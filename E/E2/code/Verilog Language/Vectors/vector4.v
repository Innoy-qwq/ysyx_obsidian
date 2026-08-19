module top_module (
    input [7:0] in,
    output [31:0] out );//

    wire [23:0]sign;
    
    assign sign[23:0] = {24{in[7]}};
    assign out[31:0] = {sign[23:0], in[7:0]};

endmodule
