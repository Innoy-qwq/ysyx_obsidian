module add_2(
    input a,
    input b,
    input cin,
	output sum,
    output cout);
    
    assign sum =a^b^cin;
    assign cout = (a&b) | (a&cin) | (b&cin);
endmodule

module top_module(
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum);
    
    genvar i;
    wire [100:0] carry;
    assign carry[0] = cin;
    
    generate
        for (i=0;i<100;i=i+1)begin: ad2
            add_2 ad2(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1]));
    	end
    endgenerate

    assign cout[99:0] = carry[100:1];

endmodule
