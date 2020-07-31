vlog uart_defines.v
vlog uart_baud.v
vlog uart_tx.v
vlog uart_tx_tb.v
vsim -novopt work.uart_tx_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /uart_tx_tb/rst_n
add wave -noupdate -radix binary /uart_tx_tb/sys_clk
add wave -noupdate -radix binary /uart_tx_tb/tx_duf/bps_clk_up
add wave -noupdate -radix unsigned /uart_tx_tb/tx_duf/state
add wave -noupdate -radix binary /uart_tx_tb/tx_data_i
add wave -noupdate -radix binary /uart_tx_tb/tx_duf/tx_data_r
add wave -noupdate -radix binary /uart_tx_tb/txd
add wave -noupdate -radix unsigned /uart_tx_tb/tx_ready
add wave -noupdate -radix unsigned /uart_tx_tb/tx_duf/tx_st1
add wave -noupdate -radix unsigned /uart_tx_tb/tx_duf/tx_st2
add wave -noupdate /uart_tx_tb/tx_duf/txd_pose
add wave -noupdate /uart_tx_tb/tx_duf/tx_start
add wave -noupdate -radix binary /uart_tx_tb/tx_duf/tx_ok
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {613800 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
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
WaveRestoreZoom {0 ps} {1840 ns}

run -all
view wave
