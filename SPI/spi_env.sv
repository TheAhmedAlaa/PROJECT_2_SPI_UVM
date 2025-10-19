package spi_env_pkg;
  import uvm_pkg::*;
  import spi_driver_pkg::*;
  import config_pkgg::*;
  import sequencer_pkg::*;
  import spi_monitor_pkg::*;
  import spi_seq_item_pkg::*;
  import spi_agent_pkg::*;
  import sb_pkg::*;
  //import sb_pkg::*;
  import cvg_pkg::*;
  `include "uvm_macros.svh"
  class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)
    spi_agent agent;
    spi_cover_gp cgp;
    spi_seq_item seq_item;
    spi_sb sb;
    function new(string name = "spi_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction  //new()
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agent = spi_agent::type_id::create("agent", this);
      sb = spi_sb::type_id::create("sb", this);
      cgp = spi_cover_gp::type_id::create("cgp", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.agt_ap.connect(sb.sb_export);
      agent.agt_ap.connect(cgp.cgp_export);
    endfunction
  endclass
endpackage
