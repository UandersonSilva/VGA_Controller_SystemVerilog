module vga_sync#(
        parameter HORIZONTAL_DISPLAY = 640,                          
        parameter HORIZONTAL_BACK_PORCH  = 48,
        parameter HORIZONTAL_FRONT_PORCH = 16,
        parameter HORIZONTAL_SYNC_PULSE = 96,
        parameter HORIZONTAL_LINE  = HORIZONTAL_DISPLAY+HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE+HORIZONTAL_BACK_PORCH,
        parameter VERTICAL_DISPLAY = 480,
        parameter VERTICAL_BACK_PORCH  = 33,
        parameter VERTICAL_FRONT_PORCH = 10,
        parameter VERTICAL_SYNC_PULSE = 2,
        parameter VERTICAL_LINE  = VERTICAL_DISPLAY+VERTICAL_FRONT_PORCH+VERTICAL_SYNC_PULSE+VERTICAL_BACK_PORCH,
        parameter H_BLANK = HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE
    )
    (
        input logic reset_in,
        input logic vga_clk_in,
        //output logic blank_n,
        output logic h_sync_out,
        output logic v_sync_out,
        output logic [10:0] horizontal_position_out,
        output logic [9:0] vertical_position_out
    ); 

    logic [10:0] horizontal_count;
    logic [9:0]  vertical_count;

    logic h_sync_pulse_signal, v_sync_pulse_signal; /*cDEN, horizontal_valid, vertical_valid*/;

    always_ff@(negedge vga_clk_in, posedge reset_in)
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

    assign h_sync_pulse_signal = (horizontal_count>HORIZONTAL_DISPLAY+HORIZONTAL_FRONT_PORCH && horizontal_count <= HORIZONTAL_DISPLAY+HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE) ? 1'b0: 1'b1;
    assign v_sync_pulse_signal = (vertical_count>VERTICAL_DISPLAY+VERTICAL_FRONT_PORCH && vertical_count<=VERTICAL_DISPLAY+VERTICAL_FRONT_PORCH+VERTICAL_SYNC_PULSE) ? 1'b0: 1'b1; 

    //assign horizontal_valid = (horizontal_count<(HORIZONTAL_LINE-HORIZONTAL_FRONT_PORCH) && horizontal_count>=HORIZONTAL_BACK_PORCH) ? 1'b1: 1'b0;
    //assign vertical_valid = (vertical_count<(VERTICAL_LINE-VERTICAL_FRONT_PORCH) && vertical_count>=VERTICAL_BACK_PORCH) ? 1'b1: 1'b0; 

    //assign cDEN = horizontal_valid && vertical_valid;

    always_ff@(negedge vga_clk_in)
    begin
        h_sync_out <= h_sync_pulse_signal;
        v_sync_out <= v_sync_pulse_signal;
        horizontal_position_out <= horizontal_count;
        vertical_position_out <= vertical_count;
      //  blank_n <= cDEN;
    end
endmodule