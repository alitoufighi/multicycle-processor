`timescale 1ns/1ns
module Register #(parameter integer LENGTH) (input [LENGTH-1:0] in, input clk, rst, ld, output logic [LENGTH-1:0] out);
	always @(posedge clk or posedge rst) begin
		if (rst)
			out <= 0;
		else if (ld)
			out <= in;
		else
			out <= out;
	end
endmodule
