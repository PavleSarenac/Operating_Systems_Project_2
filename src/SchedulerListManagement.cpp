#include "../h/TCB.hpp"
#include "../h/Z_Njihovo_Printing.hpp"

// ovo je telo funkcije koje ce izvrsavati idle nit (besposlena, vrti se u beskonacnoj petlji)
// ona se daje procesoru samo onda kada nema drugih spremnih niti u scheduleru
[[noreturn]] void idleFunction(void* arg) { while (true) { } }

// uzimamo element sa pocetka ulancane liste
TCB* removeFromScheduler(TCB*& head, TCB*& tail) {
    if (!head || !tail) return nullptr; // ovaj slucaj moze da se dogodi samo ako idle nit jos nije ubacena, a trazena je nit iz schedulera
    if (head == tail) return head; // slucaj kada je u scheduleru samo idle nit - nju vracamo i ne izbacujemo nikad iz schedulera
    TCB* thread = head;
    head = head->getNextThreadScheduler();
    thread->getNextThreadScheduler()->setPrevThreadScheduler(nullptr);
    thread->setNextThreadScheduler(nullptr);
    return thread;
}

// umecemo u ulancanu listu; ukoliko prvi put umecemo, to je slucaj kada se umece idle nit;
// kada budemo umetali sve naredne niti, umecemo ih tako da idle nit uvek bude poslednja;
// idle nit se nikada ne izbacuje iz scheduler-a nakon sto se ubaci u scheduler;
void insertIntoScheduler(TCB*& head, TCB*& tail, TCB* tcb) {
    if (!tcb) return;
    if (!head || !tail) { head = tail = tcb; return; } // ubacivanje idle niti na pocetku dok je jos nismo prvi put ubacili
    if (tcb->getBody() == &idleFunction) return; // pokusaj ubacivanja idle niti kada je ona vec u scheduleru - bez efekta
    tcb->setNextThreadScheduler(tail);
    tcb->setPrevThreadScheduler(tail->getPrevThreadScheduler());
    if (tail->getPrevThreadScheduler()) tail->getPrevThreadScheduler()->setNextThreadScheduler(tcb);
    else head = tcb;
    tail->setPrevThreadScheduler(tcb);
}
