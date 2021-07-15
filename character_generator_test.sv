`timescale 1 ns / 10 ps
//To draw one frame, run it on ModelSim until the v_sync pulse (839714 ns in this case).
module character_generator_test;

    localparam 
        WIDTH = 640,
        HEIGHT = 480,
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        PIXEL_BITS = 12;

    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [PIXEL_BITS - 1:0] pixel;
    logic [10:0]char_address;
    logic [7:0]char_line;
    logic clock, video_on, v_sync, char_bit, figure_bit, pixel_bit, bit_value;


    clock_generator GCLOCK(clock);

    character_generator char_gen0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y),
        .char_line_in(char_line),
        .bit_value_in(bit_value),
        .char_address_out(char_address),
        .char_bit_out(char_bit)
    );

     font_rom font_rom0(   
        .addr_in(char_address),  
        .data_out(char_line)
    );

    figure_generator fig_gen0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y),
        .pixel_bit_out(figure_bit)
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
            bit_value = 1'b0;
            pixel_bit = char_bit | figure_bit;
            pixel = {(PIXEL_BITS){pixel_bit}};
            #1;
        end
        while(v_sync != 1'b0);        
    end
endmodule