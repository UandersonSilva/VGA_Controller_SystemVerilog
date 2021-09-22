module vga_sync#(
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10
    )
    (
        input logic clock_in,
        output logic h_sync_out,
        output logic v_sync_out,
        output logic display_on_out,
        output logic [WIDTH_BITS - 1:0] pixel_x_out, 
        output logic [HEIGHT_BITS - 1:0] pixel_y_out
    ); 

    localparam 
        HORIZONTAL_DISPLAY = 640,                         
        HORIZONTAL_FRONT_PORCH = 16,
        HORIZONTAL_SYNC_PULSE = 96,
        HORIZONTAL_BACK_PORCH  = 48,
        HORIZONTAL_POSITIONS = HORIZONTAL_DISPLAY+HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE+HORIZONTAL_BACK_PORCH,
        VERTICAL_DISPLAY = 480,
        VERTICAL_FRONT_PORCH = 10,
        VERTICAL_SYNC_PULSE = 2,
        VERTICAL_BACK_PORCH  = 33,
        VERTICAL_POSITIONS = VERTICAL_DISPLAY+VERTICAL_FRONT_PORCH+VERTICAL_SYNC_PULSE+VERTICAL_BACK_PORCH;

    logic [WIDTH_BITS - 1:0] horizontal_counter = {(WIDTH_BITS){1'b1}};
    logic [HEIGHT_BITS - 1:0] vertical_counter = {(HEIGHT_BITS){1'b1}};

    always_ff@(posedge clock_in)
    begin
        if (horizontal_counter < HORIZONTAL_POSITIONS-1)
            horizontal_counter <= horizontal_counter + 1;
        else
        begin 
            horizontal_counter <= {(WIDTH_BITS){1'b0}};
            if (vertical_counter < VERTICAL_POSITIONS-1)
                vertical_counter <= vertical_counter + 1;
            else
                vertical_counter <= {(HEIGHT_BITS){1'b0}};
        end
           
    end

    always_comb 
    begin 
        if (
            horizontal_counter >= HORIZONTAL_DISPLAY+HORIZONTAL_FRONT_PORCH && 
            horizontal_counter < HORIZONTAL_DISPLAY+HORIZONTAL_FRONT_PORCH+HORIZONTAL_SYNC_PULSE
        )
            h_sync_out <= 1'b0;
        else
            h_sync_out <= 1'b1;

        if (
            vertical_counter >= VERTICAL_DISPLAY+VERTICAL_FRONT_PORCH && 
            vertical_counter < VERTICAL_DISPLAY+VERTICAL_FRONT_PORCH+VERTICAL_SYNC_PULSE
        )
            v_sync_out <= 1'b0;
        else
            v_sync_out <= 1'b1;

        if (horizontal_counter < HORIZONTAL_DISPLAY && vertical_counter < VERTICAL_DISPLAY)
            display_on_out <= 1'b1;
        else
            display_on_out <= 1'b0;
    end

    assign pixel_x_out = horizontal_counter;
    assign pixel_y_out = vertical_counter;
    
endmodule