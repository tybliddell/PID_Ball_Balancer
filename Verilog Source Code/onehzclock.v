module onehzclock
#(parameter [25:0] period = 26'd50000000)
(input fast_clk, output reg tick);
	initial begin
		tick = 1'b0;
	end
	reg [25:0] counter = 26'd0;

	always @(posedge fast_clk) begin
		counter <= counter + 1'b1;
		if(counter == period/2) begin
			tick <= ~tick;
			counter <= 26'd0;
		end
	end

endmodule 