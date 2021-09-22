`timescale 1 ns / 1 ps

module data_manager_memory_test#(
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_ELEMENTS = 10,
        MEMORY_ELEMENTS = 10
    );
    
    logic [DATA_WIDTH - 1:0] cpu_content_in, data_memory_in, instruction_memory_in;
    logic [DATA_WIDTH - 1:0] aux_data_in;
    logic v_sync_in;
    logic aux_wr_out;
    logic [DATA_WIDTH - 1:0] aux_data_out;
    logic [AUX_ADDRESS_WIDTH - 1:0] aux_raddress_out, aux_waddress_out; 
    logic [MEMORY_ADDRESS_WIDTH - 1:0] data_address_out, instruction_address_out;
    logic [CPU_ELEMENTS - 1:0] content_enable_out;

    logic [DATA_WIDTH - 1:0] aux_data_1, instruction_mem0, instr_0, data_mem0, data_0;
    logic [AUX_ADDRESS_WIDTH - 1:0]  aux_address_1;
    logic [MEMORY_ADDRESS_WIDTH - 1:0] instruction_address_0, data_address_0;
    logic instr_wr, data_wr, read_clock, write_clock;

    int i;

   clock_generator GCLOCK(read_clock);

   clock_divider DCLOCK(
      .clock_f_in(read_clock),
      .clock_fd2_out(write_clock)
   );

   tri_port_memory aux_mem0(
      .data_in(aux_data_out),
      .write_address_in(aux_waddress_out),
      .address_0_in(aux_raddress_out),
      .address_1_in(aux_address_1),
      .memory_wr_in(aux_wr_out),
      .read_clock_in(!read_clock),
      .write_clock_in(write_clock),
      .data_0_out(aux_data_in),
      .data_1_out(aux_data_1)
   );

   tri_port_memory #(.ADDRESS_WIDTH(MEMORY_ADDRESS_WIDTH)) instr_memory0(
      .data_in(instruction_mem0),
      .write_address_in(instruction_address_0),
      .address_0_in(instruction_address_0),
      .address_1_in(instruction_address_out),
      .memory_wr_in(instr_wr),
      .read_clock_in(!read_clock),
      .write_clock_in(write_clock),
      .data_0_out(instr_0),
      .data_1_out(instruction_memory_in)
   );

   tri_port_memory #(.ADDRESS_WIDTH(MEMORY_ADDRESS_WIDTH)) data_memory0(
      .data_in(data_mem0),
      .write_address_in(data_address_0),
      .address_0_in(data_address_0),
      .address_1_in(data_address_out),
      .memory_wr_in(data_wr),
      .read_clock_in(!read_clock),
      .write_clock_in(write_clock),
      .data_0_out(data_0),
      .data_1_out(data_memory_in)
   );

    data_manager manager0(
        .cpu_content_in(cpu_content_in), 
        .data_memory_in(data_memory_in), 
        .instruction_memory_in(instruction_memory_in),
        .aux_data_in(aux_data_in),
        .clock_in(!write_clock), 
        .v_sync_in(v_sync_in),
        .aux_wr_out(aux_wr_out),
        .aux_data_out(aux_data_out),
        .aux_raddress_out(aux_raddress_out),
        .aux_waddress_out(aux_waddress_out), 
        .data_address_out(data_address_out), 
        .instruction_address_out(instruction_address_out),
        .content_enable_out(content_enable_out)
    );

    initial 
   begin
       cpu_content_in = 16'b0000000000000110;
       v_sync_in = 1'b1;
       #3;
       for(i = 0; i < 10; i++)
        begin
            instruction_address_0 = 11'h000 + i;
            instruction_mem0 = 16'b0000000000000000 + 2*i;
            instr_wr = 1'b1;
            data_address_0 = 11'h00F + i;
            data_mem0 = 16'b0000000000000001 + 2*i;
            data_wr = 1'b1;
            #4; 
       end
       #1 instr_wr = 1'b0;
       data_wr = 1'b0;
       v_sync_in = 1'b0;
       cpu_content_in = 16'b0000000000000000;
       
       while(1)
        begin
            if(aux_waddress_out == 5'b00000)
            begin
                cpu_content_in = 16'b0000000000000000;
                #1;
            end
            else if(aux_waddress_out == 5'b00010)
            begin
                cpu_content_in = 16'b0000000000010011;
                #1;
            end
            else
            begin
                cpu_content_in = 16'b0000000000000110;
                #1;
            end
            #1;
       end
   end

endmodule