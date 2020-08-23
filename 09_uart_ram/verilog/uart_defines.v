// 本模块定义了工程可能用到的宏定义，并设计了timescale
`timescale  1ns / 100ps

//宏定义
`define SYS_CLOCK 100000000 //定义了使用的系统时钟频率100MHz
//仿真时用，写入FPGA时注释掉
//`define FAST_SIM  

`ifdef  FAST_SIM
  `define BAUDRATE  1562500  //仿真时用
`else								
  `define BAUDRATE  115200    //定义了uart的波特率为115200
  //`define BAUDRATE  9600      //定义了uart的波特率为9600
`endif


