module pixy_coords_reg(input [7:0] byte_in, input byte_done_tick, output reg new_vals, output reg [15:0] x_center_out, output reg [15:0] y_center_out);

	parameter IDLE = 1'b0,
				 DATA = 1'b1;
	
	reg state = IDLE;
	reg [7:0] x_center_lower_inner = 8'd0;
	reg [7:0] x_center_upper_inner = 8'd0;
	reg [7:0] y_center_lower_inner = 8'd0;
	reg [7:0] y_center_upper_inner = 8'd0;
	reg [3:0] counter = 4'd0;
	
	
	always @(posedge byte_done_tick) begin
		case(state)
			IDLE:
				if(byte_in != 8'd0) begin
					state <= DATA;
					counter <= counter + 1'b1;
					new_vals <= 1'b0;
				end	
			DATA: begin
				new_vals <= 1'b0;
				//lower sig bits of x center
				if(counter == 4'd8)
					//x_center <= { x_center[15:8], byte_in };
					x_center_lower_inner <= byte_in;
						
				//upper sig bits of x center
				else if(counter == 4'd9)
					//x_center <= { byte_in, x_center[7:0] } ;
					x_center_upper_inner <= byte_in;
					
				//lower sig bits of y center
				else if(counter == 4'd10)
					//y_center <= { y_center[15:8], byte_in };
					y_center_lower_inner <= byte_in;
						
				//upper sig bits of y center
				else if(counter == 4'd11)
					//y_center <= { byte_in, y_center[7:0] };
					y_center_upper_inner <= byte_in;
					
				else if(counter == 4'd15) begin
					x_center_out = { x_center_upper_inner, x_center_lower_inner };
					y_center_out = { y_center_upper_inner, y_center_lower_inner };
					new_vals <= 1'b1;
					state <= IDLE;
				end
				counter <= counter + 1'b1;
			end
			default: begin
				x_center_out = 16'd0;
				y_center_out = 16'd0;
				counter <= 4'd0;
			end
		endcase
	end

endmodule 