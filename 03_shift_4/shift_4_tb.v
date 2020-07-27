`timescale  1ns / 100ps
module shift_4_tb();

  reg         rst_n_tb;
  initial begin
    rst_n_tb     = 1'b1;
    #5  rst_n_tb = 1'b0;
    #13 rst_n_tb = 1'b1;
  end

  reg         clk_tb;
  initial begin
    clk_tb       = 1'b0;
  end
  always #10  clk_tb = ~clk_tb;

  reg   [1:0] sel_tb;
  initial begin
    sel_tb       = 2'b00;
    #25   sel_tb = 2'b11;  //25'并行输入数据
    #20   sel_tb = 2'b01;  //45'进行右移
    #40   sel_tb = 2'b00;  //85'保持
    #20   sel_tb = 2'b11;  //105'并行输入数据
    #20   sel_tb = 2'b10;  //105'进行左移
  end

  reg   [3:0] din_tb;
  initial begin
    din_tb       = 4'b0000;
    #26   din_tb = 4'b1000;
    #80  din_tb = 4'b0001;
  end

  reg         dinr_tb;
  initial begin
    dinr_tb        = 1'b0;
    #46   dinr_tb  = 1'b1;
    #20   dinr_tb  = 1'b0;
  end

  reg         dinl_tb;
  initial begin
    dinl_tb        = 1'b0;
    #126  dinl_tb  = 1'b1;
    #20   dinl_tb  = 1'b0;
    #25   $finish;
  end
  
  wire  [3:0] out_tb;
  shift_4 duf (
    .dinl   ( dinl_tb ),
    .din    ( din_tb ),
    .dinr   ( dinr_tb ),
    .clk    ( clk_tb ),
    .rst_n  ( rst_n_tb ),
    .sel    ( sel_tb ),
    .out    ( out_tb )
  );
endmodule
