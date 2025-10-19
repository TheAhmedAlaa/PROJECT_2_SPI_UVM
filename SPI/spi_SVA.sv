module spi_SVA (
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
  input reg [9:0] rx_data;
  input reg rx_valid, MISO;
  property rst_n_prop;
    @(posedge clk) !rst_n |=> {~MISO&&~rx_valid&&~rx_data};
  endproperty
  property MULTp;
  disable iff(rst||bypass_A||bypass_B||red_op_A||red_op_B)
    @(posedge clk) opcode == 3'b011 |-> ##2 out == ($past(
        A, 2
    ) * $past(
        B, 2
    ));
  endproperty
  property SHIFTp_direction1;
  disable iff(rst||bypass_A||bypass_B||red_op_A||red_op_B)
    @(posedge clk) (opcode == 3'b100 && direction) |-> ##2 out == {$past(
        out[4:0],1
    ), $past(serial_in,2)};
  endproperty
  property SHIFTp_direction0;
  disable iff(rst||bypass_A||bypass_B||red_op_A||red_op_B)
    @(posedge clk) (opcode == 3'b100 && ~direction) |-> ##2 out == {$past(serial_in,2), $past(
        out[5:1],1
    )};
  endproperty
  property ROTATEp_direction1;
  disable iff(rst||bypass_A||bypass_B||red_op_A||red_op_B)
    @(posedge clk) (opcode == 3'b101 && direction) |-> ##2 out == {$past(
        out[4:0]
    ), $past(
        out[5]
    )};
  endproperty
  property ROTATEp_direction0;
  disable iff(rst||bypass_A||bypass_B||red_op_A||red_op_B)
    @(posedge clk) (opcode == 3'b101 && !direction) |-> ##2 out == {$past(
        out[0]
    ), $past(
        out[5:1]
    )};
  endproperty
  property red_op_A_OR;
  disable iff(rst||bypass_A||bypass_B)
    @(posedge clk) (opcode == 3'b000 && red_op_A) |-> ##2 out == {|$past(
        A, 2
    )};
  endproperty
  property red_op_B_OR;
  disable iff(rst||bypass_A||bypass_B)
    @(posedge clk) (opcode == 3'b000 && red_op_B&& ~red_op_A) |-> ##2 out == {|$past(
        B, 2
    )};
  endproperty
  property OR_p;
  disable iff(rst||bypass_A||bypass_B||red_op_A||red_op_B)
    @(posedge clk) (opcode == 3'b000) |-> ##2 {out == ($past(
        A, 2
    ) | $past(
        B, 2
    ))};
  endproperty
  property red_op_A_XOR;
  disable iff(rst||bypass_A||bypass_B)
    @(posedge clk) (opcode == 3'b001 && red_op_A) |-> ##2 out == {^$past(
        A, 2
    )};
  endproperty
  property red_op_B_XOR;
  disable iff(rst||bypass_A||bypass_B)
    @(posedge clk) (opcode == 3'b001 && red_op_B&& ~red_op_A) |-> ##2 out == {^$past(
        B, 2
    )};
  endproperty
property XOR_p;
  disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B)
    @(posedge clk)
      (opcode == 3'b001) |-> ##2 (out == ($past(A,2) ^ $past(B,2)));
endproperty

  property invalid_p;
  disable iff(rst||bypass_A||bypass_B)
    @(posedge clk) (opcode == 3'b110 || opcode == 3'b111) |-> ##2 ~out;
  endproperty
  property bypass_Ap;
  disable iff(rst||red_op_A||red_op_B)
    @(posedge clk) bypass_A |-> ##2 out == ($past(
        A, 2
    ));
  endproperty
  property bypass_Bp;
  disable iff(rst||red_op_A||red_op_B)
    @(posedge clk) (bypass_B&&~bypass_A) |-> ##2 out == $past(
        B, 2
    );
  endproperty
  property leds_invalid;
  disable iff(rst||bypass_A||bypass_B)
    @(posedge clk) (opcode==3'b110||opcode==3'b111||(~(opcode==3'b000||opcode==3'b001)&&(red_op_A||red_op_B)))|->##2(leds!=$past(
        leds
    ));
  endproperty
property leds_valid;
  @(posedge clk) disable iff(rst)
    (!(( (red_op_A || red_op_B) && (opcode[1] || opcode[2]) ) ||(opcode[1] && opcode[2])) ) |-> ##2 (leds == 0);
endproperty
  property resetp;
    @(posedge clk) rst |=> (~out && ~leds);
  endproperty
endmodule
