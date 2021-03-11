`default_nettype none

module task2_fsm(clk, s, fsm1_done, secret_key, done_flag);
input clk;
input fsm1_done;
input reg [7:0] s[256];
input reg [7:0] secret_key[3];
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
    endcase
end
endmodule