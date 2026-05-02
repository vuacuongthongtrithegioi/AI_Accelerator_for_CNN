module tb;
    reg clk, reset, start;
    reg signed [215:0] IFM_in;
    reg signed [215:0] WGT_in;
    wire signed [215:0] IFM_out;
    wire signed [215:0] WGT_out;
    wire done;

    input_buffer_block_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM_in(IFM_in),
        .WGT_in(WGT_in),
        .IFM_out(IFM_out),
        .WGT_out(WGT_out),
        .done(done)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0; reset = 1; start = 0;
        IFM_in = 216'h1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF;
        WGT_in = 216'hFEDCBA0987654321FEDCBA0987654321FEDCBA0987654321;
        #10 reset = 0; start = 1;
        #10 start = 0;
        #100 $finish;
    end

    initial begin
        $dumpfile("tb_input_buffer.vcd");
        $dumpvars(0, tb);
    end
endmodule