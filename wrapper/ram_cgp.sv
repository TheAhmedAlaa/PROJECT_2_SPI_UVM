package ram_cvg_pkg;
  import config_pkg_ram::*;
  import ram_seq_item_pkg::*;
  import uvm_pkg::*;
  import ram_agent_pkg::*;
  `include "uvm_macros.svh"
  class ram_cover_gp extends uvm_component;
    `uvm_component_utils(ram_cover_gp);
    uvm_analysis_export #(ram_seq_item) cgp_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) cgp_fifo;
    ram_seq_item seq_item;

    covergroup cvr_gp;
      din_check: coverpoint seq_item.din[9:8] {
        bins wr_add = {0};
        bins wr_data = {2'b01};
        bins read_address = {2'b10};
        bins read_data = {2'b11};
        bins trans_WA_WD = {2'b00 -> 2'b01};
        bins trans_RA_RD = {2'b10 -> 2'b11};
        bins trans = {2'b00 -> 2'b01 -> 2'b10 -> 2'b11};
      }
      rx_check: coverpoint seq_item.rx_valid {bins rx_valid_0 = {0}; bins rx_valid_1 = {1};}
      tx_check: coverpoint seq_item.tx_valid {bins tx_valid_0 = {0}; bins tx_valid_1 = {1};}
      cross rx_check, din_check{}
      cross din_check, tx_check{
        option.cross_auto_bin_max = 0;
        bins dinXrx = binsof (tx_check.tx_valid_1) && binsof (din_check.read_data);
      }
    endgroup : cvr_gp
    function new(string name = "cgp", uvm_component parent = null);
      super.new(name, parent);
      cvr_gp = new();
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cgp_export = new("cgp_export", this);
      cgp_fifo   = new("cgp_fifo", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      cgp_export.connect(cgp_fifo.analysis_export);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        cgp_fifo.get(seq_item);
        cvr_gp.sample();
      end
    endtask
  endclass

endpackage
