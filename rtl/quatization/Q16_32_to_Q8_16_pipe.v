module Q16_32_to_Q8_16_pipe (
    input  wire clk,
    input  wire reset,
    input  wire enable,

    input  wire signed [47:0] din_0, din_1, din_2, din_3, din_4, din_5, din_6, din_7, din_8;
    output reg  signed [23:0] dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, dout_8;
    output reg done
);

    reg signed [47:0] stage_0, stage_1, stage_2, stage_3, stage_4, stage_5, stage_6, stage_7, stage_8;
    reg valid1;

    always @(posedge clk) begin
        if (reset) begin
            valid1 <= 0;
        end else begin
            valid1 <= enable;
            if (enable)
                stage_0 <= din_0 + 48'sd32768;
                stage_1 <= din_1 + 48'sd32768;
                stage_2 <= din_2 + 48'sd32768;
                stage_3 <= din_3 + 48'sd32768;
                stage_4 <= din_4 + 48'sd32768;
                stage_5 <= din_5 + 48'sd32768;
                stage_6 <= din_6 + 48'sd32768;
                stage_7 <= din_7 + 48'sd32768;
                stage_8 <= din_8 + 48'sd32768;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            dout_0 <= 0; dout_1 <= 0; dout_2 <= 0;
            dout_3 <= 0; dout_4 <= 0; dout_5 <= 0;
            dout_6 <= 0; dout_7 <= 0; dout_8 <= 0;
            done <= 0;
        end else begin
            done <= valid1;

            if (valid1) begin
                if (stage_0[47:39] != {9{stage_0[47]}})
                    dout_0 <= (stage_0[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_0 <= stage_0[39:16];
                if (stage_1[47:39] != {9{stage_1[47]}})
                    dout_1 <= (stage_1[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_1 <= stage_1[39:16];
                if (stage_2[47:39] != {9{stage_2[47]}})
                    dout_2 <= (stage_2[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_2 <= stage_2[39:16];
                if (stage_3[47:39] != {9{stage_3[47]}})
                    dout_3 <= (stage_3[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_3 <= stage_3[39:16];
                if (stage_4[47:39] != {9{stage_4[47]}})
                    dout_4 <= (stage_4[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_4 <= stage_4[39:16];
                if (stage_5[47:39] != {9{stage_5[47]}})
                    dout_5 <= (stage_5[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_5 <= stage_5[39:16];
                if (stage_6[47:39] != {9{stage_6[47]}})
                    dout_6 <= (stage_6[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_6 <= stage_6[39:16];
                if (stage_7[47:39] != {9{stage_7[47]}})
                    dout_7 <= (stage_7[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_7 <= stage_7[39:16];
                if (stage_8[47:39] != {9{stage_8[47]}})
                    dout_8 <= (stage_8[47]) ? -24'sh800000 : 24'sh7FFFFF;
                else
                    dout_8 <= stage_8[39:16];
            end
        end
    end


endmodule