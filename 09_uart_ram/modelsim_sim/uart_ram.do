vlog ../verilog/uart_defines.v
vlog ../verilog/uart_baud.v
vlog ../verilog/uart_rx.v
vlog ../verilog/uart_tx.v
vlog ../verilog/uart_top.v
vlog ../verilog/uart_ram.v
vlog ../verilog/uart_ram_tb.v
vlog ../vivado_fpga/vivado.srcs/sources_1/ip/dmg_ram/simulation/dist_mem_gen_v8_0.v
vlog ../vivado_fpga/vivado.srcs/sources_1/ip/dmg_ram/sim/dmg_ram.v
vsim -novopt work.uart_ram_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst_n -radix binary /uart_ram_tb/rst_n
add wave -noupdate -label sys_clk -radix binary /uart_ram_tb/sys_clk
add wave -noupdate -label bps_clk_up -radix binary /uart_ram_tb/ram_1/bps_clk_up
add wave -noupdate -label rx_state -radix unsigned /uart_ram_tb/ram_1/top_to_ram/top_rx/state
add wave -noupdate -label rxd -radix binary /uart_ram_tb/rxd
add wave -noupdate -label rx_start -radix binary /uart_ram_tb/ram_1/top_to_ram/top_rx/rx_start
add wave -noupdate -label rx_shift_r -radix binary /uart_ram_tb/ram_1/top_to_ram/top_rx/rx_shift_r
add wave -noupdate -label rx_data_o -radix binary /uart_ram_tb/ram_1/rx_data_o
add wave -noupdate -label rx_bits_ok -radix binary /uart_ram_tb/ram_1/rx_bits_ok
add wave -noupdate -label state -radix unsigned /uart_ram_tb/ram_1/state
add wave -noupdate -label ram_command -radix binary /uart_ram_tb/ram_1/ram_command
add wave -noupdate -label ram_addr -radix binary /uart_ram_tb/ram_1/ram_addr
add wave -noupdate -label ram_datain -radix binary /uart_ram_tb/ram_1/ram_datain
add wave -noupdate -label ram_write_r -radix binary /uart_ram_tb/ram_1/ram_write_r
add wave -noupdate -label ram_write_r1 -radix binary /uart_ram_tb/ram_1/ram_write_r1
add wave -noupdate -label ram_write -radix binary /uart_ram_tb/ram_1/ram_write
add wave -noupdate -label ram_dataout -radix binary /uart_ram_tb/ram_1/ram_dataout
add wave -noupdate -label tx_state -radix unsigned /uart_ram_tb/ram_1/top_to_ram/top_tx/state
add wave -noupdate -label txd -radix binary /uart_ram_tb/txd
add wave -noupdate -label tx_data_in -radix binary /uart_ram_tb/ram_1/tx_data_i
add wave -noupdate -label tx_ready_r /uart_ram_tb/ram_1/tx_ready_r
add wave -noupdate -label tx_ready_r1 /uart_ram_tb/ram_1/tx_ready_r1
add wave -noupdate -label tx_ready /uart_ram_tb/ram_1/tx_ready
add wave -noupdate -label tx_start /uart_ram_tb/ram_1/top_to_ram/top_tx/tx_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9227500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 287
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
WaveRestoreZoom {0 ps} {3212 ns}

run -all
view wave
