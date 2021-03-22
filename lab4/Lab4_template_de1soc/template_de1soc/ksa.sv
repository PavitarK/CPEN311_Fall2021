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
    logic [7:0] address;
    logic [7:0] counter1;
    logic [7:0] address2;
    logic [7:0] data2;
    logic [7:0] out_mem; 
    //reg [7:0] s[256]; 
    logic done_flag_fsm1, fsm2_done; 
    logic [23:0] secret;
    logic [7:0] secret_key [3];
    logic [7:0] data; 
    logic [1:0] fsm_active;
    logic [1:0] crack_success;

    //assign secret_key = '{ 8'b0, 8'd2, 8'd73}; 
    assign fsm_active = {fsm2_active, fsm1_active};

    //mux for RAM1 signals 
    // always @(posedge CLOCK_50) begin 
    //     case(fsm_active) 
    //     2'b01: begin 
    //             wren <= wren1;
    //             address <= counter1;  
    //             data <= counter1; 
    //          end 
    //     2'b10: begin 
    //             wren <= wren2; 
    //             address <= address2;
    //             data <= data2;  
    //          end 
    //    default: begin 
    //             wren <= wren;
    //             address <= address; 
    //             data <= data; 
    //         end 
    //     endcase 
    // end 

   
    //task1_fsm fillArray(.clk(CLOCK_50), .done_flag(done_flag_fsm1), .wren(wren1), .counter(counter1), .fsm1_active(fsm1_active));
    
    task2_fsm task2(.clk(CLOCK_50),
                    .secret(secret), 
                    .secret_key(secret_key), 
                    .done_flag(fsm2_done), 
                    .wren(wren2), 
                    .address(address2), 
                    .data(data2), 
                    .fsm2_active(fsm2_active),
                    .crack_success(crack_success));
    always @(posedge CLOCK_50) begin
        if (crack_success == 2'b01) begin LED[0] = 1'b1; LED[9:1] = 9'b0; end
        else if (crack_success == 2'b10) begin LED[1] = 1'b1; LED[9:2] = 8'b0; LED[0] = 1'b0; end
        else LED[9:0] = 10'b0;
    end

    logic [7:0] Seven_Seg_Val[5:0];
    logic [3:0] Seven_Seg_Data[5:0];
    
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
    SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));

    assign HEX0 = Seven_Seg_Val[0];
    assign HEX1 = Seven_Seg_Val[1];
    assign HEX2 = Seven_Seg_Val[2];
    assign HEX3 = Seven_Seg_Val[3];
    assign HEX4 = Seven_Seg_Val[4];
    assign HEX5 = Seven_Seg_Val[5];

    assign Seven_Seg_Data[0] = secret[3:0];
    assign Seven_Seg_Data[1] = secret[7:4];
    assign Seven_Seg_Data[2] = secret[11:8];
    assign Seven_Seg_Data[3] = secret[15:12];
    assign Seven_Seg_Data[4] = secret[19:16];
    assign Seven_Seg_Data[5] = secret[23:20];


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