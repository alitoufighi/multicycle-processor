`timescale 1ns/1ns
module multi_cycle(input start, clk, rst);
	logic PCsrc, PCldEn, PCout, IRldL, IRldR, RegSel, IRDout, IRAout, Mout, Mld, MemWrite,
			RegWrite, RegFileSel, Rout, Rld, DIld, Ald, Bld, ALUResOut, ALUResld, CZNld;
	logic[3:0] opcode;
	logic[2:0] czn;
	logic[1:0] JmpSel, ALUOp;
	Datapath dp(PCsrc, PCldEn, PCout, IRldR, IRldL, RegSel, IRDout, IRAout,
				Mout, Mld, MemWrite, RegWrite, RegFileSel, Rout, Rld, DIld,
				Ald, Bld, ALUResOut, ALUResld, CZNld, ALUOp,
				opcode, czn, JmpSel, clk, rst);
	Controller cu(opcode, JmpSel, czn, clk, rst, start,
			PCsrc, PCout, IRldR,
			IRldL, RegSel, IRDout, IRAout, Mout,
			Mld, MemWrite, RegWrite, RegFileSel,
			Rout, Rld, DIld, Ald, Bld, ALUResOut,
			ALUResld, CZNld, PCldEn, ALUOp);
endmodule


module TB();
	logic rst=1, clk=0, start=0;
	multi_cycle test(start, clk, rst);
	initial repeat(1000)#40 clk=~clk;
	initial repeat(1)#45 rst=~rst;
	initial repeat(1)#100 start=~start;
	initial repeat(1)#150 start=~start;
endmodule

// module TestBench();
// 	reg clk=0, rst=0, Ld=0, done;
// 	processor imatov(clk, rst, Ld, done);

// 	initial repeat(1000)#40 clk=~clk;
// 	initial repeat(2)#15 rst=~rst;
// 	initial repeat(2)#37 Ld=~Ld;
// endmodule