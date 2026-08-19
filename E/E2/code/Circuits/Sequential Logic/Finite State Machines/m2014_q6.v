module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);
    
    parameter A=3'h0, B=3'h1, C=3'h2,D=3'h3, E=3'h4, F=3'h5;
    reg [3:1]Y, y;
    
    always@(*)begin
        case(y)
            A: Y = w ? A : B;
            B: Y = w ? D : C;
            C: Y = w ? D : E;
            D: Y = w ? A : F;
            E: Y = w ? D : E;
            F: Y = w ? D : C;
        endcase
    end
    
    always@(posedge clk)begin
        if (reset) y <= A;
        else y <= Y;
    end
    
    assign z = (y == E) || (y == F);

endmodule
