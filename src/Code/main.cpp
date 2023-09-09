#include "../../h/Code/InterruptHandling/Riscv.hpp"
#include "../../h/Code/Thread/TCB.hpp"
#include "../../h/Code/Console/KernelThreadFunctions.hpp"
#include "../../h/Code/Console/KernelBuffer.hpp"
#include "../../h/Code/MemoryAllocator/slab.hpp"
#include "../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

#include "../../h/Testing/Testing_OS1/Threads_C_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Threads_CPP_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Consumer_Producer_C_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Consumer_Producer_CPP_Sync_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/ThreadSleep_C_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Consumer_Producer_CPP_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Periodic_Threads_CPP_API_Test.hpp"

#include "../../h/Testing/Testing_OS2/BuddyAllocatorTest.hpp"
#include "../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../h/Testing/Testing_OS2/SlabAllocatorOfficialExplicitTest.hpp"
#include "../../h/Testing/Testing_OS2/SlabAllocatorOfficialImplicitTest.hpp"

void userMain(void* arg) {
    // OS1 projekat testovi

    //ThreadsTestC::Threads_C_API_test(); // niti C API, sinhrona promena konteksta (prosao)
    //ThreadsTestCPP::Threads_CPP_API_test(); // niti CPP API, sinhrona promena konteksta (prosao)

    //ConsumerProducerSyncC::Consumer_Producer_Sync_C_API_Test(); // kompletan C API sa semaforima, sinhrona promena konteksta (prosao)
    //ConsumerProducerSyncCPP::Consumer_Producer_Sync_CPP_API_Test(); // kompletan CPP API sa semaforima, sinhrona promena konteksta (prosao)

    //ThreadSleepTest::Thread_Sleep_C_API_Test(); // uspavljivanje i budjenje niti, C API test (prosao)
    //ConsumerProducerAsyncCPP::Consumer_Producer_Async_CPP_API_Test(); // CPP API i asinhrona promena konteksta, kompletan test svega (prosao)

    //PeriodicThreadsTest::Periodic_Threads_CPP_API_Test();  // test periodicnih niti (prosao)

    // OS2 projekat testovi

    // Javni testovi
    //userMainSlabAllocatorOfficialExplicitTest();  // (prosao)
    userMainSlabAllocatorOfficialImplicitTest();

    //MemoryAllocationHelperFunctions::printBuddyAllocatorInfo();
    //MemoryAllocationHelperFunctions::printFirstFitAllocatorInfo();
}

// funkcija main je u nadleznosti jezgra - jezgro ima kontrolu onda nad radnjama koje ce se izvrsiti pri pokretanju programa
// nakon toga, funkcija main treba da pokrene nit nad funkcijom userMain
void main() {
    auto firstAlignedAddress = reinterpret_cast<void*>(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator());
    auto numberOfMemoryBlocksForBuddyAllocator = static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator());
    kmem_init(firstAlignedAddress, numberOfMemoryBlocksForBuddyAllocator);

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