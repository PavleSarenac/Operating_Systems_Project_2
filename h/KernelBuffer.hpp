#ifndef BUFFER_HPP
#define BUFFER_HPP

#include "../h/KernelSemaphore.hpp"
#include "../h/syscall_cpp.hpp"

class KernelBuffer {
public:
    static KernelBuffer* putcGetInstance();
    static KernelBuffer* getcGetInstance();
    ~KernelBuffer();

    void insertIntoBuffer(int value);
    int removeFromBuffer();

    int getNumberOfElements();

    static void* operator new(size_t n);
    static void* operator new[](size_t n);
    static void operator delete(void* ptr);
    static void operator delete[](void* ptr);

private:
    KernelBuffer();
    static KernelBuffer* putcKernelBufferHandle;
    static KernelBuffer* getcKernelBufferHandle;

    int capacity;
    int* buffer;
    int head, tail;

    KernelSemaphore* spaceAvailable;
    KernelSemaphore* itemAvailable;
    KernelSemaphore* mutexHead;
    KernelSemaphore* mutexTail;
};

#endif