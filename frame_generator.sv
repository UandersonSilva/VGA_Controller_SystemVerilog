module frame_generator#(
        WIDTH_BITS = 10,
        HEIGHT_BITS = 10,
        PIXEL_BITS = 12,
        DATA_WIDTH = 16,
        MEMORY_ADDRESS_WIDTH = 11,
        AUX_ADDRESS_WIDTH = 5,
        CPU_ELEMENTS = 10,
        MEMORY_ELEMENTS = 10
    )
    ( 
        input logic [WIDTH_BITS - 1:0] pixel_x_in, 
        input logic [HEIGHT_BITS - 1:0] pixel_y_in,
        input logic figure_bit_in, char_bit_in,
        input logic [DATA_WIDTH - 1:0] aux_data_in,
        output logic [AUX_ADDRESS_WIDTH - 1:0] aux_raddress_out,
        output logic bit_value_out,
        output logic [3:0] pixel_red_out,
        output logic [3:0] pixel_green_out,  
        output logic [3:0] pixel_blue_out
    );

    localparam _FINAL_ADDRESS = 2**MEMORY_ADDRESS_WIDTH - 1;

    logic pixel_bit;
    logic [PIXEL_BITS - 1:0] pixel;
    logic [WIDTH_BITS - 1:0] aux_x;  
    logic [DATA_WIDTH - 1:0] address, current_instr_address, current_data_address, instruction_address0, data_address0;

    always_latch 
    begin
        if(pixel_x_in==0 && pixel_y_in==2)
            aux_raddress_out <= 5'h00;
        
        else if(pixel_x_in==1 && pixel_y_in==2)
        begin
            current_instr_address <= aux_data_in; 

            if(aux_data_in < 5)
            begin/*0x000 to 0x009*/
                instruction_address0 <= {DATA_WIDTH{1'b0}};
            end

            else if(aux_data_in > (_FINAL_ADDRESS - 5))
            begin/*LAST_ADDRESS-11'h009 to LAST_ADDRESS*/
                instruction_address0 <= _FINAL_ADDRESS - 11'h009;
            end

            else
            begin/*aux_data_in-11'h004 to aux_data_in+11'h005*/
                instruction_address0 <= aux_data_in - 11'h004;
            end
        end

        else if(pixel_x_in==2 && pixel_y_in==2)
            aux_raddress_out <= 5'h02;
        
        else if(pixel_x_in==3 && pixel_y_in==2)
        begin
            current_data_address <= aux_data_in;

            if(aux_data_in < 5)
            begin/*0x000 to 0x009*/
                data_address0 <= {DATA_WIDTH{1'b0}};
            end

            else if(aux_data_in > (_FINAL_ADDRESS - 5))
            begin/*LAST_ADDRESS-11'h009 to LAST_ADDRESS*/
                data_address0 <= _FINAL_ADDRESS - 11'h009;
            end

            else
            begin/*aux_data_in-11'h004 to aux_data_in+11'h005*/
                data_address0 <= aux_data_in - 11'h004;
            end
        end

        else if((pixel_x_in>=159 && pixel_x_in<=287) && (pixel_y_in[9:4]>=3 && pixel_y_in[9:4]<=12))
        begin//INSTRUCTION locations in the aux memory
            aux_raddress_out <= CPU_ELEMENTS + pixel_y_in[9:4] - 6'd3;//First address: 5'h0a
        end

        else if((pixel_x_in>=159 && pixel_x_in<=287) && (pixel_y_in[9:4]>=19 && pixel_y_in[9:4]<=28))
        begin//DATA locations in the aux memory
            aux_raddress_out <= CPU_ELEMENTS + MEMORY_ELEMENTS + pixel_y_in[9:4] - 6'd19;//First address 5'h14
        end

        else if((pixel_x_in>=356 && pixel_x_in<=484) && (pixel_y_in>=65 && pixel_y_in<=80))
            aux_raddress_out <= 5'h00;//PC location in the aux memory

        else if((pixel_x_in>=502 && pixel_x_in<=630) && (pixel_y_in>=65 && pixel_y_in<=80))
            aux_raddress_out <= 5'h01;//INSTRUCTION IN location in the aux memory

        else if((pixel_x_in>=356 && pixel_x_in<=484) && (pixel_y_in>=115 && pixel_y_in<=130))
            aux_raddress_out <= 5'h02;//DATA ADDRESS location in the aux memory

        else if((pixel_x_in>=502 && pixel_x_in<=630) && (pixel_y_in>=115 && pixel_y_in<=130))
            aux_raddress_out <= 5'h03;//DATA IN location in the aux memory
            
        else if((pixel_x_in>=356 && pixel_x_in<=484) && (pixel_y_in>=165 && pixel_y_in<=180))
            aux_raddress_out <= 5'h04;//IR location in the aux memory

        else if((pixel_x_in>=502 && pixel_x_in<=630) && (pixel_y_in>=165 && pixel_y_in<=180))
            aux_raddress_out <= 5'h05;//ACC location in the aux memory

        else if((pixel_x_in>=356 && pixel_x_in<=484) && (pixel_y_in>=215 && pixel_y_in<=230))
            aux_raddress_out <= 5'h06;//ALU A location in the aux memory
        
        else if((pixel_x_in>=502 && pixel_x_in<=630) && (pixel_y_in>=215 && pixel_y_in<=230))
            aux_raddress_out <= 5'h07;//ALU B location in the aux memory
        
        else if((pixel_x_in>=419 && pixel_x_in<=426) && (pixel_y_in>=312 && pixel_y_in<=327))
            aux_raddress_out <= 5'h08;//CLOCK level location in the aux memory

        else if((pixel_x_in>=556 && pixel_x_in<=575) && (pixel_y_in>=313 && pixel_y_in<=328))
            aux_raddress_out <= 5'h09;//STATUS location in the aux memory
    end
    
    always_comb 
    begin
        if((pixel_x_in[9:3]>=2 && pixel_x_in[9:3]<=17) && (pixel_y_in[9:4]>=3 && pixel_y_in[9:4]<=12))
        begin//Show INSTRUCTION ADDRESSES values
            aux_x = 10'd0;
            address <= {instruction_address0 + pixel_y_in[9:4] - 6'd3};
            bit_value_out <= address[7'd17 - pixel_x_in[9:3]];
        end

        else if((pixel_x_in[9:3]>=20 && pixel_x_in[9:3]<=35) && (pixel_y_in[9:4]>=3 && pixel_y_in[9:4]<=12))
        begin//Show INSTRUCTION values
            aux_x = 10'd0;
            address <= {instruction_address0 + pixel_y_in[9:4] - 6'd3};
            bit_value_out <= aux_data_in[7'd35 - pixel_x_in[9:3]];
        end

        else if((pixel_x_in[9:3]>=2 && pixel_x_in[9:3]<=17) && (pixel_y_in[9:4]>=19 && pixel_y_in[9:4]<=28))
        begin//Show DATA ADDRESSES values
            aux_x = 10'd0;
            address <= {data_address0 + pixel_y_in[9:4] - 6'd19};
            bit_value_out <= address[7'd17 - pixel_x_in[9:3]];
        end

        else if((pixel_x_in[9:3]>=20 && pixel_x_in[9:3]<=35) && (pixel_y_in[9:4]>=19 && pixel_y_in[9:4]<=28))
        begin//Show DATA values
            aux_x = 10'd0;
            address <= {data_address0 + pixel_y_in[9:4] - 6'd19};
            bit_value_out <= aux_data_in[7'd35 - pixel_x_in[9:3]];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=65 && pixel_y_in<=80))
        begin//Show PC value
            aux_x = 10'd484 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=65 && pixel_y_in<=80))
        begin//Show INSTRUCTION IN value
            aux_x = 10'd630 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=115 && pixel_y_in<=130))
        begin//Show DATA ADDRESS value
            aux_x = 10'd484 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=115 && pixel_y_in<=130))
        begin//Show DATA IN value
            aux_x = 10'd630 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=165 && pixel_y_in<=180))
        begin//Show IR value
            aux_x = 10'd484 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=165 && pixel_y_in<=180))
        begin//Show ACC value
            aux_x = 10'd630 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=215 && pixel_y_in<=230))
        begin//Show ALU A value
            aux_x = 10'd484 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=215 && pixel_y_in<=230))
        begin//Show ALU B value
            aux_x = 10'd630 - pixel_x_in;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[aux_x[9:3]];
        end

        else if((pixel_x_in>=557 && pixel_x_in<=565) && (pixel_y_in>=313 && pixel_y_in<=328))
        begin//Show STATUS Z value
            aux_x = 10'd0;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[1];
        end

        else if((pixel_x_in>=568 && pixel_x_in<=575) && (pixel_y_in>=313 && pixel_y_in<=328))
        begin//Show STATUS N value
            aux_x = 10'd0;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[0];
        end

        else if((pixel_x_in>=420 && pixel_x_in<=426) && (pixel_y_in>=312 && pixel_y_in<=327))
        begin//Show CLOCK level
            aux_x = 10'd0;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= aux_data_in[0];
        end

        else
        begin
            aux_x = 10'd0;
            address <= {DATA_WIDTH{1'b0}};
            bit_value_out <= 1'b0;
        end
    end

    always_comb
    begin
        if(((pixel_x_in[9:3]>=2 && pixel_x_in[9:3]<=17) || (pixel_x_in[9:3]>=20 && pixel_x_in[9:3]<=35)) && 
        ((pixel_y_in>=48 && pixel_y_in<=206) && (address == current_instr_address) || /*Invert colors in the current instruction address*/
        (pixel_y_in>=303 && pixel_y_in<=462) && (address == current_data_address)))/*Invert colors in the current data address*/
            pixel <= {PIXEL_BITS{!pixel_bit}};
        else
            pixel <= {PIXEL_BITS{pixel_bit}};
    end

    assign pixel_bit = figure_bit_in | char_bit_in; 
    assign pixel_red_out = pixel[11:8];
    assign pixel_green_out = pixel[7:4];
    assign pixel_blue_out = pixel[3:0];

endmodule