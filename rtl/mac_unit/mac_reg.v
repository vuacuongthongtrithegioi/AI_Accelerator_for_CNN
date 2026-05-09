module mac_reg (
    clk, reset, read, write,
    p1_in, p2_in, p3_in,
    p4_in, p5_in, p6_in,
    p7_in, p8_in, p9_in,
);
    input clk, reset, read, write;
    input signed [47:0] p1_in, p2_in, p3_in;
    input signed [47:0] p4_in, p5_in, p6_in;
    input signed [47:0] p7_in, p8_in, p9_in;

    output reg signed [47:0] p1_out, p2_out, p3_out;
    output reg signed [47:0] p4_out, p5_out, p6_out;
    output reg signed [47:0] p7_out, p8_out, p9_out;

    reg [47:0] p1_in_reg, p2_in_reg, p3_in_reg;
    reg [47:0] p4_in_reg, p5_in_reg, p6_in_reg;
    reg [47:0] p7_in_reg, p8_in_reg, p9_in_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p1_out <= 0; p2_out <= 0; p3_out <= 0;
            p4_out <= 0; p5_out <= 0; p6_out <= 0;
            p7_out <= 0; p8_out <= 0; p9_out <= 0;
        end else if (write) begin
            // Write input values to registers
            p1_in_reg <= p1_in;
            p2_in_reg <= p2_in;
            p3_in_reg <= p3_in;
            p4_in_reg <= p4_in;
            p5_in_reg <= p5_in;
            p6_in_reg <= p6_in;
            p7_in_reg <= p7_in;
            p8_in_reg <= p8_in;
            p9_in_reg <= p9_in;
        end else if (read) begin
            // Output the registered values
            p1_out <= p1_in_reg;
            p2_out <= p2_in_reg;
            p3_out <= p3_in_reg;
            p4_out <= p4_in_reg;
            p5_out <= p5_in_reg;
            p6_out <= p6_in_reg;
            p7_out <= p7_in_reg;
            p8_out <= p8_in_reg;
            p9_out <= p9_in_reg;
        end
    end

endmodule