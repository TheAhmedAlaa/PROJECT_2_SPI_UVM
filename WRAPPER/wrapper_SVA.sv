module wrapper_SVA (
    clk,
    rst_n,
    MOSI,
    MISO,
    SS_n
);
  input MOSI, SS_n, clk, rst_n;
  input MISO;

  property rst_n_check;
    @(posedge clk) !rst_n |=> !MISO;
  endproperty

  assert property (rst_n_check)
  else $error("MISO should be low when reset is asserted");

  cover property (rst_n_check);

  sequence READ_DATA_SEQUENCE;
    $fell(
        SS_n
    ) ##1 (MOSI [-> 3] ##0 1'b1);
  endsequence

  property MISO_STABLE_NOT_READ;
    @(posedge clk) disable iff (!rst_n) $fell(
        SS_n
    ) |=> (not READ_DATA_SEQUENCE ##1
      ($stable(
        MISO
    ) throughout (!SS_n)));
  endproperty

  assert property (MISO_STABLE_NOT_READ)
  else $error("MISO changed during SS_n low in non-read sequence");

  cover property (MISO_STABLE_NOT_READ);

endmodule
