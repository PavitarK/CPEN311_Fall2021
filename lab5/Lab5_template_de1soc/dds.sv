module dds(clk, reset, en, lfsr, modulation_sel, signal_sel, mod_signal_out, original_signal,
           sin_out, cos_out, squ_out, saw_out, sampler);
    
    input logic clk, reset, en, lfsr, sampler; 
    input logic [1:0] modulation_sel, signal_sel; 
    output logic [11:0] mod_signal_out, original_signal;  
    input logic [11:0] sin_out, cos_out, squ_out, saw_out;


    logic [11:0] signal, ASK_signal, BPSK_signal, LFSR_signal, FSK_signal, mod_signal; 

    clk_sync_fast2slow clk_sync_modulation(.clk(CLOCK_50), 
                                            .slow_clk(sampler), 
                                            .data(mod_signal), 
                                            .out(mod_signal_out)
                                            );

    clk_sync_fast2slow clk_sync_signal(.clk(CLOCK_50), 
                                        .slow_clk(sampler), 
                                        .data(signal), 
                                        .out(original_signal)
                                        );

    assign LFSR_signal = 12'd11;
    assign FSK_signal = 12'd2; 
    
    always @(*) begin
        case(signal_sel)
            2'b00: signal <= sin_out; 
            2'b01: signal <= cos_out; 
            2'b10: signal <= squ_out; 
            2'b11: signal <= saw_out;
            default: signal <= signal; 
        endcase 
    end

    always @(*) begin 
        if(lfsr) begin 
            ASK_signal <= 0; 
            BPSK_signal <= ~sin_out + 1; 
        end
        else begin
            ASK_signal <= sin_out; 
            BPSK_signal <= sin_out; 
        end 
    end 

    always @(*) begin
        case(modulation_sel)
            2'b00: mod_signal <= ASK_signal; 
            2'b01: mod_signal <= FSK_signal; 
            2'b10: mod_signal <= BPSK_signal; 
            2'b11: mod_signal <= LFSR_signal; 
            default: mod_signal <= mod_signal; 
        endcase
    end
         
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
