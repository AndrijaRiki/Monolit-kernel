//
// Created by os on 6/18/26.
//

#include "../h/Thread.hpp"
#include "../h/riscv.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../h/Scheduler.hpp"
#include "../h/syscall_c.h"

_thread::_thread()
{
    ready = true;
    finished = false;
    sleeping = false;
    interrupted = false;
    arg = nullptr;
    start_routine = nullptr;
    stack = nullptr;
    next = nullptr;
    waiting = nullptr;
    sleepTime = 0;
    id = 0;
}

static _thread* createMainThread()
{
    static uint8 storage[sizeof(_thread)];
    _thread* t = (_thread*)storage;
    t->ready = true;
    t->finished = false;
    t->sleeping = false;
    t->interrupted = false;
    t->arg = nullptr;
    t->start_routine = nullptr;
    t->stack = nullptr;
    t->next = nullptr;
    t->waiting = nullptr;
    t->sleepTime = 0;
    t->id = 0;
    return t;
}

_thread* _thread::running = createMainThread();
time_t _thread::time = 0;
size_t _thread::nextId = 0;

_thread::_thread(void (*start_routine)(void*), void* arg, void* stack) :
    stack(stack),
    start_routine(start_routine),
    arg(arg),
    context({((uint64)stack + DEFAULT_STACK_SIZE) & ~0xFULL, (uint64)threadWrapper})
{
    ready = true;
    finished = false;
    sleeping = false;
    interrupted = false;
    next = nullptr;
    waiting = nullptr;
    sleepTime = 0;
    id = ++nextId;
    Scheduler::getInstance().addReady(this);
}

_thread::~_thread()
{
    if (stack != nullptr)
    {
        MemoryAllocator::getInstance().free(stack);
    }
}

void _thread::dispatch()
{
    if (running == nullptr)
        running = createMainThread();

    _thread* old = _thread::running;

    
    if (old->ready && !old->finished)
        Scheduler::getInstance().addReady(old);

    _thread* next = Scheduler::getInstance().getReady();

    if (next == nullptr)
    {
        if (old->ready && !old->finished)
        {
            return;
        }

        while (next == nullptr)
        {
            asm volatile("csrs sstatus, 2");
            asm volatile("wfi");
            asm volatile("csrc sstatus, 2");

            next = Scheduler::getInstance().getReady();
        }
    }

    running = next;
    time = 0;
    contextSwitch(&old->context, &running->context);
}

void _thread::join()
{
    if (finished)
    {
        return;
    }

    running->ready = false;
    running->next = waiting;
    waiting = running;
}

void _thread::threadWrapper()
{
    Riscv::ms_sstatus(Riscv::SSTATUS_SIE);

    if (_thread::running->start_routine != nullptr)
    {
        _thread::running->start_routine(_thread::running->arg);
    }

    thread_exit();
}