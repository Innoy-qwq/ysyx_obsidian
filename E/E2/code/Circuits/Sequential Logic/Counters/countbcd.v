module decade_BCDcounter(
	input clk,
	input reset,
    input enable,
    output [3:0] q);
    
    always @(posedge clk)begin
        if (enable) q = q + 1;
        if (q == 4'ha | reset) q = 0;
    end
    
endmodule

module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    decade_BCDcounter counter1(
        .clk(clk),
        .reset(reset),
        .enable(1),
        .q(q[3:0]));
    
    decade_BCDcounter counter2(
        .clk(clk),
        .reset(reset),
        .enable(ena[1]),
        .q(q[7:4]));
    
    decade_BCDcounter counter3(
        .clk(clk),
        .reset(reset),
        .enable(ena[2]),
        .q(q[11:8]));
    
    decade_BCDcounter counter4(
        .clk(clk),
        .reset(reset),
        .enable(ena[3]),
        .q(q[15:12]));
    
    always@(*)begin
        if (q[3:0] == 4'b1001) ena[1] = 1;
        else ena[1] = 0;
        
        if (q[7:0] == 8'b10011001) ena[2] = 1;
        else ena[2] = 0;
        
        if (q[11:0] == 12'b100110011001) ena[3] = 1;
        else ena[3] = 0;
    end

endmodule
