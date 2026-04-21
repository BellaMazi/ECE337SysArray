onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /tb_systolic_array/clk
add wave -noupdate /tb_systolic_array/n_rst
add wave -noupdate /tb_systolic_array/load_weights
add wave -noupdate /tb_systolic_array/run_array
add wave -noupdate /tb_systolic_array/input_vec
add wave -noupdate /tb_systolic_array/testName
add wave -noupdate -divider Outputs
add wave -noupdate /tb_systolic_array/data_out_valid
add wave -noupdate /tb_systolic_array/outputs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1400988 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {3171 ns}
