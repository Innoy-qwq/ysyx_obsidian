module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    reg [1:0] state;
    reg [1:0] next_state;
    parameter one=1, two=2, three=3, OFF=0;
    
    // State transition logic (combinational)
    always@(*)begin
        case (state)
            one: next_state = two;
            two: next_state = three;
            three: begin 
                if (in[3]) next_state = one;
                else next_state = OFF;
            end
            OFF: begin
                if (in[3]) next_state = one;
                else next_state = OFF;
            end
        endcase
    end

    // State flip-flops (sequential)
    always@(posedge clk)begin
        //if (state == three) done <= 1;
        //else done <= 0;
        
        if (reset) state <= OFF;
        else state <= next_state;
    end
 
    // Output logic
    assign done = (state == three);

endmodule
