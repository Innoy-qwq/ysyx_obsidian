module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Modify FSM and datapath from Fsm_serialdata
    reg [3:0] counter;
    reg [2:0] state;
    reg [2:0] next_state;
    reg [8:0] data;
    reg odd;
    wire p_reset;
    
    parameter IDLE=3'h0, START=3'h1, DATA=3'h2, STOP=3'h3, WAIT_STOP = 3'd4;
    
    parity p(
        .clk(clk),
        .reset(p_reset),
        .in(next_state == DATA & in),
        .odd(odd));
    
    always @(*)begin
        
        if (next_state == START | reset) p_reset = 1;
        else p_reset = 0;
        
        case (state)
            IDLE:begin
                if (!in) next_state = START;
                else next_state = IDLE;
            end
            START:begin
                next_state = DATA;
            end
            DATA:begin
                if (counter == 9) begin 
                    if (in) next_state = STOP;
                    else next_state = WAIT_STOP;
                end
                else next_state = DATA;
            end
            STOP:begin
                if (!in) next_state = START;
                else next_state = IDLE;
            end
            WAIT_STOP:begin
                if (in) next_state = IDLE;
                else next_state = WAIT_STOP;
            end
        endcase
    end
    
    
    always @(posedge clk)begin
        if(reset) begin
            state <= IDLE;
            counter <= 0;
            data <= 9'h0;
        end
        else begin
            state <= next_state;
            if (next_state == DATA) begin
                data[counter] <= in;
                counter <= counter + 1;
            end
            else counter <= 0;
        end
    end
    
    assign done = (state == STOP & odd);
    assign out_byte = data[7:0] & {8{done}};

    // New: Add parity checking.
    

endmodule
