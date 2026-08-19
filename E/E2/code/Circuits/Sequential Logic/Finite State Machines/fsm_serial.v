module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    
    reg [3:0] counter;
    reg [2:0] state;
    reg [2:0] next_state;
    
    parameter IDLE=3'h0, START=3'h1, DATA=3'h2, STOP=3'h3, WAIT_STOP = 3'd4;
    
    always @(*)begin
        case (state)
            IDLE:begin
                if (!in) next_state = START;
                else next_state = IDLE;
            end
            START:begin
                next_state = DATA;
            end
            DATA:begin
                if (counter == 8) begin 
                    if (in) next_state = STOP;
                    else next_state = WAIT_STOP;
                end
                else next_state = DATA;
            end
            STOP:begin
                if (!in) next_state = START;
                else next_state = IDLE;
            end
            WAIT_STOP:begin
                if (in) next_state = IDLE;
                else next_state = WAIT_STOP;
            end
            
        endcase
        
    end
    
    
    always @(posedge clk)begin
        if(reset) begin
            state <= IDLE;
            counter <= 0;
        end
        else begin
            state <= next_state;
            if (next_state == DATA) counter <= counter + 1;
            else counter <= 0;
        end
    end
    
    assign done = (state == STOP);

endmodule
