module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);
    parameter A=3'h0,B=3'h1,C=3'h2,D=3'h3,E=3'h4;
    reg [2:0] state, next_state;
    
    always@(*)begin
        case(state)
            A:begin
                if (!x) next_state = A;
                else next_state = B;
            end
            B:begin
                if (!x) next_state = B;
                else next_state = E;
            end
            C:begin
                if (!x) next_state = C;
                else next_state = B;
            end
            D:begin
                if (!x) next_state = B;
                else next_state = C;
            end
            E:begin
                if (!x) next_state = D;
                else next_state = E;
            end
            
        endcase
    end
    
    always@(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end
    
    assign z = (state == D) || (state == E);

endmodule
