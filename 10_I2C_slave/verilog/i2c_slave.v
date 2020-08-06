`include "i2c_defines.v"

module i2c_slave (
  rst_n,
  sys_clk,
  sda_data_in,
  sda_data_out,
  sda_en,
  scl,
  sda
);
  parameter device_addr = 7'b1111_010;
  input           rst_n;        //全局复位
  input           sys_clk;      //系统时钟 100MHz
  input   [7:0]   sda_data_in;  //待从机发送的数据
  output  [7:0]   sda_data_out; //从机收到的数据
  output          sda_en;
  input           scl;          //i2c时钟线
  inout           sda;          //i2c数据线

  
  //调用分频模块
  wire          bps_clk_up;     //9600波特率的时钟上升沿信号
  wire          div_clk_up;     //2倍频
  i2c_div_clk twice_dps (
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up ),
    .div_clk_up ( div_clk_up )  //2倍于bps_clk_up
  );

  //对inout线进行拆分重组
  reg             sda_en;       //从机占用总线使能
  reg             sda_r;        //从机占用sda时的电平状态
  reg             sda_out;      //从机发送的sda
 
  wire            sda_in;
 
  assign sda_in = sda;          //从主机传送过来的sda信号
  //从机占用sda逻辑
  always @ ( sda_en or sda_out ) begin
    if ( sda_en )
      sda_r <= sda_out;
    else              //不占用时sda高阻态
      sda_r <= 1'bZ;
  end
  //将占用时的电平状态连到 sda 上
  assign sda  = sda_r;
  
  //延迟与同步，延迟1-2拍sys_clk
  reg   [1:0]     sda_d;
  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      sda_d   <= 3'b111;
    end
    else begin
      sda_d   <= { sda_d[0] , sda_in };
    end
  end
  //检测sda下降沿，产生sda_start信号
  wire            sda_nege;     //下降沿脉冲，持续一个sys_clk
  reg             sda_start;    //启动信号  IDLE->START / ACK->START
                                //通过sda产生，持续到下一个bps_clk的上升沿
  assign  sda_nege  = scl ? ( sda_d[1] & ~sda_in ) : 1'b0;
  always @ ( posedge sda_nege or posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      sda_start   <= 1'b0;
    end
    else if ( sda_nege ) begin
      sda_start   <= 1'b1;
    end
    else if ( bps_clk_up )begin
      sda_start   <= 1'b0;
    end
    else begin
      sda_start   <= sda_start;
    end
  end
  //检测sda上升沿，产生sda_stop信号
  wire            sda_pose;     //上升沿脉冲，持续一个sys_clk
  reg             sda_stop;     //启动信号  NACK->STOP
                                //通过sda产生，持续到下一个bps_clk的上升沿
  assign  sda_pose  = scl ? ( ~sda_d[1] & sda_in ) : 1'b0;
  always @ ( posedge sda_pose or posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      sda_stop    <= 1'b0;
    end
    else if ( sda_pose ) begin
      sda_stop    <= 1'b1;
    end
    else if ( bps_clk_up ) begin
      sda_stop    <= 1'b0;
    end
    else begin
      sda_stop    <= sda_stop;
    end
  end
  //slave状态机
  //数两个div_clk就是一个bps_clk,或一个scl周期
  parameter NULL      = 5'd0,
            IDLE      = 5'd1,
            START     = 5'd2,
            DEV_ADDR  = 5'd3,
            ACK       = 5'd4,
            NACK      = 5'd5,
            NWAIT     = 5'd6,
            W_WAIT    = 5'd7,
            W_DATA    = 5'd8,
            W_ACK     = 5'd9,
            R_WAIT    = 5'd10,
            R_DATA    = 5'd11,
            R_NULL    = 5'd12,
            R_NACK    = 5'd13,
            R_NWAIT   = 5'd14,
            R_ACK     = 5'd15,
            STOP      = 5'd16;

  reg   [3:0]   state;        //状态机
  reg   [2:0]   R_wait_cnt;   //进入R_wait状态后的计时计数器
  reg   [2:0]   data_cnt;     //sda的数据收发计数器
  reg   [7:0]   sda_data_r;   //从sda收到的8bits数据
  reg           wr;           //读写标志寄存器
  reg   [7:0]   sda_data_out; //从机收到的数据
  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      state   <= NULL;
    end
    else if ( bps_clk_up && sda_start ) begin
      state   <= START;
    end
    else if ( bps_clk_up && sda_stop ) begin
      state   <= STOP;
    end
    else
    case ( state ) 
      NULL: begin
        if ( div_clk_up ) begin
          state   <= IDLE;
        end
      end
      IDLE: begin
        if ( bps_clk_up && sda_start ) begin
          state   <= START;
        end
      end
      START: begin
        if ( div_clk_up && scl )
          state   <= DEV_ADDR;
      end
      DEV_ADDR: begin
        if ( div_clk_up ) begin
          if ( ~scl && &data_cnt ) begin
            if ( sda_data_r[7:1] == device_addr ) begin
              state   <= ACK;
            end
            else  begin
              state   <= NACK;
            end
          end
          else if ( scl && !(&data_cnt) ) begin
            state   <= DEV_ADDR;
          end
        end
      end
      ACK: begin
        if ( div_clk_up && ~scl ) begin
          if( wr ) begin
            state   <= R_WAIT;
          end
          else begin
            state   <= W_WAIT;
          end
        end
      end
      NACK: begin
        if ( div_clk_up && ~scl ) begin
          state   <= NWAIT;
        end
      end
      NWAIT: begin
        if ( bps_clk_up && sda_stop ) begin
          state   <= STOP;
        end
      end
      W_WAIT: begin//?????
        if ( bps_clk_up ) begin
          if( sda_start ) begin
            state   <= START;
          end
          else if ( sda_stop ) begin
            state   <= STOP;
          end
        end    
        else if ( div_clk_up && scl ) begin
          state   <= W_DATA;
        end
      end
      W_DATA: begin
        if ( div_clk_up ) begin
          if ( ~scl && &data_cnt ) begin
            state   <= W_ACK;
          end
          else if ( scl && !(&data_cnt) ) begin
            state   <= W_DATA;
          end
        end
      end
      W_ACK: begin
        if ( div_clk_up && ~scl ) begin
          state   <= W_WAIT;
        end
      end
      R_WAIT: begin//?????
        if ( div_clk_up && ~scl ) begin
          if ( &R_wait_cnt ) begin
            state   <= R_DATA;
          end 
          else begin
            state   <= R_WAIT;
          end
        end
      end
      R_DATA: begin
        if ( div_clk_up && ~scl ) begin
          if ( &data_cnt ) begin
            state   <= R_NULL;
          end
          else begin
            state   <= R_DATA;
          end
        end
      end
      R_NULL: begin
        if ( div_clk_up && scl ) begin
          if ( sda_in ) begin
            state   <= R_NACK;
          end
          else begin
            state   <= R_ACK;
          end
        end
      end
      R_ACK: begin
        if (div_clk_up && ~scl ) begin
          state   <= R_WAIT;
        end
      end
      R_NACK: begin
        if ( div_clk_up && ~scl ) begin
          state   <= R_NWAIT;
        end
      end
      R_NWAIT: begin
        if ( bps_clk_up && sda_stop ) begin
          state   <= STOP;
        end
      end
      STOP: begin
        if ( bps_clk_up ) begin
          state   <= IDLE;
        end
      end
      default: begin
        state   <=  NULL;
      end
    endcase 
  end
  

  //计数器的变化
  always @ ( posedge sys_clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      R_wait_cnt  <= 3'b0;
      data_cnt    <= 3'b0;
    end
    else begin
      case ( state ) 
        DEV_ADDR,W_DATA: begin
          if ( div_clk_up && scl ) begin
            data_cnt    <= data_cnt + 3'b1;
          end
        end
        R_DATA: begin
          if ( div_clk_up && ~scl ) begin
            data_cnt    <= data_cnt + 3'b1;
          end
        end
        R_WAIT: begin
          if ( div_clk_up ) begin
            R_wait_cnt  <= R_wait_cnt + 3'b1;
          end
        end
        default: begin
          data_cnt    <=  3'b0;
          R_wait_cnt  <=  3'b0;
        end
      endcase
    end
  end
  always @ ( rst_n or state or data_cnt or R_wait_cnt ) begin
    if ( ~rst_n ) begin
      sda_data_r    = 8'b0;
      sda_data_out  = 8'h00;
      wr            = 1'b0;
      sda_en        = 1'b0;
      sda_out       = 1'b1;
    end
    else begin
      case ( state ) 
        NULL: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        START: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        DEV_ADDR: begin
          sda_data_r    = { sda_data_r[6:0] , sda_in };
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        ACK: begin
          sda_data_r    = sda_data_r;
          sda_data_out  = sda_data_r;
          wr            = sda_data_r[0];
          sda_en        = 1'b1;
          sda_out       = 1'b0;
        end
        NACK: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end 
        NWAIT: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        W_WAIT: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        W_DATA: begin
          sda_data_r    = { sda_data_r[6:0] , sda_in };
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        W_ACK: begin
          sda_data_r    = sda_data_r;
          sda_data_out  = sda_data_r;
          wr            = 1'b0;
          sda_en        = 1'b1;
          sda_out       = 1'b0;
        end
        R_WAIT: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        R_DATA: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b1;
          sda_out       = sda_data_in[7-data_cnt];
        end
        R_NULL: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        R_ACK: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        R_NACK: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        R_NWAIT: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
        STOP: begin
          sda_data_r    = 8'b0;
          wr            = 1'b0;
          sda_en        = 1'b0;
          sda_out       = 1'b1;
        end
      endcase
    end
  end
endmodule
