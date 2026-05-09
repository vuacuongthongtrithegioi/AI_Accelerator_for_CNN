module mac_reg (

    input clk,
    input reset,
    input valid_in,
    input signed [47:0] p1_in, p2_in, p3_in;
    input signed [47:0] p4_in, p5_in, p6_in;
    input signed [47:0] p7_in, p8_in, p9_in;

    output reg signed [47:0] p1_out, p2_out, p3_out;
    output reg signed [47:0] p4_out, p5_out, p6_out;
    output reg signed [47:0] p7_out, p8_out, p9_out;

    output reg valid_out
);

    always @(posedge clk or posedge reset) begin

        if(reset) begin

            p1_out <= 0; p2_out <= 0; p3_out <= 0;
            p4_out <= 0; p5_out <= 0; p6_out <= 0;
            p7_out <= 0; p8_out <= 0; p9_out <= 0;

            valid_out <= 0;

        end
        else begin
            valid_out <= valid_in;
            if(valid_in) begin
                p1_out <= p1_in;
                p2_out <= p2_in;
                p3_out <= p3_in;
                p4_out <= p4_in;
                p5_out <= p5_in;
                p6_out <= p6_in;
                p7_out <= p7_in;
                p8_out <= p8_in;
                p9_out <= p9_in;
            end
        end
    end
endmodule