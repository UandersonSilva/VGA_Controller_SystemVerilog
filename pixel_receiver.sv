module pixel_receiver#(
        parameter WIDTH = 640,
        parameter HEIGHT = 480,
        parameter WIDTH_BITS = 10,
        parameter HEIGHT_BITS = 9,
        parameter PIXEL_BITS = 12
    )
    (
        input logic [WIDTH_BITS - 1:0] pixel_x_in,
        input logic [HEIGHT_BITS - 1:0] pixel_y_in,
        input logic [PIXEL_BITS - 1:0] pixel_in,
        input logic clock_in, video_on_in, v_sync_in
    );

    localparam 
        FILE_PATH = "C:/Users/uande/Documents/TCC/VGA_CONTROLLER/";//frame.bin path on your computer

    logic [PIXEL_BITS - 1:0] frame [2**(WIDTH_BITS + HEIGHT_BITS) - 1:0];

    always_ff @(posedge clock_in)
    begin
        if(video_on_in)
            frame[{pixel_y_in, pixel_x_in}] <= pixel_in;
    end

    always_ff @(negedge v_sync_in) 
        $writememb({FILE_PATH, "frame.bin"}, frame);

endmodule