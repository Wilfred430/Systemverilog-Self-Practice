module top_module ();

  reg  clk;
  reg  reset;
  reg  t;
  wire q;

  // clk, reset design by yourself
  initial begin
    clk <= 0;
    forever #5 clk <= ~clk;
  end

  initial begin
    reset <= 0;
    #50 reset <= ~reset;
    #10 reset <= ~reset;
  end

  initial begin
    t <= 0;
  end

  always @(posedge clk) begin
    if (reset) t <= 1;
  end

  tff T (
      .clk(clk),
      .reset(reset),
      .t(t),
      .q(q)
  );

endmodule
