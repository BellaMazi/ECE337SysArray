onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/clk
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/n_rst
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/sram_rd_en
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/sram_wr_en
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/sram_addr
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/sram_wr_data
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/ctrl_reg_clear
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/ctrl_reg_0
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/haddr
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/hwdata
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/hwrite
add wave -noupdate -group Inputs /tb_dataBuffer/DUT/ahb_req
add wave -noupdate -expand -group Outputs /tb_dataBuffer/test_name
add wave -noupdate -expand -group Outputs /tb_dataBuffer/DUT/sram_rd_data
add wave -noupdate -expand -group Outputs /tb_dataBuffer/DUT/sram_state_out
add wave -noupdate -expand -group Outputs /tb_dataBuffer/DUT/hready_stall
add wave -noupdate -expand -group Outputs /tb_dataBuffer/DUT/occ_err
add wave -noupdate -expand -group Outputs /tb_dataBuffer/DUT/overrun_err
add wave -noupdate /tb_dataBuffer/DUT/hold_re
add wave -noupdate /tb_dataBuffer/DUT/hold_we
add wave -noupdate /tb_dataBuffer/DUT/sram_re
add wave -noupdate /tb_dataBuffer/DUT/sram_we
add wave -noupdate /tb_dataBuffer/DUT/next_occ_err
add wave -noupdate /tb_dataBuffer/DUT/next_overrun_err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1478 ps}
