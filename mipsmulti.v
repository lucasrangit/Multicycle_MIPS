//-------------------------------------------------------
// mipsmulti.v
// David_Harris@hmc.edu 8 November 2005
// Multicycle MIPS processor
//------------------------------------------------

// files needed for simulation:
//  mipsttest.v
//  topmulti.v
//  mipsmulti.v
//  mipsparts.v

module mips(input         clk, reset,
            output [31:0] adr, writedata,
            output        memwrite,
            input  [31:0] readdata);

  wire        zero, pcen, irwrite, regwrite,
              alusrca, iord, memtoreg, regdst;
  wire [2:0]  alusrcb;    // ORI, XORI 
  wire [1:0]  pcsrc;
  wire [3:0]  alucontrol; // SRLV
  wire [5:0]  op, funct;
  wire        lbu;        // LBU

  controller c(clk, reset, op, funct, zero,
               pcen, memwrite, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst, 
               alusrcb, pcsrc, alucontrol, lbu);  // LBU
  datapath dp(clk, reset, 
              pcen, irwrite, regwrite,
              alusrca, iord, memtoreg, regdst,
              alusrcb, pcsrc, alucontrol,
				  lbu,                             // LBU
              op, funct, zero,
              adr, writedata, readdata);
endmodule

module controller(input        clk, reset,
                  input  [5:0] op, funct,
                  input        zero,
                  output       pcen, memwrite, irwrite, regwrite,
                  output       alusrca, iord, memtoreg, regdst,
                  output [2:0] alusrcb,     // ORI, XORI 
						output [1:0] pcsrc,
                  output [3:0] alucontrol,  // SRLV
						output       lbu);        // LBU

  wire [2:0] aluop;  // XORI
  wire       branch, pcwrite;
  wire       bne;  // BNE

  // Main Decoder and ALU Decoder subunits.
  maindec md(clk, reset, op,
             pcwrite, memwrite, irwrite, regwrite,
             alusrca, branch, iord, memtoreg, regdst, 
             alusrcb, pcsrc, aluop, bne, lbu);  // BNE, LBU
  aludec  ad(funct, aluop, alucontrol);

  assign pcen = pcwrite | (branch & zero) | (bne & ~zero);  // BNE

endmodule

