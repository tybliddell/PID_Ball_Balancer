`timescale 1ps/1ps
module tb_Regbank;
reg [15:0] data;
reg [0:15] write_enable;
wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
reg  reset, clk;
// order of flags from Left to Right: CLFZN
//43210
wire [4:0]flags;
wire [15:0]result;

parameter wait_time = 2;
parameter clock_time = 1;

// dummy loop variable
integer i;

Register regbank(.ALUBus(data), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4),
                 .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12),
                 .r13(r13), .r14(r14), .r15(r15), .regEnable(write_enable), .clk(clk), .reset(reset));

always #clock_time clk = ~clk;

initial
  begin
    clk = 0;
    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    data = 43690;
    write_enable = 65535;

    #wait_time;

    $display("reg0:%b", r0);
    $display("reg1:%b", r1);
    $display("reg2:%b", r2);
    $display("reg3:%b", r3);
    $display("reg4:%b", r4);
    $display("reg5:%b", r5);
    $display("reg6:%b", r6);
    $display("reg7:%b", r7);
    $display("reg8:%b", r8);
    $display("reg9:%b", r9);
    $display("reg10:%b", r10);
    $display("reg11:%b", r11);
    $display("reg12:%b", r12);
    $display("reg13:%b", r13);
    $display("reg14:%b", r14);
    $display("reg15:%b", r15);

    data = 137;
    write_enable = 16'b0000000011111111;

    $display("Changed upper registers:\n\n");

    #wait_time;

    $display("reg0:%b", r0);
    $display("reg1:%b", r1);
    $display("reg2:%b", r2);
    $display("reg3:%b", r3);
    $display("reg4:%b", r4);
    $display("reg5:%b", r5);
    $display("reg6:%b", r6);
    $display("reg7:%b", r7);
    $display("reg8:%b", r8);
    $display("reg9:%b", r9);
    $display("reg10:%b", r10);
    $display("reg11:%b", r11);
    $display("reg12:%b", r12);
    $display("reg13:%b", r13);
    $display("reg14:%b", r14);
    $display("reg15:%b", r15);

    data = 0;
    write_enable = 65535;
    #wait_time;

    // Test to create an identity matrix view of the register

    write_enable = 0;
    for (i = 0; i <= 15; i = i + 1)
      begin
        write_enable = (1 << i);
        #wait_time;
        data = (32768 >> i);
        #wait_time;
      end
    $display("\n\n15x15 Identity Matrix\n");
    $display("%b", r0);
    $display("%b", r1);
    $display("%b", r2);
    $display("%b", r3);
    $display("%b", r4);
    $display("%b", r5);
    $display("%b", r6);
    $display("%b", r7);
    $display("%b", r8);
    $display("%b", r9);
    $display("%b", r10);
    $display("%b", r11);
    $display("%b", r12);
    $display("%b", r13);
    $display("%b", r14);
    $display("%b", r15);
  end
endmodule

