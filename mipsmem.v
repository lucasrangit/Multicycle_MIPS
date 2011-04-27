//------------------------------------------------
// mipsmem.v
// Sarah_Harris@hmc.edu 27 May 2007
// External unified memory used by MIPS multicycle
// processor
//------------------------------------------------

module idmem(input         clk, we,
             input  [31:0] a, wd,
             output [31:0] rd);

  reg  [31:0] RAM[63:0];

  initial
    begin
      $readmemh("memfile.dat",RAM);
    end

  assign rd = RAM[a[31:2]]; // word aligned

  always @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule
