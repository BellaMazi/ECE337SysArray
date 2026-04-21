############################################
#
# Auto-generated project tcl file:
#  * sets up variable
#  * runs customized script
#
############################################
sh date

set TOP_MODULE sysArr_top
set DC_SCRIPT synth.tcl

set READ_SOURCES u337mg126_ece337_sysArr_top_1.0.0-read-sources

set SCRIPT_DIR src/u337mg126_ece337_synfiles_0

set REPORT_DIR reports
sh mkdir -p ${REPORT_DIR}

set target_library /home/ecegrid/a/ece337/summer24-refactor/tech/ami05/osu05_stdcells.db
set link_library   [concat "*"  /home/ecegrid/a/ece337/summer24-refactor/tech/ami05/osu05_stdcells.db dw_foundation.sldb]
############################################
#
# Run custom script
#
############################################
source ${SCRIPT_DIR}/${DC_SCRIPT}

############################################
#
#  all done -- exit
#
############################################
sh date