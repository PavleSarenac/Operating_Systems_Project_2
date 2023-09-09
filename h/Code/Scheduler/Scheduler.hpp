#ifndef SCHEDULER_HPP
#define SCHEDULER_HPP

#include "../../../h/Code/MemoryAllocator/slab.hpp"

// forward declaration klase TCB - ovo smo uradili da bi prevodilac mogao da prepozna tip TCB* koji se koristi u klasi Scheduler
// nisam uradio #include "TCB.hpp", jer sam u fajlu TCB.hpp uradio #include "Scheduler.hpp", tako da bi tada doslo do kruzne deklaracije,
// tj. circular dependency
class TCB;
// prosledjujemo referencu na pokazivace schedulerHead i schedulerTail jer hocemo da se upravo ti pokazivaci izmene u ovim funkcijama;
// pokazivac na nit koju umecemo u scheduler nema potrebe prosledjivati po referenci jer ne zelimo da se menja taj pokazivac, nego samo zelimo
// da modifikujemo i dohvatamo atribute niti na koju pokazuje taj pokazivac, sto ce se i dogoditi pomocu odgovarajucih getter i setter metoda
// ove f-je su definisane u fajlu SchedulerListManagement.cpp
TCB* removeFromScheduler(TCB*& head, TCB*& tail);
void insertIntoScheduler(TCB*& head, TCB*& tail, TCB* tcb);
[[noreturn]] void idleFunction(void* arg);

// klasu Scheduler smo dizajnirali kao singleton klasu - moze samo jedan objekat ove klase da se napravi
class Scheduler {
public:
    static kmem_cache_t* schedulerCache;
    static void slabAllocatorConstructor(void* schedulerObject);
    static Scheduler& getInstance();
    Scheduler(const Scheduler&) = delete;
    void operator=(const Scheduler&) = delete;
    TCB* get();
    void put(TCB* tcb);

private:
    static Scheduler* schedulerInstance;
    TCB* schedulerHead;
    TCB* schedulerTail;

    Scheduler() = default;
};

#endif