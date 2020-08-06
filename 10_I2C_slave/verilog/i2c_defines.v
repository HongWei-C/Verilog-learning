`timescale  1ns / 100ps

//定义系统时钟和
`define SYS_CLOCK   100000000
//仿真时用，写入FPGA时注释掉
`define FAST_SIM

`ifdef  FAST_SIM
  `define BPS_RATE  12500000
`else
  `define BPS_RATE  9600
`endif
