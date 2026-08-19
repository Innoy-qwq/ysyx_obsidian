module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 
    integer i;
    always @(posedge clk)begin
        if (reset) q <= 32'h1;
        else begin
            for (i=31;i>0;i=i-1)begin
                if (i == 22 | i == 2 | i == 1) q[i-1] <= q[i] ^ q[0];
                else q[i-1] <= q[i];
            end
            q[31] <= q[0] ^ 0;
        end
    end
endmodule
