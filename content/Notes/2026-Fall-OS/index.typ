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