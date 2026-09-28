#import "../index.typ": template, tufted

#show: template.with(
  title: "Computer Architecture",
  description: "2026 Fall",
  date: datetime(year: 2026, month:9, day: 24),
  lang: "en",
)

== Performance

(Speed) performance is the reciprocal of the execution time. "$X$ is $n$ times faster than $Y$" means $"perf"_X / "perf"_Y = n.$ 

Throughput is the amount of work done in unit time. Decreasing response time (a.k.a. execution time) *always* improves throughput.

*Clock rate* is the inverse of clock cycle time (MHz, GHz).

Performance is often measured by *latency* or *throughput*. Because of overlaps, in assembly lines throughput $>$ 1/latency.

*Clock cycles per instruction (CPI)* is the average number of clock cycles each instruction takes to execute. Let $"IC"_i$ be the percentage of class $i$ instructions, then 
$ "Overall effective CPI" = sum_i "CPI"_i times "IC"_i. $

#figure(image("imgs/CPUtime.png"), caption: [The "iron law" of performance])

We can rewrite CPU clock cycles in another way.

#image("imgs/CPUtime2.png")

Consider different applications. We can summarize performance by (weighted) arithmetic mean.

When we consider speedup, use geometric mean instead.

We often use IPC instead of CPI. When taking average of IPCs, we must use harmonic mean.

*Amdahl's law.* Suppose there is a speedup $n$ on $p$ fraction of the overall time. The overall speedup is 
$ 1 / (1 - p + p\/n). $

== RISC-V ISA 

Difference between CISC and RISC: CISC has dense instruction size, is programmer friendly and hardware unfriendly. RISC has fixed instruction lengths, load-store instruction sets, limited addressing modes and limited operations.

User level ISA defines normal instructions needed for computation. A mandatory base integer ISA (I) includes ALU, Branches/jumps and Loads/stores. 

Standard extensions:
+ M: Integer Multiplication and Division
+ A: Atomic Instructions
+ F: Single-Precision Floating-Point
+ D: Double-Precision Floating-Point
+ C: Compressed Instructions (16 bit)
+ G = IMAFD

An instruction includes `Opcode + Operand specifiers`.

RISC-V has 6 instruction formats which are all 32 bits wide. They are named R,I,S,SB,U and UJ. There are 32 registers (excluding PC), each holds a 64-bit integer. The register file has 2 read ports and 1 write port.

#image("imgs/riscvformat.png")

`add x5, x6, x7`: arithmetic instruction format (R format). `func7(7) + rs2(5) + rs1(5) + func3(3) + rd(5) + opcode(7)` Here `x5,x6,x7` correspond to `rd,rs1,rs2`.

`ld/sd x5, 24(x6)`: load/store doubleword. The memory address is 64-bit, and is formed by adding `x6` (base address register) to the offset value (12-bit, $plus.minus 2^11$ bytes). The load instruction is in the I format. `immediate(12) + rs1(5) + func3(3) + rd(5) + opcode(7)` The store instruction is in the S format. `imm[11:5](7) + rs2(5) + rs1(5) + func3(3) + imm[4:0](5) + opcode(7)`

`lb/sb` are provided to move bytes. Use signed extension when loading. When storing, ignore the upper bytes.

`addi sp, sp, 4`: immediate instruction. I format.

`lui x5, 34354`: load upper immediate. The least significant bits are filled with 0. U format. `imm[31:12](20) + rd(5) + opcode(7)`

Conditional branch: SB format. `imm[12,10:5](7) + rs2(5) + rs1(5) + func3(3) + imm[4:1,11](5) + opcode(7)`

```asm
beq rs1, rs2, L1 #goto L1 if rs1 == rs2
bne rs1, rs2, L1 #goto L1 if rs1 != rs2
```

Branch destination is specified using *PC relative address*. So the branch distance is $[-2^10,2^10-1]$ words from the instruction after the branch instruction.

`jal x1, ProcedureAddr`: procedure call (saves PC+4 in `x1`). UJ format. `imm[20,10:1,11,19:12](20) + rd(5) + opcode(7)`. When return, use `jalr x0, 0(x1)`. A long jump can be performed with `lui + jalr`.

Stack is used when a callee needs more register.

Instructions for synchronization. Consider a simple lock: check the value of the lock, value 0 indicates that the lock is free while value 1 indicates that the lock is unavailable. It can be implemented with the following compare-and-swap atomic operation:

```
Word CAS(Word *addr, Word old_val, Word new_val) {
  Word value = *addr
  if (value == old_val)
    *addr = new_val
  return value
}
```

CAS is too heavy, so RISC-V uses two R-type commands.
```asm
lr.d x5, (x6) # x5 = Mem[x6], load-reserved dword
sc.d x7, x5, (x6) # Mem[x6] = x5; x7 = 0/1, store-conditional dword
# If the contents of the memory location specified by the load-reserved 
# are changed before the store-conditional to the same address occurs,
# then the store-conditional fails and does not write the value to the memory.
```

The addressing modes include register addressing, base addressing, immediate addressing and PC-relative addressing.

An RISC-V cheatsheat can be found #link("./RISCV_CARD.pdf")[here].

== RISC-V ALU & Basic Architecture

=== ALU 

An ALU usually takes two inputs, a mode of operation and outputs a result. It also sets some flags.

A *full adder* maps $(a,b,c_"in")$ to $(s,c_"out")$. An adder based on 32 full adders is called a 32-bit ripple carry adder/subtractor. (There are more efficient implementations.) Overflow can be detected by xor-ing the carry into MSB and the carry out of MSB. 

Shift operations: `sll,srl,sra` etc.. `sra` uses msb-extends.

Typical implementations of multiplication hardwares include RCA (shift & add) and CSA. In RISC-V, multiply instructions include `mul` and `mulh`, which compute the lower part and the higher part of the product respectively.

Division is implemented naively. 

=== Architecture

*Register Transfer Level (RTL)* is a description of data flow between registers. It gives a meaning to the instructions. A lower-level description is *gate-level simulation*.

Datapath components are either *combinational elements* (similar to gates) or *storage elements*. Multiplexor is a simple multifunctional logic unit. A writable storage element requires clocking for synchronization.

A typical execution in a clock cycle is as follows. (i) State element 1 updates. (ii) Data passes through the combinational elements. (iii) Data reaches state element 2 before