module mux_21_tb();
  reg       sel_tb;
  initial begin
    sel_tb      = 1'b0;
    #20 sel_tb  = 1'b1;
    #35 sel_tb  = 1'b0;
  end

  reg       in_a_tb;
  initial begin
    in_a_tb     = 1'b0;
    #21 in_a_tb = 1'b1;
    #31 in_a_tb = 1'b0;
  end

  reg       in_b_tb;
  initial begin
    in_b_tb     = 1'b1;
    #16 in_b_tb = 1'b0;
    #36 in_b_tb = 1'b1;
    #50 $finish;
  end

  mux_21 duf(
  .sel    ( sel_tb ),
  .in_a   ( in_a_tb ),
  .in_b   ( in_b_tb ),
  .out    ( out_tb )
  );
endmodule
