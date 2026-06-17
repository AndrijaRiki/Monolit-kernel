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
    if (ptr == nullptr)
        return -1;

    ptr = (void*)((size_t)ptr - MEM_BLOCK_SIZE); //-1 block = descriptor

    // FIX: compare against the ALIGNED bounds (same ones used to build the
    // initial free list in the constructor), not the raw HEAP_START_ADDR.
    // The first block's descriptor can legitimately sit in the gap between
    // the raw, unaligned HEAP_START_ADDR and the aligned heapStart -- using
    // the raw value here incorrectly rejected valid frees from that block.
    if ((size_t)ptr < heapStart || (size_t)ptr >= heapEnd)
        return -1;

    // Find the correct insertion point: prev is the last free block
    // before ptr, curr is the first free block after (or equal to) ptr.
    MemDescr* prev = nullptr;
    MemDescr* curr = head;

    while (curr != nullptr && curr < ptr)
    {
        prev = curr;
        curr = curr->next;
    }

    // If curr == ptr, this block is already on the free list -> double free.
    if (curr == ptr)
        return -1;

    MemDescr* desc = (MemDescr*)ptr;
    desc->next = curr;

    // FIX: original code did "head = prev->next" here, which overwrote the
    // list head every time prev wasn't null, corrupting the free list.
    // We need to link desc INTO the list at the right spot instead.
    if (prev == nullptr)
        head = desc;
    else
        prev->next = desc;

    // Merge desc forward into curr first (desc's address is still correct,
    // only curr might get absorbed into it), then merge prev forward into
    // desc/curr's combined block. Order matters: merge the later pair first
    // so the earlier merge sees the final, fully-coalesced size.
    mergeBlocks(desc, curr);
    mergeBlocks(prev, desc);

    return 0;
}