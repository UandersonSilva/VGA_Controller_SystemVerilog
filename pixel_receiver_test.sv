`timescale 1 ns / 10 ps

module pixel_receiver_test;

    localparam 
        WIDTH = 640,
        HEIGHT = 480,
        WIDTH_BITS = 10,
        HEIGHT_BITS = 9,
        PIXEL_BITS = 12;

    logic [WIDTH_BITS - 1:0] pixel_x;
    logic [HEIGHT_BITS - 1:0] pixel_y;
    logic [PIXEL_BITS - 1:0] pixel;
    logic clock, video_on, v_sync;

    clock_generator GCLOCK(clock);

    pixel_receiver pr0(
        .pixel_x_in(pixel_x),
        .pixel_y_in(pixel_y),
        .pixel_in(pixel),
        .clock_in(clock),
        .video_on_in(video_on), 
        .v_sync_in(v_sync)
    );

    initial 
    begin
        v_sync = 1'b1;
        video_on = 1'b1;

        for (pixel_y=0; pixel_y<HEIGHT; pixel_y++)
        begin
            for (pixel_x=0; pixel_x<WIDTH; pixel_x++)
            begin
                if(
                    ((pixel_x <= WIDTH/2) && (pixel_y <= HEIGHT/2)) || 
                    ((pixel_x > WIDTH/2) && (pixel_y > HEIGHT/2)) 
                )
                begin
                    pixel = {(PIXEL_BITS){1'b1}};
                    #2;
                end
                else
                    pixel = {(PIXEL_BITS){1'b0}};
                    #2;
            end
        end
        
        v_sync = 1'b0;
        video_on = 1'b0;
        #2 v_sync = 1'b1;        
    end

endmodule