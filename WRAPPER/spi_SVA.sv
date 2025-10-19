module spi_SVA(
    MOSI,
    MISO,
    SS_n,
    clk,
    rst_n,
    rx_data,
    rx_valid,
    tx_data,
    tx_valid
);

  input logic MOSI, clk, rst_n, SS_n, tx_valid;
  input  logic [7:0] tx_data;
  input   logic [9:0] rx_data;
  input  logic rx_valid, MISO;
  property rst_n_prop;
    @(posedge clk) !rst_n |=> {
      ~MISO && ~rx_valid && ~rx_data
    };
  endproperty
  property VALID_wr_add_seq;
    @(posedge clk) disable iff (!rst_n) ($fell(
        SS_n
    ) ##1((!MOSI)) [* 3]) |-> ##10 (rx_valid && SS_n);
  endproperty
  property VALID_wr_data_seq;
    @(posedge clk) disable iff (!rst_n) ($fell(
        SS_n
    ) ##1($past(
        !MOSI
    )) [* 2] ##1 ($past(
        MOSI
    ))) |-> ##10 (rx_valid && SS_n);
  endproperty
property VALID_rd_add_seq;
@(posedge clk) disable iff (!rst_n)
 ($fell(SS_n) ##1 (MOSI) ##1 (MOSI) ##1 (!MOSI) ) |=> ##10 (rx_valid  && $rose(SS_n)[->1]);
endproperty
   property VALID_rd_data_seq;
    @(posedge clk) disable iff (!rst_n)($fell(SS_n) ##1 (MOSI) ##1 (MOSI) ##1 (MOSI) ) |=> ##10 (rx_valid  && $rose(SS_n)[->1]);
     endproperty
  property first;
  disable iff (!rst_n) 
    @(posedge clk) (cs == IDLE && !SS_n) |-> (ns == CHK_CMD);
  endproperty
  property sec;
  disable iff (!rst_n) 
    @(posedge clk) cs == CHK_CMD |-> ns == WRITE || READ_ADD || READ_DATA;
  endproperty
  property third;
  disable iff (!rst_n) 
    @(posedge clk) (cs == WRITE && SS_n) |-> ns == IDLE;
  endproperty
  property forth;
  disable iff (!rst_n) 
    @(posedge clk) cs == READ_ADD && SS_n |-> ns == IDLE;
  endproperty
  property fifth;
  disable iff (!rst_n) 
    @(posedge clk) cs == READ_DATA && SS_n |-> ns == IDLE;
  endproperty
  ASSRT_rst_n_prop :
  assert property (rst_n_prop)
  else $error("ASSERT rst_n_prop failed at time %0t", $time);
  COVER_rst_n_prop :
  cover property (rst_n_prop);

  ASSRT_VALID_wr_add_seq :
  assert property (VALID_wr_add_seq)
  else $error("ASSERT VALID_wr_add_seq failed at time %0t", $time);
  COVER_VALID_wr_add_seq :
  cover property (VALID_wr_add_seq);

  ASSRT_VALID_wr_data_seq :
  assert property (VALID_wr_data_seq)
  else $error("ASSERT VALID_wr_data_seq failed at time %0t", $time);
  COVER_VALID_wr_data_seq :
  cover property (VALID_wr_data_seq);

  ASSRT_VALID_rd_add_seq :
  assert property (VALID_rd_add_seq)
  else $error("ASSERT VALID_rd_add_seq failed at time %0t", $time);
  COVER_VALID_rd_add_seq :
  cover property (VALID_rd_add_seq);

  ASSRT_VALID_rd_data_seq :
  assert property (VALID_rd_data_seq)
  else $error("ASSERT VALID_rd_data_seq failed at time %0t", $time);
  COVER_VALID_rd_data_seq :
  cover property (VALID_rd_data_seq);

  ASSRT_first :
  assert property (first)
  else $error("ASSERT first (IDLE -> CHK_CMD) failed at time %0t", $time);
  COVER_first :
  cover property (first);

  ASSRT_sec :
  assert property (sec)
  else $error("ASSERT sec (CHK_CMD -> WRITE|READ_ADD|READ_DATA) failed at time %0t", $time);
  COVER_sec :
  cover property (sec);

  ASSRT_third :
  assert property (third)
  else $error("ASSERT third (WRITE -> IDLE) failed at time %0t", $time);
  COVER_third :
  cover property (third);

  ASSRT_forth :
  assert property (forth)
  else $error("ASSERT forth (READ_ADD -> IDLE) failed at time %0t", $time);
  COVER_forth :
  cover property (forth);

  ASSRT_fifth :
  assert property (fifth)
  else $error("ASSERT fifth (READ_DATA -> IDLE) failed at time %0t", $time);
  COVER_fifth :
  cover property (fifth);
  endmodule