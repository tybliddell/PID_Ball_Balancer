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
// CREATED		"Thu Oct 28 15:16:24 2021"

module tb_CPU_inst(
	reset,
	clk,
	grounds,
	gpio_gnd,
	Disp1,
	Disp2,
	Disp3,
	Disp4
);


input wire	reset;
input wire	clk;
input wire	[15:0] grounds;
output wire	gpio_gnd;
output wire	[0:6] Disp1;
output wire	[0:6] Disp2;
output wire	[0:6] Disp3;
output wire	[0:6] Disp4;

wire	[15:0] address;
wire	[15:0] data_a;
wire	[15:0] Imm;
wire	imm_ctrl;
wire	IO_ctrl;
wire	[15:0] IO_ext;
wire	load_to_reg_ctrl;
wire	ls_ctrl;
wire	[15:0] next_address;
wire	[7:0] Op_code;
wire	[15:0] out;
wire	PC_en;
wire	pc_set_ctrl;
wire	[15:0] q_b;
wire	[15:0] r01;
wire	[3:0] Rdest;
wire	we_a;
wire	[15:0] SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;
wire	[15:0] SYNTHESIZED_WIRE_2;
wire	[15:0] SYNTHESIZED_WIRE_44;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	[15:0] SYNTHESIZED_WIRE_45;
wire	[15:0] SYNTHESIZED_WIRE_46;
wire	[15:0] SYNTHESIZED_WIRE_47;
wire	[15:0] SYNTHESIZED_WIRE_48;
wire	[15:0] SYNTHESIZED_WIRE_49;
wire	[15:0] SYNTHESIZED_WIRE_50;
wire	[15:0] SYNTHESIZED_WIRE_51;
wire	[15:0] SYNTHESIZED_WIRE_52;
wire	[15:0] SYNTHESIZED_WIRE_53;
wire	[15:0] SYNTHESIZED_WIRE_54;
wire	[15:0] SYNTHESIZED_WIRE_55;
wire	[15:0] SYNTHESIZED_WIRE_56;
wire	[15:0] SYNTHESIZED_WIRE_57;
wire	[15:0] SYNTHESIZED_WIRE_58;
wire	[15:0] SYNTHESIZED_WIRE_59;
wire	[3:0] SYNTHESIZED_WIRE_35;
wire	[15:0] SYNTHESIZED_WIRE_60;
wire	[15:0] SYNTHESIZED_WIRE_37;
wire	[4:0] SYNTHESIZED_WIRE_39;
wire	SYNTHESIZED_WIRE_41;
wire	[15:0] SYNTHESIZED_WIRE_42;
wire	[15:0] SYNTHESIZED_WIRE_43;

assign	gpio_gnd = 0;
assign	SYNTHESIZED_WIRE_41 = 0;




Register	b2v_inst(
	.clk(clk),
	.reset(reset),
	.ALUBus(SYNTHESIZED_WIRE_0),
	.regEnable(SYNTHESIZED_WIRE_1),
	.r00(SYNTHESIZED_WIRE_45),
	.r01(r01),
	.r02(SYNTHESIZED_WIRE_46),
	.r03(SYNTHESIZED_WIRE_47),
	.r04(SYNTHESIZED_WIRE_48),
	.r05(SYNTHESIZED_WIRE_49),
	.r06(SYNTHESIZED_WIRE_50),
	.r07(SYNTHESIZED_WIRE_51),
	.r08(SYNTHESIZED_WIRE_52),
	.r09(SYNTHESIZED_WIRE_53),
	.r10(SYNTHESIZED_WIRE_54),
	.r11(SYNTHESIZED_WIRE_55),
	.r12(SYNTHESIZED_WIRE_56),
	.r13(SYNTHESIZED_WIRE_57),
	.r14(SYNTHESIZED_WIRE_58),
	.r15(SYNTHESIZED_WIRE_59));


Mux21	b2v_inst1(
	.ctrl(load_to_reg_ctrl),
	.x(SYNTHESIZED_WIRE_2),
	.y(SYNTHESIZED_WIRE_44),
	.out(SYNTHESIZED_WIRE_0));


