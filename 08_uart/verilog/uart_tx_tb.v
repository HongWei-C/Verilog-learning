`include "uart_defines.v"
module uart_tx_tb ();
  reg         sys_clk;
  reg         rst_n;
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
    //全局复位
    rst_n       = 1'b1;
    tx_ready    = 1'b0;
    tx_data_i   = 8'b0000_0000;
    delay(1);
    rst_n       = 1'b0;
    delay(1);
    rst_n       = 1'b1;
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
    $finish;
  end


  wire          txd;
  wire          tx_idle;
  wire          tx_bits_ok;  
  wire					bps_clk_up;

  uart_tx tx_duf (
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
