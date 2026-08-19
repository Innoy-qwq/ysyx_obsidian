module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    
    reg [3:0] state, next_state;
    wire r1 = r[1];
    wire r2 = r[2];
    wire r3 = r[3];
    
    wire SA = state[0];
    wire SB = state[1];
    wire SC = state[2];
    wire SD = state[3];
    
    always@(*)begin
        next_state[0] = (SA && !r1 && !r2 && !r3) || (SB && !r1) || (SC && !r2) || (SD && !r3);
        next_state[1] = (SA && r1) || (SB && r1);
        next_state[2] = (SA && !r1 && r2) || (SC && r2);
        next_state[3] = (SA && !r1 && !r2 && r3) || (SD && r3);
    end
    
    always@(posedge clk)begin
        if (!resetn) state <= 4'b0001;
        else state <= next_state;
    end

    assign g = state[3:1];
    
endmodule
