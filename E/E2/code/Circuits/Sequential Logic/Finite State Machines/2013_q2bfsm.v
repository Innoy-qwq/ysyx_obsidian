module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
);
    
    reg [3:0] state, next_state;
    parameter A=4'h0, A1=4'h1, S0=4'h2, S1=4'h3, S2=4'h4, G1=4'h5, G2=4'h6, N1=4'h7, N2=4'h8;
    
    always@(*)begin
        case(state)
            A:begin
                next_state = A1;
            end
            A1:begin
                next_state = S0;
            end
            S0:begin
                if(!x) next_state = S0;
                else next_state = S1;
            end
            S1:begin
                if(x) next_state = S1;
                else next_state = S2;
            end
            S2:begin
                if(!x) next_state = S0;
                else next_state = G1;
            end
            G1:begin
                if(y) next_state = N1;
                else next_state = G2;
            end
            G2:begin
                if(y) next_state = N1;
                else next_state = N2;
            end
            N1:begin
                next_state = N1;
            end
            N2:begin
                next_state = N2;
            end
        endcase
        
    end
    
    always@(posedge clk)begin
        if (!resetn) state <= A;
        else begin
           state <= next_state; 
        end
    end
    
    assign f = (state == A1);
    assign g = (state == G1) || (state == G2) || (state == N1);

endmodule
