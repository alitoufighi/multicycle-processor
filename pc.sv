`timescale 1ns/1ns
module InstructionRegister (input [7:0] in, input clk, rst, ldR, ldL,
							output logic [12:0] addr_out, output logic [7:0] data_out, output logic [3:0] opcode_out, output logic [1:0] AccSrc, AccDst);
	logic [15:0] out;
	assign data_out = out[15:8];
	assign addr_out = out[12:0];
	assign opcode_out = out[15:12];
	assign AccSrc = out[ 9: 8];
	assign AccDst = out[11:10];
	always @(posedge clk or posedge rst) begin
		if (rst)
			out <= 0;
		else if (ldR)
			out[ 7:0] <= in;
		else if (ldL)
			out[ 15:8] <= in;
		else
			out <= out;
	end
endmodule

