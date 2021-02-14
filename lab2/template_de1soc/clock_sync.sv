module clock_sync(CLOCK_50, async_clk, edgedetect);
    input CLOCK_50, async_clk; 
    output logic edgedetect; // = 1'b0; 

    logic ff1out, ff2out, ff3out, sync_signal, reset; 

    assign reset = (!async_clk) & ff3out; 
    assign edgedetect = (!sync_signal) & ff3out; //edge detector 

    flip_flop ff1(.in(1'b1), .out(ff1out), .clk(async_clk), .reset(reset));
    flip_flop ff2(.in(ff1out), .out(ff2out), .clk(CLOCK_50), .reset(1'b0));
    flip_flop ff3(.in(ff2out), .out(ff3out), .clk(CLOCK_50), .reset(1'b0));
    flip_flop ff4(.in(ff3out), .out(sync_signal), .clk(CLOCK_50), .reset(1'b0));

endmodule 

module flip_flop(in, out, clk, reset);
    input in,clk, reset;
    output logic out;  

    always_ff @(posedge clk or posedge reset) begin
        if(reset)
            out <= 1'b0; 
        else 
            out <= in; 
    end
endmodule

