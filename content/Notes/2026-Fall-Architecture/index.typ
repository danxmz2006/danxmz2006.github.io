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

Big and small numbers are represented using extra float point registers `f0 - f31`. The IEEE 754 FP standard encoding takes the form of $(-1)^s times (1+F) times 2^(E-"bias")$.

`flw f1, 54(x5): # f1 = Mem[x5+54]`
`fsw f1, 58(x5): # Mem[x5+58] = f1`

`fadd.s` and `fadd.d`: for single/double precision operations.
`flt.s` and `flt.d`: comparison.

=== Architecture

*Register Transfer Level (RTL)* is a description of data flow between registers. It gives a meaning to the instructions. A lower-level description is *gate-level simulation*.

Datapath components are either *combinational elements* (similar to gates) or *storage elements*. Multiplexor is a simple multifunctional logic unit. A writable storage element requires clocking for synchronization. Control signal is used to select the operations / control the flow of data.

A typical execution in a clock cycle is as follows. (i) State element 1 updates. (ii) Data passes through the combinational elements. (iii) Data reaches state element 2 before next update. The clock cycle must be long enough.
- $T_"clk_q"$: Clock to the output delay through a register
- $T_"max_comb"$: The longest delay through combinational logic
- $T_s$: Setup time that inputs to a register must be stable before clock edge
- $T_h$: Hold time (that inputs to a register) must hold after the arrival of a clock edge, usually satisfied since $T_"clk_q" > T_h$

$ T_t >= T_"clk_q" + T_"max_comb" + T_s $

=== Single Cycle Datapath

Fetch: read instruction, update PC

#image("imgs/fetch.png")

Decode: send opcode and function field to the control unit, reading two values from the register file

#image("imgs/decode.png")

Execute R: perform the op and funct operation on rs1 and rs2, store the result to register file

#image("imgs/execR.png")

Execute L/S: compute address, then load/store value

#image("imgs/execLS.png")

Execute Branch operations: compare the operands read during decoding phase and compute the branch target address by adding the update PC to the 12-bit signed-extended offset field in the instruction

#image("imgs/execB.png")

The next figure combines R-type and memory access instructions by using multiplexors.

#image("imgs/RMem.png")

The *control* selects the operation to perform and controls the flow of data. The `op` field is in bits 6-0. The addresses of registers to be read are specified in rs1 field (bits 19-15) and rs2 field (bits 24-20). Addr. of register to be written is in rd (bits 11-7).
Another operand can also be a 12-bit offset for branch or L/S instructions.

#image("imgs/control.png")

The clock cycle must be timed to accommodate the slowest instruction (`load`). Some functional units (e.g. adders) must be duplicated.

=== Multi-cycle Datapath

An instruction is broken into shorter cycles. A functional unit can be used more than once per instruction (in a different cycle). To determine the current cycle and control signals, use a finite state machine.

There are 5 steps per each instruction: Ifetch (Instruction Fetch and Update PC), Dec (Instruction Decode, Register Read, Sign Extend Offset
), Exec (Execute R-type; Calculate Memory Address; Branch Comparison; Branch and Jump Completion
), Mem (Memory Read; Memory Write Completion; R-type Completion (RegFile write)), WB (Memory Read Completion (RegFile write)).

Values are saved into an internal register at the end of a cycle.

#image("imgs/multireg.png")

A FSM contains a set of states, a next state function and an output function.

#image("imgs/fsm.png")

=== Pipelining

Pipelining requires enabling some datapath components at the same time, thus some of them are duplicated (like in single cycle datapath). Additional intermediate registers are used to record the PC and instruction. Control signals and other data are propagated through the pipeline via pipeline registers.

One register file is enough to support both the ID and WB, which go to separate ports. Writes occur in the *first* half of the cycle while reads occur in the second half.

It is helpful to simplify the diagram considering the registers as one big pipeline register between each stage.

#image("imgs/pipe.png")

Control signals are generated in the same way as the single-cycle processor. Some of the control signals won't be neeed for some next-level stages and clock cycles.

#image("imgs/pipectrl.png")

Pipelining does not improve latency. The speedup is less than 5 mostly due to imbalanced stages.

=== Hazards

Three types of pipeline hazards:
+ structural hazards: attempt to use the same resource by two different instructions at the same time;
+ data hazards: attempt to use data before it's ready;
+ control hazards: attempt to make a decision about program control flow before the condition has been evaluated and the new PC target address calculated.

Hazards can always be avoided by waiting.

*Structural hazards.*

e.g. A single memory would be a structural hazard. Solved with separate IM and DM.

e.g. Write register + read register. Use half of the cycle.

*Data hazards.* There are 3 generic data hazards: write after read (can't happen in 5 stage pipeline since WB is after ID), write after write (still can't happen, writes are always in WB), and read after write (caused by true independence).

RAW hazard 1. Register use.

#image("imgs/raw1.png")

Stalling can always solve the problem but it impacts CPI.

Results can be forwarded as soon as they are available. But during load-use hazard we still needs to stall one cycle.

#image("imgs/forward.png")

#image("imgs/luhazard.png")

Forwarding is implemented using pipeline registers. If two forwardings create a conflict between the result of the WB stage instruction and the MEM stage instruction, the latter should be forwarded.

```
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd != 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRs))
		ForwardA = 10
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd != 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRs))
		ForwardA = 10
  
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd != 0)
and (EX/MEM.RegisterRd != ID/EX.RegisterRs)
and (MEM/WB.RegisterRd = ID/EX.RegisterRs))
		ForwardA = 01
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd != 0)
and (EX/MEM.RegisterRd != ID/EX.RegisterRs)
and (MEM/WB.RegisterRd = ID/EX.RegisterRs))
		ForwardA = 01
```

RAW Hazard 2. Load-Use. This time a stall is mandatory. A hazard detection unit inserts a stall between the load and its use.

```
if (ID/EX.MemRead
and ((ID/EX.RegisterRt = IF/ID.RegisterRs)
or (ID/EX.RegisterRt = IF/ID.RegisterRt)))
stall the pipeline
```

The stall hardware prevents the instructions in the IF and ID stages from progress down the pipeline by preventing the PC register and the IF/ID register from changing. A _bubble_ is inserted between the `lw` instruction (in the EX stage) and the load-use instruction (in the ID stage). The control bits in the EX, MEM, and WB control fields of the ID/EX pipeline register to 0. 

For memory-to-memory copies (`ld` + `sd`), a stall can be avoided by adding forwarding hardware from MEM/WB register to the data memory input.

*Control hazards.* Caused by branch instructions.

This can be fixed by stalling (add 3 stalls before correct execution).

It is possible to move branch decisions earlier in pipe, to the ID stage. In this case forwarding from EX/MEM to ID comparison is required. If the *previous* instruction produces one of the branch source operands, a stall is needed.

