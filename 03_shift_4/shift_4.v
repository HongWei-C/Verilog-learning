module shift_4 (
  dinl,
  din,
  dinr,
  clk,
  rst_n,
  sel,
  out
);

  input         dinl;   //左移暂存寄存器
  input   [3:0] din;    //并行输入
  input         dinr;   //右移暂存寄存器
  input         clk;    //时钟
  input         rst_n;  //复位
  input   [1:0] sel;    //功能选择 00保持 01右移 10左移 11并行载入
  output  [3:0] out;    //移位寄存器

  reg     [3:0] out;
  always @ ( posedge clk or negedge rst_n ) begin
    if ( ~rst_n ) begin
      out     <= 4'b0000;
    end
    else begin
      case ( sel )
        2'b00:  out <= out;                 //保持
        2'b01:  out <= { dinr , out[3:1] }; //右移
        2'b10:  out <= { out[2:0] , dinl }; //左移
        2'b11:  out <= din;               //并行输入
      endcase
    end
  end
  endmodule
