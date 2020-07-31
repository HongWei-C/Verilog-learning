`include "uart_defines.v"

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
    delay(1*8);
    rst_n       = 1'b0;
    delay(1*8);
    rst_n       = 1'b1;
    delay(1);
    //2个空闲位后,出现起始位,持续1周期
    delay(2*8);
    delay(4);
    rxd         = 1'b0;
    delay(1*8);
    //传输0101_1011
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    rxd         = 1'b1;
    delay(1*8);
    rxd         = 1'b0;
    delay(1*8);
    //传输停止位
    rxd         = 1'b1;
    delay(1*8);
    //传输3个空闲位
    rxd         = 1'b1;
    delay(3*8);
    //2个空闲位后,出现起始位,持续1周期
    delay(2*8);
    rxd         = 1'b0;
    delay(1*8);
    //传输0000_1111
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

  wire          rx_ok;
  wire    [7:0] rx_data_o;
  uart_rx rx_duf (
    .sys_clk    ( sys_clk ),
    .rst_n      ( rst_n ),
    .bps_clk_up ( bps_clk_up ),
    .rx_data_o  ( rx_data_o ),
    .rxd        ( rxd )
  );
endmodule
