//
// Created by os on 6/16/26.
//

#ifndef PROJEKAT_SYSCALLS_HPP
#define PROJEKAT_SYSCALLS_HPP

#include "../lib/hw.h"

class SysCalls
{
public:
    template <typename T>
    static inline T invoke(uint64 id)
    {
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
};

#endif //PROJEKAT_SYSCALLS_HPP
