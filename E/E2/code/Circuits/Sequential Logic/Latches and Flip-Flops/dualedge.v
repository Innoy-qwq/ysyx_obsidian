module top_module (
    input clk,
    input d,
    output q
);
    wire posq, negq;
    
    always @(posedge clk)begin
        posq <= d;
    end
    
    always @(negedge clk)begin
    	negq <= d;
    end
    
    always @(*)begin
        if (clk) 
    	q <= posq;
        else if (~clk)
        q <= negq;
    end
        
endmodule
