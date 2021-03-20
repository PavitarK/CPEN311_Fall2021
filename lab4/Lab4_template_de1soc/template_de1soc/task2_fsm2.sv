`default_nettype none
`timescale 1 ps / 1 ps

module task2_fsm2(clk, fsm1_done, out_mem, secret_key, done_flag, wren, address, data, fsm2_active);
input logic clk;
input logic fsm1_done;
input reg [7:0] secret_key[3]; 
input logic [7:0] out_mem; 
output logic done_flag;
output logic [7:0] address; 
output logic [7:0] data; 
output logic wren; 
output logic fsm2_active; 

logic [7:0] counter_i;
logic [7:0] temp_i;
logic [7:0] counter_j;
logic [7:0] temp_j;
logic j_enable, i_enable, reset_flag, address_i, address_j, tempi_enable;
logic tempj_enable, update_data_i, update_data_j; 
logic [7:0] address_reg, data_reg; 

                            //65432_1098_7654_3210
parameter waitforfsm1   = 17'b00000_0000_0000_0000; // nothing
parameter start         = 17'b00000_0000_0110_0001; // raise reset flag AND fsm active flag
parameter wait_0        = 17'b00000_0000_0010_0010;
parameter store_i       = 17'b00000_1000_0010_0011; // tempi_enable
parameter j_logic       = 17'b00000_0000_1010_0100; // j_enable and address_j
parameter wait_1        = 17'b00000_0100_0010_0101; //
parameter store_j       = 17'b00001_0000_0010_0111; // tempj_enable
parameter swap_1        = 17'b01000_0000_0010_1000; // data_i, wren 
parameter wait_2        = 17'b00000_0000_0010_1001; // lower wren
parameter swap_2        = 17'b01000_0000_0010_1010; // update adress i, data_j, wren 
parameter wait_3        = 17'b00000_0000_0010_1100; //
parameter check_inc     = 17'b00000_0000_0011_1101;
parameter counter_inc   = 17'b00000_0001_0010_1110; // i_enable
parameter reset_address = 17'b00000_0010_0010_1111; // address_i
parameter done          = 17'b10000_0000_0001_1111; //
parameter wait_4        = 17'b00010_0000_0010_0111;
parameter wait_5        = 17'b00100_0010_0010_1010;
parameter state1        = 17'b00000_0000_0010_0101;

reg [16:0] state = waitforfsm1;

assign fsm2_active = state[5];
assign reset_flag = state[6];

assign j_enable = state[7]; //update counter j signal
assign i_enable = state[8]; //update counter i signal

assign address_i = state[9];
assign address_j = state[10];

assign tempi_enable = state[11];
assign tempj_enable = state[12]; 
assign update_data_i = state[13];
assign update_data_j = state[14];
assign wren = state[15];
assign done_flag = state[16];

assign address = address_reg; 
assign data = data_reg; 

