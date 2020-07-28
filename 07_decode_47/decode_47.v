module decode_top (
  rst_n,
  data,
  sel,
  seg_num,
  seg
);
  input         rst_n;
  input   [3:0] data;
  input   [2:0] sel;
  output  [7:0] seg_num;
  output  [6:0] seg;

  //调用下层模块
  seg_sel sel_1 (
    .rst_n    ( rst_n ),
    .sel      ( sel ),
    .seg_num  ( seg_num )
  );
  decode_47 decode_1 (
    .rst_n    ( rst_n ),
    .data     ( data ),
    .seg      ( seg )
  ); 
endmodule

//数码管段选模块
module seg_sel (
  rst_n,
  sel,
  seg_num
);
  input         rst_n;      //全局复位
  input   [2:0] sel;        //数码管段选输入
  output  [7:0] seg_num;    //数码管段选
  
  reg     [7:0] seg_num;
  always @ ( sel or rst_n ) begin
    if ( ~rst_n ) begin
      seg_num     = 8'b0000_0000; //复位全亮
    end
    else begin
      case ( sel ) 
        3'h0:     seg_num = 8'b1111_1110;
        3'h1:     seg_num = 8'b1111_1101;
        3'h2:     seg_num = 8'b1111_1011;
        3'h3:     seg_num = 8'b1111_0111;
        3'h4:     seg_num = 8'b1110_1111;
        3'h5:     seg_num = 8'b1101_1111;
        3'h6:     seg_num = 8'b1011_1111;
        3'h7:     seg_num = 8'b0111_1111;
        default:  seg_num = 8'b1111_1111; //错误段选
      endcase
    end
  end
endmodule

//数码管译码模块
module decode_47 (
  rst_n,
  data,
  seg  
);
  input         rst_n;
  input   [3:0] data;
  output  [6:0] seg;
  
  //共阳极设计
  reg     [6:0] seg;
  always @ ( data or rst_n ) begin
    if ( ~rst_n ) begin
      seg   = 7'b111_1110;    //数码管显示 -
    end
    else begin 
      case( data )      //共阳        //共阴
        4'h0:     seg = 7'b000_0001;  //7'b111_1110;  // 0
        4'h1:     seg = 7'b100_1111;  //7'b011_0000;  // 1
        4'h2:     seg = 7'b001_0010;  //7'b110_1101;  // 2
        4'h3:     seg = 7'b000_0110;  //7'b111_1001;  // 3
        4'h4:     seg = 7'b100_1100;  //7'b011_0011;  // 4
        4'h5:     seg = 7'b010_0100;  //7'b101_1011;  // 5
        4'h6:     seg = 7'b010_0000;  //7'b101_1111;  // 6
        4'h7:     seg = 7'b000_1111;  //7'b111_0000;  // 7
        4'h8:     seg = 7'b000_0000;  //7'b111_1111;  // 8
        4'h9:     seg = 7'b000_0100;  //7'b111_1011;  // 9
        4'ha:     seg = 7'b000_1000;  //7'b111_0111;  // A
        4'hb:     seg = 7'b110_0000;  //7'b001_1111;  // b
        4'hc:     seg = 7'b011_0001;  //7'b100_1110;  // C
        4'hd:     seg = 7'b100_0010;  //7'b011_1101;  // d
        4'he:     seg = 7'b011_0000;  //7'b100_1111;  // E
        4'hf:     seg = 7'b011_1000;  //7'b100_0111;  // F
        default:  seg = 7'b111_1111;  //7'b000_0000;  // 其他，数码管不显示
      endcase
    end
  end
endmodule
