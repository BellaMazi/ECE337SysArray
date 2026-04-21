proc get_n_rst_paths {endpoint n} {
    return [get_timing_paths -include_hierarchical_pins \
        -from "n_rst" -to $endpoint -enable_preset_clear_arcs -nworst $n]
}

proc get_async_pin_attr {path attr} {
    foreach_in_collection point [get_attribute $path points] {
        set point_obj [get_attribute $point object]
        if {[get_attribute $point_obj object_class] ne "pin"} {
            continue;
        }
        if {[get_attribute $point_obj is_async_pin] eq "true"} {
            return [get_attribute $point $attr]
        }
    }
    error "Did not have an async pin"
}

proc has_async_logic {{max_paths_to_fetch 100}} {
    set set_paths [get_n_rst_paths "*/S" $max_paths_to_fetch]
    set reset_paths [get_n_rst_paths "*/R" $max_paths_to_fetch]

    set all_paths $set_paths
    append_to_collection all_paths $reset_paths

    set issues_detected false
    foreach_in_collection path $all_paths {
        if {[get_async_pin_attr $path arrival] != 0} {
            set n [get_attribute [get_async_pin_attr $path object] full_name]
            puts "Warning: Combinational logic between n_rst and $n (ECE337-1)"
            set issues_detected true
        }
    }
    return $issues_detected
}

proc has_port {name} {
    return [expr [sizeof_collection [get_ports $name -quiet]] > 0]
}

proc check_clock_reset {} {
    if { [has_port "clk"] && [has_port "n_rst"] } {
        return [expr ! [has_async_logic]]
    }
    if { [has_port "clk"] && ! [has_port "n_rst"] } {
        puts "Warning: Design has a clock port without a reset port (ECE337-2)"
    }
    if { ! [has_port "clk"] && [has_port "n_rst"] } {
        puts "Warning: Design has a reset port without a clock port (ECE337-3)"
    }
    return true
}
