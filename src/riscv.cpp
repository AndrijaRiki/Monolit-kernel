//
// Created by os on 6/16/26.
//

#include "../h/riscv.hpp"

// Deklaracija asemblerske rutine iz trap.S
extern "C" void supervisorTrap();

void Riscv::popSppSpie()
{
    __asm__ volatile("csrc sstatus, %0" :: "r"(Riscv::SSTATUS_SPP));
    __asm__ volatile("csrw sepc, ra");
    __asm__ volatile("sret");
}

// AUTOMATSKA INICIJALIZACIJA TRAPOVA:
// Ova struktura i njen globalni objekat osiguravaju da se adresa handlera
// upiše u stvec kontrolni registar automatski pri podizanju sistema, pre main-a.
struct TrapInitializer {
    TrapInitializer() {
        Riscv::w_stvec((uint64)&supervisorTrap);
    }
};

// Globalna instanca koja okida konstruktor automatski
static TrapInitializer auto_trap_init;