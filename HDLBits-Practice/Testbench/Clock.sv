module top_module ();

wire clk;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

dut u(.clk(clk));

endmodule
