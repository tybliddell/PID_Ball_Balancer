/**
* @brief: A simple MUX module for switching between immediate values, and values from the register file
* @input ctrl: The control signal for the MUX.
* @input immediate: The immediate value
* @input register: The register value
* @output out: The output value depends on ctrl. When ctrl is 1, the output is the immediate value
*              Else the value is the register value 
**/
module ImmediateControl(input wire ctrl, input wire immediate, input wire register, output wire out);
assign out = ctrl ? immediate : register;
endmodule
