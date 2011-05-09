onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Test Bench}
add wave -noupdate -expand -group {Test Bench} /testbench/clk
add wave -noupdate -expand -group {Test Bench} /testbench/reset
add wave -noupdate -expand -group {Test Bench} -radix decimal /testbench/cycle
add wave -noupdate -expand -group {Test Bench} -radix hexadecimal /testbench/writedata
add wave -noupdate -expand -group {Test Bench} -radix hexadecimal /testbench/dataadr
add wave -noupdate -divider Controller
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/op
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/funct
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/zero
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/pcen
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/memwrite
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/irwrite
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/regwrite
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/alusrca
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/iord
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/memtoreg
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/regdst
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/alusrcb
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/pcsrc
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/alucontrol
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/aluop
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/branch
add wave -noupdate -group Controller -radix binary /testbench/dut/mips/c/pcwrite
add wave -noupdate -divider Datapath
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/clk
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/reset
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/pcen
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/irwrite
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/regwrite
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/alusrca
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/iord
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/memtoreg
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/regdst
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/alusrcb
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/pcsrc
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/alucontrol
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/zero
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/adr
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/writedata
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/readdata
add wave -noupdate -group Datapath -radix binary /testbench/dut/mips/dp/writereg
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/pcnext
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/pc
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/instr
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/data
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/srca
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/srcb
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/a
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/aluresult
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/aluout
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/signimm
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/signimmsh
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/wd3
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/rd1
add wave -noupdate -group Datapath -radix hexadecimal /testbench/dut/mips/dp/rd2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 220
configure wave -valuecolwidth 65
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {62 ns}
