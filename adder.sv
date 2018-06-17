`timescale 1ns/1ns
module Adder #(parameter integer LENGTH) (input[LENGTH-1:0] A, B, output logic [LENGTH-1:0] out);
	assign out = A + B;
endmodule
