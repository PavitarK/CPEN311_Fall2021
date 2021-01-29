`timescale 1 ps / 1 ps

module tb_clkdivider();
 
    reg [27:0] finalcount; 
    wire outclk; 
    reg CLOCK_50; 

    //instantiate dut
    clk_divider dut(.inclk(CLOCK_50), .outclk(outclk), .finalcount(finalcount)); 

    //clock switching forever
	initial begin 
	  CLOCK_50 = 0; 
      finalcount = 28'd10; 
		forever begin 
		#10 CLOCK_50 = !CLOCK_50; 
		end 
        
	end 
   
   /* //testing different counts
    initial begin 
        #15
        finalcount = 18'd5; 
        #30 //should have 5 posedges

        finalcount = 28'd10; //should have 6 posedges
        #60; 

        finalcount = 28'd4; //should have 5 posedges
        #20; 
    end 
    */

endmodule 