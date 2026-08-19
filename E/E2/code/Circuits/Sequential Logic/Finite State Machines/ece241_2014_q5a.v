module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    reg [1:0] state, next_state;
    parameter OFF=2'h0, ON=2'h1, C=2'h2;
    
    always @(*)begin
        case (state)
            OFF:begin 
                if (x) next_state = OFF;
                else next_state = ON;
            end
            
            ON:begin
                if (x) next_state = OFF;
                else next_state = ON;
            end
            
            C:begin
                if (x) next_state = ON;
                else next_state = C;
            end
        endcase
    end
    
    always @(posedge clk, posedge areset)begin
        if (areset) state <= C;
        else state <= next_state;
    end
    
    assign z = (state == ON);

endmodule
