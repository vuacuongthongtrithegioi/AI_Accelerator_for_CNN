module buffer_ctl #(
    parameter DEPTH = 4
)(
    input clk, reset, start,
    input mode,

    input full, empty,

    output reg write_en, read_en,
    output reg done
);
    localparam IDLE  = 2'd0;
    localparam WRITE = 2'd1;
    localparam READ  = 2'd2;
    localparam DONE  = 2'd3;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if(reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(start) begin
                    if(mode == 0 && !full)
                        next_state = WRITE;
                    else if(mode == 1 && !empty)
                        next_state = READ;
                end
            end
            WRITE: begin
                next_state = DONE;
            end
            READ: begin
                next_state = DONE;
            end
            DONE: begin
                if(!start)
                    next_state = IDLE;
            end

        endcase
    end
    always @(*) begin
        write_en = 0;
        read_en  = 0;
        done     = 0;
        case(state)
            WRITE: begin
                write_en = 1;
            end
            READ: begin
                read_en = 1;
            end
            DONE: begin
                done = 1;
            end
        endcase
    end
endmodule