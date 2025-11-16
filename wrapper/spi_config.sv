package config_pkg_spi;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class spi_config_obj extends uvm_object;
    `uvm_object_utils(spi_config_obj);
    virtual spiif spi_config_vif;
    uvm_active_passive_enum is_active;
    function new(string name = "spi_config");
      super.new(name);
    endfunction  //new()
  endclass
endpackage
