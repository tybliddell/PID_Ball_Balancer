module nun_chuck(input [7:0] byte_in, input byte_done_tick, output reg [7:0] x_val, output reg [7:0] y_val, output reg z_but, output reg ready_tick);

	reg [1:0] counter = 2'd0;
	
	always @(posedge byte_done_tick) begin	
			ready_tick <= 1'd0;
			counter <= counter + 1'd1;
			if(counter == 2'd0)
				x_val <= byte_in;
				else if (counter == 2'd1)
				y_val <= byte_in;
				else if (counter == 2'd2) begin
				z_but <= byte_in[0];
				ready_tick <= 1'b1;
				counter <= 2'd0;
				end
		
	end

endmodule 