module figure_generator(  
        input logic [9:0] pixel_x_in, pixel_y_in, 
        output logic pixel_bit_out
    );

    logic instr_mem_rectangle, data_mem_rectangle, pc_rectangle, instr_in_rectangle; 
    logic data_add_rectangle, data_in_rectangle, ir_rectangle, acc_rectangle;
    logic alu_a_rectangle, alu_b_rectangle, clock_rectangle, status_rectangle;

    assign instr_mem_rectangle = (pixel_x_in>=8 && pixel_x_in<=295) && (pixel_y_in==31 || pixel_y_in==47 || pixel_y_in==207)//Horizontal line
                        || (pixel_x_in == 8 || pixel_x_in == 152 || pixel_x_in == 295) && (pixel_y_in > 31 && pixel_y_in < 207);//Vertical line
    
    assign data_mem_rectangle = (pixel_x_in>=8 && pixel_x_in<=295) && (pixel_y_in==287 || pixel_y_in==303 || pixel_y_in==463)//Horizontal line
                        || (pixel_x_in == 8 || pixel_x_in == 152 || pixel_x_in == 295) && (pixel_y_in > 287 && pixel_y_in < 463);//Vertical line
    
    assign pc_rectangle = (pixel_x_in>=355 && pixel_x_in <= 485) && (pixel_y_in==63 || pixel_y_in==81)//Horizontal line
                        || (pixel_x_in==355 || pixel_x_in == 485) && (pixel_y_in > 63 && pixel_y_in < 81);//Vertical line
    
    assign instr_in_rectangle = (pixel_x_in>=501 && pixel_x_in <= 631) && (pixel_y_in==63 || pixel_y_in==81)//Horizontal line
                        || (pixel_x_in==501 || pixel_x_in == 631) && (pixel_y_in > 63 && pixel_y_in < 81);//Vertical line
    
    assign data_add_rectangle = (pixel_x_in>=355 && pixel_x_in <= 485) && (pixel_y_in==113 || pixel_y_in==131)//Horizontal line
                        || (pixel_x_in==355 || pixel_x_in == 485) && (pixel_y_in > 113 && pixel_y_in < 131);//Vertical line
    
    assign data_in_rectangle = (pixel_x_in>=501 && pixel_x_in <= 631) && (pixel_y_in==113 || pixel_y_in==131)//Horizontal line
                        || (pixel_x_in==501 || pixel_x_in == 631) && (pixel_y_in > 113 && pixel_y_in < 131);//Vertical line
    
    assign ir_rectangle = (pixel_x_in>=355 && pixel_x_in <= 485) && (pixel_y_in==163 || pixel_y_in==181)//Horizontal line
                        || (pixel_x_in==355 || pixel_x_in == 485) && (pixel_y_in > 163 && pixel_y_in < 181);//Vertical line
    
    assign acc_rectangle = (pixel_x_in>=501 && pixel_x_in <= 631) && (pixel_y_in==163 || pixel_y_in==181)//Horizontal line
                        || (pixel_x_in==501 || pixel_x_in == 631) && (pixel_y_in > 163 && pixel_y_in < 181);//Vertical line
    
    assign alu_a_rectangle = (pixel_x_in>=355 && pixel_x_in <= 485) && (pixel_y_in==213 || pixel_y_in==231)//Horizontal line
                        || (pixel_x_in==355 || pixel_x_in == 485) && (pixel_y_in > 213 && pixel_y_in < 231);//Vertical line
    
    assign alu_b_rectangle = (pixel_x_in>=501 && pixel_x_in <= 631) && (pixel_y_in==213 || pixel_y_in==231)//Horizontal line
                        || (pixel_x_in==501 || pixel_x_in == 631) && (pixel_y_in > 213 && pixel_y_in < 231);//Vertical line
    
    assign clock_rectangle = (pixel_x_in>=418 && pixel_x_in <= 428) && (pixel_y_in==311 || pixel_y_in==329)//Horizontal line
                        || (pixel_x_in==418 || pixel_x_in == 428) && (pixel_y_in > 311 && pixel_y_in < 329);//Vertical line
    
    assign status_rectangle = (pixel_x_in>=556 && pixel_x_in <= 576) && (pixel_y_in==311 || pixel_y_in==329)//Horizontal line
                        || (pixel_x_in==556 || pixel_x_in==566 || pixel_x_in == 576) && (pixel_y_in > 311 && pixel_y_in < 329);//Vertical line
    
    assign pixel_bit_out = instr_mem_rectangle | data_mem_rectangle | pc_rectangle | instr_in_rectangle 
                        | data_add_rectangle | data_in_rectangle | ir_rectangle | acc_rectangle
                        | alu_a_rectangle | alu_b_rectangle | clock_rectangle | status_rectangle;

endmodule