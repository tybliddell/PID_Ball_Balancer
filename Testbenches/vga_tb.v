`timescale 1ns/1ps
module vga_tb();

reg clk = 0;
reg [7:0] r_in,g_in,b_in;



wire clk_25mhz_out,hsync,vsync;
wire [7:0] r_out,g_out,b_out;


 vga_output vout(.r_in(r_in), .g_in(g_in), .b_in(b_in), .clk(clk), .hsync(hsync),
				.vsync(vsync), .r_out(r_out), .g_out(g_out), .b_out(b_out), 
				.clk_25mhz_out(clk_25mhz_out)
				);
				
				
				
always #5 clk = ~clk;

endmodule
