proc load_wave {wave_file} {
    global wave_file_name
    set wave_file_name $wave_file
    source $wave_file

    global save_wave
    proc save_wave {} {
        global wave_file_name
        set wave_path [exec find ../../../.. -path "*tmp" -prune -o -path "*$wave_file_name" -print]
        write format wave -window .main_pane.wave.interior.cs.body.pw.wf [lindex $wave_path 0]
    }
}