module maindec(input        clk, reset, 
               input  [5:0] op, 
               output       pcwrite, memwrite, irwrite, regwrite,
               output       alusrca, branch, iord, memtoreg, regdst,
               output [2:0] alusrcb, // ORI, XORI
					output [1:0] pcsrc,   
               output [2:0] aluop,   // XORI
					output       bne,     // BNE
					output       lbu);    // LBU

  parameter   FETCH   = 5'b00000;   // State 0
  parameter   DECODE  = 5'b00001;   // State 1
  parameter   MEMADR  = 5'b00010;	// State 2
  parameter   MEMRD   = 5'b00011;	// State 3
  parameter   MEMWB   = 5'b00100;	// State 5
  parameter   MEMWR   = 5'b00101;	// State 5
  parameter   RTYPEEX = 5'b00110;	// State 6
  parameter   RTYPEWB = 5'b00111;	// State 7
  parameter   BEQEX   = 5'b01000;	// State 8
  parameter   ADDIEX  = 5'b01001;	// State 9
  parameter   ADDIWB  = 5'b01010;	// state a
  parameter   JEX     = 5'b01011;	// State b
  parameter   ORIEX   = 5'b01100;   // State c // ORI
  parameter   ORIWB   = 5'b01101;   // State d // ORI
  parameter   XORIEX  = 5'b01110;   // State e // XORI
  parameter   XORIWB  = 5'b01111;   // State f // XORI
  parameter   BNEEX   = 5'b10000;   // State 10 // BNE
  parameter   LBURD   = 5'b10001;  // State 11 // LBU

  parameter   LW      = 6'b100011;	// Opcode for lw
  parameter   SW      = 6'b101011;	// Opcode for sw
  parameter   RTYPE   = 6'b000000;	// Opcode for R-type
  parameter   BEQ     = 6'b000100;	// Opcode for beq
  parameter   ADDI    = 6'b001000;	// Opcode for addi
  parameter   J       = 6'b000010;	// Opcode for j
  parameter   ORI     = 6'b001101;  // Opcode for ori  // ORI
  parameter   XORI    = 6'b001110;  // Opcode for xori // XORI
  parameter   BNE     = 6'b000101;  // Opcode for bne  // BNE
  parameter   LBU     = 6'b100100;  // Opcode for lbu  // LBU

  reg [4:0]  state, nextstate;
  reg [18:0] controls;  // ORI, XORI, BNE, LBU

  // state register
  always @(posedge clk or posedge reset)			
    if(reset) state <= FETCH;
    else state <= nextstate;

  // next state logic
  always @( * )
    case(state)
      FETCH:   nextstate <= DECODE;
      DECODE:  case(op)
                 LW:      nextstate <= MEMADR;
                 SW:      nextstate <= MEMADR;
					  LBU:     nextstate <= MEMADR; // LBU
                 RTYPE:   nextstate <= RTYPEEX;
                 BEQ:     nextstate <= BEQEX;
                 ADDI:    nextstate <= ADDIEX;
                 J:       nextstate <= JEX;
					  ORI:     nextstate <= ORIEX;  // ORI
					  XORI:    nextstate <= XORIEX; // XORI
					  BNE:     nextstate <= BNEEX;  // BNE
                 default: nextstate <= FETCH;  // should never happen
               endcase
      MEMADR:  case(op)
                 LW:      nextstate <= MEMRD;
                 SW:      nextstate <= MEMWR;
					  LBU:     nextstate <= LBURD; // LBU
                 default: nextstate <= FETCH; // should never happen
               endcase
      MEMRD:   nextstate <= MEMWB;
      MEMWB:   nextstate <= FETCH;
      MEMWR:   nextstate <= FETCH;
      RTYPEEX: nextstate <= RTYPEWB;
      RTYPEWB: nextstate <= FETCH;
      BEQEX:   nextstate <= FETCH;
      ADDIEX:  nextstate <= ADDIWB;
      ADDIWB:  nextstate <= FETCH;
      JEX:     nextstate <= FETCH;
		ORIEX:   nextstate <= ORIWB;  // ORI
		ORIWB:   nextstate <= FETCH;  // ORI
		XORIEX:  nextstate <= XORIWB; // XORI
		XORIWB:  nextstate <= FETCH;  // XORI
		BNEEX:   nextstate <= FETCH;  // BNE
		LBURD:   nextstate <= MEMWB;
      default: nextstate <= FETCH;  // should never happen
    endcase

  // output logic
  assign {pcwrite, memwrite, irwrite, regwrite, 
          alusrca, branch, iord, memtoreg, regdst, bne, // BNE
          alusrcb, pcsrc, 
			 aluop,  // extend aluop to 3 bits // XORI
			 lbu} = controls;  // LBU

  always @( * )
    case(state)
      FETCH:   controls <= 19'b1010_000000_00100_000_0;
      DECODE:  controls <= 19'b0000_000000_01100_000_0;
      MEMADR:  controls <= 19'b0000_100000_01000_000_0;
      MEMRD:   controls <= 19'b0000_001000_00000_000_0;
      MEMWB:   controls <= 19'b0001_000100_00000_000_0;
      MEMWR:   controls <= 19'b0100_001000_00000_000_0;
      RTYPEEX: controls <= 19'b0000_100000_00000_010_0;
      RTYPEWB: controls <= 19'b0001_000010_00000_000_0;
      BEQEX:   controls <= 19'b0000_110000_00001_001_0;
      ADDIEX:  controls <= 19'b0000_100000_01000_000_0;
      ADDIWB:  controls <= 19'b0001_000000_00000_000_0;
      JEX:     controls <= 19'b1000_000000_00010_000_0;     
      ORIEX:   controls <= 19'b0000_100000_10000_011_0; // ORI
		ORIWB:   controls <= 19'b0001_000000_00000_000_0; // ORI
      XORIEX:  controls <= 19'b0000_100000_10000_100_0; // XORI
		XORIWB:  controls <= 19'b0001_000000_00000_000_0; // XORI
      BNEEX:   controls <= 19'b0000_100001_00001_001_0; // BNE
      LBURD:   controls <= 19'b0000_001000_00000_000_1; // LBU
      default: controls <= 19'b0000_xxxxxx_xxxxx_xxx_x; // should never happen
    endcase
