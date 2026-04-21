# Auto-generated project tcl file to read all sources

set search_path [concat [list .] $search_path]
analyze -format sverilog -define { } -work work src/ece337_course-lib_sram1024x32_wrapper_1.0.0/source/sram1024x32_wrapper.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_activation_1.0.0/source/activation.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_ahb_subordinate_cdl_1.0.0/source/ahb_subordinate_cdl.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_dataBuffer_1.0.0/source/dataBuffer.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_fp_adder_1.0.0/source/fp_adder.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_fp_multiplier_1.0.0/source/fp_multiplier.sv
source  src/u337mg126_ece337_synfiles_0/detect-reset-logic.tcl
analyze -format sverilog -define { } -work work src/u337mg126_ece337_sysController_1.0.0/source/sysController.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_bias_adder_1.0.0/source/bias_adder.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_systolic_array_1.0.0/source/systolic_array.sv
analyze -format sverilog -define { } -work work src/u337mg126_ece337_sysArr_top_1.0.0/source/sysArr_top.sv
source  src/u337mg126_ece337_sysArr_top_1.0.0/scripts/syn_sysArr_top.tcl
