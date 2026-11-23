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

Buzz words: _Protection, protected/privileged instruction, event, fault, system call, interrupt._

=== Protections 

*Protected/privileged instructions*: some instructions of every CPU is restricted to use only by the OS. E.g., directly access I/O devices, manipulate memory management state, manipulate protected control registers, execute machine halt instruction.

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

System calls: used for a user program to do something privileged. ISA provides a system call instruction that causes an exception. The caller state is saved.

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

== Multiprocessor Scheduling

Buzz words: _Loosely/tightly coupled multiprocessor, static/dynamic assignment, master/slave, peer, load sharing, gang scheduling, dedicated processor assignment._

=== Classifications

A *loosely coupled* multiprocessor gives each processor its own memory and I/O channels, like a cluster. A *functionally specialized* system has dedicated processors (e.g. an I/O processor) controlled by a master. A *tightly coupled* multiprocessor shares main memory and is controlled by one OS; this is the model considered here.

=== Assigning Processes to Processors

The simplest policy treats the processors as a pooled resource and assigns processes on demand. The assignment may be *static* (a process is bound to a processor, with a dedicated short-term queue) or *dynamic* (threads move between the per-processor queues, as in Linux).

Static assignment has less overhead and permits group or *gang* scheduling, but one processor may idle while another has a backlog; a common queue fixes this. Dynamic assignment balances load but pays for migration (cache pollution, TLB shootdowns).

Two ways to organize the kernel itself:

#table(columns: (auto, auto),
  [*Master/slave*], [*Peer*],
  [kernel functions pinned to one processor; the master schedules and slaves send it requests], [kernel executes on any processor; each processor self-schedules from the pool],
  [simple, but the master is a single point of failure and a bottleneck], [no bottleneck, but the OS must prevent two processors from taking the same process and synchronize competing claims])

Usually processes are not dedicated to processors: one global queue, or several queues by priority, feeds the common pool, so the system is a *multiserver queuing architecture*.

=== Thread Scheduling

Threads execute separately from the rest of the process, so an application becomes a set of cooperating threads in one address space; on a multiprocessor this exposes true parallelism and can give dramatic speedups. Four general approaches exist:

#table(columns: (auto, auto, auto),
  [*Approach*], [*Mechanism*], [*Tradeoff*],
  [Load sharing], [global ready queue; an idle processor takes a thread], [queue contention, poor cache affinity, related threads may not run together],
  [Gang scheduling], [a set of related threads runs on a set of processors simultaneously], [less synchronization blocking and switching; needs coordination],
  [Dedicated], [each thread of an application is bound to a processor], [no time-multiplexing, but no switching cost],
  [Dynamic], [the application changes its thread count; the OS adjusts], [good utilization, depends on application cooperation])

*Load sharing* is the simplest: no centralized scheduler is needed, but the global queue needs mutual exclusion and becomes a bottleneck when many processors look for work. A preempted thread is also unlikely to resume on the same processor, which hurts the cache, and all threads of one program are unlikely to run at once, so synchronization may block them.

*Gang scheduling* addresses the last problem: a single decision schedules a set of related threads on a set of processors at the same time. *Dedicated processor assignment* goes further and gives each thread its own processor for the application's lifetime; some processors may sit idle, but in a highly parallel system effectiveness matters more than utilization, and avoiding process switching speeds up the program. *Dynamic scheduling* lets the application change the number of threads so that the OS can adjust the load.

=== Case Study: openEuler and Multicore

openEuler keeps CFS (the Completely Fair Scheduler inherited from Linux, 2007) as its standard time-sharing policy. Each task accumulates a weighted *virtual runtime* (`vruntime`); the scheduler picks the task with the smallest `vruntime` from a red-black tree, so CPU time is shared in proportion to weight and ordinary processes get fairness.

Multicore scheduling faces cache coherence, cache affinity, inter-core data sharing and load balance. A single global queue causes lock contention and cache misses, so openEuler uses per-CPU queues (multi-queue scheduling) and *migration threads* named `migration/CPUID`. Each migration thread has a stop-machine work queue: to move a process from CPU1 to CPU0, CPU0 enqueues a work function on CPU1's queue and wakes its migration thread, which cannot be preempted and performs the move immediately, balancing the load.

