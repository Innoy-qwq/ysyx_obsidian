module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

    reg [2:0] state, next_state;

    parameter A   = 3'd0,
              B   = 3'd1,   // 上一组结果 z=0，同时开始下一组
              C   = 3'd2,   // 上一组结果 z=1，同时开始下一组
              S10 = 3'd3,   // 已采样1次，出现0个1
              S11 = 3'd4,   // 已采样1次，出现1个1
              S20 = 3'd5,   // 已采样2次，出现0个1
              S21 = 3'd6,   // 已采样2次，出现1个1
              S22 = 3'd7;   // 已采样2次，出现2个1

    always @(*) begin
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            // 新一组三周期的第1个 w
            B: begin
                if (w)
                    next_state = S11;
                else
                    next_state = S10;
            end

            // 和 B 完全一样，只是 z 不同
            C: begin
                if (w)
                    next_state = S11;
                else
                    next_state = S10;
            end

            // 新一组三周期的第2个 w
            S10: begin
                if (w)
                    next_state = S21;
                else
                    next_state = S20;
            end

            S11: begin
                if (w)
                    next_state = S22;
                else
                    next_state = S21;
            end

            // 第3个 w 之后，进入结果状态
            S20: begin
                // 00 + 0/1 都不可能恰好两个1
                next_state = B;
            end

            S21: begin
                // 已经有一个1
                if (w)
                    next_state = C;  // 010/011? → 恰好两个1
                else
                    next_state = B;
            end

            S22: begin
                // 已经有两个1
                if (w)
                    next_state = B;  // 三个1
                else
                    next_state = C;  // 恰好两个1
            end

            default:
                next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    assign z = (state == C);

endmodule
