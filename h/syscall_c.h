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
    MEM_FREE=0x02,
    THREAD_CREATE = 0x11,
    THREAD_EXIT = 0x12,
    THREAD_DISPATCH = 0x13,
    THREAD_JOIN = 0x15,
    THREAD_GETID = 0x16,
};

/*#ifdef __cplusplus
extern "C" {
#endif*/

void* mem_alloc(size_t size);
int mem_free(void* ptr);

class _thread;
typedef _thread* thread_t;

typedef void (*thread_body_t)(void*);

int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg);
int thread_exit(); //shuts down current thread
void thread_dispatch();
void thread_join(thread_t handle);
int thread_getID();

/*#ifdef __cplusplus
}
#endif*/
#endif //PROJEKAT_SYSCALL_C_H