== Real-Time Scheduling

Buzz words: _Hard/soft real-time task, periodic/aperiodic task, deadline scheduling, laxity, rate monotonic scheduling (RMS), earliest deadline first (EDF), least laxity first (LLF)._

=== Real-Time Tasks

*Real-time computing* means that correctness depends not only on the logical result but also on the time at which it is produced. Tasks control or react to events in the outside world and must keep up with them.

A *hard real-time task* must meet its deadline; otherwise it causes unacceptable damage or a fatal error. A *soft real-time task* has a deadline that is desirable but not mandatory: it still makes sense to run the task after the deadline has passed.

*Periodic* tasks require "once per period $T$" or "exactly $T$ units apart"; *aperiodic* tasks have constraints on their deadline or start time but no period. Real-time systems control laboratory experiments, industrial processes, air traffic, telecommunications, military command and control, and robots.

=== Real-Time OS

A real-time OS needs fast process/thread switching, a small size, quick response to external interrupts, and multitasking with IPC tools such as semaphores, signals and events. It also provides special alarms and timeouts, sequential files that accumulate data quickly, preemptive priority scheduling, minimal intervals with interrupts disabled, and a way to delay a task for a fixed amount of time.

Pure round-robin preemptive scheduling and priority-driven *non-preemptive* scheduling are both unacceptable. The usable design combines priorities with clock-based interrupts and *immediate preemption*: a higher-priority task preempts the running one as soon as it becomes ready.

=== Classes of Algorithms

#table(columns: (auto, auto),
  [*Class*], [*How it works*],
  [Static table-driven], [offline feasibility analysis produces a dispatch table; a task's start time is looked up at run time],
  [Static priority-driven preemptive], [offline analysis only; a fixed-priority preemptive scheduler dispatches at run time],
  [Dynamic planning-based], [feasibility is checked at run time; a task is admitted only if its deadline can still be met],
  [Dynamic best effort], [no admission control; the system tries to meet deadlines and aborts tasks that miss them])

=== Deadline Scheduling and Laxity

Real-time applications care less about sheer speed than about completing or starting a task at the most valuable time, neither too early nor too late, despite dynamic resource demands, overloads and faults. "Priority" is a crude tool for this.

Deadline scheduling uses the ready time, starting deadline, completion deadline, processing time, resource requirements, priority and subtask scheduler, for both periodic and aperiodic tasks.

The *laxity* of a task is $L_i = d_i - (t + r_i)$, where $d_i$ is its deadline, $t$ the current time and $r_i$ the remaining computation time. It is how much later than now the task can start and still finish by $d_i$; $L_i = 0$ means it must run now. *Least laxity first (LLF)* runs the task with the smallest laxity.

=== Rate Monotonic Scheduling

Assumptions: all tasks are periodic (no aperiodic or sporadic ones), a job's deadline is the end of its period, there are no resource constraints, and tasks are preemptable.

*RMS* assigns fixed priorities by period: the shortest period gets the highest priority, and at any time the highest-priority ready task runs. It is an optimal preemptive algorithm among *fixed-priority* algorithms (all jobs of a task share one priority).

The offline schedulability test is the utilization bound

$ U = sum_(i=1)^n c_i / p_i <= n (root(n, 2) - 1) $

where $c_i$ is the computation time and $p_i$ the period. The bound $n (root(n, 2) - 1)$ falls from $0.828$ for $n = 2$ to $ln 2 approx 0.69$ as $n -> infinity$. It is sufficient but not necessary.

For $T_1 = (2, 4)$ and $T_2 = (1, 8)$, $U = 2/4 + 1/8 = 0.625 <= 0.828$, so the set is schedulable. For $T_1 = (2, 4)$ and $T_2 = (4, 8)$, $U = 1.0 > 0.828$, yet RMS still meets every deadline; the example shows why an exact analysis (response-time analysis) is needed in addition to the bound.

=== Earliest Deadline First

*EDF* assigns priorities dynamically: the task with the smallest deadline (or, for LLF, the smallest laxity) gets the highest priority, and the highest-priority ready task runs. EDF and LLF are optimal preemptive algorithms among *dynamic-priority* algorithms, since different jobs of one task may get different priorities.

