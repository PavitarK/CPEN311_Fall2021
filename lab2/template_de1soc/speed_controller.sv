module speed_controller(CLOCK_50, divisor, reset, speedUp,speedDown); 

    input CLOCK_50, reset, speedUp, speedDown; 
    output logic [27:0] divisor; 

    parameter standard = 28'd2273; //22kHz

    logic [27:0] temp_divisor = standard;

    assign divisor = temp_divisor; 

    always_ff@(posedge CLOCK_50) begin 
        if(reset)
            temp_divisor <= standard; 
        else if(speedUp)
            temp_divisor <= temp_divisor - 5; 
        else if(speedDown)
            temp_divisor <= temp_divisor + 5; 
        else
            temp_divisor <= temp_divisor; 
        end

endmodule 