module top_module (
    input  clk,
    input  in,
    input  reset,  // Synchronous reset
    output done
);

  parameter IDLE = 0, DATA = 1, STOP = 2, ESTOP = 3;

  reg [1:0] state, next_state;

  always @(*) begin
    case (state)
      IDLE:  next_state = (~in) ? DATA : IDLE;
      DATA:  next_state = (count == 4'd8) ? ((in) ? STOP : ESTOP) : DATA;
      STOP:  next_state = (in) ? IDLE : DATA;
      ESTOP: next_state = (in) ? IDLE : ESTOP;
    endcase
  end

  reg [3:0] count;

  always @(posedge clk) begin
    if (reset) state <= IDLE;
    else state <= next_state;
  end

  always @(posedge clk) begin
    if (state == IDLE || state == STOP || state == ESTOP) count <= 4'd0;
    else count <= count + 1;
  end

  assign done = (state == STOP);

endmodule
