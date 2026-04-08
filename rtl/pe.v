module pe(
    clk, reset, clear,
    ifm_in, weight_in,
    ifm_out, weight_out,
    ofm_out
);
    input wire clk, reset, clear;
    input wire [23:0] ifm_in, weight_in;
    output reg [23:0] ifm_out, weight_out;
    output reg [47:0] ofm_out;

    always @(posedge clk) begin
        if (reset || clear) begin
            ifm_out <= 0;
            weight_out <= 0;
            ofm_out <= 0;
        end else begin
            ifm_out <= ifm_in;
            weight_out <= weight_in;
            ofm_out <= ofm_out + ifm_in * weight_in;
        end
    end
endmodule