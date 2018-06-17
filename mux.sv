`timescale 1ns/1ns
module Mux2 #(parameter integer LENGTH) (input [LENGTH-1:0] in0, in1, input s, output logic [LENGTH-1:0] out); //1,0,sel,out
	assign out = (s) ? in1 : in0;
endmodule

module Mux4 #(parameter integer LENGTH) (input [LENGTH-1:0] in0, in1, in2, in3, input[1:0] s, output logic [LENGTH-1:0] out); //1,0,sel,out
	assign out = (s==0) ? in0 : (s==1) ? in1 : (s==2) ? in2 : in3;
endmodule
