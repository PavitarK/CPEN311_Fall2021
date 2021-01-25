module clk_divider(inclk, outclk, finalcount); 
    input inclk; 
    input [17:0] finalcount;
    output reg outclk = 1'b0;  

    logic [17:0] cycle_count = 18'b0;

    //cycle counter 
    always@(posedge inclk) begin 
        if(cycle_count == (finalcount -1))
            begin 
            outclk <= ~outclk; 
            cycle_count <= 18'b1;  
            end 
        else 
            cycle_count <= cycle_count + 1; 
    end 
endmodule

    /*
    //select a frequency via Mux and 50MHz clock input
    always_comb begin 
        case(frequency_sel)
        3'b000: finalcount = 18'b1_0111_0101_0111_0010; //95602 getting 536Hz
        3'b001: finalcount = 18'b1_0100_1100_1011_1011; //85179 getting 587Hz
        3'b010: finalcount = 18'b1_0010_1000_0110_0001; //75873 getting 659Hz
        3'b011: finalcount = 18'b1_0001_0111_1101_0001; //71633 getting 698Hz
        3'b100: finalcount = 18'b1111_1001_0111_0001;   //63856 getting 783Hz
        3'b101: finalcount = 18'b1101_1101_1111_0010;   //56818 getting 880Hz
        3'b110: finalcount = 18'b1100_0101_1110_0011;   //50658 getting 987Hz
        3'b111: finalcount = 18'b1011_1010_1011_1001;   //47801 getting 1046Hz
        default: finalcount = 18'bx;
        endcase 
    end 
    */