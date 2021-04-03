module clk_sync_fast2slow(clk, slow_clk, data, out);
    input clk, slow_clk;
    input logic [11:0] data;  
    output logic [11:0] out; 

    logic reg1, reg3, enable, d1; 
    flipflop #(.DATA_WIDTH(11)) ff1(.d(data), .q(reg1), .clk(slow_clk), .en(1'b1));
    flipflop #(.DATA_WIDTH(11)) ff2(.d(reg1), .q(reg3), .clk(clk), .en(enable));
    flipflop #(.DATA_WIDTH(11)) ff3(.d(reg3), .q(out), .clk(slow_clk), .en(1'b1));

    flipflop #(.DATA_WIDTH(1)) d1(.d(slow_clk), .q(d1), .clk(~clk), .en(1'b1));
    flipflop #(.DATA_WIDTH(1)) d2(.d(d1), .q(enable), .clk(~clk), .en(1'b1));

endmodule


module flipflop #(parameter DATA_WIDTH = N)(d, q, clk, en);

    input logic [N-1:0] d;
	input logic clk, en;
    output reg [N-1:0] q;

    always_ff @(posedge clk) begin
        if(en)
            q <= d;
        else
            q <= q;
    end
endmodule