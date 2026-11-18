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

=== Cache optimization

Average memory access time summarizes the three knobs:
$ "AMAT" = "hit time" + "miss rate" times "miss penalty". $

*Reducing the miss rate.* Hardware prefetching watches the access stream and fetches blocks before they are demanded. The simplest form is sequential prefetching with a _stream buffer_, a FIFO of the next $N$ lines, each with a tag. Real processors combine several prefetchers (stride and PC-localized predictors, adjacent-line prefetch, L2 stream buffers), usually close to the core where access patterns are visible; prefetching at the LLC is harder because the cache is banked and hashed.

Compiler techniques reshape data access:
- _Merging arrays_: turn two arrays `val[]` and `key[]` into one array of compound elements, so one cache line serves both fields (spatial locality).
- _Loop interchange_: swap the loop order so the array is traversed in storage order rather than by column (spatial locality).
- _Loop fusion_: combine two loops over the same data, so the second pass hits in cache (temporal locality).

*Reducing the hit time.* A _virtually indexed cache_ uses the page offset of the virtual address to index the cache, overlapping address translation with the cache lookup; the tag must still be physical. Context switches would otherwise require flushing, which PID tags avoid; aliasing (two virtual addresses mapping to one physical address) is handled by anti-aliasing hardware or page coloring. A _trace cache_ stores already-decoded micro-operations along a dynamic instruction trace, so fetch follows taken branches without re-fetching and re-decoding; Pentium 4 used one.

== DRAM

Last-level cache misses are served by main memory, so DRAM latency and bandwidth set the miss penalty. Main memory is *DRAM*: one transistor and one capacitor per cell (1T1C). The capacitor holds the bit, the wordline turns the transistor on, and the bitline reads or writes the charge. DRAM is dense and cheap but much slower than SRAM. The capacitor is physically a _trench cell_ to keep the cell small. An SRAM cell of six transistors holds its value as long as it is powered, so it is faster but far less dense; a DRAM read costs tens of ns (50–100 ns on a row-buffer miss), roughly a hundred L1 hits. Latency is what one miss pays; bandwidth is what a stream of misses can consume.

Two consequences of analog storage:
- *Destructive read.* Accessing the cell shares charge with the bitline and leaves the cell near $V_"dd" / 2$. A sense amplifier detects the small difference and immediately writes the value back.
- *Leakage.* The capacitor discharges even when idle, so DRAM is _dynamic_: all rows must be refreshed periodically (the usual retention window is 64 ms). Refresh consumes bandwidth.

Refresh is scheduled by the controller, which commands the chip to read and rewrite every row once per retention window, issuing one refresh every $t_"REFI" = 64 "ms" \/ N_"rows"$ (about 7.8 µs with 8192 rows). An all-bank refresh takes $t_"RFC"$ (hundreds of ns) and blocks the whole chip; LPDDR4 and DDR5 can refresh one bank while the others keep serving. Refresh therefore costs a few percent of bandwidth, and more at high temperature because charge leaks faster. Repeatedly activating one row can also flip its neighbors (_row hammer_), which recent standards mitigate with targeted row refresh and refresh management.

=== MAT, bank, chip, rank, channel

A _MAT_ is a two-dimensional cell array with a row decoder, a column decoder and sense amplifiers. A row access copies an entire row into the sense amplifiers, which act as the _row buffer_; a column access then selects data from that buffer. This is why a DRAM address is a (row, column) pair. A column access that finds its row already open is a _row-buffer hit_; otherwise it is a _row-buffer miss_ and must pay a precharge plus an activate. A row is also called a _page_, which names the open-page and closed-page policies below.

#image("imgs/mat.png")

A _bank_ combines several MATs with global sense amps and shared peripheral logic; it is the basic unit that can be busy independently. A _chip_ contains several banks plus the I/O interface. A _rank_ is a group of chips that together provide the full bus width and are selected together by the chip-select signal. A _channel_ is a set of DIMMs (ranks) on one memory bus attached to a memory controller.

#image("imgs/bank.png")

#image("imgs/dramchip.png")

