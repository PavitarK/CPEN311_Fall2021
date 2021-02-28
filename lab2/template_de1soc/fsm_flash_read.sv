`timescale 1 ps / 1 ps

module fsm_flash_read(CLOCK_50, reset, start, flash_mem_read, flash_mem_address,
                     direction, finish_read, sound_finish);

    input start, reset, CLOCK_50, sound_finish, direction; 
    output logic flash_mem_read; 
    output finish_read;
    output [22:0] flash_mem_address; 

    //state_00_get_address_read
    parameter [7:0] idle = 8'b0001_0000; //do nothing
    parameter [7:0] get_read_address = 8'b0010_0010; //get the next address
    parameter [7:0] send_read_address = 8'b1000_0001; //send the address to flash
    parameter [7:0] finished = 8'b0100_0101; 

    // assign an initial state
    logic [7:0] state = idle; 
    logic get_address; 

    assign flash_mem_read = state[0]; 
    assign get_address = state[1]; 
    assign finish_read = state[2];

    //get the next address
    address_controller get(.CLOCK_50(CLOCK_50), .reset(reset), .get_address(get_address), .address_to_read(flash_mem_address), .direction(direction));

    //state controller
    always_ff @(posedge CLOCK_50 or posedge reset) begin 
        if(reset)
            state <= idle; 
        else begin 
            case(state)
                idle: if(start)
                        state <= get_read_address; 
                      else 
                        state <= idle; 
                get_read_address: 
                            state <= send_read_address; 
                send_read_address:
                            state <= finished; 
                finished: if(sound_finish)
                            state<= idle; 
                        else 
                            state <= finished;             
                default: state <= idle; 
            endcase 
        end 
    end 
endmodule 


module tb_fsm_flash_read();

    logic start, reset, CLOCK_50,clk_22kHz;
    logic flash_mem_read ,finish_read, finish_sound; 
    logic direction; 
    logic [22:0] flash_mem_address; 

    fsm_flash_read dut(.CLOCK_50(CLOCK_50), .reset(1'b0), .start(start), .flash_mem_read(flash_mem_read), 
                        .flash_mem_address(flash_mem_address), .finish_read(finish_read), .sound_finish(finish_sound), .direction(direction));

  //  clock_sync sync(.CLOCK_50(CLOCK_50), .async_clk(clk_22kHz), .edgedetect(edgedetect));


     initial begin
         finish_sound =0; 
         start = 0; 
         reset = 0; 
         CLOCK_50 = 0; 
         direction = 1; 
        forever begin 
            #1;
            CLOCK_50 = !CLOCK_50; 
        end  
    end

    initial begin 
            clk_22kHz = 0; 
        forever begin 
            #5
            clk_22kHz = !clk_22kHz;
        end 
    end 

    initial begin
        #30; 
        start = 1;  
        #30; 
        finish_sound =1; 
        #2; 
        finish_sound = 0; 
        #30; 
        finish_sound =1; 
        #2; 
        finish_sound = 0; 
        #5; 
        finish_sound = 1; 
        direction = 0; 
        #10; 
        finish_sound = 0; 
    end 


endmodule 

