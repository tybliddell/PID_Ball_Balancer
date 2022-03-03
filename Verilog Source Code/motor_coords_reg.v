module motor_coords_reg(input [7:0] byte_in, input in_byte_tick, 
								output reg done_tick, output reg [7:0] m1_pos_upper, output reg [7:0] m1_pos_lower, output reg [7:0] m2_pos_upper, output reg [7:0] m2_pos_lower, output reg [7:0] m3_pos_upper, output reg [7:0] m3_pos_lower);
	parameter IDLE = 1'b0, 
				 DATA = 1'b1;
				
	reg state = IDLE;
	reg [2:0] counter = 3'd0;
	
	reg [7:0] m1_pos_internal_upper;
	reg [7:0] m1_pos_internal_lower;
	reg [7:0] m2_pos_internal_upper;
	reg [7:0] m2_pos_internal_lower;
	reg [7:0] m3_pos_internal_upper;
	reg [7:0] m3_pos_internal_lower;

	
	always @(posedge in_byte_tick) begin		
		counter <= counter + 1'd1;
		done_tick <= 1'b0;
		
		if(counter == 3'd0)
			m1_pos_internal_lower <= byte_in;
		else if (counter == 3'd1)
			m1_pos_internal_upper <= byte_in;
		else if(counter == 3'd2)
			m2_pos_internal_lower <= byte_in;
		else if(counter == 3'd3)
			m2_pos_internal_upper <= byte_in;
		else if(counter == 3'd4)
			m3_pos_internal_lower <= byte_in;
		else if(counter == 3'd5) begin
			m1_pos_lower <= m1_pos_internal_lower;
			m1_pos_upper <= m1_pos_internal_upper;
			
			m2_pos_lower <= m2_pos_internal_lower;
			m2_pos_upper <= m2_pos_internal_upper;

			m3_pos_lower <= m3_pos_internal_lower;
			m3_pos_upper <= byte_in;
			counter <= 3'd0;
			done_tick <= 1'b1;
		end
	end		
//	always @(posedge in_byte_tick) begin
//		case(state) 
//			IDLE: begin
//				if(byte_in != 8'd253) begin
//					counter <= 3'd0;
//					state <= DATA;
//					done_tick <= 1'b0;
//				end
//			end
//			DATA: begin
//				counter <= counter + 1'b1;
//
//				if(counter == 3'd0) 
//					m1_pos_internal = { m1_pos_internal[15:8], byte_in };
//				else if(counter == 3'd1)
//					m1_pos_internal = { byte_in, m1_pos_internal[7:0] };
//				else if(counter == 3'd2)
//					m2_pos_internal = { m2_pos_internal[15:8], byte_in };
//				else if(counter == 3'd3)
//					m2_pos_internal = { byte_in, m2_pos_internal[7:0] };
//				else if(counter == 3'd4)
//					m3_pos_internal = { m3_pos_internal[15:8], byte_in };
//				else if(counter == 3'd5)
//					m3_pos_internal = { byte_in, m3_pos_internal[7:0] };
//				else if(counter == 3'd6) begin
//					if(byte_in == 8'd254) begin
//						m1_pos <= m1_pos_internal;
//						m2_pos <= m2_pos_internal;
//						m3_pos <= m3_pos_internal;
//						state <= IDLE;
//						counter <= 3'd0;		
//						done_tick <= 1'b1;
//					end
//					else begin
//						state <= IDLE;
//						counter <= 3'd0;
//					end
//				end			
//			end
//		endcase	
//	end
endmodule 