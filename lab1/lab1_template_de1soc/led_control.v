module led_control(inclk, LED);

    //define states 
    `define S0 4'd0 //LED 0 is on increasing
    `define S1 4'd1 //LED 1 is on increasing
    `define S2 4'd2 //LED 2 is on increasing
    `define S3 4'd3 //LED 3 is on increasing
    `define S4 4'd4 //LED 4 is on increasing
    `define S5 4'd5 //LED 5 is on increasing
    `define S6 4'd6 //LED 6 is on decreasing
    `define S7 4'd7 //LED 5 is on decreasing
    `define S8 4'd8 //LED 4 is on decreasing
    `define S9 4'd9 //LED 3 is on decreasing
    `define S10 4'd10 //LED 2 is on decreasing
    `define S11 4'd11 //LED 1 is on decreasing

    //50Mhz Clock 
    input inclk; 
    output [7:0] LED; 

    logic clk_1Hz; 
    logic [7:0] LED_reg;
    logic [3:0] next_state = `S0; 
    logic [3:0] current_state; 

    //controls light direction
    //logic bounce = 1'b1; //removing this will remove the latch? 

    assign LED = LED_reg;  

    //make a 1Hz clock via clk divider
    clk_divider slow_clk(.inclk(inclk), .finalcount(28'd50000000), .outclk(clk_1Hz)); 

    //Flip Flop driving state controller
	vDFF state_controller(.clk(clk_1Hz), .in(next_state), .out(current_state)); 

    //state controller, rolling through LED's
    always @(*) begin
        case(current_state)    
            `S0: next_state = `S1; 
            `S1: next_state = `S2;
            `S2: next_state = `S3;
            `S3: next_state = `S4;
            `S4: next_state = `S5;
            `S5: next_state = `S6;
            `S6: next_state = `S7;
            `S7: next_state = `S8;
            `S8: next_state = `S9;
            `S9: next_state = `S10;
            `S10: next_state = `S11;
            `S11: next_state = `S0;
            default: next_state = `S0; 
        endcase 
    end 

    //state behaviour
    always @(*) begin 
        case(current_state)
            `S0:  LED_reg = 8'b0000001; 
            `S1:  LED_reg = 8'b0000010; 
            `S2:  LED_reg = 8'b0000100; 
            `S3:  LED_reg = 8'b0001000; 
            `S4:  LED_reg = 8'b0010000;
            `S5:  LED_reg = 8'b0100000; 
            `S6:  LED_reg = 8'b1000000;
            `S7:  LED_reg = 8'b0100000; 
            `S8:  LED_reg = 8'b0010000; 
            `S9:  LED_reg = 8'b0001000; 
            `S10:  LED_reg = 8'b0000100;
            `S11:  LED_reg = 8'b0000010; 
            default:  LED_reg = 8'bx;
        endcase
    end
endmodule 


module vDFF(clk, in, out); 
	input clk; 
	input [3:0] in; 
	output [3:0] out;
	reg [3:0] out; 

	always @(posedge clk) begin  
	  out <= in; 
	end
endmodule 