module top_module ( input clk, input d, output q );

    wire dff1to2;
    wire dff2to3;
    
    my_dff dff1(clk, d, dff1to2);
    my_dff dff2(clk, dff1to2, dff2to3);
    my_dff dff3(clk, dff2to3, q);
    
endmodule
