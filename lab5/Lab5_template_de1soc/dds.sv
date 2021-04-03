module dds(clk, reset, en, lfsr, modulation_sel, signal_sel, signal_out, original_signal);
    
    input clk, reset, en, lfsr; 
    input [1:0] modulation_sel, signal_sel; 
    output [11:0] signal_out, original_signal;  

    logic [31:0] phase_inc = 32'd258; //tuning word 3*2^32/50*10^6 +0.5 = 258
    logic [11:0] signal, ASK_signal, BPSK_signal, LFSR_signal, FSK_signal; 
    logic [11:0] sin_out, cos_out, squ_out, saw_out; 

    assign original_signal = signal; 

    waveform_gen wave(.clk(clk), 
                    .reset(reset), 
                    .en(en), 
                    .phase_inc(phase_inc), 
                    .sin_out(sin_out), 
                    .cos_out(cos_out), 
                    .squ_out(squ_out),
                    .saw_out(saw_out));
    
    always @(posedge clk) begin
        case(signal_sel)
            2'b00: signal <= sin_out; 
            2'b01: signal <= cos_out; 
            2'b10: signal <= squ_out; 
            2'b11: signal <= saw_out;
            default: signal <= signal; 
        endcase 
    end

    always @(posedge clk) begin 
        if(lfsr) begin 
            ASK_signal <= 0; 
            BPSK_signal <= ~signal + 1; 
        end
        else begin
            ASK_signal <= signal; 
            BPSK_signal <= signal; 
        end 
    end 

    always @(posedge clk) begin
        case(modulation_sel)
            2'b00: signal_out <= ASK_signal; 
            2'b01: signal_out <= FSK_signal; 
            2'b10: signal_out <= BPSK_signal; 
            2'b11: signal_out <= LFSR_signal; 
            default: signal_out <= signal_out; 
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
