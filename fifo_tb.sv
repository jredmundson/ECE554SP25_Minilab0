`timescale 1ns / 1ps

module fifo_tb;
    // Parameters
    parameter DEPTH = 8;
    parameter DATA_WIDTH = 8;
    
    // Signals
    logic clk;
    logic rst_n;
    logic rden;
    logic wren;
    logic [DATA_WIDTH-1:0] i_data;
    logic [DATA_WIDTH-1:0] o_data;
    logic full;
    logic empty;
    
    // Instantiate the FIFO module
    FIFO #(DEPTH, DATA_WIDTH) uut (
        .clk(clk),
        .rst_n(rst_n),
        .rden(rden),
        .wren(wren),
        .i_data(i_data),
        .o_data(o_data),
        .full(full),
        .empty(empty)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 10ns period
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        rden = 0;
        wren = 0;
        i_data = 0;
        
        // Reset FIFO
        #10 rst_n = 1;
        
        // Write data into FIFO
        repeat (DEPTH) begin
            #10 wren = 1; i_data = i_data + 1;
        end
        
        // Stop writing, check full flag
        #10 wren = 0;
        
        // Read data from FIFO
        repeat (DEPTH) begin
            #10 rden = 1;
        end
        
        // Stop reading, check empty flag
        #10 rden = 0;
        
        // End simulation
        #20 $stop;
    end
endmodule
