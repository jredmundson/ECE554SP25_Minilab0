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
  output full,
  output empty
);

integer i;
logic [DATA_WIDTH-1:0] memory [DEPTH-1];
logic [$clog2(DEPTH)-1:0] size;

always @(posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    memory <= '{default: '0};
    size <= 0;
  end

  else if (wren) begin
    for (i = 0; i < DEPTH-1; i++) begin
      memory[i + 1] <= memory[i]
    end
    memory[0] <= i_data;
    if (!rden) begin
      size <= size + 1
    end 
  end

  else if (!wren && rden) begin
    size <= size - 1;
  end
end

assign o_data = memory[size];
assign full = (size == DEPTH);
assign empty = ~|size; 

endmodule