`timescale 1 ns / 1 ps

module data_manager_test#(
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_CONTENT_ELEMENTS = 10,
        MEMORY_ELEMENTS = 10
    );
    
    logic [DATA_WIDTH - 1:0] cpu_content_in, data_memory_in, instruction_memory_in;
    logic [DATA_WIDTH - 1:0] aux_data_in;
    logic clock_in, v_sync_in;
    logic aux_wr_out;
    logic [DATA_WIDTH - 1:0] aux_data_out;
    logic [AUX_ADDRESS_WIDTH - 1:0] aux_raddress_out, aux_waddress_out; 
    logic [MEMORY_ADDRESS_WIDTH - 1:0] data_address_out, instruction_address_out;
    logic [CPU_CONTENT_ELEMENTS - 1:0] content_enable_out;

    clock_generator GCLOCK(clock_in);

    data_manager manager0(
        .cpu_content_in(cpu_content_in), 
        .data_memory_in(data_memory_in), 
        .instruction_memory_in(instruction_memory_in),
        .aux_data_in(aux_data_in),
        .clock_in(clock_in), 
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
       cpu_content_in = 16'b0000000110000000;
       instruction_memory_in = 16'b0000000000011001;
       data_memory_in = 16'b1110000000000101;
       //aux_data_in = 16'b0000000000000001;
       aux_data_in = 16'b0000000000000000;
       v_sync_in = 1'b1;
       #2 v_sync_in = 1'b0;
       while(1)
        begin
            if(aux_raddress_out == 5'b00000)
            begin
                aux_data_in = 16'b0000000000000001;
                #0.001;
            end
            else if(aux_raddress_out == 5'b00010)
            begin
                aux_data_in = 16'b0000011111111111;
                #0.001;
            end
            else
            begin
                aux_data_in = 16'b0000000000000000;
                #0.001;
            end
            #0.999;   
       end
   end

endmodule