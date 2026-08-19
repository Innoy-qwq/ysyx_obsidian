module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    
    reg [31:0] old;
    always @(posedge clk)begin
        out <= (old & ~in) | out;
        if (reset) out <= 32'h00;
        old <= in; 
    end

endmodule
