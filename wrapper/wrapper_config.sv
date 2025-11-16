package config_pkg_wrapper;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class wrapper_config_obj extends uvm_object;
    `uvm_object_utils(wrapper_config_obj);
    virtual wrapperif wrapper_config_vif;
    uvm_active_passive_enum is_active;
    function new(string name = "wrapper_config");
      super.new(name);
    endfunction  //new()
  endclass
endpackage
