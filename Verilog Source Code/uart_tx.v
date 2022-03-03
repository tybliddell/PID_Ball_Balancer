module uart_tx(input [15:0] x_in, input [15:0] y_in, input [15:0] set_x_in, input [15:0] set_y_in, input baud, input send_tick, output reg tx_out, output reg done_sending_signal,
					 output wire [1:0] temp_state_out, output wire [2:0] temp_packet_out);
	parameter SENDING_X = 3'b000,
				 SENDING_Y = 3'b001,
				 SENDING_X_SET = 3'b010,
				 SENDING_Y_SET = 3'b011,
				 COMPLETE = 3'b100;
	
	parameter IDLE = 2'b00,
				 START = 2'b01,
				 DATA = 2'b10,
				 STOP = 2'b11;
	
	reg [15:0] x = 16'd0;
	reg [15:0] y = 16'd0;
	reg [15:0] set_x = 16'd0;
	reg [15:0] set_y = 16'd0;
	
	reg [3:0] bit_counter = 4'd0;
	
	reg [2:0] curr_packet = SENDING_X;
	reg [1:0] state = IDLE;
	
	reg sending = 1'b0;
		
	assign temp_state_out = state;
	assign temp_packet_out = curr_packet;
	
	always @(posedge send_tick, posedge done_sending_signal) begin
		if(done_sending_signal) 
			sending <= 1'b0;
		else
			sending <= 1'b1;
		x <= x_in;
		y <= y_in;
		set_x <= set_x_in;
		set_y <= set_y_in;
	end
	
	
	always @(posedge baud) begin
		if(sending == 1'b1) begin
			case(state)
				IDLE: begin
					tx_out <= 1'b1;
					curr_packet <= SENDING_X;
					state <= START;
				end
				START: begin
					tx_out <= 1'b0;
					state <= DATA;
				end
				DATA: begin
					case(curr_packet)
						SENDING_X: begin
							tx_out <= x[bit_counter];
							if(bit_counter == 4'd7)
								curr_packet <= COMPLETE;
						end
						SENDING_Y: begin
							tx_out <= y[bit_counter];
							
							if(bit_counter == 4'd15)
								curr_packet <= SENDING_X_SET;
						end
						SENDING_X_SET: begin
							tx_out <= set_x[bit_counter];
							
							if(bit_counter == 4'd15)
								curr_packet <= SENDING_Y_SET;						
						end
						SENDING_Y_SET: begin
							tx_out <= set_y[bit_counter];
							
							if(bit_counter == 4'd15)
								curr_packet <= COMPLETE;
						end
					endcase
					
					bit_counter <= bit_counter + 1'b1;
					if(bit_counter == 4'd7 || bit_counter == 4'd15)
						state <= STOP;
				end
				STOP: begin
					tx_out <= 1'b1;
					if(curr_packet == COMPLETE) begin
						done_sending_signal <= 1'b1;
						state <= IDLE;
					end
					else
						state <= START;
				end
			endcase		
		end	
		else begin
			done_sending_signal <= 1'b0;
			tx_out <= 1'b1;
		end
	end
	//16 bits - current x
	//16 bits - current y
	//16 bits - current x trying to get to
	//16 bits - current y trying to get to	
endmodule 