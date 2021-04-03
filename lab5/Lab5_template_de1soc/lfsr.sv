module lfsr (clk, q, reset);

input logic clk;
output logic [4:0] q;
input logic reset; 
logic feedback_value;
 
assign feedback_value = q[0] ^ q[2]; 

always @(posedge clk or posedge reset) begin
	if(reset) 
		q <= 5'b1;
	else  
		q <= {feedback_value, q[4:1]};
end 

endmodule


module tb_lfsr;
	// Inputs
	reg clk;
	logic reset; 
	// Outputs
	logic [4:0] q;
	// Test the clock divider in Verilog
	lfsr dut(
	 .clk(clk), 
  	 .q(q),	
	   .reset(reset)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1; 
		// create input clock 1Hz
		forever begin #10; clk = ~clk; end
 	end

	 initial begin 
		 #20
		 reset = 0; 
	 
	 end 
      
endmodule 
