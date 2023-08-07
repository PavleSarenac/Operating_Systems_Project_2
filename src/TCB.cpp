#include "../h/TCB.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../h/Riscv.hpp"
#include "../h/print.hpp"
#include "../h/syscall_c.h"
#include "../h/KernelThreadFunctions.hpp"

int TCB::staticThreadId = 0;

// runningThread je pokazivac na nit koja se trenutno izvrsava (na pocetku cemo je u main-u postaviti da pokazuje na nit main-a)
TCB* TCB::runningThread = nullptr;

// promenljiva timeSliceCounter broji koliko perioda tajmera se trenutno izvrsava tekuca nit (ona na koju pokazuje pokazivac runningThread)
// kada timeSliceCounter dodje do vrednosti atributa timeSlice (vremenski odsecak, tj. kvantum koji je dat tekucoj niti, tj. tekucem objektu klase TCB),
// onda treba uraditi promenu tekuce niti i konteksta
uint64 TCB::timeSliceCounter = 0;

TCB* TCB::sleepHead = nullptr;
TCB* TCB::sleepTail = nullptr;

TCB* TCB::createThread(Body body, void* arg, void* stack, bool cppApi) {
    if (cppApi) {
        return new TCB(body, arg, stack, cppApi);
    } else {
        return new TCB(body, arg, stack);
    }
}

void TCB::insertSleepThread(uint64 time) {
    if (!sleepHead || !sleepTail) {
        sleepHead = sleepTail = runningThread;
        runningThread->setSleepTime(time); // prvi element liste uspavanih niti ce pamtiti pravi broj perioda tajmera za spavanje
        return;
    }
    uint64 currSumOfSleepTimes = 0;
    for (TCB* curr = sleepHead; curr; curr = curr->getNextSleepThread()) {
        currSumOfSleepTimes += curr->getSleepTime();
        if (time < currSumOfSleepTimes) {
            runningThread->setNextSleepThread(curr);
            runningThread->setPrevSleepThread(curr->getPrevSleepThread());
            if (!curr->getPrevSleepThread()) {
                // umetanje tekuce niti (runningThread) na pocetak liste uspavanih niti
                runningThread->setSleepTime(time);
                curr->setSleepTime(currSumOfSleepTimes - time);
                sleepHead = runningThread;
            } else {
                // umetanje tekuce niti (runningThread) negde unutar liste (NIJE UMETANJE ni na pocetak ni na kraj)
                curr->getPrevSleepThread()->setNextSleepThread(runningThread);
                runningThread->setSleepTime(time - (currSumOfSleepTimes - curr->getSleepTime()));
            }
            curr->setPrevSleepThread(runningThread);
            return;
        }
    }
    // umetanje tekuce niti (runningThread) na kraj liste uspavanih niti
    runningThread->setPrevSleepThread(sleepTail);
    sleepTail->setNextSleepThread(runningThread);
    runningThread->setSleepTime(time - currSumOfSleepTimes);
    sleepTail = runningThread;
}

void TCB::updateSleepThreadList() {
    if (!sleepHead || !sleepTail) return;
    sleepHead->setSleepTime(sleepHead->getSleepTime() - 1);
    TCB* curr = sleepHead;
    // budjenje niti kojima je sleepTime dostigao vrednost nula
    while (curr && curr->getSleepTime() == 0) {
        TCB* oldCurr = curr;
        curr = curr->getNextSleepThread();
        sleepHead = curr;
        if (curr) curr->setPrevSleepThread(nullptr);
        oldCurr->setNextSleepThread(nullptr);
        Scheduler::getInstance().put(oldCurr);
    }
    // slucaj kada se ispraznila lista uspavanih niti
    if (!curr) sleepHead = sleepTail = nullptr;
}

void* TCB::operator new(size_t n) {
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    return ptr;
}

void* TCB::operator new[](size_t n) {
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    return ptr;
}

void TCB::operator delete(void *ptr) {
    MemoryAllocator::getInstance().deallocateSegment(ptr);
}

void TCB::operator delete[](void *ptr) {
    MemoryAllocator::getInstance().deallocateSegment(ptr);
}

