package spi_cvg_pkg;
  import config_pkg_spi::*;
  import spi_seq_item_pkg::*;
  import uvm_pkg::*;
  import spi_agent_pkg::*;
  `include "uvm_macros.svh"
  class spi_cover_gp extends uvm_component;
    `uvm_component_utils(spi_cover_gp);
    uvm_analysis_export #(spi_seq_item) cgp_export;
    uvm_tlm_analysis_fifo #(spi_seq_item) cgp_fifo;
    spi_seq_item seq_item;

    covergroup cvr_gp;
      rx_data_all: coverpoint seq_item.rx_data[9:8] {
        bins wr_add = {0};
        bins wr_data = {2'b01};
        bins read_address = {2'b10};
        bins read_data = {2'b11};
      }
      SS_n_seq: coverpoint seq_item.SS_n {
        bins seq_ = (1 => 0 [* 13] => 1);
        bins seq2_ = (1 => 0 [* 23] => 1);
        bins start_transaction = (1 => 0 => 0 => 0);
      }
      MOSI_SEQ: coverpoint seq_item.MOSI {
        bins write_address = (0 => 0 => 0);
        bins write_data = (0 => 0 => 1);
        bins read_address = (1 => 1 => 0);
        bins read_data = (1 => 1 => 1);
      }
      cross MOSI_SEQ, SS_n_seq{
        option.cross_auto_bin_max = 0;
        bins start_wrdata = binsof (SS_n_seq.start_transaction) && binsof (MOSI_SEQ.write_data);
        bins start_rdadd = binsof (SS_n_seq.start_transaction) && binsof (MOSI_SEQ.read_address);
        bins start_rddata = binsof (SS_n_seq.start_transaction) && binsof (MOSI_SEQ.read_data);
        bins seq_wradd = binsof (SS_n_seq.seq_) && binsof (MOSI_SEQ.write_address);
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
