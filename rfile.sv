`timescale 1ns/1ns
module RegisterFile(input [1:0] address, input[7:0] write_data, input regWrite, rst, output logic [7:0] out);
	logic [7:0] rfile [3:0];

	initial begin
		$readmemb("reg.txt", rfile);
	end
	// initial begin $readmemb("instruction.txt", mem); end
	assign out = rfile[address];
	always @(write_data, posedge regWrite, posedge rst) begin
		if(rst) begin
			integer i;
			for(i=0; i<3; i=i+1) begin
				rfile[i] <= 8'b0;
			end
		end
		else if(regWrite)
			rfile[address] <= write_data;
	end
endmodule


// module IMTB();
// 	reg [18:0] instruction;
// 	reg rst=0;
// 	reg insLd =0;
// 	logic done;
// 	InstructionMemory im(13'd8, insLd, instruction, done, rst);
// 	initial #50 rst=~rst;
// 	initial #100 rst=~rst;
// 	initial #130 insLd=~insLd;
// 	initial #180 insLd=~insLd;
// 	initial #15000 $stop;
// endmodule
