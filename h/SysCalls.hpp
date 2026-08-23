#ifndef PROJEKAT_SYSCALL_HPP
#define PROJEKAT_SYSCALL_HPP

#include "../lib/hw.h"

class SysCalls
{
public:

    // =========================================================
    // invoke<T> - 0 ARGUMENATA
    // =========================================================
    template <typename RetType>
    static inline RetType invoke(uint64 id)
    {
        uint64 ret;

        asm volatile(
            "mv a0, %1\n"
            "ecall\n"
            "mv %0, a0\n"
            : "=r"(ret)
            : "r"(id)
            : "a0", "memory"
        );

        return (RetType)ret;
    }


    // =========================================================
    // invoke<T> - 1 ARGUMENT
    // =========================================================
    template <typename RetType, typename Arg1>
    static inline RetType invoke(uint64 id, Arg1 arg1)
    {
        uint64 ret;

        asm volatile(
            "mv a0, %1\n"
            "mv a1, %2\n"
            "ecall\n"
            "mv %0, a0\n"
            : "=r"(ret)
            : "r"(id),
              "r"((uint64)arg1)
            : "a0", "a1", "memory"
        );

        return (RetType)ret;
    }


    // =========================================================
    // invoke<T> - 2 ARGUMENTA
    // =========================================================
    template <typename RetType, typename Arg1, typename Arg2>
    static inline RetType invoke(uint64 id, Arg1 arg1, Arg2 arg2)
    {
        uint64 ret;

        asm volatile(
            "mv a0, %1\n"
            "mv a1, %2\n"
            "mv a2, %3\n"
            "ecall\n"
            "mv %0, a0\n"
            : "=r"(ret)
            : "r"(id),
              "r"((uint64)arg1),
              "r"((uint64)arg2)
            : "a0", "a1", "a2", "memory"
        );

        return (RetType)ret;
    }


    // =========================================================
    // invoke<T> - 3 ARGUMENTA
    // =========================================================
    template <
        typename RetType,
        typename Arg1,
        typename Arg2,
        typename Arg3
    >
    static inline RetType invoke(
        uint64 id,
        Arg1 arg1,
        Arg2 arg2,
        Arg3 arg3
    )
    {
        uint64 ret;

        asm volatile(
            "mv a0, %1\n"
            "mv a1, %2\n"
            "mv a2, %3\n"
            "mv a3, %4\n"
            "ecall\n"
            "mv %0, a0\n"
            : "=r"(ret)
            : "r"(id),
              "r"((uint64)arg1),
              "r"((uint64)arg2),
              "r"((uint64)arg3)
            : "a0", "a1", "a2", "a3", "memory"
        );

        return (RetType)ret;
    }


    // =========================================================
    // invoke<T> - 4 ARGUMENTA
    // =========================================================
    template <
        typename RetType,
        typename Arg1,
        typename Arg2,
        typename Arg3,
        typename Arg4
    >
    static inline RetType invoke(
        uint64 id,
        Arg1 arg1,
        Arg2 arg2,
        Arg3 arg3,
        Arg4 arg4
    )
    {
        uint64 ret;

        asm volatile(
            "mv a0, %1\n"
            "mv a1, %2\n"
            "mv a2, %3\n"
            "mv a3, %4\n"
            "mv a4, %5\n"
            "ecall\n"
            "mv %0, a0\n"
            : "=r"(ret)
            : "r"(id),
              "r"((uint64)arg1),
              "r"((uint64)arg2),
              "r"((uint64)arg3),
              "r"((uint64)arg4)
            : "a0", "a1", "a2", "a3", "a4", "memory"
        );

        return (RetType)ret;
    }


    // =========================================================
    // invokeVoid - 0 ARGUMENATA
    // =========================================================
    static inline void invokeVoid(uint64 id)
    {
        asm volatile(
            "mv a0, %0\n"
            "ecall\n"
            :
            : "r"(id)
            : "a0", "memory"
        );
    }


    // =========================================================
    // invokeVoid - 1 ARGUMENT
    // =========================================================
    template <typename Arg1>
    static inline void invokeVoid(uint64 id, Arg1 arg1)
    {
        asm volatile(
            "mv a0, %0\n"
            "mv a1, %1\n"
            "ecall\n"
            :
            : "r"(id),
              "r"((uint64)arg1)
            : "a0", "a1", "memory"
        );
    }


    // =========================================================
    // invokeVoid - 2 ARGUMENTA
    // =========================================================
    template <typename Arg1, typename Arg2>
    static inline void invokeVoid(
        uint64 id,
        Arg1 arg1,
        Arg2 arg2
    )
    {
        asm volatile(
            "mv a0, %0\n"
            "mv a1, %1\n"
            "mv a2, %2\n"
            "ecall\n"
            :
            : "r"(id),
              "r"((uint64)arg1),
              "r"((uint64)arg2)
            : "a0", "a1", "a2", "memory"
        );
    }


    // =========================================================
    // invokeVoid - 3 ARGUMENTA
    // =========================================================
    template <
        typename Arg1,
        typename Arg2,
        typename Arg3
    >
    static inline void invokeVoid(
        uint64 id,
        Arg1 arg1,
        Arg2 arg2,
        Arg3 arg3
    )
    {
        asm volatile(
            "mv a0, %0\n"
            "mv a1, %1\n"
            "mv a2, %2\n"
            "mv a3, %3\n"
            "ecall\n"
            :
            : "r"(id),
              "r"((uint64)arg1),
              "r"((uint64)arg2),
              "r"((uint64)arg3)
            : "a0", "a1", "a2", "a3", "memory"
        );
    }


    // =========================================================
    // invokeVoid - 4 ARGUMENTA
    // =========================================================
    template <
        typename Arg1,
        typename Arg2,
        typename Arg3,
        typename Arg4
    >
    static inline void invokeVoid(
        uint64 id,
        Arg1 arg1,
        Arg2 arg2,
        Arg3 arg3,
        Arg4 arg4
    )
    {
        asm volatile(
            "mv a0, %0\n"
            "mv a1, %1\n"
            "mv a2, %2\n"
            "mv a3, %3\n"
            "mv a4, %4\n"
            "ecall\n"
            :
            : "r"(id),
              "r"((uint64)arg1),
              "r"((uint64)arg2),
              "r"((uint64)arg3),
              "r"((uint64)arg4)
            : "a0", "a1", "a2", "a3", "a4", "memory"
        );
    }
};

#endif // PROJEKAT_SYSCALL_HPP

/*
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

#endif //PROJEKAT_SYSCALLS_HPP*/
