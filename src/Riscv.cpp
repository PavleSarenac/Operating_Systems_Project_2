#include "../h/Riscv.hpp"
#include "../h/print.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../lib/console.h"
#include "../h/TCB.hpp"
#include "../h/KernelSemaphore.hpp"
#include "../h/KernelBuffer.hpp"

void Riscv::exitSupervisorTrap() {
    __asm__ volatile ("csrw sepc, ra"); // u sepc postavljamo vrednost ra jer hocemo da se tu vratimo nakon sret koji cemo pozvati
    __asm__ volatile ("sret");
    // sret instrukcija radi sledece:
    // prelazi se u rezim koji pise u SPP, u pc se upisuje vrednost iz sepc i u bit SIE sstatus registra se upisuje vrednost bita SPIE
}

void Riscv::handleSupervisorTrap() {

    // alokacija prostora na steku za registre a0-a7; hocemo na steku da ih sacuvamo jer su to parametri sistemskih poziva a kompajler moze da ih uprlja
    __asm__ volatile ("addi sp,sp,-64");
    // cuvanje registara a0-a7 na steku
    pushSysCallParameters();

    // citanje razloga ulaska u prekidnu rutinu i smestanje u promenljivu scause
    uint64 volatile scause = readScause();

    if (scause == 0x0000000000000008UL || scause == 0x0000000000000009UL) {
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: ecall iz korisnickog ili sistemskog rezima

        // na steku niti koja je pozvala sistemski poziv ce biti sacuvane vrednosti sepc i sstatus;
        // ovo radimo jer se kod ecall-a u sepc cuva adresa instrukcije ecall, a hocemo da se pri povratku iz prekidne rutine predje
        // na instrukciju posle ecall (sret upisuje sepc u pc, sve instrukcije su duzine 4 bajta)
        uint64 volatile sepc = readSepc() + 4;
        uint64 volatile sstatus = readSstatus();

        uint64 volatile sysCallCode; // iz registra a0 citamo kod sistemskog poziva i upisujemo ga u sysCallCode
        __asm__ volatile ("ld %[sysCallCode],0(sp)" : [sysCallCode] "=r"(sysCallCode));

        if (sysCallCode == 0x01) {
            // sistemski poziv: mem_alloc

            size_t volatile numberOfBlocks; // broj blokova memorije koje je korisnik zatrazio - citamo iz registra a1
            __asm__ volatile ("ld %[numberOfBlocks],8(sp)" : [numberOfBlocks] "=r"(numberOfBlocks));

            // izvrsavamo kernel kod - alociramo memoriju koju je korisnik trazio i upisujemo njenu adresu u pokazivac allocatedMemory
            void* allocatedMemory = MemoryAllocator::getInstance().allocateSegment(numberOfBlocks);

            // upisujemo adresu te memorije u registar a0 kao povratnu vrednost ovog sistemskog poziva
            __asm__ volatile ("mv a0,%[allocatedMemory]" : : [allocatedMemory] "r"(allocatedMemory));

        } else if (sysCallCode == 0x02) {
            // sistemski poziv: mem_free

            uint64* volatile freeThisMemory; // ovde cemo smestiti adresu memorije koju treba osloboditi - to citamo iz registra a1
            __asm__ volatile ("ld %[freeThisMemory],8(sp)" : [freeThisMemory] "=r"(freeThisMemory));

            // izvrsavamo kernel kod - dealociramo memoriju koju je korisnik prosledio i rezultat ove operacije upisujemo u promenljivu successInfo
            int successInfo = MemoryAllocator::getInstance().deallocateSegment(freeThisMemory);

            // upisujemo informaciju o uspehu ove operacije u registar a0 kao povratnu vrednost ovog sistemskog poziva
            __asm__ volatile ("mv a0,%[successInfo]" : : [successInfo] "r"(successInfo));

        } else if (sysCallCode == 0x11) {
            // sistemski poziv: thread_create

            TCB** handle; // ovde ce biti smestena adresa na kojoj se nalazi vrednost pokazivaca koji pokazuje na nit (objekat klase TCB)
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
            void (*startRoutine)(void*); // ovde cemo smestiti adresu funkcije koju novokreirana nit treba da izvrsava - citamo tu adresu iz registra a2
            __asm__ volatile ("ld %[startRoutine],16(sp)" : [startRoutine] "=r"(startRoutine));
            void* arg; // ovde smestamo adresu argumenta koji treba proslediti funkciji cija je adresa zapamcena u startRoutine - citamo iz registra a3
            __asm__ volatile ("ld %[arg],24(sp)" : [arg] "=r"(arg));
            void* stack; // ovde smestamo adresu steka koji je alociran za nit koju treba napraviti - citamo iz registra a4
            __asm__ volatile ("ld %[stack],32(sp)" : [stack] "=r"(stack));

            // izvrsavamo kernel kod - kreiramo novu nit za zadatom funkcijom, njenim argumentom i sa zadatim stekom
            *handle = TCB::createThread(startRoutine, arg, stack, false);

        } else if (sysCallCode == 0x12) {
            // sistemski poziv: thread_exit

            // za tekucu nit se postavlja flag da je ona zavrsena, pa se zato ona nece vise davati scheduler-u na raspolaganje
            TCB::runningThread->setFinished(true);
            // kada se ugasi tekuca nit, treba da se promeni kontekst kako bi procesor dobio neku drugu nit
            TCB::dispatch();

        } else if (sysCallCode == 0x13) {
            // sistemski poziv: thread_dispatch

            // u okviru staticke metode dispatch se menja kontekst;
            // cuvanje i restauraciju registara radimo u okviru prekidne rutine supervisorTrap
            TCB::dispatch();

        } else if (sysCallCode == 0x14) {
            // sistemski poziv: thread_create_cpp

            TCB** handle; // ovde ce biti smestena adresa na kojoj se nalazi vrednost pokazivaca koji pokazuje na nit (objekat klase TCB)
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
            void (*startRoutine)(void*); // ovde cemo smestiti adresu funkcije koju novokreirana nit treba da izvrsava - citamo tu adresu iz registra a2
            __asm__ volatile ("ld %[startRoutine],16(sp)" : [startRoutine] "=r"(startRoutine));
            void* arg; // ovde smestamo adresu argumenta koji treba proslediti funkciji cija je adresa zapamcena u startRoutine - citamo iz registra a3
            __asm__ volatile ("ld %[arg],24(sp)" : [arg] "=r"(arg));
            void* stack; // ovde smestamo adresu steka koji je alociran za nit koju treba napraviti - citamo iz registra a4
            __asm__ volatile ("ld %[stack],32(sp)" : [stack] "=r"(stack));

            // izvrsavamo kernel kod - kreiramo novu nit za zadatom funkcijom, njenim argumentom i sa zadatim stekom
            *handle = TCB::createThread(startRoutine, arg, stack, true);

        } else if (sysCallCode == 0x15) {
            // sistemski poziv: scheduler_put

            TCB* thread;
            __asm__ volatile ("ld %[thread],8(sp)" : [thread] "=r"(thread)); // citanje iz registra a1

            // stavljanje ove niti u scheduler
            Scheduler::getInstance().put(thread);

        } else if (sysCallCode == 0x16) {
            // sistemski poziv: getThreadId

            int volatile threadId = TCB::runningThread->getThreadId();

            TCB::dispatch();

            // upisujemo adresu te memorije u registar a0 kao povratnu vrednost ovog sistemskog poziva
            __asm__ volatile ("mv a0,%[threadId]" : : [threadId] "r"(threadId));

        }
        else if (sysCallCode == 0x21) {
            // sistemski poziv: sem_open

            KernelSemaphore** handle; // ovde ce biti smestena adresa na kojoj se nalazi vrednost pokazivaca koji pokazuje na semafor (objekat klase KernelSemaphore)
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
            uint16 initialSemaphoreValue; // pocetna vrednost semafora
            __asm__ volatile ("ld %[initialSemaphoreValue],16(sp)" : [initialSemaphoreValue] "=r"(initialSemaphoreValue)); // citanje iz registra a2

            // izvrsavamo kernel kod - kreiramo nov semafor sa zadatom pocetnom vrednoscu
            *handle = KernelSemaphore::createSemaphore(initialSemaphoreValue);

        } else if (sysCallCode == 0x22) {
            // sistemski poziv: sem_close

            KernelSemaphore* handle; // ovde ce biti smestena adresa semafora kojeg treba osloboditi
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1

            // oslobadjamo zadati semafor
            int successInfo = KernelSemaphore::closeSemaphore(handle);
            // upisujemo informaciju o uspehu ove operacije u registar a0 kao povratnu vrednost ovog sistemskog poziva
            __asm__ volatile ("mv a0,%[successInfo]" : : [successInfo] "r"(successInfo));

        } else if (sysCallCode == 0x23) {
            // sistemski poziv: sem_wait

            KernelSemaphore* semaphoreId; // ovde ce biti smestena adresa semafora za koji treba da se pozove metod wait
            __asm__ volatile ("ld %[semaphoreId],8(sp)" : [semaphoreId] "=r"(semaphoreId)); // citanje iz registra a1

            // za prosledjeni semafor se zove metod wait nad tekucom niti
            semaphoreId->wait();

            if (TCB::runningThread->getWaitSemaphoreFailed()) __asm__ volatile ("li a0,-1"); // slucaj kada je nit odblokirana sa sem_close umesto sem_signal
            else __asm__ volatile ("li a0,1"); // slucaj kada je nit odblokirana normalno pomocu sistemskog poziva sem_signal

        } else if (sysCallCode == 0x24) {
            // sistemski poziv: sem_signal

            KernelSemaphore* semaphoreId; // ovde ce biti smestena adresa semafora za koji treba da se pozove metod signal
            __asm__ volatile ("ld %[semaphoreId],8(sp)" : [semaphoreId] "=r"(semaphoreId)); // citanje iz registra a1

            // za prosledjeni semafor se zove metod signal
            semaphoreId->signal();

        } else if (sysCallCode == 0x31) {
            // sistemski poziv: time_sleep

            uint64 time; // broj perioda tajmera na koliko treba da se uspava tekuca nit
            __asm__ volatile ("ld %[time], 8(sp)" : [time] "=r"(time)); // citanje iz registra a1

            // umetanje tekuce niti u red uspavanih niti sa zadatim brojem perioda tajmera koliko tekuca nit treba da spava
            TCB::insertSleepThread(time);
            // tekucu nit treba suspendovati tako sto cemo promeniti kontekst bez vracanja tekuce niti u rasporedjivac ovde
            TCB::suspendCurrentThread();

            // operacija umetanja uspavane niti u listu uvek uspeva jer ne alociram dodatnu memoriju za umetanje u listu, vec jednostavno
            // uvezujem u listu koju simuliram pomocu pokazivaca koji su atributi klase TCB
            __asm__ volatile ("li a0,1");

        } else if (sysCallCode == 0x41) {
            // sistemski poziv: getc

            char inputCharacter = KernelBuffer::getcGetInstance()->removeFromBuffer();
            // rezultat ovog sistemskog poziva (uneti karakter) vracamo kroz registar a0
            __asm__ volatile ("mv a0,%[inputCharacter]" : : [inputCharacter] "r"(inputCharacter));

        } else if (sysCallCode == 0x42) {
            // sistemski poziv: putc

            char outputCharacter;
            __asm__ volatile ("ld %[outputCharacter], 8(sp)" : [outputCharacter] "=r"(outputCharacter)); // citanje iz registra a1

            KernelBuffer::putcGetInstance()->insertIntoBuffer(outputCharacter);

        } else if (sysCallCode == 0x50) {
            // sistemski poziv: switchSupervisorToUser

            Riscv::maskClearBitsSstatus(Riscv::SSTATUS_SPP);

        } else if (sysCallCode == 0x51) {
            // sistemski poziv: switchUserToSupervisor

            Riscv::maskSetBitsSstatus(Riscv::SSTATUS_SPP);

        }

        // pre ulaska u handleSupervisorTrap() u prekidnoj rutini (supervisorTrap) su sacuvane stare vrednosti svih 32 registra opste namene;
        // nakon izlaska iz ove funkcije (handleSupervisorTrap), restarurirala bi se stara vrednost registra a0, a mi ne zelimo da ta vrednost ostane
        // u registru a0 nakon povratka iz prekidne rutine, vec zelimo da se upise povratna vrednost sistemskog poziva; zato, ovde prepisujem rezultat
        // sistemskog poziva preko stare vrednosti a0 koja se nalazi na steku, i na taj nacin ce se restaurirati ova povratna vrednost sistemskog poziva
        // nakon izlaska iz funkcije handleSupervisorTrap
        __asm__ volatile ("sd a0,10*8(s0)"); // a0 je zapravo registar x10 - pise u dokumentaciji

        // restauracija registara sepc i sstatus sa steka tekuce niti
        writeSepc(sepc);
        if (sysCallCode != 0x50 && sysCallCode != 0x51) {
            writeSstatus(sstatus);
        }

    } else if (scause == 0x0000000000000002UL) {
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: ilegalna instrukcija

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x0000000000000005UL) {
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: nedozvoljena adresa citanja

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x0000000000000007UL) {
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: nedozvoljena adresa upisa

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x8000000000000001UL) {
        // spoljasnji prekid (tajmer ili konzola): da; razlog prekida: softverski prekid od tajmera

        maskClearBitsSip(SIP_SSIP); // brise se zahtev za prekidom od tajmera
        TCB::updateSleepThreadList(); // azuriranje liste uspavanih niti
        TCB::timeSliceCounter++; // povecava se brojac perioda tajmera za tekucu nit (runningThread)
        // ako se tekuca nit se izvrsavala dovoljno perioda tajmera - promeniti kontekst
        if (TCB::timeSliceCounter >= TCB::runningThread->getTimeSlice()) {
            uint64 volatile sepc = readSepc();
            uint64 volatile sstatus = readSstatus();
            TCB::timeSliceCounter = 0;
            TCB::dispatch(); // promena konteksta
            writeSepc(sepc);
            writeSstatus(sstatus);
        }

    } else if (scause == 0x8000000000000009UL) {
        // spoljasnji prekid (tajmer ili konzola): da; razlog prekida: spoljasnji hardverski prekid od konzole

        // od kontrolera prekida saznajemo koji uredjaj je generisao prekid pozivajuci funkciju plic_claim
        int externalInterruptCode = plic_claim();

        if (externalInterruptCode == CONSOLE_IRQ) {
            // prekid od konzole
            while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {
                int consoleInput = *reinterpret_cast<char*>(CONSOLE_RX_DATA);
                KernelBuffer::getcGetInstance()->insertIntoBuffer(consoleInput);
            }

        }

        // kontroler prekida se obavestava da je prekid obradjen
        plic_complete(externalInterruptCode);
        maskClearBitsSip(SIP_SEIP); // brise se zahtev za spoljasnjim hardverskim prekidom
    }

    // ciscenje steka - vise nisu potrebni parametri sistemskog poziva/prekida/izuzetka na steku posto je sad to obradjeno
    __asm__ volatile ("addi sp,sp,64");

}