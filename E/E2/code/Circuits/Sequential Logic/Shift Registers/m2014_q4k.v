module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    
    reg [3:0] q;
    
    assign out = q[0];
    
    always@(posedge clk)begin
        if (~resetn)  q <= 4'h0;
        else begin
            q[3] <= in;
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule
