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

// Postavlja stvec na našu sopstvenu trap rutinu (supervisorTrap iz trap.S).
//
// VAŽNO: ovo se NE poziva preko globalnog konstruktora, jer redosled
// izvršavanja globalnih konstruktora u odnosu na platformski start()/
// trapinithart() (koji takođe piše u stvec, postavljajući ga na kernelvec)
// nije garantovan. U ovom projektu se pokazalo da trapinithart() pobeđuje
// i prepiše našu vrednost pre nego što main() uopšte počne da se izvršava.
//
// Umesto toga, initTraps() se poziva LENJO (lazy), tačno jednom, iz
// SysCalls::invoke() pre prvog ecall-a. Pošto svaki syscall mora doći iz
// main()-a (ili koda koji main() pozove), a main() se poziva tek nakon
// što se start() u potpunosti završi, ovaj redosled je zagarantovan i
// korisnik ne mora ručno da poziva nikakvu init funkciju.
void Riscv::initTraps()
{
    Riscv::w_stvec((uint64)&supervisorTrap);
}