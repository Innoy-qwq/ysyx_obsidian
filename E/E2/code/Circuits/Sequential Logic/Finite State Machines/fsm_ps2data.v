module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    // FSM from fsm_ps2

    reg [1:0] state;
    reg [1:0] next_state;
    reg [23:0] data;
    parameter one=1, two=2, three=3, OFF=0;
    
    // State transition logic (combinational)
    always@(*)begin
        case (state)
            one: begin
                next_state = two;
            end
            two: begin
                next_state = three;
            end
            three: begin 
                if (in[3])begin
                    next_state = one;
                end
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
        if (reset) begin
            state <= OFF;
            data <= 24'b0;
        end
        else begin
            state = next_state;
            case (state)
                one:   data[23:16]  <= in;
                two:   data[15:8]   <= in;
                three: data[7:0] <= in;
        endcase
        end
    end
 
    // Output logic
    assign done = (state == three);
    assign out_bytes = data & {24{state == three}};

    // New: Datapath to store incoming bytes.
    

endmodule
