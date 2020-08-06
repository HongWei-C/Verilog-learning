`include "i2c_defines.v"
module i2c_div_clk_tb ();
  reg         rst_n;
  reg         sys_clk;

  task delay;
    input [31:0]  number;
    begin
      repeat ( number ) @ ( posedge sys_clk )
      #3;
    end
  endtask
  always #10 sys_clk  = ~sys_clk;
  initial begin
    rst_n   = 1'b1;
    sys_clk = 1'b0;
    delay(1*8);
    rst_n   = 1'b0;
    delay(1*8);
    rst_n   = 1'b1;
    delay(20*8);
    $finish;  
  end
  i2c_div_clk clk_duf(
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up ),
    .div_clk_up ( div_clk_up )
  );
endmodule
