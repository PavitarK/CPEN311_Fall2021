module dds(clk, en, lfsr, modulation_sel, signal_sel, mod_signal_out, original_signal,
           sin_out, cos_out, squ_out, saw_out, sampler);
    
    input logic clk, en, lfsr, sampler; 
    input logic [1:0] modulation_sel, signal_sel; 
    output logic [11:0] mod_signal_out, original_signal;  
    input logic [11:0] sin_out, cos_out, squ_out, saw_out;


    logic [11:0] signal, mod_signal; 

    //crossing clock domain 50Mhz to 200Hz
    clk_sync_fast2slow clk_sync_modulation(.clk(clk), 
                                            .slow_clk(sampler), 
                                            .data(mod_signal), 
                                            .out(mod_signal_out)
                                            );

    //crossing clock domain 50Mhz to 200Hz
    clk_sync_fast2slow clk_sync_signal(.clk(clk), 
                                        .slow_clk(sampler), 
                                        .data(signal), 
                                        .out(original_signal)
                                        );

    //original signal controller
    always @(*) begin
        case(signal_sel)
            2'b00: signal = sin_out; 
            2'b01: signal = cos_out; 
            2'b10: signal = saw_out; 
            2'b11: signal = squ_out;
            default: signal = signal; 
        endcase 
    end

    //modulated signal controller
    always @(*) begin
        case(modulation_sel) 
            2'b00: mod_signal = lfsr ? 0 : sin_out; 
            2'b01: mod_signal = sin_out; 
            2'b10: mod_signal = lfsr ? (~sin_out + 1) : sin_out; 
            2'b11: mod_signal = lfsr ? 12'b0 : 12'b1000_0000_0000; 
        endcase 
    end
         
endmodule

module tb_modulation();

	// Inputs
	reg clk, en, lfsr, sampler;
    logic [1:0] modulation_sel, signal_sel; 
	logic [11:0] sin_out, cos_out, squ_out, saw_out;

    //outputs 
    logic [11:0] mod_signal_out, original_signal;

	// Test the clock divider in Verilog
	dds dut(clk, en, lfsr, modulation_sel, signal_sel, mod_signal_out, original_signal,
            sin_out, cos_out, squ_out, saw_out, sampler);

	    initial begin
		// Initialize Inputs
		clk = 0;
        en = 1; 
        lfsr = 1; 
        sin_out = 12'd2; 
        cos_out = 12'd4; 
        squ_out = 12'd6; 
        saw_out = 12'd8; 
        modulation_sel = 2'b00; 
        signal_sel = 2'b00; 
		// create input clock 1Hz
		    forever begin #10; clk = ~clk; 
            end
 	    end

        initial begin 
            sampler = 0; 
         forever begin
             #20
            sampler = ~ sampler; 
         end
        end 


	 initial begin 
        #40; 
        modulation_sel = 2'b00; 
        signal_sel = 2'b01;
        #40; 
        modulation_sel = 2'b00; 
        signal_sel = 2'b10;  
        #40; 
        modulation_sel = 2'b00; 
        signal_sel = 2'b11; 
        #40; 
        modulation_sel = 2'b01; 
        signal_sel = 2'b00;
        #40; 
        modulation_sel = 2'b01; 
        signal_sel = 2'b01;
        #40; 
        modulation_sel = 2'b01; 
        signal_sel = 2'b10;
        #40; 
        modulation_sel = 2'b11; 
        signal_sel = 2'b00;
        #40; 
        modulation_sel = 2'b11; 
        signal_sel = 2'b10;
	 
	 end 
      
endmodule 