/*
init loop -> swap -> wait 1 -> store i -> calc j -> wait 2 -> read j -> write at j -> wait 3 -> write at i -> wait 4 -> inc -> done
*/
always_ff @(posedge clk) begin
    case(state)
        waitforfsm1:
            begin 
                if(fsm1_done) state <= start;
                else state <= waitforfsm1;
            end
        start: begin 
            state <= wait_0;
        end 
        wait_0: begin 
            state <= store_i;  
        end 

        store_i: begin 
             state <= j_logic; 
             //temp_i <= out_mem; 
        end 

        j_logic: begin 
           // counter_j <= counter_j + out_mem + secret_key[counter_i % 3];
            state <= wait_1;
        end 

        wait_1: state <= state1;            //address <= counter_j;

        state1: state <= store_j;

        store_j: begin
            state <= wait_4;
            //temp_j <= out_mem; 
        end

        wait_4: begin
            state <= swap_1;
            //data <= temp_i; 
        end

        swap_1: begin 
            state <= wait_2; 
            //wren <=1; 
        end 
        
        wait_2: begin 
            state <= wait_5; 
            //wren <= 0; 
        end 

        wait_5: begin
            state <= swap_2;
            //address <= counter_i; 
             //data <= temp_j; 
        end

        swap_2:begin 
             state <= wait_3;
            
             //wren <= 1; 
        end 

         wait_3: begin 
             state <= check_inc; 
             //wren <= 0; 
         end 

        check_inc: begin 
            if(counter_i == 8'd255)
                state <= done; 
            else
                state <= counter_inc; 
        end 

        counter_inc: begin 
            state <= reset_address; 
            //counter_i <= counter_i + 1;  
        end 

        reset_address: begin 
            //address <= counter_i; 
            state <= wait_0; 
        end 

        done: state <= done; 
        default: 
            begin
                state <= 17'bz;
            end 
    endcase
end

always_ff @(posedge tempj_enable or posedge reset_flag) begin 
        if(reset_flag)
            temp_j <= 8'b0; 
        else if(tempj_enable)
            temp_j <= out_mem; 
        else
            temp_j <= temp_j; 
end 

always_ff @(posedge tempi_enable or posedge reset_flag) begin 
    if(reset_flag)
        temp_i <= 8'b0; 
    else if(tempi_enable)
        temp_i <= out_mem; 
    else 
        temp_i <= temp_i; 
end

always_ff @(posedge j_enable or posedge reset_flag) begin 
    if(reset_flag)
        counter_j <= 8'b0; 
    else if(j_enable)
        counter_j <= counter_j + out_mem + secret_key[counter_i % 3];
    else 
        counter_j <= counter_j; 
end 

always_ff @(posedge i_enable or posedge reset_flag) begin 
    if(reset_flag)
        counter_i <= 8'b0; 
    else if(i_enable)
        counter_i <= counter_i + 1; 
    else 
        counter_i <= counter_i; 
end 

always_ff @(posedge address_i or posedge address_j or posedge reset_flag) begin 
    if(reset_flag)
        address_reg <= 8'b0;
    else if(address_i) 
        address_reg <= counter_i; 
    else if(address_j)
        address_reg <= counter_j; 
    else    
        address_reg <= address_reg; 
end 

always_ff @(posedge update_data_i or posedge update_data_j or posedge reset_flag) begin
    if(reset_flag)
        data_reg <= 8'b0; 
    else if(update_data_i)
        data_reg <= temp_i; 
    else if(update_data_j)
        data_reg <= temp_j; 
    else 
        data_reg <= data_reg; 
end 

endmodule

module tb_task2_fsm2();

//Inputs

logic clk, fsm2_active;
logic fsm1_done;
logic [7:0] s[256];
logic [7:0] secret_key[3]; 
logic [7:0] out_mem; 

//Outputs

logic done_flag;
logic [7:0] address; 
logic [7:0] data; 
logic wren;

task2_fsm2 dut(clk, fsm1_done, out_mem, secret_key, done_flag, wren, address, data, fsm2_active);

initial
forever #1 clk = ~clk;

initial
begin
clk = 0;
fsm1_done = 1;
s = '{8'd0,8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7,8'd8,8'd9,
    8'd10,8'd11,8'd12,8'd13,8'd14,8'd15,8'd16,8'd17,8'd18,8'd019,
    8'd20,8'd21,8'd22,8'd23,8'd24,8'd25,8'd26,8'd27,8'd28,8'd029,
    8'd30,8'd31,8'd32,8'd33,8'd34,8'd35,8'd316,8'd37,8'd38,8'd039,
    8'd40,8'd41,8'd42,8'd43,8'd44,8'd45,8'd46,8'd47,8'd48,8'd049,
    8'd50,8'd51,8'd52,8'd53,8'd54,8'd55,8'd56,8'd57,8'd58,8'd059,
    8'd60,8'd61,8'd62,8'd63,8'd64,8'd65,8'd66,8'd67,8'd68,8'd069,
    8'd70,8'd71,8'd72,8'd73,8'd74,8'd75,8'd76,8'd77,8'd78,8'd079,
    8'd80,8'd81,8'd82,8'd83,8'd84,8'd85,8'd86,8'd87,8'd88,8'd089,
    8'd90,8'd91,8'd92,8'd93,8'd94,8'd95,8'd96,8'd97,8'd98,8'd099,
    8'd100,8'd101,8'd102,8'd103,8'd104,8'd105,8'd106,8'd107,8'd108,8'd109,
    8'd110,8'd111,8'd112,8'd113,8'd114,8'd115,8'd116,8'd117,8'd118,8'd119,
    8'd120,8'd121,8'd122,8'd123,8'd124,8'd125,8'd126,8'd127,8'd128,8'd129,
    8'd130,8'd131,8'd132,8'd133,8'd134,8'd135,8'd136,8'd137,8'd138,8'd139,
    8'd140,8'd141,8'd142,8'd143,8'd144,8'd145,8'd146,8'd147,8'd148,8'd149,
    8'd150,8'd151,8'd152,8'd153,8'd154,8'd155,8'd156,8'd157,8'd158,8'd159,
    8'd160,8'd161,8'd162,8'd163,8'd164,8'd165,8'd166,8'd167,8'd168,8'd169,
    8'd170,8'd171,8'd172,8'd173,8'd174,8'd175,8'd176,8'd177,8'd178,8'd179,
    8'd180,8'd181,8'd182,8'd183,8'd184,8'd185,8'd186,8'd187,8'd188,8'd189,
    8'd190,8'd191,8'd192,8'd193,8'd194,8'd195,8'd196,8'd197,8'd198,8'd199,
    8'd200,8'd201,8'd202,8'd203,8'd204,8'd205,8'd206,8'd207,8'd208,8'd209,
    8'd210,8'd211,8'd212,8'd213,8'd214,8'd215,8'd216,8'd217,8'd218,8'd219,
    8'd220,8'd221,8'd222,8'd223,8'd224,8'd225,8'd226,8'd227,8'd228,8'd229,
    8'd230,8'd231,8'd232,8'd233,8'd234,8'd235,8'd236,8'd237,8'd238,8'd239,
    8'd240,8'd241,8'd242,8'd243,8'd244,8'd245,8'd246,8'd247,8'd248,8'd249,
    8'd250,8'd251,8'd252,8'd253,8'd254,8'd255};
    secret_key = '{8'b0 ,8'b0000_0010 ,8'b0100_1001}; 
    out_mem = 8'd128;

    #15; 
    out_mem = 8'd100; 

    #15; 
    out_mem = 8'd50; 

    #15
    out_mem = 8'd150; 

    #15; 
    out_mem = 8'd200; 

end

endmodule