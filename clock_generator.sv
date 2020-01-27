`timescale 1 ns/ 10 ps

module clock_generator(output logic clock_out);

    initial
    begin
        clock_out = 1; 
    end 
        
    always  
        #1 clock_out = !clock_out; 

endmodule