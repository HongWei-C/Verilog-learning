module fifo_tb ();
  //clk 设置
  reg         clk;
  initial begin
    clk         = 1'b0;
  end
  always  #10 clk = ~clk;
  //rst_n设置
  reg         rst_n;
  initial begin
    rst_n       = 1'b1;
    #5  rst_n   = 1'b0;
    #10 rst_n   = 1'b1;
  end

  //wr,rd设置
  reg         wr;
  initial begin
    wr          = 1'b0;
    #25   wr    = 1'b1; //25'写使能
    #360  wr    = 1'b0; //385'写使能无效，datain送入18个数据做测试
  end
  reg         rd;
  initial begin
    rd          = 1'b0;
    #405  rd    = 1'b1; //405'读使能
    #360  rd    = 1'b0; //765'读使能无效，试图从fifo_mem读取18个数据做测试
    #20   $finish;      //785'结束仿真
  end

  reg   [7:0] datain;
  reg   [7:0] i;
  initial begin
    datain      = 8'h00;
    i           = 8'h00;
    #5;
    while(i < 18) begin
      #20 datain  = i;
      i           = i + 8'h01;
    end
  end

  wire        full;
  wire        full_err;
  wire        empty;
  wire        empty_err;
  wire  [7:0] dataout;

  fifo duf (
    .wr       ( wr ),
    .rd       ( rd ),
    .rst_n    ( rst_n ),
    .clk      ( clk ),
    .full     ( full ),
    .empty    ( empty ),
    .full_err ( full_err ),
    .empty_err( empty_err ),
    .datain   ( datain ),
    .dataout  ( dataout )
  );

endmodule
