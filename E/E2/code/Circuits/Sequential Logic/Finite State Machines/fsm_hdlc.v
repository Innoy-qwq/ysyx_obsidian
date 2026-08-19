module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    parameter NONE=4'h0,ONE=4'h1,TWO=4'h2,THREE=4'h3,FOUR=4'h4,FIVE=4'h5,SIX=4'h6,DISC=4'h7,DONE=4'h8,ERR=4'h9;
    reg [3:0] state, next_state;
    
    always @(*)begin
        case (state)
            NONE:begin
                if (in) next_state = ONE;
                else next_state = NONE;
            end
            ONE:begin
                if (in) next_state = TWO;
                else next_state = NONE;
            end
            TWO:begin
                if (in) next_state = THREE;
                else next_state = NONE;
            end
            THREE:begin
                if (in) next_state = FOUR;
                else next_state = NONE;
            end
            
            FOUR:begin
                if (in) next_state = FIVE;
                else next_state = NONE;
            end
            
            FIVE:begin
                if (in) next_state = SIX;
                else next_state = DISC;
            end
            
            SIX:begin
                if (in) next_state = ERR;
                else next_state = DONE;
            end
            
            DISC:begin
                if (in) next_state = ONE;
                else next_state = NONE;
            end
            
            DONE:begin
                if (in) next_state = ONE;
                else next_state = NONE;
            end
            
            ERR:begin
                if (in) next_state = ERR;
                else next_state = NONE;
            end
        endcase
    end
    
    always @(posedge clk)begin
        if (reset) state <= NONE;
        else begin
            state <= next_state;
        end
    end
    
    assign disc = (state == DISC);
    assign flag = (state == DONE);
    assign err = (state == ERR);
                
endmodule
