//
// Created by os on 7/20/26.
//

#ifndef PROJEKAT_SYSCALL_CPP_HPP
#define PROJEKAT_SYSCALL_CPP_HPP

#include "../h/syscall_c.h"

void* operator new(size_t);
void operator delete(void*);

class Thread {
public:
    Thread (void (*body)(void*), void* arg);
    virtual ~Thread ();
    int start ();
    void join();
    static void dispatch ();
    static int sleep (time_t);
    static int getID();
protected:
    Thread ();
    virtual void run () {}
private:
    thread_t myHandle;
    void (*body)(void*); void* arg;
    static void runWrapper(void*);
};
class Semaphore {
public:
    Semaphore (unsigned init = 1);
    virtual ~Semaphore ();
    int wait ();
    int signal ();
private:
    sem_t myHandle;
};
class PeriodicThread : public Thread {
public:
    void terminate ();
    virtual ~PeriodicThread() override;
protected:
    PeriodicThread (time_t period);
    virtual void periodicActivation () {}
    virtual void run() override;
private:
    time_t period;
};
class Console {
public:
    static char getc ();
    static void putc (char);
};

#endif //PROJEKAT_SYSCALL_CPP_HPP
