module address_controller(CLOCK_50, reset, get_address, address_to_read);
    input CLOCK_50, reset, get_address; 
    output logic [22:0] address_to_read; 


    parameter [22:0] start = 23'h0;
    parameter [22:0] finish = 23'h7FFFF; 

    logic [22:0] address = 23'h0; 

    always_ff @(posedge CLOCK_50 or posedge reset) begin 
        if(reset)
            address <= 23'h0;
        else if(get_address)
            address <= address + 1;
        else 
            address <= address;
    end 

endmodule 