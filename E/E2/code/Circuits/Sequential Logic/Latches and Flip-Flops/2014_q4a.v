module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    wire d, e;
    
    always@(*)begin
        if (E) e <= w;
        else e <= Q;
    end
    
    always@(*)begin
        if (L) d <= R;
        else d <= e;
    end
    
    always@(posedge clk)begin
    	Q <= d;
    end

endmodule
