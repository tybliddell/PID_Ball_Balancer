module SignExtend(input [7:0] in, output [15:0] out);
    wire sign;
    assign sign = in[7];
    assign out = {{8{sign}}, in};
endmodule
