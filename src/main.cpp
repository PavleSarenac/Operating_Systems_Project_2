#include "../h/Riscv.hpp"
#include "../h/TCB.hpp"
#include "../h/KernelThreadFunctions.hpp"
#include "../h/KernelBuffer.hpp"
#include "../h/Z_Njihovo_Threads_C_API_Test.hpp"
#include "../h/Z_Njihovo_Threads_CPP_API_Test.hpp"
#include "../h/Z_Njihovo_Consumer_Producer_C_API_Test.hpp"
#include "../h/Z_Njihovo_Consumer_Producer_CPP_Sync_API_Test.hpp"
#include "../h/Z_Njihovo_ThreadSleep_C_API_Test.hpp"
#include "../h/Z_Njihovo_Consumer_Producer_CPP_API_Test.hpp"

Semaphore* myOwnMutex;
Semaphore* myOwnWaitForAll;

class A : public PeriodicThread {
public:
    explicit A(time_t period) : PeriodicThread(period) {}

protected:
    void run() override {
        while (true && !shouldThisThreadEnd) {
            periodicActivation();
            time_sleep(sleepTime);
        }
        myOwnWaitForAll->signal();
    }

private:
    void periodicActivation() override {
        myOwnMutex->wait();
        putc('A');
        putc('\n');
        myOwnMutex->signal();
    }
};

class B : public PeriodicThread {
public:
    explicit B(time_t period) : PeriodicThread(period) {}

protected:
    void run() override {
        while (true && !shouldThisThreadEnd) {
            periodicActivation();
            time_sleep(sleepTime);
        }
        myOwnWaitForAll->signal();
    }

private:
    void periodicActivation() override {
        myOwnMutex->wait();
        putc('B');
        putc('\n');
        myOwnMutex->signal();
    }
};

class C : public PeriodicThread {
public:
    explicit C(time_t period) : PeriodicThread(period) {}

protected:
    void run() override {
        while (true && !shouldThisThreadEnd) {
            periodicActivation();
            time_sleep(sleepTime);
        }
        myOwnWaitForAll->signal();
    }

private:
    void periodicActivation() override {
        myOwnMutex->wait();
        putc('C');
        putc('\n');
        myOwnMutex->signal();
    }
};

void userMain(void* arg) {
    //Threads_C_API_test(); // niti C API, sinhrona promena konteksta (prosao)
    //Threads_CPP_API_test(); // niti CPP API, sinhrona promena konteksta (prosao)

    //producerConsumer_C_API(); // kompletan C API sa semaforima, sinhrona promena konteksta (prosao)
    //producerConsumer_CPP_Sync_API(); // kompletan CPP API sa semaforima, sinhrona promena konteksta (prosao)

    //testSleeping(); // uspavljivanje i budjenje niti, C API test (prosao)
    //ConsumerProducerCPP::testConsumerProducer(); // CPP API i asinhrona promena konteksta, kompletan test svega (prosao)

    myOwnMutex = new Semaphore();
    myOwnWaitForAll = new Semaphore(0);

    A* a = new A(5);
    B* b = new B(5);
    C* c = new C(5);

    PeriodicThread* threads[3];
    threads[0] = a;
    threads[1] = b;
    threads[2] = c;

    threads[0]->start();
    threads[1]->start();
    threads[2]->start();

    int endThis = 0;
    for (int i = 0; i < 3; i++) {
        char chr = getc();
        if (chr == 'k') {
            threads[endThis++]->endPeriodicThread();
        } else {
            i--;
        }
    }

    for (int i = 0; i < 3; i++) {
        myOwnWaitForAll->wait();
    }

    delete myOwnMutex;
    delete myOwnWaitForAll;
}

// funkcija main je u nadleznosti jezgra - jezgro ima kontrolu onda nad radnjama koje ce se izvrsiti pri pokretanju programa
// nakon toga, funkcija main treba da pokrene nit nad funkcijom userMain
void main() {

    // upisivanje adrese prekidne rutine u registar stvec
    Riscv::writeStvec(reinterpret_cast<uint64>(&Riscv::supervisorTrap));

    // kreiranje niti za main funkciju da bismo postavili pokazivac TCB::runningThread na nit main-a - tako ce moci da radi promena konteksta
    thread_t mainThreadHandle;
    thread_create(&mainThreadHandle, nullptr, nullptr);
    TCB::runningThread = (TCB*)(mainThreadHandle);

    // kreiranje idle niti i ubacivanje nje u scheduler (ubacivanje niti u scheduler se radi u konstruktoru klase TCB (klase koja apstrahuje nit))
    // idle nit se nikada ne izbacuje iz schedulera i uvek ce biti na kraju schedulera
    thread_t idleThreadHandle;
    thread_create(&idleThreadHandle, &idleFunction, nullptr);

    // kreiranje niti nad funkcijom userMain i ubacivanje nje u scheduler (ubacivanje niti u scheduler se radi u konstruktoru klase TCB)
    thread_t userMainThreadHandle;
    thread_create(&userMainThreadHandle, &userMain, nullptr);

    thread_t putcKernelThread;
    thread_create(&putcKernelThread, &putcKernelThreadFunction, nullptr);

    // omogucujem spoljasnje prekide jer trenutno radimo sve u sistemskom rezimu, a tu su oni podrazumevano onemoguceni;
    // radicu u sistemskom rezimu sve dok ne dodjem do kraja projekta kad cu imati i semafore i ispis;
    Riscv::maskSetBitsSstatus(Riscv::SSTATUS_SIE);

    while (!((TCB*)userMainThreadHandle)->getFinished() || KernelBuffer::putcGetInstance()->getNumberOfElements() > 0) {
        thread_dispatch();
    }

    // moram da dealociram bafer eksplicitno jer KernelBuffer::getInstance unutar sebe ne pravi staticki objekat klase, vec
    // dinamicki alocira na heap-u, sto znaci da se nece unistiti sam taj objekat kada se zavrsi main (upravo posto nije rec o
    // statickom objektu) i zato moramo mi ovde eksplicitno da ga unistimo
    delete KernelBuffer::getcGetInstance();
    // ne brisem bafer za putc jer treba da se ispise Kernel Finished za sta treba taj bafer
}