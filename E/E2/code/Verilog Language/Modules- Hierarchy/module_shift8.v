module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);
    wire [7:0] dff1to2;
    wire [7:0] dff2to3;
    wire [7:0] dff3tomux;
    
    my_dff8 test1(
        .clk(clk),
        .d(d),
        .q(dff1to2),
    );
    
    my_dff8 test2(
        .clk(clk),
        .d(dff1to2),
        .q(dff2to3),
    );
    
    my_dff8 test3(
        .clk(clk),
        .d(dff2to3),
        .q(dff3tomux),
    );
    
    always@(*) begin
        case (sel) 
            0: q = d;
            1: q = dff1to2;
            2: q = dff2to3;
            3: q = dff3tomux;
        endcase
    end

endmodule
