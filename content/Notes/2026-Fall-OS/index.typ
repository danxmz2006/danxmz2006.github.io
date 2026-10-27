#import "../index.typ": template, tufted

#show: template.with(
  title: "操作系统",
  description: "2026 Fall",
  date: datetime(year: 2026, month: 9, day: 6),
  lang: "zh",
)

#set math.equation(numbering: none)

== Von Neumann Architecture

Buzz words: _Von Neumann architecture, memory-storage hierarchy, I/O device, bus._

Important concepts of von Neumann architecture include *instructions* and *program counter*. 

#figure(image("imgs/von-neumann.png"), caption: [Von Neumann Architecture])

Non von Neumann architectures: Harvard architecture (separate instruction memory and data memory), etc.

A major bottleneck is moving data between devices. Thus *memory-storage hierarchy* is developed.

#figure(image("imgs/memory-hierarchy.png"), caption: [Memory-storage Hierarchy])

Programmers deal with I/O devices with *device drivers*.

In Linux/Unix, the user space includes application and libraries; the kernel space includes portable OS layer and machine-dependent layer.

== Hardware Features for the OS

Buzz words: _Protection, protected/priviledged instruction, event, fault, system call, interrupt._

=== Protections 

*Protected/priviledged instructions*: some instructions of every CPU is restricted to use only by the OS. E.g., directly access I/O devices, manipulate memory management state, manipulate protected control registers, execute machine halt instruction.

The architecture must support *kernel mode* and *user mode*. OS executes in kernel mode. 

To switch from user mode to kernel mode, use a special system call (exception).

Memory management hardware (MMU) provices memory protection mechanisms. Manipulating MMU uses protected operations.

=== Events

An event is an "unnatural" change in control flow. Events stop current execution, change mode and/or context. The kernel defines a handler for each type of event.

Events are categorized into *interrupts* (caused by an external event) and *exceptions* (caused by executing instructions). Events are either unexpected or deliberate.

#align(center, table(columns: (auto, auto, auto), 
[], [Unexpected], [Deliberate], 
[Exceptions (sync)], [fault], [system call],
[Interrupts (async)], [interrupt], [software interrupt]))

Faults: detected and reported by *hardware*. Upon exceptional conditions, hardware faults and saves state. Some faults are handled by fixing the condition (e.g. page faults). Some faults are handled by notifying the process. Faults in the kernel cause the OS to crash.

System calls: used for a user program to do something priviledged. ISA provides a system call instruction that causes an exception. The caller state is saved.

== Processes

Buzz words: _Process, execution state, address space, context switch, process control block (PCB)._

The process in the OS is an abstraction for execution (sometimes called job/task/sequential process).

A process has an *execution state* that indicates what is it currently doing: running/ready/waiting.

Each process has its own *address space*. The kernel is usually in the high memory.

#image("imgs/addrspace.png")

=== Process Data Structures

The kernel represents a process by a *process control block (PCB)*. It contains all the info about a process.

The OS maintains a queue for each state, each containing PCBs.

A *context switch* happens with two stages: the OS stops running a process and save its current hardware states into PCB; the OS is ready to start running a process and loads the hardware registers from the value stored in PCB.

=== Working on Processes

The `exec()` call stops the current process and load `prog` into the process' address space. It initializes hardware context and args for the new program, and places the PCB onto the ready queue. It does not create a new process.

`fork()` creates a child process.

`exit()` is used to end a process. (The OS does the cleanup process.)

`wait()` suspends the current process until a child process ends. `waitpid()` specifies the child process PID.

== Threads

Buzz words: _Threads, multithreading, sharing, scheduling._

The *thread* defines a sequential execution stream within a process (PC, SP, registers). The process defines the address space and general process attributes. Threads become the unit of scheduling.

The thread model includes shared information and private states. In special, each thread has its own execution stack (must not overlap).

Web servers create a new thread for each request.

OS-managed threads are called *kernel-level threads* or *lightweight processes*. *User-level threads* are managed entirely by the run-time system and are small and fast.

A thread is represented by a PC, registers, stack, and small *thread control block (TCB)*. Manipulating threads is done via procedure call.

