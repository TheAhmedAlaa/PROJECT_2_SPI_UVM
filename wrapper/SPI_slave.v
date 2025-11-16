module SLAVE (
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
  input MOSI, clk, rst_n, SS_n, tx_valid;
  input [7:0] tx_data;
  output reg [9:0] rx_data;
  output reg rx_valid, MISO;
  localparam IDLE = 3'b000;
  localparam WRITE = 3'b001;
  localparam CHK_CMD = 3'b010;
  localparam READ_ADD = 3'b011;
  localparam READ_DATA = 3'b100;

  reg [3:0] counter;
  reg       received_address;

  reg [2:0] cs, ns;
  always @(posedge clk) begin
    if (~rst_n) begin
      cs <= IDLE;
    end else begin
      cs <= ns;
    end
  end

  always @(*) begin
    case (cs)
      IDLE: begin
        if (SS_n) ns = IDLE;
        else ns = CHK_CMD;
      end
      CHK_CMD: begin
        if (SS_n) ns = IDLE;
        else begin
          if (~MOSI) ns = WRITE;
          else begin
            if (received_address) ns = READ_DATA;
            else ns = READ_ADD;
          end
        end
      end
      WRITE: begin
        if (SS_n) ns = IDLE;
        else ns = WRITE;
      end
      READ_ADD: begin
        if (SS_n) ns = IDLE;
        else ns = READ_ADD;
      end
      READ_DATA: begin
        if (SS_n) ns = IDLE;
        else ns = READ_DATA;
      end
    endcase
  end

  always @(posedge clk) begin
    if (~rst_n) begin
      rx_data <= 0;
      rx_valid <= 0;
      received_address <= 0;
      MISO <= 0;
    end else begin
      case (cs)
        IDLE: begin
          rx_valid <= 0;
          MISO <= 0;
          rx_data <= 0; //FIX
        end
        CHK_CMD: begin
          counter <= 10;  //making counter =10 as if counter=0 then rx_valid is 1
        end
        WRITE: begin
          if (counter > 0) begin  //this means it needs to write 
            rx_data[counter-1] <= MOSI;  //assign if write  writing address or data
            counter <= counter - 1;
          end else rx_valid <= 1;
        end
        READ_ADD: begin
          if (counter > 0) begin
            rx_data[counter-1] <= MOSI;
            counter <= counter - 1;
          end else begin
            rx_valid <= 1;
            received_address <= 1;
          end
        end
        READ_DATA: begin
          if (tx_valid) begin
            rx_valid <= 0;
            if (counter > 0) begin
              MISO <= tx_data[counter-1];
              counter <= counter - 1;
            end else begin
              received_address <= 0;
            end
          end else begin
            if (counter > 0 && ~rx_valid) begin
              rx_data[counter-1] <= MOSI;
              counter <= counter - 1;
            end else begin
              rx_valid <= 1;
              counter  <= 9;
            end
          end
        end
      endcase
    end
  end
    `ifdef SIM
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
  `endif
endmodule
