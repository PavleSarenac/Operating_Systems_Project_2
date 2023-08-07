#include "../h/syscall_c.h"

void* mem_alloc(size_t size) { // size je broj bajtova koje je korisnik trazio - to cu zaokruziti na ceo broj blokova tako da korisnik dobije tacno toliko ili cak i vise memorije
    uint64 sysCallCode = 0x01; // kod ovog sistemskog poziva
    size_t numberOfBlocks = size % MEM_BLOCK_SIZE ? size / MEM_BLOCK_SIZE + 1 : size / MEM_BLOCK_SIZE; // bajtovi zaokruzeni na blokove velicine MEM_BLOCK_SIZE

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = numberOfBlocks;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde adresa alocirane memorije, to upisujem u ptr i vracam korisniku
    void* ptr;
    __asm__ volatile ("mv a0,%[ptr]" : [ptr] "=r"(ptr));
    return ptr;
}

int mem_free(void* ptr) {
    uint64 sysCallCode = 0x02; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(ptr);
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}

int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg) { // handle je dvostruki pokazivac u koji treba upisati adresu kreirane niti
    uint64 sysCallCode = 0x11; // kod ovog sistemskog poziva
    void* stack;
    if (!start_routine) { // ako je start_routine nullptr, znaci treba pokrenuti nit nad main-om, a za to ne treba da alociramo stek jer ga vec main ima
        stack = nullptr;
    } else {
        // hocemo da na steku ima mesta za DEFAULT_STACK_SIZE (4096) bajtova - ima mesta za 512 vrednosti velicine uint64 (8 bajtova)
        stack = mem_alloc(DEFAULT_STACK_SIZE);
        if (!stack) return -1;
    }

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreirane niti
    arguments.arg2 = reinterpret_cast<uint64>(start_routine); // adresa funkcije koju treba da izvrsava novokreirana nit
    arguments.arg3 = reinterpret_cast<uint64>(arg); // adresa argumenta koji treba proslediti funkciji start_routine
    arguments.arg4 = reinterpret_cast<uint64>(stack); // adresa na kojoj je alociran stek za ovu nit koju treba napraviti
    prepareArgsAndEcall(&arguments);

    // slucaj kada je neuspesno alociran prostor za novu nit (u prekidnoj rutini se poziva TCB::createThread)
    if (*handle == nullptr) return -1;

    return 0;
}

int thread_exit() {
    uint64 sysCallCode = 0x12; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = 0;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // ukoliko se sistemski poziv thread_exit vrati ovde, to znaci da nit nije uspesno ugasena i da se nije promenio kontekst, zato
    // se vraca definitivno kod greske u tom slucaju
    return -1;
}

void thread_dispatch() {
    uint64 sysCallCode = 0x13; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = 0;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);
}

int thread_create_cpp(thread_t* handle, void(*start_routine)(void*), void* arg) {
    uint64 sysCallCode = 0x14; // kod ovog sistemskog poziva
    void* stack;
    if (!start_routine) { // ako je start_routine nullptr, znaci treba pokrenuti nit nad main-om, a za to ne treba da alociramo stek jer ga vec main ima
        stack = nullptr;
    } else {
        // hocemo da na steku ima mesta za DEFAULT_STACK_SIZE (4096) bajtova - ima mesta za 512 vrednosti velicine uint64 (8 bajtova)
        stack = mem_alloc(DEFAULT_STACK_SIZE);
        if (!stack) return -1;
    }

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreirane niti
    arguments.arg2 = reinterpret_cast<uint64>(start_routine); // adresa funkcije koju treba da izvrsava novokreirana nit
    arguments.arg3 = reinterpret_cast<uint64>(arg); // adresa argumenta koji treba proslediti funkciji start_routine
    arguments.arg4 = reinterpret_cast<uint64>(stack); // adresa na kojoj je alociran stek za ovu nit koju treba napraviti
    prepareArgsAndEcall(&arguments);

    // slucaj kada je neuspesno alociran prostor za novu nit (u prekidnoj rutini se poziva TCB::createThread)
    if (*handle == nullptr) return -1;

    return 0;
}

int scheduler_put(thread_t thread) {
    uint64 sysCallCode = 0x15; // kod ovog sistemskog poziva
    if (!thread) return -1;

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(thread);
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // ovaj sistemski poziv uvek uspeva jer je ovo jednostavno uvezivanje u listu schedulera bez dinamicke alokacije memorije
    return 0;
}

int getThreadId() {
    uint64 sysCallCode = 0x16; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = 0;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}

int sem_open(sem_t* handle, unsigned init) {
    uint64 sysCallCode = 0x21; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreiranog semafora
    arguments.arg2 = init;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // slucaj kada je neuspesno alociran prostor za nov semafor (u prekidnoj rutini se poziva KernelSemaphore::createSemaphore)
    if (*handle == nullptr) return -1;

    return 0;
}

int sem_close(sem_t handle) {
    uint64 sysCallCode = 0x22; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa semafora kojeg treba osloboditi
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}

int sem_wait(sem_t id) {
    uint64 sysCallCode = 0x23; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(id); // adresa semafora za koji treba da se pozove metod wait
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}

int sem_signal(sem_t id) {
    uint64 sysCallCode = 0x24; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = reinterpret_cast<uint64>(id); // adresa semafora za koji treba da se pozove metod signal
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // sem_signal se uvek uspesno obavi - nema ni rizika od eventualnog loseg rada alokatora memorije jer uopste ne alociram
    // i dealociram dinamicki elemente ulancane liste blokiranih niti na semaforu, vec pomocu pokazivaca kao nestatickih atributa
    // klase TCB formiram ulancanu listu
    return 0;
}

int time_sleep(time_t time) { // time_t je zapravo uint64
    uint64 sysCallCode = 0x31; // kod ovog sistemskog poziva

    if (time == 0) return 0;

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = time;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}

char getc() {
    uint64 sysCallCode = 0x41; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = 0;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);

    char inputCharacter;
    __asm__ volatile ("mv a0,%[inputCharacter]" : [inputCharacter] "=r"(inputCharacter));
    return inputCharacter;
}

void putc(char c) {
    uint64 sysCallCode = 0x42; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = c;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);
}

void switchSupervisorToUser() {
    uint64 sysCallCode = 0x50; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = 0;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);
}

void switchUserToSupervisor() {
    uint64 sysCallCode = 0x51; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    arguments.arg1 = 0;
    arguments.arg2 = 0;
    arguments.arg3 = 0;
    arguments.arg4 = 0;
    prepareArgsAndEcall(&arguments);
}