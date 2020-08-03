vlog ../verilog/uart_defines.v
vlog ../verilog/uart_baud.v
vlog ../verilog/uart_tx.v
vlog ../verilog/uart_tx_tb.v
vsim -novopt work.uart_tx_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst_n -radix binary /uart_tx_tb/rst_n
add wave -noupdate -label sys_clk -radix binary /uart_tx_tb/sys_clk
add wave -noupdate -label bps_clk_up -radix binary /uart_tx_tb/bps_clk_up
add wave -noupdate -label state -radix unsigned /uart_tx_tb/tx_duf/state
add wave -noupdate -label tx_data_i -radix binary /uart_tx_tb/tx_data_i
add wave -noupdate -label tx_ready -radix binary /uart_tx_tb/tx_ready
add wave -noupdate -label tx_st1 -radix binary /uart_tx_tb/tx_duf/tx_st1
add wave -noupdate -label txd_pose -radix binary /uart_tx_tb/tx_duf/txd_pose
add wave -noupdate -label tx_start -radix binary /uart_tx_tb/tx_duf/tx_start
add wave -noupdate -label txd -radix binary /uart_tx_tb/txd
add wave -noupdate -label tx_bits_ok -radix binary /uart_tx_tb/tx_bits_ok
add wave -noupdate -label tx_idle -radix binary /uart_tx_tb/tx_idle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 224
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
WaveRestoreZoom {0 ps} {900 ps}

run -all
view wave
