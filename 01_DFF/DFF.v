module DFF (
  D,
  clk,
  rst_n,
  Q
);
  input       D;    //D触发器输入
  input       clk;  //时钟
  input       rst_n;//异步复位 低电平有效
  output      Q;    //D触发器输出
      
  reg         Q;
  //注意触发器都是 沿敏感
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      Q     <=  1'b0;
    end
    else begin
      Q     <=  D;
    end
  end
endmodule
