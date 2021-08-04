`timescale 1 ns / 10 ps

module vga_sync_test();

    localparam
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10;

    logic clock;
    logic h_sync, v_sync, display_on;
    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;

    clock_generator GCLOCK(clock);

    vga_sync VGA_SYNC (
        .clock_in(clock),
        .h_sync_out(h_sync),
        .v_sync_out(v_sync),
        .display_on_out(display_on),
        .pixel_x_out(pixel_x),
        .pixel_y_out(pixel_y)
    );

endmodule