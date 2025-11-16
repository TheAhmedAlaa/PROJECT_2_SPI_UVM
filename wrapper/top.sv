import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_test_pkg::*;
import config_pkgg::*;
import config_pkg_spi::*;
import config_pkg_ram::*;
module top ();
  bit clk;
  initial begin
    clk = 0;
    forever begin
      #10 clk = ~clk;
    end
  end
  assign spiif_.MOSI     = DUT.MOSI;
  assign spiif_.SS_n     = DUT.SS_n;
  assign spiif_.rst_n    = DUT.rst_n;
  assign ramif_.din      = DUT.rx_data_din;
  assign ramif_.rx_valid = DUT.rx_valid;
  assign ramif_.rst_n    = DUT.rst_n;
  assign spiif_.tx_data  = DUT.tx_data_dout;
  assign spiif_.tx_valid = DUT.tx_valid;
  wrapperif wrapperif_ (clk);
  WRAPPER DUT (
      wrapperif_.MOSI,
      wrapperif_.SS_n,
      clk,
      wrapperif_.rst_n,
      wrapperif_.MISO
  );
  WRAPPER_GM DUT_GM (
      wrapperif_.MOSI,
      wrapperif_.SS_n,
      clk,
      wrapperif_.rst_n,
      wrapperif_.MISO_exp
  );
  spiif spiif_ (clk);
  SLAVE DUT_SLAVE (
      spiif_.MOSI,
      spiif_.MISO,
      spiif_.SS_n,
      spiif_.clk,
      spiif_.rst_n,
      spiif_.rx_data,
      spiif_.rx_valid,
      spiif_.tx_data,
      spiif_.tx_valid
  );
  SLAVE_GM GM_SLAVE (
      spiif_.MOSI,
      spiif_.MISO_exp,
      spiif_.SS_n,
      spiif_.clk,
      spiif_.rst_n,
      spiif_.rx_data_exp,
      spiif_.rx_valid_exp,
      spiif_.tx_data,
      spiif_.tx_valid
  );
  ramif ramif_ (clk);
  RAM DUT_RAM (
      ramif_.din,
      clk,
      ramif_.rst_n,
      ramif_.rx_valid,
      ramif_.dout,
      ramif_.tx_valid
  );
  RAM_GM GM_RAM (
      ramif_.din,
      clk,
      ramif_.rst_n,
      ramif_.rx_valid,
      ramif_.dout_exp,
      ramif_.tx_valid_exp
  );
  initial begin
    uvm_config_db#(virtual spiif)::set(null, "uvm_test_top", "SPI", spiif_);
    uvm_config_db#(virtual ramif)::set(null, "uvm_test_top", "RAM", ramif_);
    uvm_config_db#(virtual wrapperif)::set(null, "uvm_test_top", "wrapper", wrapperif_);
    run_test("wrapper_test");
  end
 /* bind SLAVE spi_SVA sva_instance_SPI (
      spiif_.MOSI,
      spiif_.MISO,
      spiif_.SS_n,
      spiif_.clk,
      spiif_.rst_n,
      spiif_.rx_data,
      spiif_.rx_valid,
      spiif_.tx_data,
      spiif_.tx_valid
  ); */
  bind RAM ram_SVA sva_instance (
      ramif_.din,
      clk,
      ramif_.rst_n,
      ramif_.rx_valid,
      ramif_.dout,
      ramif_.tx_valid
  );
  bind WRAPPER wrapper_SVA sva_instance_wrapper (
      wrapperif_.clk,
      wrapperif_.rst_n,
      wrapperif_.MOSI,
      wrapperif_.MISO,
      wrapperif_.SS_n
  );
endmodule
