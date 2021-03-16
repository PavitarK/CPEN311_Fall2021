`default_nettype none

module ksa(CLOCK_50, KEY, SW, LEDR, 
           HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input        logic               CLOCK_50;

//////////// LED //////////
output     logic      [9:0]      LEDR;

//////////// KEY //////////
input       logic     [3:0]      KEY;

//////////// SW //////////
input       logic     [9:0]      SW;

//////////// SEG7 //////////
output     logic      [6:0]      HEX0;
output      logic     [6:0]      HEX1;
output     logic      [6:0]      HEX2;
output      logic     [6:0]      HEX3;
output     logic      [6:0]      HEX4;
output      logic     [6:0]      HEX5;

//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [9:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDR[9:0] = LED[9:0];

    logic wren, wren1, wren2, fsm1_active, fsm2_active; 
    logic [7:0] address;
    logic [7:0] counter1;
    logic [7:0] address2;
    logic [7:0] data2;
    logic [7:0] out_mem; 
    //reg [7:0] s[256]; 
    logic done_flag_fsm1, fsm2_done; 
    logic [7:0] secret_key [3];
    logic [7:0] data; 
    logic [1:0] fsm_active;

    assign secret_key = '{8'b0 ,8'b0000_0010 ,8'b0100_1001}; 
    assign fsm_active = {fsm2_active, fsm1_active};

    //mux for RAM1 signals 
    always @(posedge CLOCK_50) begin 
        case(fsm_active) 
        2'b01: begin 
                wren <= wren1;
                address <= counter1;  
                data <= counter1; 
             end 
        2'b10: begin 
                wren <= wren2; 
                address <= address2;
                data <= data2;  
             end 
       default: begin 
                wren <= wren;
                address <= address; 
                data <= data; 
            end 
        endcase 
    end 

   
    task1_fsm fillArray(.clk(CLOCK_50), .done_flag(done_flag_fsm1), .wren(wren1), .counter(counter1), .fsm1_active(fsm1_active));
    
    task2_fsm task2(.clk(CLOCK_50), .fsm1_done(done_flag_fsm1), .out_mem(out_mem), 
                    .secret_key(secret_key), .done_flag(fsm2_done), .wren(wren2), 
                    .address(address2), .data(data2), .fsm2_active(fsm2_active));
    
    s_memory RAM1(.address(address), .clock(CLOCK_50), .data(data), .wren(wren), .q(out_mem));


endmodule 

// module tb_ksa(); 

// logic CLOCK_50;
// logic KEY[3:0];
// logic SW[8:0];
// logic LEDR[9:0]; 
// logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


// ksa dut(CLOCK_50, KEY, SW, LEDR, 
//            HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

//      initial begin 
//             CLOCK_50 = 0; 
//         forever begin 
//             #1
//             CLOCK_50 = !CLOCK_50; 
//         end 
//     end 

// endmodule 