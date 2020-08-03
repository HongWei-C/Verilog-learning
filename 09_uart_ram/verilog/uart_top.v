`include "uart_defines.v"
module uart_top (
  rst_n,
  sys_clk,
  bps_clk_up,
  rxd,
  rx_data_o,
  rx_idle,
  rx_bits_ok,
  tx_ready,
  tx_data_i,
  txd,
  tx_idle,
  tx_bits_ok
);
  input         rst_n;
  input         sys_clk;
  output        bps_clk_up;
  input         rxd;
  output  [7:0] rx_data_o;
  output        rx_idle;
  output        rx_bits_ok;
  input         tx_ready;
  input   [7:0] tx_data_i;
  output        txd;
  output        tx_idle;
  output        tx_bits_ok;


  uart_baud top_baud (
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up )
  );

  uart_rx top_rx (
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up ),
    .rxd        ( rxd ),
    .rx_data_o  ( rx_data_o ),
    .rx_idle    ( rx_idle ),
    .rx_bits_ok ( rx_bits_ok )
  );

  uart_tx top_tx (
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up ),
    .tx_ready   ( tx_ready ),
    .tx_data_i  ( tx_data_i ),
    .txd        ( txd ),
    .tx_idle    ( tx_idle ),
    .tx_bits_ok ( tx_bits_ok )
  );
endmodule
