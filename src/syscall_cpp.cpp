#include "../h/syscall_cpp.hpp"
#include "../h/TCB.hpp"
#include "../h/KernelSemaphore.hpp"

void* operator new(size_t n) {
    return mem_alloc(n);
}

void* operator new[](size_t n) {
    return mem_alloc(n);
}

void operator delete(void* ptr) {
    mem_free(ptr);
}

void operator delete[](void* ptr) {
    mem_free(ptr);
}


Thread::Thread(void (*body)(void*), void *arg) {
    thread_create_cpp(&myHandle, body, arg);
}

Thread::~Thread() {
    delete (TCB*)(myHandle);
}

int Thread::start() {
    return scheduler_put(myHandle);
}

void Thread::dispatch() {
    thread_dispatch();
}

int Thread::sleep(time_t time) {
    return time_sleep(time);
}

int Thread::getThreadId() {
    return ::getThreadId();
}

Thread::Thread() {
    thread_create_cpp(&myHandle, &callRunForThisThread, this);
}

void Thread::callRunForThisThread(void* thisPointer) {
    static_cast<Thread*>(thisPointer)->run();
}


Semaphore::Semaphore(unsigned int init) {
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore() {
    delete (KernelSemaphore*)myHandle;
}

int Semaphore::wait() {
    return sem_wait(myHandle);
}

int Semaphore::signal() {
    return sem_signal(myHandle);
}

void PeriodicThread::run() {
    while (true && !shouldThisThreadEnd) {
        periodicActivation();
        time_sleep(sleepTime);
    }
}

void PeriodicThread::endPeriodicThread() {
    shouldThisThreadEnd = true;
}

PeriodicThread::PeriodicThread(time_t period) {
    sleepTime = period;
    shouldThisThreadEnd = false;
}


char Console::getc() {
    return ::getc();
}

void Console::putc(char c) {
    ::putc(c);
}