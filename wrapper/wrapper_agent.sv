package wrapper_agent_pkg;
  import uvm_pkg::*;
  import wrapper_driver_pkg::*;
  import config_pkg_wrapper::*;
  import wrapper_sequencer_pkg::*;
  import wrapper_monitor_pkg::*;
  import wrapper_seq_item_pkg::*;
  `include "uvm_macros.svh"
  class wrapper_agent extends uvm_agent;
    `uvm_component_utils(wrapper_agent)
    wrapper_sequencer sqr;
    wrapper_driver drv;
    wrapper_config_obj cnfg;
    wrapper_monitor mon;
    uvm_analysis_port #(wrapper_seq_item) agt_ap;
    function new(string name = "wrapper_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt_ap = new("agt_ap", this);
      if (~uvm_config_db#(wrapper_config_obj)::get(this, "", "wrapper", cnfg)) begin
        `uvm_fatal("build_phase", "unable to conf");
      end
      if (cnfg.is_active == UVM_ACTIVE) begin
        sqr = wrapper_sequencer::type_id::create("sqr", this);
        drv = wrapper_driver::type_id::create("drv", this);
      end
      mon = wrapper_monitor::type_id::create("mon", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mon.wrapper_monitor_if = cnfg.wrapper_config_vif;
      if (cnfg.is_active == UVM_ACTIVE) begin
        drv.seq_item_port.connect(sqr.seq_item_export);
        drv.wrapper_driver_vif = cnfg.wrapper_config_vif;
      end
      mon.mon_ap.connect(agt_ap);
    endfunction
  endclass
endpackage
