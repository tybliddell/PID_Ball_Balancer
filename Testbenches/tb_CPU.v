`timescale 100ms/1ps
module tb_CPU;
reg clk;
reg clk_b;
reg clk_en;
reg pixy_in;
reg drive_motor_signal;
reg arduino_in;
wire m1_dir_out;
wire m1_step_out;
wire m2_dir_out;
wire m2_step_out;
wire m3_dir_out;
wire m3_step_out;
reg reset;
wire [0:6] Disp1;
wire [0:6] Disp2;
wire [0:6] Disp3;
wire [0:6] Disp4;
wire [0:6] Disp5;
wire [0:6] Disp6;
reg sw1;
reg sw2;
reg sw3;
reg sw4;
reg sw5;
reg sw6;
reg sw7;
reg sw8;
reg sw9;
reg key_1;
reg key_2;
reg key_3;


CPU_ForDiagram cpu(
	.clk(clk),
	.reset(reset),
	.clk_en(clk_en),
	.clk_b(clk_b),
	.pixy_in(pixy_in),
	.arduino_in(arduino_in),
	.sw1(sw1),
	.sw2(sw2),
	.sw3(sw3),
	.sw4(sw4),
	.sw5(sw5),
	.sw6(sw6),
	.sw7(sw7),
	.sw8(sw8),
	.sw9(sw9),
	.key_1(key_1),
	.key_2(key_2),
	.key_3(key_3),
	.m1_step_out(m1_step_out),
	.m2_step_out(m2_step_out),
	.m3_step_out(m3_step_out),
	.m1_dir_out(m1_dir_out),
	.m2_dir_out(m2_dir_out),
	.m3_dir_out(m3_dir_out),
	.Disp1(Disp1),
	.Disp2(Disp2),
	.Disp3(Disp3),
	.Disp4(Disp4),
	.Disp5(Disp5),
	.Disp6(Disp6)
);

parameter wait_time = 1;
initial
  begin
	 clk = 0;
    reset = 1;
    #wait_time;
    reset = 0;
    #wait_time;
    reset = 1;
  end
  
  always #wait_time clk = ~clk;
endmodule
