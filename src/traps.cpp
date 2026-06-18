//
// Created by os on 6/16/26.
//

#include "../h/MemoryAllocator.hpp"
#include "../lib/hw.h"
#include "../h/riscv.hpp"
#include "../h/syscall_c.h"

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

extern "C" void supervisorTrapHandler(uint64* regs)
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