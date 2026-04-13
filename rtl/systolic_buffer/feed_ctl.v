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

                    if (cycle == 3'd7)
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