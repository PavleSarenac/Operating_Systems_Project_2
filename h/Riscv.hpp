#ifndef RISCV_HPP
#define RISCV_HPP

#include "../lib/hw.h"

class Riscv {
public:
    // prekidna rutina (definisana u assembly fajlu supervisorTrap.S; ignorisati upozorenje CLiona da f-ja nije definisana)
    static void supervisorTrap();

    // definisana u registersStack.S; ova metoda treba da sacuva registre a0-a7 na steku (preko ovih registara se prenose parametri sistemskih poziva)
    static void pushSysCallParameters();

    // definisana u registersStack.S; ova metoda treba da sacuva registre x3..x31 na steku
    static void pushMostRegisters();

    // definisana u registersStack.S; ova metoda treba da restaurira registre x3..x31 sa steka
    static void popMostRegisters();

    static void exitSupervisorTrap();

    // procitaj vrednost iz statusnog registra sstatus (ovaj registar pamti trenutno stanje procesora)
    static uint64 readSstatus();

    // upisi vrednost u statusni registar sstatus
    static void writeSstatus(uint64 sstatus);

    // pod spoljasnjim prekidima se podrazumevaju prekidi od tajmera i spoljasnji hardverski prekidi;
    // u korisnickom rezimu bit SIE sstatus registra se ignorise - spoljasnji prekidi su tada podrazumevano dozvoljeni;
    enum BitMaskSstatus {
        SSTATUS_SIE = (1 << 1), // ovaj bit govori da li su dozvoljeni spoljasnji prekidi (0 - nisu, 1 - jesu); u korisnickom rezimu ovaj bit se ignorise jer su prekidi tu podrazumevano dozvoljeni
        SSTATUS_SPIE = (1 << 5), // ovaj bit govori koja je bila prethodna vrednost bita SIE (pre skoka u prekidnu rutinu)
        SSTATUS_SPP = (1 << 8) // ovaj bit govori iz kog rezima se skocilo na prekidnu rutinu (0 - korisnicki, 1 - sistemski)
    };

    // postavi odgovarajuce bite u registru sstatus na 1 (odgovarajuca maska se prosledjuje kao argument funkciji)
    static void maskSetBitsSstatus(uint64 mask);

    // postavi odgovarajuce bite u registru sstatus na 0 (odgovarajuca maska se prosledjuje kao argument funkciji)
    static void maskClearBitsSstatus(uint64 mask);

    // procitaj vrednost iz registra sip (ovaj registar pamti koji zahtevi za prekid su trenutno aktivni)
    static uint64 readSip();

    // upisi vrednost u registar sip
    static void writeSip(uint64 sip);

    enum BitMaskSip {
        SIP_SSIP = (1 << 1), // ovaj bit govori da li je aktivan zahtev za softverski prekid (0 - nije, 1 - jeste)
        SIP_SEIP = (1 << 9) // ovaj bit govori da li je aktivan zahtev za spoljasnji hardverski prekid (0 - nije, 1 - jeste)
    };

    // postavi odgovarajuce bite u registru sip na 1 (odgovarajuca maska se prosledjuje kao argument funkciji)
    static void maskSetBitsSip(uint64 mask);

    // postavi odgovarajuce bite u registru sip na 0 (odgovarajuca maska se prosledjuje kao argument funkciji)
    static void maskClearBitsSip(uint64 mask);

    // procitaj vrednost iz registra sie (ovaj registar pamti koji prekidi su trenutno dozvoljeni)
    static uint64 readSie();

    // upisi vrednost u registar sie
    static void writeSie(uint64 sie);

    // vrednost registra sie se uzima u obzir prilikom izvrsavanja u korisnickom rezimu;
    // ako se program izvrsava u sistemskom rezimu i bit SIE sstatus registra je nula, vrednost sie registra se ignorise;
    enum BitMaskSie {
        SIE_SSIE = (1 << 1), // ovaj bit govori da li su dozvoljeni softverski prekidi (0 - nisu, 1 - jesu)
        SIE_SEIE = (1 << 9) // ovaj bit govori da li su dozvoljeni spoljasnji hardverski prekidi (0 - nisu, 1 - jesu)
    };

    // postavi odgovarajuce bite u registru sie na 1 (odgovarajuca maska se prosledjuje kao argument funkciji)
    static void maskSetBitsSie(uint64 mask);

    // postavi odgovarajuce bite u registru sie na 0 (odgovarajuca maska se prosledjuje kao argument funkciji)
    static void maskClearBitsSie(uint64 mask);

    // procitaj vrednost iz registra scratch (ovaj registar sluzi za cuvanje privremenih vrednosti)
    static uint64 readScratch();

