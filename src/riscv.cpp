//
// Created by os on 6/16/26.
//

#include "../h/riscv.hpp"

extern "C" void traps();

void Riscv::popSppSpie()
{
    __asm__ volatile("csrc sstatus, %0" :: "r"(Riscv::SSTATUS_SPP));
    //__asm__ volatile("csrw sepc, ra");
    __asm__ volatile("sret");
}


void Riscv::initInternalTraps()
{
    Riscv::w_stvec((uint64)&traps | 1);
    Riscv::mc_sie(Riscv::SIE_SEIE);
    Riscv::ms_sstatus(Riscv::SSTATUS_SIE);
}