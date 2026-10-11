# Monolit-kernel

A small, multithreaded, time-sharing operating system kernel for the **RISC-V (RV64IMA)** architecture, written in C++ and RISC-V assembly.

Built as the course project for **Operating Systems 1** (Prof. Dragan Milićev) at the School of Electrical Engineering, University of Belgrade (ETF), academic year 2025/2026. The full assignment text is in *Projektni zadatak 2026 v1.0*.

The kernel is "library-style": the kernel and the user application are linked statically into a single program that shares one address space and is loaded into memory ahead of time, as in an embedded system. User "processes" are lightweight threads running inside that program. The program runs on the QEMU RISC-V emulator, on top of a stripped-down xv6 host that only boots the machine and provides a timer and a console.

---

## Features

- **Memory allocator**: contiguous first-fit allocation in `MEM_BLOCK_SIZE` blocks, with coalescing of adjacent free segments.
- **Threads**: creation, exit, `dispatch`, plus `join` and `getID` as extras beyond the spec.
- **Scheduler**: FIFO (round-robin) ready queue, with an intrusive linked list that needs no extra heap allocations.
- **Semaphores**: `open`, `close`, `wait`, `signal`, and the counted variants `wait_n` and `signal_n`.
- **Preemptive time sharing**: asynchronous context switch on the timer interrupt (default time slice: 2 timer ticks).
- **Sleeping**: `time_sleep` with wake-up driven by the timer tick.
- **Console I/O**: `getc` and `putc`, with the console interrupt routed through the trap handler.
- **Three-layer interface**: ABI, C API and C++ OO API (see below).

## Architecture

```
┌──────────────────────────────────────────┐
│          User program (app.lib)          │
├──────────────────────────────────────────┤
│  C++ OO API   Thread, Semaphore,         │  syscall_cpp.hpp / .cpp
│               PeriodicThread, Console    │
├──────────────────────────────────────────┤
│  C API        thread_create, sem_wait,   │  syscall_c.h / .cpp
│               mem_alloc, ...             │
├──────────────────────────────────────────┤
│  ABI          ecall + argument passing   │  SysCalls.hpp
│               through a0..a4             │
╞══════════════════════════════════════════╡
│  Kernel       trap handler, scheduler,   │  traps.cpp, trap.S, Thread,
│               threads, semaphores,       │  Scheduler, Semaphore,
│               allocator                  │  MemoryAllocator
├──────────────────────────────────────────┤
│  HW access module (hw.lib)               │
└──────────────────────────────────────────┘
```

### Key design decisions

| Topic | Decision |
|---|---|
| Kernel style | Monolithic, single address space, uniprocessor |
| Kernel stack | Kernel code runs on the stack of the current thread; each thread gets a `DEFAULT_STACK_SIZE` stack allocated by the C API |
| Trap entry | One vectored trap table (`stvec` in vectored mode) in `trap.S`: `ecall` and exceptions, timer (software interrupt) and external (console) interrupts each have their own entry |
| Context saving | The trap entry saves all 31 general-purpose registers (`x1`, `x3`–`x31`) on the stack. `contextSwitch.S` then swaps only `sp`, `ra` and `s0`–`s11` (the callee-saved registers) between threads |
| New threads | Start in `_thread::threadWrapper`, which enables interrupts, calls the user body and then calls `thread_exit()` |
| Mutual exclusion | Kernel code is a single critical section: interrupts are masked on trap entry by the hardware |
| Scheduling | FIFO ready list; the timer decrements the running thread's slice and forces a dispatch when it expires |
| Idle handling | `main` starts an idle thread that yields until the user thread has finished, then both are joined and the program ends |

### Memory allocator

`MemoryAllocator` is a singleton that manages the region `[HEAP_START_ADDR, HEAP_END_ADDR)`.

- Free segments form an address-ordered singly linked list stored inside the free memory itself.
- Every allocation is preceded by one descriptor block, so a request for `n` blocks consumes `n + 1` blocks.
- `free` validates the pointer (null and out-of-range checks, double-free detection) and merges the freed segment with its previous and next neighbours.

### System calls

System call numbers follow the spec (`a0` = call number, `a1…` = arguments, `a0` = return value).

| Code | C API | Notes |
|---|---|---|
| `0x01` | `void* mem_alloc(size_t)` | The C API rounds bytes up to blocks before the `ecall` |
| `0x02` | `int mem_free(void*)` | |
| `0x11` | `int thread_create(thread_t*, void(*)(void*), void*)` | The C API allocates the stack, the ABI call receives it |
| `0x12` | `int thread_exit()` | |
| `0x13` | `void thread_dispatch()` | |
| `0x15` | `void thread_join(thread_t)` | Extra (not in the spec) |
| `0x16` | `int thread_getID()` | Extra (not in the spec) |
| `0x21` | `int sem_open(sem_t*, unsigned)` | |
| `0x22` | `int sem_close(sem_t)` | Wakes all waiters; their `wait` returns an error |
| `0x23` | `int sem_wait(sem_t)` | |
| `0x24` | `int sem_signal(sem_t)` | |
| `0x25` | `int sem_wait_n(sem_t, unsigned)` | |
| `0x26` | `int sem_signal_n(sem_t, unsigned)` | |
| `0x31` | `int time_sleep(time_t)` | Period is in timer ticks |
| `0x41` | `char getc()` | |
| `0x42` | `void putc(char)` | |

