package seq_rst_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wrapper_seq_item_pkg::*;
  class seq_rst extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(seq_rst);
    wrapper_seq_item seq_item;
    function new(string name = "seq_rst");
      super.new(name);
    endfunction
    task body;
      seq_item = wrapper_seq_item::type_id::create("seq_item_rst");
      repeat (100) begin
        start_item(seq_item);
        seq_item.rst_n = 0;
        finish_item(seq_item);
      end
    endtask
  endclass  //seq_rst
endpackage
