import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_test_pkg::*;
import config_pkgg::*;
module top ();
  bit clk;
  initial begin
    clk = 0;
    forever begin
      #10 clk = ~clk;
    end
  end
  spiif spiif_ (clk);
  SLAVE DUT (
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
  SLAVE_GM _GM (
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
  initial begin
    uvm_config_db#(virtual spiif)::set(null, "uvm_test_top", "KEY", spiif_);
    run_test("spi_test");
  end
  /* bind SLAVE spi_SVA sva_instance (
      spiif_.A,
      spiif_.B,
      spiif_.cin,
      spiif_.serial_in,
      spiif_.red_op_A,
      spiif_.red_op_B,
      spiif_.opcode,
      spiif_.bypass_A,
      spiif_.bypass_B,
      clk,
      spiif_.rst,
      spiif_.direction,
      spiif_.leds,
      spiif_.out
  ); */
endmodule
