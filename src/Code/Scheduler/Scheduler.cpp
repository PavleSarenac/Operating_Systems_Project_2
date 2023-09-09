#include "../../../h/Code/Scheduler/Scheduler.hpp"

kmem_cache_t* Scheduler::schedulerCache = nullptr;
Scheduler* Scheduler::schedulerInstance = nullptr;

void Scheduler::slabAllocatorConstructor(void* schedulerObject) {
    auto scheduler = static_cast<Scheduler*>(schedulerObject);
    scheduler->schedulerHead = nullptr;
    scheduler->schedulerTail = nullptr;
}

Scheduler& Scheduler::getInstance() {
    schedulerCache = kmem_cache_create("Scheduler", sizeof(Scheduler), &slabAllocatorConstructor, nullptr);
    if (!schedulerInstance) {
        schedulerInstance = static_cast<Scheduler*>(kmem_cache_alloc(schedulerCache));
    }
    return *schedulerInstance;
}

// uzima se nit sa pocetka ulancane liste schedulera i daje se procesoru
// u slucaju da takve niti nema, onda se procesoru daje nit koja izvrsava funkciju idleFunction (beskonacno se vrti u praznoj petlji)
TCB* Scheduler::get() {
    return removeFromScheduler(schedulerHead, schedulerTail);
}

// nova nit se smesta na kraj ulancane liste schedulera
void Scheduler::put(TCB* tcb) {
    insertIntoScheduler(schedulerHead, schedulerTail, tcb);
}