package spi_monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import spi_seq_item_pkg::*;
  class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor);
    virtual spiif spi_monitor_if;
    spi_seq_item seq_item;
    uvm_analysis_port #(spi_seq_item) mon_ap;
    function new(string name = "spi_monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap", this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        seq_item = spi_seq_item::type_id::create("seq_item_spi");
        //we must sample the outputs of the DUT
        @(negedge spi_monitor_if.clk);
        seq_item.MOSI     = spi_monitor_if.MOSI;
        seq_item.rst_n    = spi_monitor_if.rst_n;
        seq_item.MISO     = spi_monitor_if.MISO;
        seq_item.rx_data  = spi_monitor_if.rx_data;
        seq_item.rx_valid = spi_monitor_if.rx_valid;
        seq_item.tx_data  = spi_monitor_if.tx_data;
        seq_item.tx_valid = spi_monitor_if.tx_valid;
        seq_item.SS_n     = spi_monitor_if.SS_n;
        mon_ap.write(seq_item);
        //also at the same time sample the outputs of the GOLDEN MODEL
        seq_item.rx_data_exp = spi_monitor_if.rx_data_exp;
        seq_item.rx_valid_exp = spi_monitor_if.rx_valid_exp;
        seq_item.MISO_exp = spi_monitor_if.MISO_exp;
        `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH);
      end
    endtask
  endclass
endpackage
