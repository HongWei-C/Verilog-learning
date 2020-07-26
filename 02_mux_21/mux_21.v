module mux_21(
  sel,
  in_a,
  in_b,
  out
);
  input       sel;
  input       in_a;
  input       in_b;
  output      out;

  assign out    = sel ? in_a : in_b;

endmodule
