// input wire reset,
// input wire clk,
// input wire [31:0] command,
// output wire [31:0] data_out,
// output wire valid

`timescale 1ps/1ps
module TB_PID;
parameter WAITTIME = 10;
parameter CLKTIME = 500000000;

reg clk, reset;
wire ready;
reg signed [15:0] PV;
wire signed [15:0] result;
reg signed [15:0] Kp;
reg signed [15:0] Kd;
reg signed [15:0] Ki;
reg enable;



PID pid(
      .clk(clk),
      .reset(!reset),
      .Kp(Kp),
      .Kd(Kd),
      .Ki(Ki),
      .Sp(16'd500),
      .Pv(PV),
      .data(result),
      .ready(ready),
      .enable(enable)
    );

initial
  begin
    $display("Setting Up");
    PV = 0;
    Kp = 0;
    Kd = 0;
    Ki = 0;
    reset = 0;
    clk = 0;
    enable = 1;
    #WAITTIME;
    reset = 1;
    #WAITTIME
     reset = 0;
  end

always@(posedge ready)
  begin
      $display(result);
      PV = PV + (result/10) + ($random%11);
  end

always #CLKTIME
  begin
    clk = ~clk;
  end

endmodule
