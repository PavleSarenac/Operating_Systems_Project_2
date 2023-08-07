#include "../h/KernelSemaphore.hpp"
#include "../h/MemoryAllocator.hpp"

KernelSemaphore::~KernelSemaphore() {
    KernelSemaphore::closeSemaphore(this);
}

KernelSemaphore* KernelSemaphore::createSemaphore(unsigned short initialSemaphoreValue) {
    return new KernelSemaphore(initialSemaphoreValue);
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
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    return ptr;
}

void* KernelSemaphore::operator new[](size_t n) {
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    return ptr;
}

void KernelSemaphore::operator delete(void *ptr) {
    MemoryAllocator::getInstance().deallocateSegment(ptr);
}

void KernelSemaphore::operator delete[](void *ptr) {
    MemoryAllocator::getInstance().deallocateSegment(ptr);
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