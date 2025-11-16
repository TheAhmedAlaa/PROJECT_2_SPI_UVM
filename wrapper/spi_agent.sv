package spi_agent_pkg;
  import uvm_pkg::*;
  import spi_driver_pkg::*;
  import config_pkg_spi::*;
  import spi_sequencer_pkg::*;
  import spi_monitor_pkg::*;
  import spi_seq_item_pkg::*;
  `include "uvm_macros.svh"
  class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)
    spi_sequencer sqr;
    spi_driver drv;
    spi_config_obj cnfg;
    spi_monitor mon;
    uvm_analysis_port #(spi_seq_item) agt_ap;
    function new(string name = "spi_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt_ap = new("agt_ap", this);
      if (~uvm_config_db#(spi_config_obj)::get(this, "", "SPI", cnfg)) begin
        `uvm_fatal("build_phase", "unable to conf");
      end
      if (cnfg.is_active == UVM_ACTIVE) begin
        sqr = spi_sequencer::type_id::create("sqr", this);
        drv = spi_driver::type_id::create("drv", this);
      end
      mon = spi_monitor::type_id::create("mon", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mon.spi_monitor_if = cnfg.spi_config_vif;
      if (cnfg.is_active == UVM_ACTIVE) begin
        drv.spi_driver_vif = cnfg.spi_config_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
      end
      mon.mon_ap.connect(agt_ap);
    endfunction
  endclass
endpackage
