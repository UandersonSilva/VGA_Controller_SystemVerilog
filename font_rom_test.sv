`timescale 1 ns / 10 ps
//To draw one frame, run it on ModelSim until the v_sync pulse (839714 ns in this case).
module font_rom_test;

    localparam 
        WIDTH = 640,
        HEIGHT = 480,
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        PIXEL_BITS = 12;

    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [PIXEL_BITS - 1:0] pixel;
    logic clock, video_on, v_sync;
    logic [3:0]char_line = 0;
    logic [7:0]char_code = 8'h00, char_register = 8'h00;
    logic [10:0]font_address = 0;
    logic [0:7]data_out;
    int pixel_counter = 0;

    clock_generator GCLOCK(clock);

    font_rom font_rom0(   
        .addr_in(font_address),  
        .data_out(data_out)
    );

    vga_sync vga_sync0 (
        .clock_in(clock),
        .h_sync_out(h_sync),
        .v_sync_out(v_sync),
        .display_on_out(video_on),
        .pixel_x_out(pixel_x),
        .pixel_y_out(pixel_y)
    );

    pixel_receiver pr0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y[8:0]),
        .pixel_in(pixel),
        .clock_in(!clock),
        .video_on_in(video_on), 
        .v_sync_in(v_sync)
    );

    initial 
    begin
        do
        begin
            font_address = {char_code[6:0], char_line};
            pixel = {(PIXEL_BITS){data_out[pixel_counter]}};
            #1;

            if(!clock)
            begin
            if((pixel_x < WIDTH) && (pixel_y < HEIGHT))
            begin
                if(pixel_counter < 7)
                begin
                    //pixel = {(PIXEL_BITS){data_out[pixel_counter]}};
                    //#1;
                    pixel_counter += 1;
                end
                else
                begin
                    pixel_counter = 0;
                    if(char_code < 8'h80)
                        char_code += 1;
                    /*else if(pixel_x == 0)
                    begin
                        char_register = 8'h00;
                        char_code = 8'h00;
                    end*/
                end
            end

            else if (pixel_x == WIDTH)
            begin
                if(char_line < 15)
                begin
                    char_code = char_register;
                    pixel_counter = 0;
                    char_line += 1;
                    //#1;
                end
                else
                begin
                    char_register = char_code;
                    pixel_counter = 0;
                    char_line = 0;
                    //#1;
                end
            end

            else
            begin
                pixel = {(PIXEL_BITS){1'b0}};
                //#1;
            end
            end
        end
        while(v_sync != 1'b0);        
    end

endmodule