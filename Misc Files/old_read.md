# ece-3710-group-project
This is the readme for the ECE 3710 group project. 

## Getting Started
* Install the Cyclone Device Support files  
* Create a new Quartus Project
* Name the project and top level heirarchy EECS427
* Use the device that corresponds with the DE1-SoC


## Notes
* Use [15:0] when instantiating a 16 bit vector for our endianness
* Unsigned -> uses carry flag
* Signed -> uses overflow flag
* 

## DEBUGGING
* If you are using a block diagram and change anything that is in the diagram, REGENERATE the .v file.
* Check non-blocking statements, are you using a value before it's set?
* Save the file!
* Check module declaration--are all inputs included?
* Check top level module for what you are trying to do!
* Make sure everything is included in project and things that should not be in are not.
* Have Miguel look at it because he can see things we can't.
* Eat some food, take a walk.
* Rubber ducky.
* 


## FILES NEEDED IN PROJECT
* CPU_ForDiagram.bdf  (TOP LEVEL)
* DFlipFlop.v
* SignExtend.v
* pid/PIDMultiplier.qip -> pid/PIDMultiplier.v
* pid/PIDAdder.qip -> pid/PIDAdder.v
* pid/PID.v
* vga_output.v
* nun_chuck.v
* REGISTERS.bdf
* FSM.v
* mux16_1.v
* BlockMem.v
* Mux41.v
* Mux21.v
* Register.v
* ALU_ENCODER.v
* bcd_to_seven_seg_de10_lite.v
* ALU.v
* Program_Counter.v
* add_1.v
* tb_CPU.v
* add_x.v
* output_files/stp1.stp
* my_dff.v
* uart_rec.v
* pixy_coords_reg.v
* baud_clock.v
* clock_splitter.v
* onehzclock.v
* motor_driver.v
* uart_tx.v
* absoluter.v

Notes about Pixy:
* x value range: 0-319
* y value range: 0-199
* Baud Rate: 19,200

On platform center
x: 165
y: 95
