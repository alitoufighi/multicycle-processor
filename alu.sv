`timescale 1ns/1ns
module ALU(input [7:0] A, B, input Cin, clk, input [1:0] ALUOp, output logic [7:0] ALUout, output logic [2:0] CZN);
	parameter ADD=3, AND=1, OR=2;
	logic Cout, Negative, Zero;
	assign Negative = (ALUout<0)? 1 : 0;
	assign Zero = (ALUout==0)? 1 : 0;
	assign CZN = {Cout, Zero, Negative};
	always @(*) begin
		Cout <= 0;
		case(ALUOp)
			ADD:
				{Cout, ALUout} <= A + B + Cin;
			AND:
				ALUout <= A & B;
			OR:
				ALUout <= A | B;
		endcase
	end
endmodule
