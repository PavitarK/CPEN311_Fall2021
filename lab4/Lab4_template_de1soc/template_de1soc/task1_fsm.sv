`default_nettype none

module task1_fsm(clk, s, done_flag, wren, fsm1_active, counter);
input clk; 
output reg [7:0] s[256];
output done_flag;
output fsm1_active; 
output wren; 
output counter; 

parameter start = 5'b10000;
parameter array_fill = 5'b10010;
parameter counter_inc = 5'b10100;
parameter done = 5'b00001;

reg [4:0] state = start;
reg [7:0] counter = 0;
logic [7:0] out_mem; 
logic wren = 0;

assign done_flag = state[0];
assign wren = state[1];
assign fsm1_active = state[4];

always @(posedge clk) begin
    case(state)
        start: begin state <= array_fill; end
        array_fill: begin 
                        //state <= counter_inc;
                        counter <= counter + 1;
                        s[counter] <= counter;
                        if(counter <= 8'd255) state <= array_fill;
                        else state <= done;
                    end
        // counter_inc: begin 
        //                 if(counter <= 8'd255) state <= array_fill;
        //                 else if (counter > 8'd255) state <= done;

        //              end
        done: begin state <= done; end
        default: begin 
            state <= 5'bzzzzz; 
            counter <= counter; 
        end
    endcase 
end
endmodule 

