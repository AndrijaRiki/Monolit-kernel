//
// Created by os on 6/16/26.
//

#include "../h/MemoryAllocator.hpp"

MemoryAllocator& MemoryAllocator::getInstance()
{
    static MemoryAllocator allocator;
    return allocator;
}

MemoryAllocator::MemoryAllocator()
{
    heapStart = align_down((size_t)HEAP_START_ADDR, MEM_BLOCK_SIZE);
    heapEnd = align_up((size_t)HEAP_END_ADDR, MEM_BLOCK_SIZE);

    MemDescr* mem = (MemDescr*)heapStart;
    mem->size = heapEnd - heapStart;
    mem->next = nullptr;

    head = mem;
}

void* MemoryAllocator::alloc(size_t size)
{
    if (size > ((uint64)SIZE_MAX / MEM_BLOCK_SIZE - 1))
        return nullptr;
    // one more block for the descriptor
    size = (size + 1) * MEM_BLOCK_SIZE;

    MemDescr* prev = nullptr;
    MemDescr* curr = head;

    while(curr != nullptr)
    {
        if(curr->size >= size)
        {
            if(curr->size - size >= MEM_BLOCK_SIZE)
            {
                MemDescr* newDesc = (MemDescr*)((size_t)curr + size);
                newDesc->next = curr->next;
                newDesc->size = curr->size - size;
                curr->size = size;

                if(prev == nullptr)
                    head = newDesc;
                else
                    prev->next = newDesc;
            }
            else
            {
                if(prev == nullptr)
                    head = curr->next;
                else
                    prev->next = curr->next;
            }

            curr->next = nullptr;

            return (void*)((size_t)curr + MEM_BLOCK_SIZE);
        }

        prev = curr;
        curr = curr->next;
    }

    return nullptr;
}

int MemoryAllocator::free(void* ptr)
{
    if (ptr == nullptr)
        return -1;

    ptr = (void*)((size_t)ptr - MEM_BLOCK_SIZE); //-1 block = descriptor

    if ((size_t)ptr < heapStart || (size_t)ptr >= heapEnd)
        return -1;

    MemDescr* prev = nullptr;
    MemDescr* curr = head;

    while (curr != nullptr && curr < ptr)
    {
        prev = curr;
        curr = curr->next;
    }

    if (curr == ptr)
        return -1;

    MemDescr* desc = (MemDescr*)ptr;
    desc->next = curr;

    if (prev == nullptr)
        head = desc;
    else
        prev->next = desc;

    mergeBlocks(desc, curr);
    mergeBlocks(prev, desc);

    return 0;
}