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
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
	
    dff1 exp1(
        .zero(LEDR[2]),
        .one(SW[0]),
        .l(KEY[1]),
        .clk(KEY[0]),
        .q(LEDR[0]));
    
    dff1 exp2(
        .zero(LEDR[0]),
        .one(SW[1]),
        .l(KEY[1]),
        .clk(KEY[0]),
        .q(LEDR[1]));

    dff1 exp3(
        .zero(LEDR[1] ^ LEDR[2]),
        .one(SW[2]),
        .l(KEY[1]),
        .clk(KEY[0]),
        .q(LEDR[2]));

endmodule
