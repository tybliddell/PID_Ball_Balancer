// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Mon Sep 13 10:58:02 2021"

module ALU_BLOCK_Test(
         reset,
         switch_val,
         load_dest,
         load_src,
         load_op,
         Disp1,
         Disp2,
         Disp3,
         Disp4,
         Flags
       );


input wire	reset;
input wire [9:0]switch_val;
reg	[15:0] Dest;
reg	[15:0] Src;
output wire	[0:6] Disp1;
output wire	[0:6] Disp2;
output wire	[0:6] Disp3;
output wire	[0:6] Disp4;
output wire	[4:0] Flags;
input load_dest;
input load_src;
input load_op;
reg	[7:0] opcode;
wire	[15:0] result;





ALU	b2v_ALU_BLOCK(
      .Rdest(Dest),
      .Rsrc(Src),
      .op(opcode),
      .flags(Flags),
      .result(result),
      .reset(reset));



bcd_to_sev_seg	b2v_inst(
                 .bcd(result[3:0]),
                 .seven_seg(Disp1));


bcd_to_sev_seg	b2v_inst3(
                 .bcd(result[7:4]),
                 .seven_seg(Disp2));


bcd_to_sev_seg	b2v_inst4(
                 .bcd(result[11:8]),
                 .seven_seg(Disp3));


bcd_to_sev_seg	b2v_inst5(
                 .bcd(result[15:12]),
                 .seven_seg(Disp4));


always@(negedge load_dest)
  begin
    Dest[9:0] = switch_val[9:0];
  end

always@(negedge load_src)
  begin
    Src[9:0] = switch_val[9:0];
  end
always@(negedge load_op)
  begin
    opcode[7:0] = switch_val[7:0];
  end


endmodule
