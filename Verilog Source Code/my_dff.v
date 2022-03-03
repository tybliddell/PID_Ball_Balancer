module my_dff(input [15:0] data_in, input enable, input clock, output reg [15:0] data_out);
	always@(posedge clock)
		if(enable)
			data_out <= data_in;
endmodule 