module clock_divider(
        input logic clock_f_in,
        output logic clock_fd2_out = 1'b0
    );

    always_ff @(posedge clock_f_in) 
    begin
        clock_fd2_out <= !clock_fd2_out;
    end
endmodule