The hierarchy is a compromise. One huge array would share peripherals and be area-efficient, but long bitlines are slow and skew grows across the array; splitting into smaller MATs keeps sensing margins and access times manageable at the cost of more peripheral circuits. For example, a 512 Mb chip can be four 128 Mb banks, each bank a grid of MATs of a few hundred wordlines by a few hundred bitlines.

=== Timing and generations

Three commands define an access:
+ *Activate* (RAS): open a row and move it into the row buffer.
+ *Read/Write* (CAS): select a column in the open row.
+ *Precharge* (PRE): close the row and prepare the bank for another row.

Important delays:
- $t_"RCD"$: activate to column command (row to sense amp).
- $t_"RAS"$: minimum time a row stays active, so data can be restored.
- $t_"CAS"$: column command to data on the bus.
- $t_"CCD"$: minimum column-to-column spacing.
- $t_"BURST"$: duration of the data burst.
- $t_"RP"$: precharge time.
- $t_"RC" = t_"RAS" + t_"RP"$: full row cycle within one bank.

Module specifications quote the triple `CL-tRCD-tRP` in clock cycles, for example 22-22-22 on DDR4-3200. The clock is then 1600 MHz (0.625 ns per cycle), so 22 cycles is 13.75 ns: a row hit returns the first word after CL (13.75 ns), while a row miss adds $t_"RP" + t_"RCD"$ and costs about 41 ns. Bandwidth is data rate times bus width, so one 64-bit channel at 3200 MT/s peaks at 25.6 GB/s, and a 64 B line is a burst of eight transfers, or four cycles.

#image("imgs/readcyc.png")

Interface generations:
- _Asynchronous DRAM_ uses RAS/CAS strobes and no clock, so timing is open-loop.
- _Fast page mode (FPM)_ keeps the row open and issues several CAS accesses to it.
- _EDO_ puts a buffer between the sense amps and the data line, overlapping column-address capture with data output.
- _Burst EDO_ increments the column address internally, so a burst needs only one address.
- _SDRAM_ adds a clock; commands are sampled on the rising edge.
- _DDR_ transfers on both edges, doubling bandwidth. It also decouples the slow cell core from the fast I/O: a $2n$-bit internal prefetch is serialized onto the bus (DDR1 $2n$, DDR2 $4n$, DDR3 $8n$). This is why data rates can grow while the array core stays at a few hundred MHz.

=== Scaling capacity

To add capacity, stack dies or PCBs, or put more DIMMs on a channel. Stacking is the denser route: bond several dies on top of each other and connect them with through-silicon vias (TSVs). HBM pushes this to the limit—four to eight DRAM dies stacked beside the processor on an interposer, with a 1024-bit interface per stack. Its pins run slower than DDR, but the wide bus delivers much more bandwidth per watt in a small package, at the cost of capacity per package and price.

The second route, more DIMMs per channel, runs into the shared bus: address and command lines fan out to every chip on every DIMM, adding capacitance and distance-dependent delay, so the signal is attenuated and skewed. Solutions put a buffer on the DIMM:
- _RDIMM_ buffers the address/command signals and redistributes them.
- _FB-DIMM_ buffers all signals, including data, through an advanced memory buffer (AMB), at the cost of heat and money.
- _LR-DIMM_ buffers all signals without the extra control logic of an AMB.

=== Memory controller

The memory controller (MC) sits between the last-level cache and DRAM. It used to be off-chip in the north bridge, which added wire delay and tied its speed to the front-side bus; modern CPUs integrate it, so it runs at core speed but fixes the memory type (a DDR4 CPU only takes DDR4).

Its roles: accept and buffer requests from cores and I/O, arbitrate, translate physical addresses into {rank, bank, row, column}, queue commands (often per bank), schedule them, drive the signaling interface, and obey all timing constraints.

Two row-buffer policies dominate:
- _Open-page_: leave the row open after an access, hoping for more hits in the same row. A row-buffer miss then costs a precharge plus an activate, which is expensive.
- _Closed-page_: precharge immediately; better for sparse or random streams with little row locality.