Mux21	b2v_inst13(
	.ctrl(IO_ctrl),
	.x(SYNTHESIZED_WIRE_4),
	.y(IO_ext),
	.out(SYNTHESIZED_WIRE_2));


mux16_1	b2v_inst14(
	.in00(SYNTHESIZED_WIRE_45),
	.in01(r01),
	.in02(SYNTHESIZED_WIRE_46),
	.in03(SYNTHESIZED_WIRE_47),
	.in04(SYNTHESIZED_WIRE_48),
	.in05(SYNTHESIZED_WIRE_49),
	.in06(SYNTHESIZED_WIRE_50),
	.in07(SYNTHESIZED_WIRE_51),
	.in08(SYNTHESIZED_WIRE_52),
	.in09(SYNTHESIZED_WIRE_53),
	.in10(SYNTHESIZED_WIRE_54),
	.in11(SYNTHESIZED_WIRE_55),
	.in12(SYNTHESIZED_WIRE_56),
	.in13(SYNTHESIZED_WIRE_57),
	.in14(SYNTHESIZED_WIRE_58),
	.in15(SYNTHESIZED_WIRE_59),
	.select(Rdest),
	.Final_output(data_a));


mux16_1	b2v_inst16(
	.in00(SYNTHESIZED_WIRE_45),
	.in01(r01),
	.in02(SYNTHESIZED_WIRE_46),
	.in03(SYNTHESIZED_WIRE_47),
	.in04(SYNTHESIZED_WIRE_48),
	.in05(SYNTHESIZED_WIRE_49),
	.in06(SYNTHESIZED_WIRE_50),
	.in07(SYNTHESIZED_WIRE_51),
	.in08(SYNTHESIZED_WIRE_52),
	.in09(SYNTHESIZED_WIRE_53),
	.in10(SYNTHESIZED_WIRE_54),
	.in11(SYNTHESIZED_WIRE_55),
	.in12(SYNTHESIZED_WIRE_56),
	.in13(SYNTHESIZED_WIRE_57),
	.in14(SYNTHESIZED_WIRE_58),
	.in15(SYNTHESIZED_WIRE_59),
	.select(SYNTHESIZED_WIRE_35),
	.Final_output(SYNTHESIZED_WIRE_42));


ALU	b2v_inst18(
	.reset(reset),
	.current_address(address),
	.op(Op_code),
	.Rdest(data_a),
	.Rdest_index(Rdest),
	.Rsrc(SYNTHESIZED_WIRE_60),
	.flags(SYNTHESIZED_WIRE_39),
	.next_address(next_address),
	.result(SYNTHESIZED_WIRE_4));
	defparam	b2v_inst18.ADD = 4'b0000;
	defparam	b2v_inst18.ADDU = 4'b0001;
	defparam	b2v_inst18.AND = 4'b0101;
	defparam	b2v_inst18.Bcond = 4'b1100;
	defparam	b2v_inst18.C = 4;
	defparam	b2v_inst18.CARRY_C = 4'b0011;
	defparam	b2v_inst18.CARRY_S = 4'b0010;
	defparam	b2v_inst18.CMP = 4'b0100;
	defparam	b2v_inst18.EQUAL = 4'b0000;
	defparam	b2v_inst18.F = 2;
	defparam	b2v_inst18.FLAG_C = 4'b1001;
	defparam	b2v_inst18.FLAG_S = 4'b1000;
	defparam	b2v_inst18.G_EQUAL = 4'b1101;
	defparam	b2v_inst18.GREATER = 4'b0110;
	defparam	b2v_inst18.HIGHER = 4'b0100;
	defparam	b2v_inst18.HIGHER_S = 4'b1011;
	defparam	b2v_inst18.JAL = 4'b1110;
	defparam	b2v_inst18.Jcond = 4'b1101;
	defparam	b2v_inst18.L = 3;
	defparam	b2v_inst18.L_EQUAL = 4'b0111;
	defparam	b2v_inst18.LESS = 4'b1100;
	defparam	b2v_inst18.LOAD = 4'b1010;
	defparam	b2v_inst18.LOWER = 4'b1010;
	defparam	b2v_inst18.LOWER_S = 4'b0101;
	defparam	b2v_inst18.LSH = 4'b1001;
	defparam	b2v_inst18.MOV = 4'b1000;
	defparam	b2v_inst18.MUL = 4'b0010;
	defparam	b2v_inst18.N = 0;
	defparam	b2v_inst18.NO_JUMP = 4'b1111;
	defparam	b2v_inst18.NOT_EQUAL = 4'b0001;
	defparam	b2v_inst18.OR = 4'b0110;
	defparam	b2v_inst18.STOR = 4'b1011;
	defparam	b2v_inst18.SUB = 4'b0011;
	defparam	b2v_inst18.UNCONDITIONAL = 4'b1110;
	defparam	b2v_inst18.WAIT = 4'b1111;
	defparam	b2v_inst18.XOR = 4'b0111;
	defparam	b2v_inst18.Z = 1;


