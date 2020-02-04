`timescale 1 ns / 10 ps

module vga_sync_test();

    logic reset, vga_clk;
    logic h_sync, v_sync, display_on;
    logic [10:0] pixel_x;
    logic [9:0] pixel_y;

clock_generator GCLOCK(vga_clk);

vga_sync VGA_SYNC (
        .reset_in(reset),
        .vga_clk_in(vga_clk),
        .h_sync_out(h_sync),
        .v_sync_out(v_sync),
        .display_on_out(display_on),
        .pixel_x_out(pixel_x),
        .pixel_y_out(pixel_y)
    );

    initial
    begin
        reset = 1'b1;
        #2 reset = 1'b0;
    end

endmodule