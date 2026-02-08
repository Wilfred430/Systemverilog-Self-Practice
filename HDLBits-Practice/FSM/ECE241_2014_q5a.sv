module top_module (
    input  clk,
    input  areset,
    input  x,
    output z
);

  parameter IDLE = 0, S1 = 1, S2 = 2;
  reg [1:0] state, next_state;

  always @(*) begin
    case (state)
      IDLE: next_state = (x) ? S1 : IDLE;
      S1:   next_state = (x) ? S2 : S1;
      S2:   next_state = (x) ? S2 : S1;
    endcase
  end

  always @(posedge clk, posedge areset) begin
    if (areset) state <= IDLE;
    else state <= next_state;
  end

  assign z = (state == S1);

endmodule
