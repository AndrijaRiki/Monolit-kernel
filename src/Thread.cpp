//
// Created by os on 6/18/26.
//

#include "../h/Thread.hpp"
#include "../h/riscv.hpp"
#include "../h/MemoryAllocator.hpp"
#include  "../h/Scheduler.hpp"
#include "../h/printing.hpp"

namespace
{
    _thread* zombie = nullptr;
}

_thread::_thread()
{
    ready = true;
    finished = false;
    sleeping = false;
    interrupted = false;
    arg = nullptr;
    start_routine = nullptr;
}

static _thread* createMainThread()
{
    static uint8 storage[sizeof(_thread)];
    _thread* t = (_thread*)storage;
    // manually replicate what the default constructor does
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
    //t->context = {0, 0};
    return t;
}

_thread* _thread::running = createMainThread();
time_t _thread::time = 0;
size_t _thread::nextId = 0;

_thread::_thread(void (*start_routine)(void*), void* arg, void* stack):
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
    id = ++nextId; // FIX: Use the unique ID counter
    Scheduler::getInstance().addReady(this);
}

_thread::~_thread()
{
    if (stack != nullptr)
    {
        MemoryAllocator::getInstance().free(stack);
    }
}

/*
void _thread::dispatch()
{
    // 1. Clean up the previous zombie thread if one exists.
    // SAFEGUARD: Only delete if it's a dynamically allocated thread (stack != nullptr).
    // The main thread is statically allocated in global memory and must NEVER be deleted.
    if (zombie != nullptr)
    {
        if (zombie->stack != nullptr)
        {
            delete zombie;
        }
        zombie = nullptr;
    }

    // 2. Fallback to guarantee a valid running thread context
    if (running == nullptr)
    {
        running = createMainThread();
    }

    _thread* old = _thread::running;

    // 3. Save the current thread back to the Scheduler if it's still active
    if (old->ready && !old->finished)
    {
        Scheduler::getInstance().addReady(old);
    }
    else if (old->finished)
    {
        zombie = old;
    }

    // 4. Fetch the next thread to execute
    _thread* next = Scheduler::getInstance().getReady();

    if (next == nullptr)
    {
        // OPTIMIZATION: If the scheduler is empty but the current thread is
        // still runnable, just keep running it without an expensive context switch.
        if (old->ready && !old->finished)
        {
            _thread::time = 0; // Reset time-slice counter
            return;
        }

        // IDLE LOOP: If the scheduler is empty AND the current thread cannot run
        // (e.g., it blocked on a semaphore, went to sleep, or exited), we must idle
        // here until an asynchronous interrupt (timer/console) wakes a thread up.
        while (next == nullptr)
        {
            // Unmask supervisor interrupts so the timer/hardware handlers can run
            Riscv::ms_sstatus(Riscv::SSTATUS_SIE);

            next = Scheduler::getInstance().getReady();

            // Mask interrupts again immediately after checking to protect
            // kernel state manipulation atomicity
            Riscv::mc_sstatus(Riscv::SSTATUS_SIE);
        }
    }

    // 5. Perform the context switch
    running = next;
    _thread::time = 0; // Reset the time-slice counter for the incoming thread
    contextSwitch(&old->context, &running->context);
}
*/

void _thread::dispatch()
{
    if (zombie != nullptr)
    {
        if (zombie->stack != nullptr)
            delete zombie;
        zombie = nullptr;
    }

    if (running == nullptr)
        running = createMainThread();

    _thread* old = _thread::running;
    if (old->ready && !old->finished)
        Scheduler::getInstance().addReady(old);
    else if (old->finished)
        zombie = old;

    _thread* next = Scheduler::getInstance().getReady();

    // FIX: Handle the case where the ready queue is empty
    if (next == nullptr)
    {
        // If the current thread is still ready, it's the only thread in the system,
        // so we can safely keep running it.
        if (old->ready && !old->finished)
        {
            return;
        }

        // If the current thread is blocked/finished and no other thread is ready,
        // we must idle and wait for a hardware timer interrupt to wake someone up.
        while (next == nullptr)
        {
            asm volatile("csrs sstatus, 2"); // Enable Supervisor Interrupts (SIE)
            asm volatile("wfi");             // Wait For Interrupt (low power mode)
            asm volatile("csrc sstatus, 2"); // Disable Supervisor Interrupts (SIE)

            next = Scheduler::getInstance().getReady();
        }
    }

    running = next;
    //time = DEFAULT_TIME_SLICE;
    time = 0;
    contextSwitch(&old->context, &running->context);
}

/*void _thread::dispatch()
{
    if (running == nullptr)
        running = createMainThread();

    _thread* old = _thread::running;
    if (old->ready && !old->finished)
        Scheduler::getInstance().addReady(old);

    _thread* next = Scheduler::getInstance().getReady();
    if (next == nullptr)
        return;

    running = next;
    contextSwitch(&old->context, &running->context);
}*/

/*void _thread::dispatch()
{
    _thread* old = _thread::running;
    if (old->ready && !old->finished)
        Scheduler::getInstance().addReady(old);

    _thread* next = Scheduler::getInstance().getReady();
    if (next == nullptr)
        return;

    running = next;
    contextSwitch(&old->context, &running->context);
}*/

void _thread::join()
{
    running->ready = false;
    running->next = waiting;
    waiting = running;
}

void _thread::threadWrapper()
{
    Riscv::ms_sstatus(Riscv::SSTATUS_SIE);

    _thread::running->start_routine(_thread::running->arg);
    thread_exit();
}