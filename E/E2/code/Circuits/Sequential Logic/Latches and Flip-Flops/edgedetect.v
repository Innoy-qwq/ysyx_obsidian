module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    reg [7:0] old;
    always @(posedge clk)begin
        pedge <= ~old & in;
        old <= in; 
    end
    

endmodule
