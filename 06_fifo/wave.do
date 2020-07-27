vlog fifo.v
vlog fifo_tb.v
vsim -novopt work.fifo_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /fifo_tb/rst_n
add wave -noupdate -radix unsigned /fifo_tb/clk
add wave -noupdate -radix unsigned /fifo_tb/wr
add wave -noupdate -radix unsigned /fifo_tb/rd
add wave -noupdate -radix unsigned /fifo_tb/duf/cnt
add wave -noupdate -radix unsigned /fifo_tb/full
add wave -noupdate -radix unsigned /fifo_tb/full_err
add wave -noupdate -radix unsigned /fifo_tb/empty
add wave -noupdate -radix unsigned /fifo_tb/empty_err
add wave -noupdate -radix unsigned /fifo_tb/duf/wr_addr
add wave -noupdate -radix unsigned /fifo_tb/datain
add wave -noupdate -radix unsigned -childformat {{{/fifo_tb/duf/fifo_mem[0]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[1]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[2]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[3]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[4]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[5]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[6]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[7]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[8]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[9]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[10]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[11]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[12]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[13]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[14]} -radix unsigned} {{/fifo_tb/duf/fifo_mem[15]} -radix unsigned}} -expand -subitemconfig {{/fifo_tb/duf/fifo_mem[0]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[1]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[2]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[3]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[4]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[5]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[6]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[7]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[8]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[9]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[10]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[11]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[12]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[13]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[14]} {-radix unsigned} {/fifo_tb/duf/fifo_mem[15]} {-radix unsigned}} /fifo_tb/duf/fifo_mem
add wave -noupdate -radix unsigned /fifo_tb/duf/rd_addr
add wave -noupdate -radix unsigned /fifo_tb/dataout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {745 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {470 ns} {802 ns}

run -all
view wave