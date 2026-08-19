module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [31:0] sub_32;
    wire c;
    
    assign sub_32[31:0] = b[31:0] ^ {32{sub}};
    
    add16 add_bottom(a[15:0], sub_32[15:0], sub, sum[15:0], c);
    add16 add_upper(a[31:16], sub_32[31:16], c, sum[31:16], 1'b0);

endmodule
