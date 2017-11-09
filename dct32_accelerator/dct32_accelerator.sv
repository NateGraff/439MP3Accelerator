`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nathaniel Graff
// 
// Create Date: 11/07/2017 09:01:58 AM
// Module Name: dct32_accelerator
// Project Name: Hardware-Accelerated MP3 Player
//////////////////////////////////////////////////////////////////////////////////

module dct32_accelerator(
    input clk,
    input rst,
    input iarg_empty,
    input [31:0] iarg_d,
    output reg iarg_read,
    input oarg_full,
    output reg [31:0] oarg_d,
    output reg oarg_write
    );
    
    int in_count;
    int in_data[31:0];
    int out_count;
    int out_data[31:0];
    
    dct32 dct32(clk, in_data, out_data[31:16], out_data[15:0]);
    
    enum { RESET, IDLE, READ_IN, PROCESS, READ_OUT } state;
    
    always @(posedge clk) begin
        if(rst) begin
            state = RESET;
        end
        
        case(state)
            RESET: begin
                in_count = 0;
                out_count = 0;
                state = IDLE;
            end
            
            IDLE: begin
                oarg_write = 0;
                iarg_read = 0;
                if(!iarg_empty) begin
                    state = READ_IN;
                end
            end
            
            READ_IN: begin
                if(!iarg_empty) begin
                    in_data[in_count] = iarg_d;
                    iarg_read = 1;
                    in_count = in_count + 1;
                    if(in_count == 32) begin
                        iarg_read = 0;
                        state = PROCESS;
                        in_count = 0;
                    end
                else
                    iarg_read = 0;
                end
            end
            
            PROCESS: begin
                iarg_read = 0;
                state = READ_OUT;
            end
            
            READ_OUT: begin
                oarg_d = out_data[out_count];
                out_count = out_count + 1;
                oarg_write = 1;
                if(out_count == 32) begin
                    oarg_write = 0;
                    out_count = 0;
                    state = IDLE;
                end
            end
        
        endcase
    end
endmodule
