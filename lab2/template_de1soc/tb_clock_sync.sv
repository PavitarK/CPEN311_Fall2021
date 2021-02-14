`timescale 1 ps / 1 ps

module tb_clock_sync();

    logic CLOCK_50, slowclk, readnow; 
    logic [27:0] frequencyControl; 

    //generate a 22kHz clock
    clk_divider songSpeedClock(.inclk(CLOCK_50), .outclk(slowclk), .finalcount(frequencyControl)); 
 
    //Synchorize the clocks
    clock_sync synchronizer(.CLOCK_50(CLOCK_50), .async_clk(slowclk), .edgedetect(readNow));

    initial begin
        frequencyControl = 28'd7; 
        CLOCK_50 = 0;
        
        forever begin 
            #3;
            CLOCK_50 = !CLOCK_50; 
        end  
    end

endmodule