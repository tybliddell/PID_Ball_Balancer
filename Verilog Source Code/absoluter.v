module absoluter(input signed [15:0] in, output wire signed [15:0] out);
	assign out = ~in + 16'b1;
endmodule 