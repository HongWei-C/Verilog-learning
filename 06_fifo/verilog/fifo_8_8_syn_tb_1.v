`timescale  1ns / 100ps
//fifo上升沿触发，数据等等在下降沿给
module fifo_8_8_syn_tb();
  //clk 设置
  reg         clk;
  reg         rst_n;
  reg         wr;
  reg         rd;
  reg   [7:0] datain;
	
	wire        full;
  wire        full_err;
  wire        empty;
  wire        empty_err;
  wire  [7:0] dataout;
	wire	[4:0]	cnt;

	fifo_8_8_syn fifo_duf (
    .wr       ( wr ),
    .rd       ( rd ),
    .rst_n    ( rst_n ),
    .clk      ( clk ),
    .full     ( full ),
    .empty    ( empty ),
    .full_err ( full_err ),
    .empty_err( empty_err ),
    .datain   ( datain ),
    .dataout  ( dataout ),
		.cnt			( cnt )
  );

  initial begin
    $dumpfile("fifo_8_8_syn_tb_wave.vcd");
    $dumpvars;
  end

  //clk设置
  initial begin
    clk       = 1'b0; 
  end
  always #10  clk = ~clk;
	//Initial input
	initial begin
		datain		= 8'b0;
		rd				= 1'b0;
		wr				= 1'b0;
		//reset fifo
		rst_n			= 1'b1;
		@ (posedge clk);
		rst_n			= 1'b0;
		@ (posedge clk);
		rst_n			= 1'b1;
		//检查复位是否正确
		if	( ~empty ) begin
			$display("\nError at time %0t:", $time);
			$display("After reset, empty status not asserted\n");
			$stop;
		end
		if	( full ) begin
			$display("\nError at time %0t:", $time);
			$display("After reset, full status not asserted\n");
			$stop;
		end
	end
	
	reg					rw_en;				//读写有效
	reg					cycle;				//循环计数，使读数慢于写数
	reg		[7:0]	exp_data;			//读数期望值
	reg					filled_f;			//
	reg					fast_wr;
	reg					fast_rd;
	initial begin
		rw_en			= 1'b0;
		fast_wr		= 1'b1;
		fast_rd		= 1'b0;
		cycle			=	1'b0;
		exp_data	= 8'd0;
		filled_f	= 1'b0;
		repeat(10) @( posedge clk);
		rw_en			= 1'b1;
	end
	always @( negedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      cycle		= 1'b0;
    end
    else begin
      cycle		= cycle + 1'b1;
    end
	end
	//读，下降沿给读使能
	always @ ( negedge clk or negedge rst_n ) begin
		if ( ~rst_n ) begin
			rd				<= 1'b0;
			exp_data	<= 8'b0;
		end
		else if ( rw_en &&  ( fast_rd || cycle ) && ( ~empty )) begin
			rd				<= 1'b1;
			exp_data	<= exp_data + 1;
		end
		else begin
			rd				<= 1'b0;
			exp_data	<= exp_data;
		end
	end
	//读验证,下降沿验证
	always @ ( negedge clk ) begin
		if ( rw_en && rd && ( dataout != exp_data )) begin
			$display("\nError at time %0t:", $time);
			$display("Expect data_out = %h", exp_data);
			$display("Actual data out = %h", dataout);
			$stop;
		end
	end
	
	//写，下降沿给写使能
	always @ ( negedge clk or negedge rst_n ) begin
		if ( ~rst_n ) begin
			wr			<= 1'b0;
			datain	<= 8'b0;
		end
		else if ( rw_en && ( fast_wr || cycle ) && ( ~full )) begin
			wr			<= 1'b1;
			datain	<= datain + 1'b1;
		end
		else begin
			wr			<= 1'b0;
			datain	<= datain; 
		end
	end

	//仿真完成，下降沿做检测
	always @ ( negedge clk or negedge rst_n ) begin
		if (filled_f && empty ) begin
			$display ("\nSimulation complete --no errors\n");
			$stop;
		end
	end

	//分析cnt
	always @ ( cnt ) begin	
		#5;
		case ( cnt )
			5'b0 : begin
				if(~empty || full ) begin
					$display( "\nERROR at time %0t:", $time );
          $display( "fifo_cnt = %h", cnt );
          $display( "empty = %b", empty);
          $display( "full = %b\n",full);
					$stop;
				end
			end
			5'b1_0000: begin
				if ( empty || ~full) begin
					$display( "\nERROR at time %0t:", $time );
          $display( "fifo_cnt = %h", cnt );
          $display( "empty = %b", empty);
          $display( "full = %b\n",full);
					$stop;
				end
				filled_f		= 1'b1;
				fast_wr			= 1'b0;
				fast_rd			= 1'b1;
			end
			default: begin
				 if ( empty || full ) begin
          $display("\nERROR at time %0t:", $time);
          $display("fifo_count = %h", cnt);
          $display("empty = %b",empty);
          $display("full = %b\n",full);
          // Use $stop for debugging
          $stop;
        end
			end
		endcase

	end
endmodule
