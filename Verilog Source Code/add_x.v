module add_x(input [15:0] current, input [15:0] disp, output [15:0] next);
assign next = current + disp;
endmodule
