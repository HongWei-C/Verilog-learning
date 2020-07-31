`include "uart_defines.v"
//数据位为8位，无校验位的发送端
module uart_tx (
  sys_clk,
  rst_n,
  bps_clk_up,
  tx_ready,
  tx_data_i,
  txd
);
  parameter IDLE  = 4'd0, // 空闲位，等待接收起始位,复位后信号
            START = 4'd1, // 起始位，接收到0，准备接收有效数据
            BIT0  = 4'd2, // 发送第0位数据的状态
            BIT1  = 4'd3,
            BIT2  = 4'd4,
            BIT3  = 4'd5,
            BIT4  = 4'd6,
            BIT5  = 4'd7,
            BIT6  = 4'd8,
            BIT7  = 4'd9,// 发送第7位数据的状态
//            PAR   = 4'd10,// 奇偶校验位
            STOP  = 4'd11;// 接收完毕，停止位

  input             sys_clk;      //50MHz时钟
  input             rst_n;        //全局复位
  input             bps_clk_up;   //经过波特率分频后的时钟上升沿标志
  input             tx_ready;     //表示已经准备好下一个数据,高电平有效
  input    [7:0]    tx_data_i;    //未传送到寄存器的  待发送的数据
  output            txd;          //UART串行发送数据信号

  wire              sys_clk;
  wire              rst_n;
  wire              bps_clk_up;   //分频后时钟的上升沿，为接收数据位的                                  
                                  //中间采样点,同时也作为发送数据的数据改变点
  
  // 检测tx_ready信号处于IDLE状态的上升沿, 采用2级触发器进行采样和同步
  // 主要是为了滤除10ns~20ns以下宽度的毛刺
  // tx_ready至少要持续一个sys_clk
  // tx_ready防止一次ready发送多个数据，只有每个数据后跟一个ready才行
  wire              tx_ready;
  reg               tx_st1;
  reg               tx_st2;
  always @ (posedge sys_clk or negedge rst_n) begin
    if ( ~rst_n ) begin
      tx_st1  <= 1'b1;
      tx_st2  <= 1'b1;
    end
    else begin  
      tx_st1  <= tx_ready;
      tx_st2  <= tx_st1;
    end
  end
  wire              txd_pose;     //上升沿检测
                                  //通过tx_ready信号控制产生，持续一个周期psd_clk
  reg               tx_ok;        //处于空闲状态 IDLE
  //防止txd_pose 出现在非空闲状态
  assign  txd_pose = tx_ok ? ( tx_st1 & ~tx_st2 ) : 1'b0;
  reg               tx_start;     //接收过程启动信号  IDLE -> START
                                  //通过rxd上信号产生，持续到
                                  //下一个bps_clk上升沿
  always @ ( posedge txd_pose or posedge sys_clk or negedge rst_n) begin
    if ( ~rst_n ) begin
      tx_start    <= 1'b0;
    end
    else if ( txd_pose )
      tx_start    <= 1'b1;
    else if ( bps_clk_up )begin
      tx_start    <= 1'b0;
    end
  end


  //用状态级编写发送机
  
  wire      [7:0]   tx_data_i;    //未传送到寄存器的  待发送数据
  reg       [7:0]   tx_data_r;    //寄存器中暂存的    待发送数据
                                  //防止抖动导致数据发生变化
  reg               txd;
  reg       [3:0]   state;        //状态机更新
  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin           //复位时，复位为空闲状态
      state     <= IDLE;
      txd       <= 1'b1;
      tx_ok     <= 1'b1;          //已发送完成，等待起始信号
      tx_data_r <= 8'h00;
    end
    //状态转换
    else begin
      case ( state )
        //空闲状态 IDLE
        IDLE: begin               
          if ( tx_start && bps_clk_up ) begin     //检测到启动信号tx_start
            state     <= START;     //状态改变 IDLE -> START
            txd       <= 1'b0;      //txd为逻辑 0
            tx_ok     <= 1'b0;      //发送未完成
            tx_data_r <= tx_data_i; //装载传送过来的数据到寄存器中
          end
          else begin              
            state     <= IDLE;        //维持IDLE状态
            txd       <= 1'b1;        //txd为逻辑 1
            tx_ok     <= 1'b1;        //已发送完成，继续等待起始信号
          end
        end
        //起始状态 START
        START: begin
          if ( bps_clk_up ) begin
            state     <= BIT0;        //状态改变 START -> BIT0
            txd       <= tx_data_r[0];//tx_data_r[0]
            tx_ok     <= 1'b0;        
          end
        end
        //发送LSB BIT0
        BIT0: begin
          if ( bps_clk_up ) begin
            state     <= BIT1;        //状态改变 BIT0 -> BIT1
            txd       <= tx_data_r[1];//tx_data_r[1]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT1
        BIT1: begin
          if ( bps_clk_up ) begin
            state     <= BIT2;        //状态改变 BIT1 -> BIT2
            txd       <= tx_data_r[2];//tx_data_r[2]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT2
        BIT2: begin
          if ( bps_clk_up ) begin
            state     <= BIT3;        //状态改变 BIT2 -> BIT3
            txd       <= tx_data_r[3];//tx_data_r[3]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT3
        BIT3: begin
          if ( bps_clk_up ) begin
            state     <= BIT4;        //状态改变 BIT3 -> BIT4
            txd       <= tx_data_r[4];//tx_data_r[4]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT4
        BIT4: begin
          if ( bps_clk_up ) begin
            state     <= BIT5;        //状态改变 BIT4 -> BIT5
            txd       <= tx_data_r[5];//tx_data_r[5]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT5
        BIT5: begin
          if ( bps_clk_up ) begin
            state     <= BIT6;        //状态改变 BIT5 -> BIT6
            txd       <= tx_data_r[6];//tx_data_r[6]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT6
        BIT6: begin
          if ( bps_clk_up ) begin
            state     <= BIT7;        //状态改变 BIT6 -> BIT7
            txd       <= tx_data_r[7];//tx_data_r[7]
            tx_ok     <= 1'b0;        
          end
        end
        //BIT7
        BIT7: begin
          if ( bps_clk_up ) begin
            state     <= STOP;        //状态改变 BIT7 -> STOP
            txd       <= 1'b1;        //txd为逻辑 1
            tx_ok     <= 1'b0;          
          end
        end
        //发送停止位
        STOP: begin
          if ( bps_clk_up ) begin
            state     <= IDLE;        //状态改变 STOP -> IDLE
            txd       <= 1'b1;        //txd为逻辑 1
            tx_ok     <= 1'b1;        //已发送完成，等待起始信号
          end
        end
        default: begin                //出错则重置状态为IDLE状态
          state     <= IDLE;          //状态改变 STOP -> IDLE
          txd       <= 1'b1;          //txd为逻辑 1
          tx_ok     <= 1'b1;          //已发送完成，等待起始信号
        end
      endcase
    end
  end
endmodule
