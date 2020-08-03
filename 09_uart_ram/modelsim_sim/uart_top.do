vlog ../verilog/uart_defines.v
vlog ../verilog/uart_baud.v
vlog ../verilog/uart_rx.v
vlog ../verilog/uart_tx.v
vlog ../verilog/uart_top.v
vlog ../verilog/uart_top_tb.v
vsim -novopt work.uart_top_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst_n -radix binary /uart_top_tb/rst_n
add wave -noupdate -label sys_clk -radix binary /uart_top_tb/sys_clk
add wave -noupdate -label bps_clk_up -radix binary /uart_top_tb/bps_clk_up
add wave -noupdate -label rx_state -radix unsigned /uart_top_tb/top_duf/top_rx/state
add wave -noupdate -label rxd -radix binary /uart_top_tb/rxd
add wave -noupdate -label rxd_d -radix binary /uart_top_tb/top_duf/top_rx/rxd_d
add wave -noupdate -label rxd_nege -radix binary /uart_top_tb/top_duf/top_rx/rxd_nege
add wave -noupdate -label rx_start -radix binary /uart_top_tb/top_duf/top_rx/rx_start
add wave -noupdate -label rx_data_o -radix binary /uart_top_tb/rx_data_o
add wave -noupdate -label rx_idle -radix binary /uart_top_tb/rx_idle
add wave -noupdate -label rx_bits_ok -radix binary /uart_top_tb/rx_bits_ok
add wave -noupdate -label tx_state -radix unsigned /uart_top_tb/top_duf/top_tx/state
add wave -noupdate -label tx_ready -radix binary /uart_top_tb/tx_ready
add wave -noupdate -label tx_st1 -radix binary /uart_top_tb/top_duf/top_tx/tx_st1
add wave -noupdate -label txd_pose -radix binary /uart_top_tb/top_duf/top_tx/txd_pose
add wave -noupdate -label tx_start -radix binary /uart_top_tb/top_duf/top_tx/tx_start
add wave -noupdate -label tx_data_i -radix binary /uart_top_tb/tx_data_i
add wave -noupdate -label tx_data_r -radix binary /uart_top_tb/top_duf/top_tx/tx_data_r
add wave -noupdate -label tx_shift_r -radix binary /uart_top_tb/top_duf/top_rx/rx_shift_r
add wave -noupdate -label txd -radix binary /uart_top_tb/txd
add wave -noupdate -label tx_idle -radix binary /uart_top_tb/tx_idle
add wave -noupdate -label tx_bits_ok -radix binary /uart_top_tb/tx_bits_ok
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4010000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2421200 ps} {5533300 ps}

run -all
view wave
