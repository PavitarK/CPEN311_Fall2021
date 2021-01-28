module clk_divider(inclk, outclk, finalcount); 
    input inclk; 
    input [27:0] finalcount;
    output reg outclk = 1'b0;  

    logic [27:0] cycle_count = 28'b0;

    //cycle counter 
    always@(posedge inclk) begin 
        if(cycle_count == ((finalcount/2) - 1))
            begin 
            outclk <= ~outclk; 
            cycle_count <= 28'b1; //TODO: used to be 1  
            end 
        else 
            cycle_count <= cycle_count + 1; 
    end 
endmodule
