module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //
    count4 the_counter (
        .clk(clk),
        .enable(c_enable),
        .load(c_load),
        .d(c_d),
        .Q(Q));
    
    always @(*) begin
        if (Q == 4'd12 & enable) begin
            c_enable = enable;
            c_load = 1;
            c_d = 4'd1;
        end
        
        else if(reset)begin
        	c_enable = enable;
            c_load = 1;
            c_d = 4'd1;
        end
        
        else begin
            c_enable = enable;
            c_load = 0;
            c_d = 4'd0;
        end
    end

endmodule
