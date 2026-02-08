module top_module (
    input  clk,
    input  reset,  // Synchronous reset
    input  s,
    input  w,
    output z
);

  parameter A = 0, B = 1;
  reg state, next_state;

  always @(*) begin
    case (state)
      A: next_state = (s) ? B : A;
      B: next_state = B;
    endcase
  end

  always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
  end

  reg [1:0] count, one;

  always @(posedge clk) begin
    if (reset || state == A) begin
      count <= 2'b0;
      one   <= 2'b0;
    end else if (state == B) begin
      count <= (count == 3) ? 1 : count + 1;
      one   <= (count == 3) ? w : one + w;
    end
  end

  assign z = (one == 2'd2 && count == 2'd3);

endmodule
