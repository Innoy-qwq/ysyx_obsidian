`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
    
    wire wire_a_b;
    wire wire_c_d;
    
    assign wire_a_b = a & b;
    assign wire_c_d = c & d;
    assign out = wire_a_b | wire_c_d;
    assign out_n = ~out;

endmodule
