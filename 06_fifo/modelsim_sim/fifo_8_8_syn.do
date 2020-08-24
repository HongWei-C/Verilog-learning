vlog ../verilog/fifo_8_8_syn.v
#vlog ../verilog/fifo_8_8_syn_tb.v
vlog ../verilog/fifo_8_8_syn_tb_1.v
vsim -novopt work.fifo_8_8_syn_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /fifo_8_8_syn_tb/rst_n
add wave -noupdate -radix binary /fifo_8_8_syn_tb/clk
add wave -noupdate -radix binary /fifo_8_8_syn_tb/rw_en
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/cnt
add wave -noupdate -radix binary /fifo_8_8_syn_tb/cycle
add wave -noupdate -radix binary /fifo_8_8_syn_tb/fast_wr
add wave -noupdate -radix binary /fifo_8_8_syn_tb/wr
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/fifo_duf/wr_addr
add wave -noupdate -radix binary /fifo_8_8_syn_tb/full
add wave -noupdate -radix binary /fifo_8_8_syn_tb/full_err
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/datain
add wave -noupdate -radix unsigned -childformat {{{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[0]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[1]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[2]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[3]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[4]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[5]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[6]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[7]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[8]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[9]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[10]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[11]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[12]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[13]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[14]} -radix unsigned} {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[15]} -radix unsigned}} -expand -subitemconfig {{/fifo_8_8_syn_tb/fifo_duf/fifo_mem[0]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[1]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[2]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[3]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[4]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[5]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[6]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[7]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[8]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[9]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[10]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[11]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[12]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[13]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[14]} {-height 15 -radix unsigned} {/fifo_8_8_syn_tb/fifo_duf/fifo_mem[15]} {-height 15 -radix unsigned}} /fifo_8_8_syn_tb/fifo_duf/fifo_mem
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/dataout
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/exp_data
add wave -noupdate -radix binary /fifo_8_8_syn_tb/fast_rd
add wave -noupdate -radix binary /fifo_8_8_syn_tb/rd
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/fifo_duf/rd_addr
add wave -noupdate -radix binary /fifo_8_8_syn_tb/empty
add wave -noupdate -radix binary /fifo_8_8_syn_tb/empty_err
add wave -noupdate -radix unsigned /fifo_8_8_syn_tb/filled_f


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {164500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 146
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {453 ns}

run -all
view wave
