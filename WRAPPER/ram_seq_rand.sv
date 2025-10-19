package seq_rand_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ram_seq_item_pkg::*;
  class seq_rand extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(seq_rand);
    ram_seq_item seq_item;
    function new(string name = "seq_rand");
      super.new(name);
    endfunction
    task body;
      seq_item = ram_seq_item::type_id::create("seq_item_rand");
      repeat (10000) begin
        start_item(seq_item);
        assert (seq_item.randomize());
        finish_item(seq_item);
      end
    endtask
  endclass  //seq_rand
endpackage
