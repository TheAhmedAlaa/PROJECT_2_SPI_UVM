import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_test_pkg::*;
import config_pkgg::*;
module top ();
  bit clk;
  initial begin
    clk = 0;
    forever begin
      #10 clk = ~clk;
    end
  end
  ramif ramif_ (clk);
  RAM DUT (
      ramif_.din,
      clk,
      ramif_.rst_n,
      ramif_.rx_valid,
      ramif_.dout,
      ramif_.tx_valid
  );
  RAM_GM RAM_GM_ (
      ramif_.din,
      clk,
      ramif_.rst_n,
      ramif_.rx_valid,
      ramif_.dout_exp,
      ramif_.tx_valid_exp
  );
  initial begin
    uvm_config_db#(virtual ramif)::set(null, "uvm_test_top", "KEY", ramif_);
    run_test("ram_test");
  end
  bind RAM ram_SVA sva_instance (
      ramif_.din,
      clk,
      ramif_.rst_n,
      ramif_.rx_valid,
      ramif_.dout,
      ramif_.tx_valid
  );
endmodule
