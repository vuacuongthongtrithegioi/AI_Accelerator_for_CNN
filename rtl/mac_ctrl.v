module SimplifiedMasterController(
    clk, reset, start,
    A00, A01, A02,
    A10, A11, A12,
    A20, A21, A22,
    B00, B01, B02,
    B10, B11, B12,
    B20, B21, B22,
    a1, a2, a3,
    b1, b2, b3,
    done, clear
);
    input wire clk;
    input wire reset;
    input wire start;

    input wire [23:0] A00, A01, A02;
    input wire [23:0] A10, A11, A12;
    input wire [23:0] A20, A21, A22;

    input wire [23:0] B00, B01, B02;
    input wire [23:0] B10, B11, B12;
    input wire [23:0] B20, B21, B22;

    output reg [23:0] a1, a2, a3;
    output reg [23:0] b1, b2, b3;

    output reg done;
    output reg clear;

    reg [2:0] cycle;
    reg [1:0] state;

    localparam IDLE = 0,
               CLEAR = 1,
               FEED = 2,
               DONE = 3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cycle <= 0;
            a1 <= 0; a2 <= 0; a3 <= 0;
            b1 <= 0; b2 <= 0; b3 <= 0;
            done <= 0; clear <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) state <= CLEAR;
                end

                CLEAR: begin
                    clear <= 1;
                    cycle <= 0;
                    state <= FEED;
                end

                FEED: begin
                    clear <= 0;

                    case (cycle)
                        3'd0: begin
                            a1 <= A00; a2 <= 0;   a3 <= 0;
                            b1 <= B00; b2 <= 0;   b3 <= 0;
                        end
                        3'd1: begin
                            a1 <= A01; a2 <= A10; a3 <= 0;
                            b1 <= B10; b2 <= B01; b3 <= 0;
                        end
                        3'd2: begin
                            a1 <= A02; a2 <= A11; a3 <= A20;
                            b1 <= B20; b2 <= B11; b3 <= B02;
                        end
                        3'd3: begin
                            a1 <= 0;   a2 <= A12; a3 <= A21;
                            b1 <= 0;   b2 <= B21; b3 <= B12;
                        end
                        3'd4: begin
                            a1 <= 0;   a2 <= 0;   a3 <= A22;
                            b1 <= 0;   b2 <= 0;   b3 <= B22;
                        end
                        default: begin
                            a1 <= 0; a2 <= 0; a3 <= 0;
                            b1 <= 0; b2 <= 0; b3 <= 0;
                        end
                    endcase

                    if (cycle == 3'd7)
                        state <= DONE;
                    else
                        cycle <= cycle + 1;
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule