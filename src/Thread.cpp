//
// Created by os on 6/18/26.
//

#include "../h/Thread.hpp"
#include "../h/riscv.hpp"
#include "../h/MemoryAllocator.hpp"
#include  "../h/Scheduler.hpp"
#include "../h/printing.hpp"

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
size_t _thread::time = 0;
size_t _thread::nextId = 0;

_thread::_thread(void (*start_routine)(void*), void* arg, void* stack):
    stack(stack),
    start_routine(start_routine),
    arg(arg),
    context({((uint64)stack + DEFAULT_STACK_SIZE) & ~0xFULL, (uint64)threadWrapper})
{
    Scheduler::getInstance().addReady(this); //newly created thread has to be put in ready list
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

    // DEBUG
    /*printString("D old=");
    printInteger((uint64)old, 16);
    printString(" next=");
    printInteger((uint64)next, 16);
    if (next) {
        printString(" sp=");
        printInteger(next->context.sp, 16);
        printString(" fin=");
        printInteger(next->finished, 10);
        printString(" rdy=");
        printInteger(next->ready, 10);
    }
    printString("\n");*/

    if (next == nullptr)
        return;

    running = next;
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
    _thread::running->start_routine(_thread::running->arg);
    thread_exit();
}