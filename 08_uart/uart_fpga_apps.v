`include "uart_defines.v"
module uart_fpga_apps(
  sys_clk,
  rst_n,
  rxd,
  txd,
  tx_ready,
  rx_data_o
);
  input         sys_clk;
  input         rst_n;
  input         rxd;
  output        txd;
  input         tx_ready;
  output  [7:0] rx_data_o;
  wire    [7:0] rx_data_o;
  wire    [7:0] tx_data_i;
  //调用 uart
  uart_top top_1 (
    .sys_clk    ( sys_clk ),
    .rst_n      ( rst_n ),
    .rxd        ( rxd ),
    .rx_data_o  ( rx_data_o ),
    .txd        ( txd ),
    .tx_ready   ( tx_ready ),
    .tx_data_i  ( tx_data_i )
  );

  reg     [7:0] tx_data_r;
  assign  tx_data_i = tx_data_r;
  always @ ( rst_n ) begin
    if ( ~rst_n ) begin
      tx_data_r   = 8'b0100_0010;
    end
    else begin
      tx_data_r   = 8'b0100_0010;
    end
  end

  //调用数码管译码
endmodule

