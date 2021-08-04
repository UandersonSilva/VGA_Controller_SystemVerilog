module character_generator(
        input logic [9:0] pixel_x_in, pixel_y_in,
        input logic [0:7] char_line_in,
        input logic bit_value_in,
        output logic [10:0] char_address_out,
        output logic char_bit_out
    );
    //--------------------------Drawing static words--------------------------------
    logic [6:0] words [7:0][0:10]; //7 bits wide array with rows = 8, cols = 11
    logic [6:0] short_words [1:0][0:1]; //7 bits wide array with rows = 2, cols = 2

    initial 
    begin
        words[0] = '{7'h49, 7'h4e, 7'h53, 7'h54, 7'h52, 7'h55, 7'h43, 7'h54, 7'h49, 7'h4f, 7'h4e}; //INSTRUCTION
        words[1] = '{7'h4d, 7'h45, 7'h4d, 7'h4f, 7'h52, 7'h59, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00}; //MEMORY
        words[2] = '{7'h41, 7'h44, 7'h44, 7'h52, 7'h45, 7'h53, 7'h53, 7'h00, 7'h00, 7'h00, 7'h00}; //ADDRESS
        words[3] = '{7'h44, 7'h41, 7'h54, 7'h41, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00}; //DATA
        words[4] = '{7'h41, 7'h43, 7'h43, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00}; //ACC
        words[5] = '{7'h41, 7'h4c, 7'h55, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00}; //ALU
        words[6] = '{7'h43, 7'h4c, 7'h4f, 7'h43, 7'h4b, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00}; //CLOCK
        words[7] = '{7'h53, 7'h54, 7'h41, 7'h54, 7'h55, 7'h53, 7'h00, 7'h00, 7'h00, 7'h00, 7'h00}; //STATUS

        short_words[0] = '{7'h50, 7'h43}; //PC
        short_words[1] = '{7'h49, 7'h52}; //IR
    end

    always_comb 
    begin
        if((pixel_x_in[9:3]>=10 && pixel_x_in[9:3]<=20) && (pixel_y_in[9:4]==1))//Show INSTRUCTION tile_map(10, 1)
        begin
            char_address_out <= {words[0][pixel_x_in[9:3] - 10], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=22 && pixel_x_in[9:3]<=27) && (pixel_y_in[9:4]==1))//Show MEMORY tile_map(22, 1)
        begin
            char_address_out <= {words[1][pixel_x_in[9:3] - 22], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=6 && pixel_x_in[9:3]<=12) && (pixel_y_in[9:4]==2))//Show ADDRESS tile_map(6, 2)
        begin
            char_address_out <= {words[2][pixel_x_in[9:3] - 6], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=22 && pixel_x_in[9:3]<=32) && (pixel_y_in[9:4]==2))//Show INSTRUCTION tile_map(22, 2)
        begin
            char_address_out <= {words[0][pixel_x_in[9:3] - 22], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=14 && pixel_x_in[9:3]<=17) && (pixel_y_in[9:4]==17))//Show DATA tile_map(14, 17)
        begin
            char_address_out <= {words[3][pixel_x_in[9:3] - 14], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=19 && pixel_x_in[9:3]<=24) && (pixel_y_in[9:4]==17))//Show MEMORY tile_map(19, 17)
        begin
            char_address_out <= {words[1][pixel_x_in[9:3] - 19], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=6 && pixel_x_in[9:3]<=12) && (pixel_y_in[9:4]==18))//Show ADDRESS tile_map(6, 18)
        begin
            char_address_out <= {words[2][pixel_x_in[9:3] - 6], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=26 && pixel_x_in[9:3]<=30) && (pixel_y_in[9:4]==18))//Show DATA tile_map(26, 30)
        begin
            char_address_out <= {words[3][pixel_x_in[9:3] - 26], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=51 && pixel_x_in[9:3]<=52) && (pixel_y_in[9:4]==3))//Show PC tile_map(51, 3)
        begin
            char_address_out <= {short_words[0][pixel_x_in[9:3] - 51], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=64 && pixel_x_in[9:3]<=74) && (pixel_y_in[9:4]==3))//Show INSTRUCTION tile_map(64, 3)
        begin
            char_address_out <= {words[0][pixel_x_in[9:3] - 64], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=76 && pixel_x_in[9:3]<=77) && (pixel_y_in[9:4]==3))//Show IN tile_map(76, 3)
        begin
            char_address_out <= {words[0][pixel_x_in[9:3] - 76], pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=46 && pixel_x_in[9:3]<=49) && (pixel_y_in>=98 && pixel_y_in<=113))//Show DATA tile_map_x(46) line_map_y(98)
        begin
            char_address_out <= {words[3][pixel_x_in[9:3] - 46], pixel_y_in[3:0] - 4'h2};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=51 && pixel_x_in[9:3]<=57) && (pixel_y_in>=98 && pixel_y_in<=113))//Show ADDRESS tile_map_x(51) line_map_y(98)
        begin
            char_address_out <= {words[2][pixel_x_in[9:3] - 51], pixel_y_in[3:0]  - 4'h2};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=67 && pixel_x_in[9:3]<=70) && (pixel_y_in>=98 && pixel_y_in<=113))//Show DATA tile_map_x(67) line_map_y(98)
        begin
            char_address_out <= {words[3][pixel_x_in[9:3] - 67], pixel_y_in[3:0] - 4'h2};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=72 && pixel_x_in[9:3]<=73) && (pixel_y_in>=98 && pixel_y_in<=113))//Show IN tile_map_x(72) line_map_y(98)
        begin
            char_address_out <= {words[0][pixel_x_in[9:3] - 72], pixel_y_in[3:0] - 4'h2};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=51 && pixel_x_in[9:3]<=52) && (pixel_y_in>=148 && pixel_y_in<=163))//Show IR tile_map_x(51) line_map_y(148)
        begin
            char_address_out <= {short_words[1][pixel_x_in[9:3] - 51], pixel_y_in[3:0]  - 4'h4};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=69 && pixel_x_in[9:3]<=71) && (pixel_y_in>=148 && pixel_y_in<=163))//Show ACC tile_map_x(69) line_map_y(148)
        begin
            char_address_out <= {words[4][pixel_x_in[9:3] - 69], pixel_y_in[3:0] - 4'h4};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=50 && pixel_x_in[9:3]<=52) && (pixel_y_in>=198 && pixel_y_in<=213))//Show ALU tile_map_x(50) line_map_y(198)
        begin
            char_address_out <= {words[5][pixel_x_in[9:3] - 50], pixel_y_in[3:0] - 4'h6};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]==54) && (pixel_y_in>=198 && pixel_y_in<=213))//Show A tile_map_x(54) line_map_y(198)
        begin
            char_address_out <= {7'h41, pixel_y_in[3:0] - 4'h6};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=68 && pixel_x_in[9:3]<=70) && (pixel_y_in>=198 && pixel_y_in<=213))//Show ALU tile_map_x(68) line_map_y(198)
        begin
            char_address_out <= {words[5][pixel_x_in[9:3] - 68], pixel_y_in[3:0] - 4'h6};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]==72) && (pixel_y_in>=198 && pixel_y_in<=213))//Show B tile_map_x(72) line_map_y(198)
        begin
            char_address_out <= {7'h42, pixel_y_in[3:0] - 4'h6};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=51 && pixel_x_in[9:3]<=56) && (pixel_y_in>=296 && pixel_y_in<=313))//Show CLOCK tile_map_x(51) line_map_y(296)
        begin
            char_address_out <= {words[6][pixel_x_in[9:3] - 51], pixel_y_in[3:0] - 4'h8};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=68 && pixel_x_in[9:3]<=73) && (pixel_y_in>=296 && pixel_y_in<=313))//Show STATUS tile_map_x(68) line_map_y(296)
        begin
            char_address_out <= {words[7][pixel_x_in[9:3] - 68], pixel_y_in[3:0] - 4'h8};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in>=557 && pixel_x_in<=564) && (pixel_y_in>=329 && pixel_y_in<=344))//Show Z column_map_x(557) line_map_y(329)
        begin
            char_address_out <= {7'h5a, pixel_y_in[3:0] - 4'h9};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'd5];
        end

        else if((pixel_x_in[9:3]==71) && (pixel_y_in>=329 && pixel_y_in<=344))//Show N tile_map_x(71) line_map_y(329)
        begin
            char_address_out <= {7'h4e, pixel_y_in[3:0] - 4'h9};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end
        //---------------------------Drawing dynamic words---------------------------------
        else if((pixel_x_in[9:3]>=2 && pixel_x_in[9:3]<=17) && (pixel_y_in[9:4]>=3 && pixel_y_in[9:4]<=12))//Show INSTRUCTION ADDRESSES values
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=20 && pixel_x_in[9:3]<=35) && (pixel_y_in[9:4]>=3 && pixel_y_in[9:4]<=12))//Show INSTRUCTION values
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=2 && pixel_x_in[9:3]<=17) && (pixel_y_in[9:4]>=19 && pixel_y_in[9:4]<=28))//Show DATA ADDRESSES values
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in[9:3]>=20 && pixel_x_in[9:3]<=35) && (pixel_y_in[9:4]>=19 && pixel_y_in[9:4]<=28))//Show DATA values
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0]};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=65 && pixel_y_in<=80))//Show PC
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h1};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h5];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=65 && pixel_y_in<=80))//Show INSTRUCTION IN value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h1};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h7];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=115 && pixel_y_in<=130))//Show DATA ADDRESS value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h3};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h5];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=115 && pixel_y_in<=130))//Show DATA IN value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h3};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h7];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=165 && pixel_y_in<=180))//Show IR value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h5};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h5];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=165 && pixel_y_in<=180))//Show ACC value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h5};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h7];
        end

        else if((pixel_x_in>=357 && pixel_x_in<=484) && (pixel_y_in>=215 && pixel_y_in<=230))//Show ALU A value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h7};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h5];
        end

        else if((pixel_x_in>=503 && pixel_x_in<=630) && (pixel_y_in>=215 && pixel_y_in<=230))//Show ALU B value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h7};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h7];
        end

        else if((pixel_x_in>=557 && pixel_x_in<=565) && (pixel_y_in>=313 && pixel_y_in<=328))//Show STATUS Z value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h9};
            char_bit_out <= char_line_in[pixel_x_in[2:0] - 3'h6];
        end

        else if((pixel_x_in>=568 && pixel_x_in<=575) && (pixel_y_in>=313 && pixel_y_in<=328))//Show STATUS N value
        begin
            char_address_out <= {7'h30 + bit_value_in, pixel_y_in[3:0] - 4'h9};
            char_bit_out <= char_line_in[pixel_x_in[2:0]];
        end

        else if((pixel_x_in>=420 && pixel_x_in<=426) && (pixel_y_in>=312 && pixel_y_in<=327))//Show CLOCK LEVEL value
        begin
		    char_address_out <= {(11){1'b0}};
            char_bit_out <= bit_value_in;
        end

        else
        begin
            char_address_out <= {(11){1'b0}};
            char_bit_out <= 1'b0;
        end       
    end
endmodule