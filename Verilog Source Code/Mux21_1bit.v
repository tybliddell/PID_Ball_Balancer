module Mux21_1bit(input wire x, input wire y, input wire ctrl, output wire out);
assign out = ctrl ? y : x;
endmodule
