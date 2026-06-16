//
// Created by os on 6/16/26.
//
#include "../h/syscall_c.h"
#include "../lib/hw.h"
#include "../h/SysCalls.hpp"

#ifdef __cplusplus
extern "C" {
#endif

void *mem_alloc(size_t size)
{
    size_t blocks  = (size + MEM_BLOCK_SIZE - 1) / MEM_BLOCK_SIZE;
    return SysCalls::invoke<void*>(MEM_ALLOC, blocks);
}

int mem_free(void* ptr)
{
    return SysCalls::invoke<int>(MEM_FREE, ptr);
}

#ifdef __cplusplus
}
#endif