Mux21	b2v_inst19(
	.ctrl(pc_set_ctrl),
	.x(SYNTHESIZED_WIRE_37),
	.y(next_address),
	.out(SYNTHESIZED_WIRE_43));


Mux21	b2v_inst2(
	.ctrl(ls_ctrl),
	.x(address),
	.y(SYNTHESIZED_WIRE_60),
	.out(out));


FSM	b2v_inst20(
	.reset(reset),
	.clk(clk),
	.flags(SYNTHESIZED_WIRE_39),
	.instruction(SYNTHESIZED_WIRE_44),
	.IO_ctrl(IO_ctrl),
	.Imm_ctrl(imm_ctrl),
	.PC_en(PC_en),
	.pc_set_ctrl(pc_set_ctrl),
	.ls_ctrl(ls_ctrl),
	.we_a(we_a),
	.load_to_reg_ctrl(load_to_reg_ctrl),
	.imm(Imm),
	.Op_code(Op_code),
	.Rdest(Rdest),
	.Reg_enable(SYNTHESIZED_WIRE_1),
	.Rsrc(SYNTHESIZED_WIRE_35));
	defparam	b2v_inst20.D2R = 5'b10000;
	defparam	b2v_inst20.DEC = 5'b00001;
	defparam	b2v_inst20.EXEC = 5'b00010;
	defparam	b2v_inst20.FETCH = 5'b00000;
	defparam	b2v_inst20.L2M = 5'b01000;
	defparam	b2v_inst20.WB = 5'b00100;


bcd_to_sev_seg	b2v_inst3(
	.bcd(r01[7:4]),
	.seven_seg(Disp2));


bcd_to_sev_seg	b2v_inst4(
	.bcd(r01[3:0]),
	.seven_seg(Disp1));


bcd_to_sev_seg	b2v_inst5(
	.bcd(r01[11:8]),
	.seven_seg(Disp3));


bcd_to_sev_seg	b2v_inst6(
	.bcd(r01[15:12]),
	.seven_seg(Disp4));



BlockMem	b2v_inst8(
	.we_a(we_a),
	.we_b(SYNTHESIZED_WIRE_41),
	.clk_a(clk),
	.clk_b(clk),
	.addr_a(out[10:0]),
	.addr_b(r01[10:0]),
	.data_a(data_a),
	.data_b(grounds),
	.q_a(SYNTHESIZED_WIRE_44)
	);
	defparam	b2v_inst8.ADDR_WIDTH = 11;
	defparam	b2v_inst8.DATA_WIDTH = 16;


Mux21	b2v_inst9(
	.ctrl(imm_ctrl),
	.x(SYNTHESIZED_WIRE_42),
	.y(Imm),
	.out(SYNTHESIZED_WIRE_60));


add_1	b2v_inst_add1(
	.current(address),
	.next(SYNTHESIZED_WIRE_37));



Program_Counter	b2v_inst_PC(
	.PC_en(PC_en),
	.new_val(SYNTHESIZED_WIRE_43),
	.address(address));


endmodule
