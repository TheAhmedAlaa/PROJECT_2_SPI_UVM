package spi_seq_item_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  class spi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item)
    rand bit tx_valid;
    rand bit rst_n;
    rand bit [10:0] array_;
    bit [10:0] prev_array;
    bit [10:0] array_data;
    bit SS_n;
    bit MOSI;
    bit is_read;
    rand logic [7:0] tx_data;
    logic MISO, rx_valid, rx_valid_exp, MISO_exp;
    logic [9:0] rx_data, rx_data_exp;
    int counter;
    int index;
    bit communication;
    function new(string name = "spi_seq_item");
      super.new(name);
      counter = 0;
      index = 10;
      communication = 0;
      array_data = array_;
    endfunction
    constraint array__ {
      {array_[10], array_[9], array_[8]} inside {3'b000, 3'b001, 3'b110, 3'b111};
      array_ != prev_array;
    }
    constraint reset {
      rst_n dist {
        1 := 98,
        0 := 2
      };
    }
    function void pre_randomize();
      if (SS_n) begin
        array_data = array_;
        prev_array = array_;
      end
      is_read = ({array_data[10], array_data[9], array_data[8]} == 3'b111);  //indicates that it is reading 
      SS_n = ~communication;  //every time i change my array if there is a transition in SS_n
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
      if (is_read) begin
        tx_valid = 1;
      end else tx_valid = 0;
      if (~SS_n) begin
        if (index >= 0) begin
          MOSI  = array_data[index];
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
          "%s MOSI=%0d, MISO=%0b, SS_n=0b%0b, rst_n=0b%0b, rx_data=0b%0b, rx_valid=0b%0b, tx_data=0b%0b, tx_valid=0b%0b",
          super.convert2string(),
          MOSI,
          MISO,
          SS_n,
          rst_n,
          rx_data,
          rx_valid,
          tx_data,
          tx_valid
      );
    endfunction
    function string convert2string_stimulus();
      return $sformatf(
          "MOSI=%0d, MISO=%0b, SS_n=0b%0b, rst_n=0b%0b, rx_data=0b%0b, rx_valid=0b%0b, tx_data=0b%0b, tx_valid=0b%0b",
          MOSI,
          MISO,
          SS_n,
          rst_n,
          rx_data,
          rx_valid,
          tx_data,
          tx_valid
      );
    endfunction
  endclass
endpackage
