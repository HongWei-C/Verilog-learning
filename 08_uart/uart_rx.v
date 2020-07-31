`include "uart_defines.v"

module uart_rx (
  sys_clk,
  rst_n,
  bps_clk_up,
  rx_data_o,
  rxd
);
  parameter IDLE  = 4'd0, // 空闲位，等待接收起始位,复位后信号
            START = 4'd1, // 起始位，接收到0，准备接收有效数据
            BIT0  = 4'd2, // 接收第0位数据的状态
            BIT1  = 4'd3,
            BIT2  = 4'd4,
            BIT3  = 4'd5,
            BIT4  = 4'd6,
            BIT5  = 4'd7,
            BIT6  = 4'd8,
            BIT7  = 4'd9, // 接收第7位数据的状态
//            PAR   = 4'd10,// 奇偶校验位
            STOP  = 4'd11;// 接收完毕，停止位

  input             sys_clk;      //100MHz时钟
  input             rst_n;        //全局复位
  input             bps_clk_up;   //经过波特率分频后的时钟上升沿标志
  output    [7:0]   rx_data_o;    //从寄存器传送出来的  接收数据
  input             rxd;          //UART串行接收数据信号
  
  // 检测rxd信号的下降沿,并改善脉冲的持续时间
  reg               rxd_d;
  always @(posedge sys_clk or negedge rst_n) begin
    if ( ~rst_n ) begin
        rxd_d  <= 1'b1;
    end
    else begin
        rxd_d  <= rxd;
    end
  end
  wire              rxd_neg;      //下降沿脉冲，持续一个sys_clk
  reg               rx_start;     //接收过程启动信号  IDLE -> START
                                  //通过rxd上信号产生，持续到
                                  //下一个bps_clk上升沿
  reg               rx_ok;        //接收过程完成      处于IDLE状态
  //防止在非空闲状态产生rx_start信号
  assign rxd_neg = rx_ok ? ( rxd_d & ~rxd ) : 1'b0;
  always @ ( posedge rxd_neg or posedge sys_clk or negedge rst_n) begin
    if ( ~rst_n ) begin
      rx_start    <= 1'b0;
    end
    else if ( rxd_neg )
      rx_start    <= 1'b1;
    else if ( bps_clk_up )begin
      rx_start    <= 1'b0;
    end
  end

  
  wire              sys_clk;
  wire              rst_n;
  wire              rxd;
  wire              bps_clk_up;
  //用状态机编写接收机
  reg       [7:0]   rx_shift_r;   //接收数据移位寄存器
  reg       [7:0]   rx_data_o;    //接收数据寄存器
  reg       [3:0]   state;        //状态机更新
  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin           //复位时，复位为空闲状态
      state       <= IDLE;
      rx_shift_r  <= 8'h00;
      rx_data_o   <= 8'h00;
      rx_ok       <= 1'b1;        //已接收完成，等待下一个起始信号
    end
    //状态转换
    else begin
      case ( state )
        //空闲状态 IDLE
        IDLE: begin
          if ( rx_start && bps_clk_up ) begin       //检测到启动信号rx_start
            state     <= START;       //状态改变 IDLE -> START
            rx_ok     <= 1'b0;        //接收未完成
          end
          else begin
            state       <= IDLE;      //继续维持IDLE状态
            rx_shift_r  <= 8'h00;     //接收数据移位寄存器复位
            rx_data_o   <= rx_data_o; //接收数据寄存器保持
            rx_ok       <= 1'b1;      //已接收完成，等待下一个起始信号
          end
        end
        //起始状态 START
        START: begin
          if ( bps_clk_up ) begin
            state       <= BIT0;      //状态改变 START -> BIT0
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //接收LSB BIT0
        BIT0: begin
          if ( bps_clk_up ) begin
            state       <= BIT1;      //状态改变 BIT0 -> BIT1
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //BIT1
        BIT1: begin
          if ( bps_clk_up ) begin
            state       <= BIT2;      //状态改变 BIT1 -> BIT2
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //BIT2
        BIT2: begin
          if ( bps_clk_up ) begin
            state       <= BIT3;      //状态改变 BIT2 -> BIT3
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //BIT3
        BIT3: begin
          if ( bps_clk_up ) begin
            state       <= BIT4;      //状态改变 BIT3 -> BIT4
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //BIT4
        BIT4: begin
          if ( bps_clk_up ) begin
            state       <= BIT5;      //状态改变 BIT4 -> BIT5
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //BIT5
        BIT5: begin
          if ( bps_clk_up ) begin
            state       <= BIT6;      //状态改变 BIT5 -> BIT6
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //BIT6
        BIT6: begin
          if ( bps_clk_up ) begin
            state       <= BIT7;      //状态改变 BIT6 -> BIT7
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //接收MSB BIT7
        BIT7: begin
          if ( bps_clk_up ) begin
            state       <= STOP;      //状改变 BIT7 -> STOP
            rx_data_o   <= rx_shift_r;//将移位寄存器中的数据传输到寄存器中
            rx_ok       <= 1'b0;      //接收未完成
          end
        end
        //接收停止位
        STOP: begin
           if ( bps_clk_up ) begin
            state       <= IDLE;      //状态改变 STOP -> IDLE
            rx_shift_r  <= 8'h00;     //接收数据移位寄存器复位
            rx_data_o   <= rx_data_o; //接收数据寄存器保持            
            rx_ok       <= 1'b1;      //已接收完成，等待下一个起始信号
          end
        end
        default: begin                //出错直接重置为IDLE状态
          state       <= STOP;        //状态改变 STOP -> IDLE
          rx_shift_r  <= 8'h00;       //接收数据移位寄存器复位
          rx_data_o   <= rx_data_o;   //接收数据寄存器保持            
          rx_ok       <= 1'b1;        //已接收完成，等待下一个起始信号
        end
      endcase
    end
  end
endmodule
