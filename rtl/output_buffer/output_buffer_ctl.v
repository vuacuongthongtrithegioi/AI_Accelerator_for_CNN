module output_buffer_ctl (clk, reset, done_sytolic, load);
    input clk, reset, done_sytolic;
    output reg load;

    always @(posedge clk) begin
        if (reset) begin
            load <= 0;
        end
        else if (done_sytolic) begin
            load <= 1;
        end
        else begin
            load <= 0;
        end
    end
endmodule