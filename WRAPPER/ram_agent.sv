package ram_agent_pkg;
  import uvm_pkg::*;
  import ram_driver_pkg::*;
  import config_pkg_ram::*;
  import ram_sequencer_pkg::*;
  import ram_monitor_pkg::*;
  import ram_seq_item_pkg::*;
  `include "uvm_macros.svh"
  class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)
    ram_sequencer sqr;
    ram_driver drv;
    ram_config_obj cnfg;
    ram_monitor mon;
    uvm_analysis_port #(ram_seq_item) agt_ap;
    function new(string name = "ram_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt_ap = new("agt_ap", this);
      if (~uvm_config_db#(ram_config_obj)::get(this, "", "RAM", cnfg)) begin
        `uvm_fatal("build_phase", "unable to conf");
      end
      if (cnfg.is_active == UVM_ACTIVE) begin
        sqr = ram_sequencer::type_id::create("sqr", this);
        drv = ram_driver::type_id::create("drv", this);
      end
      mon = ram_monitor::type_id::create("mon", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mon.ram_monitor_if = cnfg.ram_config_vif;
      if (cnfg.is_active == UVM_ACTIVE) begin
        drv.seq_item_port.connect(sqr.seq_item_export);
        drv.ram_driver_vif = cnfg.ram_config_vif;
      end
      mon.mon_ap.connect(agt_ap);
    endfunction
  endclass
endpackage
