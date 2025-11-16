package ram_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class ram_seq_item extends uvm_sequence_item;
    `uvm_object_utils(ram_seq_item)
    logic [9:0] din;
    rand logic rst_n, rx_valid;
    logic tx_valid;
    logic [7:0] dout;
    rand logic [7:0] data;
    rand logic [1:0] seq;
    logic wr_data, rd_data, rd_add_, wr_data_done;
    logic [7:0] dout_exp;
    logic tx_valid_exp;
    function new(string name = "ram_seq_item");
      super.new(name);
      wr_data = 0;
      wr_data_done = 0;
      rd_add_ = 0;
      rd_data = 0;
    endfunction
    constraint cons {
      rst_n dist {
        1 := 98,
        0 := 2
      };
      rx_valid dist {
        1 := 80,
        0 := 20
      };
    }
    constraint cons_ {
      if (wr_data) seq inside {2'b00, 2'b01};
      if (wr_data_done)
      seq dist {
        2'b00 := 40,
        2'b10 := 60
      };
      if (rd_add_) seq inside {2'b11};
      if (rd_data)
      seq dist {
        2'b00 := 60,
        2'b10 := 40
      };
    }
    function void post_randomize();
      din = {seq, data};
      if (seq == 2'b00) begin
        wr_data = 1;
        wr_data_done = 0;
      end else if (seq == 2'b01) begin
        wr_data = 0;
        wr_data_done = 1;
      end else begin
        wr_data = 0;
        wr_data_done = 0;
      end  //wr_handle
      if (seq == 2'b10) begin
        rd_add_ = 1;
        rd_data = 0;
      end else if (seq == 2'b11) begin
        rd_data = 1;
        rd_add_ = 0;
      end else begin
        rd_add_ = 0;
        rd_data = 0;
      end
    endfunction
    function string convert2string();
      return $sformatf(
          "%s din=%0d, rst_n=0b%0b,rx_valid=0b%0b, tx_valid=0b%0b, dout=0b%0b",
          super.convert2string(),
          din,
          rst_n,
          rx_valid,
          tx_valid,
          dout,
      );
    endfunction
    function string convert2string_stimulus();
      return $sformatf(
          "din=%0d, rst_n=%0b,rx_valid=0b%0b, tx_valid=0b%0b, dout=0b%0b",
          din,
          rst_n,
          rx_valid,
          tx_valid,
          dout,
      );
    endfunction
  endclass
endpackage