The offline test is $U = sum_i c_i / p_i <= 1$, which is both necessary and sufficient. For $T_1 = (1, 3, 3)$ and $T_2 = (4, 6, 6)$, $U = 1/3 + 4/6 = 1$, so the set is schedulable. Unlike the RMS bound, this test is exact: EDF can schedule a task set if and only if it passes.

#table(columns: (auto, auto, auto),
  [], [*RMS*], [*EDF / LLF*],
  [Priority], [fixed, by period], [dynamic, by deadline/laxity],
  [Schedulability], [$U <= n (root(n, 2) - 1)$ sufficient], [$U <= 1$ necessary and sufficient],
  [Optimality], [optimal fixed-priority], [optimal dynamic-priority],
  [Practice], [analyzable, widely used], [higher schedulability, harder to implement])

=== Aperiodic Scheduling

Aperiodic tasks have deadlines but no period, so the schedule is built from the ready times and deadlines rather than from periods. The lecture works through a non-preemptive schedule of five aperiodic tasks and shows how the ordering must be chosen so that every completion deadline is met.

== Synchronization

Buzz words: _Synchronization, race condition, data race, mutual exclusion, critical section, atomic operation, lock, spinlock, semaphore, monitor, condition variable, deadlock, starvation, message passing, barrier, IPC, signal, memory barrier, interlock._

=== Why Synchronization?

Threads of one process share an address space. Global and static objects and objects allocated on the heap are shared; each thread's stack, registers and program counter are private. When two threads access the same shared data concurrently and at least one writes, the result depends on the exact interleaving of their instructions; this is a *race condition*, and the special case of conflicting accesses to one memory location is a *data race*.

For example, `x++` and `x--` on a global `x = 0` each consist of a load, a modification and a store. If both threads load before either stores, the final value can be `-1` or `1` instead of `0`. Likewise, two threads withdrawing RMB 1000 from a shared account can both read the old balance and both write back the same new balance, losing one withdrawal. The race occurs even on a uniprocessor, because a context switch can happen between the load and the store; multiple processors only make it more likely.

#figure(image("imgs/sync-race.png"), caption: [Two withdrawals interleaved: both read the old balance before either writes back])

The shared objects may be buffers, queues, lists or hash tables, and the compound operations on them must be made *atomic* — executed as a whole, with no observable intermediate state. Synchronization is the set of mechanisms that provide this atomicity and coordinate the order in which threads access shared resources. It plays the role of traffic signals: threads make progress independently, but must obey rules at intersections.

=== Critical Sections

A *critical section* (critical region) is a piece of code that accesses a shared resource and must not be executed by more than one thread at a time. A thread enters the section, accesses the shared data, and leaves; other threads wait at the entry. The programmer marks the boundaries, and the entry/exit protocol enforces mutual exclusion.

#figure(image("imgs/sync-critical.png"), caption: [Mutual exclusion with critical regions: B waits while A is inside])

A correct critical-section solution has four requirements:

- *Mutual exclusion* (safety): if one thread is in the critical section, no other thread is.
- *Progress* (liveness): a thread outside the critical section cannot prevent another thread from entering; only threads inside or trying to enter take part in the decision.
- *Bounded waiting* (liveness): a thread waiting to enter eventually enters, so no thread starves.
- *Performance*: entering and leaving costs little compared with the work inside.

The model assumes that only word-sized loads and stores are atomic, that a context switch can occur anywhere, and that threads may run at arbitrary speeds; in particular, no assumption is made about the number of CPUs.

The simplest two-thread solution is *alternation*: a shared `turn` says whose turn it is, and a thread spins while `turn` is not its own. It gives mutual exclusion, but fails progress — a thread that stops outside the critical section leaves `turn` pointing at itself and blocks the other forever.

*Peterson's algorithm* fixes the progress problem by adding a `ready` flag per thread:

```
// thread i, with j = 1 - i
ready[i] = true;
turn = j;
while (turn == j && ready[j]) ;
// critical section
ready[i] = false;
```

If both threads try to enter, both set their flags, and the last write to `turn` loses: that thread sees `turn == j` and spins, while the other enters. If the other thread is outside and not interested, its flag is false, so the interested thread enters. Hence mutual exclusion holds and, because the loser enters as soon as the winner leaves, waiting is bounded. Peterson's algorithm assumes atomic loads/stores and sequential consistency; a compiler or CPU that reorders the flag and `turn` writes can break it unless fences are used.

