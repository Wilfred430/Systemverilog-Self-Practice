module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q);

  always @(posedge clk)
  begin
    if(load)
      q <= data;
    case(ena)

    endcase

  end

endmodule
