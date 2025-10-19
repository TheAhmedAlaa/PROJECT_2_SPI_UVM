package config_pkg_ram;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class ram_config_obj extends uvm_object;
    `uvm_object_utils(ram_config_obj);
    virtual ramif ram_config_vif;
    uvm_active_passive_enum is_active;
    function new(string name = "ram_config");
      super.new(name);
    endfunction  //new()
  endclass
endpackage
