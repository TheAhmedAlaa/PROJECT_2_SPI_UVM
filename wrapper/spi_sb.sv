package spi_sb_pkg;
  import config_pkg_spi::*;
  import spi_seq_item_pkg::*;
  import uvm_pkg::*;
  import spi_agent_pkg::*;
  import seq_rand_pkg::*;
  `include "uvm_macros.svh"
  class spi_sb extends uvm_scoreboard;
    `uvm_component_utils(spi_sb);
    uvm_analysis_export #(spi_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(spi_seq_item) sb_fifo;
    spi_seq_item seq_item;
    int error_count = 0;
    int correct_count = 0;
    function new(string name = "scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_fifo   = new("sb_fifo", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(sb_fifo.analysis_export);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        sb_fifo.get(seq_item);
        if (seq_item.rx_data != seq_item.rx_data_exp || seq_item.rx_valid != seq_item.rx_valid_exp||seq_item.MISO!=seq_item.MISO_exp) begin
          `uvm_error("run_phase", $sformatf(
                     "comparason failed,DUT_transaction=%s refrence data=0b%0b refrence rx_valid=0b%0b refrence MISO=0b%0b",
                     seq_item.convert2string(),
                     seq_item.rx_data_exp,
                     seq_item.rx_valid_exp,
                     seq_item.MISO_exp
                     ));
          error_count = error_count + 1;
        end else begin
          correct_count = correct_count + 1;
        end
      end
    endtask
    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info("report_phase", $sformatf("Total correct:%d", correct_count), UVM_MEDIUM);
      `uvm_info("report_phase", $sformatf("Total false:%d", error_count), UVM_MEDIUM);
    endfunction
  endclass
endpackage
