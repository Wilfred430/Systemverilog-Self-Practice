module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

  // one-hot encoding: y1=A, y2=B, y3=C, y4=D, y5=E, y6=F
  assign Y2 = y[1] & ~w;  // A→B
  assign Y4 = (y[2] & w) | (y[3] & w) | (y[5] & w) | (y[6] & w);  // B→D 或 C→D

endmodule
