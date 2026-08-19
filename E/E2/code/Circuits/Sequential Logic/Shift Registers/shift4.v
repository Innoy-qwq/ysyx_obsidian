module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 
    
    always @(posedge clk , posedge areset)begin
        if (areset) begin
            q <= 4'h0;            
        end
        
        else if (load)begin
            q <= data;
        end
        
        else if (ena) begin
            q[3] <= 0;
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end
        
    end

endmodule
