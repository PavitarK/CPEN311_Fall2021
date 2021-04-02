module lfsr
#(
    parameter N = 5
)
(
    clk, q
)

logic clk;
logic [N-1:0] q = 1;
logic feedback_value;

flipflop ff1(.d(q[4]), .q(q[3]), .clk(clk));
flipflop ff2(.d(q[3]), .q(q[2]), .clk(clk));
flipflop ff3(.d(q[2]), .q(q[1]), .clk(clk));
flipflop ff4(.d(q[1]), .q(q[0]), .clk(clk));
flipflop ff5(.d(feedback_value), .q(q[4]), .clk(clk));

endmodule

module flipflop(d, q, clk);
    input d, clk;
    output reg q;

    always_ff @(posedge clk) begin
        q <= d;
    end
endmodule

module tb_lfsr;
	// Inputs
	reg clk;
	// Outputs
	wire [4:0] q;
	// Test the clock divider in Verilog
	clkDiv uut (
	 .clk(clk), 
  	 .q(q)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		// create input clock 50MHz
		forever begin #10000000; clk = ~clk; end
 	end
      
endmodule 