    // upisi vrednost u registar scratch
    static void writeScratch(uint64 scratch);

    // procitaj vrednost iz registra sepc (ovaj registar cuva vrednost registra pc iz korisnickog rezima;
    // to ce biti adresa instrukcije ecall ili adresa prve neizvrsene/prekinute instrukcije)
    static uint64 readSepc();

    // upisi vrednost u registar sepc
    static void writeSepc(uint64 sepc);

    // procitaj vrednost iz registra scause (ovaj registar cuva razlog prelaska u sistemski rezim)
    static uint64 readScause();

    // upisi vrednost u registar scause
    static void writeScause(uint64 scause);

    // procitaj vrednost iz registra stvec (ovaj registar cuva adresu prekidne rutine)
    static uint64 readStvec();

    // upisi vrednost u registar stvec
    static void writeStvec(uint64 stvec);

    // procitaj vrednost iz registra stval (ovaj registar cuva dodatan opis greske koja se dogodila)
    static uint64 readStval();

    // upisi vrednost u registar stval
    static void writeStval(uint64 stval);

private:
    // obrada sistemskog poziva/prekida/izuzetka
    static void handleSupervisorTrap();
};

// ove metode pisem kao inline da ne bi bilo rezijskih troskova koje iziskuje poziv funkcije (prenos argumenata, skok na adresu
// funkcije, cuvanje povratne adrese)- ovako ce kod tela funkcije samo da se ugradi na mesto poziva i tako prevede, bez standardnog
// poziva funkcije
inline uint64 Riscv::readSstatus() {
    // volatile kvalifikator obezbedjuje da prevodilac ne izvrsi optimizaciju i sacuva lokalnu promenljivu u nekom od opstenamenskih
    // registara - umesto toga, sacuvace je na steku
    uint64 volatile sstatus;
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    return sstatus;
}

inline void Riscv::writeSstatus(uint64 sstatus) {
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
}

inline void Riscv::maskSetBitsSstatus(uint64 mask) {
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}

inline void Riscv::maskClearBitsSstatus(uint64 mask) {
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
}

inline uint64 Riscv::readSip() {
    uint64 volatile sip;
    __asm__ volatile ("csrr %[sip], sip" : [sip] "=r"(sip));
    return sip;
}

inline void Riscv::writeSip(uint64 sip) {
    __asm__ volatile ("csrw sip, %[sip]" : : [sip] "r"(sip));
}

inline void Riscv::maskSetBitsSip(uint64 mask) {
    __asm__ volatile ("csrs sip, %[mask]" : : [mask] "r"(mask));
}

inline void Riscv::maskClearBitsSip(uint64 mask) {
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
}

inline uint64 Riscv::readSie() {
    uint64 volatile sie;
    __asm__ volatile ("csrr %[sie], sie" : [sie] "=r"(sie));
    return sie;
}

inline void Riscv::writeSie(uint64 sie) {
    __asm__ volatile ("csrw sie, %[sie]" : : [sie] "r"(sie));
}

inline void Riscv::maskSetBitsSie(uint64 mask) {
    __asm__ volatile ("csrs sie, %[mask]" : : [mask] "r"(mask));
}

inline void Riscv::maskClearBitsSie(uint64 mask) {
    __asm__ volatile ("csrc sie, %[mask]" : : [mask] "r"(mask));
}

inline uint64 Riscv::readScratch() {
    uint64 volatile scratch;
    __asm__ volatile ("csrr %[scratch], scratch" : [scratch] "=r"(scratch));
    return scratch;
}

inline void Riscv::writeScratch(uint64 scratch) {
    __asm__ volatile ("csrw scratch, %[scratch]" : : [scratch] "r"(scratch));
}

inline uint64 Riscv::readSepc() {
    uint64 volatile sepc;
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    return sepc;
}

inline void Riscv::writeSepc(uint64 sepc) {
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
}

inline uint64 Riscv::readScause() {
    uint64 volatile scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    return scause;
}

inline void Riscv::writeScause(uint64 scause) {
    __asm__ volatile ("csrw scause, %[scause]" : : [scause] "r"(scause));
}

inline uint64 Riscv::readStvec() {
    uint64 volatile stvec;
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    return stvec;
}

inline void Riscv::writeStvec(uint64 stvec) {
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
}

inline uint64 Riscv::readStval() {
    uint64 volatile stval;
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    return stval;
}

inline void Riscv::writeStval(uint64 stval) {
    __asm__ volatile ("csrw stval, %[stval]" : : [stval] "r"(stval));
}

#endif