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