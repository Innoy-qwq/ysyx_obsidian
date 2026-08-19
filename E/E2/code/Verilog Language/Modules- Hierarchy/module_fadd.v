module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);//
    
    wire c;
    
    add16 add_bottom(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(c)
    );
    
    add16 add_up(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(c),
        .sum(sum[31:16]),
        .cout(1'b0)
    );

endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );
    
	assign sum = a ^ b ^ cin;
	assign cout = (a & b) | (cin & (a ^ b));
    
endmodule
