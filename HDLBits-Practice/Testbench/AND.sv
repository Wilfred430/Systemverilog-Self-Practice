module top_module ();

  reg [1:0] in;
  wire out;

  initial begin
    in[1:0] <= 2'b00;
    #10;
    in[0] <= ~in[0];
    #10;
    in[1:0] <= ~in[1:0];
    #10;
    in[0] <= ~in[0];
  end

  assign out = &in;

  andgate a (
      .in (in),
      .out(out)
  );

endmodule
