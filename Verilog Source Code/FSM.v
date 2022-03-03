module FSM (input [15:0]instruction,
            input reset,
            input clk,
				input motor_ready,
				input x_pid_ready,
				input y_pid_ready,
            output reg [3:0] Rdest,
            output reg [3:0] Rsrc,
            output reg [15:0] imm,
            output reg IO_ctrl,
            output reg Imm_ctrl,
            output reg [15:0] Reg_enable,
            output reg [7:0] Op_code,
            output reg PC_en,
            output reg pc_set_ctrl,
            output reg ls_ctrl,
            output reg we_a,
            output reg load_to_reg_ctrl,
            output reg ir_en,
				output reg motor_driver,
				output reg x_pid_en,
				output reg y_pid_en,
				output wire reg_lock);
parameter 
FETCH = 6'b000000,
DEC   = 6'b000001,
EXEC  = 6'b000010,
WB    = 6'b000100,
L2M   = 6'b001000,
D2R   = 6'b010000,
IDLE  = 6'b010110,
DONE_WITH_MOTOR = 6'b010100,
MOTOR = 6'b010010,
PID = 6'b100000,
PID_DONE = 6'b100110,
DEC_BIT = 0,
L2M_BIT = 3;

DFlipFlop #(.SIZE(1)) flipflop
(.D(!reg_lock), .Q(reg_lock), .clk(pid_cntrl));
 
reg [5:0] current_state = IDLE;
wire special, R, S, L, J, mtr_cntrl;
assign special   = !(instruction[12] || instruction[13] || instruction[15]) && instruction[14];
assign S         = special && !instruction[7] && instruction[6];
assign L         = special && !(instruction[7] || instruction[6]);
assign R         = !(instruction[15] || instruction[14] || instruction[13] || instruction[12]);
assign J         = special && instruction[7];
assign mtr_cntrl = R && instruction[7] && !instruction[6] && !instruction[5] && !instruction[4];
assign pid_cntrl = R && instruction[7] && instruction[6] && !instruction[5] && !instruction[4];

reg [5:0] next_state = FETCH;
// special is = !(bits 12, 13, 15) & bit 14, but the only specials we implement are also !(bits 4, 5)
//assign next_state = {current_state[3], current_state[0] && !R && !S, current_state[0] && !R && !L, current_state[0] && !S && !L, !(current_state && 5'b11111)};

initial begin
PC_en = 1'b0;
end



