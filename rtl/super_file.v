//Input Buffer for Systolic Array
module systolic_input_buffer #(parameter DW=24)(
    input clk, reset,
    input load,
    input [2:0] cycle,

    input signed [DW-1:0] A00,A01,A02,
    input signed [DW-1:0] A10,A11,A12,
    input signed [DW-1:0] A20,A21,A22,

    input signed [DW-1:0] B00,B01,B02,
    input signed [DW-1:0] B10,B11,B12,
    input signed [DW-1:0] B20,B21,B22,

    output reg signed [DW-1:0] a1,a2,a3,
    output reg signed [DW-1:0] b1,b2,b3
);

    reg signed [DW-1:0] rA00,rA01,rA02;
    reg signed [DW-1:0] rA10,rA11,rA12;
    reg signed [DW-1:0] rA20,rA21,rA22;

    reg signed [DW-1:0] rB00,rB01,rB02;
    reg signed [DW-1:0] rB10,rB11,rB12;
    reg signed [DW-1:0] rB20,rB21,rB22;

    always @(posedge clk) begin
        if (reset) begin
            rA00<=0; rA01<=0; rA02<=0;
            rA10<=0; rA11<=0; rA12<=0;
            rA20<=0; rA21<=0; rA22<=0;

            rB00<=0; rB01<=0; rB02<=0;
            rB10<=0; rB11<=0; rB12<=0;
            rB20<=0; rB21<=0; rB22<=0;
        end
        else if (load) begin
            rA00<=A00; rA01<=A01; rA02<=A02;
            rA10<=A10; rA11<=A11; rA12<=A12;
            rA20<=A20; rA21<=A21; rA22<=A22;

            rB00<=B00; rB01<=B01; rB02<=B02;
            rB10<=B10; rB11<=B11; rB12<=B12;
            rB20<=B20; rB21<=B21; rB22<=B22;
        end
    end

    always @(*) begin
        case (cycle)

            3'd1: begin
                a1 = rA00; a2 = 0;     a3 = 0;
                b1 = rB00; b2 = 0;     b3 = 0;
            end

            3'd2: begin
                a1 = rA01; a2 = rA10;  a3 = 0;
                b1 = rB10; b2 = rB01;  b3 = 0;
            end

            3'd3: begin
                a1 = rA02; a2 = rA11;  a3 = rA20;
                b1 = rB20; b2 = rB11;  b3 = rB02;
            end

            3'd4: begin
                a1 = 0;     a2 = rA12; a3 = rA21;
                b1 = 0;     b2 = rB21; b3 = rB12;
            end

            3'd5: begin
                a1 = 0;     a2 = 0;     a3 = rA22;
                b1 = 0;     b2 = 0;     b3 = rB22;
            end

            3'd6: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

            3'd7: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

            3'd8: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

            default: begin
                a1 = 0; a2 = 0; a3 = 0;
                b1 = 0; b2 = 0; b3 = 0;
            end

        endcase
    end

endmodule

