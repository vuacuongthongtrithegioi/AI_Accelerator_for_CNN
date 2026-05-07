// Input buffer
module input_buffer_block (
    input clk, reset,
    input write_en,
    input read_en,

    input  signed [215:0] data_in,   
    output reg signed [215:0] data_out
);

    reg signed [215:0] buffer;

    always @(posedge clk) begin
        if (reset)
            buffer <= 0;
        else if (write_en)
            buffer <= data_in;
    end

    always @(posedge clk) begin
        if (reset)
            data_out <= 0;
        else if (read_en)
            data_out <= buffer;
    end

endmodule

module input_buffer_block_ctrl (
    input clk, reset,
    input start,

    output reg write_en,
    output reg read_en,
    output reg done
);

    reg [1:0] state;

    localparam IDLE  = 2'd0,
               WRITE = 2'd1,
               READ  = 2'd2,
               DONE  = 2'd3;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else begin
            case (state)

                IDLE:
                    if (start) state <= WRITE;

                WRITE:
                    state <= READ;

                READ:
                    state <= DONE;

                DONE:
                    state <= IDLE;

            endcase
        end
    end

    always @(*) begin
        write_en = 0;
        read_en  = 0;
        done     = 0;

        case (state)
            WRITE: write_en = 1;
            READ:  read_en  = 1;
            DONE:  done     = 1;
        endcase
    end

endmodule

module input_buffer_block_top (
    input clk, reset, start,

    input  signed [215:0] IFM_in,
    input  signed [215:0] WGT_in,

    output signed [215:0] IFM_out,
    output signed [215:0] WGT_out,

    output done
);

    wire write_en, read_en;

    input_buffer_block_ctrl ctrl (
        .clk(clk),
        .reset(reset),
        .start(start),
        .write_en(write_en),
        .read_en(read_en),
        .done(done)
    );

    input_buffer_block ifm_buf (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(IFM_in),
        .data_out(IFM_out)
    );

    input_buffer_block wgt_buf (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(WGT_in),
        .data_out(WGT_out)
    );

endmodule

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

module NPU (
    clk, reset, start,
    IFM_in, WGT_in,
    done_input_buffer, done_systolic_input, done_mac,
    cout_1, cout_2, cout_3,
    cout_4, cout_5, cout_6,
    cout_7, cout_8, cout_9,
    done_npu
);
    input clk, reset, start;
    input signed [215:0] IFM_in, WGT_in;
    output done_input_buffer, done_systolic_input, done_mac;
    output signed [47:0] cout_1, cout_2, cout_3;
    output signed [47:0] cout_4, cout_5, cout_6;
    output signed [47:0] cout_7, cout_8, cout_9;
    output done_npu;

    // Wires to connect input buffer outputs to the rest of the NPU
    wire [215:0] IFM_out, WGT_out;

    input_buffer_block_top input_buffer (
        .clk(clk),
        .reset(reset),
        .start(start),
        .IFM_in(IFM_in),
        .WGT_in(WGT_in),
        .IFM_out(IFM_out), 
        .WGT_out(WGT_out),
        .done(done_input_buffer)
    );

    // The rest of the NPU would go here, using IFM_out and WGT_out as inputs
    wire [23:0] a1_w, a2_w, a3_w;
    wire [23:0] b1_w, b2_w, b3_w;
    systolic_input_top systolic_input (
        .clk(clk),
        .reset(reset),
        .start(done_input_buffer), // Start systolic input after input buffer is done
        .IFM(IFM_out),
        .WGT(WGT_out),
        .a1(a1_w), .a2(a2_w), .a3(a3_w),
        .b1(b1_w), .b2(b2_w), .b3(b3_w),
        .done(done_systolic_input)
    );

    // Additional logic to connect the systolic input to the rest of the NPU would go here
    wire [47:0] c1_w, c2_w, c3_w, 
        c4_w, c5_w, c6_w, 
        c7_w, c8_w, c9_w;
    mac_top mac (
        .clk(clk),
        .reset(reset),
        .start(done_input_buffer), // Start MAC after input buffer is done
        .a1(a1_w), .a2(a2_w), .a3(a3_w),
        .b1(b1_w), .b2(b2_w), .b3(b3_w),
        .c1(c1_w), .c2(c2_w), .c3(c3_w),
        .c4(c4_w), .c5(c5_w), .c6(c6_w),
        .c7(c7_w), .c8(c8_w), .c9(c9_w),
        .done(done_mac) 
    );

    //Test outputs
    assign cout_1 = c1_w;
    assign cout_2 = c2_w;
    assign cout_3 = c3_w;
    assign cout_4 = c4_w;
    assign cout_5 = c5_w;
    assign cout_6 = c6_w;
    assign cout_7 = c7_w;
    assign cout_8 = c8_w;
    assign cout_9 = c9_w;
    assign done_npu = done_mac; // NPU is done when MAC is done
endmodule