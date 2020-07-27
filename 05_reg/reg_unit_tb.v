`timescale 1ns / 100ps
module reg_unit_tb ();

  reg         clk_tb;
  initial begin
    clk_tb           = 1'b0;
  end
  always  #10 clk_tb = ~clk_tb;

  reg         rst_n_tb;
  initial begin
    rst_n_tb     = 1'b1;
    #13 rst_n_tb = 1'b0;
    #20 rst_n_tb = 1'b1;
  end

  reg         en_tb;
  initial begin
    en_tb        = 1'b0;
    #45 en_tb    = 1'b1;
    #80 en_tb    = 1'b0;
    #20 en_tb    = 1'b1;
    #80 $finish;
  end

  reg         Din_tb;
  initial begin
    Din_tb       = 1'b0;
    repeat ( 6 ) begin
      #20 Din_tb = 1'b1;
      #20 Din_tb = 1'b0;
    end
  end

  wire        Q_tb;
  reg_unit  duf (
    .Din  ( Din_tb ),
    .en   ( en_tb ),
    .rst_n( rst_n_tb ),
    .clk  ( clk_tb ),
    .Q    ( Q_tb)
  );
endmodule
