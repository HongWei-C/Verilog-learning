`include "uart_defines.v"

module uart_rx (
  rst_n,
  sys_clk,
  bps_clk_up_16x,
  rxd,
  rx_data_o,
  rx_idle,
  rx_bits_ok
);
 
  input           rst_n;        //全局复位
  input           sys_clk;      //100MHz系统时钟
  output          bps_clk_up_16x;   //经波特率分频再16倍频后的时钟上升沿标志
  input           rxd;          //UART  RXD端
  output    [7:0] rx_data_o;    //从RXD端获取经过串转并的并行数据
  output          rx_idle;      //RXD端处于IDLE状态，高电平
  output          rx_bits_ok;   //RXD端处于STOP状态或者IDLE状态


  wire            rst_n;
  wire            sys_clk;
  wire            bps_clk_up_16x;

	wire            rxd;
  wire            rxd_nege;     //下降沿脉冲，持续一个sys_clk
  reg             rx_start;     //接收过程启动信号  IDLE->START / STOP->START
                                //通过RXD产生，持续到下一个bps_clk的上升沿
  reg             rx_bits_ok;   //当前处于STOP / IDLE

	reg				[3:0]	cnt_16x;			//bps_clk_up_16x计数器
	wire						cnt_16x_f;		//数到15的标志
	//产生uart_rx的16倍频时钟 bps_clk_16x
	uart_baud	#(
		.fre_mul		(16)
	)
	baud_rx
	( 
		.sys_clk		(sys_clk),          
		.rst_n			(rst_n),            
		.bps_clk_up	(bps_clk_up_16x)             
	);

  //计数到15才进入下一个状态，保证接收端采样点近似位于数据中心
	always @ (posedge sys_clk or negedge rst_n ) begin
		if ( ~rst_n ) begin
			cnt_16x	<= 4'd7;
		end
		else if ( bps_clk_up_16x ) begin
			if ( rx_bits_ok & ~rx_start ) begin
				cnt_16x	<= 4'd7;
			end
			else begin
				cnt_16x	<= cnt_16x + 4'd1;
			end
		end
	end
	//cnt_16x_f表示cnt_16x数到了15，初始状态为7(即，过了半个bps_clk周期)
	assign			cnt_16x_f	= &cnt_16x;


	 //检测RXD串行信号的下降沿(即检测起始信号)，并改善脉冲的持续时间
	 //两级延迟，滤除小毛刺
	parameter					rx_dly = 1;		//最小为1,控制rx_start延迟产生时间
	reg		[rx_dly:0]	rxd_d;				//rx_dly个sys_clk
	always @ ( negedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      rxd_d <= { (rx_dly+1) {1'b1}};
    end
    else begin
      rxd_d <=  { rxd , rxd_d[rx_dly:1] };
    end
  end
  //防止在START或BITx等未接收完的状态下产生rx_start信号
	//同时，产生一个稳定的可以用于接收的rx_start信号
  assign  rxd_nege  = rx_bits_ok ? ( rxd_d[0] & ~rxd_d[1] ) : 1'b0;
  always @ ( posedge rxd_nege or negedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      rx_start    <= 1'b0;
    end
    else if ( rxd_nege ) begin
      rx_start    <= 1'b1;				//RXD下降沿拉高rx_start
    end
    else if ( ~(|cnt_16x) ) begin	//cnt_16x数到0才释放rx_start
      rx_start    <= 1'b0;				//使其持续时间略大于半个bps_clk周期
    end
    else begin
      rx_start    <= rx_start;
    end
  end
  
  //用状态机编写接收机
  reg     [7:0]   rx_shift_r;   //接收机有效数据移位寄存器
  reg     [7:0]   rx_data_o;    //接收数据寄存器
  reg     [3:0]   state;        //状态机更新
  reg             rx_idle;			//当前处于idle状态
  reg             rx_bit_ok;		//当前处于stop/idle状态
	parameter NULL  = 4'd0,       // 复位后状态
            IDLE  = 4'd1,       // 空闲位，等待接收起始位,复位后信号
            START = 4'd2,       // 起始位，接收到0，准备接收有效数据
            BIT0  = 4'd3,       // 接收第0位数据的状态
            BIT1  = 4'd4,
            BIT2  = 4'd5,
            BIT3  = 4'd6,
            BIT4  = 4'd7,
            BIT5  = 4'd8,
            BIT6  = 4'd9,
            BIT7  = 4'd10,       // 接收第7位数据的状态
//            PAR   = 4'd11,      // 奇偶校验位
            STOP  = 4'd12;      // 接收完毕，停止位

  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin         //复位
      state       <= NULL;
      rx_shift_r  <= 8'h00;
      rx_data_o   <= 8'h00;
      rx_idle     <= 1'b1;
      rx_bits_ok  <= 1'b1;
    end
    //状态装换
    else begin
      case ( state )
        //复位状态 NULL
        NULL: begin
          if ( bps_clk_up_16x ) begin
            state       <= IDLE;      //  IDLE -> IDLE
            rx_shift_r  <= 8'h00;     //  清除上一次非连续接收后的有效数据
            rx_data_o   <= rx_data_o; //  保持上一次接收的有效数据
            rx_idle     <= 1'b1;      //  进入IDLE状态
            rx_bits_ok  <= 1'b1;      //  进入STOP / IDLE状态
          end
        end
        //空闲状态 IDLE
        IDLE: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            if( rx_start ) begin				//在rxd稳定位置(中心)检测到启动信号rx_start
              state       <= START;     //  IDLE -> START
              rx_shift_r  <= 8'h00;     //  清除上一次连续接收后的有效数据
              rx_data_o   <= rx_data_o; //  保持上一次接收的有效数据
              rx_idle     <= 1'b0;      //  进入非IDLE状态
              rx_bits_ok  <= 1'b0;      //  进入非STOP / IDLE状态
            end
            else begin                  //否则，继续保持IDLE状态  
              state       <= IDLE;      //  IDLE -> IDLE
              rx_shift_r  <= 8'h00;     //  清除上一次非连续接收后的有效数据
              rx_data_o   <= rx_data_o; //  保持上一次接收的有效数据
              rx_idle     <= 1'b1;      //  进入IDLE状态
              rx_bits_ok  <= 1'b1;      //  进入STOP / IDLE状态
            end
          end
        end
        //起始状态 START
        START: begin
          if ( bps_clk_up_16x  && cnt_16x_f ) begin
            state       <= BIT0;      //  START -> BIT0
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      //  进入非IDLE状态
            rx_bits_ok  <= 1'b0;      //  进入非STOP / IDLE状态
          end
        end
        //接收LSB BIT0
        BIT0: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT1;      //  BIT0 -> BIT1
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //BIT1
        BIT1: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT2;      //  BIT1 -> BIT2
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //BIT2
        BIT2: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT3;      //  BIT2 -> BIT3
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //BIT3
        BIT3: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT4;      //  BIT3 -> BIT4
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //BIT4
        BIT4: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT5;      //  BIT4 -> BIT5
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //BIT5
        BIT5: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT6;      //  BIT5 -> BIT6
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //BIT6
        BIT6: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= BIT7;      //  BIT6 -> BIT7
            rx_shift_r  <= { rxd , rx_shift_r[7:1] };      
            rx_data_o   <= rx_data_o; 
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b0;      
          end
        end
        //接收MSB BIT7
        BIT7: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            state       <= STOP;      //  BIT7 -> STOP
            rx_shift_r  <= rx_shift_r;//  移位寄存器保持
            rx_data_o   <= rx_shift_r;//  RXD串转并
            rx_idle     <= 1'b0;      
            rx_bits_ok  <= 1'b1;      //进入STOP状态   
          end
        end
        //接收停止位 STOP
        STOP: begin
          if ( bps_clk_up_16x && cnt_16x_f ) begin
            if( rx_start ) begin        //  检测到连续多位信号待接收
              state       <= START;     //  STOP -> START
              rx_shift_r  <= 8'h00;     //  清除上一次连续接收后的有效数据
              rx_data_o   <= rx_data_o; //  保持上一次接收的有效数据
              rx_idle     <= 1'b0;      
              rx_bits_ok  <= 1'b0;      //  进入非STOP / IDLE状态
            end
            else begin                  //  本次为单次输入
              state       <= IDLE;      //  STOP -> IDLE
              rx_shift_r  <= 8'h00;     //  清除上一次非连续接收后的有效数据
              rx_data_o   <= rx_data_o; //  保持上一次接收的有效数据
              rx_idle     <= 1'b1;      //  进入IDLE状态
              rx_bits_ok  <= 1'b1;      
            end
          end
        end
        default: begin                  //状态错误，重置为NULL状态
          state       <= NULL;         
          rx_shift_r  <= 8'h00;         
          rx_data_o   <= 8'h00;    
          rx_idle     <= 1'b1;      
          rx_bits_ok  <= 1'b1;          
        end
      endcase
    end
  end
endmodule
