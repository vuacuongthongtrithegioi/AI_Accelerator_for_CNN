module tb ();
    reg clk, reset, start;
    reg signed [215:0] IFM;
    reg signed [215:0] WGT;

    wire signed [47:0] c1,c2,c3;
    wire signed [47:0] c4,c5,c6;
    wire signed [47:0] c7,c8,c9;

    wire done;

    mac_unit_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .IFM(IFM),
        .WGT(WGT),

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
        #1000;
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;
    end
endmodule