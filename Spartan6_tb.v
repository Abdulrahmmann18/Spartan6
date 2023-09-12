module Spartan6_tb();

	// signals declaration
	reg [17:0] A, B, D, BCIN;
	reg [47:0] C, PCIN;
	reg [7:0] OPMODE; 
	reg CLK, CARRYIN, RSTA, RSTB, RSTC, RSTD, RSTM, RSTP, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEC, CED, CEM, CEP, CECARRYIN, CEOPMODE;
	reg [17:0] BCOUT_EXP;
	reg [35:0] M_EXP;
	reg [47:0] P_EXP, PCOUT_EXP;
	reg CARRYOUT_EXP, CARRYOUTF_EXP;
	wire [17:0] BCOUT_DUT;
	wire [35:0] M_DUT;
	wire [47:0] P_DUT, PCOUT_DUT;
	wire CARRYOUT_DUT, CARRYOUTF_DUT;
	// DUT Instantiation
	Spartan6 DUT(A, B, C, D, CLK, CARRYIN, OPMODE, BCIN, RSTA, RSTB, RSTC, RSTD, RSTM, RSTP, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEC, CED, CEM, CEP, CECARRYIN, CEOPMODE, PCIN, BCOUT_DUT, PCOUT_DUT, P_DUT, M_DUT, CARRYOUT_DUT, CARRYOUTF_DUT);
	// clk generation block
	initial begin
		CLK = 0;
		forever
			#1 CLK = ~CLK;
	end
	// directed test stimulus
	initial begin
		// restart 
		RSTA = 1; RSTB = 1; RSTC = 1; RSTD = 1; RSTM = 1; RSTP = 1; RSTCARRYIN = 1; RSTOPMODE = 1;
		CEA = 0; CEB = 0; CEC = 0; CED = 0; CEM = 0; CEP = 0; CECARRYIN = 0; CEOPMODE = 0;
		A = 0; B = 0; C = 0; D = 0; CARRYIN = 0; OPMODE = 0; BCIN = 0; PCIN = 0;
		repeat (4) @(negedge CLK);
		BCOUT_EXP = 0; M_EXP = 0; P_EXP = 0; PCOUT_EXP = 0; CARRYOUT_EXP = 0; CARRYOUTF_EXP = 0;
		if ((BCOUT_DUT != BCOUT_EXP) || (M_DUT != M_EXP) || (P_DUT != P_EXP) || (PCOUT_DUT != PCOUT_EXP) || (CARRYOUT_DUT != CARRYOUT_EXP) || (CARRYOUTF_DUT != CARRYOUTF_EXP)) begin
			$display("Error in restart mode !!");
			$stop;
		end
		// check case P = A*(D+B)+C
		RSTA = 0; RSTB = 0; RSTC = 0; RSTD = 0; RSTM = 0; RSTP = 0; RSTCARRYIN = 0; RSTOPMODE = 0;
		CEA = 1; CEB = 1; CEC = 1; CED = 1; CEM = 1; CEP = 1; CECARRYIN = 1; CEOPMODE = 1;
		A = 10; B = 10; C = 10; D = 10; CARRYIN = 0; BCIN = 9; PCIN = 9;
		OPMODE[6] = 0; // addition to D and B
		OPMODE[4] = 1;
		OPMODE[5] = 0;
		OPMODE[1:0] = 2'b01; // use multiplication for mux_x
		OPMODE[3:2] = 2'b11; // use C for mux_z
		OPMODE[7] = 0;
		repeat (4) @(negedge CLK);
		BCOUT_EXP = 20; M_EXP = 200; P_EXP = 210; PCOUT_EXP = 210; CARRYOUT_EXP = 0; CARRYOUTF_EXP = 0;
		if ((BCOUT_DUT != BCOUT_EXP) || (M_DUT != M_EXP) || (P_DUT != P_EXP) || (PCOUT_DUT != PCOUT_EXP) || (CARRYOUT_DUT != CARRYOUT_EXP) || (CARRYOUTF_DUT != CARRYOUTF_EXP)) begin
			$display("Error, check this case !!");
			$stop;
		end
		// check case P = C-A*B
		A = 10; B = 10; C = 200; D = 10; CARRYIN = 0; BCIN = 9; PCIN = 9;
		OPMODE[6] = 0; // addition to D and B
		OPMODE[4] = 0;
		OPMODE[5] = 0;
		OPMODE[1:0] = 2'b01; // use multiplication for mux_x
		OPMODE[3:2] = 2'b11; // use C for mux_z
		OPMODE[7] = 1;
		repeat (4) @(negedge CLK);
		BCOUT_EXP = 10; M_EXP = 100; P_EXP = 100; PCOUT_EXP = 100; CARRYOUT_EXP = 0; CARRYOUTF_EXP = 0;
		if ((BCOUT_DUT != BCOUT_EXP) || (M_DUT != M_EXP) || (P_DUT != P_EXP) || (PCOUT_DUT != PCOUT_EXP) || (CARRYOUT_DUT != CARRYOUT_EXP) || (CARRYOUTF_DUT != CARRYOUTF_EXP)) begin
			$display("Error, check this case !!");
			$stop;
		end
		// check case P = A*(D-B)+PCIN
		A = 10; B = 10; C = 200; D = 50; CARRYIN = 0; BCIN = 9; PCIN = 9;
		OPMODE[6] = 1; // subtraction to D and B
		OPMODE[4] = 1;
		OPMODE[5] = 0;
		OPMODE[1:0] = 2'b01; // use multiplication for mux_x
		OPMODE[3:2] = 2'b01; // use C for mux_z
		OPMODE[7] = 0;
		repeat (4) @(negedge CLK);
		BCOUT_EXP = 40; M_EXP = 400; P_EXP = 409; PCOUT_EXP = 409; CARRYOUT_EXP = 0; CARRYOUTF_EXP = 0;
		if ((BCOUT_DUT != BCOUT_EXP) || (M_DUT != M_EXP) || (P_DUT != P_EXP) || (PCOUT_DUT != PCOUT_EXP) || (CARRYOUT_DUT != CARRYOUT_EXP) || (CARRYOUTF_DUT != CARRYOUTF_EXP)) begin
			$display("Error, check this case !!");
			$stop;
		end
		#10 $stop;
	end
endmodule
