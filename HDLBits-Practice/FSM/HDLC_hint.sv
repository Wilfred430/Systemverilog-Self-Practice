module top_module (
    input  clk,
    input  reset,  // Synchronous reset
    input  in,
    output disc,
    output flag,
    output err
);

  parameter NONE = 4'd0,ONE = 4'd1,TWO = 4'd2,THREE = 4'd3,FOUR = 4'd4,
            FIVE = 4'd5,SIX = 4'd6,DIS = 4'd7,FLAG = 4'd8,ERROR = 4'd9;

  reg [3:0] state, next_state;

  always @(*) begin
    case (state)
      NONE: next_state = (in) ? ONE : NONE;
      ONE: next_state = (in) ? TWO : NONE;
      TWO: next_state = (in) ? THREE : NONE;
      THREE: next_state = (in) ? FOUR : NONE;
      FOUR: next_state = (in) ? FIVE : NONE;
      FIVE: next_state = (in) ? SIX : DIS;
      SIX: next_state = (in) ? ERROR : FLAG;
      DIS: next_state = (in) ? ONE : NONE;
      FLAG: next_state = (in) ? ONE : NONE;
      ERROR: next_state = (in) ? ERROR : NONE;
      default: next_state = NONE;
    endcase
  end

  always @(posedge clk) begin
    if (reset) state <= NONE;
    else state <= next_state;
  end

  assign disc = (state == DIS);
  assign flag = (state == FLAG);
  assign err  = (state == ERROR);

endmodule
