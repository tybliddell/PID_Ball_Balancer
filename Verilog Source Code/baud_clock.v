module baud_clock
#(parameter [15:0] divider = 16'd163)
(input clk, output reg tick);
	reg [15:0] counter = 16'd0;
	
	always @(posedge clk) begin
		counter <= counter + 1;
		if (counter == divider) begin
			tick <= ~tick;
			counter <= 8'd0;
		end
	end


endmodule 