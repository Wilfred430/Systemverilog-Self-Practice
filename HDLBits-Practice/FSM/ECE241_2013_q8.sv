module top_module (
    input  clk,
    input  aresetn,  // Asynchronous active-low reset
    input  x,
    output z
);

  parameter S1 = 0, S2 = 1, S3 = 2;
  reg [1:0] state, next_state;

  always @(posedge clk, negedge aresetn) begin
    if (!aresetn) state <= S1;
    else state <= next_state;
  end

  always @(*) begin
    case (state)
      S1: begin
        next_state = (x) ? S2 : S1;
        z = 0;
      end
      S2: begin
        next_state = (x) ? S2 : S3;
        z = 0;
      end
      S3: begin
        next_state = (x) ? S2 : S1;
        z = (x) ? 1 : 0;
      end
      default: begin
        next_state = S1;
        z = 0;
      end
    endcase
  end

endmodule
