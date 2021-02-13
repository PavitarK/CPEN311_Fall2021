module address_controller(CLOCK_50, reset, get_address, address_to_read);
    input CLOCK_50, reset, get_address; 
    output [22:0] address_to_read; 


    parameter [22:0] start = 23'h0;
    parameter [22:0] finish = 23'h7FFFF; 

    logic [22:0] address_to_read = 23'h0; 

    always_ff @(posedge CLOCK_50 or posedge reset) begin 
        if(reset | address_to_read == finish)
            address_to_read <= 23'h0;
        else if(get_address)
            address_to_read <= address_to_read + 1;
        else 
            address_to_read <= address_to_read;
    end 

endmodule 

module tb_address_controller(); 

   logic CLOCK_50, reset, get_address; 
   logic [22:0] address_to_read; 

   address_controller dut(.CLOCK_50(CLOCK_50), .reset(reset), .get_address(get_address), .address_to_read(address_to_read));

   initial begin
        get_address = 1'b0; 
        reset = 1'b0; 
        CLOCK_50 = 0;
        forever begin 
            #1;
            CLOCK_50 = !CLOCK_50; 
        end  
    end

    initial begin 
        #5
        get_address = 1; 
        
        #10
        get_address = 0; 

        #10
        reset = 1; 
        get_address = 1; 

        #5
        reset = 0; 
        
        #15;
    end 
endmodule 