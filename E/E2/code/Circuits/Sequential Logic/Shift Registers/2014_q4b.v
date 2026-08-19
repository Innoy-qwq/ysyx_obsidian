module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    
    MUXDFF exp1(
        .w(KEY[3]),
        .r(SW[3]),
        .clk(KEY[0]),
        .e(KEY[1]),
        .l(KEY[2]),
        .q(LEDR[3]));
    
    MUXDFF exp2(
        .w(LEDR[3]),
        .r(SW[2]),
        .clk(KEY[0]),
        .e(KEY[1]),
        .l(KEY[2]),
        .q(LEDR[2]));
    
    MUXDFF exp3(
        .w(LEDR[2]),
        .r(SW[1]),
        .clk(KEY[0]),
        .e(KEY[1]),
        .l(KEY[2]),
        .q(LEDR[1]));
    
    MUXDFF exp4(
        .w(LEDR[1]),
        .r(SW[0]),
        .clk(KEY[0]),
        .e(KEY[1]),
        .l(KEY[2]),
        .q(LEDR[0]));

endmodule

module MUXDFF (
    input w,
    input r,
    input e,
    input l,
    input clk,
    output q);
    
    wire mux_1_q, mux_2_q;
    
    always@(posedge clk)begin
        if (e) mux_1_q = w;
        else mux_1_q = q;

        if (l) mux_2_q = r;
        else mux_2_q = mux_1_q;
		
		q <= mux_2_q;
    end

endmodule