module systolic_input_buffer_ctl (
    input clk, reset,
    input start,

    output reg load,
    output reg [2:0] cycle, 
    output reg done
);

    reg [1:0] state;

    localparam IDLE  = 2'd0,
               LOAD  = 2'd1,
               FEED  = 2'd2,
               DONE  = 2'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cycle <= 0;
            load  <= 0;
            done  <= 0;
        end else begin
            case (state)

                IDLE: begin
                    done  <= 0;
                    load  <= 0;
                    cycle <= 0;

                    if (start)
                        state <= LOAD;
                end

                LOAD: begin
                    load  <= 1;
                    cycle <= 0;
                    state <= FEED;
                end

                FEED: begin
                    load <= 0;

                    if (cycle == 3'd6)
                        state <= DONE;
                    else
                        cycle <= cycle + 1;
                end

                DONE: begin
                    done  <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule

module systolic_input_top #(parameter DW=24)(
    input clk, reset, start,

    input signed [215:0] IFM,
    input signed [215:0] WGT,

    output signed [DW-1:0] a1,a2,a3,
    output signed [DW-1:0] b1,b2,b3,
    output done
);
    wire [2:0] cycle;
    wire load;

    wire signed [23:0] A00 = IFM[215:192];
    wire signed [23:0] A01 = IFM[191:168];
    wire signed [23:0] A02 = IFM[167:144];

    wire signed [23:0] A10 = IFM[143:120];
    wire signed [23:0] A11 = IFM[119:96];
    wire signed [23:0] A12 = IFM[95:72];

    wire signed [23:0] A20 = IFM[71:48];
    wire signed [23:0] A21 = IFM[47:24];
    wire signed [23:0] A22 = IFM[23:0];

    wire signed [23:0] B00 = WGT[215:192];
    wire signed [23:0] B01 = WGT[191:168];
    wire signed [23:0] B02 = WGT[167:144];

    wire signed [23:0] B10 = WGT[143:120];
    wire signed [23:0] B11 = WGT[119:96];
    wire signed [23:0] B12 = WGT[95:72];

    wire signed [23:0] B20 = WGT[71:48];
    wire signed [23:0] B21 = WGT[47:24];
    wire signed [23:0] B22 = WGT[23:0];

    systolic_input_buffer_ctl ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),
        .load(load),
        .cycle(cycle),
        .done(done)
    );

    systolic_input_buffer buffer (
        .clk(clk),
        .reset(reset),
        .load(load),
        .cycle(cycle),

        .A00(A00), .A01(A01), .A02(A02),
        .A10(A10), .A11(A11), .A12(A12),
        .A20(A20), .A21(A21), .A22(A22),

        .B00(B00), .B01(B01), .B02(B02),
        .B10(B10), .B11(B11), .B12(B12),
        .B20(B20), .B21(B21), .B22(B22),

        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3)
    );

endmodule

//MAC Unit for Systolic Array
module pe(
    clk, reset, clear,
    in_a, in_b,
    out_a, out_b,
    out_c
);
    input wire clk, reset, clear;
    input wire signed [23:0] in_a, in_b;
    output reg signed [23:0] out_a, out_b;
    output reg signed [47:0] out_c;

    always @(posedge clk) begin
        if (reset || clear) begin
            out_a <= 0;
            out_b <= 0;
            out_c <= 0;
        end else begin
            out_a <= in_a;
            out_b <= in_b;
            out_c <= out_c + in_a * in_b;
        end
    end
endmodule

module matrix_multiplication(
    clk, reset, clear,
    a1, a2, a3,
    b1, b2, b3,
    c1, c2, c3,
    c4, c5, c6,
    c7, c8, c9
);

    input wire clk, reset, clear;
    input wire signed [23:0] a1, a2, a3;
    input wire signed [23:0] b1, b2, b3;
    output wire signed [47:0] c1, c2, c3;
    output wire signed [47:0] c4, c5, c6;
    output wire signed [47:0] c7, c8, c9;

    wire signed [23:0] a12, a23, a45, a56, a78, a89;
    wire signed [23:0] b14, b25, b36, b47, b58, b69;

    wire signed [47:0] pe_c1, pe_c2, pe_c3, 
                pe_c4, pe_c5, pe_c6,
                pe_c7, pe_c8, pe_c9;

    pe pe1 (.clk(clk), .reset(reset), .clear(clear), .in_a(a1),  .in_b(b1),  .out_a(a12), .out_b(b14), .out_c(pe_c1));
    pe pe2 (.clk(clk), .reset(reset), .clear(clear), .in_a(a12), .in_b(b2),  .out_a(a23), .out_b(b25), .out_c(pe_c2));
    pe pe3 (.clk(clk), .reset(reset), .clear(clear), .in_a(a23), .in_b(b3),  .out_a(),    .out_b(b36), .out_c(pe_c3));

    pe pe4 (.clk(clk), .reset(reset), .clear(clear), .in_a(a2),  .in_b(b14), .out_a(a45), .out_b(b47), .out_c(pe_c4));
    pe pe5 (.clk(clk), .reset(reset), .clear(clear), .in_a(a45), .in_b(b25), .out_a(a56), .out_b(b58), .out_c(pe_c5));
    pe pe6 (.clk(clk), .reset(reset), .clear(clear), .in_a(a56), .in_b(b36), .out_a(),    .out_b(b69), .out_c(pe_c6));

    pe pe7 (.clk(clk), .reset(reset), .clear(clear), .in_a(a3),  .in_b(b47), .out_a(a78), .out_b(),    .out_c(pe_c7));
    pe pe8 (.clk(clk), .reset(reset), .clear(clear), .in_a(a78), .in_b(b58), .out_a(a89), .out_b(),    .out_c(pe_c8));
    pe pe9 (.clk(clk), .reset(reset), .clear(clear), .in_a(a89), .in_b(b69), .out_a(),    .out_b(),    .out_c(pe_c9));

    assign c1 = pe_c1[47:0];
    assign c2 = pe_c2[47:0];
    assign c3 = pe_c3[47:0];
    assign c4 = pe_c4[47:0];
    assign c5 = pe_c5[47:0];
    assign c6 = pe_c6[47:0];
    assign c7 = pe_c7[47:0];
    assign c8 = pe_c8[47:0];
    assign c9 = pe_c9[47:0];

