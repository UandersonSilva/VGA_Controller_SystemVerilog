module vga_controller#(
        parameter VIDEO_WIDTH	= 640;
        parameter VIDEO_HEIGHT	= 480;
    )
    ( 
        board_reset_in,
        board_vga_clk_in,
        board_blank_n,
        board_h_sync_out,
        board_v_sync_out,
        vga_blue_out,
        vga_green_out,
        vga_red_out
    );

    input logic board_reset_in;
    input logic board_vga_clk_in;
    output logic board_blank_n;
    output logic board_h_sync_out;
    output logic board_v_sync_out;
    output logic [3:0] vga_blue_out;
    output logic [3:0] vga_green_out;  
    output logic [3:0] vga_red_out;

    logic [18:0] address;
    wire VGA_CLK_n;
    logic [7:0] index;
    logic [23:0] bgr_data_raw;
    logic blank_n, h_sync, v_sync, reset;
    logic [23:0] bgr_data;

    assign reset = ~board_reset_in;

    vga_sync VGA_SYNC (
        .reset_in(reset),
        .vga_clk_in(board_vga_clk_in),
        .blank_n(blank_n),
        .h_sync_out(h_sync),
        .v_sync_out(v_sync)
    );

    always_ff@(posedge board_vga_clk_in, negedge board_reset_in)
    begin
    if (!board_reset_in)
        address<=19'd0;
    else if (blank_n==1'b1)
        address<=address+1;
        else
            address<=19'd0;
    end

    always_ff@(posedge board_vga_clk_in)
    begin
    if (~board_reset_in)
    begin
        bgr_data<=24'h000000;
    end
        else
        begin
        if (0<address && address <= VIDEO_WIDTH/3)
            bgr_data <= {8'hff, 8'h00, 8'h00}; // blue
        else if (address > VIDEO_WIDTH/3 && address <= VIDEO_WIDTH*2/3)
            bgr_data <= {8'h00,8'hff, 8'h00};  // green
        else if(address > VIDEO_WIDTH*2/3 && address <=VIDEO_WIDTH)
            bgr_data <= {8'h00, 8'h00, 8'hff}; // red
        else bgr_data <= 24'h0000; 
    end

    assign vga_blue_out = bgr_data[23:20];
    assign vga_green_out = bgr_data[15:12]; 
    assign vga_red_out = bgr_data[7:4];

    logic m_h_sync, m_v_sync, m_blank_n;
    
    always_ff@(posedge board_vga_clk_in)
    begin
        m_h_sync <= h_sync;
        m_v_sync <= v_sync;
        m_blank_n <= blank_n;
        board_h_sync_out <=m_h_sync;
        board_v_sync_out <= m_v_sync;
        board_blank_n <=m_blank_n;
    end


    ////for signaltap ii/////////////
    wire [18:0] H_Cont/*synthesis noprune*/;
    always@(posedge board_vga_clk_in, negedge board_reset_in)
    begin
    if (!board_reset_in)
        H_Cont<=19'd0;
    else if (m_h_sync == 1'b1)
        H_Cont<=H_Cont+1;
        else
            H_Cont<=19'd0;
    end
endmodule