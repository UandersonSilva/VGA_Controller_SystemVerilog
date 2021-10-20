`timescale 1 ns / 1 ps
//To draw one frame, run it on ModelSim until the v_sync pulse (1660 us per frame).
module vga_controller_test;

    localparam
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        PIXEL_BITS = 12,
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        CPU_ELEMENTS = 10;

        
    logic [DATA_WIDTH - 1:0] cpu_content_in, instruction_memory_in, data_memory_in;
    logic [CPU_ELEMENTS - 1:0] content_enable_out;
    logic [MEMORY_ADDRESS_WIDTH - 1:0] instruction_address_out, data_address_out;
    logic [3:0] vga_red_out, vga_green_out, vga_blue_out;
    logic clock_in, h_sync_out, v_sync_out;

    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [DATA_WIDTH - 1:0] instruction_mem0, instr_0, data_mem0, data_0;
    logic [MEMORY_ADDRESS_WIDTH - 1:0] instruction_address_0, data_address_0;
    logic instr_wr, data_wr, h_sync_ext, v_sync_ext, video_on;

    int i = 0, j = 0, k = 0;

    clock_generator GCLOCK(clock_in);

    clock_divider DCLOCK_E(
      .clock_f_in(clock_in),
      .clock_fd2_out(divided_clock)
    );

    pixel_receiver pr0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y[8:0]),
        .pixel_in({vga_red_out, vga_green_out, vga_blue_out}),
        .clock_in(!divided_clock),
        .video_on_in(video_on), 
        .v_sync_in(v_sync_ext)
    );

    vga_sync vga_sync_E0(
        .clock_in(divided_clock),
        .h_sync_out(h_sync_ext),
        .v_sync_out(v_sync_ext),
        .display_on_out(video_on),
        .pixel_x_out(pixel_x),
        .pixel_y_out(pixel_y)
    );

    tri_port_memory #(.ADDRESS_WIDTH(MEMORY_ADDRESS_WIDTH)) instr_memory0(
      .data_in(instruction_mem0),
      .write_address_in(instruction_address_0),
      .address_0_in(instruction_address_0),
      .address_1_in(instruction_address_out),
      .memory_wr_in(instr_wr),
      .read_clock_in(!clock_in),
      .write_clock_in(divided_clock),
      .data_0_out(instr_0),
      .data_1_out(instruction_memory_in)
    );

   tri_port_memory #(.ADDRESS_WIDTH(MEMORY_ADDRESS_WIDTH)) data_memory0(
      .data_in(data_mem0),
      .write_address_in(data_address_0),
      .address_0_in(data_address_0),
      .address_1_in(data_address_out),
      .memory_wr_in(data_wr),
      .read_clock_in(!clock_in),
      .write_clock_in(divided_clock),
      .data_0_out(data_0),
      .data_1_out(data_memory_in)
    );

    vga_controller vga_contr0(
        .cpu_content_in(cpu_content_in), 
        .instruction_memory_in(instruction_memory_in), 
        .data_memory_in(data_memory_in),
        .clock_in(clock_in),
        .content_enable_out(content_enable_out),
        .instruction_address_out(instruction_address_out), 
        .data_address_out(data_address_out),
        .vga_red_out(vga_red_out), 
        .vga_green_out(vga_green_out), 
        .vga_blue_out(vga_blue_out),
        .h_sync_out(h_sync_out), 
        .v_sync_out(v_sync_out)
    );

    initial
    begin
        cpu_content_in = 16'h000A;
        #3;
        for(i = 0; i < 50; i++)
        begin
            instruction_address_0 = 11'h000 + i;
            instruction_mem0 = 16'b0000000000000000 + 2*i;
            instr_wr = 1'b1;
            data_address_0 = 11'h000 + i;
            data_mem0 = 16'b0000000000000001 + 2*i;
            data_wr = 1'b1;
            #4; 
       end

       instr_wr = 1'b0;
       data_wr = 1'b0;
       #1;

        while(1) 
        begin
            if(content_enable_out == 10'b0000000001)
            begin
                cpu_content_in = 16'h0000 + j;
                #1;
            end

            else if(content_enable_out == 10'b0000000100)
            begin
                cpu_content_in = 16'h0005 + j;
                j = j + 1;
                #1;
            end

            else
            begin
                cpu_content_in = 16'h000A + j;
                #1;
            end
            #7;   
        end        
    end

endmodule