endmodule

module SystolicController (
    input wire clk,
    input wire reset,
    input wire start,

    output reg clear,
    output reg valid,
    output reg done,
    output reg [2:0] cycle
);

    reg [1:0] state;

    localparam IDLE  = 2'd0;
    localparam CLEAR = 2'd1;
    localparam RUN   = 2'd2;
    localparam DONE  = 2'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cycle <= 0;
        end else begin
            case (state)

                IDLE: begin
                    cycle <= 0;
                    if (start)
                        state <= CLEAR;  
                end

                CLEAR: begin
                    cycle <= 0;          
                    state <= RUN;        
                end

                RUN: begin
                    cycle <= cycle + 1;  

                    if (cycle == 7)
                        state <= DONE;
                end

                DONE: begin
                    state <= IDLE;
                end

            endcase
        end
    end

    always @(*) begin
        clear = 0;
        valid = 0;
        done  = 0;

        case (state)
            IDLE: begin
                clear = 0;
            end

            CLEAR: begin
                clear = 1; 
            end

            RUN: begin
                valid = (cycle >= 1); 
            end

            DONE: begin
                done = 1;
            end
        endcase
    end

endmodule

module mac_top #(parameter DW=24)(
    input clk, reset, start,

    input signed [DW-1:0] a1,a2,a3,
    input signed [DW-1:0] b1,b2,b3,

    output signed [47:0] c1,c2,c3,
    output signed [47:0] c4,c5,c6,
    output signed [47:0] c7,c8,c9,

    output done
);

    wire clear, valid;
    wire [2:0] cycle;

    SystolicController ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),

        .clear(clear),
        .valid(valid),
        .done(done),
        .cycle(cycle)
    );

    wire signed [DW-1:0] a1_g, a2_g, a3_g;
    wire signed [DW-1:0] b1_g, b2_g, b3_g;

    assign a1_g = valid ? a1 : 0;
    assign a2_g = valid ? a2 : 0;
    assign a3_g = valid ? a3 : 0;

    assign b1_g = valid ? b1 : 0;
    assign b2_g = valid ? b2 : 0;
    assign b3_g = valid ? b3 : 0;

    matrix_multiplication systolic (
        .clk(clk),
        .reset(reset),
        .clear(clear),

        .a1(a1_g), .a2(a2_g), .a3(a3_g),
        .b1(b1_g), .b2(b2_g), .b3(b3_g),

        .c1(c1), .c2(c2), .c3(c3),
        .c4(c4), .c5(c5), .c6(c6),
        .c7(c7), .c8(c8), .c9(c9)
    );

endmodule

