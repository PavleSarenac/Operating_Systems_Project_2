#ifndef KERNELBUFFER_HPP
#define KERNELBUFFER_HPP

#include "../Semaphore/KernelSemaphore.hpp"
#include "../SystemCalls/syscall_cpp.hpp"
#include "../../../h/Code/MemoryAllocator/slab.hpp"

class KernelBuffer {
public:
    static KernelBuffer* putcGetInstance();
    static KernelBuffer* getcGetInstance();
    static kmem_cache_t* kernelBufferCache;
    static void slabAllocatorConstructor(void* kernelBufferObject);
    static void slabAllocatorDestructor(void* kernelBufferObject);
    ~KernelBuffer() = default;

    void insertIntoBuffer(int value);
    int removeFromBuffer();

    int getNumberOfElements();

    static void* operator new(size_t n);
    static void* operator new[](size_t n);
    static void operator delete(void* ptr);
    static void operator delete[](void* ptr);

private:
    KernelBuffer() = default;
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