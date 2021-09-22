`timescale 1 ns / 1 ps

module tri_port_memory_test#(
      DATA_WIDTH = 16,
      ADDRESS_WIDTH = 5
   );

   logic [DATA_WIDTH - 1:0] data_in, data_0, data_1;
   logic [ADDRESS_WIDTH - 1:0] write_address, address_0, address_1;
   logic memory_wr, read_clock, write_clock;

   clock_generator GCLOCK(read_clock);

   clock_divider DCLOCK(
      .clock_f_in(read_clock),
      .clock_fd2_out(write_clock)
   );

   tri_port_memory memory0(
      .data_in(data_in),
      .write_address_in(write_address),
      .address_0_in(address_0),
      .address_1_in(address_1),
      .memory_wr_in(memory_wr),
      .read_clock_in(read_clock),
      .write_clock_in(write_clock),
      .data_0_out(data_0),
      .data_1_out(data_1)
   );

   initial 
   begin
      data_in = 16'b0000000000000001;
      write_address = 5'b00000;
      address_0 =  5'b00000;
      address_1 = 5'b11111;
      memory_wr = 1'b0;
      #3 memory_wr = 1'b1;
      #2 memory_wr = 1'b0;
      #2 data_in = 16'b0000000000000101;
         write_address = 5'b11111;
       memory_wr = 1'b1;
      #2 memory_wr = 1'b0;
      #2 data_in = 16'b1111111111111111;
         write_address = 5'b01111;
         address_0 =  5'b01111;
       memory_wr = 1'b1;
      #2 memory_wr = 1'b0;
      #2 data_in = 16'b1111111111111011;
         write_address = 5'b10000;
         address_1 = 5'b10000;
       memory_wr = 1'b1;
      #2 memory_wr = 1'b0;
      #4 address_0 = 5'b11111;
         address_1 = 5'b00000;
      #4 address_0 = 5'b10000;
         address_1 = 5'b01111;
   end

endmodule