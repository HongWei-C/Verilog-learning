module DFF_tb ();
  reg         tb_clk;
  reg         tb_D;
  initial begin
    tb_clk  = 1'b0;
    tb_D    = 1'b0;
  end
  always  #10 tb_clk  = ~tb_clk;
  always  #13 tb_D    = ~tb_D;

  reg         tb_rst_n;
  initial begin
    tb_rst_n      = 1'b1;
    #11 tb_rst_n  = 1'b0;
    #25 tb_rst_n  = 1'b1;
    #100  $finish;
  end

  DFF dut_dff_1 (
    .D    ( tb_D ),
    .clk  ( tb_clk ),
    .rst_n( tb_rst_n ),
    .Q    ( tb_Q )
  );
endmodule
