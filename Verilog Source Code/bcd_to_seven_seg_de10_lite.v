module bcd_to_sev_seg(bcd,seven_seg);

input [3:0] bcd;
output reg [0:6] seven_seg;

always @*
  begin
    case (bcd)
      4'b0000 :
        begin
          seven_seg = ~7'b1111110;
        end
      4'b0001 :
        begin
          seven_seg = ~7'b0110000;
        end
      4'b0010 :
        begin
          seven_seg = ~7'b1101101;
        end
      4'b0011 :
        begin
          seven_seg = ~7'b1111001;
        end
      4'b0100 :
        begin
          seven_seg = ~7'b0110011;
        end
      4'b0101 :
        begin
          seven_seg = ~7'b1011011;
        end
      4'b0110 :
        begin
          seven_seg = ~7'b1011111;
        end
      4'b0111 :
        begin
          seven_seg = ~7'b1110000;
        end
      4'b1000 :
        begin
          seven_seg = ~7'b1111111;
        end
      4'b1001 :
        begin
          seven_seg = ~7'b1110011;
        end
      4'b1010 :
        begin
          seven_seg = ~7'b1111101;
        end
      4'b1011 :
        begin
          seven_seg = ~7'b0011111;
        end
      4'b1100 :
        begin
          seven_seg = ~7'b1001110;
        end
      4'b1101 :
        begin
          seven_seg = ~7'b0111101;
        end
      4'b1110 :
        begin
          seven_seg = ~7'b1101111;
        end
      4'b1111 :
        begin
          seven_seg = ~7'b1000111;
        end
      default :
        begin
          seven_seg = ~7'b0000000;
        end
    endcase
  end
endmodule



  /*
  PIN ASSIGNMENTS
   
  bcd[3]			Input		PIN_F15
  bcd[2]			Input		PIN_B14
  bcd[1]			Input		PIN_A14
  bcd[0]			Input		PIN_A13
  seven_seg[0]		Output		PIN_C14
  seven_seg[1]		Output		PIN_E15
  seven_seg[2]		Output		PIN_C15
  seven_seg[3]		Output		PIN_C16
  seven_seg[4]		Output		PIN_E16
  seven_seg[5]		Output		PIN_D17
  seven_seg[6]		Output		PIN_C17
   
  */
