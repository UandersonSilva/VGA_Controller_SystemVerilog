module tri_port_memory#(
        DATA_WIDTH = 16,
        ADDRESS_WIDTH = 5
    )
    (
        input memory_wr_in, write_clock_in, read_clock_in,
        input logic [ADDRESS_WIDTH - 1:0] address_0_in, address_1_in, write_address_in,
        input logic [DATA_WIDTH - 1:0] data_in,
        output logic [DATA_WIDTH - 1:0] data_0_out, data_1_out
    );

    logic [DATA_WIDTH - 1:0] memory [2**ADDRESS_WIDTH - 1:0];

    always_ff @(posedge write_clock_in) 
    begin
        if(memory_wr_in)
            memory[write_address_in] <= data_in;
    end
	 
	always_ff @(posedge read_clock_in) 
    begin
        data_0_out <= memory[address_0_in];
		data_1_out <= memory[address_1_in];
    end	 

endmodule