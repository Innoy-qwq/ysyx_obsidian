module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    
endmodule

module top_module (
    input [3:0] x,
    input [3:0] y, 
    output [4:0] sum);
    
    wire [2:0] c;
    
    full_adder FA1(x[0], y[0], 0, sum[0], c[0]);
    full_adder FA2(x[1], y[1], c[0], sum[1], c[1]);
    full_adder FA3(x[2], y[2], c[1], sum[2], c[2]);
    full_adder FA4(x[3], y[3], c[2], sum[3], sum[4]);
    

endmodule
