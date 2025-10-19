package spi_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import spi_env_pkg::*;
  import config_pkgg::*;
  import seq_rand_pkg::*;
  import seq_rst_pkg::*;
  class spi_test extends uvm_test;
    `uvm_component_utils(spi_test)
    spi_env spi_env_comp;
    spi_config_obj spi_config_obj_test;
    seq_rand randd;
    seq_rst rst;
    function new(string name = "spi_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      spi_env_comp = spi_env::type_id::create("spi_env_comp", this);
      spi_config_obj_test = spi_config_obj::type_id::create("spi_config_comp", this);
      randd = seq_rand::type_id::create("randd");
      rst = seq_rst::type_id::create("rst");
      if (~uvm_config_db#(virtual spiif)::get(this, "", "KEY", spi_config_obj_test.spi_config_vif))
        `uvm_fatal("build_phase", "Test -Unable to get into virtual interface");
      uvm_config_db#(spi_config_obj)::set(this, "*", "KEY", spi_config_obj_test);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "rannd_begin", UVM_LOW);
      rst.start(spi_env_comp.agent.sqr);
      `uvm_info("run_phase", "rst_end", UVM_LOW);
      `uvm_info("run_phase", "rannd_begin", UVM_LOW);
      randd.start(spi_env_comp.agent.sqr);
      `uvm_info("run_phase", "rannd_end", UVM_LOW);
      phase.drop_objection(this);
    endtask
  endclass
endpackage
