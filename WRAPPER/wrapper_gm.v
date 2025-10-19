module WRAPPER_GM (
    MOSI,
    SS_n,
    clk,
    rst_n,
    MISO
);
  input clk, rst_n, MOSI, SS_n;
  output MISO;
  wire [9:0] rx_data;
  wire rx_valid;
  wire [7:0] tx_data;
  wire tx_valid;
  SLAVE_GM SLAVE_GMM (
      MOSI,
      MISO,
      SS_n,
      clk,
      rst_n,
      rx_data,
      rx_valid,
      tx_data,
      tx_valid
  );
  RAM_GM RAMM_GM (
      rx_data,
      clk,
      rst_n,
      rx_valid,
      tx_data,
      tx_valid
  );
endmodule
