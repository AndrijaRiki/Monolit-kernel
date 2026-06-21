//
// Created by os on 6/16/26.
//
#include "../h/syscall_c.h"
#include "../lib/hw.h"
#include "../h/SysCalls.hpp"

/*#ifdef __cplusplus
extern "C" {
#endif*/

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

/*#ifdef __cplusplus
}
#endif*/