### C++ API

`syscall_cpp.hpp` provides `Thread`, `Semaphore`, `PeriodicThread` and `Console`, together with global `operator new` / `operator delete` routed to `mem_alloc` / `mem_free`.

```cpp
class Worker : public Thread {
    void run() override { /* thread body */ }
};

Worker* w = new Worker();
w->start();
w->join();
delete w;
```

## Project layout

```
.
├── h/                    # Headers
│   ├── MemoryAllocator.hpp
│   ├── Scheduler.hpp
│   ├── Semaphore.hpp
│   ├── Thread.hpp
│   ├── SysCalls.hpp      # ABI layer (ecall wrappers)
│   ├── syscall_c.h       # C API
│   ├── syscall_cpp.hpp   # C++ API
│   └── riscv.hpp         # CSR access helpers
├── src/                  # Implementation
│   ├── main.cpp          # Kernel entry point
│   ├── trap.S            # Trap vector, register save/restore
│   ├── traps.cpp         # Syscall dispatch, timer and console handlers
│   ├── contextSwitch.S   # Thread context switch
│   ├── MemoryAllocator.cpp
│   ├── Scheduler.cpp
│   ├── Semaphore.cpp
│   ├── Thread.cpp
│   ├── syscall_c.cpp
│   └── syscall_cpp.cpp
├── lib/                  # Provided libraries (hw.lib, mem.lib, console.lib) and headers
├── test/                 # Public tests and userMain
├── kernel.ld             # Linker script (image loaded at 0x80000000)
└── Makefile
```

## Building and running

### Requirements

- GNU `make`
- A RISC-V 64-bit GCC toolchain (`riscv64-unknown-elf-`, `riscv64-linux-gnu-` or `riscv64-unknown-linux-gnu-`)
- `qemu-system-riscv64`
- `gdb-multiarch` (only for debugging)

The course provides a ready-made virtual machine with all of this preinstalled (see the course website).

### Commands

```bash
make qemu        # build and run in QEMU
make qemu-gdb    # build and run, waiting for a debugger on a local TCP port
make clean       # remove build artifacts
```

QEMU is started with `-machine virt -bios none -m 128M -smp 1 -nographic`. To quit QEMU, press `Ctrl+A`, then `X`.

The Makefile compiles with `-std=c++11 -ffreestanding -nostdlib -fno-rtti -march=rv64ima -mabi=lp64 -mcmodel=medany`. The standard C/C++ libraries are not used.

### Debugging

```bash
make qemu-gdb
# in a second terminal, using the port printed by make:
gdb-multiarch kernel
(gdb) target remote localhost:<port>
```

## Tests

The `test/` directory contains the public tests. `userMain` asks for a test number on the console:

| # | Test | Covers |
|---|---|---|
| 1 | `Threads_C_API_test` | Threads, C API, synchronous context switch |
| 2 | `Threads_CPP_API_test` | Threads, C++ API, synchronous context switch |
| 3 | `ConsumerProducer_C_API_test` | Semaphores, C API |
| 4 | `ConsumerProducer_CPP_Sync_API_test` | Semaphores, C++ API, synchronous context switch |
| 5 | `ThreadSleep_C_API_test` | `time_sleep` |
| 6 | `ConsumerProducer_CPP_API_test` | C++ API with asynchronous context switch |
| 7 | `System_Mode_test` | Privilege mode check (the course notes say this test is not expected to finish regularly) |

Set the `LEVEL_N_IMPLEMENTED` macros at the top of `test/userMain.cpp` to `1` for each completed task `N`.

## Task status

| # | Task | Status |
|---|---|---|
| 1 | Memory allocation (`mem_alloc`, `mem_free`) | Implemented (own allocator) |
| 2 | Threads and synchronous context switch | Implemented |
| 3 | Semaphores | Implemented |
| 4 | Asynchronous context switch, time sharing, `time_sleep`, console I/O, `PeriodicThread` | Implemented (console I/O uses the provided `console.lib`) |

## Notes and limitations

- `lib/mem.lib` is still listed in the Makefile, but the kernel uses its own `MemoryAllocator`.
- Console `getc` / `putc` are delegated to the provided `console.lib` (`__getc`, `__putc`, `console_handler`) rather than a kernel-side buffered implementation.
- The kernel assumes a uniprocessor system and does not support preemption inside kernel code.

## License

The project is built on the xv6-based course scaffolding; see [`LICENSE`](LICENSE) for the xv6 license terms.

## Author

[AndrijaRiki](https://github.com/AndrijaRiki)
