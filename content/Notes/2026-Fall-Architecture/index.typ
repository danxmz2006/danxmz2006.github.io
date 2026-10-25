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

== Branch Prediction

We dub whether a branch is taken or not _direction_ and the target address if it is taken _target_.

For conditional branches, predicting direction is difficult while computing target is easy; for indirect jumps and function returns the direction is always taken while predicting target is difficult.

*Static* direction prediction predicts the branch direction at compile time. Early predictors used always-not-taken strategies, and had about 30-40% accuracy. Always-taken has 60-70% accuracy.

BTFNT (backward taken, forward not taken) has advantage in loops. It has about 65% accuracy. Compiler directed prediction (running using test data) has about 75% accuracy.

*Dynamic* direction prediction. Branch history table (BHT) keeps a record of the previous branch behavior, allowing it to improve its predictions over time. It has 80% accuracy.

To handle short and frequently executed loops better, we can use 2-bit BHT instead (this makes the predicted direction more stable). Achieves around 90% accuracy.

It is possible to further improve branch prediction using branch correlation (to 96%) and hybrid predictors (to 97%).

A branch target buffer (BTB) caches the branch target address in the IF stage. 

Function returns are frequent and the address is difficult to predict with BTB. The return address stack solves this issue by saving the return address in a stack at call time.

== Multi-Issue Processor

The optimal number of stages is around 15.

A *dynamic multiple issue machine (superscalar)* consists of a number of pipelines that are working in parallel. Multi-port, multi-ALUs and multi-mux are needed.

If the instructions are dependent, super-scalar degenerates to pipelining. So the precessor must look ahead for independent instructions. The policy of issue and completion can be either in-order or out-of-order.

In-order: dependent on how the code is written.

Out-of-order: must remove true dependencies.

#image("imgs/superscalar.png")

*VLIW (very long instruction word)* is a static multiple-issue architecture (the decision is made by the complier). The sequential ISA is replaced with a new ISA where instruction-level parallelism is encoded. Sub-instructions within a long instruction are independent. There is a slot in a VLIW instruction for each specific functional unit.

#image("imgs/vliw.png")

The main difficulties are in the software side. Compiling techniques include loop unrolling and predicated execution (i.e. conditional move).

=== Conventional Optimization Techniques

Focus on reducing IC.

Register renaming & scheduling: eliminate false dependencies and dead codes.

Loop unrolling.

Function inlining.

Tree height reduction. Shorten critical path using associative law.

=== Optimization Techniques for ILP

To reduce CPI.

A basic block is a sequence of instructions with no branches into or out of the block. For general computation it is not big enough.

Trace scheduling is a type of global scheduling. It takes the execution trace (a sequence of basic blocks) of the common case and schedules code as if it had no branches. It checks misprediction at some point and goto the fix-up code if necessary.

Software pipelining is another optimization technique. Iterations are overlapped by starting the next iteration before the current iteration in the loop ends.

== Dynamic Scheduling 

Dynamic scheduling means *out-of-order execution*. It can potentially reduce stalls, but may introduce more hazards.

For WAW and WAR, the dependency is on name/location, not on data. So it can be solved by renaming registers (recorded in map-table). Specifically, we can map each data flow to a unique register. The output of each instruction is recorded in a new register, and each reference to its orginal output is then redirected to this new register. One can see that renaming can proceed in a streaming fashion. O3 works by fetching, renaming then scheduling.

_Scoreboard._ 5 pipeline stages: Dispatch, Issue, Rdop, Execute, WB. It doesn't use forwarding and simply stalls at WAW and WAR. 

#image("imgs/scorepipe.png")

The scoreboard (SB) is a control unit. It records the instruction status, FU status and reg status.

#image("imgs/scoreboard.png")

During each cycle, the SB checks the hazard (data & structural), and decides whether each instruction should proceed.

_Tomasulo Scheduling._ Remove false dependencies by register renaming; add forwarding. 3 stages: Issue, Exec. Comp., Write Result.

In the Tomasulo algorithm the new registers are named with the corresponding instructions. The *FP registers (FLR)* is a table with entries containing either a running instruction or the actual data. Each FU has a buffer (*Reservation station*), containing instructions with unresolved symbols. L&S instructions have something similar called *L&S buffers*. 

Whenever an execution (loading included) is finished, the data is transferred to *Common Data Bus (CDB)* and is forwarded to each RS/LSB. The data finally arrives at FLS at the write back stage.

#image("imgs/tomasulo.png")

_Re-Order Buffer._  Tomasulo does not handle exception and branch misprediction. Also, the RS cannot be freed until the instruction is finished, while its information is only needed before the instruction begins to execute.

FP registers are split into register alias table (RAT), re-order buffer (ROB) and architected register file (ARF). ARF is similar to the conventional register file, and appears to be updated in-order. Each RAT entry either points to a ROB entry or an ARF entry. ROB is the result of register renaming. Each ROB entry marks the original ARF before register renaming and the instruction who will update this ROB. ROB has a tail and a head.

Tomasulo with ROB has 4 stages: Issue, Execution, Write result and Commit. In the commit stage, if the ready bit is set in the ROB entry, the result is written to the ARF, and the RAT is redirected to the ARF.

#image("imgs/rob.png")

In Tomasulo with ROB, issue and commit are in-order while computation is out-of-order. Therefore, on branch misprediction or exception we can simply flush the instructions beyond this point, and no state is altered. Store instruction writes to memory after the instruction is committed so there is no need of a store buffer. 

== Cache

(Hardware) memory hierarchy technologies for *random access* include DRAM (high density, low power, cheap, slow) and SRAM (low density, high power, expensive, fast). Both DRAM and SRAM are volatile.

A conventional SRAM cell contains 6 transisters. #tufted.margin-note(image("imgs/sram2.png")) Wordline is used for cell selection; bitline is used for cell read or write.

Each DRAM cell consists of a transistor and a capacitor.

#image("imgs/dramcell.png")

A RAM is usually organized as a grid, consisting of word (row) lines and bit (data) lines. Each intersection is a DRAM/SRAM cell. Row decoder and column selector are used to locate the lines. Sometimes a buffer is used to store a row and reduce access time.

Two types of locality: temporal locality and spatial locality.

Larger memory hardwares are in general slower. So all memory is divided into several hierarchies.
+ Register file. Managed by compiler.
+ Instruction and data cache.
+ Second level cache (SRAM).
+ Main memory (DRAM). 
+ Secondary memory.

The first 3 levels are on chip. Cache and main memory are managed by hardware. The secondary memory is managed by OS, user and etc..

During each access the cache either hits or misses. Parameters include hit/miss rate, hit time and miss penalty.

=== Cache designs

_Direct mapped cache._ The address is divided into `tag + index + block offset + byte offset` (from high to low). Block offset is omitted when we use singleword blocks. When block size increases, the miss rate first goes down (more references to the same block) then goes up (less blocks in a cache).

_Set-Associative Cache._ Has multiple ways in a single set. The miss rate decreases as the number of ways goes up, but the return diminishes.

When a capacity miss happens, a cacheline is evicted from cache. There are several cache replacement policies.

_Least recently used._ Evict block with longest reuse distance. Difficult when more than 2 ways.