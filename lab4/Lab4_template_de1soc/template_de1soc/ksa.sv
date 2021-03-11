`default_nettype none

module ksa(CLOCK_50, KEY, SW, LEDR, 
           HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;

//////////// LED //////////
output           [9:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input            [9:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;

//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [9:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDR[9:0] = LED[9:0];

    logic wren, wren1, wren2, fsm1_active, fsm2_active; 
    logic [7:0] address, counter1, counter2, data, out_mem; 
    logic reset_n; 
    reg [7:0] s[256]; 
    logic done_flag; 

    assign reset_n = KEY[3]; 

    //mux for RAM1 signals 
    always begin 
        if(fsm1_active) begin 
            wren = wren1;
            address = counter1;  
            data = counter1; 
        end 
        // else if(fsm2_active) begin 
        //     wren = wren2; 
        //     address = counter2;
        //     data = counter2;  
        // end 
        else begin 
            wren = wren;
            address = address; 
            data = data; 
        end 
    end 

    task1_fsm fillArray(.clk(CLOCK_50),.s(s), .done_flag(done_flag), .wren(wren1), .counter(counter1), .fsm1_active(fsm1_active));

    s_memory RAM1(.address(address), .clock(CLOCK_50), .data(data), .wren(wren), .q(out_mem));

endmodule 