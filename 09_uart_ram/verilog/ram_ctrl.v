module ram_ctrl (
	sys_clk,
	rst_n,
	rx_bits_ok,
	rx_data_o,
	tx_ready,
	ram_write,
	ram_addr,
  ram_datain
);
	input						sys_clk;			//系统时钟
	input						rst_n;				//全局复位
	input						rx_bits_ok;		//接收处于stop/idle状态	
	input			[7:0]	rx_data_o;		//从RXD来的接收数据
	output					tx_ready;			//ctrl模块产生的tx_ready(自动控制)
	output					ram_write;		//ram写使能
	output		[7:0]	ram_addr;			//ram地址
	output		[7:0]	ram_datain;		//写入ram的数据
	//通过uart读写ram，可连续向uart发送数据
  reg				[2:0] state;				//状态机
  reg				[7:0] ram_command;	//从uart送过来的命令
  reg				[7:0] ram_addr_r;		//ram地址，地址存在时，会一直从dataout读出数据
  reg				[7:0] ram_datain_r;	//待写入ram的数据
  reg							ram_write_r;	//ram写使能
  reg							tx_ready_r;		//uart发出数据准备信号
  parameter   NULL    = 3'd0,
              COMD    = 3'd1,
              R_ADDR  = 3'd2,
              W_ADDR  = 3'd3,
              W_DATA  = 3'd4;
  always @ ( posedge rx_bits_ok or negedge rst_n ) begin
    //异步复位，进入STOP / IDLE阶段时触发
    if ( ~rst_n ) begin
      state         <= NULL;  //复位后处于NULL
      ram_command   <= 8'h00; //清空命令
      ram_addr_r    <= 8'h00; //清空地址
      ram_datain_r  <= 8'h00; //清空数据
      ram_write_r   <= 1'b0;  //不读
      tx_ready_r    <= 1'b0;  //不准备向TXD发数据
    end
    //状态变化
    else begin
      case ( state )
        NULL: begin   //复位后，rx_state进入IDLE，使state必然进入COMD
                      //但是接收了一个无效指令，将再次接收指令
          state         <= COMD;      //NULL -> COMD
          ram_command   <= rx_data_o; //读取RXD上来的命令
          ram_addr_r    <= 8'h00; 
          ram_datain_r  <= 8'h00; 
          ram_write_r   <= 1'b0;  
          tx_ready_r    <= 1'b0;  
        end
        //指令
        COMD: begin
          //指令为"写"，进入W_ADDR状态
          if ( ram_command == 8'b1111_0000 ) begin
            state         <= W_ADDR;      //COMD -> W_ADDR
            ram_command   <= ram_command; //保持指令
            ram_addr_r    <= rx_data_o;   //读取RXD上来的地址       
            ram_datain_r  <= 8'h00;     
            ram_write_r   <= 1'b0;  
            tx_ready_r    <= 1'b0; 
          end
          //指令为"读"，进入R_ADDR状态
          else if ( ram_command == 8'b0000_1111 ) begin
            state         <= R_ADDR;      //COMD -> W_ADDR
            ram_command   <= ram_command; //保持指令
            ram_addr_r    <= rx_data_o;   //读取RXD上来的地址       
            ram_datain_r  <= 8'h00;     
            ram_write_r   <= 1'b0;  
            tx_ready_r    <= 1'b1; 
          end
          //错误指令，继续等待指令
          else begin
            state         <= COMD;      //COMD -> COMD
            ram_command   <= rx_data_o; //读取RXD上来的命令
            ram_addr_r    <= 8'h00; 
            ram_datain_r  <= 8'h00; 
            ram_write_r   <= 1'b0;  
            tx_ready_r    <= 1'b0; 
          end
        end
        //读，地址
        R_ADDR: begin
          state         <= COMD;      //R_ADDR -> COMD
          ram_command   <= rx_data_o; //读取RXD上来的命令
          ram_addr_r    <= 8'h00; 
          ram_datain_r  <= 8'h00; 
          ram_write_r   <= 1'b0;  
          tx_ready_r    <= 1'b0; 
        end
        //写，地址
        W_ADDR: begin
          state         <= W_DATA;      //R_ADDR -> W_DATA
          ram_command   <= ram_command; 
          ram_addr_r    <= ram_addr_r;  
          ram_datain_r  <= rx_data_o;   //读取RXD上来的数据
          ram_write_r   <= 1'b1;        //ram写使能拉高
          tx_ready_r    <= 1'b0; 
        end
        //写，数据
        W_DATA: begin
          state         <= COMD;      //R_ADDR -> COMD
          ram_command   <= rx_data_o; //读取RXD上来的命令
          ram_addr_r    <= 8'h00; 
          ram_datain_r  <= 8'h00; 
          ram_write_r   <= 1'b0;  
          tx_ready_r    <= 1'b0; 
        end
        //错误状态，重启到NULL等待下一个指令
        default: begin
          state         <= NULL;      
          ram_command   <= 8'h00;     //读取RXD上来的命令
          ram_addr_r    <= 8'h00; 
          ram_datain_r  <= 8'h00; 
          ram_write_r   <= 1'b0;  
          tx_ready_r    <= 1'b0;
        end
      endcase
    end
  end

  parameter	en_dly = 3;											//用于控制en使能信号相对于数据的延迟(en_dly个sys_clk)
  reg			[en_dly-1:0]	tx_ready_r1;        //uart发送信号节拍延迟
	reg			[en_dly-1:0]	ram_write_r1;       //ram写信号节拍延迟
  always @ ( negedge sys_clk or negedge rst_n ) begin //在下降沿生成使能，使能上升沿能采到稳定的使能信号
    if ( ~rst_n ) begin
			tx_ready_r1   <= {en_dly{1'b0}};
			ram_write_r1  <= {en_dly{1'b0}};
    end
    else begin											//2个sys_clk的节拍延迟
			tx_ready_r1   <= { tx_ready_r , tx_ready_r1[en_dly-1:1] };	//使tx_ready相对于tx_data_in延迟出现
      ram_write_r1  <= { ram_write_r , ram_write_r1[en_dly-1:1] };	//使ram_write相对于ram_datain延迟出现
		end
  end

  wire          ram_write;					//写数据使能(连接ram)
  wire    [7:0] ram_addr;						//ram地址线(连接ram)
  wire    [7:0] ram_datain;					//ram写数据线(连接ram)
  wire    [7:0] ram_dataout;				//ram读数据线(连接ram)
  //将节拍延迟的发送数据准备信号连上,保持一个sys_clk
  assign  tx_ready    = tx_ready_r1[1]	& ~tx_ready_r1[0];	//保证仅一次sys_clk周期有效，防止多次写入
  assign  ram_write   = ram_write_r1[1]	& ~ram_write_r1[0];	//
  assign  ram_addr    = ram_addr_r;
  assign  ram_datain  = ram_datain_r;

endmodule
