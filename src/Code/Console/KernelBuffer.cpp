#include "../../../h/Code/Console/KernelBuffer.hpp"

KernelBuffer* KernelBuffer::putcKernelBufferHandle = nullptr;
KernelBuffer* KernelBuffer::getcKernelBufferHandle = nullptr;
kmem_cache_t* KernelBuffer::kernelBufferCache = nullptr;

void KernelBuffer::slabAllocatorConstructor(void* kernelBufferObject) {
    auto kernelBuffer = static_cast<KernelBuffer*>(kernelBufferObject);
    kernelBuffer->capacity = 2000;
    kernelBuffer->head = kernelBuffer->tail = 0;
    kernelBuffer->buffer = nullptr;
    kernelBuffer->spaceAvailable = KernelSemaphore::createSemaphore(kernelBuffer->capacity);
    kernelBuffer->itemAvailable = KernelSemaphore::createSemaphore(0);
    kernelBuffer->mutexHead = KernelSemaphore::createSemaphore(1);
    kernelBuffer->mutexTail = KernelSemaphore::createSemaphore(1);
}

void KernelBuffer::slabAllocatorDestructor(void* kernelBufferObject) {
    auto kernelBuffer = static_cast<KernelBuffer*>(kernelBufferObject);
    kfree(kernelBuffer->buffer);
    delete kernelBuffer->spaceAvailable;
    delete kernelBuffer->itemAvailable;
    delete kernelBuffer->mutexHead;
    delete kernelBuffer->mutexTail;
}

KernelBuffer* KernelBuffer::putcGetInstance() {
    if (!putcKernelBufferHandle) {
        if (!KernelBuffer::kernelBufferCache)
            KernelBuffer::kernelBufferCache = kmem_cache_create("KernelBuffer", sizeof(KernelBuffer),
                                                                &slabAllocatorConstructor, &slabAllocatorDestructor);
        putcKernelBufferHandle = new KernelBuffer;
        putcKernelBufferHandle->buffer = static_cast<int*>(kmalloc(putcKernelBufferHandle->capacity * sizeof(int)));
    }
    return putcKernelBufferHandle;
}

KernelBuffer* KernelBuffer::getcGetInstance() {
    if (!getcKernelBufferHandle) {
        if (!KernelBuffer::kernelBufferCache)
            KernelBuffer::kernelBufferCache = kmem_cache_create("KernelBuffer", sizeof(KernelBuffer),
                                                                &slabAllocatorConstructor, &slabAllocatorDestructor);
        getcKernelBufferHandle = new KernelBuffer;
        getcKernelBufferHandle->buffer = static_cast<int*>(kmalloc(getcKernelBufferHandle->capacity * sizeof(int)));
    }
    return getcKernelBufferHandle;
}

void* KernelBuffer::operator new(size_t n) {
    return kmem_cache_alloc(kernelBufferCache);
}

void* KernelBuffer::operator new[](size_t n) {
    return kmem_cache_alloc(kernelBufferCache);
}

void KernelBuffer::operator delete(void *ptr) {
    kmem_cache_free(kernelBufferCache, ptr);
}

void KernelBuffer::operator delete[](void *ptr) {
    kmem_cache_free(kernelBufferCache, ptr);
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