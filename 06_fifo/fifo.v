//同步fifo设计
`timescale  1ns / 100ps
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
  `define       DEPTH         16   //fifo_mem深度
  `define       WIDTH         8    //fifo_mem位宽
  `define       BSIZE         4    //地址线位宽

  input                 wr;     //fifo写使能,高有效
  input                 rd;     //fifo读使能,高有效
  input                 rst_n;  //fifo全局复位
  input                 clk;    //同步fifo时钟
  output                full;   //fifo存储空间满
  output                empty;  //fifo存储空间空
  output                full_err; //fifo写错误
  output                empty_err; //fifo读错误
  input   [`WIDTH-1:0]  datain; //fifo输入
  output  [`WIDTH-1:0]  dataout;//fifo输出

   
  //计算fifo_mem的已用空间,并产生读写fifo_mem地址
  reg     [`BSIZE:0]    cnt;        //用于计算已存储空间
  reg     [`BSIZE-1:0]  wr_addr;    //写fifo_mem的地址
  reg     [`BSIZE-1:0]  rd_addr;    //读fifo_mem的地址
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      cnt     <= #1 5'b0_0000;
      wr_addr <= #1 4'b0000;
      rd_addr <= #1 4'b0000;
    end
    else if ( wr && cnt != `DEPTH ) begin   //写入fifo,且未存满`DEPTH个数据
      cnt     <= #1 cnt + 5'b0_0001;        //计数器cnt +1
      wr_addr <= #1 wr_addr + 4'b0001;      //写fifo_addr +1
      rd_addr <= #1 rd_addr;                //读fifo_addr 不变
    end
    else if ( rd && cnt != 0    ) begin     //读取fifo,且fifo_mem不为空
      cnt     <= #1 cnt - 5'b0_0001;        //计数器cnt -1
      wr_addr <= #1 wr_addr;                //写fifo_addr 不变
      rd_addr <= #1 rd_addr + 4'b0001;      //读fifo_addr +1
    end
    else begin
      cnt     <= #1 cnt;
      wr_addr <= #1 wr_addr;
      rd_addr <= #1 rd_addr;
    end
  end

  //fifo write 
  reg   [`WIDTH-1:0]   fifo_mem  [0:`DEPTH-1];  
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      $readmemb ( "fifo_mem_rst.txt", fifo_mem );
    end
    else if ( wr && cnt != `DEPTH ) begin
      fifo_mem[wr_addr] <= #1 datain;
    end
    else begin
      fifo_mem[wr_addr] <= #1 fifo_mem[wr_addr];
    end
  end
  //fifo write control-full
  wire           full;
  assign  full  = cnt[`BSIZE];   //cnt为16，empty有效
  //fifo write control-full_err
  reg           full_err;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      full_err    <= #1 1'b0;
    end
    else if ( wr && cnt == `DEPTH) begin
      full_err    <= #1 1'b1;
    end
    else begin
      full_err    <= #1 1'b0;
    end
  end


  //fifo read 
  reg   [`WIDTH-1:0]   dataout;  
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      dataout     <= #1 8'bz;
    end
    else if ( rd && cnt != 0    ) begin
      dataout     <= #1 fifo_mem[rd_addr];
    end
    else begin
      dataout     <= #1 8'bz;
    end
  end
  //fifo read control-empty
  wire           empty;
  assign  empty = !(|cnt);  //cnt为0，empty有效
  //fifo read control-empty_err
  reg           empty_err;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      empty_err    <= #1 1'b0;
    end
    else if ( rd && cnt == 5'b0_0000 ) begin
      empty_err    <= #1 1'b1;
    end
    else begin
      empty_err    <= #1 1'b0;
    end
  end

endmodule