User-level threads are invisible to the OS, so it might make poor decisions when scheduling. Solving this requires communication between the kernel and the user-level thread manager.

=== Implementing Threads

We focus on user-level threads.

We use *non-preemptive scheduling* when threads voluntarily give up the CPU with `thread_yield`.

== Memory Management

Buzz words: _Address space, physical/virtual address, relocation, internal fragmentation, external fragmentation, compaction, swapping._

Memory manager is the part of the operating system that manages the memory hierarchy. The goal of memory management is to provide a convenient abstraction for programming and to allocate scarce memory resources among competing processes to maximize performance with minimal overhead.

The OS provides virtual memory for managing memory.

=== Memory Abstraction

An (virtual) *address space* is the set of addresses that a process can use to address memory. Each process has its own address space (with some exceptions such as shared memory).

*Relocation* maps logical address to physical address. Static relocation converts to physical address for all memory accesses during loading. Dynamic relocation converts to physical addresses when an instruction is executed. 

Dynamic relocation is supported by the hardware named MMU (memory management unit). It has two special registers `base` and `limit`. If physical address is greater than `base + limit`, then protection fault is triggered.

When memory is full then swapping (between disk) is performed.

Memory management can be implemented with bitmaps or linked lists.

There are several memory allocation algorithms. (X-fit)

Memory compaction: merge with neighbors when is finished.

Buddy System: all free segments are in size of power in 2, find the smallest hole larger than the requested size.

Memory overlaying: different functions can reuse the same memory space if they are not dependent on each other. Virtual memory can be served as a replacement of the splitting procedure.

== Virtual Memory

Buzz words: _Paging, page table, segmentation, multi-level page tables, translation lookaside buffer (TLB)._

(Virtual) Pages are fixed-size units in the virtual address space. Page frames are the corresponding units in the physical memory. Paging solves the external fragmentation problem by using fixed sized units in both physical and virtual memory.

Virtual address has two parts: virtual page number (VPN) and offset. *Page tables* maps VPN to page frame number (PFN). A PA includes PFN and offset.

Page table includes a set of page table entries (PTEs). A PTE contains page frame and other information.

#image("imgs/pte.png")

To reduce page table size, use multiple levels. 32-bit address is divided into 10 + 10 + 12 bits. Each page table (master or secondary) takes up exactly one page.

*Segmentation* partitions memory into logically related data units. Each segment has an independent base-limit pair, the pairs are stored in the segment table.

Translation can be made more efficient using *translation lookaside buffer (TLB)*. The hardware checks TLB before going to the real page table. If a match is found in the TLB, the PTE is retrieved directly. If there is a miss, a page is evicted out of TLB and is replaced with the new entry.

#image("imgs/tlb.png")

== Page Replacement

Buzz words: _Page replacement, Demand paging, Temporal/spatial locality, Least recently used (LRU), Working Set, Copy on write, Shared memory, Mapped files._ 

The process that pages are moved between memory and disk (swapping) is called *demand paging*. The main memory is like a page cache of all the data allocated by processes in the system.

In the common case, the PTE is found in the TLB, the physical frame is combined with the offset into a physical address, which the MMU reads from. The process is done by the hardware.

If TLB does not have the mapping, either MMU loads PTE from the page table in memory (OS not involved), or a trap is triggered (software managed TLB).

When TLB has PTE, the uncommon case is that TLB faults again on PTE because of PTE protection bits. It is either an invalid reference (OS sends fault to process) or a page fault. If no free page frame exists, one page frame is chosen to evict (write back to disk if the victim page is dirty). The user process is suspended to map address into disk block and fetch disk block into page frame. When disk read is finished, VM mapping is added for page frame. The process is restarted if necessary. Dirty pages write to the _swap space_ on external memory.

Reduce fault rate requires exploiting the locality of programs.

Eviction picks the least useful page; only dirty pages are written back (each frame has a dirty bit), to the swap space.

A page fault may also occur on a page that is being paged out, in which case the page is "in the air".

=== Replacement Algorithms

*Optimal (Belady)* evicts the page used farthest in the future, and serves only as a benchmark (random is the lower bound).

*NRU* uses the `R` and `M` bits to sort pages into four classes (clearing `R` periodically) and evicts from the lowest class.

