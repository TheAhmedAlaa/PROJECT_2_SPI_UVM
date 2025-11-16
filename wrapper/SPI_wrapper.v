module WRAPPER (
    MOSI,
    SS_n,
    clk,
    rst_n,
    MISO
);

  input MOSI, SS_n, clk, rst_n;
  output MISO;

  wire [9:0] rx_data_din;
  wire       rx_valid;
  wire       tx_valid;
  wire [7:0] tx_data_dout;

  RAM RAM_instance (
      rx_data_din,
      clk,
      rst_n,
      rx_valid,
      tx_data_dout,
      tx_valid
  );
  SLAVE SLAVE_instance (
      MOSI,
      MISO,
      SS_n,
      clk,
      rst_n,
      rx_data_din,
      rx_valid,
      tx_data_dout,
      tx_valid
  );
endmodule
