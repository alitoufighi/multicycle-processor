`timescale 1ns/1ns
module Datapath(input PCsrc, PCldEn, PCout, IRldR, IRldL, RegSel,
				IRDout, IRAout,	Mout, Mld, MemWrite, RegWrite, RegFileSel,
				Rout, Rld, DIld, Ald, Bld, ALUResOut, ALUResld, CZNld, input[1:0] ALUOp,
				output logic [3:0] opcode, output logic [2:0] FlagOut, output logic [1:0] JmpSel, input clk, rst);
	
	logic[12:0] PCinc, PCo, PCin, IRAo;
	logic[ 7:0] IRDo, Mi, Mo, ALUResO, ALUOut, Aout, Bout, Ri, Ro;
	logic[ 1:0] DIAccOut, AccSelected, AccSrc, AccDst, RegAddrIn;
	logic[ 2:0] FlagIn;
	logic		Cin;
	// assign opcode = ;
	tri[ 7:0] DataBus;
	tri[12:0] AddressBus;
	wire tmp;
	InstructionRegister IR(.in(DataBus), .ldR(IRldR), .ldL(IRldL), .clk(clk), .rst(rst), .addr_out(IRAo), .data_out(IRDo), .opcode_out(opcode), .AccSrc(AccSrc), .AccDst(AccDst));
	
	Register #(.LENGTH(13)) PC(.in(PCin), .out(PCo), .ld(PCldEn), .clk(clk), .rst(rst));
	Register #(.LENGTH(5)) DI(.in(DataBus[4:0]), .clk(clk), .rst(rst), .ld(DIld), .out({DIAccOut,JmpSel,tmp}));
	Register #(.LENGTH(8)) A(.in(DataBus), .clk(clk), .rst(rst), .ld(Ald), .out(Aout));
	Register #(.LENGTH(8)) B(.in(DataBus), .clk(clk), .rst(rst), .ld(Bld), .out(Bout));
	Register #(.LENGTH(8)) M(.in(Mi), .clk(clk), .rst(rst), .ld(Mld), .out(Mo));
	Register #(.LENGTH(8)) R(.in(Ri), .clk(clk), .rst(rst), .ld(Rld), .out(Ro));
	Register #(.LENGTH(8)) ALUres(.in(ALUOut), .clk(clk), .rst(rst), .ld(ALUResld), .out(ALUResO));
	Register #(.LENGTH(3)) CZN(.in(FlagIn), .clk(clk), .rst(rst), .ld(CZNld), .out(FlagOut));
	
	Memory memory(.address(AddressBus), .write_data(DataBus), .memWrite(MemWrite), .out(Mi));

	RegisterFile RFile(.address(RegAddrIn), .write_data(DataBus), .regWrite(RegWrite), .rst(rst), .out(Ri));

	Mux2 #(.LENGTH(13)) PCSRC(.in0(PCinc), .in1(AddressBus), .s(PCsrc), .out(PCin));
	Mux2 #(.LENGTH(2)) REGSEL(.in0(AccSrc), .in1(AccDst), .s(RegSel), .out(AccSelected));
	Mux2 #(.LENGTH(2)) REGFILESEL(.in0(DIAccOut), .in1(AccSelected), .s(RegFileSel), .out(RegAddrIn));
	ALU alu(.A(Aout), .B(Bout), .Cin(FlagOut[2]), .clk(clk), .ALUOp(ALUOp), .ALUout(ALUOut), .CZN(FlagIn));

	Adder #(.LENGTH(13)) PCIncrementer(PCo, 13'b1, PCinc);

	assign AddressBus = (IRAout)?IRAo:(PCout)?PCo:13'bZ;
	assign DataBus = (IRDout)?IRDo:(Mout)?Mo:(Rout)?Ro:(ALUResOut)?ALUResO:8'bZ;
endmodule
