`include "uart_defines.v"
module uart_ram_tb();
  reg         sys_clk;
  reg         rst_n;
  reg         rxd;

   task delay;
    input [31:0]  number;
    begin
      repeat ( number ) @ ( posedge sys_clk )
      #3;
    end
  endtask

  initial begin
    sys_clk = 1'b0;
  end
  always #10 sys_clk = ~sys_clk;

  initial begin
    rst_n = 1'b1;
    rxd   = 1'b1;
    delay(1*64);
    rst_n = 1'b0;
    delay(1*64);
    rst_n = 1'b1;
    delay(1*64);
  //rxd上来的指令 W
    //起始位
    rxd   = 1'b0;
    delay(1*64);
    //指令W，1111_0000 
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    //停止位
    rxd   = 1'b1;
    delay(1*64);
    //连续传输测试
    //3个空闲位
//    rxd   = 1'b1;
//    delay(3*64);
  //rxd上来的地址 0000_0101
    //起始位
    rxd   = 1'b0;
    delay(1*64);
    //地址，0000_0101 
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    //停止位
    rxd   = 1'b1;
    delay(1*64);
    //3个空闲位
//    rxd   = 1'b1;
//    delay(3*64);
  //rxd上来的数据 1100_1010
    //起始位
    rxd   = 1'b0;
    delay(1*64);
    //数据，1100_1010 
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    //停止位
    rxd   = 1'b1;
    delay(1*64);
    //3个空闲位
//    rxd   = 1'b1;
//    delay(3*64);
  //rxd上来的指令 R
    //起始位
    rxd   = 1'b0;
    delay(1*64);
    //指令R，0000_1111
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    //停止位
    rxd   = 1'b1;
    delay(1*64);
    //3个空闲位
//    rxd   = 1'b1;
//    delay(3*64);
  //rxd上来的地址 0000_0101
    //起始位
    rxd   = 1'b0;
    delay(1*64);
    //地址，0000_0101 
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b1;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    rxd   = 1'b0;
    delay(1*64);
    //停止位
    rxd   = 1'b1;
    delay(1*64);
    //16个空闲位
    rxd   = 1'b1;
    delay(16*64);

  
    $finish;
  end

  wire        txd;
  uart_ram ram_1 (
    .rst_n    ( rst_n ),
    .sys_clk  ( sys_clk),
    .rxd      ( rxd ),
    .txd      ( txd )
  );

endmodule
