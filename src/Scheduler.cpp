//
// Created by os on 6/18/26.
//

#include  "../lib/hw.h"
#include  "../h/Scheduler.hpp"
#include "../h/Thread.hpp"

Scheduler& Scheduler::getInstance()
{
    static Scheduler instance;
    return instance;
}

void Scheduler::addReady(thread_t thread)
{
    thread_t prev = nullptr;
    thread_t curr = ready;

    while (curr != nullptr)
    {
        prev = curr;
        curr = curr->next;
    }

    if (prev == nullptr)
    {
        ready = thread;
    }
    else
    {
        prev->next = thread;
    }
    thread->next = nullptr;
}

void Scheduler::addSleeping(thread_t thread, time_t time)
{
    thread_t prev = nullptr;
    thread_t curr = sleeping;
    while(curr != nullptr && curr->sleepTime <= time)
    {
        prev = curr;
        curr = curr->next;
    }

    if(prev == nullptr)
    {
        sleeping = thread;
    }
    else
    {
        prev->next = thread;
    }
    thread->next = curr;
    thread->sleepTime = time;
}

thread_t Scheduler::getReady()
{
    thread_t thread = ready;
    if (thread != nullptr)
    {
        ready = thread->next;
        thread->next = nullptr;
    }
    return thread;
}

void Scheduler::updateSleeping()
{
    thread_t prev = nullptr;
    thread_t curr = sleeping;

    while (curr != nullptr)
    {
        thread_t next = curr->next;
        if (curr->sleepTime == 0)
        {
            if (prev == nullptr)
            {
                sleeping = next;
            }
            else
            {
                prev->next = next;
            }
            curr->ready = true;
            addReady(curr);
        }
        else
        {
            curr->sleepTime--;
            prev = curr;
        }
        curr = next;
    }
}
