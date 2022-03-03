`timescale 1ps/1ps
module TB_Fibonacci();
parameter clock_time = 1000000;


reg next;
reg reset;
wire[6:0] disp1;
wire[6:0] disp2;
wire[6:0] disp3;
wire[6:0] disp4;
Fibonacci fib(.next(next), .reset(reset), .disp1(disp1), .disp2(disp2), .disp3(disp3), .disp4(disp4));

initial
  begin
    next = 0;
    reset = 1;
    #10
     reset = 0;
    #10
     reset = 1;
  end


always #clock_time
  begin
    next = ~next;
    $display("%x - %x - %x - %x", disp4, disp3, disp2, disp1);
  end

endmodule
