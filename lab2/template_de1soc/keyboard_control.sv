`timescale 1 ps / 1 ps

module keyboard_control(clk, key, startstop, direction);

    input clk; 
    input [7:0] key; 
    output startstop, direction; 

    parameter backward = 8'h62; //backward B
    parameter backwardUp =8'h42;
    parameter stop = 8'h64; //stop D
    parameter stopUp =8'h44;
    parameter start = 8'h65; //start E
    parameter startUp = 8'h45;
    parameter forward = 8'h66; //forward F
    parameter forwardUp = 8'h46;
    parameter character_lowercase_r = 8'h72; //optional

    //states_direction_start
     parameter check_key = 6'b000_000;
     parameter start_forward = 6'b001_011;
     parameter start_backward = 6'b011_001;
     parameter stop_forward = 6'b100_010;
     parameter stop_backward = 6'b101_000;

     logic [5:0] state = check_key; 

    assign startstop = state[0]; //1 start 0 is stop
    assign direction = state[1]; // 1 is forward 0 is backward

    always_ff @(posedge clk) begin 
        case(state)
            check_key: 
                if (key == start || key == startUp)
                     state <= start_forward; 
                else if (key == backward || key == backwardUp)
                     state <= start_backward; 
                else 
                    state <= check_key; 

            start_forward: 
                if(key == stop || key == stopUp)
                    state <= stop_forward; 
                else if(key == backward || key == backwardUp)
                    state <= start_backward; 
                else state <= start_forward; 

            start_backward: 
                if(key == forward || key == forwardUp)
                    state <= start_forward; 
                else if(key == stop || key == stopUp)
                    state <= stop_backward; 
                else 
                    state <= start_backward; 

            stop_forward: 
                if(key == start || key == startUp)
                    state <= start_forward; 
                else if(key == backward || key == backwardUp)
                    state <= stop_backward; 
                else 
                    state<= stop_forward;
                     
            stop_backward: 
                 if(key == start || key == startUp)
                    state <= start_backward; 
                else if(key == forward || key == forwardUp)
                    state <= stop_forward; 
                else 
                    state<= stop_backward; 
            default: state <= check_key; 
        endcase 
    end 
endmodule 

module tb_keyboard_control(); 

    logic clk, startstop,direction; 
    logic [7:0] key; 

    keyboard_control dut(clk, key, startstop, direction);

     initial begin 
            clk = 0; 
            key = 0; 
        forever begin 
            #5
            clk = !clk;
        end 
    end 

    initial begin 
        #10; 
        key = 8'h65;

        #20; 
        key = 8'h64;
        #20; 
        key = 8'h62;
        #20; 
        key = 8'h65;
    end 
endmodule 