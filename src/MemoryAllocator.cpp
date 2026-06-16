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
    size_t memStart = align_down((size_t)HEAP_START_ADDR, MEM_BLOCK_SIZE);
    size_t memEnd = align_up((size_t)HEAP_END_ADDR, MEM_BLOCK_SIZE);

    MemDescr* mem = (MemDescr*)memStart;
    mem->size = memEnd - memStart;
    mem->next = nullptr;

    head = mem;
}

void* MemoryAllocator::alloc(size_t size)
{
    // convert to bytes, and add one more block for the descriptor
    size = (size + 1)*MEM_BLOCK_SIZE;


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

            // return the start of the block that's available to the user
            return (void*)((size_t)curr + MEM_BLOCK_SIZE);
        }

        prev = curr;
        curr = curr->next;
    }

    return nullptr;
}

int MemoryAllocator::free(void* ptr)
{
    ptr = (void*)((size_t)ptr - MEM_BLOCK_SIZE); //-1 block = descriptor

    if (ptr < HEAP_START_ADDR || ptr >= HEAP_END_ADDR)
        return -1;

    MemDescr* prev = nullptr;
    MemDescr* curr = head;

    while (curr != nullptr)
    {
        if (curr == ptr)
            return -1;
        if (curr > ptr)
            break;

        prev =curr;
        curr = curr->next;
    }

    MemDescr* desc = (MemDescr*)ptr;
    if (prev == nullptr)
        head = desc;
    else
        head = prev->next;

    desc->next = curr;

    mergeBlocks(desc, curr);
    mergeBlocks(prev, desc);

    return 0;
}