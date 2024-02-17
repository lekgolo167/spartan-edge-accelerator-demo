`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2022 08:47:24 AM
// Design Name: 
// Module Name: top
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


module top(
    input sys_clk,
    input fpga_rst,
    output [1:0] led,
    output adc_oe_n,
    output adc_clk,
    input [7:0] adc_raw_data,

    output dac_serial_clk,
    output dac_sync,
    output dac_serial_data
    );
   
   wire dac_clk, pll_locked;
   reg rstn, rstn1;

   always @(posedge sys_clk) begin
    rstn1 <= fpga_rst;
    rstn <= rstn1;
   end
    
    clk_wiz_0 clk_wiz_inst (
        .clk_in1(sys_clk),
        .resetn(rstn),
        .locked(pll_locked),
        .clk_out1(adc_clk),
        .clk_out2(dac_clk)
    );

    assign led[1] = pll_locked;
    wire en, adc_data_valid;
    wire [7:0] adc_data;

    assign en = 1;

    ADC1173 adc (
        .i_rstn(1'b1),
        .i_adc_clk(adc_clk),
        .i_sys_clk(sys_clk),
        .i_wr_en(en),
        .i_rd_en(en),
        .i_adc_data(adc_raw_data),
        .o_data(adc_data),
        .o_data_ready(adc_data_valid),
        .o_output_enable_n(adc_oe_n)
    );

    wire dac_data_valid, dac_busy; 
    DAC7311 dac (
        .i_sys_clk(sys_clk),
        .i_dac_clk(dac_clk),
        .i_data_valid(adc_data_valid),
        .i_data({adc_data, 4'h0}),
        .i_rstn(rstn),
        .pwrd0(1'b0),
        .pwrd1(1'b0),
        .o_serial_data(dac_serial_data),
        .o_sync(dac_sync),
        .o_serial_clk(dac_serial_clk),
        .o_busy(dac_busy)
    );
    
    assign led[0] = dac_busy;
endmodule
