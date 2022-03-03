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
// CREATED		"Tue Sep 28 20:20:18 2021"

module RAM_TEST(
         clk_a,
         clk_b,
         ab,
         reset,
         we_a,
         we_b,
         Disp1,
         Disp2,
         Disp3,
         Disp4
       );


input wire	clk_a, clk_b;
input wire	ab;
input wire we_a, we_b;
input wire	reset;
output wire	[0:6] Disp1;
output wire	[0:6] Disp2;
output wire	[0:6] Disp3;
output wire	[0:6] Disp4;

wire	[15:0] out;





FSMMem	b2v_inst(
         .clk_a(clk_a),
         .clk_b(clk_b),
         .ab(ab),
         .reset(reset),
         .we_a(we_a),
         .we_b(we_b),
         .out(out));
//defparam	b2v_inst.wait_time = 2;


bcd_to_sev_seg	b2v_inst3(
                 .bcd(out[7:4]),
                 .seven_seg(Disp2));


bcd_to_sev_seg	b2v_inst4(
                 .bcd(out[3:0]),
                 .seven_seg(Disp1));


bcd_to_sev_seg	b2v_inst5(
                 .bcd(out[11:8]),
                 .seven_seg(Disp3));


bcd_to_sev_seg	b2v_inst6(
                 .bcd(out[15:12]),
                 .seven_seg(Disp4));


endmodule