*FIFO* evicts the oldest page and suffers from *Belady's anomaly*: for A B C D A B E A B C D E, 9 faults with 3 frames but 10 with 4 (optimal 7, LRU 10 and 8); the anomaly is in fact unbounded.

*SCR* gives the oldest page with `R = 1` a second chance, and *clock* keeps the frames on a circular list with a hand instead of moving list entries.

*LRU* evicts the page unused for the longest time in the past, which needs a counter or stack per page and hardware support, so *NFU* counts references per clock tick and *aging* shifts the counters right before adding `R`.

=== Thrashing and Working Set

When faults rise, processes queue on the disk and throughput plunges (*thrashing*): starting new jobs only reduces the frames per process.

Fixed-space (*local*) allocation caps each process's pages, while variable-space (*global*) allocation adjusts them dynamically, with PFF as an indicator.

The working set $"WS"(t)$ is the set of pages referenced in the last $k$ references, i.e. in the interval $(t_k, t)$; Denning's rule is to not run a process unless its working set is in memory.

It is approximated with a window $tau$ of virtual time and the `R` bit, and *WSClock* combines it with the clock: claim clean pages older than $tau$, schedule writes for dirty ones, and keep looking if a write was scheduled.

=== Design and Implementation Issues

*Load control* swaps processes out when the working sets are too big.

Instructions and data may live in separate *I-space* and *D-space*.

*Shared memory* maps the same frame in several page tables, all of which must be updated on invalidation (mapping at the same virtual address keeps shared pointers valid).

*Copy on write* shares the parent's pages read-only in the child and copies on a write protection fault, which makes `fork()` cheap.

*Mapped files* (`mmap()`) use the file as backing store and write back only dirty pages; VM without a file is *anonymous VM*, backed by a zero page.

A *paging daemon* with a two-hand clock (the front hand writes, the back hand evicts) keeps free frames clean, and pages used for DMA must be *pinned* in memory.

Policy and mechanism are separated into the MMU handler, the page fault handler and an external pager.

#image("imgs/pgfault.png")

== Windows Virtual Memory

Buzz words: _Protected mode, segment selector/descriptor, PDE/PTE, virtual address descriptor (VAD), self-map entry, hard/soft fault, working set, PFN database._

=== Address Modes for x86

*Real mode* (8086) uses physical addresses directly, for DOS. *Protected mode* (80286) is the protected virtual address mode: it supports virtual memory, paging and safe multi-tasking, with both 16- and 32-bit code. The *8086 virtual mode* (80386) provides hardware virtualization, running real mode inside protected mode.

=== Protected Mode

A *segment selector* indexes a *segment descriptor*, which gives the base and limit of the segment. *Segmentation* turns a logical address into a linear address, and *paging* turns the linear address into a physical one.

=== Paging on i386

Two levels: a *PDE* points to a page table, a *PTE* points to the page frame. Both carry a PFN plus flags (`P` present, `R/W`, `U/S`, `PWT`, `PCD`, `A` accessed, `D` dirty, `PS` page size, `G` global). With 4KB pages the linear address is split into 10 + 10 + 12 bits.

=== Windows MM

The MM lives in `Ntoskrnl.exe`. On x86 each process gets a 4GB 32-bit address space, split into 2GB kernel and 2GB user; on x86-64 the space is large enough not to worry. Paging is *demand paging* with 4KB pages (2MB pages are also used).

Each virtual page is in one of three states:

- *Invalid*: not mapped to a section object, so a reference causes a page fault.
- *Committed*: code or data is mapped onto the page.
- *Reserved*: invalid, but the MM never allocates those addresses for another purpose, so they work as *guard pages* that stop the stack from growing too far.

The MM keeps a *VAD (virtual address descriptor)* per process, listing the mapped address range, the backing section/file and offset, and the permissions. VADs form a *balanced tree*, and the address space is completely defined by the list of VADs.

=== Page Faults

Five types: the page is not committed; access violates the permissions; a shared copy-on-write page is about to be modified; the stack needs to grow; the page is committed but not mapped in.

A *hard fault* must read the page from disk. A *soft fault* is satisfied from memory instead: the page is already mapped in another process, only a new zero page is needed, it was trimmed from the working set but is requested again before reuse, or it was compressed to enlarge physical memory.

