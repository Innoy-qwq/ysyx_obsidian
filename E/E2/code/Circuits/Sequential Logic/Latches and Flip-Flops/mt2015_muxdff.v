module dff1 (
	input zero,
    input one,
    input l,
	input clk,
	output q);
    
    wire d;
    
    always @(*)begin
        if (l) d <= one;
        else d <= zero;
    end
    
    always @(posedge clk)begin
    	q <= d;
    end

endmodule

module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);
    
    dff1 exp1(
        .zero(q_in),
        .one(r_in),
        .l(L),
        .clk(clk),
        .q(Q));
    
endmodule
