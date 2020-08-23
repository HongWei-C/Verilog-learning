`include "uart_defines.v"
module uart_ram (
  rst_n,
  sys_clk,
  rxd,
  txd
);
  
  input         rst_n;      //全局复位
  input         sys_clk;    //100MHz系统时钟
  input         rxd;        //uart--RXD 
  output        txd;        //uart--TXD

  wire          rst_n;
  wire          sys_clk;
  wire          bps_clk_up;
  wire          rxd;
  wire    [7:0] rx_data_o;
  wire          rx_idle;
  wire          rx_bits_ok;
  wire          tx_ready;
  wire    [7:0] tx_data_i;
  wire          txd;
  wire          tx_idle;
  wire          tx_bits_ok;
	wire					ram_write;
	wire		[7:0]	ram_addr;
	wire		[7:0]	ram_datain;
	wire		[7:0]	ram_dataout;

  //调用uart    
  uart_top top_to_ram (
    .rst_n      ( rst_n ),
    .sys_clk    ( sys_clk ),
    .bps_clk_up ( bps_clk_up ),
    .rxd        ( rxd ),
    .rx_data_o  ( rx_data_o ),
    .rx_idle    ( rx_idle ),
    .rx_bits_ok ( rx_bits_ok ),
    .tx_ready   ( tx_ready ),
    .tx_data_i  ( tx_data_i ),
    .txd        ( txd ),
    .tx_idle    ( tx_idle ),
    .tx_bits_ok ( tx_bits_ok )
  );

	//ram控制逻辑，给ram提供写使能，地址，数据，给uart提供tx_ready
	ram_ctrl ctrl_for_ram (
		.sys_clk		( sys_clk ),
		.rst_n			( rst_n ),
		.rx_bits_ok	( rx_bits_ok ),
		.rx_data_o	( rx_data_o ),
		.tx_ready		( tx_ready ),
		.ram_write	( ram_write ),
		.ram_addr		( ram_addr ),
		.ram_datain (	ram_datain )
	);

	//vivado ram ip核调用
  dmg_ram sram_t (
    .clk      ( sys_clk ),
    .we       ( ram_write ),
    .a        ( ram_addr ),
    .d        ( ram_datain ),
    .spo      ( ram_dataout )
  );
	//将ram读出的数据连上TXD发送
	assign  tx_data_i   = ram_dataout;
endmodule
