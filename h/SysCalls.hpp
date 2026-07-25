#ifndef PROJEKAT_SYSCALLS_HPP
#define PROJEKAT_SYSCALLS_HPP

#include "../lib/hw.h"

template <typename T>
struct SysCallImpl {
    template <typename... Args>
    static inline T invoke(uint64 id, Args... args)
    {
        uint64 regs[5] = { id, (uint64)args... };

        register uint64 r_a0 asm("a0") = regs[0];
        register uint64 r_a1 asm("a1") = regs[1];
        register uint64 r_a2 asm("a2") = regs[2];
        register uint64 r_a3 asm("a3") = regs[3];
        register uint64 r_a4 asm("a4") = regs[4];

        asm volatile(
            "ecall"
            : "+r" (r_a0) // r_a0 je i ulazni (ID) i izlazni registar!
            : "r" (r_a1), "r" (r_a2), "r" (r_a3), "r" (r_a4)
            : "memory"
        );

        return (T)r_a0;
    }
};

template <>
struct SysCallImpl<void> {
    template <typename... Args>
    static inline void invoke(uint64 id, Args... args)
    {
        uint64 regs[5] = { id, (uint64)args... };

        register uint64 r_a0 asm("a0") = regs[0];
        register uint64 r_a1 asm("a1") = regs[1];
        register uint64 r_a2 asm("a2") = regs[2];
        register uint64 r_a3 asm("a3") = regs[3];
        register uint64 r_a4 asm("a4") = regs[4];

        asm volatile(
            "ecall"
            : "+r" (r_a0)
            : "r" (r_a1), "r" (r_a2), "r" (r_a3), "r" (r_a4)
            : "memory"
        );
    }
};

class SysCalls
{
public:
    template <typename T = void, typename... Args>
    static inline T invoke(uint64 id, Args... args)
    {
        return SysCallImpl<T>::invoke(id, args...);
    }
};

#endif //PROJEKAT_SYSCALLS_HPP