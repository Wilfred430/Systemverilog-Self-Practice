module top_module (
    output reg A,
    output reg B
);  //

  // generate input patterns here
  initial begin
    A <= 0;
    B <= 0;
    #10 A <= ~A;
    #5 B <= ~B;
    #5 A <= ~A;
    #20 B <= ~B;
  end

endmodule
