module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //
    reg [11:0] Q;
    
    bcdcount counter0 (
        .clk(clk),
        .reset(reset),
        .enable(c_enable[0]),
        
        .Q(Q[3:0]));
    
    bcdcount counter1 (
        .clk(clk),
        .reset(reset),
        .enable(c_enable[1]),
        
        .Q(Q[7:4]));
    
    bcdcount counter2 (
        .clk(clk),
        .reset(reset),
        .enable(c_enable[2]),
        
        .Q(Q[11:8]));
    
    always @(*)begin
        if (!reset) c_enable[0] = 1;
        else c_enable[0] = 0;
        
        if (Q[3:0] == 4'b1001) c_enable[1] = 1;
        else c_enable[1] = 0;
        
        if (Q[7:0] == 8'b10011001) c_enable[2] = 1;
        else c_enable[2] = 0;
        
        if (Q[11:0] == 12'b100110011001) OneHertz = 1;
        else OneHertz = 0;
    end
    
endmodule
