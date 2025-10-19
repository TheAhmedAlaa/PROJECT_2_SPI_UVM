vlib work
vlog -sv -work work -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc -classdebug -uvmcontrol=all -assertdebug work.top -cover
add wave sim:/top/ramif_/*
run -all