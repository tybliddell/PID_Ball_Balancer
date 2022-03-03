module Fibonacci(input next, input reset, output[0:6] Disp1, output[0:6] Disp2, output[0:6] Disp3, output[0:6] Disp4);
parameter opcode = 8'b00000101; // ADD
reg[15:0] i = 0; // The counter variable
reg[1:0] r0 = 0;
reg[3:0] r1 = 0;
reg[3:0] r2 = 0;
reg immCtrl = 0;
reg [15:0]imm;
wire[4:0] flags;
reg[15:0] reg_enable;
ALU_REG alu_reg(.Reset(reset), .clk(next), .IO_ctrl(0), .Imm_ctrl(immCtrl), .Imm(imm), .IO_ext(0), .opcode(opcode), .Reg_Enable(reg_enable), .s_reg1(r1), .s_reg2(r2), .Disp1(Disp1), .Disp2(Disp2), .Disp3(Disp3), .Disp4(Disp4), .Flags(flags));


always @(r0)
  begin
    case(r0)
      0:
        begin
          r1 = 1;
          r2 = 2;
        end
      1:
        begin
          r1 = 2;
          r2 = 0;
        end
      2:
        begin
          r1 = 0;
          r2 = 1;
        end
      default:
        begin
          r1 = 0;
          r2 = 0;
        end
    endcase
  end

always @(posedge next)
  begin
    i <= i+1;
    immCtrl <= 0;
    reg_enable <= 0;
    if(i == 0)
      begin
        reg_enable <= 0;
      end
    else if(i == 1)
      begin
        immCtrl <= 1;
        imm <= 16'd1;
        reg_enable <= 16'd2;
      end
    else
      begin
        r0 <= i % 3;
        reg_enable[i%3] <= 1;
      end
  end
endmodule
