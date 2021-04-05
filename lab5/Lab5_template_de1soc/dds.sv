module dds(clk, reset, en, lfsr, modulation_sel, signal_sel, mod_signal_out, original_signal,
           sin_out, cos_out, squ_out, saw_out, sampler, sampler_sync);
    
    input logic clk, reset, en, lfsr, sampler,sampler_sync; 
    input logic [1:0] modulation_sel, signal_sel; 
    output logic [11:0] mod_signal_out, original_signal;  
    input logic [11:0] sin_out, cos_out, squ_out, saw_out;


    logic [11:0] signal, ASK_signal, BPSK_signal, LFSR_signal, FSK_signal, mod_signal; 

    clk_sync_fast2slow clk_sync_modulation(.clk(clk), 
                                            .slow_clk(sampler), 
                                            .data(mod_signal), 
                                            .out(mod_signal_out)
                                            );

    clk_sync_fast2slow clk_sync_signal(.clk(clk), 
                                        .slow_clk(sampler), 
                                        .data(signal), 
                                        .out(original_signal)
                                        );

    
    always @(*) begin
        case(signal_sel)
            2'b00: signal = sin_out; 
            2'b01: signal = cos_out; 
            2'b10: signal = saw_out; 
            2'b11: signal = squ_out;
            default: signal = signal; 
        endcase 
    end

    always @(*) begin
        case(modulation_sel) 
            2'b00: mod_signal = lfsr ? 0 : sin_out; 
            2'b01: mod_signal = sin_out; 
            2'b10: mod_signal = lfsr ? (~sin_out + 1) : sin_out; 
            2'b11: mod_signal = lfsr ? 12'b0 : 12'b1000_0000_0000; 
        endcase 
    end

        //     if(modulation_sel[1:0] == 2'b00) mod_signal = lfsr? sin_out: 0; 
		// else if(modulation_sel[1:0] == 2'b01) mod_signal = sin_out; 
		// else if(modulation_sel[1:0] == 2'b10) mod_signal = lfsr? (~sin_out+1): sin_out; 
		// else if(modulation_sel[1:0] == 2'b11) mod_signal = lfsr? 12'b0:12'b100000000000;
         
endmodule

// module tb_modulation;
// 	// Inputs
// 	reg clk, reset, en;
// 	// Outputs
// 	logic [11:0] sin_out, cos_out, squ_out saw_out;
// 	// Test the clock divider in Verilog
// 	modulation dut(clk, reset, en, sin_out, cos_out, squ_out, saw_out);
// 	initial begin
// 		// Initialize Inputs
// 		clk = 0;
// 		reset = 1; 
// 		// create input clock 1Hz
// 		forever begin #10; clk = ~clk; end
//  	end

// 	 initial begin 
// 		 #100
// 		 reset = 1; 
	 
// 	 end 
      
// endmodule 
