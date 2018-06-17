	//  DIAccOut, DIin, RegWDataIn, RegAddrIn, Ri, Ro, MemAddrIn, MemWDataIn, Mi, Mo, AccSelected, MBusOut, ALUResBusOut, AccDst, AccSr, IRDo, IRin, PCin, PCout, 
	`timescale 1ns/1ns
	module Controller(input [3:0] opcode, input [1:0] JmpSel, input[2:0] Flags, input clk, rst, start,
															output logic PCsrc, PCout, IRldR,
															IRldL, RegSel, IRDout, IRAout, Mout,
															Mld, MemWrite, RegWrite, RegFileSel,
															Rout, Rld, DIld, Ald, Bld, ALUResOut,
															ALUResld, CZNld, pcLdEn,
															output logic [1:0] ALUOp);
		parameter[4:0] IF1=0, IF2=1, ID=2, RT1=3, RT2=4, RT3=5, RT4=6, RT5=7, RT6=8, IF3=9, IF4=10, LDA1=11, LDA2=12, STA1=13, STA2=14, JMP=15, ADA1=16, ADA2=17, ADA3=18, ADA4=19, ADA5=20, ADA6=21, IDLE=22, START=23;
		logic[4:0] ps, ns;
		logic PCld, Jump, jump_cond;
		Mux4 #(.LENGTH(1)) JumpSelector(.in0(1'b1), .in1(Flags[2]), .in2(Flags[1]), .in3(Flags[0]), .s(JmpSel), .out(jump_cond));
		and(jmp, Jump, jump_cond);
		or(pcLdEn, PCld, jmp);
		always @(*) begin
			ns <= 4'b0;
			case(ps)
				IDLE: ns <= (start==1)?START:IDLE;
				START: ns <= (start==0)?IF1:START;
				IF1:  ns <= IF2;
				IF2:  ns <= ID;
				ID:   begin ns <= (opcode[3:2]==2'b10)?RT1:(opcode[3:1]==3'b111)?IF1:IF3; end
				RT1:  ns <= RT2;
				RT2:  ns <= RT3;
				RT3:  ns <= RT4;
				RT4:  ns <= RT5;
				RT5:  ns <= RT6;
				RT6:  ns <= IF1;
				IF3:  ns <= IF4;
				IF4:  begin ns <= (opcode[3:1]==3'b000)?LDA1:(opcode[3:1]==3'b001)?STA1:(opcode[3:1]==3'b110)?JMP:ADA1; end
				LDA1: ns <= LDA2;
				LDA2: ns <= IF1;
				STA1: ns <= STA2;
				STA2: ns <= IF1;
				JMP:  ns <= IF1;
				ADA1: ns <= ADA2;
				ADA2: ns <= ADA3;
				ADA3: ns <= ADA4;
				ADA4: ns <= ADA5;
				ADA5: ns <= ADA6;
				ADA6: ns <= IF1;
			endcase
		end

		always @(*) begin
			ALUOp <= 0;
			{PCsrc, PCld, PCout, IRldR, IRldL, RegSel, IRDout, IRAout, Mout, Mld, MemWrite, RegWrite, RegFileSel, Rout, Rld, DIld, Ald, Bld, ALUResOut, ALUResld, CZNld, Jump} <= 22'b0;
			case(ps)
				IF1:  begin PCout <=1; PCld <=1; Mld <=1; end
				IF2:  begin Mout <=1; IRldL <=1; end
				ID:   begin IRDout <= (opcode[3:1]==3'b111); DIld <= (opcode[3:1]==3'b111); end
				RT1:  begin RegFileSel <=1; Rld <=1; end
				RT2:  begin Rout <=1; Ald <=1; end
				RT3:  begin RegSel <=1; RegFileSel <=1; Rld <=1; end
				RT4:  begin Rout <= 1; Bld <=1; end
				RT5:  begin ALUResld <=1; CZNld <=1; end
				RT6:  begin ALUResOut <=1; RegWrite<=1; RegSel <=1; RegFileSel <=1; end
				IF3:  begin PCout <= 1; PCld<=1; Mld<=1; end
				IF4:  begin Mout <=1; IRldR<=1; end
				LDA1: begin IRAout<=1; Mld<=1; end
				LDA2: begin Mout<=1; RegWrite<=1; end
				STA1: begin Rld<=1; end
				STA2: begin Rout<=1; IRAout<=1; MemWrite<=1; end
				JMP:  begin IRAout<=1; PCsrc<=1; Jump<=1; end
				ADA1: begin IRAout<=1; Mld<=1; end
				ADA2: begin Mout<=1; Ald<=1; end
				ADA3: begin Rld<=1; end
				ADA4: begin Rout<=1; Bld<=1; end
				ADA5: begin ALUResld<=1; CZNld<=1; end
				ADA6: begin ALUResOut<=1; RegWrite<=1; end
			endcase

			casez(opcode)
				// ALUOp: 3=ADD, 1=AND, 2=OR
				4'b010?: ALUOp <= 2'd3;
				4'b011?: ALUOp <= 2'd1;
				4'b1001: ALUOp <= 2'd3;
				4'b1010: ALUOp <= 2'd1;
				4'b1011: ALUOp <= 2'd2;
			endcase
		end

		always @(posedge clk, posedge rst) begin
			if (rst)
				ps<=IDLE;
			else
				ps<=ns;
		end
	endmodule
