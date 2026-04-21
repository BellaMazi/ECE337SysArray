source $READ_SOURCES.tcl
elaborate $TOP_MODULE
uniquify

suppress_message VO-4

synthesize_design

check_design
# check_clock_reset

report_timing -path full -delay max -max_paths 1 -nworst 1 > $REPORT_DIR/$TOP_MODULE.rep
report_area >> $REPORT_DIR/$TOP_MODULE.rep
report_power >> $REPORT_DIR/$TOP_MODULE.rep

write_file -format verilog -hierarchy -output $TOP_MODULE.v

quit

