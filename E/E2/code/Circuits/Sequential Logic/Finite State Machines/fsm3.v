module top_module(
    input clk,
    input in,
    input areset,
    output out); //

    wire [3:0] next_state;
    reg [3:0] state;
    parameter A=0, B=1, C=2, D=3;

    assign next_state[A] = (state[A] | state[C]) & ~in;
    assign next_state[B] = (state[A] | state[B] | state[D]) & in;
    assign next_state[C] = (state[B] | state[D]) & ~in;
    assign next_state[D] = state[C] & in;

    // State flip-flops with asynchronous reset
    always @(posedge clk, posedge areset)begin
        if (areset)begin
            state <= 4'b0001;
        end
        else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state[D] == 1);

endmodule
