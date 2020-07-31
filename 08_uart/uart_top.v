`include "uart_defines.v"
module uart_top (
  sys_clk,
  rst_n,
  rxd,
  rx_data_o,
  txd,
  tx_ready,
  tx_data_i
);
  input         sys_clk;    //系统时钟，100MHz
  input         rst_n;      //全局复位，低电平有效
  //接收端口
  input         rxd;        //接收数据 串口
  output  [7:0] rx_data_o;  //已接收的数据
  //发送端口
  output        txd;        //发送数据 串口
  input         tx_ready;   //发送数据 起始信号
  input   [7:0] tx_data_i;  //待发送的数据

  //波特率分频
  wire          sys_clk;
  wire          rst_n;
  wire          bps_clk_up; //经波特率分频后时钟的上升沿标志
                            //节拍延迟一个sys_clk
  uart_baud baud_1 ( 
    .sys_clk    ( sys_clk ),
    .rst_n      ( rst_n ),            
    .bps_clk_up ( bps_clk_up )
  );
  //调用发送端口
  wire          txd;
  wire          tx_ready;
  wire  [7:0]   tx_data_i;
  uart_tx tx_1 (
    .sys_clk    ( sys_clk ),
    .rst_n      ( rst_n ),
    .bps_clk_up ( bps_clk_up ),
    .tx_ready   ( tx_ready ),
    .tx_data_i  ( tx_data_i ),
    .txd        ( txd )
  );
  //调用接收端口
  wire          rxd;
  wire  [7:0]   rx_data_o;
  uart_rx rx_1 (
    .sys_clk    ( sys_clk ),
    .rst_n      ( rst_n ),
    .bps_clk_up ( bps_clk_up ),
    .rx_data_o  ( rx_data_o ),
    .rxd        ( rxd )
  );

endmodule
