module s2p_tb ();

reg         nreset_tb;   //全局复位设置
initial begin
  nreset_tb      = 1'b1;
  #7  nreset_tb  = 1'b0;
  #15 nreset_tb  = 1'b1;
end

reg         clk_tb;      //时钟设置，20'一周期
initial begin
  clk_tb     = 1'b0;
end
always  #10  clk_tb   = ~clk_tb;

reg         en_tb;
initial begin
  en_tb        = 1'b0;
  #33   en_tb  = 1'b1; //33'测试en_tb的使能作用
  #120  en_tb  = 1'b0; //153'测试en_tb的暂停转换作用
  #20   en_tb  = 1'b1; //173'重启转换，测试能否接上次暂停的串行数据继续转换
  #120  $finish;    //293'结束
end

reg         sin_tb;    //输入串行信号设置
initial begin
  sin_tb       = 1'b0;
  #27 sin_tb   = 1'b1;
  repeat ( 5 ) begin
    #20 sin_tb = 1'b0;
    #20 sin_tb = 1'b1;
  end
end

wire  [3:0] pout_tb;
s2p duf (
  .sin    ( sin_tb ),
  .en     ( en_tb ),
  .clk    ( clk_tb ),
  .nreset ( nreset_tb ),
  .pout   ( pout_tb )
);
endmodule