The mechanisms for building critical sections are atomic read/write instructions, locks, semaphores, monitors and message passing; the rest of this section develops atomic instructions, locks, semaphores and monitors.

=== Locks

A *lock* is an object with `acquire()` and `release()` operations. A thread holds the lock between the pair; `acquire()` does not return until the previous holder releases. A lock whose waiters busy-wait is a *spinlock*; a lock whose waiters block is a *mutex*.

The naive implementation is itself a critical section:

```
while (lock->held) ;   // check
lock->held = true;     // then set
```

Two threads can both observe `held == false` and both acquire the lock. The check and the set must be a single atomic instruction. *Test-and-set* returns the old value and sets the flag:

```
bool test_and_set(bool *flag) {
  bool old = *flag;
  *flag = true;
  return old;
}

void acquire(lock) { while (test_and_set(&lock->held)) ; }
void release(lock) { lock->held = false; }
```

`swap`/`xchg` provides the same primitive. This works on multiprocessors, but a spinner burns CPU while the holder cannot run; on a uniprocessor it is especially wasteful. A waiter can call `thread_yield()` instead of spinning, but the general fix is to sleep and be woken when the lock is released.

Another way is to *disable interrupts* around the critical section: with interrupts off, no timer or I/O interrupt can cause a context switch. It works on a uniprocessor only, since it does not stop another processor, and it hides or delays important events, so it is used only for short kernel primitives and never around a long critical section.

The usual compromise is a blocking lock with a queue. `acquire()` disables interrupts just long enough to check the lock; if it is held, the thread is put on the lock's queue and blocked with interrupts enabled. `release()` disables interrupts, clears the flag and, if the queue is non-empty, removes and unblocks one waiter; then it re-enables interrupts. Waiting now costs a context switch rather than a full time slice.

=== Semaphores

A *semaphore* is an integer with a wait queue and two atomic operations. `P()` (wait, down) waits until the value is positive and then decrements it; `V()` (signal, up) increments it and wakes one waiter. The value is never negative, and `V()` has *history*: if nobody is waiting, the increment is remembered for the next caller.

A *binary semaphore* (mutex) has values 0 and 1 and provides mutual exclusion. A *counting semaphore* has values 0 to N and represents N identical resources. Mutual exclusion is then:

```
sem mutex = 1;
P(&mutex);
// critical section
V(&mutex);
```

Semaphores also express ordering, as in the bounded-buffer producer/consumer:

```
sem empty = N, full = 0, mutex = 1;

producer: P(&empty); P(&mutex); put(item); V(&mutex); V(&full);
consumer: P(&full);  P(&mutex); item = get(); V(&mutex); V(&empty);
```

The resource semaphore must be taken before the mutex. Otherwise a producer holding `mutex` can block on `full` while the consumer cannot enter to drain the buffer, and the two deadlock.

Two semaphores can also deadlock directly. With `S = Q = 1`, if one thread does `P(S); P(Q)` while another does `P(Q); P(S)`, each holds one and waits for the other forever. Because semaphores are untyped global variables, nothing prevents `V()` before the critical section, a missing `V()`, or a second `P()`; all are programmer errors.

The readers-writers problem uses a counting variable and two semaphores:

```
int readcount = 0;
sem mutex = 1, w_or_r = 1;

reader:
  P(&mutex); readcount++;
  if (readcount == 1) P(&w_or_r);   // first reader locks out writers
  V(&mutex);
  read;
  P(&mutex); readcount--;
  if (readcount == 0) V(&w_or_r);   // last reader lets writers in
  V(&mutex);

writer:
  P(&w_or_r); write; V(&w_or_r);
```

`w_or_r` excludes writers from readers and writers from one another; `mutex` protects `readcount`. If readers keep arriving while a writer waits, the writer starves; a turnstile that makes new readers wait behind a pending writer fixes this.

=== Monitors and Condition Variables

A *monitor* is a programming-language construct that bundles shared data with the procedures that operate on it. The compiler inserts lock/unlock around every procedure, so only one thread executes inside the monitor at a time and other callers wait in an entry queue. The synchronization is part of the data abstraction and cannot be forgotten by a caller.

