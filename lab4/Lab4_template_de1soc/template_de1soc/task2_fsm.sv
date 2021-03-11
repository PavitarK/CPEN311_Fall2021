`default_nettype none

module task2_fsm(clk, s, fsm1_done, out_mem, secret_key, done_flag, wren, address, data);
input clk;
input fsm1_done;
input reg [7:0] s[256];
input reg [7:0] secret_key[3]; //why is this only third bit?? 
input logic [7:0] out_mem; 
output done_flag;
output [7:0] address; 
output [7:0] data; 

lgoic swap_flag;
logic swap_done;
logic wren; 
logic [7:0] counter_i = 0;
logic [7:0] counter_j = 0;
logic [7:0] array_func[256];


parameter start = 5'b00000;
parameter j_logic = 5'b00010;
parameter counter_inc = 5'b00100;
parameter swap_state = 5'b01000;
parameter done = 5'b00001;

reg [4:0] state = start;

assign done_flag = state[0];
assign swap_flag = state[3];
assign array_func = s;

swap_fsm swap_fsm(.clk(clk), .counter_i(counter_i), .counter_j(counter_j), 
                .s(array_func), .swap_flag(swap_flag), .swap_done(swap_done), 
                .wren(wren), .s_out(array_func), .address(address), .out_mem(out_mem), .data(data));

/*
set j = 0 
set i = 0 
wait 
get s[i]
set j
swap i and j its own fsm 
check i <255
increment
done 
*/
always_ff @(posedge clk) begin
    case(state)
        start:
            begin 
                if(fsm1_done) state <= j_logic;
                else state <= start;
            end
        j_logic: 
            begin 
                counter_j <= counter_j + out_mem + secret_key[counter_i % 3];
                state <= swap_state; 
            end
        swap_state: // call some swap fsm
            begin
                if(!swap_done) state <= swap_state;
                else if(counter <= 8'd255 && swap_done) state <= counter_inc;
                else state <= done;
            end
        counter_inc:
            begin
                counter_i <= counter_i + 1;
                state <= j_logic;
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