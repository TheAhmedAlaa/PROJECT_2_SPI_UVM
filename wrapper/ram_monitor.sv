package ram_monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ram_seq_item_pkg::*;
  class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor);
    virtual ramif ram_monitor_if;
    ram_seq_item seq_item;
    uvm_analysis_port #(ram_seq_item) mon_ap;
    function new(string name = "ram_monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap", this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        seq_item = ram_seq_item::type_id::create("seq_item_ram");
        //we must sample the outputs of the DUT
        @(negedge ram_monitor_if.clk);
        seq_item.din      = ram_monitor_if.din;
        seq_item.rst_n    = ram_monitor_if.rst_n;
        seq_item.rx_valid = ram_monitor_if.rx_valid;
        seq_item.dout     = ram_monitor_if.dout;
        seq_item.tx_valid = ram_monitor_if.tx_valid;
        mon_ap.write(seq_item);
        //also at the same time sample the outputs of the GOLDEN MODEL
        seq_item.tx_valid_exp = ram_monitor_if.tx_valid_exp;
        seq_item.dout_exp = ram_monitor_if.dout_exp;
        `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH);
      end
    endtask
  endclass
endpackage
