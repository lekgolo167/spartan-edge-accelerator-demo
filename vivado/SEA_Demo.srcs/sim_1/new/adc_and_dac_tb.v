`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2024 11:36:45 PM
// Design Name: 
// Module Name: adc_and_dac_tb
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


module adc_and_dac_tb();
    
wire [1:0] led;
reg fpga_rst, sys_clk, adc_clk, dac_clk, pll_locked;
reg [7:0] adc_raw_data, adc_data;

wire adc_oe_n, en, adc_data_valid;
wire dac_serial_clk;
wire dac_sync, dac_busy;
wire dac_serial_data;

reg rstn, rstn1;

assign led[0] = dac_busy;
assign led[1] = pll_locked;
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

    DAC7311 dac (
        .i_sys_clk(sys_clk),
        .i_dac_clk(dac_clk),
        .i_data_valid(adc_data_valid),
        .i_data({adc_data, 4'h0}),
        .i_rstn(rstn),
        .pwrd0(1),
        .pwrd1(1),
        .o_serial_data(dac_serial_data),
        .o_sync(dac_sync),
        .o_serial_clk(dac_serial_clk),
        .o_busy(dac_busy)
    );

    initial begin
        sys_clk = 0;
        adc_clk = 0;
        dac_clk = 0;
        adc_raw_data = 0;
        fpga_rst = 1;
        pll_locked = 0;
        #10 fpga_rst = 0;
        #100 fpga_rst = 1;
        pll_locked = 1;
    end
    
    always
        #3 dac_clk = ~dac_clk;

    always
        #20 adc_clk = ~adc_clk;

    always
        #1 sys_clk = ~sys_clk;

    always @(posedge sys_clk) begin
        rstn1 <= fpga_rst;
        rstn <= rstn1;
   end

    always @(posedge adc_clk) begin
        adc_raw_data <= adc_raw_data + 1;
    end

endmodule
