`timescale 1 ps / 1 ps

module tb_clkdivider();
 
    reg [2:0] frequency_sel; 
    wire outclk; 
    reg CLOCK_50; 

    //instantiate dut
    clk_divder dut(.inclk(CLOCK_50), .outclk(outclk), .frequency_sel(frequency_sel)); 

    //50Mhz clock
	initial begin 
	  CLOCK_50 = 0; 
      frequency_sel = 3'b000; 
		forever begin 
		#10 CLOCK_50 = !CLOCK_50; 
		end 
	end 

/*
    initial begin 
//Test no input => 536 Hz
        //frequency_sel = 3'b000; 
        //#100000; 
        //assert
        //#10; 

// Test input b001 
        //frequency_sel = 3'b001; 
        //#100000; 
        //assert
        //#10


    $display("Tests Finished Running");    
    end 
    */
endmodule 