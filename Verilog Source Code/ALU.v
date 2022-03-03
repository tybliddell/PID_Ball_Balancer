/*
 *  Implements our ALU
 *  Written by: Rich Baird, Miguel Gomez, Tyler Liddell, and Hyrum Saunders
 *  Last edited: Sep, 2021
 */
module ALU(Rdest,Rsrc, op, flags, result, reset, current_address, next_address, Rdest_index, enc_out);

// Inputs
input signed [15:0]Rdest;
input signed [15:0]Rsrc;
input wire [7:0]op;
input wire reset;
input wire [15:0] current_address;
input wire [3:0] Rdest_index;
wire [3:0] opcode;

// Outputs
// order of flags from Left to Right: CLFZN
output reg [4:0]flags;              //43210
output reg [15:0]result, next_address;
output wire [3:0] enc_out;

assign enc_out = opcode;

ALU_ENCODER encoder(.opcode(op), .encoded(opcode));
// Used paramaters
parameter [3:0]ADD = 4'b0000;
parameter [3:0]ADDU = 4'b0001;
parameter [3:0]MUL = 4'b0010;
parameter [3:0]SUB = 4'b0011;
parameter [3:0]CMP = 4'b0100;
parameter [3:0]AND = 4'b0101;
parameter [3:0]OR = 4'b0110;
parameter [3:0]XOR = 4'b0111;
parameter [3:0]MOV = 4'b1000;
parameter [3:0]LSH = 4'b1001;
parameter [3:0]LOAD = 4'b1010;
parameter [3:0]STOR = 4'b1011;
parameter [3:0]Bcond = 4'b1100;
parameter [3:0]Jcond =4'b1101;
parameter [3:0]JAL = 4'b1110;
parameter [3:0]WAIT = 4'b1111;

// Conditional jump paramaters
parameter [3:0] EQUAL = 4'b0000;
parameter [3:0] NOT_EQUAL = 4'b0001;
parameter [3:0] CARRY_S = 4'b0010;
parameter [3:0] CARRY_C = 4'b0011;
parameter [3:0] HIGHER = 4'b0100;
parameter [3:0] LOWER_S = 4'b0101;
parameter [3:0] GREATER = 4'b0110;
parameter [3:0] L_EQUAL = 4'b0111;
parameter [3:0] FLAG_S = 4'b1000;
parameter [3:0] FLAG_C = 4'b1001;
parameter [3:0] LOWER = 4'b1010;
parameter [3:0] HIGHER_S = 4'b1011;
parameter [3:0] LESS = 4'b1100;
parameter [3:0] G_EQUAL = 4'b1101;
parameter [3:0] UNCONDITIONAL = 4'b1110;
parameter [3:0] NO_JUMP = 4'b1111;
parameter C = 4;
parameter L = 3;
parameter F = 2;
parameter Z = 1;
parameter N = 0;

/*
 *  Occurs if: positive + positive = negative
 *         or: negative + negative = positive
 */
function [0:0] overflow_add(input [15:0]Rdest,Rsrc,res);
  begin
    overflow_add = ((Rdest[15] == Rsrc[15]) && (res[15] !=Rdest[15]));
  end
endfunction


/*
 *  Occurs if: positive - negative = negative
 *         or: negative - positive = positive
 */
function [0:0] overflow_sub(input [15:0]Rdest,Rsrc,res);
  begin
    overflow_sub = ((Rdest[15] == 0 && Rsrc[15] == 1 && res[15] == 1) ||
                    (Rdest[15] == 1 && Rsrc[15] == 0 && res[15] == 0));
  end
endfunction

/*
 *  Given a signed number, returns the absolute value
 */
function [15:0] abs(input [15:0] n);
  begin
    if(n[15] == 1)
      abs = ~n + 16'b1;
    else
      abs = n;
  end
endfunction

function [15:0] shift(input [15:0]Rdest,Rsrc);
  begin
    if ($signed(Rsrc) > 0)
      shift = Rdest << Rsrc;
    else
      begin
        shift = Rdest >> abs(Rsrc);
      end
  end
endfunction


