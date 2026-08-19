
module SSMMClock(
   	input clk,
	input enable,
	input reset,
    output [7:0] q,
	output c);
    
    assign c = (q[7:0] == 8'h59 & enable) ? 1 : 0;
    
    always @(posedge clk)begin
        if (enable) begin
            q <= q + 1;
        
            if (q[3:0] == 4'd9)begin
                q [3:0] <= 0;
                q [7:4] <= q[7:4] + 1;
            end

            if (q[7:0] == 8'h59) q <= 0;
        end
        
        if (reset) q <= 0;
    end

endmodule


module HHClock(
	input clk,
	input enable,
	input reset,
    output [7:0] q,
	output c,
	output pm_c);
    
    assign c = (q[7:0] == 8'h12 & enable) ? 1 : 0;
    assign pm_c = (q[7:0] == 8'h11 & enable) ? 1 : 0;
    
    always @(posedge clk)begin
        if (enable) begin
            q <= q + 1;

            if (q[3:0] == 4'd9)begin
                q [3:0] <= 0;
                q [7:4] <= q[7:4] + 1;
            end

            if (c) q <= 1;
        end
        
        if (reset) q <= 8'h12;
    end

endmodule


module PmClock(
    input clk,
	input enable,
	input reset,
	output q);
    
    always @(posedge clk)begin
        if (enable) q <= ~q;
        if (reset) q <= 0;
    end
    
endmodule


module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);
    
    wire [2:0] c;
    wire pm_c;
    
    SSMMClock ss_clock(
        .clk(clk),
        .enable(ena),
        .reset(reset),
        .q(ss),
        .c(c[0])); // 60循环,ena控制enble, 进位输出c[0]. 
    
    SSMMClock mm_clock(
        .clk(clk),
        .enable(c[0]),
        .reset(reset),
        .q(mm),
        .c(c[1])); // 60循环, c[0]控制enable, 进位输出c[1].
    
    HHClock hh_clock(
        .clk(clk),
        .enable(c[1]),
        .reset(reset),
        .q(hh),
        .c(c[2]),
        .pm_c(pm_c)); // 12循环, c[1]控制enable, 进位输出c[2]. 达到12输出pm_c
    
    
    PmClock pm_clock(
        .clk(clk),
        .enable(pm_c),
        .reset(reset),
        .q(pm)); // 2循环, pm_c控制enable, 进位无输出.
    
endmodule
