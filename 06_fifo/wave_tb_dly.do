vlog fifo.v
vlog fifo_tb_dly.v
vsim -novopt work.fifo_tb_dly

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /fifo_tb_dly/rst_n
add wave -noupdate -radix unsigned /fifo_tb_dly/clk
add wave -noupdate -radix unsigned /fifo_tb_dly/wr
add wave -noupdate -radix unsigned /fifo_tb_dly/rd
add wave -noupdate -radix unsigned /fifo_tb_dly/full
add wave -noupdate -radix unsigned /fifo_tb_dly/full_err
add wave -noupdate -radix unsigned /fifo_tb_dly/empty
add wave -noupdate -radix unsigned /fifo_tb_dly/empty_err
add wave -noupdate -radix unsigned /fifo_tb_dly/duf/cnt
add wave -noupdate -radix unsigned /fifo_tb_dly/duf/wr_addr
add wave -noupdate -radix unsigned /fifo_tb_dly/datain
add wave -noupdate -radix unsigned -childformat {{{/fifo_tb_dly/duf/fifo_mem[0]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[1]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[2]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[3]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[4]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[5]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[6]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[7]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[8]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[9]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[10]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[11]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[12]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[13]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[14]} -radix unsigned} {{/fifo_tb_dly/duf/fifo_mem[15]} -radix unsigned}} -expand -subitemconfig {{/fifo_tb_dly/duf/fifo_mem[0]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[1]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[2]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[3]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[4]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[5]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[6]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[7]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[8]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[9]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[10]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[11]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[12]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[13]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[14]} {-height 15 -radix unsigned} {/fifo_tb_dly/duf/fifo_mem[15]} {-height 15 -radix unsigned}} /fifo_tb_dly/duf/fifo_mem
add wave -noupdate -radix unsigned -childformat {{{/fifo_tb_dly/duf/rd_addr[3]} -radix binary} {{/fifo_tb_dly/duf/rd_addr[2]} -radix binary} {{/fifo_tb_dly/duf/rd_addr[1]} -radix binary} {{/fifo_tb_dly/duf/rd_addr[0]} -radix binary}} -subitemconfig {{/fifo_tb_dly/duf/rd_addr[3]} {-height 15 -radix binary} {/fifo_tb_dly/duf/rd_addr[2]} {-height 15 -radix binary} {/fifo_tb_dly/duf/rd_addr[1]} {-height 15 -radix binary} {/fifo_tb_dly/duf/rd_addr[0]} {-height 15 -radix binary}} /fifo_tb_dly/duf/rd_addr
add wave -noupdate -radix unsigned /fifo_tb_dly/dataout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {824400 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ns
update
WaveRestoreZoom {437800 ps} {851700 ps}

run -all
view wave
