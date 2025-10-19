vlib work
vlog -sv -work work -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc -classdebug -uvmcontrol=all -assertdebug work.top -cover
add wave -position insertpoint sim:/top/DUT/*
add wave -position insertpoint sim:/top/DUT_RAM/*
add wave -position insertpoint sim:/top/DUT_SLAVE/*
run -all