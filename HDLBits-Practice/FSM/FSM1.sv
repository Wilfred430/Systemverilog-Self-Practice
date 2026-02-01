module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//

  parameter A=0, B=1;
  reg state, next_state;

  always @(*)
  begin    // This is a combinational always block
    // State transition logic
    case(state)
      1'b0:
      begin
        if(in)
          next_state = 0;
        else
          next_state = 1;
      end
      1'b1:
      begin
        if(in)
          next_state = 1;
        else
          next_state = 0;
      end
    endcase
  end

  always @(posedge clk, posedge areset)
  begin    // This is a sequential always block
    // State flip-flops with asynchronous reset
    if(areset)
      state <= 1;
    else
    begin
      state <= next_state;
    end
  end

  // Output logic
  // assign out = (state == ...);
  assign out = (state == A)? 0:1;

endmodule
