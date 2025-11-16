package ram_env_pkg;
  import uvm_pkg::*;
  import ram_driver_pkg::*;
  import config_pkg_ram::*;
  import ram_sequencer_pkg::*;
  import ram_monitor_pkg::*;
  import ram_seq_item_pkg::*;
  import ram_agent_pkg::*;
  import ram_sb_pkg::*;
  import ram_cvg_pkg::*;
  `include "uvm_macros.svh"
  class ram_env extends uvm_env;
    `uvm_component_utils(ram_env)
    ram_agent agent;
    ram_cover_gp cgp;
    ram_seq_item seq_item;
    ram_sb sb;
    function new(string name = "ram_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = ram_agent::type_id::create("agent", this);
      sb = ram_sb::type_id::create("sb", this);
      cgp = ram_cover_gp::type_id::create("cgp", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.agt_ap.connect(sb.sb_export);
      agent.agt_ap.connect(cgp.cgp_export);
    endfunction
  endclass
endpackage
