vlib work

# compile design files
vlog alu.sv
vlog control_unit.sv
vlog PCTarget.sv
vlog extend.sv
vlog PCPlus4.sv
vlog data_mem.sv
vlog insruction_mem.sv
vlog register_file.sv
vlog top.sv

# compile testbench
vlog top_tb.sv

# simulate
vsim -voptargs=+acc work.top_tb

# add waves
add wave *

# run simulation
run -all