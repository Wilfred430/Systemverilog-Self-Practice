module top_module (
    input  clk,
    input  reset,  // Synchronous reset
    input  in,
    output disc,
    output flag,
    output err
);

  parameter IDLE = 0, ACC = 1, DISC = 2, FLAG = 3, ERROR = 4;
  integer count;
  reg [2:0] state, next_state;

  always @(*) begin
    case (state)
      IDLE: next_state = (in) ? ACC : IDLE;
      ACC: begin
        if (!in) begin
          if (count == 5) next_state = DISC;
          else if (count == 6) next_state = FLAG;
        end else if (count >= 6) next_state = ERROR;
      end
      DISC: next_state = (in) ? ACC : IDLE;
      FLAG: next_state = (in) ? ACC : IDLE;
      ERROR: next_state = (in) ? ERROR : IDLE;
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (reset) state <= IDLE;
    else state <= next_state;
  end

  always @(posedge clk) begin
    if (reset || !in) count <= 0;
    else if (in) count <= count + 1;
  end

  assign disc = (state == DISC);
  assign flag = (state == FLAG);
  assign err  = (state == ERROR);

endmodule
