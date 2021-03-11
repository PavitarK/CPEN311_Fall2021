`default_nettype none

module task2_fsm(clk, s, fsm1_done, secret_key, swap_done, swap_flag, done_flag);
input clk;
input fsm1_done;
input reg [7:0] s[256];
input reg [7:0] secret_key[3];
input swap_done
output swap_flag;
output done_flag;
logic [7:0] counter_i = 0;
logic [7:0] counter_j = 0;

parameter start = 5'b00000;
parameter j_logc = 5'b00010;
parameter counter_inc = 5'b00100;
parameter swap_state = 5'b01000;
parameter done = 5'b00001;

reg [4:0] state = start;
assign done_flag = state[0];
assign swap_flag = state[3]

always_ff @(posedge clk) begin
    case(state)
        start:
        begin 
            if(fsm1_done) state <= j_logic;
            else state <= start;
        end
        j_logic: 
        begin 
            counter_j <= counter_j + s[counter_i] + secret_key[counter_i % 3];
            state <= counter_inc
        end
        counter_inc:
        begin
            counter_i <= counter_i + 1;
            state <= swap_state;
        end
        swap_state:
        begin
            // call some swap fsm
            if(!swap_done) state <= swap_state;
            else if(counter <= 8'd255 && swap_done) state <= j_logic;
            else state <= done;
        end
        done: state <= done;
        default: 
        begin
            state <= 5'bzzzzz;
            counter_i <= counter_i;
            counter_j <= counter_j;
        end 
    endcase
end
endmodule