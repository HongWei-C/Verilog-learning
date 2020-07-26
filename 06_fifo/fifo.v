//同步fifo设计
module fifo (
  wr,
  rd,
  rst_n,
  clk,
  full,
  empty,
  full_err,
  empty_err,
  datain,
  dataout
);
  input         wr;     //fifo写使能,高有效
  input         rd;     //fifo读使能,高有效
  input         rst_n;  //fifo全局复位
  input         clk;    //同步fifo时钟
  output        full;   //fifo存储空间满
  output        empty;  //fifo存储空间空
  output        full_err; //fifo写错误
  output        empty_err; //fifo读错误
  input   [7:0] datain; //fifo输入
  output  [7:0] dataout;//fifo输出

  parameter     depth         = 16;//fifo_mem深度
   
  //计算fifo_mem的已用空间,并产生读写fifo_mem地址
  reg     [4:0] cnt;        //用于计算已存储空间
  reg     [3:0] wr_addr;    //写fifo_mem的地址
  reg     [3:0] rd_addr;    //读fifo_mem的地址
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      cnt     <= 5'b0_0000;
      wr_addr <= 4'b0000;
      rd_addr <= 4'b0000;
    end
    else if ( wr && cnt != depth ) begin  //写入fifo,且未存满depth个数据
      cnt     <= cnt + 5'b0_0001;         //计数器cnt +1
      wr_addr <= wr_addr + 4'b0001;       //写fifo_addr +1
      rd_addr <= rd_addr;                 //读fifo_addr 不变
    end
    else if ( rd && cnt != 0    ) begin   //读取fifo,且fifo_mem不为空
      cnt     <= cnt - 5'b0_0001;         //计数器cnt -1
      wr_addr <= wr_addr;                 //写fifo_addr 不变
      rd_addr <= rd_addr + 4'b0001;       //读fifo_addr +1
    end
    else begin
      cnt     <= cnt;
      wr_addr <= wr_addr;
      rd_addr <= rd_addr;
    end
  end

  //fifo write 
  reg   [7:0]   fifo_mem  [0:depth-1];  
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      $readmemb ( "fifo_mem_rst.txt", fifo_mem );
    end
    else if ( wr && cnt != depth ) begin
      fifo_mem[wr_addr] <= datain;
    end
    else begin
      fifo_mem[wr_addr] <= fifo_mem[wr_addr];
    end
  end
  //fifo write control-full
  wire           full;
  assign  full  = cnt[4];   //cnt为16，empty有效
  //fifo write control-full_err
  reg           full_err;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      full_err    <= 1'b0;
    end
    else if ( wr && cnt == depth) begin
      full_err    <= 1'b1;
    end
    else begin
      full_err    <= 1'b0;
    end
  end


  //fifo read 
  reg   [7:0]   dataout;  
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      dataout     <= 8'bz;
    end
    else if ( rd && cnt != 0    ) begin
      dataout     <= fifo_mem[rd_addr];
    end
    else begin
      dataout     <= 8'bz;
    end
  end
  //fifo read control-empty
  wire           empty;
  assign  empty = !(|cnt);  //cnt为0，empty有效
  //fifo read control-empty_err
  reg           empty_err;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      empty_err    <= 1'b0;
    end
    else if ( rd && cnt == 5'b0_0000 ) begin
      empty_err    <= 1'b1;
    end
    else begin
      empty_err    <= 1'b0;
    end
  end

endmodule

