`default_nettype none

module task1_fsm(clk, s, done_flag);
input clk; 
output reg [7:0] s[256];
output done_flag;

parameter start = 5'b00000;
parameter array_fill = 5'b00010;
parameter counter_inc = 5'b00100;
parameter done = 5'b00001;

reg [4:0] state = start;
reg [7:0] counter = 8'd50;
logic [7:0] out_mem; 
logic wren = 0;
assign done_flag = state[0];
assign wren = state[1];

s_memory RAM1(.address(counter), .clock(clk), .data(counter), .wren(wren), .q(out_mem));

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

