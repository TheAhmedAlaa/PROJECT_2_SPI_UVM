package seq_wr_only_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wrapper_seq_item_pkg::*;
  class seq_wr_only extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(seq_wr_only);
    wrapper_seq_item seq_item;
    function new(string name = "seq_wr_only");
      super.new(name);
    endfunction
    task body;
      seq_item = wrapper_seq_item::type_id::create("seq_item_wr_only");
      repeat (10000) begin
        start_item(seq_item);
        if (seq_item.counter == 0) begin
          seq_item.write_only_seq.constraint_mode(1);
          seq_item.read_only_seq.constraint_mode(0);
          seq_item.wr_rd_seq.constraint_mode(0);
        end else begin
          seq_item.write_only_seq.constraint_mode(0);
          seq_item.read_only_seq.constraint_mode(0);
          seq_item.wr_rd_seq.constraint_mode(0);
        end
        assert (seq_item.randomize());
        finish_item(seq_item);
      end
    endtask
  endclass  //seq_wr_only
endpackage
