`timescale 1 ns / 10 ps

module vga_sync_test();

    logic reset, vga_clk;
    //logic blank_n;
    logic h_sync, v_sync;
    logic [10:0] horizontal_position;
    logic [9:0] vertical_position;

clock_generator GCLOCK(vga_clk);

vga_sync VGA_SYNC (
        .reset_in(reset),
        .vga_clk_in(vga_clk),
        //.blank_n(blank_n),
        .h_sync_out(h_sync),
        .v_sync_out(v_sync),
        .horizontal_position_out(horizontal_position),
        .vertical_position_out(vertical_position)
    );

    initial
    begin
        reset = 1'b1;
        #2 reset = 1'b0;
    end

endmodule