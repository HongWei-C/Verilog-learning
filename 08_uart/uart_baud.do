vlog uart_defines.v
vlog uart_baud.v
vlog uart_baud_tb.v

vsim -novopt work.uart_baud_tb
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_baud_tb/rst_n
add wave -noupdate /uart_baud_tb/sys_clk
add wave -noupdate -radix unsigned /uart_baud_tb/baud_duf/cnt
add wave -noupdate -radix unsigned /uart_baud_tb/baud_duf/cnt_half
add wave -noupdate /uart_baud_tb/bps_clk_up
add wave -noupdate -radix unsigned /uart_baud_tb/baud_duf/cnt_max
add wave -noupdate /uart_baud_tb/bps_clk_down
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {232700 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
WaveRestoreZoom {160600 ps} {463800 ps}

run -all
view wave
