module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer r, c;
    integer count;

    reg [255:0] next;

    always @(*) begin
        next = 256'b0;

        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin

                count = 0;

                // 左上
                count = count + q[((r+15)%16)*16 + ((c+15)%16)];

                // 上
                count = count + q[((r+15)%16)*16 + c];

                // 右上
                count = count + q[((r+15)%16)*16 + ((c+1)%16)];

                // 左
                count = count + q[r*16 + ((c+15)%16)];

                // 右
                count = count + q[r*16 + ((c+1)%16)];

                // 左下
                count = count + q[((r+1)%16)*16 + ((c+15)%16)];

                // 下
                count = count + q[((r+1)%16)*16 + c];

                // 右下
                count = count + q[((r+1)%16)*16 + ((c+1)%16)];


                case(count)

                    2:
                        next[r*16+c] = q[r*16+c];

                    3:
                        next[r*16+c] = 1'b1;

                    default:
                        next[r*16+c] = 1'b0;

                endcase

            end
        end
    end


    always @(posedge clk) begin
        if(load)
            q <= data;
        else
            q <= next;
    end

endmodule
