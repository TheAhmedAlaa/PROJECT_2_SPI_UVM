package ram_sb_pkg;
  import config_pkg_ram::*;
  import ram_seq_item_pkg::*;
  import uvm_pkg::*;
  import ram_agent_pkg::*;
  import seq_rand_pkg::*;
  `include "uvm_macros.svh"
  class ram_sb extends uvm_scoreboard;
    `uvm_component_utils(ram_sb);
    uvm_analysis_export #(ram_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
    ram_seq_item seq_item;
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
        if (seq_item.dout != seq_item.dout_exp || seq_item.tx_valid != seq_item.tx_valid_exp) begin
          `uvm_error("run_phase", $sformatf(
                     "comparason failed,DUT_transaction=%s dout_ref=0b%0b refrence tx_valid=0b%0b",
                     seq_item.convert2string(),
                     seq_item.dout_exp,
                     seq_item.tx_valid_exp,
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