_Bank-level parallelism_: while one bank precharges or activates, another can transfer data. All banks still share the chip's data pins, so only one transfer happens at a time. Address mapping decides how well this works: physical address bits are partitioned into rank/bank/row/column fields (e.g. RaBaRoCo). Which bits go where trades row locality against bank parallelism; binary invertible matrices give one-to-one mappings, and entropy-based mappings send low-entropy bits to the row and high-entropy bits to the bank.

A 32-bit example uses 3 bits of rank, 2 of bank, 14 of row and 10 of column, leaving 3 low bits as the byte offset inside a word that DRAM never sees. Taking bank bits from low addresses spreads consecutive lines over banks (parallelism, less row locality); taking them from high addresses does the opposite. Channel interleaving adds another level that stripes lines across controllers.

#figure(image("imgs/addrmap.png"), caption: [Decoding a physical address into rank, bank, row and column fields])

Scheduling principles:
+ Prioritize row-buffer hits, to maximize bandwidth.
+ Prioritize latency-sensitive applications, to maximize system throughput.
+ Ensure that no application is starved, for fairness.

The classical policy is *FR-FCFS* (first-ready, first-come-first-served): among requests whose bank is ready, serve row-buffer hits first and then the oldest request. It maximizes bandwidth but can starve a stream that keeps missing its row, hence the fairness rule.

Multiple channels add bandwidth: lock-step channels act as one wider interface (for example $2 times 64 = 128$ bits), while independent channels have separate controllers and can serve different requests. Across sockets, independent channels give NUMA: local memory is fast, remote memory goes over UPI and is slower.

=== Access flow

A last-level miss turns into a DRAM transaction in four steps:
+ The controller decodes the physical address into {channel, rank, bank, row, column} and appends the request to that bank's queue.
+ If the wanted row is not open, it precharges the bank (when another row is open) and activates the wanted row ($t_"RP" + t_"RCD"$), copying it into the sense amplifiers.
+ It issues the column command; after $t_"CAS"$ data appears on the bus and the burst delivers the cache line.
+ Depending on the page policy, the row stays open or is precharged for the next access.

Steps within one bank serialize, but the controller overlaps them across banks and channels. Bank-level parallelism is what turns a pile of high-latency requests into high bandwidth.

=== High-speed signaling

As data rates rise, the bus itself becomes the problem:
- *Power*: DRAM power scales with voltage and frequency. Each DDR generation lowers the core voltage, and the DIMM keying changes (184, 240, 240 and 288 pins) so a module cannot be inserted into the wrong generation.
- *Clock skew*: a central clock arrives at chips at different times. DDR1–3 use source-synchronous strobes (DQS) sent with the data, so the receiver captures data relative to its own strobe.
- *Reflection*: a signal reflects at the end of the bus and interferes with later data; termination resistors absorb it.
- *Noise*: reflections and crosstalk close the eye. DDR2 used a symmetrical T-branch so all chips see a similar delay; DDR3 moved to a fly-by topology with short stubs, which gives a predictable delay that the controller can compensate.

High-speed links are calibrated at boot rather than trusted blindly: the controller trains write leveling and read timing per bit, and on-die termination (ODT) absorbs reflections at the receiver. DDR5 moves the voltage regulator onto the DIMM (a PMIC) and adds on-die ECC, since smaller cells and faster signaling make both power delivery and errors harder.

== Multiprocessor

=== Flynn's taxonomy and memory organization

Traditional software assumes serial execution: one CPU runs a program broken into a series of instructions, one instruction at a time. Parallel computing uses multiple compute resources at once: the program is split into subprograms that run concurrently, each subprogram is again a series of instructions, and instructions from different parts execute simultaneously on different resources.

Flynn's taxonomy (1966) classifies machines by the number of instruction streams and data streams:
+ *SISD*: one instruction stream on one data stream, the conventional uniprocessor (UNIVAC 1, IBM 360, CDC 7600).
+ *SIMD*: one instruction operates on many data items; best for regular problems such as array processing, and the model behind GPUs (SIMT is its thread-level variant).
+ *MISD*: several instruction streams on one data stream; almost no real machine of this class has ever existed.
+ *MIMD*: independent instruction streams on independent data, the model of multicore CPUs, Cray X-MP and modern supercomputers. It is the most common form today and the subject of this lecture.

