module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter fir=2'h0,sec=2'h1,NONE=2'h2;
    reg [1:0] state, next_state;
    
    always @(*)begin
        case (state)
            fir:begin
                if (!x) next_state = sec;
                else next_state = fir;
            end
            sec:begin
                if (x) next_state = fir;
                else next_state = NONE;
            end
            NONE:begin
                if (x) next_state = fir;
                else next_state = NONE;
            end
        endcase
    end
    
    always @(posedge clk or negedge aresetn)begin
        if (!aresetn) state <= NONE;
        else begin
            state <= next_state;
        end
    end
    
    assign z = x & (state == sec);
    
endmodule