#figure(image("imgs/sync-monitor.png"), caption: [Monitor queues: entry queue, condition queues, and the single thread executing inside])

A monitor alone cannot express "wait until the buffer has space". A *condition variable* provides that: `wait(c)` atomically releases the monitor lock, puts the thread on `c`'s queue and sleeps; on wakeup it reacquires the lock. `signal(c)` wakes one waiter and `broadcast(c)` wakes all. Condition variables have no history — a signal with no waiter is lost — and they are not booleans; the thread must recheck the real predicate.

```
monitor BoundedBuffer {
  Resource buf[N];
  int count = 0;
  Condition not_full, not_empty;

  void put(Resource r) {
    while (count == N) wait(not_full);
    buf[count++] = r;
    signal(not_empty);
  }

  Resource get() {
    while (count == 0) wait(not_empty);
    Resource r = buf[--count];
    signal(not_full);
    return r;
  }
}
```

Monitor implementations differ in what `signal()` does:

#table(columns: (auto, auto, auto),
  [], [*Hoare*], [*Mesa*],
  [Signal], [switches immediately to the waiter], [puts the waiter on the ready queue; signaler continues],
  [On return from `wait`], [the condition is guaranteed true], [it is only a hint; the condition may have changed],
  [Typical wait], [`if (pred) wait(c)`], [`while (pred) wait(c)`],
  [Tradeoff], [easier to reason about], [fewer context switches, easier to broadcast])

Java uses Mesa semantics, so `while` is mandatory there. Hoare monitors leave less to chance but force an extra context switch on every signal.

#table(columns: (auto, auto, auto, auto),
  [*Mechanism*], [*Atomicity from*], [*Waiting*], [*Main pitfall*],
  [Spinlock], [hardware test-and-set/swap], [busy-wait], [wastes CPU; long critical sections],
  [Disable interrupts], [the CPU], [none], [uniprocessor only; hides I/O],
  [Blocking lock], [atomic instruction + queue], [block], [context-switch cost],
  [Semaphore], [atomic `P`/`V`], [block], [deadlock; misuse; no ownership],
  [Monitor], [compiler/runtime], [block], [signal semantics; lost wakeup],
  [Message passing], [atomic send/receive], [block or buffer], [lost messages; ordering],
  [Barrier], [counter and lock], [block until all arrive], [a missing process stalls all])

=== Messages and Barriers

*Message passing* is a synchronization and communication model based on the atomic transfer of data across a channel. The primitives are `send(destination, &message)` and `receive(source, &message)`. Unlike locks and semaphores, it needs no shared memory: the receiver blocks until a message arrives, and the sender may block until the receiver is ready (a rendezvous) or until there is room in the channel.

The model raises issues beyond mutual exclusion: messages and acknowledgements can be lost, so a reliable protocol needs sequence numbers and retransmission; messages can arrive out of order; naming can be direct (process id) or indirect (mailbox); and the receiver may need authentication. Blocking/non-blocking and buffered/unbuffered sends give different semantics.

The producer-consumer problem can be solved with messages alone, using the messages themselves as the buffer. The consumer first sends N empty messages to the producer; the producer waits for an empty message, fills it with an item and sends it back; the consumer receives a full message, consumes the item and returns the empty message.

```
#define N 100

void producer(void) {
  message m;
  while (TRUE) {
    receive(consumer, &m);              /* wait for an empty message */
    build_message(&m, produce_item());
    send(consumer, &m);                 /* hand a full message to consumer */
  }
}

void consumer(void) {
  message m;
  for (int i = 0; i < N; i++) send(producer, &m);  /* N empty messages */
  while (TRUE) {
    receive(producer, &m);              /* get a full message */
    consume_item(extract_item(&m));
    send(producer, &m);                 /* return the empty message */
  }
}
```

A *barrier* is a synchronization point at which every process must arrive before any can proceed. Processes approach the barrier; all but the last block; when the last one arrives, all are released. Barriers are natural for iterative parallel algorithms: in a parallel matrix multiplication, each phase of `multiply` and `add` must finish before the next phase reads the updated blocks, so a barrier separates the phases. The lecture's recursive example partitions A, B and C into quadrants, forks eight sub-multiplications (four writing C, four writing a temporary T), joins, then forks the four additions of T into C and joins again; each join acts as a barrier.