General programs are irregular, so their parallelism cannot be packed into one instruction stream, and replicating cores is how a chip keeps using transistors once ILP and clock scaling stop paying off.

The memory of a multiprocessor can be organized in several ways:
- *UMA* (uniform memory access): all chips go through one interconnect to one memory, so every core sees the same latency;
- *NUMA* (non-uniform memory access): memory is distributed between the chips, so a core's local memory is fast while a remote access crosses the interconnect and is slower;
- a *distributed memory* system, where every node owns its memory and nodes communicate only over the network (a cluster).

#image("imgs/mp-uma-numa.png")

=== Memory consistency

Two different ordering problems arise when processors share memory:
- *memory consistency* is about the *global* order of all memory operations from different processors, possibly to different locations;
- *cache coherence* is about the *local* order of operations from different processors to the *same* location (cache block).

#image("imgs/mp-consistency-coherence.png")

Consider `P1: A = 1; Flag = 1;` and `P2: while (Flag == 0) {}; print A;`. If the store to `Flag` becomes visible before the store to `A` — as happens when stores wait in a write buffer — P2 can print `A = 0`. Likewise `P1: A = 1; print B;` and `P2: B = 1; print A;` can both print 0.

A third effect is *diffusion*: even without reordering, a store travels over the interconnect and reaches caches at different times, so with a chain of dependent flags (`A = 1; if (A == 1) B = 1; ...`) a distant processor may see `B = 1` but still read `A = 0`.

A *memory consistency model* specifies the legal ordering of memory events when several processors access shared memory. The hardware is free to reorder only where the model allows.

=== Sequential consistency

*Sequential consistency (SC)*: the result of any execution is the same as if the memory operations of all processors were executed in one sequential order, and the operations of each processor appear in that order in program order. Equivalently, each processor issues operations in program order and there is one total order over all of them.

SC is easy to reason about but restrictive, since it forbids overlapping or buffering memory operations, and therefore slow. It is still strong enough to build mutual exclusion from ordinary loads and stores: Dekker's and Peterson's algorithms use two flags and a `turn` variable so that only one processor can enter the critical section.

=== TSO and relaxed models

*Total store order (TSO)* is the most widely used model (x86). Its hardware implementation is a FIFO write buffer per core: stores queue up and drain to memory in order, so store→store, load→load and load→store remain in program order, but a load can bypass the core's own pending store. Only *store→load* is reordered, which is exactly why the flag example fails.

Under TSO the experiment `X = 1; r1 = Y` on P1 and `Y = 1; r2 = X` on P2 can return `r1 = r2 = 0`; under SC at least one processor must see the other's store.

More relaxed models:
+ *PSO (partial store order)*: like TSO but stores to different addresses may reorder; more flexibility, harder reasoning.
+ *RMO (relaxed memory order)*: load→store, store→store, load→load and store→load may all reorder, and explicit fences are required where order matters.
+ *Weak consistency*: memory is consistent only at synchronization operations; between barriers operations reorder freely.

The ordering rules can be summarized as a matrix of the earlier operation (Op1) against the later one (Op2). `X` means the pair must stay in order, `B` means Op2 may bypass a buffered Op1.

#table(columns: 5, align: center,
  [*Op1* \ *Op2*], [*Load*], [*Store*], [*RMW*], [*Fence*],
  [*Load*], [X], [X], [X], [X],
  [*Store*], [B], [X], [X], [X],
  [*RMW*], [X], [X], [X], [X],
  [*Fence*], [X], [X], [X], [X])

The table shows TSO; for SC the `B` becomes `X`.

=== Cache coherence and snooping

Private caches create the coherence problem: a write updates one local copy while other copies, and possibly memory, stay stale. A *bus snooper* watches every transaction on the bus and updates the state of its own copy, so all caches agree on the block.

