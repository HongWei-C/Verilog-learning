vlog uart_defines.v
vlog uart_baud.v
vlog uart_rx.v
vlog uart_rx_tb.v
vsim -novopt work.uart_rx_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /uart_rx_tb/rst_n
add wave -noupdate -radix binary /uart_rx_tb/sys_clk
add wave -noupdate -radix binary /uart_rx_tb/rx_duf/bps_clk_up
add wave -noupdate -radix unsigned /uart_rx_tb/rx_duf/state
add wave -noupdate -radix binary /uart_rx_tb/rxd
add wave -noupdate -radix binary /uart_rx_tb/rx_duf/rx_shift_r
add wave -noupdate -radix binary /uart_rx_tb/rx_data_o
add wave -noupdate -radix binary /uart_rx_tb/rx_duf/rx_ok
add wave -noupdate -radix binary /uart_rx_tb/rx_duf/rxd_d
add wave -noupdate -radix binary /uart_rx_tb/rx_duf/rxd_neg
add wave -noupdate -radix binary /uart_rx_tb/rx_duf/rx_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {570000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 249
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
WaveRestoreZoom {0 ps} {1100000 ps}

run -all
view wave
