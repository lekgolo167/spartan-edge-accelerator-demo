`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2024 02:02:40 AM
// Design Name: 
// Module Name: adc_tb
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


module adc_tb();
    reg adc_clk, sys_clk;
    reg rd, en;
    reg [7:0] adc_data;
    wire data_valid, output_enabled_n;
    wire [7:0] data;
    
    ADC1173 adc (
        .i_adc_clk(adc_clk),
        .i_sys_clk(sys_clk),
        .i_wr_en(en),
        .i_rd_en(rd),
        .i_adc_data(adc_data),
        .o_data(data),
        .o_data_ready(data_valid),
        .o_output_enable_n(output_enabled_n)
    );
    
    initial begin
        adc_clk = 0;
        sys_clk = 0;
        adc_data = 0;
        en = 0;
        rd = 0;
        #100 en = 1;
        rd = 1;
    end
    
    always
        #3 sys_clk = ~sys_clk;
        
    always
        #20 adc_clk = ~adc_clk;
        
    always @(posedge adc_clk) begin
        adc_data <= adc_data + 1;
    end
    
    initial
        #400 $finish;
endmodule