=== Self-Map Entries

The self-map entries map the physical pages of the page tables and page directory into kernel virtual addresses, so the MM can address a PTE directly:

```
MiGetPdeAddress(va) = ((((ULONG)va) >> 22) << 2) + PDE_BASE
MiGetPteAddress(va) = ((((ULONG)va) >> 12) << 2) + PTE_BASE
```

=== Working Set and Physical Memory

Each process's working set has a minimum and a maximum size (default 20-50 and 45-345 pages). The working-set manager runs every second and throttles its own work to keep from overloading the system.

Physical memory is tracked by the *PFN database*, one entry per frame. Every page is either referenced by a valid PTE or on one of five lists: *free*, *standby*, *modified*, *zeroed* and *bad* (frames with hardware errors).

#figure(image("imgs/pfn.png"), caption: [PFN Database])

A page evicted from all working sets goes to the modified list if dirty (the modified page writer sends it back to disk) or to standby if clean; a process exit deallocates pages to the free list, and the zero-page thread turns free pages into zeroed ones. A fault on a standby page brings it straight back into a working set, a soft fault.

#figure(image("imgs/pagelists.png"), caption: [Transitions between page lists])

== Scheduling

Buzz words: _Short-/long-term scheduler, dispatcher, preemptive scheduling, throughput, turnaround/waiting/response time, starvation, priority inversion, priority inheritance, MLFQ._

=== Overview

Multiprogramming overlaps I/O and CPU to raise CPU utilization and job throughput. The mechanisms (context switch, process queues, process states) are known; *scheduling* is the policy: which process or thread runs, and for how long. The schedulable entity is called a *job*.

- The *long-term (job) scheduler* selects processes spooled on mass storage and loads them into memory (batch systems).
- The *short-term (CPU) scheduler* selects among the ready processes and allocates the CPU to one of them.
- The *dispatcher* gives the CPU to that process: switch context, switch to user mode, jump to the right place in the program. Dispatch latency (stopping one process and starting another) is pure overhead and must be fast.

Scheduling happens when a new process starts, when the running one exits or blocks, on an I/O interrupt that makes processes ready, and on a clock interrupt (e.g. every 10 ms).

*Non-preemptive*: the running process keeps the CPU until it exits or blocks (only transitions 1 and 4). *Preemptive*: it can be interrupted and forced to release the CPU.

=== Objectives and Criteria

Objectives: performance, fairness, priority, encouraging good behavior, supporting heavy loads, adapting to different environments (interactive, real-time, multimedia).

Criteria: *efficiency* (keep resources busy), *throughput* (processes completed per unit time), *turnaround time* (submission to completion), *waiting time* (sum of the time spent in the ready queue), *response time* (submission to the first response), predictability with low variance, and meeting deadlines.

Batch systems maximize throughput, minimize turnaround and maximize CPU utilization; interactive systems minimize response time; real-time systems need predictability and deadlines. All of them care about fairness, policy enforcement and resource balance.

Program behavior matters: I/O bound or CPU bound, batch or interactive, urgency, priority, page fault rate, preemption frequency, the execution time already received, and the time still needed.

=== Batch Scheduling

*FCFS (first come first serve, FIFO)*: non-preemptive; a new process enters the tail of the queue and the scheduler takes the head. For P1(24), P2(3), P3(4) all arriving at 0, the waiting times are 0, 24 and 27, so AWT is 17. It is not optimal: short jobs wait behind long ones (a basket stuck behind a full shopping cart), which the "express lane" idea fixes.

*SJF (shortest job first)*: run the shortest job first. The lengths must be known in advance. It is optimal for the AWT if all jobs are available simultaneously. The same jobs run as P4(3), P1(6), P3(7), P2(8), with waiting times 0, 3, 9, 16 and AWT 7 (FCFS: 10.25) for the same total time of 24.

SJF is not optimal when jobs arrive later: P1(10) arrives at 0 and P2(2) at 2. SJF runs P1 first, AWT 4; leaving the CPU idle for 2 units to catch P2 gives AWT 2, but wastes 2 units of CPU.

