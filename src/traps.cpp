//
// Created by os on 6/16/26.
//

#include "../h/MemoryAllocator.hpp"
#include "../h/moj_printing.hpp"
#include "../lib/hw.h"
#include "../h/riscv.hpp"
#include "../h/Scheduler.hpp"
#include "../h/syscall_c.h"
#include "../h/Thread.hpp"
#include "../h/Semaphore.hpp"
#include "../lib/console.h"

constexpr uint64 ECALL_FROM_U_MODE = 0x08;
constexpr uint64 ECALL_FROM_S_MODE = 0x09;
constexpr uint64 ECALL_INSTR_SIZE = 4;

bool isEcal(uint64 scause)
{
    return scause == ECALL_FROM_U_MODE || scause == ECALL_FROM_S_MODE;
}

void setReturnValue(uint64* regs, uint64 value)
{
    regs[A0] = value;
}

extern "C" void internalTrapHandler(uint64* regs)
{
    volatile uint64 sepc    = Riscv::r_sepc();
    volatile uint64 sstatus = Riscv::r_sstatus();
    uint64 scause = Riscv::r_scause();

    if (!isEcal(scause))
    {
        printString("Unhandled exception: SEPC = ");
        printInteger(sepc, 16);
        printString(", SCAUSE = ");
        printInteger(scause, 16);
        printString(", STVAL = ");
        printInteger(Riscv::r_stval(), 16);
        printString("\n");
        Riscv::w_sstatus(sstatus);
        return;
    }

    sepc += ECALL_INSTR_SIZE;

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
                regs[A0] = -1;
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
    case THREAD_JOIN:
        {
            thread_t handle = (thread_t)regs[A1];
            if (handle != nullptr && !handle->finished)
            {
                handle->join();
                _thread::dispatch();
            }
            regs[A0] = 0;
            break;
        }
    case THREAD_GETID:
        {
            regs[A0] = _thread::running->id;
            break;
        }
    case SEM_OPEN:
        {
            sem_t* handle = (sem_t*)regs[A1];
            unsigned init = (unsigned)regs[A2];

            if (handle == nullptr)
            {
                regs[A0] = -1;
            }
            else
            {
                _sem* s = new _sem(init);
                *handle = s;
                regs[A0] = 0;
            }
            break;
        }
    case SEM_CLOSE:
        {
            sem_t handle = (sem_t)regs[A1];
            if (handle == nullptr)
            {
                regs[A0] = -1;
                break;
            }
            delete handle;
            regs[A0] = 0;
            break;
        }
    case SEM_WAIT:
        {
            sem_t id = (sem_t)regs[A1];
            if (id == nullptr)
            {
                regs[A0] = -1;
                break;
            }
            regs[A0] = id->wait();
            break;
        }
    case SEM_SIGNAL:
        {
            sem_t id = (sem_t)regs[A1];
            if (id == nullptr)
            {
                regs[A0] = -1;
                break;
            }
            regs[A0] = id->signal();
            break;
        }
    case SEM_WAIT_N:
        {
            sem_t id = (sem_t)regs[A1];
            unsigned n = (unsigned)regs[A2];
            if (id == nullptr)
            {
                regs[A0] = -1;
                break;
            }
            regs[A0] = id->wait(n);
            break;
        }
    case SEM_SIGNAL_N:
        {
            sem_t id = (sem_t)regs[A1];
            unsigned n = (unsigned)regs[A2];
            if (id == nullptr)
            {
                regs[A0] = -1;
                break;
            }
            regs[A0] = id->signal(n);
            break;
        }
    case TIME_SLEEP:
        {
            time_t time = (time_t)regs[A1];
            _thread::running->ready = false;
            Scheduler::getInstance().addSleeping(_thread::running, time);
            _thread::dispatch();
            regs[A0] = 0;
            break;
        }
    case GETC:
        {
            char c = __getc();
            Riscv::w_user_reg(A0, c);
            break;
        }
    case PUTC:
        {
            char c = Riscv::r_user_reg<char>(A1);
            __putc(c);
            break;
        }
    default:
        regs[A0] = 0;
    }
    Riscv::w_sepc(sepc);
    Riscv::w_sstatus(sstatus);
}

static volatile uint64 ticks = 0;

extern "C" void timerHandler()
{
    ticks++;
    volatile uint64 sepc = Riscv::r_sepc();
    volatile uint64 sstatus = Riscv::r_sstatus();

    Riscv::mc_sip(Riscv::SIP_SSIP);
    Scheduler::getInstance().updateSleeping();

    _thread::time++;
    if (_thread::time >= DEFAULT_TIME_SLICE)
    {
        _thread::time = 0;
        if (_thread::running != nullptr && _thread::running->ready && !_thread::running->finished)
        {
            _thread::dispatch();
        }
    }
    Riscv::w_sepc(sepc);
    Riscv::w_sstatus(sstatus);
}

extern "C" void externalHandler()
{
    console_handler();
}