void TCB::initializeClassAttributes(TCB* thisPointer, Body body, void* arg, void* stack) {
    thisPointer->body = body;
    thisPointer->arg = arg;
    thisPointer->stack = static_cast<uint64*>(stack);
    // u polju ra strukture context cuvamo adresu na koju bi trebalo da skoci nit;
    // u konstruktoru podmecemo adresu staticke metode threadWrapper jer zelimo da se
    // ona prva izvrsi za svaku novonapravljenu nit
    thisPointer->context.ra = reinterpret_cast<uint64>(&threadWrapper);
    // sp se postavlja na vrh steka; posto sp pokazuje na poslednju zauzetu lokaciju, a na pocetku nijedna nije zauzeta,
    // postavili smo ga na jednu adresu iznad prve u koju sme da se stavi nesto na stek;
    // stek zauzima DEFAULT_STACK_SIZE (4096) bajtova, dakle ima mesta za 512 vrednosti velicine sizeof(uint64), tj. 8 bajtova
    // to znaci da niz na koji pokazuje uint64* stack ima 512 elemenata - zato sam ispod kod indeksiranja uradio DEFAULT_STACK_SIZE / sizeof(uint64),
    // da bih pristupio adresi koja je za jedan iznad poslednje adrese koju zauzima stek
    thisPointer->context.sp = stack ? reinterpret_cast<uint64>(&static_cast<uint64*>(stack)[DEFAULT_STACK_SIZE / sizeof(uint64)]) : 0;
    thisPointer->finished = false;
    thisPointer->threadId = TCB::staticThreadId++;
}

TCB::TCB(Body body, void* arg, void* stack) {
    initializeClassAttributes(this, body, arg, stack);

    // ako je body nullptr, to znaci da se kreira nit nad main-om i zelimo tada da main nastavi
    // da se izvrsava, zato ga ne dajemo scheduleru jer bi ga to suspendovalo; u suprotnom, stavljamo
    // nit u scheduler
    if (body) Scheduler::getInstance().put(this);
}

TCB::TCB(Body body, void* arg, void* stack, bool cppApi) {
    initializeClassAttributes(this, body, arg, stack);
}

// promena konteksta
void TCB::dispatch() {
    TCB* oldThread = runningThread;
    if (!oldThread->getFinished()) Scheduler::getInstance().put(oldThread);
    runningThread = Scheduler::getInstance().get();
    TCB::contextSwitch(&oldThread->context, &runningThread->context);
    // cak iako je oldThread ugasena i dealocirana, nije problem uraditi contextSwitch, tj. upisati kontekst te niti u prostor memorije koji
    // je dealociran jer to nece narusiti nista (jer je ta memorija slobodna i nebitno nam je sta pise u njoj), i naravno nije nam bitan taj
    // kontekst posto je ta nit ugasena i nece se vise nikada izvrsavati
}

void TCB::suspendCurrentThread() {
    TCB* oldThread = TCB::runningThread;
    TCB::runningThread = Scheduler::getInstance().get();
    TCB::contextSwitch(&oldThread->context, &TCB::runningThread->context);
}

void TCB::threadWrapper() {
    Riscv::exitSupervisorTrap();
    switchSupervisorToUser();
    runningThread->body(runningThread->arg);
    if (!runningThread->getFinished()) {
        thread_exit(); // sistemski poziv thread_exit za gasenje tekuce niti - unutar ovog poziva ce se promeniti i kontekst
    }
}

void TCB::contextSwitch(TCB::Context *oldContext, TCB::Context *runningContext) {
    // prvi parametar funkcije (pokazivac na strukturu stare niti - oldContext) se prosledjuje kroz registar a0
    // cuvanje registara ra i sp tekuce niti u njenoj strukturi
    __asm__ volatile ("sd ra, 0*8(a0)");
    __asm__ volatile ("sd sp, 1*8(a0)");

    // drugi parametar funkcije (pokazivac na strukturu nove niti - runningContext) se prosledjuje kroz registar a1
    // restauracija registara ra i sp nove niti iz njene strukture
    __asm__ volatile ("ld ra, 0*8(a1)");
    __asm__ volatile ("ld sp, 1*8(a1)");
}