module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire selector;
    wire [15:0] add_cin1_sum;
    wire [15:0] add_cin0_sum;
    
    add16 sum_bottom(a[15:0], b[15:0], 1'b0, sum[15:0], selector);
    add16 sum_up_cin0(a[31:16], b[31:16], 1'b0, add_cin0_sum[15:0], 1'b0);
    add16 sum_up_cin1(a[31:16], b[31:16], 1'b1, add_cin1_sum[15:0], 1'b0);
    
    always@(*)begin 
        case(selector)
            1'b0: sum[31:16] = add_cin0_sum[15:0];
            1'b1: sum[31:16] = add_cin1_sum[15:0];
        endcase
    end

endmodule
