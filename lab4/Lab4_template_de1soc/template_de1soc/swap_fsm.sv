`timescale 1 ps / 1 ps

module swap_fsm(clk, counter_i, counter_j, s, swap_flag, swap_done, s_out, wren, address, out_mem, data);
input logic clk;
input logic swap_flag;
input logic [7:0] counter_i;
input logic [7:0] counter_j;
input logic [7:0] out_mem; 
input logic [7:0] s[256];
output logic [7:0] address; 
output logic swap_done;
output logic [7:0] s_out[256]; //can remove? 
output logic wren; 
output logic [7:0] data; 

parameter start         = 8'b0000_0000;
parameter get_i         = 8'b0000_0010;
parameter get_j         = 8'b0000_0011;
parameter wait1         = 8'b0000_0100;
parameter wait2         = 8'b0000_0101; 
parameter store_i       = 8'b0000_0111; 
parameter store_j       = 8'b0000_1111; 
parameter swap_state_j  = 8'b0001_0100;
parameter swap_state_i  = 8'b0001_1000;
parameter wait3         = 8'b0001_1001;
parameter wait4         = 8'b0001_1011;
parameter done          = 8'b1000_0000;

logic [7:0] temp_i, temp_j; 
reg [7:0] state = start;

assign swap_done = state[7];
assign wren = state[4];

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
    case (state)
        start: 
        begin
            if(swap_flag) state <= get_i;
            else state <= start;
            address <= counter_i; //keep this as whatever the counter in task2fsm is until we need to read alternate values
        end

        get_i: begin
            address <= counter_i; //?
            state <= wait1; 
        end

        wait1: state <= store_i;

        store_i: begin 
            state <= get_j; 
            temp_i <= out_mem; //temp <= s[i]
        end 

        get_j: begin 
            state <= wait2; 
            address <= counter_j; 
        end 
        
        wait2: state <= store_j; 

        store_j: begin 
            state <= swap_state_i;  
            temp_j <= out_mem; 
        end 
    
        swap_state_i: begin
            address <= counter_i;
            state <= wait3;
            data <= temp_j; 
        end

        wait3: state <= swap_state_j;

        swap_state_j: begin
             address <= counter_j;
             data <= temp_i;
             state <= wait4; 
        end

        wait4: state <= done; 

        done: begin 
            state <= start;
            address <= counter_i; //????
            end
        default: begin
            state <= 5'bzzzzz;
            s_out <= s_out; //can remove? 
            address = address; 
            data = data; 
        end
    endcase
end
endmodule

module tb_swap_fsm();

   logic clk, wren, swap_done, swap_flag; 
   logic [7:0] counter_i, counter_j, out_mem, address, data; 
   logic [7:0] s[256];
   logic [7:0] s_out[256];

    swap_fsm dut(clk, counter_i, counter_j, s, swap_flag, swap_done, s_out, wren, address, out_mem, data);

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
        #5;

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