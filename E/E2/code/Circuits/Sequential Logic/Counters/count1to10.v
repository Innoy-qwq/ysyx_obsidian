module top_module (
    input clk,
    input reset,
    output [3:0] q);
    
    always @(posedge clk)begin
       	q <= q+1;
        if (reset) q <= 1;
        if (q == 4'ha) q <= 4'h1; 
    end

endmodule
