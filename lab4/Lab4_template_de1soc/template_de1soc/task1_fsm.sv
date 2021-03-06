`default_nettype none

module task1_fsm(clk, done_flag, wren, fsm1_active, counter);
input logic clk; 
output logic done_flag;
output logic fsm1_active; 
output logic wren; 
output counter; 

parameter start = 5'b10000;
parameter array_fill = 5'b10010;
// parameter counter_inc = 5'b10100;
parameter done = 5'b00001;

reg [4:0] state = start;
reg [7:0] counter = 8'b0;
logic [7:0] out_mem; 
//logic wren = 0;

assign done_flag = state[0];
assign wren = state[1];
assign fsm1_active = state[4];

always @(posedge clk) begin
    case(state)
        start: begin state <= array_fill; end
        array_fill: begin 
                        //state <= counter_inc;
                        counter <= counter + 1;
                        //s[counter] <= counter;
                        if(counter < 8'd255) state <= array_fill;
                        else state <= done;
                    end
        done: begin state <= done; end
        default: begin 
            state <= 5'bzzzzz; 
            counter <= counter; 
        end
    endcase 
end
endmodule 

module tb_task1_fsm(); 

    logic clk, wren, fsm1_active, done_flag;
    logic [7:0] s[256]; 
    logic [7:0] counter;  

    task1_fsm dut(clk, s, done_flag, wren, fsm1_active, counter);

    initial begin
        clk = 0; 
        forever begin
            #2;  
            clk = !clk; 
        end
    end 

endmodule 

