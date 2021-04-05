module lfsr (clk, q);

input logic clk;
output logic [4:0] q = 5'b00001;
logic feedback_value;
 
assign feedback_value = q[0] ^ q[2]; 

always @(posedge clk) begin

	q <= {feedback_value, q[4:1]};
end 

endmodule


module tb_lfsr;
	// Inputs
	reg clk;
	// Outputs
	logic [4:0] q;
	// Test the clock divider in Verilog
	lfsr dut(
	 .clk(clk), 
  	 .q(q)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		// create input clock 1Hz
		forever begin #10; clk = ~clk; end
 	end

	 initial begin 
	 
	 end 
      
endmodule 
