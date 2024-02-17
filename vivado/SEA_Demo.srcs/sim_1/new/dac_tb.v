`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2024 10:23:04 PM
// Design Name: 
// Module Name: dac_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dac_tb();
    reg i_sys_clk, i_dac_clk;
    reg i_data_valid;
    reg [11:0] i_data;
    reg i_rstn;
    wire o_serial_data;
    wire o_sync;
    wire o_serial_clk;
    wire o_busy;
    
    DAC7311 dac (
        .i_sys_clk(i_sys_clk),
        .i_dac_clk(i_dac_clk),
        .i_data_valid(i_data_valid),
        .i_data(i_data),
        .i_rstn(i_rstn),
        .pwrd0(1),
        .pwrd1(1),
        .o_serial_data(o_serial_data),
        .o_sync(o_sync),
        .o_serial_clk(o_serial_clk),
        .o_busy(o_busy)
    );
    
    always
        #3 i_sys_clk = ~i_sys_clk;
    
    always
        #20 i_dac_clk = ~i_dac_clk;
        
    initial begin
        i_sys_clk = 0;
        i_dac_clk = 0;
        i_rstn = 0;
        i_data_valid = 0;
        i_data = 0;
        #40 i_rstn = 1;
        i_data <= 12'h6F1;
        #10 i_data_valid = 1;
    end
    
    always @(posedge i_dac_clk) begin
    
    end
    initial
        #1400 $finish;
endmodule
