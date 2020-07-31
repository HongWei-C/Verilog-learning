`include "uart_defines.v"

module uart_top_tb ();
  reg         sys_clk;
  reg         rst_n;
  reg         rxd;
  reg         tx_ready;
  reg   [7:0] tx_data_i;

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
  
  //test_bench设置
  initial begin
    //初始化
    rst_n       = 1'b1;
    rxd         = 1'b1;
    tx_ready    = 1'b0;
    tx_data_i   = 8'h00;
    //复位
    delay(1*8);
    rst_n       = 1'b0;
    delay(1*8);
    rst_n       = 1'b1;
    delay(1);
    //发送测试
    //2个空闲位后,出现起始位,持续1周期
    delay(2*8);
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

    //接收测试
    //传输数据，先保持一段时间空闲位
    tx_data_i   = 8'b0110_1110; //第一次要传输的数据
    delay(2*8);
    //给一个持续7个周期的起始信号    
    tx_ready    = 1'b1;        
    delay(4*8);
    //第一个数据未发送完前就给下一个数据，验证tx_data_r是否正常保持    
    tx_data_i   = 8'b1111_0000; //传输完BIT3后重新设置待数据
    delay(3*8);
    //拉低起始信号    
    tx_ready    = 1'b0;
    delay(3*8);
    //数据传输完保留一段时间(3个周期)的空闲状态IDLE
    delay(3*8);
    //拉高起始信号，保持一个周期
    tx_ready    = 1'b1;
    delay(1*8);
    //传输完第二个数据    
    tx_ready    = 1'b0;     
    delay(9*8);                //传输完这一个数据
    //保持3个周期的空闲状态IDLE
    delay(3*8);
    $finish;

  end

  wire  [7:0]   rx_data_o;
  wire          rx_ok;
  wire          txd;
  wire          tx_ok;
  
  uart_top top_duf (
    .sys_clk    ( sys_clk ),
    .rst_n      ( rst_n ),
    .rxd        ( rxd ),
    .rx_data_o  ( rx_data_o ),
    .txd        ( txd ),
    .tx_ready   ( tx_ready ),
    .tx_data_i  ( tx_data_i )
  );

endmodule
