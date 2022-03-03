module uart_rec(input rx, input fast_tick, input reset, output reg [7:0] d_out, output reg rx_done_tick);
	parameter IDLE = 2'b00,
				 DATA = 2'b01,
				 STOP = 2'b10;

	reg [2:0] counter = 3'd0;
	reg [1:0] state = IDLE;
	reg [3:0] bit_count = 4'd0;
	reg [7:0] d_to_go_out;
		
	always @(posedge fast_tick, negedge reset) begin
		if(!reset) begin
			state <= IDLE;
			counter <= 4'd0;
			rx_done_tick <= 1;
		end
		else begin
			case(state)
				IDLE:
				begin
					//We are in the middle of the beginning
					if(rx == 1'b0 && counter == 3'd4) begin
						rx_done_tick <= 1'b0;
						state <= DATA;
						d_to_go_out <= 8'd0;
						counter <= 3'd0;
						bit_count <= 4'd0;		
					end
					else if(rx == 1'b0) begin
						counter <= counter + 1'b1;
					end
				end
				DATA:
					if(counter == 3'd7) begin
						state <= DATA;
						//Add bit as most significant bit
						d_to_go_out <= {rx, d_to_go_out[7:1]};
						bit_count <= bit_count + 1'b1;
						counter <= 4'd0;
						if(bit_count == 4'd7) begin
							state <= STOP;
							bit_count <= 4'd0;
							rx_done_tick <= 1'b0;
							d_out <= { rx, d_to_go_out[7:1] };
						end
					end
					else begin
						counter <= counter + 1'b1;
					end
				STOP:
					if(counter == 3'd7) begin
						rx_done_tick <= 1'b1;
						state <= IDLE;
						counter <= 3'd0;
					end 
					else begin
						counter <= counter + 1'b1;
					end	
			endcase
		end
	end
endmodule 