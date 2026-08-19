module A(input x, input y, output z);
    assign z = (x^y) & x;
endmodule

module B(input x, input y, output z );
    assign z = (~x & ~y) | (x & y);
endmodule

module top_module (input x, input y, output z);
	wire z1,z2,z3,z4,w1,w2;

    A test1(x, y, z1);
    B test2(x, y, z2);
    A test3(x, y, z3);
    B test4(x, y, z4);

    assign w1 = z1 | z2;
    assign w2 = z3 & z4;
    assign z = w1 ^ w2;
    
    
endmodule
