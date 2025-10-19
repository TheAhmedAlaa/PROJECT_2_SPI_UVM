vlib work
vlog -sv -work work -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc -classdebug -uvmcontrol=all -assertdebug work.top -cover
add wave sim:/top/spiif_/*
add wave /top/DUT/ASSRT_VALID_rd_data_seq
add wave /top/DUT/ASSRT_VALID_rd_add_seq
add wave /top/DUT/ASSRT_VALID_wr_add_seq
add wave /top/DUT/received_address
run -all