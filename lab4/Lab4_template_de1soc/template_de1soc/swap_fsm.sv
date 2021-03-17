`timescale 1 ps / 1 ps

module swap_fsm(clk, counter_i, counter_j, swap_flag, swap_done, wren, address, out_mem, data);
input logic clk;
input logic swap_flag;
input logic [7:0] counter_i;
input logic [7:0] counter_j;
input logic [7:0] out_mem; 
output logic [7:0] address; 
output logic swap_done;
output logic wren; 
output logic [7:0] data; 

parameter start         = 12'b0000_0001_0000; //16: update address to counter i
parameter get_i         = 12'b0000_0001_0010; //18: update address to counter i? 
parameter get_j         = 12'b0000_0010_0011; //35: update address to counter j
parameter wait1         = 12'b0000_0100_0100; //4: do nothing 
parameter wait2         = 12'b0000_1000_0101; //5: do nothing 
parameter store_i       = 12'b0000_0010_0111; //71: update temp_i
parameter store_j       = 12'b0001_0001_1111; //143: update temp_j
parameter swap_state_j  = 12'b0110_0010_0100; //1572: update address to counter j AND update data to temp_i AND wren
parameter swap_state_i  = 12'b0101_0001_1000; //1304: update address to counter i AND update data to temp_j AND wren
parameter wait3         = 12'b0110_0010_1001; //1033: do nothing AND wren 
parameter wait4         = 12'b0100_0000_1011; //1035: do nothing AND wren
parameter done          = 12'b1000_0000_0000; //2048: raise done flag

// parameter start         = 12'b0000_0001_0000; //16: update address to counter i
// parameter get_i         = 12'b0000_0001_0010; //18: update address to counter i? 
// parameter get_j         = 12'b0000_0010_0011; //35: update address to counter j
// parameter wait1         = 12'b0000_0000_0100; //4: do nothing 
// parameter wait2         = 12'b0000_0000_0101; //5: do nothing 
// parameter store_i       = 12'b0000_0100_0111; //71: update temp_i
// parameter store_j       = 12'b0000_1000_1111; //143: update temp_j
// parameter swap_state_j  = 12'b0110_0010_0100; //1572: update address to counter j AND update data to temp_i AND wren
// parameter swap_state_i  = 12'b0101_0001_1000; //1304: update address to counter i AND update data to temp_j AND wren
// parameter wait3         = 12'b0100_0000_1001; //1033: do nothing AND wren 
// parameter wait4         = 12'b0100_0000_1011; //1035: do nothing AND wren
// parameter done          = 12'b1000_0000_0000; //2048: raise done flag 

logic [7:0] temp_i, temp_j; 
reg [11:0] state = start;
logic address_i, address_j, tempi_enable, tempj_enable, update_data_i, update_data_j; 

assign address_i     = state[4]; //set address to i 
assign address_j     = state[5]; //set address to j
assign tempi_enable  = state[6]; //update temp_i
assign tempj_enable  = state[7]; //update temp_j

assign update_data_i = state[8]; //update data to i
assign update_data_j = state[9]; //update data to j
assign wren          = state[10]; 
assign swap_done     = state[11];
/*
wait
get s[i]
wait 
store s[i]
get s[j]
wait
store s[j]
put s[j] in s[i]
put s[i] in s]j
finish
*/

always_ff @(posedge clk) begin 
    if(address_i) 
        address <= counter_i; 
    else if(address_j)
        address <= counter_j; 
    else 
        address <= address; 
end

always_ff @(posedge clk) begin 
    if(tempi_enable)
        temp_i <= out_mem; 
    else 
        temp_i <= temp_i; 
end 

always_ff @(posedge clk) begin 
    if(tempj_enable)
        temp_j <= out_mem; 
    else 
        temp_j <= temp_j; 
end 

always_ff @(posedge clk) begin 
    if(update_data_i)
        data <= temp_i; 
    else if(update_data_j)
        data <= temp_j;
    else 
        data <= data; 
end 

//state controller
always_ff @(posedge clk) begin
    case (state)
        start: 
        begin
            if(swap_flag) state <= get_i;
            else state <= start;
            //address <= counter_i; //keep this as whatever the counter in task2fsm is until we need to read alternate values
        end

        get_i: begin
            // address <= counter_i; //?
            state <= wait1; 
        end

        wait1: state <= store_i;

        store_i: begin 
            state <= get_j; 
            //temp_i <= out_mem; //temp <= s[i]
        end 

        get_j: begin 
            state <= wait2; 
            //address <= counter_j; 
        end 
        
        wait2: state <= store_j; 

        store_j: begin 
            state <= swap_state_i;  
            //temp_j <= out_mem; 
        end 
    
        swap_state_i: begin
            //address <= counter_i;
            state <= wait3;
            //data <= temp_j; //temp_j
        end

        wait3: state <= swap_state_j; 

        swap_state_j: begin
             //address <= counter_j;
             //data <= temp_i; //temp_i
             state <= wait4; 
        end

        wait4: state <= done;

        done: begin 
            state <= start;
            // address <= counter_i; //????
            end
        default: begin
            state <= 5'bzzzzz; 
            // address = address; 
            // data = data; 
        end
    endcase
end
endmodule

module tb_swap_fsm();

   logic clk, wren, swap_done, swap_flag; 
   logic [7:0] counter_i, counter_j, out_mem, address, data; 
   logic [7:0] s[256];
   logic [7:0] s_out[256];

    swap_fsm dut(clk, counter_i, counter_j, swap_flag, swap_done, wren, address, out_mem, data);

    initial begin 
            clk = 0; 
            swap_flag = 0; 
            counter_i = 0; 
            counter_j = 4;
            out_mem = 0; 
        forever begin 
            #1
            clk = !clk; 
        end 
    end 

    initial begin 
        //address should be i=0 and should stay in start state 
        #6;

        //state machine starts
        //address is i=0 
        swap_flag = 1; 

        //state goes into wait1
        #2;
        out_mem = 8'd50;  
        #2;

        //entering store i state temp_i should get whatever the out_mem is holding
        #2; 

        //entering get_j 
        //address is j=4

        #2; 
        //enter wait2
        out_mem = 8'd2; 
        #2;
        //temp_j gets 2 
        #2 
        //starting swap 
        //address get i=o
        //data gets tempj = 2
        #2;
        //entering wait3
        #2; 
        //next swap 
        //address get j=4 
        //data data i=0
        #2; 
        //entering wait 4
        #2; 
        //endtering done 
        //done flag should go up
        swap_flag = 0; 

        

    end 


endmodule 