module top_module (
    input  clk,
    input  areset,
    input  x,
    output z
);

  parameter A = 0, B = 1;
  reg state, next_state;

  always @(*) begin
    case (state)
      A: begin
        next_state = (x) ? B : A;
        z = (x) ? 1 : 0;
      end
      B: begin
        next_state = B;
        z = (x) ? 0 : 1;
      end
      default: next_state = A;
    endcase
  end

  always @(posedge clk, posedge areset) begin
    if (areset) state <= A;
    else state <= next_state;
  end

endmodule
