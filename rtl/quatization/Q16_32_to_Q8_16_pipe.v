module Q16_32_to_Q8_16_pipe (
    input  wire clk,
    input  wire reset,
    input  wire enable,

    input  wire signed [47:0] din,
    output reg  signed [23:0] dout,
    output reg done
);

    reg signed [47:0] stage1;
    reg valid1;
    
    always @(posedge clk) begin
        if (reset) begin
            valid1 <= 0;
        end else begin
            valid1 <= enable;
            if (enable)
                stage1 <= din + 48'sd32768;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            dout <= 0;
            done <= 0;
        end else begin
            done <= valid1;

            if (valid1) begin
                if (stage1[47:39] != {9{stage1[47]}})
                    dout <= (stage1[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout <= stage1[39:16];
            end
        end
    end

endmodule