`include "uart_defines.v"
//数据位为8位，无校验位的发送端
module uart_tx (
  rst_n,
  sys_clk,
  bps_clk_up,
  tx_ready,
  tx_data_i,
  txd,
  tx_idle,
  tx_bits_ok
);
  
  input           rst_n;      //全局复位
  input           sys_clk;    //100MHz系统时钟
  output          bps_clk_up; //经过比特率分频后时钟的上升沿标志
  input           tx_ready;   //表示待发送的数据已经准备好了
  input     [7:0] tx_data_i;  //未传送到寄存器的待发送数据
  output          txd;        //uart的TXD端
  output          tx_idle;    //发送端处于IDLE状态
  output          tx_bits_ok; //发送端处于STOP / IDLE 状态

  //利用外部传入的tx_ready产生tx_start信号，且tx_start只会出现在STOP/IDLE状态
  wire            rst_n;
  wire            sys_clk;
  wire            bps_clk_up;

	//波特率1x倍频
	uart_baud	#(
		.fre_mul		(1)
	)
	baud_tx
	( 
		.sys_clk		(sys_clk),          
		.rst_n			(rst_n),            
		.bps_clk_up	(bps_clk_up)             
	);

	//滤除无效的tx_ready信号,非stop/idle状态下的ready信号
  wire            tx_ready;
  wire            tx_ready_u;   //tx_ready的有效信号
  reg             tx_start;			//发送启动信号，持续到下一个bps_clk上升沿
  assign  tx_ready_u  = tx_bits_ok ? tx_ready : 1'b0;//tx_ready只有在stop/idle状态下才真正有效
  always @ ( posedge tx_ready_u or posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      tx_start  <= 1'b0;
    end
    else if ( tx_ready_u ) begin
      tx_start  <= 1'b1;      //tx_ready的有效信号
    end
    else if ( bps_clk_up ) begin
      tx_start  <= 1'b0;      //直到下一个bps_clk_up下升沿前
    end												//bps_clk_up由sys_clk产生，持续一个sys_clk周期
    else begin								//故，前一个sys_clk_up对应bps_clk上升沿前，
      tx_start  <= tx_start;	//后一个sys_clk_up对应bps_clk下降沿前
    end
  end
  
  //用状态机编写发送机
  wire    [7:0] tx_data_i;    //未传送到寄存器的  待发送数据  
  reg     [7:0] tx_data_r;    //寄存器中暂存的    待发送数据
                              //防止抖动导致数据发送变化
  reg           txd;
  reg     [3:0] state;				//状态
  reg           tx_idle;			//当前处于idle状态	
  reg           tx_bits_ok;		//当前处于stop/idle状态
	parameter NULL  = 4'd0,			// 复位状态NULL
            IDLE  = 4'd1,			// 空闲位，等待接收起始位,复位后信号
            START = 4'd2,			// 起始位，接收到0，准备接收有效数据
            BIT0  = 4'd3,			// 发送第0位数据的状态
            BIT1  = 4'd4,
            BIT2  = 4'd5,
            BIT3  = 4'd6,
            BIT4  = 4'd7,
            BIT5  = 4'd8,
            BIT6  = 4'd9,
            BIT7  = 4'd10,		// 发送第7位数据的状态
//            PAR   = 4'd11,  // 奇偶校验位
            STOP  = 4'd12;    // 接收完毕，停止位
  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      state       <= NULL;
      txd         <= 1'b1;
      tx_data_r   <= 8'h00;
      tx_idle     <= 1'b0;
      tx_bits_ok  <= 1'b0;
    end
    //状态转换
    else begin
      case ( state )
        //复位状态
        NULL: begin
          if ( bps_clk_up ) begin
            state       <= IDLE;        //NULL -> IDLE
            txd         <= 1'b1;        //TXD拉高
            tx_data_r   <= 8'h00;       //带发送数据寄存器清空
            tx_idle     <= 1'b1;        //进入IDLE状态
            tx_bits_ok  <= 1'b1;        //进入IDLE / STOP状态
          end
        end
        IDLE: begin
          if ( bps_clk_up ) begin
            if ( tx_start) begin        //tx_start有效
              state       <= START;     //IDLE -> START
              txd         <= 1'b0;
              tx_data_r   <= tx_data_i; //将待传输数据放入寄存器
              tx_idle     <= 1'b0;      //进入非IDLE状态
              tx_bits_ok  <= 1'b0;      //进入非IDLE / STOP状态
            end
            else begin                    
              state       <= IDLE;      //NULL -> IDLE
              txd         <= 1'b1;      //TXD拉高
              tx_data_r   <= 8'h00;     //待发送数据寄存器清空
              tx_idle     <= 1'b1;      //进入IDLE状态
              tx_bits_ok  <= 1'b1;      //进入IDLE / STOP状态
            end
          end
        end
        START: begin
          if ( bps_clk_up ) begin
            state       <= BIT0;        //START -> BIT0
            txd         <= tx_data_r[0];
            tx_data_r   <= tx_data_r;   //tx_data_r保持
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //发送LSB BIT0
        BIT0: begin
          if ( bps_clk_up ) begin
            state       <= BIT1;        //BIT0 -> BIT1
            txd         <= tx_data_r[1];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //BIT1
        BIT1: begin
          if ( bps_clk_up ) begin
            state       <= BIT2;        //BIT1 -> BIT2
            txd         <= tx_data_r[2];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //BIT2
        BIT2: begin
          if ( bps_clk_up ) begin
            state       <= BIT3;        //BIT2 -> BIT3
            txd         <= tx_data_r[3];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //BIT3
        BIT3: begin
          if ( bps_clk_up ) begin
            state       <= BIT4;        //BIT3 -> BIT4
            txd         <= tx_data_r[4];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //BIT4
        BIT4: begin
          if ( bps_clk_up ) begin
            state       <= BIT5;        //BIT4 -> BIT5
            txd         <= tx_data_r[5];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //BIT5
        BIT5: begin
          if ( bps_clk_up ) begin
            state       <= BIT6;        //BIT5 -> BIT6
            txd         <= tx_data_r[6];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //BIT6
        BIT6: begin
          if ( bps_clk_up ) begin
            state       <= BIT7;        //BIT6 -> BIT7
            txd         <= tx_data_r[7];
            tx_data_r   <= tx_data_r;
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b0;
          end
        end
        //发送MSB BIT7
        BIT7: begin
          if ( bps_clk_up ) begin
            state       <= STOP;        //BIT7 -> STOP
            txd         <= 1'b1;        //TXD拉高
            tx_data_r   <= 8'h00;       //发送结束，清空发送数据寄存器
            tx_idle     <= 1'b0;
            tx_bits_ok  <= 1'b1;        //进入STOP / IDLE状态
          end
        end
        //发送停止位
        STOP: begin
          if ( bps_clk_up ) begin
            if ( tx_start) begin        //tx_start有效,连续发送数据
              state       <= START;     //STOP -> START
              txd         <= 1'b0;
              tx_data_r   <= tx_data_i; //将待传输数据放入寄存器
              tx_idle     <= 1'b0;      //进入非IDLE状态
              tx_bits_ok  <= 1'b0;      //进入非IDLE / STOP状态
            end
            else begin                    
              state       <= IDLE;      //STOP -> IDLE，非连续发送数据
              txd         <= 1'b1;      //TXD拉高
              tx_data_r   <= 8'h00;     //待发送数据寄存器清空
              tx_idle     <= 1'b1;      //进入IDLE状态
              tx_bits_ok  <= 1'b1;      //进入IDLE / STOP状态
            end
          end
        end
        default: begin
          state       <= NULL;
          txd         <= 1'b1;
          tx_data_r   <= 8'h00;
          tx_idle     <= 1'b0;
          tx_bits_ok  <= 1'b0;
        end
      endcase
    end
  end
endmodule

