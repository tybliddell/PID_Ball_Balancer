module DFlipFlop #(parameter SIZE = 16) (
    input [SIZE - 1:0] D,
    output reg [SIZE - 1:0] Q,
    input clk
); 

always @(posedge clk) begin
    Q <= D;
end
    
endmodule 