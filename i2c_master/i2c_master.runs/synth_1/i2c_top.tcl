# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/i2c_master/i2c_master.cache/wt [current_project]
set_property parent.project_path C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/i2c_master/i2c_master.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_output_repo c:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/i2c_master/i2c_master.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/apb_slave_interface.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/clock_generator.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/data_fifo_mem.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/data_path_i2c_to_core.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/fifo_mem.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/fifo_toplevel.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/i2c_master_fsm.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/rptr_empty.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/sync_r2w.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/sync_w2r.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/wptr_full.v
  C:/Users/USER/Desktop/git_code/i2c_folder/i2c_code/i2c_top.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}

synth_design -top i2c_top -part xc7z020clg484-1


write_checkpoint -force -noxdef i2c_top.dcp

catch { report_utilization -file i2c_top_utilization_synth.rpt -pb i2c_top_utilization_synth.pb }