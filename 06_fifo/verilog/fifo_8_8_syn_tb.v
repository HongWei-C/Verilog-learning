`timescale  1ns / 100ps
module fifo_8_8_syn_tb ();
  //clk 设置
  reg         clk;
  reg         rst_n;
  reg         wr;
  reg         rd;
  reg   [7:0] datain;

  initial begin
    $dumpfile("fifo_8_8_syn_tb_wave.vcd");
    $dumpvars;
  end


  task delay; //用于延迟 number个clk周期
    input [31:0]  number;
    begin
        repeat ( number ) @ ( posedge clk );
        #5;
    end
  endtask

  //clk设置
  initial begin
    clk       = 1'b0; 
  end
  always #10  clk = ~clk;

  //其他信号设置
  initial begin
    rst_n     = 1'b1;
    wr        = 1'b0;
    rd        = 1'b0;
    datain    = 8'b0;
    //1.全局复位
    delay(1);  rst_n = 1'b0;
    delay(1);
    rst_n     = 1'b1;
    //2.写使能，并输入数据，多写两个
    delay(1);
    wr        = 1'b1;
    while ( datain < 18 ) begin
      datain  = datain + 8'h01;
      delay(1);
    end
    wr        = 1'b0;
    //3.读使能，多读两个无效位来测试empty
    delay(2);
    rd        = 1'b1;
    delay(18);
    rd        = 1'b0;
    //4.finish
    delay(2);
    $finish;
  end
  
  wire        full;
  wire        full_err;
  wire        empty;
  wire        empty_err;
  wire  [7:0] dataout;

  fifo_8_8_syn fifo_duf (
    .wr       ( wr ),
    .rd       ( rd ),
    .rst_n    ( rst_n ),
    .clk      ( clk ),
    .full     ( full ),
    .empty    ( empty ),
    .full_err ( full_err ),
    .empty_err( empty_err ),
    .datain   ( datain ),
    .dataout  ( dataout )
  );

endmodule
