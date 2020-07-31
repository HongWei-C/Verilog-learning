`include "uart_defines.v"

module uart_baud_tb ();
reg         sys_clk;
reg         rst_n;

  initial begin
    sys_clk   = 1'b0;
  end
  always #10 sys_clk  = ~sys_clk;

  initial begin
    rst_n     = 1'b1;
    @ ( posedge sys_clk ) #1 rst_n = 1'b0;
    @ ( posedge sys_clk ) #1 rst_n = 1'b1;
    #500  $finish;
  end

  wire      bps_clk_up;
//  wire      bps_clk_down;
  uart_baud baud_duf (
    .sys_clk      ( sys_clk ),
    .rst_n        ( rst_n ),
    .bps_clk_up   ( bps_clk_up )
//    .bps_clk_down ( bps_clk_down )
  );
endmodule
