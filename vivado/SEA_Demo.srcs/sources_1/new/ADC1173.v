`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2024 11:24:31 PM
// Design Name: 
// Module Name: ADC1173
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


module ADC1173(
    input i_rstn,
    input i_adc_clk,
    input i_sys_clk,
    input i_wr_en,
    input i_rd_en,
    input [7:0] i_adc_data,
    output [7:0] o_data,
    output o_data_ready,
    output reg o_output_enable_n
    );
    
    wire empty, full;
    
    fifo_generator_0 adc_fifo (
        //.rst(~i_rstn),
        .wr_clk(i_adc_clk),
        .rd_clk(i_sys_clk),
        .din(i_adc_data),
        .wr_en(i_wr_en),
        .rd_en(i_rd_en),
        .dout(o_data),
        .full(full),
        .empty(empty)
    );
   
    assign o_data_ready = ~empty;

    always @(posedge i_adc_clk) begin
        o_output_enable_n <= full;
    end

endmodule
