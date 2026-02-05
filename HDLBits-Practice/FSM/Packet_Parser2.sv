module top_module (
    input clk,
    input [7:0] in,
    input reset,  // Synchronous reset
    output done
);  //

  parameter IDLE = 0, MES1 = 1, MES2 = 2, MES3 = 3;

  reg [1:0] state, next_state;

  // State transition logic (combinational)
  always @(*) begin
    case (state)
      IDLE: next_state = (in[3]) ? MES1 : IDLE;
      MES1: next_state = MES2;
      MES2: next_state = MES3;
      MES3: next_state = (in[3]) ? MES1 : IDLE;
    endcase
  end

  // State flip-flops (sequential)
  always @(posedge clk) begin
    if (reset) state <= IDLE;
    else state <= next_state;
  end

  // Output logic
  assign done = (state == MES3);

endmodule
