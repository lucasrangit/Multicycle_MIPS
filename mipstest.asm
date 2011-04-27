# mipstest.asm
# Sarah_Harris@hmc.edu 20 February 2007 
#
# Test the MIPS multicycle processor.  
#  add, sub, and, or, slt, addi, lw, sw, beq, j
#  extended instructions: srlv, ori, xori, jr, bne, lbu

# If successful, it should write the value 0xFE0B to memory address 108

#       Assembly                  Description           Address Machine
main:   addi $2, $0, 5          # initialize $2 = 5        0    20020005
        ori  $3, $2, 0xFEFE     # $3 = 0xFEFF              4    3443fefe
        srlv $2, $3, $2         # $2 = $3 >> $2 = 0x7F7    8    00431006
        j    forward                                       c    08000006
        addi $3, $0, 14         # not executed             10   2263000e
back:   beq  $2, $2, here       # should be taken          14   10420003
forward:addi $3, $3, 12         # $3 <= 0xFF0B             18   2063000c
        addi $31, $0, 0x14      # $31 ($ra) <= 0x14        1c   201f0014
        jr   $ra                # return to address Ox14   20   08000005
here:   addi $7, $3, -9         # $7 <= 0xFF02             24   2067fff7
        xori $6, $7, 0xFF07     # $6 <= 5                  28   38e6ff07
        bne  $3, $7, around     # should be taken          2c   14670003
        slt  $4, $7, $3         # not executed             30   00e6302a
        beq  $4, $0, around     # not executed             34   10800001
        addi $5, $0, 0          # not executed             38   20050000
around: sw   $7, 95($6)         # [95+5] = [100] = 0xFF02  3c   acc7005f
        sw   $2, 104($0)        # [104] = 0x7F7            40   ac020068
        lw   $2, 100($0)        # $2 = [100] = 0xFF02      44   8c020064
        lbu  $3, 107($0)        # $3 = 0x000000F7          48   9003006b
        j    end                # should be taken          4c   08000015
        addi $2, $0, 1          # not executed             50   20020001
end:    sub  $8, $2, $3         # $8 = 0xFE0B              54   00434022
        sw   $8, 108($0)        # [108] = 0xFE0B           58   ac08006c