always @(negedge reset, negedge clk)
begin
	  if (!reset) next_state <= FETCH;
	  else begin
      case(1'b1) // synthesis parallel_case full_case
		current_state[DEC_BIT]: begin
			if(mtr_cntrl) next_state <= MOTOR;
			else if(pid_cntrl) next_state <= PID;
			else if(L) next_state <= L2M;
			else if(S) next_state <= WB;
			else next_state <= EXEC;
		end
		current_state[L2M_BIT]: next_state <= D2R;
		default: next_state <= current_state == FETCH ? DEC : FETCH;
	  endcase
	  if(current_state == MOTOR && !motor_ready)
			next_state <= MOTOR;
		else if(current_state == MOTOR && motor_ready)
			next_state <= DONE_WITH_MOTOR;
		if(current_state == PID && (!x_pid_ready || !y_pid_ready))
			next_state <= PID;
		else if(current_state == PID && x_pid_ready && y_pid_ready)
			next_state <= PID_DONE;
	  end
end

always @(posedge clk, negedge reset) begin
	    if (!reset) begin
        current_state <= IDLE;
		end
		else
	current_state <= next_state;
end

/*
 Signals to be set every state:
 Rdest
 Rsrc
 imm
 IO_ctrl
 Imm_ctrl
 Reg_enable
 Op_code
 PC_en
 pc_set_ctrl
 ls_ctrl
 we_a
 load_to_reg_ctrl
 ir_en
 */
always @(current_state)
begin
    case(current_state)
        FETCH:
        begin
            Rdest            <= 4'd0;
            Rsrc             <= 4'd0;
            imm              <= 16'd0;
            IO_ctrl          <= 1'b0;
            Imm_ctrl         <= 1'b0;
            Reg_enable       <= 16'd0;
            Op_code          <= 8'd0;
            PC_en            <= 1'b0;
            pc_set_ctrl      <= 1'b0;
            ls_ctrl          <= 1'b0;
            we_a             <= 1'b0;
            load_to_reg_ctrl <= 1'b0;
            ir_en            <= 1'b1;
				motor_driver     <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
        end
        DEC:
        begin
				ir_en               <= 1'b0;
            Rdest   <= instruction[11:8];
            Rsrc    <= instruction[3:0];
            imm     <= {8'd0, instruction[7:0]};
            IO_ctrl <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
            Reg_enable          <= 16'd0;
            Op_code             <= {instruction[15:12], instruction[7:4]};
            PC_en               <= 1'b0;
            pc_set_ctrl         <= 1'b0;
            ls_ctrl             <= 1'b0;
            we_a                <= 1'b0;
            load_to_reg_ctrl    <= 1'b0;
				motor_driver        <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
        end
        EXEC:
        begin
			   ir_en    <= 1'b0;
            Rdest    <= instruction[11:8];
            Rsrc     <= instruction[3:0];
            imm      <= {8'd0, instruction[7:0]};
            IO_ctrl  <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
         if (!J)
				begin
                if(instruction != 16'b0000000000000000)
						Reg_enable   <= 16'b0000000000000001 << Rdest;
					 else  
						Reg_enable <= 16'd0;
				end
			else
				Reg_enable       <= 16'd0;
			
			Op_code          <= {instruction[15:12], instruction[7:4]};
			PC_en            <= 1'b1;
			pc_set_ctrl      <= J;
			ls_ctrl          <= 1'b0;
			we_a             <= 1'b0;
			load_to_reg_ctrl <= 1'b0;
			motor_driver     <= 1'b0;
			x_pid_en <= 1'b1;
			y_pid_en <= 1'b1;
        end
        WB:
        begin
            Rdest   <= instruction[11:8];
            Rsrc    <= instruction[3:0];
            imm     <= {8'd0, instruction[7:0]};
            IO_ctrl <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
            Reg_enable          <= 16'd0;
            Op_code             <= {instruction[15:12], instruction[7:4]};
            PC_en               <= 1'b1;
            pc_set_ctrl         <= 1'b0;
            ls_ctrl             <= 1'b1;
            we_a                <= 1'b1;
            load_to_reg_ctrl    <= 1'b0;
            ir_en               <= 1'b0;
				motor_driver        <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
        end
        L2M:
        begin
            Rdest   <= instruction[11:8];
            Rsrc    <= instruction[3:0];
            imm     <= {8'd0, instruction[7:0]};
            IO_ctrl <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
            Reg_enable          <= 16'd0;
            Op_code             <= {instruction[15:12], instruction[7:4]};
            PC_en               <= 1'b0;
            pc_set_ctrl         <= 1'b0;
            ls_ctrl             <= 1'b1;
            we_a                <= 1'b0;
            load_to_reg_ctrl    <= 1'b1;
            ir_en               <= 1'b0;
				motor_driver        <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
        end
        D2R:
        begin
            Rdest   <= instruction[11:8];
            Rsrc    <= instruction[3:0];
            imm     <= {8'd0, instruction[7:0]};
            IO_ctrl <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
                if(instruction != 16'b0000000000000000)
					Reg_enable   <= 16'b0000000000000001 << Rdest;
				else  
					Reg_enable <= 16'd0;
            Op_code             <= {instruction[15:12], instruction[7:4]};
            PC_en               <= 1'b1;
            pc_set_ctrl         <= 1'b0;
            ls_ctrl             <= 1'b1;
            we_a                <= 1'b0;
            load_to_reg_ctrl    <= 1'b1;
            ir_en               <= 1'b0;
				motor_driver        <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
        end
		  MOTOR:
		  begin
				ir_en               <= 1'b0;
            Rdest   <= instruction[11:8];
            Rsrc    <= instruction[3:0];
            imm     <= {8'd0, instruction[7:0]};
            IO_ctrl <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
            Reg_enable          <= 16'd0;
            Op_code             <= {instruction[15:12], instruction[7:4]};
            PC_en               <= 1'b0;
            pc_set_ctrl         <= 1'b0;
            ls_ctrl             <= 1'b0;
            we_a                <= 1'b0;
            load_to_reg_ctrl    <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
				if (instruction[7:6] == 2'b10)
					motor_driver <= 1'b1;
				else
					motor_driver <= 1'b0;
		  end
		  DONE_WITH_MOTOR: begin
				ir_en               <= 1'b0;
            Rdest   <= instruction[11:8];
            Rsrc    <= instruction[3:0];
            imm     <= {8'd0, instruction[7:0]};
            IO_ctrl <= 1'b0;
            Imm_ctrl <= (instruction[13:12] != 0) ||
            (instruction[15:12] == 4'b1000 && instruction[7:4] < 2'b10);
            Reg_enable          <= 16'd0;
            Op_code             <= {instruction[15:12], instruction[7:4]};
            PC_en               <= 1'b1;
            pc_set_ctrl         <= 1'b0;
            ls_ctrl             <= 1'b0;
            we_a                <= 1'b0;
            load_to_reg_ctrl    <= 1'b0;
				motor_driver 		  <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
		  end
		  PID: begin
			Rdest            <= 4'd0;
			Rsrc             <= 4'd0;
			imm              <= 16'd0;
			IO_ctrl          <= 1'b0;
			Imm_ctrl         <= 1'b0;
			Reg_enable       <= 16'd0;
			Op_code          <= 8'd0;
			PC_en            <= 1'b0;
			pc_set_ctrl      <= 1'b0;
			ls_ctrl          <= 1'b0;
			we_a             <= 1'b0;
			load_to_reg_ctrl <= 1'b0;
			ir_en            <= 1'b0;
			motor_driver     <= 1'b0;
			x_pid_en <= 1'b1;
			y_pid_en <= 1'b1;
		  end
		  PID_DONE: begin
			Rdest            <= 4'd0;
			Rsrc             <= 4'd0;
			imm              <= 16'd0;
			IO_ctrl          <= 1'b0;
			Imm_ctrl         <= 1'b0;
			Reg_enable       <= 16'd0;
			Op_code          <= 8'd0;
			PC_en            <= 1'b1;
			pc_set_ctrl      <= 1'b0;
			ls_ctrl          <= 1'b0;
			we_a             <= 1'b0;
			load_to_reg_ctrl <= 1'b1;
			ir_en            <= 1'b0;
			motor_driver     <= 1'b0;
			x_pid_en <= 1'b1;
			y_pid_en <= 1'b1;
		  end
        default:
        begin
            Rdest            <= 4'd0;
            Rsrc             <= 4'd0;
            imm              <= 16'd0;
            IO_ctrl          <= 1'b0;
            Imm_ctrl         <= 1'b0;
            Reg_enable       <= 16'd0;
            Op_code          <= 8'd0;
            PC_en            <= 1'b0;
            pc_set_ctrl      <= 1'b0;
            ls_ctrl          <= 1'b0;
            we_a             <= 1'b0;
            load_to_reg_ctrl <= 1'b0;
            ir_en            <= 1'b0;
				motor_driver     <= 1'b0;
				x_pid_en <= 1'b1;
				y_pid_en <= 1'b1;
        end
    endcase
end
endmodule



/*
 N0 = S1 ;
 N1 = S4 R' S' ;
 N2 = S4 R' L';
 N3 = S4 S' L';
 N4 = S0' S1' S2' S3' S4'
 */