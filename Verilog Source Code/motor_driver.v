module motor_driver(input [15:0] m1_steps, input [15:0] m2_steps, input [15:0] m3_steps, input drive_signal, input drive_clock, 
						  output reg m1_step_out, output reg m2_step_out, output reg m3_step_out,
						  output reg m1_step_dir, output reg m2_step_dir, output reg m3_step_dir,
						  output wire ready_out);
	//bit 15 of each step signal is direction, 14-0 are the number of steps
	reg driving = 1'b0;
	reg [15:0] counter = 16'b0;
	reg [14:0] m1_steps_todo;
	reg [14:0] m2_steps_todo;
	reg [14:0] m3_steps_todo;
	reg done_driving_signal = 1'b0;
	reg ready = 1'b1;
	
	assign ready_out = ready && !driving;
	
	//Whenever the drive signal goes high begin driving motors.
	//Set driving to true, set directions
	always @(posedge drive_signal, posedge done_driving_signal) begin
		if(done_driving_signal == 1'b1) 
			driving <= 1'b0;
		else begin
			driving <= 1'b1;
			m1_step_dir <= m1_steps[15];
			m2_step_dir <= m2_steps[15];
			m3_step_dir <= m3_steps[15];
			if(!m1_steps[15])
				m1_steps_todo <= (m1_steps[14:0] << 1);
			else
				m1_steps_todo <= (~(m1_steps[14:0]) + 1'b1) << 1;
			if(!m2_steps[15])
				m2_steps_todo <= (m2_steps[14:0] << 1);
			else
				m2_steps_todo <= (~(m2_steps[14:0]) + 1'b1) << 1;
			if(!m3_steps[15])
				m3_steps_todo <= (m3_steps[14:0] << 1);
			else
				m3_steps_todo <= (~(m3_steps[14:0]) + 1'b1) << 1;	
		end	
	end
	
	//On every drive clock check if currently driving
	always @(posedge drive_clock) begin
		if(driving == 1'b1) begin
			ready <= 1'b0;
			if(counter < m1_steps_todo)
				m1_step_out <= ~m1_step_out;
			if(counter < m2_steps_todo)
				m2_step_out <= ~m2_step_out;
			if(counter < m3_steps_todo)
				m3_step_out <= ~m3_step_out;
			
			counter <= counter + 1'b1;
			
			if(counter > m1_steps_todo && counter > m2_steps_todo && counter > m3_steps_todo) begin
				counter <= 15'd0;
				done_driving_signal <= 1'b1;
			end
		end
		else begin
			ready <= 1'b1;
			done_driving_signal <= 1'b0;
		end
	end

endmodule 