*Preemptive SJF* is *shortest remaining time first*: P1 runs for 2, P2 for 2, then P1 for the remaining 8, so the waiting times are 2 and 0 and AWT is 1, with no CPU wasted.

A problem is *starvation*: a 1-hour job arriving at 0 never runs if a 2-minute job keeps arriving every minute.

=== Interactive Scheduling

Interactive schedulers are usually preemptive: time is sliced into a *quantum* and a scheduling decision is also made at the start of each quantum. Response time dominates, though AWT still matters.

*Round robin (RR)*: one of the oldest, simplest and most used algorithms; processes take turns from the ready queue, differing from FIFO exactly by preemption. With quantum 1, P1(3), P2(4) and P3(3) give waiting times 4, 6, 6 and AWT 5.33. Problems: it ignores priority and pays context-switch overhead.

The quantum is a tradeoff: too large gives FIFO behavior and poor response time, too small gives too many context switches and wasted CPU. Heuristic: 70-80% of jobs should block within their quantum, with a typical quantum of 10 to 100 ms. A 1 ms context switch is about 1% overhead with a 100 ms quantum but about 9% with a 10 ms quantum.

*Priority scheduling*: each job has a priority, FCFS/RR applies within a level, and the highest priority job runs (higher priorities are more mission-critical, e.g. a video player over sending mail). Priorities may be static or dynamic, based on the cost to the user, the importance of the user, aging, or the percentage of CPU used recently. With priorities 4, 1, 3, 2 the order is P2, P4, P3, P1, giving waiting times 0, 8, 11, 18 and AWT 9.25, worse than SJF. Problems: it may not give the best AWT, and it may starve a process forever; *aging* fixes the latter.

=== Priority Inversion

A low-priority job L holds a lock that a high-priority job H needs; medium-priority jobs M preempt L, so H waits for M as well, and the inversion is unbounded unless all resources are shared under a suitable protocol.

*Priority inheritance*: a job holding a resource inherits the priority of any higher-priority job waiting for it, so it runs at high priority and releases the lock quickly (Sha, Rajkumar, Lehoczky, IEEE Transactions on Computers 39:9, 1990; implemented in VxWorks).

This rescued the *Mars Pathfinder* (1997). The software design assumed a timing constraint, $T_1 < T_2$; when it was violated the watchdog fired and the probe rebooted. The low-priority weather thread W locked the pipe to read data; the high-priority "Distribute Data" thread blocked while writing; an interrupt made medium-priority tasks runnable and they preempted W, so W held the lock far too long. The probe rebooted several times (July 5, 10, 11 and 14); enabling priority inheritance in VxWorks fixed it.

=== MLFQ

Algorithms can be combined: several queues, a different algorithm per queue, and processes moved between queues. *Multiple-level feedback queues (MLFQ)* use queues for different job types (interactive, CPU-bound, batch, system) with different priorities; jobs in the same queue are scheduled RR and move between queues according to execution history (feedback).

A job starts in the highest-priority queue. If its time slice expires, its priority drops one level; if it blocks before the slice expires (e.g. on I/O), its priority rises one level, up to the top. So CPU-bound jobs drop like a rock while I/O-bound jobs stay high.

The canonical Unix scheduler is MLFQ: 3-4 classes spanning about 170 priority levels (timesharing: the first 60; system: the next 40; real-time: the next 60; interrupt: the last 10 in Solaris). It schedules by priority across queues and RR within a queue, and priorities change dynamically: they rise if a process blocks before the end of its quantum and fall if it uses the whole quantum. The idea is to reward interactive processes (shell, editor: short CPU bursts that often do not finish the quantum) over CPU hogs so that response time is minimized; delaying CPU-bound jobs is acceptable.

#align(center, table(columns: (auto, auto, auto),
  [*Algorithm*], [*Preemptive*], [*Tradeoff*],
  [FCFS], [no], [simple; large AWT behind long jobs],
  [SJF / SRTF], [SRTF only], [optimal AWT if lengths known; starvation],
  [Round robin], [yes], [response time vs. quantum overhead],
  [Priority], [either], [priority; starvation, fixed by aging],
  [MLFQ], [yes], [feedback combining the above]))