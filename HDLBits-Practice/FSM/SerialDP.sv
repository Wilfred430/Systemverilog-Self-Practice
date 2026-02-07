module top_module (
    input clk,
    input in,
    input reset,  // Synchronous reset
    output [7:0] out_byte,
    output done
);  //

  parameter IDLE = 0, DATA = 1, STOP = 2, ESTOP = 3;

  reg [1:0] state, next_state;

  always @(*) begin
    case (state)
      IDLE: next_state = (~in) ? DATA : IDLE;
      DATA: next_state = (count == 4'd9) ? ((in) ? STOP : ESTOP) : DATA;
      STOP: next_state = (in) ? IDLE : DATA;
      ESTOP: next_state = (in) ? IDLE : ESTOP;
      default: next_state = IDLE;
    endcase
  end

  reg [3:0] count;

  always @(posedge clk) begin
    if (reset) state <= IDLE;
    else state <= next_state;
  end

  reg [8:0] out;

  always @(posedge clk) begin
    if (state == IDLE || state == STOP || state == ESTOP) count <= 4'd0;
    else begin
      if (count < 9) out[count] <= in;
      count <= count + 1;
    end
  end

  reg odd;

  always @(posedge clk) begin
    if (reset || state == STOP || state == ESTOP) odd <= 0;
    else if (in && state == DATA && count < 9) odd <= ~odd;
  end

  assign done = (state == STOP && odd);
  assign out_byte = (done) ? out[7:0] : 8'b0;

endmodule
