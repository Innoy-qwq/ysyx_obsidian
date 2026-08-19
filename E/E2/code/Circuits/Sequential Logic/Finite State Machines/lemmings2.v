module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah);
    
    // parameter LEFT=0, RIGHT=1, ...
    reg [1:0] state;
    reg [1:0] next_state;
    parameter LEFT=2'h0, RIGHT=2'h1, FALL_L=2'h2, FALL_R=2'h3;

    always @(*) begin
        // State transition logic
        case (state)
            LEFT: begin
                if (ground) next_state = (bump_left) ? RIGHT : LEFT;
                else next_state = FALL_L;
            end 
            RIGHT: begin
                if (ground) next_state = (bump_right) ? LEFT : RIGHT;
                else next_state = FALL_R;
            end
            FALL_L: begin
                if (ground) next_state = LEFT;
                else next_state = FALL_L;
            end
            FALL_R: begin
                if (ground) next_state = RIGHT;
                else next_state = FALL_R;
            end
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Output logic
    // assign walk_left = (state == ...);
    // assign walk_right = (state == ...);
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L | state == FALL_R);

endmodule
