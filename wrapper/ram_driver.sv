package ram_driver_pkg;
  import uvm_pkg::*;
  import config_pkg_ram::*;
  import ram_seq_item_pkg::*;
  `include "uvm_macros.svh"
  class ram_driver extends uvm_driver #(ram_seq_item);
    `uvm_component_utils(ram_driver)
    virtual ramif  ram_driver_vif;
    ram_config_obj ram_config_obj_driver;
    ram_seq_item   seq_item;
    function new(string name = "ram_driver", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        seq_item = ram_seq_item::type_id::create("seq_item_driver");
        seq_item_port.get_next_item(seq_item);
        ram_driver_vif.din      = seq_item.din;
        ram_driver_vif.rst_n    = seq_item.rst_n;
        ram_driver_vif.rx_valid = seq_item.rx_valid;
        @(negedge ram_driver_vif.clk);
        seq_item_port.item_done();
      end
    endtask
  endclass
endpackage
