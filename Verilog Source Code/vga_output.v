// module for VGA output 
// The vga outputs are as follows: 
// r_out - 4 bit 
// g_out - 4 bit
// b_out - 4 bit
// clk  - 1 bit
// hsync - 1 bit
// vsync - 1 bit
//
// The vga outputs are connected to the following pins:

module vga_output(      
    r_in, g_in, b_in, pos_x, pos_y, clk, hsync, vsync, r_out, g_out, b_out, clk_25mhz_out
    );
    
    // input ports 
 input [7:0] r_in;
 input [7:0] g_in;
 input [7:0] b_in;
 input [7:0] pos_x;
 input [7:0] pos_y;
 
 input clk;
 output hsync;
 output vsync;
    
    // output ports 
 output [7:0] r_out;
 output [7:0] g_out;
 output [7:0] b_out;
 output clk_25mhz_out;


 wire clk_25mhz;
 wire enable_vsync;
 wire [15:0] h_count;
 wire [15:0] v_count;

// internal reg for random color
 reg [26:0] val = 0;
 wire [25:0] int_counter;
 reg [38:0] curr_dist = 0;
 reg [23:0] wood_color = 24'hb6834e;
 reg [23:0] color = 24'h888888;
 reg [32:0] radius = 240*240;
 reg [32:0] new_radius ;
 reg [15:0] pos_x_translated;
 reg [15:0] pos_y_translated;
 reg [15:0] curr_pixel_x;
 reg [15:0] curr_pixel_y;
 wire slow_clk;
// use a clock divider to get a 25 MHz clock from a 50 MHz clock

// gives the center
function [31:0] translate(input [15:0] x_val, input [15:0] y_val);
	begin
		translate = {$signed(16'd463)-$signed(x_val), $signed(16'd275) - $signed(y_val)};
	end
endfunction
	
// compute the distance
function [37:0] distance(input [15:0] x_val, input [15:0] y_val);
	begin
		distance = ($signed(x_val)*$signed(x_val) + $signed(y_val)*$signed(y_val));
	end
endfunction


clock_divider divider_25mhz(
    .clk_in(clk),
    .clk_25mhz(clk_25mhz),
	 .int_counter(int_counter)
);

vert_counter vert_counter_25mhz(
    .clk_in(clk_25mhz),
    .enable_v(enable_vsync),
    .v_count(v_count)
);

horizontal_counter horiz_counter_25mhz(
    .clk_in(clk_25mhz),
    .enable_v_signal(enable_vsync),
    .h_count(h_count)
);

// assign the synch values to the output ports
 assign hsync = (h_count < 96) ? 1'b1 : 1'b0;
 assign vsync = (v_count < 2 ) ? 1'b1 : 1'b0;
 assign clk_25mhz_out = clk_25mhz;
 assign slow_clk = int_counter[16];
// assign color only within the active video region
 assign r_out = ((h_count < 784 && h_count > 143) && (v_count < 515 && v_count > 34)) // within the screen area
			? /*need logic for the background vs circle for platform*/ 
			(curr_dist <= new_radius) 
			? wood_color[23:16] : (color[23:16])  // if within screen area, draw either background, or the circle  
				: 8'h0;   // else, we draw black
 assign g_out = ((h_count < 784 && h_count > 143) && (v_count < 515 && v_count > 34)) // within the screen area
			? /*need logic for the background vs circle for platform*/ 
			(curr_dist <= new_radius) 
			? wood_color[15:8] : (color[15:8])  // if within screen area, draw either background, or the circle  
				: 8'h0;   // else, we draw black
 assign b_out = ((h_count < 784 && h_count > 143) && (v_count < 515 && v_count > 34)) // within the screen area
			? /*need logic for the background vs circle for platform*/ 
			(curr_dist <= new_radius) 
			? wood_color[7:0] : (color[7:0])  // if within screen area, draw either background, or the circle  
				: 8'h0;   // else, we draw black

				
always@(posedge clk_25mhz)
begin 
	curr_pixel_x <= h_count;
	curr_pixel_y <= v_count;
	curr_dist <= distance($signed(16'd463-curr_pixel_x),$signed(16'd275-curr_pixel_y));	
end

always@(posedge slow_clk)
begin 
	new_radius <= (130+$signed(pos_x))*(130+$signed(pos_x));
	//curr_pixel_x = h_count;
	//curr_pixel_y = v_count;
	//curr_dist <= distance($signed(16'd463-curr_pixel_x),$signed(16'd275-curr_pixel_y));	
end
				
always@(posedge clk_25mhz) begin
	
	if (val < 26'd25000000)
	begin
		{pos_x_translated,pos_y_translated} <= translate($signed(pos_x),$signed(pos_y));
		val <= val + 26'b1;
		
	end else begin
	val <= 26'd0;
//	if (color > 24'h0)
//		color <= (color<<<8);
//	else color <= 24'h0000FF;

end
end

endmodule

// module to make a clock dividr for the horizontal sync
module horizontal_counter(input clk_in, output reg enable_v_signal = 0, output reg [15:0] h_count = 0);
    //reg [15:0] h_count;
    always @(posedge clk_in) begin
        if(h_count < 799) begin
            h_count <= h_count + 15'b1;
				enable_v_signal <= 1'b0;
        end else begin
            h_count <= 15'b0;
            enable_v_signal <= 1'b1;
        end
    end
endmodule


    // module to make a clock dividr for the horizontal sync
module vert_counter(input clk_in, input enable_v, output reg [15:0] v_count = 0);
    //reg [15:0  ] v_count;
    always @(posedge clk_in) begin
        if (enable_v == 1'b1) begin
			if(v_count < 524) begin
				v_count <= v_count + 15'b1;
			end else begin
				v_count <= 15'b0;
			end
        end
    end
endmodule

// module to divide a 50 MHz clock to get a 25 MHz clock
module clock_divider(input clk_in, output reg clk_25mhz = 0, output reg [26:0] int_counter = 0);

    always @(posedge clk_in) begin
				int_counter <= int_counter + 1'b1;
            clk_25mhz <= ~clk_25mhz;
        end 
endmodule
