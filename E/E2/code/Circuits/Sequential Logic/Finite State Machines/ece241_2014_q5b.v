module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter A=0, B=1;
    
    reg [1:0]state, next_state;
    
    always @(*)begin
        next_state[A] = !x && state[A];
        next_state[B] = (state[A] && x) || (state[B]);
    end
    
    
    always @(posedge clk, posedge areset)begin
        if (areset) state <= 1;
        else state <= next_state;
        
    end
    
    assign z = (state[A] && x) || (state[B] && !x);
    
endmodule
