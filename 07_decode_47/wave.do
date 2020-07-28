vlog decode_47.v
vlog decode_47_tb.v
vsim -novopt work.decode_47_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /decode_47_tb/rst_n
add wave -noupdate -radix hexadecimal /decode_47_tb/sel
add wave -noupdate -radix binary /decode_47_tb/seg_num
add wave -noupdate -radix hexadecimal /decode_47_tb/data
add wave -noupdate -radix binary -childformat {{{/decode_47_tb/seg[6]} -radix binary} {{/decode_47_tb/seg[5]} -radix binary} {{/decode_47_tb/seg[4]} -radix binary} {{/decode_47_tb/seg[3]} -radix binary} {{/decode_47_tb/seg[2]} -radix binary} {{/decode_47_tb/seg[1]} -radix binary} {{/decode_47_tb/seg[0]} -radix binary}} -subitemconfig {{/decode_47_tb/seg[6]} {-radix binary} {/decode_47_tb/seg[5]} {-radix binary} {/decode_47_tb/seg[4]} {-radix binary} {/decode_47_tb/seg[3]} {-radix binary} {/decode_47_tb/seg[2]} {-radix binary} {/decode_47_tb/seg[1]} {-radix binary} {/decode_47_tb/seg[0]} {-radix binary}} /decode_47_tb/seg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {139 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 67
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
WaveRestoreZoom {186 ns} {356 ns}

run -all
view wave
