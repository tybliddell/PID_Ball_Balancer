`timescale 1ps/1ps
module tb_ALU;
reg  [15:0]x; //rdest
reg  [15:0]y;  //rsrc/imm
reg  [7:0]opcode;
reg  reset;
// order of flags from Left to Right: CLFZN
//43210
wire [4:0]flags;
wire [15:0]result;

parameter wait_time = 2;

// dummy loop variable
integer i;

ALU alu(.Rdest(x),.Rsrc(y),.op(opcode),.flags(flags),.result(result), .reset(reset));

initial
  begin
    $display("[status] Beginning tests on ALU");
    // body of test
    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    //Testing OR - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00000010;
    for(x = 0; x < 2**6; x = x + 1)
      begin
        for(y = 0; y < 2**6; y = y + 1)
          begin
            #wait_time;
            if(result != (x|y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x|y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != (x|y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x|y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    //Testing AND - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00000001;
    for(x = 0; x < 2**6; x = x + 1)
      begin
        for(y = 0; y < 2**6; y = y + 1)
          begin
            #wait_time;
            if(result != (x&y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x&y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != (x&y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x&y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    //Testing XOR - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00000011;
    for(x = 0; x < 2**6; x = x + 1)
      begin
        for(y = 0; y < 2**6; y = y + 1)
          begin
            #wait_time;
            if(result != (x^y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x^y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != (x^y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x^y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;


    //Testing ADD - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    //opcode = 8'b00000101;
    opcode = 8'b01011111;
    x = 0;
    y = 0;
    #wait_time;
    if(result != 0)
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,0,`__LINE__);
        $stop;
      end

    //Check signed interp--should overflow (max_int + max_int > max_int)
    x = 16'b0111111111111111;
    y = 16'b0111111111111111;
    #wait_time;
    if(flags[2] != 1)
      begin
        $display("x: %b, y: %b, result: %b, flags: %b",x,y,result,flags);
        $display("[error] Overflow expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Check signed interp--should overflow (min_int - min_int < min_int)
    x = 16'b1000000000000000;
    y = 16'b1000000000000001;
    #wait_time;
    if(flags[2] != 1)
      begin
        $display("x: %b, y: %b, result: %b, flags: %b",x,y,result,flags);
        $display("[error] Overflow expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Check unsigned interp--should carryout (max_int + max_int > max_int)
    x = 16'b1111111111111111;
    y = 16'b1111111111111111;
    #wait_time;
    if(flags[4] != 1)
      begin
        $display("[error] Carryout expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != (x+y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x+y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    //Testing ADDU - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00000110;
    x = 0;
    y = 0;
    #wait_time;
    if(result != 0)
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,0,`__LINE__);
        $stop;
      end

    //Check unsigned interp--should carryout (max_int + max_int > max_int)
    x = 16'b1111111111111111;
    y = 16'b1111111111111111;
    #wait_time;
    if(flags[4] != 1)
      begin
        $display("[error] Carryout expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != (x+y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x+y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    //Testing SUB - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00001001;
    x = 0;
    y = 0;
    #wait_time;
    if(result != 0)
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,0,`__LINE__);
        $stop;
      end

    //Check signed interp--should overflow (max_int - (-1) > max_int)
    x = 16'b0111111111111111;
    y = 16'b1111111111111111;
    #wait_time;
    if(flags[2] != 1)
      begin
        $display("x: %b, y: %b, result: %b, flags: %b",x,y,result,flags);
        $display("[error] Overflow expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Check signed interp--should overflow (min_int - (+1) < min_int)
    x = 16'b1000000000000000;
    y = 16'b0000000000000001;
    #wait_time;
    if(flags[2] != 1)
      begin
        $display("x: %b, y: %b, result: %b, flags: %b",x,y,result,flags);
        $display("[error] Overflow expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Check unsigned interp--should carryout (0 - 1 < 0)
    x = 16'b0000000000000000;
    y = 16'b0000000000000001;
    #wait_time;
    if(flags[4] != 1)
      begin
        $display("[error] Carryout expected, flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != (x-y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x-y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;

    //Testing MUL - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00001110;
    x = 0;
    y = 0;
    #wait_time;
    if(result != 0)
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,0,`__LINE__);
        $stop;
      end

    for(x = 0; x < 2**6; x = x + 1)
      begin
        for(y = 0; y < 2**6; y = y + 1)
          begin
            #wait_time;
            if(result != (x*y))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x*y),`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    //Some weird verilog addition happens here where 2**15 - 2**8 treats one as an unsigned and one as
    //signed, resulting in forever loops. The x>2**8 and y>2**8 are required here to stop that
    for(x = (2**16) - 2**8; x < 2**16 && x > 2**8; x = x + 1)
      begin
        for(y = (2**16) - 2**8; y < 2**16 && y > 2**8; y = y + 1)
          begin
            #wait_time;
            if(result != ((x*y) & 'hFFFF))
              begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x*y) & 'hFFFF,`__LINE__);
                $stop;
              end
            #wait_time;
          end
      end

    //Testing CMP - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b00001011;
    x = 0;
    y = 0;
    for(x = 0; x < 2**8; x = x + 1)
      begin
        y = x;
        #wait_time;
        if(flags[1] != 1)
          begin
            $display("x: %b, y: %b, flags: %b",x,y,flags);
            $display("[error] Zero flag expected, flag was not set. Line Number = %0d",result,(x-y),`__LINE__);
            $stop;
          end
      end

    //Check unsigned interp--if rsrc/imm > rdst when unsigned, set L flag
    x = 16'b0111111111111111;
    y = 16'b1111111111111111;
    #wait_time;
    if(flags[3] != 1)
      begin
        $display("x: %b, y: %b, flags: %b",x,y,flags);
        $display("[error] L flag expected (unsigned cmp), flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end
    if(flags[0] == 1)
      begin
        $display("x: %b, y: %b, flags: %b",x,y,flags);
        $display("[error] N flag not expected (signed cmp), flag was signed. Line Number = %0d",`__LINE__);
      end

    //Check signed interp--if rsrc/imm > rdst when signed, set N flag
    x = 16'b1111111111111111; //-1
    y = 16'b0000000000000001; //1
    #wait_time;
    if(flags[0] != 1)
      begin
        $display("x: %b, y: %b, flags: %b",x,y,flags);
        $display("[error] N flag expected (signed cmp), flag was not signed. Line Number = %0d",`__LINE__);
        $stop;
      end
    if(flags[3] == 1)
      begin
        $display("x: %b, y: %b, flags: %b",x,y,flags);
        $display("[error] L flag not expected (unsigned cmp), flag was signed. Line Number = %0d",`__LINE__);
      end

    //TODO: Add more cmp cases


    //Testing LSH - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    opcode = 8'b10000100;
    x = 0;
    y = 0;
    #wait_time;
    if(result != 0)
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,0,`__LINE__);
        $stop;
      end

    x = -1;
    y = 15;

    if (result != 0)
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x << 15),`__LINE__);
        $stop;
      end

    #wait_time;

    x = -1;
    y = 5;

    #wait_time;

    if (result != (x << 5))
      begin
        $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x << 5),`__LINE__);
        $stop;
      end

    #wait_time;
    // Testing negative shifts
    x = -1;
    y = 0;
    // loop overshoots by a few places to ensure it only returns 0 after going past 16 and does not give
    // unintended behavior
    for(i = 0; i < 18; i = i + 1)
      begin
        y = i;
        #wait_time;
        if (result != (x << i))
          begin
            $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x << i),`__LINE__);
            $stop;
          end
      end

    #wait_time;
    // Testing negative shifts
    x = -1;
    y = 0;
    // loop overshoots by a few places to ensure it only returns 0 after going past 16 and does not give
    // unintended behavior
    for(i = 0; i < 18; i = i + 1)
      begin
        y = -i;
        #wait_time;
        if (result != (x >> i))
          begin
            $display("[error] result:%b expected:%b\nError on Line Number = %0d",result,(x >> i),`__LINE__);
            $stop;
          end
      end
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    //Testing completed
    reset = 0;
    #wait_time;
    reset = 1;
    #wait_time;
    $display("[status] ALU testing completed. No errors detected");
  end
endmodule
