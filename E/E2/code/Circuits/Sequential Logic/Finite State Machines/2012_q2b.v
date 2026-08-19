module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    reg [5:0]Y;
    parameter A=3'h0, B=3'h1, C=3'h2,D=3'h3, E=3'h4, F=3'h5;
    
    assign Y[F] = (w && y[D]);
    assign Y[E] = (w && y[C]) || (!w && y[E]);
    assign Y[D] = (!w && (y[B] || y[C] || y[E] || y[F]));
    assign Y[C] = (w && (y[B] || y[F]));
    assign Y[B] = (w && y[A]);
    assign Y[A] = (!w && (y[A] || y[D])); 
    
    assign Y1 = Y[1];
    assign Y3 = Y[3];
endmodule
