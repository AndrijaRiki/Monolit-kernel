//
// Created by os on 6/16/26.
//

#include "../h/MemoryAllocator.hpp"
#include "../h/printing.hpp"
#include "../lib/hw.h"
#include "../h/riscv.hpp"
#include "../h/Scheduler.hpp"
#include "../h/syscall_c.h"
#include "../h/Thread.hpp"

/*
namespace
{
    // scause values for an ecall trap, depending on which privilege mode
    // issued it.
    constexpr uint64 ECALL_FROM_U_MODE = 0x08;
    constexpr uint64 ECALL_FROM_S_MODE = 0x09;

    // Size in bytes of the ecall instruction itself. sepc must be advanced
    // past it after handling the trap, otherwise we'd re-execute the same
    // ecall forever.
    constexpr uint64 ECALL_INSTRUCTION_SIZE = 4;

    bool isEcall(uint64 scause)
    {
        return scause == ECALL_FROM_U_MODE || scause == ECALL_FROM_S_MODE;
    }

    // regs[] mirrors the layout saved by supervisorTrap in trap.S: regs[N]
    // holds the value of register xN at the time of the trap (the A0/A1/...
    // enum from riscv.hpp gives the right indices for the ABI argument
    // registers, since e.g. A0 == 10 == x10).
    uint64 getSyscallId(uint64* regs) { return regs[A0]; }
    uint64 getArg1(uint64* regs)      { return regs[A1]; }
    void setReturnValue(uint64* regs, uint64 value) { regs[A0] = value; }

    uint64 dispatchSyscall(uint64 syscallId, uint64 arg1)
    {
        switch (syscallId)
        {
        case MEM_ALLOC:
            return (uint64)MemoryAllocator::getInstance().alloc(arg1);
        case MEM_FREE:
            return (uint64)MemoryAllocator::getInstance().free((void*)arg1);
        default:
            return 0;
        }
    }
}

extern "C" void internalTrapHandler(uint64* regs)
{
    uint64 scause = Riscv::r_scause();

    if (!isEcall(scause))
        return;

    uint64 syscallId = getSyscallId(regs);
    uint64 arg1      = getArg1(regs);

    uint64 ret = dispatchSyscall(syscallId, arg1);
    setReturnValue(regs, ret);

    // Skip past the ecall instruction so we don't trap on it again.
    Riscv::w_sepc(Riscv::r_sepc() + ECALL_INSTRUCTION_SIZE);
}
*/

/*namespace
{*/

constexpr uint64 ECALL_FROM_U_MODE = 0x08;
constexpr uint64 ECALL_FROM_S_MODE = 0x09;
constexpr uint64 ECALL_INSTR_SIZE = 4;

bool isEcal(uint64 scause)
{
    return scause == ECALL_FROM_U_MODE || scause == ECALL_FROM_S_MODE;
}
//}

void setReturnValue(uint64* regs, uint64 value)
{
    regs[A0] = value;
}

extern "C" void internalTrapHandler(uint64* regs)
{
    volatile uint64 sepc = Riscv::r_sepc();
    volatile uint64 sstatus = Riscv::r_sstatus();
    uint64 scause = Riscv::r_scause();

    if (!isEcal(scause))
    {
        printString("Unhandled exception: SEPC = ");
        printInteger(sepc, 16);
        printString(", SCAUSE = ");
        printInteger(scause, 16);
        printString(", STVAL = ");
        printInteger(Riscv::r_stval(), 16);  // ADD THIS
        printString("\n");
        Riscv::w_sstatus(sstatus);
        return;
    }

    sepc += ECALL_INSTR_SIZE;
    //Riscv::w_sepc(sepc);

    size_t call = regs[A0];
    switch (call)
    {
    case MEM_ALLOC:
        {
            size_t size = regs[A1];
            void* ret = MemoryAllocator::getInstance().alloc(size);
            regs[A0] = (uint64)ret;
            break;
        }
    case MEM_FREE:
        {
            void* ptr = (void*)regs[A1];
            int ret = MemoryAllocator::getInstance().free(ptr);
            regs[A0] = ret;
            break;
        }
    case THREAD_CREATE:
        {
            thread_t* handle = (thread_t*)regs[A1];
            thread_body_t start_routine = (thread_body_t)regs[A2];
            void* arg = (void*)regs[A3];
            void* stack = (void*)regs[A4];

            if (handle == nullptr || start_routine == nullptr || stack == nullptr)
            {
                regs[A0] = -1; //fff..fff
            }
            else
            {
                _thread* t = new _thread(start_routine, arg, stack);
                *handle = t;
                regs[A0] = 0;
            }
            break;
        }
    case THREAD_EXIT:
        {
            _thread::running->finished = true;
            thread_t curr = _thread::running->waiting;
            while (curr != nullptr)
            {
                thread_t next = curr->next;
                curr->ready = true;
                Scheduler::getInstance().addReady(curr);
                curr = next;
            }
            _thread::dispatch();
            break;
        }
    case THREAD_DISPATCH:
        {
            _thread::dispatch();
            break;
        }
    default:
        regs[A0] = 0;
    }
    Riscv::w_sepc(sepc);
    Riscv::w_sstatus(sstatus);
}