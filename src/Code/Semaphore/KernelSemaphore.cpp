#include "../../../h/Code/Semaphore/KernelSemaphore.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocator.hpp"

kmem_cache_t* KernelSemaphore::kernelSemaphoreCache = nullptr;

void KernelSemaphore::slabAllocatorConstructor(void* kernelSemaphoreObject) {
    auto kernelSemaphore = static_cast<KernelSemaphore*>(kernelSemaphoreObject);
    kernelSemaphore->semaphoreValue = 1;
    kernelSemaphore->blockedThreadsHead = nullptr;
    kernelSemaphore->blockedThreadsTail = nullptr;
}

void KernelSemaphore::slabAllocatorDestructor(void* kernelSemaphoreObject) {
    auto kernelSemaphore = static_cast<KernelSemaphore*>(kernelSemaphoreObject);
    KernelSemaphore::closeSemaphore(kernelSemaphore);
}

KernelSemaphore* KernelSemaphore::createSemaphore(unsigned short initialSemaphoreValue) {
    KernelSemaphore::kernelSemaphoreCache = kmem_cache_create("KernelSemaphore", sizeof(KernelSemaphore),
                                                              &slabAllocatorConstructor, &slabAllocatorDestructor);
    auto newSemaphore = new KernelSemaphore;
    newSemaphore->semaphoreValue = initialSemaphoreValue;
    return newSemaphore;
}

int KernelSemaphore::closeSemaphore(KernelSemaphore *semaphore) {
    if (!semaphore) return -1;
    while (semaphore->blockedThreadsHead) {
        TCB* unblockedThread = semaphore->unblockFirstThreadInList(); // odblokiranje svih niti koje cekaju na tekucem semaforu
        if (unblockedThread) unblockedThread->setWaitSemaphoreFailed(true); // sem_wait sistemski poziv pozvan za sve ove niti treba da vrati gresku
    }
    return 0;
}

void KernelSemaphore::wait() {
    if (--semaphoreValue < 0) {
        blockCurrentThread();
    }
}

void KernelSemaphore::signal() {
    if (++semaphoreValue <= 0) {
        unblockFirstThreadInList();
    }
}

void* KernelSemaphore::operator new(size_t n) {
    return kmem_cache_alloc(kernelSemaphoreCache);
}

void* KernelSemaphore::operator new[](size_t n) {
    return kmem_cache_alloc(kernelSemaphoreCache);
}

void KernelSemaphore::operator delete(void *ptr) {
    kmem_cache_free(kernelSemaphoreCache, ptr);
}

void KernelSemaphore::operator delete[](void *ptr) {
    kmem_cache_free(kernelSemaphoreCache, ptr);
}

void KernelSemaphore::blockCurrentThread() {
    insertThreadIntoBlockedList(TCB::runningThread);
    TCB::suspendCurrentThread();
}

TCB* KernelSemaphore::unblockFirstThreadInList() {
    TCB* tcb = removeThreadFromBlockedList();
    if (tcb) Scheduler::getInstance().put(tcb);
    return tcb;
}

void KernelSemaphore::insertThreadIntoBlockedList(TCB *tcb) {
    if (!blockedThreadsHead || !blockedThreadsTail) {
        blockedThreadsHead = blockedThreadsTail = tcb;
        blockedThreadsHead->setNextSemaphoreThread(nullptr);
    } else {
        blockedThreadsTail->setNextSemaphoreThread(tcb);
        blockedThreadsTail = tcb;
        blockedThreadsTail->setNextSemaphoreThread(nullptr);
    }
}

TCB* KernelSemaphore::removeThreadFromBlockedList() {
    if (!blockedThreadsHead || !blockedThreadsTail) return nullptr;
    TCB* oldThread = blockedThreadsHead;
    blockedThreadsHead = blockedThreadsHead->getNextSemaphoreThread();
    if (!blockedThreadsHead) blockedThreadsTail = nullptr;
    oldThread->setNextSemaphoreThread(nullptr);
    return oldThread;
}