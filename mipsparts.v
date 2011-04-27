//------------------------------------------------
// mipsparts.v
// Sarah_Harris@hmc.edu 27 May 2007
// Components used in MIPS processor
//------------------------------------------------

module alu(	input [31:0] A, B, 
            input [3:0] F, input [4:0] shamt, // SRLV 
				output reg [31:0] Y, output Zero);
	
	wire [31:0] S, Bout;
	
	assign Bout = F[3] ? ~B : B;
	assign S = A + Bout + F[3];  // SRLV

	always @ ( * )
		case (F[2:0])
			3'b000: Y <= A & Bout;
			3'b001: Y <= A | Bout;
			3'b010: Y <= S;
			3'b011: Y <= S[31];
			3'b100: Y <= (Bout >> shamt);  // SRLV
			3'b101: Y <= A ^ Bout;  // XORI
		endcase
	
	assign Zero = (Y == 32'b0);
	
//	assign Overflow =  A[31]& Bout[31] & ~Y[31] |
//							~A[31] & ~Bout[31] & Y[31];

endmodule


module regfile(input         clk, 
               input         we3, 
               input  [4:0]  ra1, ra2, wa3, 
               input  [31:0] wd3, 
               output [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we3) rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module adder(input [31:0] a, b,
             output [31:0] y);

  assign y = a + b;
endmodule

module sl2(input  [31:0] a,
           output [31:0] y);

  // shift left by 2
  assign y = {a[29:0], 2'b00};
endmodule

module signext(input  [15:0] a,
               output [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule

module flopr #(parameter WIDTH = 8)
              (input                  clk, reset,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

module flopenr #(parameter WIDTH = 8)
                (input                  clk, reset,
                 input                  en,
                 input      [WIDTH-1:0] d, 
                 output reg [WIDTH-1:0] q);
 
  always @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule


module mux3 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, d2,
              input  [1:0]       s, 
              output [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input      [WIDTH-1:0] d0, d1, d2, d3,
              input      [1:0]       s, 
              output reg [WIDTH-1:0] y);

   always @( * )
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
endmodule

// mux5 is needed for ORI, XORI
module mux5 #(parameter WIDTH = 8)
             (input      [WIDTH-1:0] d0, d1, d2, d3, d4,
              input      [2:0]       s, 
              output reg [WIDTH-1:0] y);

   always @( * )
      case(s)
         3'b000: y <= d0;
         3'b001: y <= d1;
         3'b010: y <= d2;
         3'b011: y <= d3;
         3'b100: y <= d4;
			endcase
endmodule

// zeroext is needed for ORI, XORI
module zeroext(input  [15:0] a,
               output [31:0] y);
              
  assign y = {16'b0, a};
endmodule

// zeroext8_32 is needed for LBU
module zeroext8_32(input  [7:0] a,
               output [31:0] y);
              
  assign y = {24'b0, a};
endmodule
