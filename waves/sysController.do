onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/clk
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/n_rst
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/ctrl_reg
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/act_ctrl
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/hwdata
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/ahb_wr_weight
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/ahb_wr_input
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/sram_rd_data
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/sram_state
add wave -noupdate -expand -group Inputs /tb_sysController/DUT/activations
add wave -noupdate -expand -group Outputs /tb_sysController/test_name
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/sram_rd_en
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/sram_wr_en
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/sram_addr
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/sram_wr_data
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/load_weights
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/run_array
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/input_vec
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/ctrl_reg_clear
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/status_reg
add wave -noupdate -expand -group Outputs /tb_sysController/DUT/act_ctrl_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7036046 ps} 0}
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
WaveRestoreZoom {0 ps} {7387800 ps}
