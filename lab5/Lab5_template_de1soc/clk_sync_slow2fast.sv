module clk_sync_slow2fast(clk, slow_clk, data, out); 
    input clk, slow_clk;
    input logic [11:0] data;
    output logic [11:0] out; 

    logic [11:0] reg1, reg3; 
    logic enable, d1; 
    flipflop2 #(.N(12)) ff1(.d(data), .q(reg1), .clk(slow_clk), .en(1'b1));
    flipflop2 #(.N(12)) ff2(.d(reg1), .q(reg3), .clk(clk), .en(enable));
    flipflop2 #(.N(12)) ff3(.d(reg3), .q(out), .clk(clk), .en(1'b1));

    flipflop2 #(.N(1)) d(.d(slow_clk), .q(d1), .clk(~clk), .en(1'b1));
    flipflop2 #(.N(1)) d2(.d(d1), .q(enable), .clk(~clk), .en(1'b1));

endmodule

module flipflop2 #(parameter N)(d, q, clk, en);

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