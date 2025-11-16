interface spiif (
    clk
);
  input clk;
  logic MOSI, MISO, SS_n, rst_n, tx_valid, rx_valid, MISO_exp, rx_valid_exp;
  logic [9:0] rx_data, rx_data_exp;
  logic [7:0] tx_data;
endinterface
