`include "uart_defines.v"

module uart_baud ( 
  sys_clk,          //系统时钟，100MHz
  rst_n,            //全局复位，低电平有效
  bps_clk_up        //由波特率产生的分频后时钟的上升沿标志
);
  //100MHz 系统时钟,利用波特率进行分频
  parameter cnt_max   = `SYS_CLOCK / `BAUDRATE; //计算分频系数
  parameter cnt_half  = (cnt_max / 2) ;
  input         sys_clk;
  input         rst_n;
  output        bps_clk_up;
  wire          sys_clk;
  wire          rst_n;

  reg     [9:0] cnt;  //分频计数
  reg           bps_clk_up;
  always @ ( posedge sys_clk or negedge rst_n) begin
    if ( ~rst_n ) begin
      bps_clk_up    <= 1'b0;
      cnt           <= 10'd0;
    end
    else if ( cnt == ( cnt_half - 1 )) begin
      bps_clk_up    <= 1'b1;
      cnt           <= cnt + 10'd1;
    end
    else if ( cnt == ( cnt_max - 1 )) begin
      bps_clk_up    <= 1'b0;
      cnt           <= 10'd0;
    end
    else begin
      bps_clk_up    <= 1'b0;
      cnt           <= cnt + 13'd1;
    end
  end
endmodule
