module s2p (//触发器均用非阻塞赋值
  sin,
  en,
  clk,
  nreset,
  pout
);

input         sin;      //输入的串行信号
input         en;       //转换使能
input         clk;      //时钟
input         nreset;   //全局复位
output  [3:0] pout;     //转换的并行信号

reg     [1:0] count;    //移位计数，控制并行数据跟新
always @ ( posedge clk or negedge nreset ) begin  //两个DFF构成的计数器
  if ( ~nreset ) begin
    count   <= 2'b11;   //先把count初始化为2'b11，同时并行输出一个0000，并保证第一次等待4个周期才输出一个并行数据
  end
  else if ( en ) begin
    count   <= count + 2'b01;
  end
  else begin
    count   <= count;
  end
end

reg     [3:0] data;     //用于中间串行数据传输
always @ ( posedge clk or negedge nreset ) begin  //4个DFF构成的移位寄存器
  if ( ~nreset ) begin
    data    <= 4'b0000;
  end
  else if ( en ) begin
    data    <= { data[2:0] , sin };
  end
  else begin
    data    <= data;
  end
end

reg     [3:0] pout;
always @ ( posedge clk or negedge nreset ) begin  //4个DFF将移位寄存器中的数据进行串转并
  if ( ~nreset ) begin
    pout    <= 4'b0000;
  end
  else if ( en && count == 2'b11) begin
    pout    <= data;  //en有效且计数器数了4次，进行一次串转并
  end
  else begin
    pout    <= pout;
  end
end
endmodule
