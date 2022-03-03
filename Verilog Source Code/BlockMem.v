// Quartus Prime Verilog Template
// True Dual Port RAM with dual clocks

module BlockMem
       #(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=11)
       (
         input [(DATA_WIDTH-1):0] data_a, data_b,
         input [(ADDR_WIDTH-1):0] addr_a, addr_b,
         input we_a, we_b, clk_a, clk_b,
         output reg [(DATA_WIDTH-1):0] q_a, q_b
       );

// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

initial
  begin
    $readmemh("boot.txt", ram);
  end

always @ (negedge clk_a)
  begin
    // Port A
    if (we_a)
      begin
        ram[addr_a] <= data_a;
        q_a <= data_a;
      end
    else
      begin
        q_a <= ram[addr_a];
      end
  end

always @ (negedge clk_b)
  begin
    // Port B
    if (we_b)
      begin
        ram[addr_b] <= data_b;
        q_b <= data_b;
      end
    else
      begin
        q_b <= ram[addr_b];
      end
  end

endmodule



