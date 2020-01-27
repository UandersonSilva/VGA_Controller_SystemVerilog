module vga_sync#(
        parameter HORIZONTAL_LINE  = 800,                          
        parameter HORIZONTAL_BACK_PORCH  = 144,
        parameter HORIZONTAL_FRONT_PORCH = 16,
        parameter VERTICAL_LINE  = 525,
        parameter VERTICAL_BACK_PORCH  = 34,
        parameter VERTICAL_FRONT_PORCH = 11,
        parameter HORIZONTAL_SYNC_CYCLE = 96,
        parameter VERTICAL_SYNC_CYCLE = 2,
        parameter H_BLANK = HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_CYCLE
    )
    (
        reset_in,
        vga_clk_in,
        blank_n,
        h_sync_out,
        v_sync_out
    );

    input logic reset_in;
    input logic vga_clk_in;
    output logic blank_n;
    output logic h_sync_out;
    output logic v_sync_out;

    logic [10:0] horizontal_count;
    logic [9:0]  vertical_count;

    logic cHD, cVD, cDEN, horizontal_valid, vertical_valid;

    always_ff@(negedge vga_clk_in,posedge reset_in)
    begin
        if (reset_in)
        begin
            horizontal_count <= 11'd0;
            vertical_count <= 10'd0;
        end
        else
            begin
            if (horizontal_count == HORIZONTAL_LINE-1)
            begin 
                horizontal_count <= 11'd0;
                if (vertical_count == VERTICAL_LINE-1)
                    vertical_count <= 10'd0;
                else
                    vertical_count <= vertical_count+1;
            end
            else
                horizontal_count <= horizontal_count+1;
        end
    end

    assign cHD = (horizontal_count<HORIZONTAL_SYNC_CYCLE) ? 1'b0: 1'b1;
    assign cVD = (vertical_count<VERTICAL_SYNC_CYCLE) ? 1'b0: 1'b1; 

    assign horizontal_valid = (horizontal_count<(HORIZONTAL_LINE-HORIZONTAL_FRONT_PORCH) && horizontal_count>=HORIZONTAL_BACK_PORCH) ? 1'b1: 1'b0;
    assign vertical_valid = (vertical_count<(VERTICAL_LINE-VERTICAL_FRONT_PORCH) && vertical_count>=VERTICAL_BACK_PORCH) ? 1'b1: 1'b0; 

    assign cDEN = horizontal_valid && vertical_valid;

    always_ff@(negedge vga_clk_in)
    begin
        h_sync_out <= cHD;
        v_sync_out <= cVD;
        blank_n <= cDEN;
    end
endmodule