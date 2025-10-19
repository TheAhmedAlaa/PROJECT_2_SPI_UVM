interface ramif (
    clk
);
  input clk;
  logic [9:0] din;
  logic rst_n, rx_valid;
  logic [7:0] dout, dout_exp;
  logic tx_valid, tx_valid_exp;
endinterface
