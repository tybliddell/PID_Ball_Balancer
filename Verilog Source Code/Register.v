// Given below is a 2D-memory array implementation
module Register(ALUBus, r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, r10, r11, r12, r13, r14, r15, regEnable, clk, reset, 
                     new_10, new_11, reg_lock);
input clk, reset, reg_lock;
input [15:0] ALUBus;
input [15:0] regEnable;
input [15:0]  new_10, new_11;
// 16 instances (r00 to r15) of 16-bit registers
output [15:0] r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, r10, r11, r12, r13, r14, r15;
reg [15:0] r [0:15]; // 2-dimensional memory

genvar i;

generate
  for(i=0; i<=15;i=i+1)
    begin: regfile
      always @(negedge clk, negedge reset)
        begin:register_always
			 if(i == 10 || i == 11);
          else if(reset == 0)
            r[i] <= 16'b0000000000000000;
          else if(regEnable[i]==1'b1)
            r[i] <= ALUBus;
          else
            r[i] <= r[i];
        end
    end
endgenerate

// assign outputs explicitly
assign r00 = r[0];
assign r01 = r[1];
assign r02 = r[2];
assign r03 = r[3];
assign r04 = r[4];
assign r05 = r[5];
assign r06 = r[6];
assign r07 = r[7];
assign r08 = r[8];
assign r09 = r[9];
assign r10 = r[10];
assign r11 = r[11];
assign r12 = r[12];
assign r13 = r[13];
assign r14 = r[14];
assign r15 = r[15];



// tentative for nunchuck

always@(negedge clk)
begin
	if(!reg_lock) begin
		r[10] = {16'd0,new_10};
		r[11] = {16'd0,new_11};
	end
end
endmodule