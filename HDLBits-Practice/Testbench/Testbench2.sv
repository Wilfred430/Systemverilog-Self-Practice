module top_module ();
  reg clk;
  reg in;
  reg [2:0] s;
  reg out;

  initial begin
    clk <= 0;
    forever #5 clk <= ~clk;
  end

  initial begin
    in <= 0;
    #20 in <= ~in;
    #10 in <= ~in;
    #10 in <= ~in;
    #30 in <= ~in;
  end

  initial begin
    s <= 3'd2;
    #10 s <= 3'd6;
    #10 s <= 3'd2;
    #10 s <= 3'd7;
    #10 s <= 3'd0;
  end


  q7 q (
      .clk(clk),
      .in (in),
      .s  (s),
      .out(out)
  );

endmodule
