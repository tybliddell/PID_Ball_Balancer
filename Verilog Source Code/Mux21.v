module Mux21(input wire [15:0]x, input wire [15:0]y, input wire ctrl, output wire [15:0] out);
assign out = ctrl ? y : x;
endmodule
