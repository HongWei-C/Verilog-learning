`include "uart_defines.v"
module uart_top_tb ();
  reg           rst_n;
  reg           sys_clk;
  reg           rxd;
  reg           tx_ready;
  reg   [7:0]   tx_data_i;

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
    //复位
    delay(1*4);
    rst_n       = 1'b0;
    delay(1*32);
    rst_n       = 1'b1;
    delay(1*5);
    //2个空闲位后,出现起始位,持续1周期
    delay(2*32);
    delay(4);
    rxd         = 1'b0;
    delay(1*32);
    //传输1111_0000
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    //传输停止位
    rxd         = 1'b1;
    delay(1*32);
  //测试连续传输，STOP后出现起始位
    rxd         = 1'b0;
    delay(1*32);
    //传输1011_1000
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    //传输停止位
    rxd         = 1'b1;
    delay(1*32);
  //测试连续传输，STOP后直接传输START
    rxd         = 1'b0;
    delay(1*32);
    //传输0001_0010
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    //传输停止位
    rxd         = 1'b1;
    delay(1*32);
    //传输3个空闲位
    rxd         = 1'b1;
    delay(3*32);
    //传输起始位
    rxd         = 1'b0;
    delay(1*32);
    //传输0011_1101
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b1;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    rxd         = 1'b0;
    delay(1*32);
    //传输停止位
    rxd         = 1'b1;
    delay(1*32);
    //传输3个空闲位
    rxd         = 1'b1;
    delay(3*32);
    $finish;
  end

  initial begin
    tx_ready    = 1'b0;
    tx_data_i   = 8'b0000_0000;
    delay(1*17);
    //传输数据，先保持一段时间空闲位
    tx_data_i   = 8'b0110_1110; //第一次要传输的数据
    delay(2*32);
    //给一个持续1个周期的ready信号    
    tx_ready    = 1'b1;        
    delay(1*32);
    tx_ready    = 1'b0;
    delay(9*32);
    //连续传输数据
    tx_data_i   = 8'b1111_0000;
    tx_ready    = 1'b1;
    delay(1*32);
    tx_ready    = 1'b0;
    delay(9*32);
    //连续传输数据
    tx_data_i   = 8'b0000_1111;
    tx_ready    = 1'b1;
    delay(1*32);
    tx_ready    = 1'b0;
    delay(9*32);
    //3个空闲位
    delay(3*32);
    //传输数据
    tx_data_i   = 8'b1010_0101;
    tx_ready    = 1'b1;
    delay(1*32);
    tx_ready    = 1'b0;
    delay(13*32);
    
  end

  wire          bps_clk_up;
	wire					bps_clk_up_16x;
  wire    [7:0] rx_data_o;
  wire          rx_idle;
  wire          rx_bits_ok;
  wire          txd;
  wire          tx_idle;
  wire          tx_bits_ok;

  uart_top top_duf (
    .rst_n					( rst_n ),
    .sys_clk				( sys_clk ),
    .bps_clk_up			( bps_clk_up ),
		.bps_clk_up_16x	( bps_clk_up_16x),
    .rxd						( rxd ),
    .rx_data_o			( rx_data_o ),
    .rx_idle				( rx_idle ),
    .rx_bits_ok			( rx_bits_ok ),
    .tx_ready				( tx_ready ),
    .tx_data_i			( tx_data_i ),
    .txd						( txd ),
    .tx_idle				( tx_idle ),
    .tx_bits_ok			( tx_bits_ok )
);


endmodule