endmodule

module aludec(input      [5:0] funct,
              input      [2:0] aluop,       // XORI
              output reg [3:0] alucontrol); // XORI, SRLV

    always @( * )
    case(aluop)
      3'b000: alucontrol <= 4'b0010;  // add
      3'b001: alucontrol <= 4'b1010;  // sub
		3'b011: alucontrol <= 4'b0001;  // or  // ORI
		3'b100: alucontrol <= 4'b0101;  // xor // XORI
      3'b010: case(funct)           // RTYPE
          6'b100000: alucontrol <= 4'b0010; // ADD
          6'b100010: alucontrol <= 4'b1010; // SUB
          6'b100100: alucontrol <= 4'b0000; // AND
          6'b100101: alucontrol <= 4'b0001; // OR
          6'b101010: alucontrol <= 4'b1011; // SLT
			 6'b000110: alucontrol <= 4'b0100; // SRLV
          default:   alucontrol <= 4'bxxxx; // ???
        endcase
		default: alucontrol <= 4'bxxxx; // ???
    endcase

endmodule

module datapath(input         clk, reset,
                input         pcen, irwrite, regwrite,
                input         alusrca, iord, memtoreg, regdst,
                input  [2:0]  alusrcb,     // ORI, XORI 
					 input  [1:0]  pcsrc, 
                input  [3:0]  alucontrol,  // SRLV
					 input         lbu,         // LBU
                output [5:0]  op, funct,
                output        zero,
                output [31:0] adr, writedata, 
                input  [31:0] readdata);

  // Internal signals of the datapath module

  wire [4:0]  writereg;
  wire [31:0] pcnext, pc;
  wire [31:0] instr, data, srca, srcb;
  wire [31:0] a;
  wire [31:0] aluresult, aluout;
  wire [31:0] signimm;   // the sign-extended immediate
  wire [31:0] zeroimm;   // the zero-extended immediate  // ORI, XORI
  wire [31:0] signimmsh;	// the sign-extended immediate shifted left by 2
  wire [31:0] wd3, rd1, rd2;
  wire [31:0] memdata, membyteext; // LBU
  wire [7:0]  membyte; // LBU

  // op and funct fields to controller
  assign op = instr[31:26];
  assign funct = instr[5:0];

  // datapath
  flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);
  mux2    #(32) adrmux(pc, aluout, iord, adr);
  flopenr #(32) instrreg(clk, reset, irwrite, readdata, instr);

  // changes for LBU
  flopr   #(32) datareg(clk, reset, memdata, data); // LBU
  mux4    #(8)  lbmux(readdata[31:24], readdata[23:16], readdata[15:8],
                      readdata[7:0], aluout[1:0], membyte);  // LBU
  zeroext8_32   lbe(membyte, membyteext);  // LBU
  mux2    #(32) datamux(readdata, membyteext, lbu, memdata); // LBU
  
  mux2    #(5)  regdstmux(instr[20:16], instr[15:11], regdst, writereg);
  mux2    #(32) wdmux(aluout, data, memtoreg, wd3);
  regfile       rf(clk, regwrite, instr[25:21], instr[20:16], 
                   writereg, wd3, rd1, rd2);
  signext       se(instr[15:0], signimm);
  zeroext       ze(instr[15:0], zeroimm);  // ORI, XORI
  sl2           immsh(signimm, signimmsh);
  flopr   #(32) areg(clk, reset, rd1, a);
  flopr   #(32) breg(clk, reset, rd2, writedata);
  mux2    #(32) srcamux(pc, a, alusrca, srca);
  mux5    #(32) srcbmux(writedata, 32'b100, signimm, signimmsh,
                        zeroimm,  // ORI, XORI  
                        alusrcb, srcb);
  alu           alu(srca, srcb, alucontrol, rd1[4:0],  // SRLV
                    aluresult, zero);
  flopr   #(32) alureg(clk, reset, aluresult, aluout);
  mux3    #(32) pcmux(aluresult, aluout, 
                      {pc[31:28], instr[25:0], 2'b00}, pcsrc, pcnext);
  
endmodule


