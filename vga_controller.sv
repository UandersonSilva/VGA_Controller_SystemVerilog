module vga_controller#(
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_ELEMENTS = 10
    )
    (
        input logic [DATA_WIDTH - 1:0] cpu_content_in, instruction_memory_in, data_memory_in,
        input logic clock_in,
        output logic [CPU_ELEMENTS - 1:0] content_enable_out,
        output logic [MEMORY_ADDRESS_WIDTH - 1:0] instruction_address_out, data_address_out,
        output logic [3:0] vga_red_out, vga_green_out, vga_blue_out,
        output logic h_sync_out, v_sync_out
    );

    logic divided_clock, h_sync, v_sync, video_on, figure_bit, char_bit, bit_value, aux_wr;
    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [10:0] char_address; 
    logic [7:0] char_line;
    logic [AUX_ADDRESS_WIDTH - 1:0] aux_waddress, aux_raddress_0, aux_raddress_1;
    logic [DATA_WIDTH - 1:0] aux_write_data, aux_data_0, aux_data_1;
    logic [3:0] pixel_red, pixel_green, pixel_blue;


    clock_divider DCLOCK(
      .clock_f_in(clock_in),
      .clock_fd2_out(divided_clock)
    );

    vga_sync vga_sync0 (
        .clock_in(divided_clock),
        .h_sync_out(h_sync),
        .v_sync_out(v_sync),
        .display_on_out(video_on),
        .pixel_x_out(pixel_x),
        .pixel_y_out(pixel_y)
    );

    font_rom font_rom0(   
        .addr_in(char_address),  
        .data_out(char_line)
    );

    character_generator char_gen0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y),
        .char_line_in(char_line),
        .bit_value_in(bit_value),
        .char_address_out(char_address),
        .char_bit_out(char_bit)
    );

    figure_generator fig_gen0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y),
        .pixel_bit_out(figure_bit)
    );

    tri_port_memory aux_mem0(
      .data_in(aux_write_data),
      .write_address_in(aux_waddress),
      .address_0_in(aux_raddress_0),
      .address_1_in(aux_raddress_1),
      .memory_wr_in(aux_wr),
      .read_clock_in(!clock_in),
      .write_clock_in(divided_clock),
      .data_0_out(aux_data_0),
      .data_1_out(aux_data_1)
    );

    data_manager manager0(
        .cpu_content_in(cpu_content_in),  
        .instruction_memory_in(instruction_memory_in),
        .data_memory_in(data_memory_in),
        .aux_data_in(aux_data_0),
        .clock_in(!divided_clock), 
        .v_sync_in(v_sync),
        .aux_wr_out(aux_wr),
        .aux_data_out(aux_write_data),
        .aux_raddress_out(aux_raddress_0),
        .aux_waddress_out(aux_waddress),  
        .content_enable_out(content_enable_out),
        .instruction_address_out(instruction_address_out),
        .data_address_out(data_address_out)
    );

    frame_generator frame_gen0(
        .pixel_x_in(pixel_x), 
        .pixel_y_in(pixel_y),
        .figure_bit_in(figure_bit), 
        .char_bit_in(char_bit),
        .aux_data_in(aux_data_1),
        .aux_raddress_out(aux_raddress_1),
        .bit_value_out(bit_value),
        .pixel_red_out(pixel_red),
        .pixel_green_out(pixel_green),  
        .pixel_blue_out(pixel_blue)
    );

    always_comb 
    begin
        if(video_on)
        begin
            vga_red_out <= pixel_red;
            vga_green_out <= pixel_green;
            vga_blue_out <= pixel_blue;
        end

        else
        begin
            vga_red_out <= 4'b0000;
            vga_green_out <= 4'b0000;
            vga_blue_out <= 4'b0000;
        end        
    end

    assign h_sync_out = h_sync;
    assign v_sync_out = v_sync;
    
endmodule