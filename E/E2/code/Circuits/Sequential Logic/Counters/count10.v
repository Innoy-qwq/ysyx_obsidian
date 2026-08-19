module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output [3:0] q);

    always @(posedge clk)begin
    	q <= q+1;
        if (q == 4'h9) q <= 0;
        if (reset) q <= 0;
    end

endmodule
