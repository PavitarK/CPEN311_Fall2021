module swap_fsm(clk, counter_i, counter_j, s, swap_flag, swap_done, s_out);
input clk;
input swap_flag;
input logic [7:0] counter_i;
input logic [7:0] counter_j;
input logic [7:0] s[256];
output swap_done;
output logic [7:0] s_out[256];

parameter start = 5'b00000;
parameter s_out_assign = 5'b00010;
parameter swap_state_j = 5'b00100;
parameter swap_state_i = 5'b01000;
parameter done = 5'b00001;

reg [4:0] state = start;

assign swap_done = state[0];

always_ff @(clk) begin
    case (state)
        start: 
        begin
            if(swap_flag) state <= swap_state;
            else state <= start;
        end
        s_out_assign:
        begin
            s_out <= s;
        end
        swap_state_i: 
        begin
            s_out[counter_i] <= counter_j;
            state <= wait_state;
        end
        wait_state: state <= swap_state_j
        swap_state_j:
        begin
             s_out[counter_j] <= counter_i;
            state <= done;
        end
        done:
        begin
            state <= start;
        end
        begin
            state <= 5'bzzzzz;
            s_out <= s_out;
        end
    endcase
end
endmodule