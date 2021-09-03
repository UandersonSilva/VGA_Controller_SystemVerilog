module data_manager#(
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_CONTENT_ELEMENTS = 10,
        MEMORY_ELEMENTS = 10
    )
    (
        input logic [DATA_WIDTH - 1:0] cpu_content_in, data_memory_in, instruction_memory_in,
        input logic [DATA_WIDTH - 1:0] aux_data_in,
        input logic clock_in, sync_pulse_in,
        output logic aux_wr_out,
        output logic [DATA_WIDTH - 1:0] aux_data_out,
        output logic [AUX_ADDRESS_WIDTH - 1:0] aux_raddress_out, aux_waddress_out, 
        output logic [MEMORY_ADDRESS_WIDTH - 1:0] data_address_out, instruction_address_out,
        output logic [CPU_CONTENT_ELEMENTS - 1:0] content_enable_out
    );

    localparam 
        _DEFINE_ADDRESSES = 2'b00,
        _READ = 2'b01,
        _INCREMENT = 2'b10,
        _GO_FORWARD = 2'b11,
        _LAST_ADDRESS = 2**MEMORY_ADDRESS_WIDTH - 1;

    logic [1:0] state = _DEFINE_ADDRESSES;
    logic read_enable = 1'b0, read_finished = 1'b1, read_cpu = 1'b0, read_instruction = 1'b0, read_data = 1'b0;
    logic [CPU_CONTENT_ELEMENTS - 1:0] content_enable = {(CPU_CONTENT_ELEMENTS){1'b0}};
    logic [MEMORY_ADDRESS_WIDTH - 1:0] memory_address/*, final_address*/;
    logic [4:0] read_counter;

    initial 
    begin
        aux_wr_out = 1'b0;
        aux_data_out = {DATA_WIDTH{1'b0}};
        aux_raddress_out = {AUX_ADDRESS_WIDTH{1'b0}};
        aux_waddress_out = {AUX_ADDRESS_WIDTH{1'b0}};
        instruction_address_out = {MEMORY_ADDRESS_WIDTH{1'b0}};
        data_address_out = {MEMORY_ADDRESS_WIDTH{1'b0}};
        content_enable_out = {CPU_CONTENT_ELEMENTS{1'b0}};        
    end

    always_ff @(negedge sync_pulse_in or posedge read_finished)
    begin
        read_enable <= !read_enable;            
    end 
   

    always_ff @(posedge clock_in) 
    begin 
        if(read_enable & read_finished)
        begin
            state <= _READ;
            read_cpu <= 1'b1;
        end

        else
        begin
            if(read_cpu)
            begin
                case(state)
                    _READ:
                    begin
                        state <= _INCREMENT;
                    end

                    _INCREMENT:
                    begin
                        if(read_counter < CPU_CONTENT_ELEMENTS)
                            state <= _READ;
                        else
                            state <= _GO_FORWARD;
                    end

                    _GO_FORWARD:
                    begin
                        state <= _DEFINE_ADDRESSES;
                        read_cpu <= 1'b0;
                        read_instruction <= 1'b1;
                    end

                    default:
                    begin
                        state <= _DEFINE_ADDRESSES;
                    end
                endcase
            end

            else if(read_instruction | read_data)
            begin
                case(state)
                    _DEFINE_ADDRESSES:
                    begin
                        state <= _READ;
                    end

                    _READ:
                    begin
                        state <= _INCREMENT;
                    end

                    _INCREMENT:
                    begin
                        if(read_counter < MEMORY_ELEMENTS)
                            state <= _READ;
                        else
                            state <= _GO_FORWARD;
                    end

                    _GO_FORWARD:
                    begin
                        if(read_instruction)
                        begin
                            read_instruction <= 1'b0;
                            read_data <= 1'b1;
                        end
                        else if (read_data)
                            read_data <= 1'b0;

                        state <= _DEFINE_ADDRESSES;
                    end

                    default:
                    begin
                        state <= _DEFINE_ADDRESSES;
                    end
                endcase
            end

            else 
                state <= _DEFINE_ADDRESSES;
        end       
    end

    always @* 
    begin
        if(read_cpu)
            aux_data_out <= cpu_content_in;

        else if(read_instruction)
        begin
            instruction_address_out <= memory_address;
            aux_data_out <= instruction_memory_in;
        end

        else if(read_data)
        begin
            data_address_out <= memory_address;
            aux_data_out <= data_memory_in;
        end

        else
        begin
            aux_data_out <= {DATA_WIDTH{1'b0}};
            instruction_address_out <= {MEMORY_ADDRESS_WIDTH{1'b0}};
            data_address_out <= {MEMORY_ADDRESS_WIDTH{1'b0}};
        end        
    end

	always @(read_enable, state)
    begin
        if(read_enable & read_finished)
        begin
            content_enable[0] <= 1'b1;
            read_counter <= 0;
        end

        if(read_cpu)
        begin
            case(state)
                _READ:
                begin
                    read_finished <= 1'b0;
                    content_enable_out <= content_enable;
                    aux_wr_out <= 1'b1;
                    read_counter <= read_counter + 1'b1;
                end

                _INCREMENT:
                begin
                    aux_wr_out <= 1'b0;
                    aux_waddress_out <= aux_waddress_out + 1'b1;
                    content_enable <= content_enable << 1;
                end

                _GO_FORWARD:
                begin
                    read_counter <= 1'b0;
                    aux_raddress_out <= 5'h00;
                    content_enable <= {CPU_CONTENT_ELEMENTS{1'b0}};
                    content_enable_out <= {CPU_CONTENT_ELEMENTS{1'b0}};
                end
            endcase             
        end

        else if(read_instruction | read_data)
        begin
            case(state)
                _DEFINE_ADDRESSES:
                begin
                    if(aux_data_in < 5)
                    begin
                        memory_address <= {MEMORY_ADDRESS_WIDTH{1'b0}};
                    end

                    else if(aux_data_in > (_LAST_ADDRESS - 5))
                    begin
                        memory_address <= _LAST_ADDRESS - 11'h009;
                    end

                    else
                    begin
                        memory_address <= aux_data_in - 11'h004;
                    end

                    if(read_instruction)
                        aux_waddress_out <= CPU_CONTENT_ELEMENTS; //In this case, 5'h00a
                    else
                        aux_waddress_out <= CPU_CONTENT_ELEMENTS + MEMORY_ELEMENTS;//In this case, 5'h014                  
                end

                _READ:
                begin
                    aux_wr_out <= 1'b1;
                    read_counter <= read_counter + 1'b1;;
                end

                _INCREMENT:
                begin
                    aux_wr_out <= 1'b0;
                    aux_waddress_out <= aux_waddress_out + 1'b1;
                    memory_address <= memory_address + 1'b1;
                end

                _GO_FORWARD:
                begin
                    read_counter <= 1'b0;

                    if(read_instruction)
                    begin
                        aux_raddress_out <= 5'h02;
                    end

                    else if (read_data)
                    begin
                        read_finished <= 1'b1;
                    end
                end
            endcase             
        end

        else
        begin
            aux_wr_out <= 1'b0;
            aux_raddress_out <= {AUX_ADDRESS_WIDTH{1'b0}};
            aux_waddress_out <= {AUX_ADDRESS_WIDTH{1'b0}};
            content_enable_out <= {CPU_CONTENT_ELEMENTS{1'b0}};
        end                
    end   
endmodule