#figure(image("imgs/barrier.png"), caption: [Use of a barrier: all processes wait until the last one arrives])

A barrier is implemented with a shared counter, a mutex and a condition variable (or with a sense-reversing flag). Each arriving thread increments the counter; if it is not the last, it waits; the last thread resets the counter and wakes all waiters. `pthread_barrier_wait` is the POSIX interface.

=== Concurrency Mechanisms in Unix and Linux

UNIX provides a variety of interprocess communication (IPC) and synchronization mechanisms:

- *Pipes*: a circular buffer implementing the producer-consumer model as a FIFO, written by one process and read by another. A pipe is either named (`mkfifo my_pipe`, removed with `rm my_pipe`) or unnamed (created by `pipe()` and inherited across `fork`).
- *Messages*: a message is a block of bytes with an accompanying type. The `msgsnd` and `msgrcv` system calls send and receive messages; each process has a message queue that works like a mailbox, so messages can be selected by type.
- *Shared memory*: a common block of virtual memory mapped into several processes, with read-only or read-write permission decided per process. The shared-memory facility itself provides no mutual exclusion; the processes must impose it with locks or semaphores.
- *Semaphores*: System V Release 4 generalizes the `semWait` and `semSignal` primitives; a queue of processes blocked on the semaphore is associated with it.
- *Signals*: a software mechanism that informs a process of an asynchronous event, similar to a hardware interrupt but without priorities. A signal is delivered by updating a field in the process table; the process handles it with a handler or a default action (ignore, terminate, stop, continue). Examples are `SIGINT` (Ctrl-C), `SIGKILL`, `SIGSEGV`, `SIGALRM` and `SIGCHLD`.

The Linux kernel provides all of the above plus its own mechanisms:

- *Atomic operations*: integer and bitmap operations that execute without interruption or interference, such as `atomic_t` with `atomic_inc`, `atomic_dec_and_test`, and `set_bit`/`test_and_set_bit`. They are the building blocks of locks and reference counts.
- *Spinlocks*: a lock is an integer; 0 means free. A thread sets it to 1 and enters; another thread keeps checking until it becomes 0. The API is `spin_lock`/`spin_unlock`, with `_irqsave` variants that also disable local interrupts. A spinlock holder must not sleep, and the lock is not recursive.
- *Semaphores*: binary, counting and reader-writer semaphores. `struct semaphore` uses `down()`/`up()` (and `down_interruptible()`); `struct rw_semaphore` uses `down_read`/`up_read` and `down_write`/`up_write`, admitting many readers or one writer.
- *Memory barriers*: enforce the order in which loads and stores reach memory and prevent the compiler or CPU from reordering accesses across the barrier. `barrier()` is a compiler barrier; `mb()`, `rmb()` and `wmb()` are full, read and write barriers, with `smp_` variants for multiprocessors.

=== Classic Synchronization Problems

==== Bounded Buffer

A bounded buffer is a set of N slots shared by producer and consumer threads. The producer inserts items and the consumer removes them; the two run at different rates, and the buffer decouples them so that neither waits for an explicit handoff.

The safety condition is that the number of items in the buffer stays between 0 and N. If `n_p` items have been produced and `n_c` consumed, then $0 <= n_p - n_c <= N$; the counting semaphores are `empty = N - (n_p - n_c)` and `full = n_p - n_c`, and a binary `mutex` protects the buffer list.

The producer does `P(empty)`, `P(mutex)`, insert, `V(mutex)`, `V(full)`; the consumer does `P(full)`, `P(mutex)`, remove, `V(mutex)`, `V(empty)`. The `P(empty)`/`P(full)` pair is the *interlock* that carries the count; the mutex only protects the list. The order matters: the resource semaphore must be taken before the mutex. If a producer took the mutex first and then blocked on `empty`, the consumer could not enter the critical section to remove an item, and both would deadlock.

The monitor version keeps `count` and two condition variables, `not_full` and `not_empty`: `put` waits while `count == N`, `get` waits while `count == 0`, and each signals the other after changing `count`. With Hoare semantics an `if` suffices; under Mesa semantics the wait must be in a `while` loop because the condition may change before the thread runs again. (The bounded-buffer code with semaphores and with a monitor appeared in the previous section.)

