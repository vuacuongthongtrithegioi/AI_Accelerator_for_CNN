module tb ();
    reg clk, reset, start;
    reg [215:0] IFM, WGT;
    wire done;
    wire done_input_buffer, done_mac;
    wire [47:0] c1_out, c2_out, c3_out;
    wire [47:0] c4_out, c5_out, c6_out; 
    wire [47:0] c7_out, c8_out, c9_out;

    NPU npu (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM(IFM),
        .WGT(WGT),
        .done(done),
        .c1_out(c1_out), .c2_out(c2_out), .c3_out(c3_out),
        .c4_out(c4_out), .c5_out(c5_out), .c6_out(c6_out),
        .c7_out(c7_out), .c8_out(c8_out), .c9_out(c9_out),
        .done_input_buffer(done_input_buffer),
        .done_mac(done_mac)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        IFM = {
            24'd1, 24'd2, 24'd3,
            24'd4, 24'd5, 24'd6,
            24'd7, 24'd8, 24'd9
        };
        WGT = {
            24'd1, 24'd2, 24'd3,
            24'd4, 24'd5, 24'd6,
            24'd7, 24'd8, 24'd9
        };
        #10;
        reset = 0; 
        start = 1;
        #10;
        start = 0;
        #1000 $finish;
    end

    initial begin
        $dumpfile("npu_tb.vcd");
        $dumpvars();
    end
endmodule