module SLAVE_GM (
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
  localparam IDLE = 3'b000;
  localparam WRITE = 3'b001;
  localparam CHK_CMD = 3'b010;
  localparam READ_ADD = 3'b011;
  localparam READ_DATA = 3'b100;
  input MOSI, clk, rst_n, SS_n, tx_valid;
  input [7:0] tx_data;
  output reg [9:0] rx_data;
  output reg rx_valid, MISO;
  reg [3:0] counter;
  reg       ADRESS_RECIVED;  //to diff between read adress and read data 
  reg [2:0] cs, ns;
  // store
  always @(posedge clk) begin
    if (~rst_n) begin
      cs <= IDLE;
    end else begin
      cs <= ns;
    end
  end
  // ns logic
  always @(*) begin
    case (cs)
      IDLE: begin
        if (SS_n) begin
          ns = IDLE;
        end else begin
          ns = CHK_CMD;
        end
      end
      CHK_CMD: begin
        if (SS_n) begin
          ns = IDLE;
        end else if (~SS_n && ~MOSI) begin
          ns = WRITE;
        end else if (~SS_n && MOSI && ~ADRESS_RECIVED) begin
          ns = READ_ADD;
        end else ns = READ_DATA;
      end
      WRITE: begin
        if (SS_n) begin
          ns = IDLE;
        end else ns = WRITE;
      end
      READ_ADD: begin
        if (SS_n) begin
          ns = IDLE;
        end else ns = READ_ADD;
      end
      READ_DATA: begin
        if (SS_n) begin
          ns = IDLE;
        end else ns = READ_DATA;
      end
    endcase
  end
  //output logic
  always @(posedge clk) begin
    if (~rst_n) begin
      rx_data <= 0;
      rx_valid <= 0;
      ADRESS_RECIVED <= 0;
      MISO <= 0;
    end else begin
      case (cs)
        IDLE: begin
          rx_valid <= 0;
          MISO <= 0;
          rx_data <= 0;
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
            ADRESS_RECIVED <= 1;
          end
        end
        READ_DATA: begin
          if (tx_valid) begin
            rx_valid <= 0;
            if (counter > 0) begin
              MISO <= tx_data[counter-1];
              counter <= counter - 1;
            end else begin
              ADRESS_RECIVED <= 0;
            end
          end else begin
            if (counter > 0 && ~rx_valid) begin
              rx_data[counter-1] <= MOSI;
              counter <= counter - 1;
            end else begin
              rx_valid <= 1;
              counter  <= 8;
            end
          end
        end
      endcase
    end
  end
endmodule
