module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    wire [511:0] left;
    wire [511:0] right;
    
    assign left = {1'h0, q[511:1]};
    assign right = {q[510:0], 1'h0};
    
    always @(posedge clk)begin
        if (load) 
            q <= data;
        else
            q <= (q & ~right)
            | (~left & right)
            | (left & ~q & right);
    end

endmodule
