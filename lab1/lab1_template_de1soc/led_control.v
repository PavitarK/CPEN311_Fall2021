module led_control(inclk, LED);

    //define states 
    `define S0 4'd0 //LED 0 is on
    `define S1 4'd1 //LED 1 is on
    `define S2 4'd2 //LED 2 is on
    `define S3 4'd3 //LED 3 is on
    `define S4 4'd4 //LED 4 is on
    `define S5 4'd5 //LED 5 is on
    `define S6 4'd6 //LED 6 is on

    //50Mhz Clock 
    input inclk; 
    output [7:0] LED; 

    logic clk_1Hz; 
    logic [7:0] LED_reg;
    logic [3:0] next_state = `S0; 
    logic [3:0] current_state; 

    //controls light direction
    logic bounce = 1'b1; //removing this will remove the latch? 

    assign LED = LED_reg;  

    //make a 1Hz clock via clk divider
    clk_divider slow_clk(.inclk(inclk), .finalcount(28'd50000000), .outclk(clk_1Hz)); 

    //Flip Flop driving state controller
	vDFF state_controller(.clk(clk_1Hz), .in(next_state), .out(current_state)); 

    //state controller, if bounce is high increase led if low decrease led position
    always @(*) begin
        case(current_state)    
            `S0: next_state = `S1; 
            `S1: if(bounce)
                    next_state = `S2;
                else 
                    next_state = `S0; 
            `S2: if(bounce) 
                    next_state = `S3;
                else 
                    next_state = `S1;
            `S3: if(bounce) 
                    next_state = `S4;
                else 
                    next_state = `S2;
            `S4: if(bounce) 
                    next_state = `S5;
                else 
                    next_state = `S3;
            `S5:if(bounce) 
                    next_state = `S6;
                else 
                    next_state = `S4;
            `S6: next_state = `S5;
            default: next_state = `S0; 
        endcase 
    end 

    //state behaviour
    always @(*) begin 
        case(current_state)
            `S0: begin LED_reg = 8'b0000001; bounce = 1'b1; end 
            `S1: begin LED_reg = 8'b0000010; bounce = bounce; end 
            `S2: begin LED_reg = 8'b0000100; bounce = bounce; end
            `S3: begin LED_reg = 8'b0001000; bounce = bounce; end
            `S4: begin LED_reg = 8'b0010000; bounce = bounce; end
            `S5: begin LED_reg = 8'b0100000; bounce = bounce; end
            `S6: begin LED_reg = 8'b1000000; bounce = 1'b0;  end 
            default: begin LED_reg = 8'bx; bounce = 1'bx; end
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