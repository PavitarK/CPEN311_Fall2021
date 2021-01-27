`timescale 1 ps / 1 ps

module tb_led_control(); 

    reg CLOCK_50; 
    reg [7:0] LED; 

    led_control dut(.inclk(CLOCK_50), .LED(LED));

    initial begin 
        CLOCK_50 = 1'b0; 
        forever begin 
            #1 //Should be 10 but 1 for testing
            CLOCK_50 = ~CLOCK_50; 
        end 
    end 
endmodule 