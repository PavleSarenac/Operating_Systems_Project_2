#include "../h/KernelBuffer.hpp"
#include "../h/MemoryAllocator.hpp"

KernelBuffer* KernelBuffer::putcKernelBufferHandle = nullptr;
KernelBuffer* KernelBuffer::getcKernelBufferHandle = nullptr;

KernelBuffer* KernelBuffer::putcGetInstance() {
    if (!putcKernelBufferHandle) {
        putcKernelBufferHandle = new KernelBuffer;
        return putcKernelBufferHandle;
    } else {
        return putcKernelBufferHandle;
    }
}

KernelBuffer* KernelBuffer::getcGetInstance() {
    if (!getcKernelBufferHandle) {
        getcKernelBufferHandle = new KernelBuffer;
        return getcKernelBufferHandle;
    } else {
        return getcKernelBufferHandle;
    }
}

void* KernelBuffer::operator new(size_t n) {
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    return ptr;
}

void* KernelBuffer::operator new[](size_t n) {
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    return ptr;
}

void KernelBuffer::operator delete(void *ptr) {
    MemoryAllocator::getInstance().deallocateSegment(ptr);
}

void KernelBuffer::operator delete[](void *ptr) {
    MemoryAllocator::getInstance().deallocateSegment(ptr);
}

KernelBuffer::KernelBuffer() {
    capacity = 8192; // 8 KB
    head = tail = 0;
    buffer = static_cast<int*>(KernelBuffer::operator new(capacity * sizeof(int)));
    spaceAvailable = KernelSemaphore::createSemaphore(capacity);
    itemAvailable = KernelSemaphore::createSemaphore(0);
    mutexHead = KernelSemaphore::createSemaphore(1);
    mutexTail = KernelSemaphore::createSemaphore(1);
}

KernelBuffer::~KernelBuffer() {
    KernelBuffer::operator delete[](buffer);
    delete spaceAvailable;
    delete itemAvailable;
    delete mutexHead;
    delete mutexTail;
}

void KernelBuffer::insertIntoBuffer(int value) {
    spaceAvailable->wait();

    mutexTail->wait();
    buffer[tail] = value;
    tail = (tail + 1) % capacity;
    mutexTail->signal();

    itemAvailable->signal();
}

int KernelBuffer::removeFromBuffer() {
    itemAvailable->wait();

    mutexHead->wait();
    int value = buffer[head];
    head = (head + 1) % capacity;
    mutexHead->signal();

    spaceAvailable->signal();

    return value;
}

int KernelBuffer::getNumberOfElements() {
    int value;

    mutexHead->wait();
    mutexTail->wait();

    if (tail >= head) {
        value = tail - head;
    } else {
        value = capacity - head + tail;
    }

    mutexHead->signal();
    mutexTail->signal();

    return value;
}