module reg_unit (
  Din,
  en,
  rst_n,
  clk,
  Q
);

  input         Din;    //寄存器的输入
  input         en;     //使能 高电平有效
  input         rst_n;  //全局复位 低电平有效
  input         clk;    //时钟
  output        Q;      //输出

  reg           Q;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      Q       <= 1'b0;
    end 
    else if ( en ) begin
     Q       <= Din;
    end
    else begin
     Q       <= Q;
    end
  end
endmodule
