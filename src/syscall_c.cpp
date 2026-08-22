//
// Created by os on 6/16/26.
//
#include "../h/syscall_c.h"
#include "../lib/hw.h"
#include "../h/SysCalls.hpp"


void *mem_alloc(size_t size)
{
    size_t blocks  = (size + MEM_BLOCK_SIZE - 1) / MEM_BLOCK_SIZE;
    return SysCalls::invoke<void*>(MEM_ALLOC, blocks);
}

int mem_free(void* ptr)
{
    return SysCalls::invoke<int>(MEM_FREE, ptr);
}

int thread_exit()
{
    return SysCalls::invoke<int>(THREAD_EXIT);
}

int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg)
{
    void* stack = mem_alloc(DEFAULT_STACK_SIZE);
    if (!stack)
        return -1; //allocation error
    return SysCalls::invoke<int>(THREAD_CREATE, handle, start_routine, arg, stack);
}

void thread_dispatch()
{
    SysCalls::invoke(THREAD_DISPATCH);
}

void thread_join(thread_t handle)
{
    SysCalls::invoke(THREAD_JOIN, handle);
}

int thread_getID()
{
    return SysCalls::invoke<int>(THREAD_GETID);
}

int sem_open(sem_t* handle, unsigned init)
{
    return SysCalls::invoke<int>(SEM_OPEN, handle, init);
}

int sem_close(sem_t handle)
{
    return SysCalls::invoke<int>(SEM_CLOSE, handle);
}

int sem_wait(sem_t id)
{
    return SysCalls::invoke<int>(SEM_WAIT, id);
}

int sem_signal(sem_t id)
{
    return SysCalls::invoke<int>(SEM_SIGNAL, id);
}

int sem_wait_n(sem_t id, unsigned n)
{
    return SysCalls::invoke<int>(SEM_WAIT_N, id, n);
}

int sem_signal_n(sem_t id, unsigned n)
{
    return SysCalls::invoke<int>(SEM_SIGNAL_N, id, n);
}

int time_sleep(time_t time)
{
    return SysCalls::invoke<int>(TIME_SLEEP, time);
}

char getc()
{
    return SysCalls::invoke<char>(GETC);
}

void putc(char c)
{
    SysCalls::invoke<void>(PUTC, c);
}
