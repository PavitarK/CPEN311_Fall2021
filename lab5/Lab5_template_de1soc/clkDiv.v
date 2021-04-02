module clkDiv(clock_in, clock_out, frequencySelect);
	//Inputs
	input clock_in;
	input [27:0] frequencySelect;
	//Output
	output reg clock_out = 1'b0; 
	
	//Clock divider logic
	reg[27:0] counter = 28'd0;

	always @(posedge clock_in)
	begin
		if (counter >= frequencySelect / 2 - 1)
		begin
			counter <= 28'd0;
        		clock_out <= ~clock_out;
		end
    		else
		begin
			counter <= counter + 1;
		end
	end
endmodule 