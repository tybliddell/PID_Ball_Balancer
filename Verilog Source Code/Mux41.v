module Mux41(input wire [15:0]x0, input wire [15:0] x1, input wire [15:0] y0, input wire [15:0] y1, input wire [1:0] ctrl, output reg [15:0] out);
always @(*)
  begin
    case(ctrl)
      2'b00:
        out = x0;
      2'b01:
        out = x1;
      2'b10:
        out = y0;
      2'b11:
        out = y1;
    endcase
  end
endmodule
