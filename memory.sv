`timescale 1ns/1ns
module Memory(input [12:0] address, input[7:0] write_data,
				input memWrite, output logic [7:0] out);
	logic [7:0] mem [8191:0];

	initial begin
		$readmemb("instruction.txt", mem);
		$readmemb("data.txt", mem, 1000, 1011);
	end
	assign out = mem[address];
	always @(posedge memWrite) begin
		if(memWrite)
			mem[address] <= write_data;
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