function [0:0] jump(input [3:0] c);
  begin
    case(c)
      EQUAL :
        begin
          jump = flags[Z] == 1;
        end
      NOT_EQUAL :
        begin
          jump = flags[Z] == 0;
        end
      G_EQUAL :
        begin
          jump = flags[N] == 1 || flags[Z] == 1;
        end
      CARRY_S :
        begin
          jump = flags[C] == 1;
        end
      CARRY_C :
        begin
          jump = flags[C] == 0;
        end
      HIGHER :
        begin
          jump = flags[L] == 1;
        end
      LOWER_S :
        begin
          jump = flags[L] == 0;
        end
      LOWER :
        begin
          jump = flags[L] == 0 && flags[Z] == 0;
        end
      HIGHER_S :
        begin
          jump = flags[L] == 1 || flags[Z] == 1;
        end
      GREATER :
        begin
          jump = flags[N] == 1;
        end
      L_EQUAL :
        begin
          jump = flags[N] == 0;
        end
      FLAG_S :
        begin
          jump = flags[F] == 1;
        end
      FLAG_C :
        begin
          jump = flags[F] == 0;
        end
      LESS :
        begin
          jump = flags[N] == 0 && flags[Z] == 0;
        end
      UNCONDITIONAL :
        begin
          jump = 1;
        end
      // What is the never jump condition?
      NO_JUMP :
        begin
          jump = 0;
        end
      default :
        begin
          jump = 0;
        end
    endcase
  end
endfunction

// Handle assembly instructions
//Rsrc will be the immediate or the other register
always@(Rdest, Rsrc, opcode, reset)
  begin

    flags = 0;
	 next_address = 0;
	 
    if (!reset)
      begin
        result = 0;
        flags  = 0;
      end
    else
      begin
        case(opcode)
          ADD :
            begin
              //Set any carryout to the flags[4] to signal unsigned carry out
              {flags[4], result} =Rdest + Rsrc;

              //SIGNED
              //If overflow has occured with signed arithmetic F flag
              flags[2] = overflow_add(Rdest,Rsrc,result);
            end

          ADDU :
            {flags[4], result} = Rdest + Rsrc; // Check for carryout and set carry flag

          MUL  :
            result = Rdest * Rsrc ;

          SUB  :
            begin
              result = Rdest - Rsrc;
              flags[2] = overflow_sub(Rdest,Rsrc,result);

              //UNSIGNED
              //Borrow occured-number being subtracted required bit off top of positive number
              if(Rsrc > Rdest)
                flags[4] = 1;
            end

          CMP  :
            begin
              result = Rdest - Rsrc;
              flags[1] = ~result;
              // simplify?
              flags[3] = $unsigned(Rsrc) > $unsigned(Rdest);
              flags[0] = Rsrc > Rdest;
            end

          AND  :
            result = Rdest & Rsrc ;

          OR   :
            result = Rdest | Rsrc ;

          XOR  :
            result = Rdest ^ Rsrc ;

          MOV  :
            result = Rsrc ;

          LSH  :
            result = shift(Rdest,Rsrc) ;

          LOAD :
            result = 0  ;

          STOR :
            result = 0  ;

          Bcond:
            begin
              next_address = current_address + 1'b1;
              if (jump(Rdest_index)) 
					next_address = current_address + Rsrc;
				  result = 0;
            end

          Jcond:
            begin
              next_address = current_address + 1'b1;
				  result = 0;
              if (jump(Rdest_index)) 
					next_address = Rsrc;
            end

          JAL  :
            begin
              result = 0;
              next_address = Rsrc;
              result = current_address + 1'b1;
            end
				
          WAIT :
            result = 0  ;

          default:
            result = 0;
        endcase
      end
  end
endmodule

  /*
  current_address will go from PC to ALU.
  next_address will go from ALU to 2-1 mux.
  	the 2-1 mux will be connected to the PC, the other input will be the increment 1 mod.
  	the enable signal for the mux will come from the FSM, which will need some logic to check if the command is a jump command or normal command.
  	I'm pretty sure we have some really similar logic in their already that we can adapt.
  cond will go from FSM to ALU.
  */
