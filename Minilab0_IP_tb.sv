`timescale 1 ps / 1 ps
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Minilab0_IP_tb(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output	reg	     [6:0]		HEX0,
	output	reg	     [6:0]		HEX1,
	output	reg	     [6:0]		HEX2,
	output	reg	     [6:0]		HEX3,
	output	reg	     [6:0]		HEX4,
	output	reg	     [6:0]		HEX5,
	
	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW
);

localparam DATA_WIDTH = 8;
localparam DEPTH = 8;

localparam FILL = 2'd0;
localparam EXEC = 2'd1;
localparam DONE = 2'd2;

parameter HEX_0 = 7'b1000000;		// zero
parameter HEX_1 = 7'b1111001;		// one
parameter HEX_2 = 7'b0100100;		// two
parameter HEX_3 = 7'b0110000;		// three
parameter HEX_4 = 7'b0011001;		// four
parameter HEX_5 = 7'b0010010;		// five
parameter HEX_6 = 7'b0000010;		// six
parameter HEX_7 = 7'b1111000;		// seven
parameter HEX_8 = 7'b0000000;		// eight
parameter HEX_9 = 7'b0011000;		// nine
parameter HEX_10 = 7'b0001000;	// ten
parameter HEX_11 = 7'b0000011;	// eleven
parameter HEX_12 = 7'b1000110;	// twelve
parameter HEX_13 = 7'b0100001;	// thirteen
parameter HEX_14 = 7'b0000110;	// fourteen
parameter HEX_15 = 7'b0001110;	// fifteen
parameter OFF   = 7'b1111111;		// all off

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [1:0] state;
reg [DATA_WIDTH-1:0] datain [0:1];
reg [DATA_WIDTH*3-1:0] result;

logic rst_n, clk;
wire [1:0] rden, wren, full, empty;
wire [DATA_WIDTH-1:0] dataout [0:1];
logic [DATA_WIDTH*3-1:0] macout, accum, accum_out;
wire [DATA_WIDTH*2-1:0] mult_result;

always #5 clk = ~clk;

initial begin
	clk = 0;
	rst_n = 0;
	#50;
	rst_n = 1;
end

//=======================================================
//  Module instantiation
//=======================================================

genvar i;

generate
  for (i=0; i<2; i=i+1) begin : fifo_gen
    FIFO_IP input_fifo
    (
    .clock(clk),
    .aclr(!rst_n),
    .rdreq(rden[i]),
    .wrreq(wren[i]),
    .data(datain[i]),
    .q(dataout[i]),
    .full(full[i]),
    .empty(empty[i])
    );
  end
endgenerate
// MAC
// #(
// .DATA_WIDTH(DATA_WIDTH)
// ) mac
// (
// .clk(CLOCK_50),
// .rst_n(rst_n),
// .En(&rden),
// .Clr(1'b0),
// .Ain(dataout[0]),
// .Bin(dataout[1]),
// .Cout(macout)
// );

LPM_MULT_IP mult_i (
	.clock(clk),
	.clken(&rden),
	.aclr(!rst_n),
	.dataa(dataout[0]),
	.datab(dataout[1]),
	.result(mult_result)
);

LPM_ADD_IP accum_i (
	.clock(clk),
	.clken(&rden),
	.aclr(!rst_n),
	.dataa(mult_result),
	.datab(accum),
	.result(accum_out)
);

assign accum = accum_out;

// always @ (posedge clk) begin
// 	if (!rst_n)
// 		accum <= 24'b0;
// 	else
// 		accum <= accum_out;
// end

//=======================================================
//  Structural coding
//=======================================================

// assign rst_n = KEY[0];
assign wren[0] = state == FILL;
assign wren[1] = wren[0];
assign rden[0] = state == EXEC;
assign rden[1] = rden[0];

integer j;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state <= FILL;
	 result <= {(DATA_WIDTH*3){1'b0}};
	 for (j=0; j<2; j=j+1) begin
	   datain[j] <= {DATA_WIDTH{1'b0}};
	 end
  end
  else begin
    case(state)
	   FILL:
		begin
		  if (full) begin
		    state <= EXEC;
		  end
		  else begin
		    datain[0] <= datain[0] + 5;
			 datain[1] <= datain[1] + 10;
		  end
	   end	
		EXEC:
		begin
		  if (empty) begin
		    state <= DONE;
		  end
		end
		DONE:
		begin
		  result <= accum_out;
		  @(posedge clk) $stop;
		end
	 endcase
  end
end


always @(*) begin
  if (state == DONE & SW[0]) begin
    case(macout[3:0])
      4'd0: HEX0 = HEX_0;
	   4'd1: HEX0 = HEX_1;
	   4'd2: HEX0 = HEX_2;
	   4'd3: HEX0 = HEX_3;
	   4'd4: HEX0 = HEX_4;
	   4'd5: HEX0 = HEX_5;
	   4'd6: HEX0 = HEX_6;
	   4'd7: HEX0 = HEX_7;
	   4'd8: HEX0 = HEX_8;
	   4'd9: HEX0 = HEX_9;
	   4'd10: HEX0 = HEX_10;
	   4'd11: HEX0 = HEX_11;
	   4'd12: HEX0 = HEX_12;
	   4'd13: HEX0 = HEX_13;
	   4'd14: HEX0 = HEX_14;
	   4'd15: HEX0 = HEX_15;
    endcase
  end
  else begin
    HEX0 = OFF;
  end
end

always @(*) begin
  if (state == DONE & SW[0]) begin
    case(macout[7:4])
      4'd0: HEX1 = HEX_0;
	   4'd1: HEX1 = HEX_1;
	   4'd2: HEX1 = HEX_2;
	   4'd3: HEX1 = HEX_3;
	   4'd4: HEX1 = HEX_4;
	   4'd5: HEX1 = HEX_5;
	   4'd6: HEX1 = HEX_6;
	   4'd7: HEX1 = HEX_7;
	   4'd8: HEX1 = HEX_8;
	   4'd9: HEX1 = HEX_9;
	   4'd10: HEX1 = HEX_10;
	   4'd11: HEX1 = HEX_11;
	   4'd12: HEX1 = HEX_12;
	   4'd13: HEX1 = HEX_13;
	   4'd14: HEX1 = HEX_14;
	   4'd15: HEX1 = HEX_15;
    endcase
  end
  else begin
    HEX1 = OFF;
  end
end

always @(*) begin
  if (state == DONE & SW[0]) begin
    case(macout[11:8])
      4'd0: HEX2 = HEX_0;
	   4'd1: HEX2 = HEX_1;
	   4'd2: HEX2 = HEX_2;
	   4'd3: HEX2 = HEX_3;
	   4'd4: HEX2 = HEX_4;
	   4'd5: HEX2 = HEX_5;
	   4'd6: HEX2 = HEX_6;
	   4'd7: HEX2 = HEX_7;
	   4'd8: HEX2 = HEX_8;
	   4'd9: HEX2 = HEX_9;
	   4'd10: HEX2 = HEX_10;
	   4'd11: HEX2 = HEX_11;
	   4'd12: HEX2 = HEX_12;
	   4'd13: HEX2 = HEX_13;
	   4'd14: HEX2 = HEX_14;
	   4'd15: HEX2 = HEX_15;
    endcase
  end
  else begin
    HEX2 = OFF;
  end
end

always @(*) begin
  if (state == DONE & SW[0]) begin
    case(macout[15:12])
      4'd0: HEX3 = HEX_0;
	   4'd1: HEX3 = HEX_1;
	   4'd2: HEX3 = HEX_2;
	   4'd3: HEX3 = HEX_3;
	   4'd4: HEX3 = HEX_4;
	   4'd5: HEX3 = HEX_5;
	   4'd6: HEX3 = HEX_6;
	   4'd7: HEX3 = HEX_7;
	   4'd8: HEX3 = HEX_8;
	   4'd9: HEX3 = HEX_9;
	   4'd10: HEX3 = HEX_10;
	   4'd11: HEX3 = HEX_11;
	   4'd12: HEX3 = HEX_12;
	   4'd13: HEX3 = HEX_13;
	   4'd14: HEX3 = HEX_14;
	   4'd15: HEX3 = HEX_15;
    endcase
  end
  else begin
    HEX3 = OFF;
  end
end

always @(*) begin
  if (state == DONE & SW[0]) begin
    case(macout[19:16])
      4'd0: HEX4 = HEX_0;
	   4'd1: HEX4 = HEX_1;
	   4'd2: HEX4 = HEX_2;
	   4'd3: HEX4 = HEX_3;
	   4'd4: HEX4 = HEX_4;
	   4'd5: HEX4 = HEX_5;
	   4'd6: HEX4 = HEX_6;
	   4'd7: HEX4 = HEX_7;
	   4'd8: HEX4 = HEX_8;
	   4'd9: HEX4 = HEX_9;
	   4'd10: HEX4 = HEX_10;
	   4'd11: HEX4 = HEX_11;
	   4'd12: HEX4 = HEX_12;
	   4'd13: HEX4 = HEX_13;
	   4'd14: HEX4 = HEX_14;
	   4'd15: HEX4 = HEX_15;
    endcase
  end
  else begin
    HEX4 = OFF;
  end
end

always @(*) begin
  if (state == DONE & SW[0]) begin
    case(macout[23:20])
      4'd0: HEX5 = HEX_0;
	   4'd1: HEX5 = HEX_1;
	   4'd2: HEX5 = HEX_2;
	   4'd3: HEX5 = HEX_3;
	   4'd4: HEX5 = HEX_4;
	   4'd5: HEX5 = HEX_5;
	   4'd6: HEX5 = HEX_6;
	   4'd7: HEX5 = HEX_7;
	   4'd8: HEX5 = HEX_8;
	   4'd9: HEX5 = HEX_9;
	   4'd10: HEX5 = HEX_10;
	   4'd11: HEX5 = HEX_11;
	   4'd12: HEX5 = HEX_12;
	   4'd13: HEX5 = HEX_13;
	   4'd14: HEX5 = HEX_14;
	   4'd15: HEX5 = HEX_15;
    endcase
  end
  else begin
    HEX5 = OFF;
  end
end

assign LEDR = {{8{1'b0}}, state};

endmodule