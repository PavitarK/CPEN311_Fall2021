`timescale 1ns / 1ps
module tb_clock_divider;
	// Inputs
	reg clock_in;
	reg[27:0] frequencySelect;
	// Outputs
	wire clock_out;
	// Test the clock divider in Verilog
	clkDiv uut (
	 .clock_in(clock_in), 
  	 .clock_out(clock_out),
  	 .frequencySelect(frequencySelect)
	);
	initial begin
		// Initialize Inputs
		clock_in = 0;
		frequencySelect = 28'd2;
		// create input clock 50MHz
		forever begin #10; clock_in = ~clock_in; end
 	end
      
endmodule 