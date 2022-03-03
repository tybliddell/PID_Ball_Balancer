module ALU_ENCODER(input wire [7:0]opcode, output reg [3:0]encoded);
parameter [7:0]ADD = 8'b00000101;
parameter [7:0]ADDU = 8'b00000110;
parameter [7:0]MUL = 8'b00001110;
parameter [7:0]SUB = 8'b00001001;
parameter [7:0]CMP = 8'b00001011;
parameter [7:0]AND = 8'b00000001;
parameter [7:0]OR = 8'b00000010;
parameter [7:0]XOR = 8'b00000011;
parameter [7:0]MOV = 8'b00001101;
parameter [7:0]LSH = 8'b10000100;
parameter [7:0]LOAD = 8'b01000000;
parameter [7:0]STOR = 8'b01000100;
parameter [7:0]JCOND = 8'b01001100;
parameter [7:0]JAL = 8'b01001000;
parameter [7:0]WAIT = 8'b00000000;

parameter [3:0]ADD_I = 4'b0101;
parameter [3:0]MUL_I = 4'b1110;
parameter [3:0]SUB_I = 4'b1001;
parameter [3:0]CMP_I = 4'b1011;
parameter [3:0]AND_I = 4'b0001;
parameter [3:0]OR_I = 4'b0010;
parameter [3:0]XOR_I = 4'b0011;
parameter [3:0]MOV_I = 4'b1101;
parameter [3:0]BCOND = 4'b1100;

parameter [6:0]LSH_I = 7'b1000000;


always @(opcode)
  begin
    case(opcode)
      ADD:
        encoded = 0;
      ADDU:
        encoded = 1;
      MUL:
        encoded = 2;
      SUB:
        encoded = 3;
      CMP:
        encoded = 4;
      AND:
        encoded = 5;
      OR:
        encoded = 6;
      XOR:
        encoded = 7;
      MOV:
        encoded = 8;
      LSH:
        encoded = 9;
      LOAD:
        encoded = 10;
      STOR:
        encoded = 11;
      JCOND:
        encoded = 13;
      JAL:
        encoded = 14;
      default:
        encoded = 15; // WAIT / NOP / Not Implemented
    endcase
	 case(opcode[7:4])
		ADD_I:
			encoded = 0;
		MUL_I:
			encoded = 2;
		SUB_I:
			encoded = 3;
		CMP_I:
			encoded = 4;
		AND_I:
			encoded = 5;
		OR_I:
			encoded = 6;
		XOR_I:
			encoded = 7;
		MOV_I:
			encoded = 8;
		BCOND:
			encoded = 12;
	 endcase
	 if(opcode[7:1] == LSH_I)
		encoded = 9;
  end
endmodule
