`timescale 1 ps / 1 ps

module tb_task5();

logic CLOCK_50; 

//fast clock triggering forever
	initial begin 
	#1 CLOCK_50 = 0; 
		forever begin 
		#5 CLOCK_50 = !CLOCK_50; 
		end 
	end 

endmodule 