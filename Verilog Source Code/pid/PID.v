module PID(input wire signed [15:0] Kp, Kd, Ki, Sp, Pv, T, input wire clk, reset, enable, output reg signed [15:0] data, output reg ready);
reg signed [15:0] e_n, e_nPrev, kpd, derivative, sigma, sigma_n, kpde, diffA, diffB, prodA, prodB, sumA, sumB, prodA1, prodB1;
reg [3:0] state, stall;
wire uf, of;
reg [15:0] counter;
wire signed [15:0] difference, sum;
wire signed [31:0]product, product1;
reg add_sub, add_sub1;
wire borrow_out, carry_out;
reg borrow_in, carry_in, sigma_cin;
PIDAdder subtractor (
           .add_sub(1'b0),
           .cin(1'b1),
           .dataa(diffA),
           .datab(diffB),
           .cout(borrow_out),
           .overflow(uf),
           .result(difference)
         );
PIDAdder adder (
           .add_sub(1'b1),
           .cin(carry_in),
           .dataa(sumA),
           .datab(sumB),
           .cout(carry_out),
           .overflow(of),
           .result(sum)
         );
PIDMultiplier multiplier(.dataa(prodA), .datab(prodB), .result(product));
PIDMultiplier multiplier1(.dataa(prodA1), .datab(prodB1), .result(product1));

always@(posedge clk or negedge reset)
  begin
    if(!reset)
      begin
        e_n <= 0;
        e_nPrev <= 0;
        kpd <= 0;
        derivative <= 0;
        sigma <= 0;
        diffA <= 0;
        diffB <= 0;
        state <= 0;
        ready <= 0;
        data <= 0;
        borrow_in <= 0;
        add_sub <= 1'b0;
        kpde <= 0;
        sigma_n <= 0;
        stall <= 4'd0;
        add_sub1 <= 1'b1;
        carry_in <= 1'b0;
        sumA <= 0;
        sumB <= 0;
        prodA1 <= 0;
        prodB1 <= 0;
        sigma_cin <= 1'b0;
        counter <= 0;
      end
    else if(enable)
      begin
        // time loop reseet
        if(T > 0 && counter == T) begin
          counter <= 0;
          e_nPrev <= 0;
          sigma <= 0;
        end
        else if(T > 0) begin
          counter <= counter + 1;
        end
        else begin
          counter <= 0;
        end
        case(state)
          4'd0:
            begin
              // store e(n - 1)
              e_nPrev <= e_n;
              state <= 4'd1;
              ready <= 1'b0;
              // Begin calculating Sp - Pv
              diffA <= Sp;
              diffB <= Pv;
              // Begin calculating Kp + Kd
              sumA <= Kp;
              sumB <= Kd;
              carry_in <= 0;
            end
          4'd1:
            begin
              // store e(n)
              e_n <= difference;
              // store kp + kd
              kpd <= sum;
              // begin calculating Kd * e(n - 1)
              prodA <= e_nPrev;
              prodB <= Kd;
              // begin calculating e(n) * (Kp + Kd)
              prodA1 <= sum;
              prodB1 <= difference;
              state <= 4'd2;
              carry_in <= 0;
            end
          4'd2:
            begin
              kpde <= product1[15:0];
              derivative <= product[15:0];
              // begin calculating e(n) - (Kd * e(n - 1))
              sumA <= sigma;
              sumB <= e_n;
              state <= 4'd3;
              carry_in <= sigma_cin;
            end
          4'd3:
            begin
              sigma <= sum;
              prodA <= Ki;
              prodB <= sum;
              state <= 4'd4;
              sigma_cin <= carry_out;
            end
          4'd4:
            begin
              diffA <= product[15:0];
              diffB <= derivative;
              state <= 4'd5;
              carry_in <= 0;
            end
          4'd5:
            begin
              // Begin calculating final value
              sumA <= kpde;
              sumB <= difference;
              state <= 4'd6;
              carry_in <= 0;
            end
          4'd6:
            begin
              // store result and go back to the top
              data <= (sum >>> 3);
              ready <= 1'b1;
              state <= 4'd0;
              carry_in <= 0;
            end
        endcase
      end
    else begin
      ready <= 1'b0;
      state <= 4'd0;
		end
  end
endmodule
