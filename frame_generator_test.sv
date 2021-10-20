`timescale 1 ns / 1 ps
//To draw one frame, run it on ModelSim until the v_sync pulse (840 us in this case).
module frame_generator_test;

    localparam 
        WIDTH = 640,
        HEIGHT = 480,
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_ELEMENTS = 10,
        MEMORY_ELEMENTS = 10;

    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [10:0]char_address;
    logic [7:0]char_line;
    logic clock, video_on, v_sync, char_bit, figure_bit, pixel_bit, bit_value;
    logic [DATA_WIDTH - 1:0] aux_data;
    logic [AUX_ADDRESS_WIDTH - 1:0] aux_raddress;
    logic [3:0] pixel_red, pixel_green, pixel_blue;


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
        .pixel_in({pixel_red, pixel_green, pixel_blue}),
        .clock_in(!clock),
        .video_on_in(video_on), 
        .v_sync_in(v_sync)
    );

    frame_generator frame_gen0(
        .pixel_x_in(pixel_x), 
        .pixel_y_in(pixel_y),
        .figure_bit_in(figure_bit), 
        .char_bit_in(char_bit),
        .aux_data_in(aux_data),
        .aux_raddress_out(aux_raddress),
        .bit_value_out(bit_value),
        .pixel_red_out(pixel_red),
        .pixel_green_out(pixel_green),  
        .pixel_blue_out(pixel_blue)
    );


    initial
    begin
        while(1)
        begin
            #0.1;
            if(aux_raddress == 5'h00)
            begin
                aux_data = 16'h0000; //16'h0003
                #0.9;
            end
            
            else if(aux_raddress == 5'h02)
            begin
                aux_data = 16'h07FF; //16'h000A
                #0.9;
            end

            else
            begin
                aux_data = {11'b0, aux_raddress};
                #0.9;
            end
            
            #1;
        end
    end


endmodule