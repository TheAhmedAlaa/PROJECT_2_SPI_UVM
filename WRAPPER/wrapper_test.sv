package wrapper_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import spi_env_pkg::*;
  import ram_env_pkg::*;
  import wrapper_env_pkg::*;
  import config_pkg_ram::*;
  import seq_rand_pkg::*;
  import config_pkg_spi::*;
  import config_pkg_wrapper::*;
  import seq_wr_only_pkg::*;
  import seq_rd_only_pkg::*;
  import seq_rst_pkg::*;
  import seq_wr_rd_only_pkg::*;
  class wrapper_test extends uvm_test;
    `uvm_component_utils(wrapper_test)
    spi_env spi_env_comp;
    ram_env ram_env_comp;
    wrapper_env wrapper_env_comp;
    spi_config_obj spi_config_obj_test;
    ram_config_obj ram_config_obj_test;
    wrapper_config_obj wrapper_config_obj_test;
    //seq_rand randd;
    seq_rst seq_rst_;
    seq_wr_only seq_wr_only_;
    seq_rd_only seq_rd_only_;
    seq_wr_rd_only seq_wr_rd_only_;
    function new(string name = "wrapper_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      spi_env_comp = spi_env::type_id::create("spi_env_comp", this);
      ram_env_comp = ram_env::type_id::create("ram_env_comp", this);
      wrapper_env_comp = wrapper_env::type_id::create("wrapper_env_comp", this);
      spi_config_obj_test = spi_config_obj::type_id::create("spi_config_comp", this);
      ram_config_obj_test = ram_config_obj::type_id::create("ram_config_comp", this);
      wrapper_config_obj_test = wrapper_config_obj::type_id::create("wrapper_config_comp", this);
      spi_config_obj_test.is_active = UVM_PASSIVE;
      ram_config_obj_test.is_active = UVM_PASSIVE;
      wrapper_config_obj_test.is_active = UVM_ACTIVE;
      //randd = seq_rand::type_id::create("randd");
      seq_rst_ = seq_rst::type_id::create("rst");
      seq_wr_only_ = seq_wr_only::type_id::create("wr");
      seq_rd_only_ = seq_rd_only::type_id::create("rd");
      seq_wr_rd_only_ = seq_wr_rd_only::type_id::create("seq_wr_rd");
      if (~uvm_config_db#(virtual spiif)::get(this, "", "SPI", spi_config_obj_test.spi_config_vif))
        `uvm_fatal("build_phase", "Test -Unable to get into virtual interface_spi");
      if (~uvm_config_db#(virtual ramif)::get(this, "", "RAM", ram_config_obj_test.ram_config_vif))
        `uvm_fatal("build_phase", "Test -Unable to get into virtual interface_ram");
      if (~uvm_config_db#(virtual wrapperif)::get(
              this, "", "wrapper", wrapper_config_obj_test.wrapper_config_vif
          ))
        `uvm_fatal("build_phase", "Test -Unable to get into virtual interface_wrapper");
      uvm_config_db#(spi_config_obj)::set(this, "*", "SPI", spi_config_obj_test);
      uvm_config_db#(ram_config_obj)::set(this, "*", "RAM", ram_config_obj_test);
      uvm_config_db#(wrapper_config_obj)::set(this, "*", "wrapper", wrapper_config_obj_test);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase", "rst_begin", UVM_LOW);
      seq_rst_.start(wrapper_env_comp.agent.sqr);
      `uvm_info("run_phase", "rst_end", UVM_LOW);
      `uvm_info("run_phase", "wr_begin", UVM_LOW);
      seq_wr_only_.start(wrapper_env_comp.agent.sqr);
      `uvm_info("run_phase", "wr_end", UVM_LOW);
      `uvm_info("run_phase", "rd_begin", UVM_LOW);
      seq_rd_only_.start(wrapper_env_comp.agent.sqr);
      `uvm_info("run_phase", "rd_end", UVM_LOW);
      `uvm_info("run_phase", "wr_rd_begin", UVM_LOW);
      seq_wr_rd_only_.start(wrapper_env_comp.agent.sqr);
      `uvm_info("run_phase", "wr_rd_end", UVM_LOW);
      /*  `uvm_info("run_phase", "rannd_begin", UVM_LOW);
     randd.start(wrapper_env_comp.agent.sqr);
      `uvm_info("run_phase", "rannd_end", UVM_LOW);*/
      phase.drop_objection(this);
    endtask
  endclass
endpackage
