//
// Created by os on 6/30/26.
//

#ifndef PROJEKAT_SEMAPHORE_HPP
#define PROJEKAT_SEMAPHORE_HPP

class _thread;

class _sem
{
public:
    _sem(unsigned init = 1);
    ~_sem();

    int wait(unsigned n=1);
    int signal(unsigned n=1);
    int val;
    _thread* waiting = nullptr;
};

#endif //PROJEKAT_SEMAPHORE_HPP
