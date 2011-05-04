// Top-level Module of a Multicycle MIPS processor
// From Exercise 7.22
module topmulti(input         clk, reset, 
                output [31:0] writedata, adr, 
                output        memwrite);

  wire [31:0] readdata;
  
  // instantiate processor and memory
  mips mips(clk, reset, adr, writedata, memwrite, readdata);
  mem mem(clk, memwrite, adr, writedata, readdata);

endmodule
