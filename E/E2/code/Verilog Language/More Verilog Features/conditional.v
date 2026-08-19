module way2_min(
    input[7:0] a, b,
    output[7:0] min);
    assign min = a > b ? b : a;
endmodule

module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);//
    
    wire [7:0] min_2_1; 
    wire [7:0] min_2_2;
    
    way2_min a_b_min(a, b, min_2_1);
    way2_min c_d_min(c, d, min_2_2);
    way2_min min1_min2(min_2_1, min_2_2, min);

endmodule
