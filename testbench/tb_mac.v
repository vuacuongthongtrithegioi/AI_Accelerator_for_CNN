module tb ();
    reg clk, reset, start;
    reg [23:0] a1,a2,a3;
    reg [23:0] b1,b2,b3;
    wire [48:0] c1,c2,c3;
    wire [48:0] c4,c5,c6;
    wire [48:0] c7,c8,c9;
    wire done;

    mac_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),

        .c1(c1), .c2(c2), .c3(c3),
        .c4(c4), .c5(c5), .c6(c6),
        .c7(c7), .c8(c8), .c9(c9),

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
        a1 = 24'd1; a2 = 24'd2; a3 = 24'd3;
        b1 = 24'd1; b2 = 24'd4; b3 = 24'd7;
        #1000;
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;
    end
endmodule