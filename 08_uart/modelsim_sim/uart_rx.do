vlog ../verilog/uart_defines.v
vlog ../verilog/uart_baud.v
vlog ../verilog/uart_rx.v
vlog ../verilog/uart_rx_tb.v
vsim -novopt work.uart_rx_tb


onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst_n -radix binary /uart_rx_tb/rst_n
add wave -noupdate -label sys_clk -radix binary /uart_rx_tb/sys_clk
add wave -noupdate -label bps_clk_up_16x -radix binary /uart_rx_tb/bps_clk_up_16x
add wave -noupdate -label cnt_16x_f -radix unsigned /uart_rx_tb/rx_duf/cnt_16x
add wave -noupdate -label cnt_16x_f -radix binary /uart_rx_tb/rx_duf/cnt_16x_f
add wave -noupdate -label rx_state -radix unsigned /uart_rx_tb/rx_duf/state
add wave -noupdate -label rxd -radix binary /uart_rx_tb/rxd
add wave -noupdate -label rxd_d -radix binary /uart_rx_tb/rx_duf/rxd_d
add wave -noupdate -label rxd_nege -radix binary /uart_rx_tb/rx_duf/rxd_nege
add wave -noupdate -label rx_start -radix binary /uart_rx_tb/rx_duf/rx_start
add wave -noupdate -label rx_shift_r -radix binary /uart_rx_tb/rx_duf/rx_shift_r
add wave -noupdate -label rx_data_o -radix binary /uart_rx_tb/rx_data_o
add wave -noupdate -label rx_bits_ok -radix binary /uart_rx_tb/rx_bits_ok
add wave -noupdate -label rx_idle -radix binary /uart_rx_tb/rx_idle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
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
WaveRestoreZoom {1638400 ps} {4915200 ps}

run -all
view wave
