module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);

  always @(posedge clk)
  begin
    if(reset)
    begin
      q<=16'd0;
    end
    else
    begin
      q[3:0] <= (q[3:0]+1)%10;
      q[7:4] <= (q[3:0]==4'd9)?(q[7:4]+1)%10:q[7:4];
      q[11:8] <= (q[7:4]==4'd9 && q[3:0]==4'd9)?(q[11:8]+1)%10:q[11:8];
      q[15:12] <= (q[11:8]==4'd9 && q[7:4]==4'd9 && q[3:0]==4'd9)?(q[15:12]+1)%10:q[15:12];
    end
  end

  always @(posedge clk)
  begin
    if(reset)
      ena <= 3'b0;
    else
    begin
      if(q[3:0] == 4'd8)
        ena[1] <= 1'b1;
      else
        ena[1] <= 1'b0;

      if(q[7:4] == 4'd9 && q[3:0] == 4'd8)
        ena[2] <= 1'b1;
      else
        ena[2] <= 1'b0;

      if(q[11:8]==4'd9 && q[7:4]==4'd9 && q[3:0]==4'd8)
        ena[3] <= 1'b1;
      else
        ena[3] <= 1'b0;
    end
  end
endmodule
