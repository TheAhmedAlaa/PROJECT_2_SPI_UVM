package cvg_pkg;
  import config_pkg_wrapper::*;
  import wrapper_seq_item_pkg::*;
  import uvm_pkg::*;
  import wrapper_agent_pkg::*;
  `include "uvm_macros.svh"
  class wrapper_cover_gp extends uvm_component;
    `uvm_component_utils(wrapper_cover_gp);
    uvm_analysis_export #(wrapper_seq_item) cgp_export;
    uvm_tlm_analysis_fifo #(wrapper_seq_item) cgp_fifo;
    wrapper_seq_item seq_item;
    covergroup cvr_gp;
    ///MORE COVERAGE IF NEEDED
    endgroup : cvr_gp
    function new(string name = "cgp", uvm_component parent = null);
      super.new(name, parent);
      cvr_gp = new();
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cgp_export = new("cgp_export", this);
      cgp_fifo   = new("cgp_fifo", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      cgp_export.connect(cgp_fifo.analysis_export);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        cgp_fifo.get(seq_item);
        cvr_gp.sample();
      end
    endtask
  endclass

endpackage
