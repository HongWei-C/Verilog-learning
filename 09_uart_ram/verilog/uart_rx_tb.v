`timescale  1ns / 100ps

module uart_rx_tb ();
  reg         sys_clk;
  reg         rst_n;
  reg         bps_clk_up;
  reg         rxd;

  task delay;
    input [31:0]  number;
    begin
      repeat ( number ) @ ( posedge sys_clk )
      #3;
    end
  endtask
  //clk初始化
  initial begin
    sys_clk = 1'b0;
  end
  always  #10 sys_clk = ~sys_clk;

  //bps_clk_up初始化
  initial begin
    bps_clk_up  = 1'b0;
  end
  always begin
    delay(7);
    bps_clk_up  = 1'b1;
    delay(1);
    bps_clk_up  = 1'b0;
  end
  
  //test_bench设置
  initial begin
    //初始化
    rst_n       = 1'b1;
    rxd         = 1'b1;
    //复位
    delay(1*4);
    rst_n       = 1'b0;
    delay(1*8);
    rst_n       = 1'b1;
    delay(1*5);
    //2个空闲位后,出现起始位,持续1周期
    delay(2*8);
    delay(4);
    rxd         = 1'b0;
    delay(1*8);
    //传输1111_0000
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    //传输停止位
    rxd         = 1'b1;
    delay(1*8);
  //测试连续传输，STOP后出现起始位
    rxd         = 1'b0;
    delay(1*8);
    //传输1011_1000
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    //传输停止位
    rxd         = 1'b1;
    delay(1*8);
  //测试连续传输，STOP后直接传输START
    rxd         = 1'b0;
    delay(1*8);
    //传输0001_0010
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    //传输停止位
    rxd         = 1'b1;
    delay(1*8);
    //传输3个空闲位
    rxd         = 1'b1;
    delay(3*8);
    //传输起始位
    rxd         = 1'b0;
    delay(1*8);
    //传输0011_1101
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    //传输停止位
    rxd         = 1'b1;
    delay(1*8);
    //传输3个空闲位
    rxd         = 1'b1;
    delay(3*8);
    $finish;
  end

  wire    [7:0] rx_data_o;
  wire          rx_idle;
  wire          rx_bits_ok;
  uart_rx rx_duf (
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up ),
    .rxd        ( rxd ),
    .rx_data_o  ( rx_data_o ),
    .rx_idle    ( rx_idle ),
    .rx_bits_ok ( rx_bits_ok )
  );
endmodule