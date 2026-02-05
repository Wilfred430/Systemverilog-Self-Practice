module top_module (
    input clk,
    input [7:0] in,
    input reset,  // Synchronous reset
    output [23:0] out_bytes,
    output done
);  //

  // FSM from fsm_ps2
  parameter IDLE = 0, MES1 = 1, MES2 = 2, MES3 = 3;

  reg [1:0] state, next_state;
  wire [23:0] out;

  // State transition logic (combinational)
  // Next-state logic
  always @(*) begin
    case (state)
      IDLE: next_state = (in[3]) ? MES1 : IDLE;
      MES1: next_state = MES2;
      MES2: next_state = MES3;
      MES3: next_state = (in[3]) ? MES1 : IDLE;
    endcase
  end

  // State and datapath registers
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      out   <= 24'b0;
    end else begin
      state <= next_state;
      case (next_state)
        MES1: out[23:16] <= in;
        MES2: out[15:8] <= in;
        MES3: out[7:0] <= in;
      endcase
    end
  end

  assign done      = (state == MES3);
  assign out_bytes = (done) ? out : 24'b0;

endmodule
