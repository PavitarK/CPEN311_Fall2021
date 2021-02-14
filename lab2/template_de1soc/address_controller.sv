module address_controller(CLOCK_50, reset, get_address, address_to_read, direction);
    input CLOCK_50, reset, get_address, direction; 
    output [22:0] address_to_read; 


    parameter [22:0] start = 23'h0;
    parameter [22:0] finish = 23'h7FFFF; 

    logic [22:0] address_to_read = 23'h0; 

    always_ff @(posedge CLOCK_50 or posedge reset) begin 
        if(reset)
            address_to_read <= start;
        else if(get_address) begin 
            if(direction) //if direction is forward
                begin 
                    if(address_to_read == finish)
                        address_to_read <= start; 
                    else
                        address_to_read <= address_to_read + 1;
                end
            else begin //if direction is backward
                if(address_to_read == start)
                    address_to_read <= finish; 
                else
                address_to_read <= address_to_read - 1;     
            end 
        end
        else 
            address_to_read <= address_to_read;
    end 
endmodule 

