module FIFO
#(
  parameter DEPTH=8,
  parameter DATA_WIDTH=8
)
(
  input  clk,
  input  rst_n,
  input  rden,
  input  wren,
  input  [DATA_WIDTH-1:0] i_data,
  output [DATA_WIDTH-1:0] o_data,
  output logic full,
  output logic empty
);

integer i;
logic [DATA_WIDTH-1:0] memory [DEPTH];
logic [$clog2(DEPTH):0] size;

always @(posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    memory <= '{default: '0};
    size <= '0;
  end

  else if (wren && !full) begin
    for (i = 0; i < DEPTH-1; i++) begin
      memory[i + 1] <= memory[i];
    end
    memory[0] <= i_data;
    if (!rden)
      size <= full ? size : size + 1'b1;
  end

  else if (!wren && rden)
    size <= empty ? size : size - 1'b1;

  else
    size <= size;
end

assign empty = ~|size;
assign full = size == DEPTH;
assign o_data = (size == '0) | !rden ? '0 : memory[size-1];

endmodule