//
// Created by os on 6/18/26.
//

#ifndef PROJEKAT_SCHEDULER_HPP
#define PROJEKAT_SCHEDULER_HPP

#include "../h/syscall_c.h"

class Scheduler
{
public:
    static Scheduler& getInstance();

    void addReady(thread_t thread);
    void addSleeping(thread_t thread, time_t time);

    thread_t getReady();

    void updateSleeping();
private:
    Scheduler() {};
    thread_t ready = nullptr; //head of list of ready threads
    thread_t sleeping = nullptr; //head of list of threads waiting to be called/woken up
};

#endif //PROJEKAT_SCHEDULER_HPP