//Quantization and ReLU
module Q16_32_to_Q8_16_pipe (
    input  wire clk,
    input  wire reset,
    input  wire enable,

    input  wire signed [47:0] din_0, din_1, din_2, din_3, din_4, din_5, din_6, din_7, din_8,
    output reg  signed [23:0] dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, dout_8,
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

module ReLU (
    input clk, reset, relu_en,

    input signed [47:0] in_0, in_1, in_2,
    input signed [47:0] in_3, in_4, in_5,
    input signed [47:0] in_6, in_7, in_8,

    output signed [47:0] out_0, out_1, out_2,
    output signed [47:0] out_3, out_4, out_5,
    output signed [47:0] out_6, out_7, out_8,

    output reg done
);

    reg signed [47:0] out_0_reg, out_1_reg, out_2_reg;
    reg signed [47:0] out_3_reg, out_4_reg, out_5_reg;
    reg signed [47:0] out_6_reg, out_7_reg, out_8_reg;
    reg relu_en_d;

    always @(posedge clk) begin
        if (reset) begin
            out_0_reg <= 0; out_1_reg <= 0; out_2_reg <= 0;
            out_3_reg <= 0; out_4_reg <= 0; out_5_reg <= 0;
            out_6_reg <= 0; out_7_reg <= 0; out_8_reg <= 0;
        end
        else if (relu_en) begin
            out_0_reg <= (in_0 < 0) ? 0 : in_0;
            out_1_reg <= (in_1 < 0) ? 0 : in_1;
            out_2_reg <= (in_2 < 0) ? 0 : in_2;

            out_3_reg <= (in_3 < 0) ? 0 : in_3;
            out_4_reg <= (in_4 < 0) ? 0 : in_4;
            out_5_reg <= (in_5 < 0) ? 0 : in_5;

            out_6_reg <= (in_6 < 0) ? 0 : in_6;
            out_7_reg <= (in_7 < 0) ? 0 : in_7;
            out_8_reg <= (in_8 < 0) ? 0 : in_8;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            relu_en_d <= 0;
            done <= 0;
        end else begin
            relu_en_d <= relu_en;
            done <= relu_en_d; 
        end
    end

    assign out_0 = out_0_reg;
    assign out_1 = out_1_reg;
    assign out_2 = out_2_reg;
    assign out_3 = out_3_reg;
    assign out_4 = out_4_reg;
    assign out_5 = out_5_reg;
    assign out_6 = out_6_reg;
    assign out_7 = out_7_reg;
    assign out_8 = out_8_reg;

endmodule

//Output Buffer for Systolic Array
module buffer_out (
    clk, reset, load,
    c1_in, c2_in, c3_in, 
    c4_in, c5_in, c6_in, 
    c7_in, c8_in, c9_in, 
    c1_out, c2_out, c3_out,
    c4_out, c5_out, c6_out,
    c7_out, c8_out, c9_out
);
    input clk, reset;
    input load;
    input signed [47:0] c1_in, c2_in, c3_in;
    input signed [47:0] c4_in, c5_in, c6_in;
    input signed [47:0] c7_in, c8_in, c9_in;
    output signed [47:0] c1_out, c2_out, c3_out;
    output signed [47:0] c4_out, c5_out, c6_out;
    output signed [47:0] c7_out, c8_out, c9_out;

    reg signed [47:0] rC1, rC2, rC3;
    reg signed [47:0] rC4, rC5, rC6;
    reg signed [47:0] rC7, rC8, rC9;

    always @(posedge clk) begin
        if (reset) begin
            rC1<=0; rC2<=0; rC3<=0;
            rC4<=0; rC5<=0; rC6<=0;
            rC7<=0; rC8<=0; rC9<=0;
        end
        else if (load) begin
            rC1<=c1_in; rC2<=c2_in; rC3<=c3_in;
            rC4<=c4_in; rC5<=c5_in; rC6<=c6_in;
            rC7<=c7_in; rC8<=c8_in; rC9<=c9_in;
        end
    end

    assign c1_out = rC1;
    assign c2_out = rC2;
    assign c3_out = rC3;
    assign c4_out = rC4;
    assign c5_out = rC5;
    assign c6_out = rC6;
    assign c7_out = rC7;
    assign c8_out = rC8;
    assign c9_out = rC9;

endmodule

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

module output_buffer_top (
    input clk, reset,
    input done_systolic,

    input signed [47:0] c1_in, c2_in, c3_in,
    input signed [47:0] c4_in, c5_in, c6_in,
    input signed [47:0] c7_in, c8_in, c9_in,

    output signed [47:0] c1_out, c2_out, c3_out,
    output signed [47:0] c4_out, c5_out, c6_out,
    output signed [47:0] c7_out, c8_out, c9_out,

    output reg done
);

    wire load;
    reg load_d;

    output_buffer_ctl out_ctl (
        .clk(clk), 
        .reset(reset),
        .done_sytolic(done_systolic),
        .load(load)
    );

    buffer_out u_buffer_out (
        .clk(clk), .reset(reset), .load(load),
        .c1_in(c1_in), .c2_in(c2_in), .c3_in(c3_in),
        .c4_in(c4_in), .c5_in(c5_in), .c6_in(c6_in),
        .c7_in(c7_in), .c8_in(c8_in), .c9_in(c9_in),
        .c1_out(c1_out), .c2_out(c2_out), .c3_out(c3_out),
        .c4_out(c4_out), .c5_out(c5_out), .c6_out(c6_out),
        .c7_out(c7_out), .c8_out(c8_out), .c9_out(c9_out)
    );

    always @(posedge clk) begin
        if (reset) begin
            load_d <= 0;
            done <= 0;
        end else begin
            load_d <= load;
            done <= load_d;   
        end
    end 
endmodule

module NPU (
    input clk, reset, start,
    input signed [215:0] IFM,
    input signed [215:0] WGT,
    output done;
    output signed [47:0] OFM_1, OFM_2, OFM_3,
    output signed [47:0] OFM_4, OFM_5, OFM_6,
    output signed [47:0] OFM_7, OFM_8, OFM_9,
);
    //variable for input buffer
    wire signed [23:0] IFM_BUF_1, IFM_BUF_2, IFM_BUF_3;
    wire signed [23:0] WGT_BUF_1, WGT_BUF_2, WGT_BUF_3;
    wire input_buffer_done;

    systolic_input_top #(.DW(24)) input_buffer (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM(IFM),
        .WGT(WGT),
        .a1(IFM_BUF_1), .a2(IFM_BUF_2), .a3(IFM_BUF_3),
        .b1(WGT_BUF_1), .b2(WGT_BUF_2), .b3(WGT_BUF_3),
        .done(input_buffer_done)
    );

    //variable for MAC unit
    wire signed [47:0] MAC_OUT_1, MAC_OUT_2, MAC_OUT_3;
    wire signed [47:0] MAC_OUT_4, MAC_OUT_5, MAC_OUT_6;
    wire signed [47:0] MAC_OUT_7, MAC_OUT_8, MAC_OUT_9;
    wire mac_done;

    mac_top #(.DW(24)) mac_unit (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a1(IFM_BUF_1), .a2(IFM_BUF_2), .a3(IFM_BUF_3),
        .b1(WGT_BUF_1), .b2(WGT_BUF_2), .b3(WGT_BUF_3),
        .c1(MAC_OUT_1), .c2(MAC_OUT_2), .c3(MAC_OUT_3),
        .c4(MAC_OUT_4), .c5(MAC_OUT_5), .c6(MAC_OUT_6),
        .c7(MAC_OUT_7), .c8(MAC_OUT_8), .c9(MAC_OUT_9),
        .done(mac_done)
    );

    //variable for quantization
    wire signed [23:0] Q_OUT_1, Q_OUT_2, Q_OUT_3;
    wire signed [23:0] Q_OUT_4, Q_OUT_5, Q_OUT_6;
    wire signed [23:0] Q_OUT_7, Q_OUT_8, Q_OUT_9;
    wire q_done;

    Q16_32_to_Q8_16_pipe cut_bit (
        .clk(clk),
        .reset(reset),
        .enable(mac_done),
        .din_0(MAC_OUT_1), .din_1(MAC_OUT_2), .din_2(MAC_OUT_3),
        .din_3(MAC_OUT_4), .din_4(MAC_OUT_5), .din_5(MAC_OUT_6),
        .din_6(MAC_OUT_7), .din_7(MAC_OUT_8), .din_8(MAC_OUT_9),
        .dout_0(Q_OUT_1), .dout_1(Q_OUT_2), .dout_2(Q_OUT_3),
        .dout_3(Q_OUT_4), .dout_4(Q_OUT_5), .dout_5(Q_OUT_6),
        .dout_6(Q_OUT_7), .dout_7(Q_OUT_8), .dout_8(Q_OUT_9),
        .done(q_done)
    );

    //variable for ReLU
    wire signed [47:0] RELU_OUT_1, RELU_OUT_2, RELU_OUT_3;
    wire signed [47:0] RELU_OUT_4, RELU_OUT_5, RELU_OUT_6;
    wire signed [47:0] RELU_OUT_7, RELU_OUT_8, RELU_OUT_9;
    wire relu_done;

    ReLU relu (
        .clk(clk),
        .reset(reset),
        .relu_en(q_done),
        .done(relu_done),
        .in_0(Q_OUT_1), .in_1(Q_OUT_2), .in_2(Q_OUT_3),
        .in_3(Q_OUT_4), .in_4(Q_OUT_5), .in_5(Q_OUT_6),
        .in_6(Q_OUT_7), .in_7(Q_OUT_8), .in_8(Q_OUT_9),
        .out_0(RELU_OUT_1), .out_1(RELU_OUT_2), .out_2(RELU_OUT_3),
        .out_3(RELU_OUT_4), .out_4(RELU_OUT_5), .out_5(RELU_OUT_6),
        .out_6(RELU_OUT_7), .out_7(RELU_OUT_8), .out_8(RELU_OUT_9)
    );

    //variable for output buffer
    wire signed [47:0] OFM_BUF_1, OFM_BUF_2, OFM_BUF_3;
    wire signed [47:0] OFM_BUF_4, OFM_BUF_5, OFM_BUF_6;
    wire signed [47:0] OFM_BUF_7, OFM_BUF_8, OFM_BUF_9;
    wire done_output_buffer;

    output_buffer_top out_buffer (
        .clk(clk),
        .reset(reset),
        .done_systolic(relu_done),
        .c1_in(RELU_OUT_1), .c2_in(RELU_OUT_2), .c3_in(RELU_OUT_3),
        .c4_in(RELU_OUT_4), .c5_in(RELU_OUT_5), .c6_in(RELU_OUT_6),
        .c7_in(RELU_OUT_7), .c8_in(RELU_OUT_8), .c9_in(RELU_OUT_9),
        .c1_out(OFM_BUF_1), .c2_out(OFM_BUF_2), .c3_out(OFM_BUF_3),
        .c4_out(OFM_BUF_4), .c5_out(OFM_BUF_5), .c6_out(OFM_BUF_6),
        .c7_out(OFM_BUF_7), .c8_out(OFM_BUF_8), .c9_out(OFM_BUF_9)
    );

    assign OFM_1 = OFM_BUF_1;
    assign OFM_2 = OFM_BUF_2;
    assign OFM_3 = OFM_BUF_3;
    assign OFM_4 = OFM_BUF_4;
    assign OFM_5 = OFM_BUF_5;
    assign OFM_6 = OFM_BUF_6;
    assign OFM_7 = OFM_BUF_7;
    assign OFM_8 = OFM_BUF_8;
    assign OFM_9 = OFM_BUF_9;
    assign done = done_output_buffer;
endmodule