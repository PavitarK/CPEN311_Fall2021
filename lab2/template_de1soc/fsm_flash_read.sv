`timescale 1 ps / 1 ps

module fsm_flash_read(CLOCK_50, reset, start, flash_mem_waitrequest, flash_mem_read, flash_mem_address);

    input start, reset, CLOCK_50, flash_mem_waitrequest; 
    output logic flash_mem_read; 
    output [22:0] flash_mem_address; 

    ////state_00_get_address_read
    parameter [7:0] idle = 8'b0001_0000;
    parameter [7:0] get_read_address = 8'b0010_0010;
    parameter [7:0] waiting = 8'b0100_0001;
    parameter [7:0] send_read_address = 8'b1000_0001;

    logic [7:0] state = idle; 
    logic get_address; 

    assign flash_mem_read = state[0]; //read signal to flash
    assign get_address = state[1]; //get new address from address controller

    address_controller get(.CLOCK_50(CLOCK_50), .reset(reset), .get_address(get_address), .address_to_read(flash_mem_address));

    //state controller
    always_ff@(posedge CLOCK_50 or posedge reset) begin 
        if(reset)
            state <= idle; 
        else if (flash_mem_waitrequest)
            state <= waiting; 
        else begin 
            case(state)
                idle: if(start)
                        state <= get_read_address; 
                      else 
                        state <= idle; 
                get_read_address: 
                        state <= send_read_address; 
                waiting: 
                        state <= send_read_address;  
                send_read_address:
                            state <= idle; //or get address? 
                // read_data: 
                //     if(flash_mem_readdatavalid & edgedetect)
                //         //then send data to audio data? wtf
                default: state <= idle; 
            endcase 
        end 
    end 
endmodule 


module tb_fsm_flash_read();

    logic start, reset, CLOCK_50, flash_mem_waitrequest;
    logic flash_mem_read; 
    logic [22:0] flash_mem_address; 

    fsm_flash_read dut(.CLOCK_50(CLOCK_50), .reset(reset), .start(start), .flash_mem_waitrequest(flash_mem_waitrequest), 
                    .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address));

     initial begin
        start = 0;
        reset = 0;  
        CLOCK_50 = 0;
        flash_mem_waitrequest = 0; 
        forever begin 
            #1;
            CLOCK_50 = !CLOCK_50; 
        end  
    end

    initial begin 
        #5
        start = 1; 
        #4 
        flash_mem_waitrequest = 1; 
        #10
        flash_mem_waitrequest = 0; 
        #15; 
      
    end 


endmodule 

