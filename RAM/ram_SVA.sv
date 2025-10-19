module ram_SVA (
    din,
    clk,
    rst_n,
    rx_valid,
    dout,
    tx_valid
);
  input [9:0] din;
  input clk, rx_valid, rst_n;
  input reg [7:0] dout;
  input reg tx_valid;
  property rst_n_prop;
    @(posedge clk) !rst_n |=> {~tx_valid&&~dout};
  endproperty
  property assertion_2_tx_valid_low;
  @(posedge clk)
  disable iff(!rst_n&&!rx_valid)
    @(posedge clk) (din[9:8] inside {2'b00,2'b01,2'b10} |=>~tx_valid);
  endproperty
    property tx_valid_high;
  @(posedge clk)
  disable iff(!rst_n)
    @(posedge clk) (din[9:8] inside {2'b11} |=>tx_valid|=>$fell(tx_valid)[->1]);
  endproperty
property wr_seq;
  @(posedge clk)
    disable iff(!rst_n&&!rx_valid)
    (din[9:8] inside{2'b00}) |-> ##[1:$] (din[9:8] inside{2'b01});
  endproperty
    property rd_add_data;
    @(posedge clk)
    disable iff(!rst_n&&!rx_valid)
    (din[9:8] inside{2'b10}) |-> ##[1:$] (din[9:8] inside{2'b11});
  endproperty
      property rd_data_add;
      @(posedge clk)
    disable iff(!rst_n&&!rx_valid)
    (din[9:8] inside{2'b11}) |-> ##[1:$] (din[9:8] inside{2'b10});
  endproperty
  assert_rst_n_prop: assert property (rst_n_prop);
  cover_rst_n_prop:  cover property (rst_n_prop);
  assert_assertion_2_tx_valid_low: assert property (assertion_2_tx_valid_low);
  cover_assertion_2_tx_valid_low:  cover property (assertion_2_tx_valid_low);
  assert_tx_valid_high: assert property (tx_valid_high);
  cover_tx_valid_high:  cover property (tx_valid_high);
  assert_rd_add_data: assert property (rd_add_data);
  cover_rd_add_data:  cover property (rd_add_data);
  assert_rd_data_add: assert property (rd_data_add);
  cover_rd_data_add:  cover property (rd_data_add);
endmodule
