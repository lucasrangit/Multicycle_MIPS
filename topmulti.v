//------------------------------------------------
// topmulti.v
// David_Harris@hmc.edu 9 November 2005
// Top level system including multicycle MIPS 
// and unified memory
//------------------------------------------------

module topmulti(input         clk, reset, 
           output [31:0] writedata, adr, 
           output        memwrite);

  wire [31:0] readdata;
  
  // instantiate processor and memory
  mips mips(clk, reset, adr, writedata, memwrite, readdata);
  idmem idmem(clk, memwrite, adr, writedata, readdata);

endmodule
