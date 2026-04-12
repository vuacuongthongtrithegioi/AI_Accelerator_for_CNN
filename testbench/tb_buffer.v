`timescale 1ns/1ps

module tb ();
    wire clk, reset, start;

    wire [215:0] IFM;
    wire [215:0] WGT;

    reg [23:0] a1,a2,a3;
    reg [23:0] b1,b2,b3;
    reg done;

    systolic_input_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .IFM(IFM),
        .WGT(WGT),

        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        #10;
        reset = 0;
        start = 1;
        #10;
        start = 0;
        
        IFM = {24'd1, 24'd2, 24'd3, 24'd4, 24'd5, 24'd6, 24'd7, 24'd8, 24'd9};
        WGT = {24'd1, 24'd2, 24'd3, 24'd4, 24'd5, 24'd6, 24'd7, 24'd8, 24'd9};
        #1000;
        $finish;
    end

    initial begin
        $dumpfile("tb_buffer.vcd");
        $dumpvars(0, tb);
    end
endmodule