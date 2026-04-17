`timescale 1ns/1ps

module tb ();
    reg clk, reset, relu_en;

    reg [47:0] in_0, in_1, in_2, 
                in_3, in_4, in_5, 
                in_6, in_7, in_8;

    wire [47:0] out_0, out_1, out_2, 
                out_3, out_4, out_5, 
                out_6, out_7, out_8;

    ReLU relu (
        .clk(clk),
        .reset(reset),
        .relu_en(relu_en),
        .in_0(in_0), .in_1(in_1), .in_2(in_2),
        .in_3(in_3), .in_4(in_4), .in_5(in_5),
        .in_6(in_6), .in_7(in_7), .in_8(in_8),
        .out_0(out_0), .out_1(out_1), .out_2(out_2),
        .out_3(out_3), .out_4(out_4), .out_5(out_5),
        .out_6(out_6), .out_7(out_7), .out_8(out_8)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        relu_en = 0;

        in_0 = 48'h000000000001; // 1
        in_1 = 48'hFFFFFFFFFFFF; // -1
        in_2 = 48'h000000000005; // 5

        in_3 = 48'hFFFFFFFFFFFE; // -2
        in_4 = 48'h000000000003; // 3
        in_5 = 48'hFFFFFFFFFFFD; // -3

        in_6 = 48'h000000000000; // 0
        in_7 = 48'h000000000002; // 2
        in_8 = 48'hFFFFFFFFFFFC; // -4

        #10 reset = 0;
        #10 relu_en = 1;
        #10 relu_en = 0;

        #50 $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
    end
endmodule