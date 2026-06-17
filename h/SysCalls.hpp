//
// Created by os on 6/16/26.
//

#ifndef PROJEKAT_SYSCALLS_HPP
#define PROJEKAT_SYSCALLS_HPP

#include "../lib/hw.h"
#include "../h/riscv.hpp"

class SysCalls
{
public:
    template <typename T>
    static inline T invoke(uint64 id)
    {
        ensureTrapsInstalled();

        register uint64 r_id asm("a0") = id;
        register T ret asm("a0");

        asm volatile(
            "ecall"
            : "=r" (ret)
            : "r" (r_id)
            : "memory"
        );
        return ret;
    }

    //with 1 argument
    template <typename T, typename Arg1>
    static inline T invoke(uint64 id, Arg1 arg1)
    {
        ensureTrapsInstalled();

        register uint64 r_id asm("a0") = id;
        register uint64 r_arg1 asm("a1") = (uint64)arg1;
        register T ret asm("a0");

        asm volatile(
            "ecall"
            : "=r" (ret)
            : "r" (r_id), "r" (r_arg1)
            : "memory"
        );

        return ret;
    }

private:
    // Installs our supervisorTrap handler into stvec exactly once, the
    // first time any syscall is invoked. A function-local static is
    // guaranteed to run-once and, since it only runs as part of an actual
    // ecall request (which can only happen after main() has started),
    // it's guaranteed to run AFTER the platform's own trapinithart() has
    // already overwritten stvec. This means user code never has to call
    // any init function itself.
    static inline void ensureTrapsInstalled()
    {
        static bool installed = []() {
            Riscv::initTraps();
            return true;
        }();
        (void)installed;
    }
};

#endif //PROJEKAT_SYSCALLS_HPP