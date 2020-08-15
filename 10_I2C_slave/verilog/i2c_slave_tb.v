`include "i2c_defines.v"
module i2c_slave_tb ();
  reg         rst_n;
  reg         sys_clk;
  reg   [7:0] sda_data_in;
  reg         scl;
  reg         sda_in;
  wire        sda;
  wire        sda_en;
  
  task delay;
    input [31:0]  number;
    begin
      repeat ( number ) @ ( posedge sys_clk )
      #3;
    end
  endtask

  assign sda = sda_en ? 1'bz : sda_in;

  initial begin
    sys_clk = 1'b0;
  end
  always  #10 sys_clk = ~sys_clk;

  initial begin
    rst_n       = 1'b1;
    sda_data_in = 8'b0;
    scl         = 1'b1;
    sda_in      = 1'b1;
    delay(4);
    rst_n       = 1'b0;
    delay(4);
    rst_n       = 1'b1;
    delay(13);
    //起始信号
    sda_in      = 1'b1;
    scl         = 1'b1;
    delay(4);
    sda_in      = 1'b0;
    delay(4);
    scl         = 1'b0;
    delay(8);
    //DEV_ADDR 1111_010+W(0)
    //7
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //6
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //5
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //4
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //3
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //2
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //1
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //wr(0)
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //ACK
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //W_WAIT
    sda_in      = 1'b1;
    scl         = 1'b0;
    delay(2*8);
    //DATA1 1100_0001
    //7
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //6
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //5
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //4
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //3
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //2
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //1
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //0
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //ACK
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //W_WAIT
    sda_in      = 1'b1;
    scl         = 1'b0;
    delay(2*8);
    //DATA2 1100_0010
    //7
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //6
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //5
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //4
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //3
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //2
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //1
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //0
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //ACK
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //W_WAIT
    sda_in      = 1'b1;
    scl         = 1'b0;
    delay(2*8);
//测试读命令
    //起始信号
    sda_in      = 1'b1;
    scl         = 1'b1;
    delay(4);
    sda_in      = 1'b0;
    delay(4);
    scl         = 1'b0;
    delay(8);
    //DEV_ADDR 1111_010+R(1)
    //7
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //6
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //5
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //4
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //3
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //2
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //1
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //wr(1)
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //W_ACK
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //W_WAIT
    sda_in      = 1'b1;
    scl         = 1'b0;
    sda_data_in = 8'b1001_0001;
    delay(4*8);//延迟8个div_clk后进入R_DATA状态
    //READ1 1001_0001
    //从机拉上sda_en
    //7
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //6
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //5
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //4
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //3
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //2
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //1
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //0
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //R_NULL+R_ACK
    sda_in      = 1'b0;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //R_WAIT
    sda_in      = 1'b1;
    scl         = 1'b0;
    sda_data_in = 8'b1001_0010;
    delay(4*8);//延迟8个div_clk后进入R_DATA状态
    //READ2 1001_0010
    //从机拉上sda_en
    //7
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //6
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //5
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //4
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //3
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //2
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //1
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //0
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //R_NULL+R_NACK
    sda_in      = 1'b1;
    delay(2);
    scl         = 1'b1;
    delay(4);
    scl         = 1'b0;
    delay(2);
    //R_WAIT
    sda_in      = 1'b1;
    scl         = 1'b0;
    delay(6*8);
    //STOP
    sda_in      = 1'b0;
    scl         = 1'b0;
    delay(4);
    scl         = 1'b1;
    delay(4);
    sda_in      = 1'b1;
    //IDLE
    delay(4*8);




    $finish;
  end

  wire    [7:0] sda_data_out;
  i2c_slave slave_duf (
    .rst_n        ( rst_n ),
    .sys_clk      ( sys_clk ),
    .sda_data_in  ( sda_data_in ),
    .sda_data_out ( sda_data_out ),
    .sda_en       ( sda_en ),
    .scl          ( scl ),
    .sda          ( sda )
  );

endmodule
