//
// Created by os on 6/30/26.
//

#include "../h/Scheduler.hpp"
#include "../h/Semaphore.hpp"
#include "../h/Thread.hpp"

_sem::_sem(unsigned init) : val((int)init), waiting(nullptr) {}

_sem::~_sem()
{
    thread_t curr = waiting;
    while (curr != nullptr)
    {
        thread_t next = curr->next;
        curr->ready = true;
        curr->interrupted = true;
        Scheduler::getInstance().addReady(curr);
        curr = next;
    }
}

int _sem::wait(unsigned n)
{
    // Ako je red prazan i ima dovoljno resursa, uzmi ih odmah bez blokiranja
    if (waiting == nullptr && val >= (int)n)
    {
        val -= (int)n;
        return 0;
    }

    // U suprotnom, nit mora da se blokira
    _thread::running->sem_needed = n;
    _thread::running->ready = false;
    _thread::running->next = nullptr;

    // FIFO DODAVANJE: Na kraj waiting liste
    if (waiting == nullptr)
    {
        waiting = _thread::running;
    }
    else
    {
        thread_t curr = waiting;
        while (curr->next != nullptr)
        {
            curr = curr->next;
        }
        curr->next = _thread::running;
    }

    _thread::dispatch();

    // Kada se nit probudi, provera da li je semafor obrisan u međuvremenu
    if (_thread::running->interrupted)
    {
        _thread::running->interrupted = false;
        return -2;
    }

    return 0;
}

int _sem::signal(unsigned n)
{
    val += (int)n;

    // Prolazi kroz FIFO red i budi samo one niti čiji zahtev možeš da ispuniš
    while (waiting != nullptr)
    {
        if (val >= (int)waiting->sem_needed)
        {
            thread_t t = waiting;
            waiting = waiting->next;

            val -= (int)t->sem_needed; // Oduzmi resurse koji su dodeljeni probuđenoj niti
            t->next = nullptr;
            t->ready = true;
            Scheduler::getInstance().addReady(t);
        }
        else
        {
            break;
        }
    }
    return 0;
}