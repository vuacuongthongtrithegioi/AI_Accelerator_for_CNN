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