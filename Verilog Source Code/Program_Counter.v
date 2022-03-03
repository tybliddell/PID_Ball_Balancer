module Program_Counter(input PC_en, input clock, input [15:0] new_val, output reg [15:0] address);
parameter PROGRAM_START = 16'b0000010000000000;
initial
  begin
    address = PROGRAM_START;
  end
always @(posedge clock)
  if(PC_en)
    address = new_val;
endmodule
