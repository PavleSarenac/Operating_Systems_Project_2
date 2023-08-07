#include "../h/Scheduler.hpp"

Scheduler& Scheduler::getInstance() {
    static Scheduler scheduler;
    return scheduler;
}

// uzima se nit sa pocetka ulancane liste schedulera i daje se procesoru
// u slucaju da takve niti nema, onda se procesoru daje nit koja izvrsava funkciju idleFunction (beskonacno se vrti u praznoj petlji)
TCB* Scheduler::get() {
    return removeFromScheduler(schedulerHead, scheduletTail);
}

// nova nit se smesta na kraj ulancane liste schedulera
void Scheduler::put(TCB* tcb) {
    insertIntoScheduler(schedulerHead, scheduletTail, tcb);
}