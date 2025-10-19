package wrapper_monitor_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wrapper_seq_item_pkg::*;
  class wrapper_monitor extends uvm_monitor;
    `uvm_component_utils(wrapper_monitor);
    virtual wrapperif wrapper_monitor_if;
    wrapper_seq_item seq_item;
    uvm_analysis_port #(wrapper_seq_item) mon_ap;
    function new(string name = "wrapper_monitor", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap", this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        seq_item = wrapper_seq_item::type_id::create("seq_item_wrapper");
        //we must sample the outputs of the DUT
        @(negedge wrapper_monitor_if.clk);
        seq_item.MOSI      = wrapper_monitor_if.MOSI;
        seq_item.rst_n    = wrapper_monitor_if.rst_n;
        seq_item.SS_n = wrapper_monitor_if.SS_n;
        seq_item.MISO     = wrapper_monitor_if.MISO;
        mon_ap.write(seq_item);
        //also at the same time sample the outputs of the GOLDEN MODEL
        seq_item.MISO_exp = wrapper_monitor_if.MISO_exp;
        `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH);
      end
    endtask
  endclass
endpackage
