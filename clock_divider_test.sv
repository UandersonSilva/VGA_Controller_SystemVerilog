`timescale 1 ns / 10 ps

module clock_divider_test();
    logic clock_in, clock_out;

    clock_generator GCLOCK(clock_in);

    clock_divider clock_divider0(
        .clock_f_in(clock_in), 
        .clock_fd2_out(clock_out)
    );

endmodule