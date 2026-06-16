//
// Created by os on 6/16/26.
//

#ifndef PROJEKAT_SYSCALL_C_H
#define PROJEKAT_SYSCALL_C_H

#include "../lib/hw.h"

//calls and their codes
enum calls
{
    MEM_ALLOC=0x01,
    MEM_FREE=0x02
};

#ifdef __cplusplus
extern "C" {
#endif

void* mem_alloc(size_t size);
int mem_free(void* ptr);

#ifdef __cplusplus
}
#endif
#endif //PROJEKAT_SYSCALL_C_H
