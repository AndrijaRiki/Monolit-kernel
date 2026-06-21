//
// Created by os on 6/20/26.
//

#include "../h/MemoryAllocator.hpp"

void* operator new(size_t size)
{
    return MemoryAllocator::getInstance().alloc(
        (size + MEM_BLOCK_SIZE - 1) / MEM_BLOCK_SIZE
    );
}

void operator delete(void* ptr)
{
    MemoryAllocator::getInstance().free(ptr);
}

void operator delete(void* ptr, size_t size)
{
    MemoryAllocator::getInstance().free(ptr);
}