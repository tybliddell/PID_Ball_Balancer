module MemTest(input clk_a, input clk_b, input reset, input ab, input [9:0] addr_a, input [9:0] addr_b, input [15:0] data_a, input [15:0] data_b, input we_a, input we_b, output [15:0] out);

wire[15:0]q_a1;
wire[15:0]q_b1;
wire[15:0]q_a2;
wire[15:0]q_b2;
wire we_a1, we_a2, we_b1, we_b2;

assign we_a1 = ~addr_a[9] && we_a;
assign we_a2 =  addr_a[9] && we_a;
assign we_b1 = ~addr_b[9] && we_b;
assign we_b2 =  addr_b[9] && we_b;

wire ctrl_q = ab ? addr_b[9] : addr_a[9];
Mux41 mem_out(q_a1, q_b1, q_a2, q_b2, {ctrl_q, ab}, out);

BlockMem #(.ADDR_WIDTH(9), .DATA_WIDTH(16)) mem1 (.data_a(data_a), .data_b(data_b), .addr_a(addr_a[8:0]), .addr_b(addr_b[8:0]), .we_a(we_a1), .we_b(we_b1), .clk_a(clk_a), .clk_b(clk_b), .q_a(q_a1), .q_b(q_b1));
BlockMem #(.ADDR_WIDTH(9), .DATA_WIDTH(16)) mem2(.data_a(data_a), .data_b(data_b), .addr_a(addr_a[8:0]), .addr_b(addr_b[8:0]), .we_a(we_a2), .we_b(we_b2), .clk_a(clk_a), .clk_b(clk_b), .q_a(q_a2), .q_b(q_b2));


endmodule
