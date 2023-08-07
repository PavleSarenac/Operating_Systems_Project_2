#ifndef SYSCALL_CPP_H
#define SYSCALL_CPP_H

#include "syscall_c.h"

void* operator new(size_t n);
void* operator new[](size_t n);
void operator delete(void* ptr);
void operator delete[](void* ptr);

class Thread {
public:
    Thread(void (*body)(void*), void* arg);
    virtual ~Thread();

    int start();

    static void dispatch();
    static int sleep(time_t time);

    int getThreadId();

protected:
    Thread();
    virtual void run() {}

private:
    static void callRunForThisThread(void* thisPointer);

    thread_t myHandle;
};

class Semaphore {
public:
    explicit Semaphore(unsigned init = 1);
    virtual ~Semaphore();

    int wait();
    int signal();

private:
    sem_t myHandle;
};

class PeriodicThread : public Thread {
public:
    void endPeriodicThread();
protected:
    explicit PeriodicThread(time_t period);
    void run() override;
    virtual void periodicActivation() {}

    time_t sleepTime;
    bool shouldThisThreadEnd;
};

class Console {
public:
    static char getc();
    static void putc(char c);
};

#endif