==== Dining Philosophers

Five philosophers sit around a table with five forks, one between each pair. A philosopher alternates thinking and eating; eating needs both adjacent forks, and a philosopher picks up one fork at a time. The question is how to prevent deadlock and starvation.

#figure(image("imgs/philosophers.png"), caption: [Five philosophers, five forks])

The naive solution — everyone picks up the left fork and then the right — deadlocks: all five can hold their left fork and wait forever for the right one, forming a cycle. This is the "nonsolution" in which each philosopher holds one fork.

Standard fixes:

- allow at most four philosophers at the table, so at least one can always get both forks;
- pick up both forks atomically under a global mutex (correct, but serializes eating);
- make the order asymmetric: odd-numbered philosophers take the left fork first, even-numbered take the right fork first, which breaks the circular wait;
- use a monitor that grants both forks only when both neighbors are not eating.

Tanenbaum's monitor solution keeps `state[i]` in `{THINKING, HUNGRY, EATING}` and one semaphore `s[i]` per philosopher. `take_forks(i)` marks `i` hungry and calls `test(i)`; `test(i)` lets `i` eat (and performs `up(&s[i])`) only if neither neighbor is eating. `put_forks(i)` marks `i` thinking and tests both neighbors. The philosopher then blocks on `down(&s[i])` only if the forks were not granted.

```
#define N 5
#define LEFT  (i + N - 1) % N
#define RIGHT (i + 1) % N
#define THINKING 0
#define HUNGRY   1
#define EATING   2

int state[N];
semaphore mutex = 1;   /* protects state[] */
semaphore s[N];        /* one per philosopher, initially 0 */

void philosopher(int i) {
  while (TRUE) {
    think();
    take_forks(i);
    eat();
    put_forks(i);
  }
}

void take_forks(int i) {
  down(&mutex);
  state[i] = HUNGRY;
  test(i);
  up(&mutex);
  down(&s[i]);         /* block if test() did not grant the forks */
}

void put_forks(int i) {
  down(&mutex);
  state[i] = THINKING;
  test(LEFT);
  test(RIGHT);
  up(&mutex);
}

void test(int i) {
  if (state[i] == HUNGRY && state[LEFT] != EATING && state[RIGHT] != EATING) {
    state[i] = EATING;
    up(&s[i]);
  }
}
```

A philosopher blocks only while a neighbor is eating, and that neighbor will eventually finish, so the solution is deadlock-free. It is not strictly starvation-free under an adversarial scheduler, but it is fair in practice.

==== Sleeping Barber

A barbershop has one barber, one barber chair and N waiting chairs. A customer enters; if a waiting chair is free he sits, otherwise he leaves. The barber sleeps when nobody is waiting, and a customer must wake him.

Three semaphores and one counter are enough: `customers` counts waiting customers (the barber waits on it), `barbers` counts available barbers (the customer waits on it), and `mutex` protects `waiting`. `waiting` counts customers waiting, not the one being cut.

```
#define CHAIRS 5
semaphore customers = 0, barbers = 0, mutex = 1;
int waiting = 0;

void barber(void) {
  while (TRUE) {
    down(&customers);      /* sleep if there is no customer */
    down(&mutex);
    waiting--;             /* take one waiting customer */
    up(&barbers);          /* tell the customer the barber is ready */
    up(&mutex);
    cut_hair();            /* outside the critical section */
  }
}

void customer(void) {
  down(&mutex);
  if (waiting < CHAIRS) {  /* a chair is free */
    waiting++;
    up(&customers);        /* wake the barber */
    up(&mutex);
    down(&barbers);        /* wait until the barber is ready */
    get_haircut();
  } else {
    up(&mutex);            /* shop full: leave */
  }
}
```

Operations on `waiting` are protected by `mutex`; `customers` carries the number of waiting customers and serves as the barber's sleep queue; `barbers` synchronizes the customer with the barber after a chair has been secured. Signalling a semaphore inside the critical section is safe because `up` does not block, and the haircut itself is done outside the lock.

The three classic problems are templates: the bounded buffer combines resource counting with mutual exclusion, the dining philosophers illustrate deadlock avoidance, and the sleeping barber models a server with a limited waiting room.
