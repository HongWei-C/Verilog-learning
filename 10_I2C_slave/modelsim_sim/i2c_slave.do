vlog ../verilog/i2c_defines.v
vlog ../verilog/i2c_frq.v
vlog ../verilog/i2c_slave.v
vlog ../verilog/i2c_slave_tb.v
vsim -novopt work.i2c_slave_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label rst_n -radix binary /i2c_slave_tb/rst_n
add wave -noupdate -label sys_clk -radix binary /i2c_slave_tb/sys_clk
add wave -noupdate -label div_clk_up -radix binary /i2c_slave_tb/slave_duf/div_clk_up
add wave -noupdate -label bps_clk_up -radix binary /i2c_slave_tb/slave_duf/bps_clk_up
add wave -noupdate -label sda_en -radix binary /i2c_slave_tb/sda_en
add wave -noupdate -label sda_in -radix binary /i2c_slave_tb/sda_in
add wave -noupdate -label sda_rr -radix binary /i2c_slave_tb/slave_duf/sda_rr
add wave -noupdate -label sda -radix binary /i2c_slave_tb/sda
add wave -noupdate -label scl -radix binary /i2c_slave_tb/scl
add wave -noupdate -label state -radix unsigned /i2c_slave_tb/slave_duf/state
add wave -noupdate -label sad_start -radix binary /i2c_slave_tb/slave_duf/sda_start
add wave -noupdate -label sda_stop -radix binary /i2c_slave_tb/slave_duf/sda_stop
add wave -noupdate -label wr -radix binary /i2c_slave_tb/slave_duf/wr
add wave -noupdate -label data_cnt -radix binary /i2c_slave_tb/slave_duf/data_cnt
add wave -noupdate -label R_wait_cnt -radix binary /i2c_slave_tb/slave_duf/R_wait_cnt
add wave -noupdate -label sda_data_in -radix binary /i2c_slave_tb/sda_data_in
add wave -noupdate -label sda_data_r -radix binary /i2c_slave_tb/slave_duf/sda_data_r
add wave -noupdate -label sda_data_out -radix binary /i2c_slave_tb/sda_data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {751600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
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
WaveRestoreZoom {0 ps} {2136400 ps}

run -all
view wave
