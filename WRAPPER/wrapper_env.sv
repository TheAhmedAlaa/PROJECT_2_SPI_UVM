package wrapper_env_pkg;
  import uvm_pkg::*;
  import wrapper_driver_pkg::*;
  import config_pkg_wrapper::*;
  import sequencer_pkg::*;
  import wrapper_monitor_pkg::*;
  import wrapper_seq_item_pkg::*;
  import wrapper_agent_pkg::*;
  import sb_pkg::*;
  //import sb_pkg::*;
  import cvg_pkg::*;
  `include "uvm_macros.svh"
  class wrapper_env extends uvm_env;
    `uvm_component_utils(wrapper_env)
    wrapper_agent agent;
    wrapper_cover_gp cgp;
    wrapper_seq_item seq_item;
    wrapper_sb sb;
    function new(string name = "wrapper_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = wrapper_agent::type_id::create("agent", this);
      sb = wrapper_sb::type_id::create("sb", this);
      cgp = wrapper_cover_gp::type_id::create("cgp", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.agt_ap.connect(sb.sb_export);
      agent.agt_ap.connect(cgp.cgp_export);
    endfunction
  endclass
endpackage
