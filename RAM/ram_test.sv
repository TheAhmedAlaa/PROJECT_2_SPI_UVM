package ram_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ram_env_pkg::*;
  import config_pkgg::*;
  import seq_rand_pkg::*;
  import seq_rst_pkg::*;
  import seq_wr_only_pkg::*;
  import seq_rd_only_pkg::*;
  import seq_wr_rd_only_pkg::*;
  class ram_test extends uvm_test;
    `uvm_component_utils(ram_test)
    ram_env ram_env_comp;
    ram_config_obj ram_config_obj_test;
   // seq_rand randd;
    seq_rst rst;
    seq_wr_only wr_only;
    seq_rd_only rd_only;
    seq_wr_rd_only wr_rd;
    function new(string name = "ram_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      ram_env_comp = ram_env::type_id::create("ram_env_comp", this);
      ram_config_obj_test = ram_config_obj::type_id::create("ram_config_comp", this);
    //  randd = seq_rand::type_id::create("randd");
    rst = seq_rst::type_id::create("rst");
    wr_only = seq_wr_only::type_id::create("wr_only");
    rd_only = seq_rd_only::type_id::create("rd_only");
    wr_rd = seq_wr_rd_only::type_id::create("wr_rd_only");
      if (~uvm_config_db#(virtual ramif)::get(this, "", "KEY", ram_config_obj_test.ram_config_vif))
        `uvm_fatal("build_phase", "Test -Unable to get into virtual interface");
      uvm_config_db#(ram_config_obj)::set(this, "*", "KEY", ram_config_obj_test);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "begin ", UVM_LOW);
      rst.start(ram_env_comp.agent.sqr);
      wr_only.start(ram_env_comp.agent.sqr);
      rd_only.start(ram_env_comp.agent.sqr);
      wr_rd.start(ram_env_comp.agent.sqr);
      `uvm_info("run_phase", "end", UVM_LOW);
      phase.drop_objection(this);
    endtask
  endclass
endpackage
