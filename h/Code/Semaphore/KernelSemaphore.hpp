#ifndef SEMAPHORE_HPP
#define SEMAPHORE_HPP

#include "../Thread/TCB.hpp"
#include "../MemoryAllocator/slab.hpp"

class KernelSemaphore {
public:
    static void slabAllocatorConstructor(void* kernelSemaphoreObject);
    static void slabAllocatorDestructor(void* kernelSemaphoreObject);
    static kmem_cache_t* kernelSemaphoreCache;

    ~KernelSemaphore() = default;
    static KernelSemaphore* createSemaphore(unsigned short initialSemaphoreValue = 1);
    static int closeSemaphore(KernelSemaphore* semaphore);

    void wait();
    void signal();

    int getSemaphoreValue() const { return semaphoreValue; }

    // preklapamo operatore new i delete zato sto ce se metodi klase KernelSemaphore izvrsavati u kernel kodu koji se vec izvrsava
    // u okviru prekidne rutine, a nas sistem nema jezgro sa preotimanjem (preemptive kernel), tj. nije dozvoljeno preotimanje
    // za vreme izvrsavanja kernel koda - zato ne smemo da koristimo globalne operatore new i delete jer ce oni pozvati sistemske
    // pozive mem_alloc i mem_free
    static void* operator new(size_t n);
    static void* operator new[](size_t n);
    static void operator delete(void* ptr);
    static void operator delete[](void* ptr);

protected:
    void blockCurrentThread();
    TCB* unblockFirstThreadInList();

private:
    KernelSemaphore() = default;

    void insertThreadIntoBlockedList(TCB* tcb);
    TCB* removeThreadFromBlockedList();

    int semaphoreValue;
    TCB* blockedThreadsHead;
    TCB* blockedThreadsTail;
};

#endif