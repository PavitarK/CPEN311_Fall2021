`default_nettype none
`timescale 1 ps / 1 ps

module task2b_fsm(clk, fsm2_done, out_mem, wren, address, data, done_flag, fsm3_active);
input logic clk;
input logic fsm2_done;
input logic [7:0] out_mem;
output logic done_flag;
output logic [7:0] address; 
output logic [7:0] data; 
output logic wren; 
output logic fsm3_active; 

logic swap_flag;
logic swap_done;
logic [7:0] counter_i, counter_j, counter_k, f, s_f, temp_i;

logic [7:0] address_in, address_out, encrypted_input, decrypted_output, data_decrypted;
logic wren_d;


parameter start         = 10'b00_0010_0000; //32
parameter j_logic       = 10'b00_0101_0010; //82
parameter f_logic_i     = 10'b00_0101_0110; //86
parameter f_logic_j     = 10'b00_0111_0110; //118
parameter f_logic_sum   = 10'b00_1111_0110; //246
parameter decrypt_state = 10'b00_1111_0100; //244
parameter counter_inc   = 10'b00_1001_0100; //148
parameter swap_state    = 10'b01_0001_1000; //280
parameter k_inc         = 10'b00_0011_0100; //52
parameter done          = 10'b10_0000_0001; //513
parameter wait_1        = 10'b00_0001_0000; //16
parameter wait_2        = 10'b00_0011_0000; //48
parameter wait_3        = 10'b00_0111_0000; //112

reg [9:0] state = start;

assign done_flag = state[0];
assign swap_flag = state[3];
assign fsm3_active = state[4];

swap_fsm swap_fsm(.clk(clk), 
                  .counter_i(counter_i), 
                  .counter_j(counter_j), 
                  .swap_flag(swap_flag), 
                  .swap_done(swap_done), 
                  .wren(wren), 
                  .address(address), 
                  .out_mem(out_mem), 
                  .data(data));

s_memory encrypted_input( .address(address_in), .clock(clk), .q(encrypted_input));
s_memory decrypted_output( .address(address_out), .clock(clk), .data(data_decrypted), .wren(wren_d), .q(decrypted_output));

always_ff @(posedge clk) begin
    case(state)
        start:
            begin 
                if(fsm2_done) state <= counter_inc;
                else state <= start;
            end

        counter_inc: 
            begin 
                // counter_i = counter_i + 1
                state <= j_logic; 
            end

        j_logic:
            begin
                // j = j + s[i]
                state <= swap_state;
            end

        swap_state: // call some swap fsm
            begin
                if(!swap_done) state <= swap_state;
                else state <= f_logic;
            end

        f_logic_i:
            begin
                // s_f = out_mem; temp_i = counter_i;
                state <= wait_1;
            end

        wait_1: state <= f_logic_j;

        f_logic_j:
            begin
                //counter_i = counter_j; s_f += out_mem
                state <= wait_2;
            end

        wait_2: state <= f_logic_sum;
        f_logic_sum:
            begin
                //counter_i = s_f; f = out_mem;
                state <= wait_3;
            end

        wait_3: state <= decrypt_state;

        decrypt_state:
            begin
                state <= k_inc;
            end

        k_inc:
            begin
                if (k <= 31) state <= start; // k is between 0 and 31
                else state <= doone
            end

        done: state <= done;

        default: 
            begin
                state <= 10'bzzzzz;
            end 
    endcase
end

always_ff @(posedge clk) begin
    case(state)
        start:
            begin
                address_in <= k;
                address_out <= k; 
            end

        counter_inc: 
            begin 
                counter_i <= counter_i + 1;
            end

        j_logic:
            begin
                j <= j + out_mem;
            end

        f_logic_i:
            begin
                s_f <= out_mem; 
                temp_i <= counter_i;
            end
        f_logic_j:
            begin
                counter_i <= counter_j; 
                s_f <= s_f + out_mem;
            end

        f_logic_sum:
            begin
                counter_i <= s_f; 
                f <= out_mem;
            end
            
        decrypt_state:
            begin
                wren_d <= 1'b1;
                data_decrypted <= out_mem ^ encrypted_input;
            end

        k_inc:
            begin
                wren_d <= 1'b0;
                k <= k + 1;
                counter_i <= temp_i;
            end

        default: 
            begin
                state <= 10'bzzzzz;
            end 
    endcase
end 

endmodule

module tb_task2b_fsm();

//Inputs

logic clk;
logic fsm2_done;
logic [7:0] out_mem; 

//Outputs

logic done_flag, fsm3_active;
logic [7:0] address; 
logic [7:0] data; 
logic wren;

task2b_fsm dut(clk, fsm2_done, out_mem, wren, address, data, done_flag, fsm3_active;

initial
forever #1 clk = ~clk;

initial
begin
clk = 0;
fsm2_done = 1;
out_mem = 8'd128;
end

endmodule