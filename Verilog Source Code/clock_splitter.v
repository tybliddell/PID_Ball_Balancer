module clock_splitter(input double_clock, output reg a, output reg b);
	reg counter = 1'b0;

	always @(posedge double_clock) begin
		if(counter == 1'b0)
			a <= ~a;
		else if(counter == 1'b1)
			b <= ~b;
		counter <= counter + 1'b1;
	end
endmodule 