`timescale 1 ns / 10 ps
//To draw one frame, run it on ModelSim until the v_sync pulse (839714 ns in this case).
module figure_generator_test;

    localparam 
        WIDTH = 640,
        HEIGHT = 480,
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        PIXEL_BITS = 12;

    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [PIXEL_BITS - 1:0] pixel;
    logic clock, video_on, v_sync, pixel_bit;


    clock_generator GCLOCK(clock);

    figure_generator fig_gen0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y),
        .pixel_bit_out(pixel_bit)
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
            pixel = {(PIXEL_BITS){pixel_bit}};
            #1;
        end
        while(v_sync != 1'b0);        
    end
endmodule