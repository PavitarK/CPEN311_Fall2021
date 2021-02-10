module fsm_flash_read(CLOCK_50, reset, start, flash_mem_waitrequest, 
                    flash_mem_readdatavalid, flash_mem_read, flash_mem_address, finish);

    input start, reset, CLOCK_50, flash_mem_readdatavalid, flash_mem_waitrequest; 
    //input [31:0] read_address; 
    output logic finish, flash_mem_read; 
    output [22:0] flash_mem_address; 

    ////state_00_get_address_read
    parameter [7:0] idle = 8'b0001_0000;
    parameter [7:0] get_read_address = 8'b0010_0010;
    parameter [7:0] waiting = 8'b0011_0001;
    parameter [7:0] send_read_address = 8'b0100_0001;
    //parameter [7:0] finish = 8'b1111_0000;

    logic [7:0] state = idle; 
    logic get_address; 

    assign flash_mem_read = state[0]; //read signal to flash
    assign get_address = state[1]; 

    address_controller get(.CLOCK_50(CLOCK_50), .reset(reset), .get_address(get_address), .address_to_read(flash_mem_address));

    //state controller
    always_ff@(posedge CLOCK_50 or posedge reset) begin 
        if(reset)
            state <= idle; 
        else begin 
            case(state)
                idle: if(start)
                        state <= get_read_address; 
                      else 
                        state <= idle; 
                get_read_address: 
                    if(flash_mem_waitrequest)
                        state <= waiting; 
                    else 
                        state <= send_read_address; 
                waiting: 
                    if(flash_mem_waitrequest)
                        state <= waiting;
                    else 
                        state <= send_read_address;  
                send_read_address:
                    //  if(flash_mem_readdatavalid)
                    //     state <= finish; 
                    //  else 
                        state <= get_read_address;
                //finish: 
                default: state <= idle; 
            endcase 
        end 
    
    end 



endmodule 