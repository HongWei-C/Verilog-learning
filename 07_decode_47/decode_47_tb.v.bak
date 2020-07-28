`timescale  1ns / 100ps
module decode_47_tb ();
  reg         rst_n;
  reg   [3:0] data;
  reg   [2:0] sel;

  initial begin
    rst_n     = 1'b1;
    #10 rst_n = 1'b0;
    #10 rst_n = 1'b1;
    data      = 4'h0;
    sel       = 3'h0;
    repeat ( 16 ) begin
      #20 sel = sel + 3'h1;
      data    = data + 4'h1; 
    end
      #20 $finish;
  end

  wire  [7:0] seg_num;
  wire  [6:0] seg;

  decode_top duf (
    .rst_n    ( rst_n ),
    .data     ( data ),
    .sel      ( sel ),
    .seg_num  ( seg_num ),
    .seg      ( seg )
  );

endmodule
