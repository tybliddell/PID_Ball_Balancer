`timescale 1ps/1ps
module tb_MemTest;
reg clk_a, clk_b, reset, ab, we_a, we_b;
reg [9:0] addr_a, addr_b;
reg [15:0] data_a, data_b;
wire [15:0] out;

MemTest test(.clk_a(clk_a), .clk_b(clk_b), .reset(reset), .ab(ab), .addr_a(addr_a), .addr_b(addr_b), .out(out), .data_a(data_a), .data_b(data_b), .we_a(we_a), .we_b(we_b));


parameter wait_time = 2;
integer i, x, y;

initial
  begin
    reset = 1;
    #wait_time;
    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    $display("[status] Beginning test on memory");

    addr_a = 0;
    ab = 0;
    clk_a = 0;
    clk_b = 0;
    #wait_time;
    clk_a = 1;
    clk_b = 1;
    #wait_time;
    clk_a = 0;
    clk_b = 0;

    if(out != 3)
      begin
        $display("[error] result:%b expected:3\nError on Line Number = %0d",out,`__LINE__);
        $stop;
      end
    data_a = out + 2;
    we_a = 1;
    #wait_time;
    clk_a = 1;
    clk_b = 1;
    #wait_time;
    if(out != 5)
      begin
        $display("[error] result:%b expected:5\nError on Line Number = %0d",out,`__LINE__);
        $stop;
      end

    addr_a = 1;
    addr_b = 513;
    data_b = 5;
    we_b = 1;
    clk_a = 0;
    clk_b = 0;

    #wait_time;
    clk_a = 1;
    clk_b = 1;
    #wait_time;
    if(out != 5)
      begin
        $display("[error] result:%b expected:5\nError on Line Number = %0d",out,`__LINE__);
        $stop;
      end
    ab = 1;
    #wait_time;
    if(out != 5)
      begin
        $display("[error] result:%b expected:5\nError on Line Number = %0d",out,`__LINE__);
        $stop;
      end

    $display("[status] Memory testing completed. No errors detected");
  end
endmodule
