`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2024 09:42:07 PM
// Design Name: 
// Module Name: DAC7311
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


module DAC7311(
    input i_sys_clk,
    input i_dac_clk,
    input i_data_valid,
    input [11:0] i_data,
    input i_rstn,
    input pwrd0,
    input pwrd1,
    output reg o_serial_data,
    output reg o_sync,
    output reg o_serial_clk,
    output o_busy
    );
    
    reg [0:15] out_buffer;
    wire [0:11] fifo_out;
    reg [3:0] index;
    reg dac_strobe;
    wire full, empty;
    reg rd_en;
    
    fifo_generator_1 dac_fifo (
        //.rst(~i_rstn),
        .wr_clk(i_sys_clk),
        .rd_clk(i_dac_clk),
        .din(i_data),
        .wr_en(i_data_valid),
        .rd_en(rd_en),
        .dout(fifo_out),
        .full(full),
        .empty(empty)
    );
       
    initial dac_strobe = 0;
//    always @(posedge i_dac_clk) begin
//        dac_strobe = ~dac_strobe;
//    end
    
    localparam s_IDLE = 2'b00;
    localparam s_SYNC = 2'b01;
    localparam s_SEND_RISING = 2'b10;
    localparam s_SEND_FALLING = 2'b11;
    reg [1:0] r_state;
    
    assign o_busy = r_state != s_IDLE;
    
    always @(posedge i_dac_clk) begin
//        if(!i_rstn) begin
//            o_serial_clk <= 0;
//        end
//        else begin
            o_serial_clk <= ~ o_serial_clk;
//        end
    end
    initial begin
    o_serial_clk = 0;
    r_state = s_IDLE;
    end
    always @(posedge i_dac_clk) begin
//        if(!i_rstn) begin
//            r_state <= s_IDLE;
//        end
//        else begin
            case(r_state)
                s_IDLE : begin
                    o_sync <= 1;
//                    o_serial_clk <= 1;
                    index <= 0;
                    rd_en <= 0;
                    if (empty == 1'b0 && o_serial_clk == 1'b0) begin
                        out_buffer <= {pwrd1, pwrd0, fifo_out, 2'b00};
                        r_state <= s_SYNC;
                        rd_en <= 1;
                    end
                end
                s_SYNC : begin
                    o_sync <= 0;
                    rd_en <= 0;
                    o_serial_data <= out_buffer[index];
                    if (o_serial_clk == 1'b1) begin
                        r_state <= s_SEND_RISING;
                    end
                end
                s_SEND_RISING : begin
                    o_serial_data <= out_buffer[index];
//                    o_serial_clk <= 0;
                    if (o_serial_clk == 1'b0) begin
                        r_state <= s_SEND_FALLING;
                    end
                end
                s_SEND_FALLING : begin
//                    o_serial_clk <= 1;
                    if (o_serial_clk == 1'b1) begin
                        index <= index + 1;
                        if (index == 4'b1111) begin
                            r_state <= s_IDLE;
//                            o_sync <= 1;
                        end
                        else begin
                            r_state <= s_SEND_RISING;
                        end
                    end
                end
            endcase
//        end
    end
endmodule
