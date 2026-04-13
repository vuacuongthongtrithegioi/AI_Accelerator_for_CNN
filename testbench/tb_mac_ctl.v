module tb ();
    reg clk, reset, start;
    wire clear, valid, done;
    wire [3:0] cycle;

    SystolicController uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .clear(clear),
        .valid(valid),
        .done(done),
        .cycle(cycle)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        #10 
        reset = 0;
        start = 1;
        #10;
        start = 0;
        #1000;
      	$finish;
    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end
endmodule