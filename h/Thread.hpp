//
// Created by os on 6/18/26.
//

#ifndef PROJEKAT_THREAD_HPP
#define PROJEKAT_THREAD_HPP

#include "../h/syscall_c.h"
#include "../lib/hw.h"

class _thread
{
public:
    static _thread* running;
    static size_t time;

    _thread();

    _thread(thread_body_t start_routine, void* arg, void* stack);

    ~_thread();

    _thread(const _thread&) = delete;
    _thread& operator=(const _thread&) = delete;

    void join();

    static void dispatch();

    struct Context {
        uint64 sp;
        uint64 ra;
        uint64 s0,  s1,  s2,  s3,  s4,  s5,
               s6,  s7,  s8,  s9,  s10, s11;
    };

    thread_t next    = nullptr;
    thread_t waiting = nullptr;
    void*    stack   = nullptr;
    time_t   sleepTime = 0;
    size_t   id      = 0;

    bool ready = true;
    bool finished = false;
    bool sleeping = false;
    bool interrupted = false;

    thread_body_t start_routine;
    void* arg;

private:
    Context context;

    static void contextSwitch(Context* oldContext, Context* newContext);
    static void threadWrapper();
    static size_t nextId;
};

#endif //PROJEKAT_THREAD_HPP