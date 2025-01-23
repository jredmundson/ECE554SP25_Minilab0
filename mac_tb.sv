`timescale 1ns / 1ps

module mac_tb;
    // Parameters
    parameter DATA_WIDTH = 8;
    
    // Signals
    logic clk;
    logic rst_n;
    logic En;
    logic Clr;
    logic [DATA_WIDTH-1:0] Ain;
    logic [DATA_WIDTH-1:0] Bin;
    logic [DATA_WIDTH*3-1:0] Cout;
    
    // Instantiate the MAC module
    MAC #(DATA_WIDTH) uut (
        .clk(clk),
        .rst_n(rst_n),
        .En(En),
        .Clr(Clr),
        .Ain(Ain),
        .Bin(Bin),
        .Cout(Cout)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 10ns period
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        En = 0;
        Clr = 0;
        Ain = 0;
        Bin = 0;
        
        // Reset
        #10 rst_n = 1;
        
        // First operation
        #10 Ain = 8'd3; Bin = 8'd2; En = 1;
        #10 Ain = 8'd4; Bin = 8'd3;
        #10 Ain = 8'd1; Bin = 8'd5;
        
        // Clear operation
        #10 Clr = 1;
        #10 Clr = 0; 
        
        // More operations
        #10 Ain = 8'd2; Bin = 8'd6; En = 1;
        #10 Ain = 8'd3; Bin = 8'd7;
        
        // Disable enable signal
        #10 En = 0;
        
        // End simulation
        #20 $stop;
    end
endmodule
