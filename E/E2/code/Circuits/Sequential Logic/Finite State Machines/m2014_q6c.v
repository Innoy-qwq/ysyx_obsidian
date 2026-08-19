module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);
    
    reg [6:1]Y;
    parameter A=3'h1, B=3'h2, C=3'h3,D=3'h4, E=3'h5, F=3'h6;
    
    assign Y[F] = (!w && y[D]);
    assign Y[E] = (!w && y[C]) || (!w && y[E]);
    assign Y[D] = (w && (y[B] || y[C] || y[E] || y[F]));
    assign Y[C] = (!w && (y[B] || y[F]));
    assign Y[B] = (!w && y[A]);
    assign Y[A] = (w && (y[A] || y[D])); 
    
    assign Y2 = Y[2];
    assign Y4 = Y[4];

endmodule
