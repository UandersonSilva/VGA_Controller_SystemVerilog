module data_manager#(
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_ELEMENTS = 10,
        MEMORY_ELEMENTS = 10
    )
    (
        input logic [DATA_WIDTH - 1:0] cpu_content_in, data_memory_in, instruction_memory_in,
        input logic [DATA_WIDTH - 1:0] aux_data_in,
        input logic clock_in, v_sync_in,
        output logic aux_wr_out,
        output logic [DATA_WIDTH - 1:0] aux_data_out,
        output logic [AUX_ADDRESS_WIDTH - 1:0] aux_raddress_out, aux_waddress_out, 
        output logic [MEMORY_ADDRESS_WIDTH - 1:0] data_address_out, instruction_address_out,
        output logic [CPU_ELEMENTS - 1:0] content_enable_out
    );

    localparam 
        _DEFINE_ADDRESSES = 2'b00,
        _READ = 2'b01,
        _INCREMENT = 2'b10,
        _GO_FORWARD = 2'b11,
        _IDLE = 2'b00,
        _READ_CPU = 2'b01,
        _READ_INSTRUCTION = 2'b10,
        _READ_DATA = 2'b11,
        _FINAL_ADDRESS = 2**MEMORY_ADDRESS_WIDTH - 1;

    logic [1:0] state = _DEFINE_ADDRESSES;
    logic [1:0] phase = _IDLE;
    logic read_enable = 1'b0, read_finished = 1'b1;
    logic [CPU_ELEMENTS - 1:0] content_enable = {(CPU_ELEMENTS){1'b0}};
    logic [MEMORY_ADDRESS_WIDTH - 1:0] memory_address;
    logic [4:0] read_counter;

    initial 
    begin
        aux_wr_out = 1'b0;
        aux_data_out = {DATA_WIDTH{1'b0}};
        aux_raddress_out = {AUX_ADDRESS_WIDTH{1'b0}};
        aux_waddress_out = {AUX_ADDRESS_WIDTH{1'b0}};
        instruction_address_out = {MEMORY_ADDRESS_WIDTH{1'b0}};
        data_address_out = {MEMORY_ADDRESS_WIDTH{1'b0}};
        content_enable_out = {CPU_ELEMENTS{1'b0}};        
    end

    /*Read trigger*/
    always_ff @(negedge v_sync_in or posedge read_finished)
    begin
        read_enable <= !read_enable;            
    end 
   
    always_ff @(posedge clock_in) 
    begin 
        if(read_enable & read_finished)/*Start*/
        begin
            state <= _READ;
            phase <= _READ_CPU;
        end

        else /*Phase and state transitions*/
        begin
            if(phase == _READ_CPU)
            begin
                case(state)
                    _READ:
                    begin
                        state <= _INCREMENT;
                    end

                    _INCREMENT:
                    begin
                        if(read_counter < CPU_ELEMENTS)
                            state <= _READ;
                        else
                            state <= _GO_FORWARD;
                    end

                    _GO_FORWARD:
                    begin
                        state <= _DEFINE_ADDRESSES;
                        phase <= _READ_INSTRUCTION;
                    end

                    default:
                    begin
                        state <= _DEFINE_ADDRESSES;
                    end
                endcase
            end

            else if((phase == _READ_INSTRUCTION) || (phase == _READ_DATA))
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
                        if(phase == _READ_INSTRUCTION)
                        begin
                            phase <= _READ_DATA;
                        end
                        else if (phase == _READ_DATA)
                            phase <= _IDLE;

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

    /*aux_data_out and memory addresses update*/
    always @* 
    begin
        if(phase == _READ_CPU)
            aux_data_out <= cpu_content_in;

        else if(phase == _READ_INSTRUCTION)
        begin
            instruction_address_out <= memory_address;
            aux_data_out <= instruction_memory_in;
        end

        else if(phase == _READ_DATA)
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

	/*State actions, according to the current phase*/
    always @(read_enable, state)
    begin
        if(read_enable & read_finished)
        begin
            content_enable[0] <= 1'b1;
            read_counter <= 0;
        end

        if(phase == _READ_CPU)
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
                    content_enable <= {CPU_ELEMENTS{1'b0}};
                    content_enable_out <= {CPU_ELEMENTS{1'b0}};
                end
            endcase             
        end

        else if((phase == _READ_INSTRUCTION) || (phase == _READ_DATA))
        begin
            case(state)
                _DEFINE_ADDRESSES:
                begin
                    if(aux_data_in < 5)
                    begin/*0x000 to 0x009*/
                        memory_address <= {MEMORY_ADDRESS_WIDTH{1'b0}};
                    end

                    else if(aux_data_in > (_FINAL_ADDRESS - 5))
                    begin/*LAST_ADDRESS-11'h009 to LAST_ADDRESS*/
                        memory_address <= _FINAL_ADDRESS - 11'h009;
                    end

                    else
                    begin/*aux_data_in-11'h004 to aux_data_in+11'h005*/
                        memory_address <= aux_data_in - 11'h004;
                    end

                    if(phase == _READ_INSTRUCTION)
                        aux_waddress_out <= CPU_ELEMENTS; //In this case, 5'h00a
                    else
                        aux_waddress_out <= CPU_ELEMENTS + MEMORY_ELEMENTS;//In this case, 5'h014                  
                end

                _READ:
                begin
                    aux_wr_out <= 1'b1;
                    read_counter <= read_counter + 1'b1;
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

                    if(phase == _READ_INSTRUCTION)
                    begin
                        aux_raddress_out <= 5'h02;
                    end

                    else
                    begin/*Final trigger*/
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
            content_enable_out <= {CPU_ELEMENTS{1'b0}};
        end                
    end   
endmodule