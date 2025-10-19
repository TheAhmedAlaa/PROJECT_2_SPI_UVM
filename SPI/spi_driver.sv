package spi_driver_pkg;
  import uvm_pkg::*;
  import config_pkgg::*;
  import spi_seq_item_pkg::*;
  `include "uvm_macros.svh"
  class spi_driver extends uvm_driver #(spi_seq_item);
    `uvm_component_utils(spi_driver)
    virtual spiif  spi_driver_vif;
    spi_config_obj spi_config_obj_driver;
    spi_seq_item   seq_item;
    function new(string name = "spi_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        seq_item = spi_seq_item::type_id::create("seq_item_driver");
        seq_item_port.get_next_item(seq_item);
        spi_driver_vif.MOSI     = seq_item.MOSI;
        spi_driver_vif.rst_n    = seq_item.rst_n;
        spi_driver_vif.SS_n     = seq_item.SS_n;
        spi_driver_vif.tx_data  = seq_item.tx_data;
        spi_driver_vif.tx_valid = seq_item.tx_valid;
        @(negedge spi_driver_vif.clk);
        seq_item_port.item_done();
      end
    endtask
  endclass
endpackage
