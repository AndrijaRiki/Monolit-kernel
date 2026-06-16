//
// Created by os on 6/16/26.
//

#include "../h/MemoryAllocator.hpp"
#include "../lib/hw.h"
#include "../h/riscv.hpp"
#include "../h/syscall_c.h"

extern "C" void supervisorTrapHandler(uint64* regs)
{
    uint64 scause = Riscv::r_scause();

    if (scause == 0x08 || scause == 0x09)
    {
        uint64 current_sepc = Riscv::r_sepc();

        // Čitamo direktno sa pozicije na steku gde ih je asembler sačuvao!
        // U RISC-V, x10 je A0 (syscall_id), a x11 je A1 (arg1)
        uint64 syscall_id = regs[10];
        uint64 arg1       = regs[11];

        uint64 ret = 0;
        switch(syscall_id)
        {
        case MEM_ALLOC:
            ret = (uint64)MemoryAllocator::getInstance().alloc(arg1);
            break;
        case MEM_FREE:
            ret = (uint64)MemoryAllocator::getInstance().free((void*)arg1);
            break;
        }

        // Vraćamo povratnu vrednost u registar A0 na steku
        regs[10] = ret;

        // Pomeramo se za jednu instrukciju dalje da ne uđemo u beskonačnu ecall petlju
        Riscv::w_sepc(current_sepc + 4);
    }
}