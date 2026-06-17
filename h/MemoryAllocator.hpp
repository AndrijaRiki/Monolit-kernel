//
// Created by os on 6/16/26.
//

#ifndef PROJEKAT_MEMORYALLOCATOR_HPP
#define PROJEKAT_MEMORYALLOCATOR_HPP

#include "../lib/hw.h"

class MemoryAllocator
{
public:
        static MemoryAllocator& getInstance();
        void* alloc(size_t size);
        int free(void* ptr);

private:
        MemoryAllocator();
        MemoryAllocator(const MemoryAllocator&) = delete;
        MemoryAllocator& operator=(const MemoryAllocator&) = delete;

        class MemDescr
        {
        public:
                MemDescr* next;
                size_t size;
        };

        MemDescr* head;

        void mergeBlocks(MemDescr* prev, MemDescr* curr)
        {
                if (prev != nullptr && curr != nullptr && (size_t)prev + prev->size == (size_t)curr)
                {
                        prev->size += curr->size;
                        prev->next = curr->next;
                }
        }

        static constexpr size_t align_down(size_t size, size_t align)
        {
                // FIX: was "size * align / align" which is a no-op (always
                // returns size unchanged). Correct rounding-down is
                // size / align * align.
                return size / align * align;
        }

        static constexpr size_t align_up(size_t size, size_t align)
        {
                return (size + align - 1)/align * align;
        }
};

#endif //PROJEKAT_MEMORYALLOCATOR_HPP