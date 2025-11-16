package wrapper_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(wrapper_seq_item)
    logic MOSI;
    rand logic SS_n;
    rand logic rst_n;
    logic MISO, MISO_exp;
    logic [7:0] dout_exp;
    rand bit [7:0] array_;
    bit [10:0] array_final, prev_array;
    rand bit [2:0] state;
    bit is_read;
    bit wr_add;
    bit wr_data;
    bit rd_add, wr_data_done, rd_add_, rd_data;
    int counter;
    bit communication;
    int index;
    constraint write_only_seq {state inside {3'b000, 3'b001};}
    constraint read_only_seq {
      if (rd_add_)
      state inside {3'b111};
      else
      if (rd_data)
      state inside {3'b110};
      else
      state inside {3'b111, 3'b110};
    }
    constraint wr_rd_seq {
      if (wr_data) state inside {3'b000, 3'b001};
      if (wr_data_done)
      state dist {
        3'b000 := 40,
        3'b110 := 60
      };
      if (rd_add_) state inside {3'b111};
      if (rd_data)
      state dist {
        3'b000 := 60,
        3'b110 := 40
      };
    }
    function new(string name = "wrapper_seq_item");
      super.new(name);
    endfunction
    constraint rst_n_cons {
      rst_n dist {
        1 := 98,
        0 := 2
      };
    }
    constraint SS_n_high {SS_n == (!communication);}
    function void post_randomize();
      if (SS_n) begin
        array_final = {state, array_};
        if (state == 3'b111) begin
          is_read = 1;
        end else is_read = 0;
      end
      //STATE SEQ_HANDLE
      if (state == 3'b000) begin
        wr_data = 1;
        wr_data_done = 0;
      end else if (state == 3'b001) begin
        wr_data = 0;
        wr_data_done = 1;
      end else begin
        wr_data = 0;
        wr_data_done = 0;
      end  //wr_handle
      if (state == 3'b110) begin
        rd_add_ = 1;
        rd_data = 0;
      end else if (state == 3'b111) begin
        rd_data = 1;
        rd_add_ = 0;
      end else begin
        rd_add_ = 0;
        rd_data = 0;
      end
      //SS_n handle
      if (is_read) begin
        if (counter == 23) begin
          communication = 0;
          counter = 0;
        end else begin
          communication = 1;
          counter++;
        end
      end else begin
        if (counter == 13) begin
          communication = 0;
          counter = 0;
        end else begin
          communication = 1;
          counter++;
        end
      end
      //MOSI HANDLE
      if (~SS_n) begin
        if (index >= 0) begin
          MOSI  = array_final[index];
          index = index - 1;
        end else begin
          MOSI  = 0;
          index = 10;
        end
      end else begin
        MOSI  = 0;
        index = 10;
      end
    endfunction
    function string convert2string();
      return $sformatf(
          "%s MOSI=%0d, rst_n=0b%0b,SS_n=0b%0b,MISO=0b%0b",
          super.convert2string(),
          MOSI,
          rst_n,
          SS_n,
          MISO,
      );
    endfunction
    function string convert2string_stimulus();
      return $sformatf("MOSI=%0d, rst_n=%0b,SS_n=0b%0b, MISO=0b%0b", MOSI, rst_n, SS_n, MISO,);
    endfunction
  endclass
endpackage
