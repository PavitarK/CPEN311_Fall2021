module clk_divider(inclk, outclk, finalcount); 
    
    input inclk; //fast clock 
    input [27:0] finalcount; //number to count up to
    output reg outclk = 1'b0;  //output slow clock 

    logic [27:0] cycle_count = 28'b0; //internal counter 

    //cycle counter 
    always@(posedge inclk) begin 
        if(cycle_count >= ((finalcount/2) - 1)) //does >= sythesize? 
            begin 
            outclk <= ~outclk; 
            cycle_count <= 28'b0; 
            end 
        else 
            cycle_count <= cycle_count + 1; 
    end 
endmodule
