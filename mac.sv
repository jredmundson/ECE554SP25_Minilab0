module MAC #
(
parameter DATA_WIDTH = 8
)
(
input clk,
input rst_n,
input En,
input Clr,
input [DATA_WIDTH-1:0] Ain,
input [DATA_WIDTH-1:0] Bin,
output [DATA_WIDTH*3-1:0] Cout
);

logic [DATA_WIDTH-1:0] mult, accum;

always_ff @ (posedge clk) begin
    if (!rst_n) begin
        mult <= '0;
        accum <= '0;
    end
    else if (Clr) begin
        mult <= '0;
        accum <= '0;
    end
    else if (En) begin
        mult <= Ain * Bin;
        accum <= accum + mult;
    end
    else begin
        mult <= mult;
        accum <= accum;
    end
end

assign Cout = accum;    

endmodule