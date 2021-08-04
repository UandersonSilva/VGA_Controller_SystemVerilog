`timescale 1 ns / 1 ps
//To draw one frame, run it on ModelSim until the v_sync pulse (839714 ns in this case).
module character_generator_memory_test;

    localparam 
        WIDTH = 640,
        HEIGHT = 480,
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        PIXEL_BITS = 12,
        INSTRUCTION_WIDTH = 16,
        ADDRESS_WIDTH = 16;

    logic [WIDTH_BITS - 1:0] pixel_x, aux_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [PIXEL_BITS - 1:0] pixel;
    logic [10:0]char_address;
    logic [7:0]char_line;
    logic clock, video_on, h_sync, v_sync, char_bit, figure_bit, pixel_bit, bit_value;
    logic [ADDRESS_WIDTH - 1:0] address;
    logic [INSTRUCTION_WIDTH - 1:0] instruction;


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

    instruction_memory memory0(
        .address_in(address[10:0]),
        .instruction_out(instruction)
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
            pixel_bit = char_bit | figure_bit;
            pixel = {(PIXEL_BITS){pixel_bit}};
            #1;

            if((pixel_x[9:3]>=2 && pixel_x[9:3]<=17) && (pixel_y[9:4]>=3 && pixel_y[9:4]<=12))//Show INSTRUCTION ADDRESSES values
            begin
                address = {10'd0, pixel_y[9:4] - 6'd3};
                #0.001;
                bit_value = address[7'd17 - pixel_x[9:3]];
                #0.999;
            end

            else if((pixel_x[9:3]>=20 && pixel_x[9:3]<=35) && (pixel_y[9:4]>=3 && pixel_y[9:4]<=12))//Show INSTRUCTION values
            begin
                address = {10'd0, pixel_y[9:4] - 6'd3};
                #0.001;
                bit_value = instruction[7'd35 - pixel_x[9:3]];
                #0.999;
            end

            if((pixel_x[9:3]>=2 && pixel_x[9:3]<=17) && (pixel_y[9:4]>=19 && pixel_y[9:4]<=28))//Show DATA ADDRESSES values
            begin
                address = {10'd0, pixel_y[9:4] - 6'd18};
                #0.001;
                bit_value = address[7'd17 - pixel_x[9:3]];
                #0.999;
            end

            else if((pixel_x[9:3]>=20 && pixel_x[9:3]<=35) && (pixel_y[9:4]>=19 && pixel_y[9:4]<=28))//Show DATA values
            begin
                address = {10'd0, pixel_y[9:4] - 6'd18};
                #0.001;
                bit_value = instruction[7'd35 - pixel_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=357 && pixel_x<=484) && (pixel_y>=65 && pixel_y<=80))//Show PC
            begin
                address = 16'h0001;
                #0.001;
                aux_x = 10'd484 - pixel_x;
                bit_value = address[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=503 && pixel_x<=630) && (pixel_y>=65 && pixel_y<=80))//Show INSTRUCTION IN value
            begin
                address = 16'h0001;
                #0.001;
                aux_x = 10'd630 - pixel_x;
                bit_value = instruction[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=357 && pixel_x<=484) && (pixel_y>=115 && pixel_y<=130))//Show DATA ADDRESS value
            begin
                address = 16'h0007;
                #0.001;
                aux_x = 10'd484 - pixel_x;
                bit_value = address[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=503 && pixel_x<=630) && (pixel_y>=115 && pixel_y<=130))//Show DATA IN value
            begin
                address = 16'h0007;
                #0.001;
                aux_x = 10'd630 - pixel_x;
                bit_value = instruction[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=357 && pixel_x<=484) && (pixel_y>=165 && pixel_y<=180))//Show IR value
            begin
                address = 16'h0000;
                #0.001;
                aux_x = 10'd484 - pixel_x;
                bit_value = instruction[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=503 && pixel_x<=630) && (pixel_y>=165 && pixel_y<=180))//Show ACC value
            begin
                address = 16'h0005;
                #0.001;
                aux_x = 10'd630 - pixel_x;
                bit_value = address[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=357 && pixel_x<=484) && (pixel_y>=215 && pixel_y<=230))//Show ALU A value
            begin
                address = 16'h0009;
                #0.001;
                aux_x = 10'd484 - pixel_x;
                bit_value = address[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=503 && pixel_x<=630) && (pixel_y>=215 && pixel_y<=230))//Show ALU B value
            begin
                address = 16'h0006;
                #0.001;
                aux_x = 10'd630 - pixel_x;
                bit_value = address[aux_x[9:3]];
                #0.999;
            end

            else if((pixel_x>=557 && pixel_x<=565) && (pixel_y>=313 && pixel_y<=328))//Show STATUS Z value
            begin
                bit_value = 1'b1;
            end

            else
                bit_value = 1'b0;
        end
        while(v_sync != 1'b0);        
    end
endmodule