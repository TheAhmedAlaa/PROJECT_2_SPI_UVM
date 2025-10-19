package seq_wr_rd_only_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ram_seq_item_pkg::*;
  class seq_wr_rd_only extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(seq_wr_rd_only);
    ram_seq_item seq_item;
    function new(string name = "seq_wr_rd_only");
      super.new(name);
    endfunction
    task body;
      seq_item = ram_seq_item::type_id::create("seq_item_wr_rd_only");
      repeat (10000) begin
        start_item(seq_item);
        seq_item.write_only_seq.constraint_mode(0);
        seq_item.read_only_seq.constraint_mode(0);
        seq_item.wr_rd_seq.constraint_mode(1);
        assert (seq_item.randomize());
        finish_item(seq_item);
      end
    endtask
  endclass
endpackage