*Write-through cache.* Every write goes to memory and invalidates the other cached copies, so a block is either V (valid, equal to memory) or I (invalid). On a store the writer's copy becomes V and the other snoopers invalidate their copies; a later read misses and reloads from memory.

*Write-back cache: MESI.* A store does not go to memory, so the protocol needs more states:
- *M* (modified): dirty, and this is the only cached copy;
- *E* (exclusive): clean, and this is the only cached copy;
- *S* (shared): clean, possibly shared with other caches;
- *I* (invalid).

A snooper issues `BusRd` on a read miss, `BusRdX` to obtain a line for writing, and `BusWB` to write a dirty line back on replacement. It answers another request with `Flush` (data on the bus, taken by both memory and the requester) or `Flush*` (data only to the requester).

#figure(image("imgs/mp-mesi.png"), caption: [MESI transitions for one cache: blue transactions are the local processor's, red ones are snooped from other processors.])

Typical transitions:
- read miss with no other copy: `PrRd` / `BusRd`, I→E;
- read hit in E stays E, and a write hit in E goes silently to M;
- write on a block in S or a write miss: `BusRdX`, invalidating the other copies, then M;
- snooped `BusRd` on E: supply the data and go to S;
- snooped `BusRd` on M: flush the dirty data and go to S;
- snooped `BusRdX`: invalidate (flush first if M), going to I;
- replacement of an M line: `BusWB`, then I.

Variants of the write-back protocol:
+ *MSI* (RISC-V): no E, so every read miss leaves the block S and the first write to a private copy still needs `BusRdX`.
+ *MEI* (PowerPC 755): no S; a second reader invalidates the first, keeping one cached copy.
+ *MOESI* (AMD Opteron, UltraSPARC): adds *O* (owned, dirty and shared). On `BusRd` the M owner becomes O and supplies the data without updating memory.
+ *MESIF* (Intel Nehalem): adds *F* (forwarding); one sharer is designated to answer requests for the block, removing duplicate transfers.

With multi-level caches, snooping every level is too expensive. Intel uses L2 as a *snoop filter* with an inclusive policy: an L2 eviction forces the L1 line out, and L1 is write-through so that L2 always holds the current data.

#image("imgs/mp-snoopfilter.png")

=== Directory-based coherence

Snooping does not scale, because every cache must watch every request. A *directory* records who has what for each block: one modified bit plus a presence bit per node. A centralized directory is simple but adds a contention point and costs $O(P)$ bits per block.

In a large machine the interconnect is no longer a bus and memory is physically distributed, so the directory is distributed as well: every address has a *home* node, which keeps that block's directory entry next to its memory.

#image("imgs/mp-directory.png")

Read miss, block clean and shared: the requester visits the home; the home returns the data and adds the requester to the presence bits.

Read miss, block dirty: the home returns the owner's ID; the request is forwarded to the owner, which sends the data to both the requester and the home; the block then becomes clean and shared.

Write miss: the home returns the sharers' IDs, updates the directory, and sends invalidations; the sharers acknowledge, the home invalidates its own copy and acknowledges, and only then does the write proceed at the requester. The home serializes requests to its blocks, which yields a total order per location.

=== Case study: Intel server chips

Haswell-EP (Xeon E5 v3) divides the LLC into slices around a bidirectional ring. Each core has L1 I/D and L2 and reaches an L3 slice through a *CBox*, the LLC coherence engine that handles snoops and directory state for the slice.

#image("imgs/mp-mesh.jpg")

Skylake-SP (Xeon Scalable) replaces the ring with a *mesh*: cores, LLC slices and I/O tiles sit on a two-dimensional grid. The CBox is renamed *CHA* (caching and home agent); each CHA owns a slice, acts as the home for the addresses mapped to it, and takes part in coherence — in effect a hardware distributed directory.

=== Design considerations

Three decisions define a coherence design:
+ *cache type*: write-through or write-back, multi-level support and inclusion policy;
+ *mechanism*: bus snooping or directory;
+ *protocol*: invalidation or update on a write, and the state set (MSI, MESI, MOESI, MESIF).