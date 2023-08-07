#ifndef ABI_H
#define ABI_H

#include "../lib/hw.h"

// u ovu strukturu cu pakovati argumente sistemskih poziva
struct sysCallArgs {
    uint64 arg0;
    uint64 arg1;
    uint64 arg2;
    uint64 arg3;
    uint64 arg4;
};

// ova funkcija je zajednicka za sve sistemske pozive (upisuje parametre sistemskog poziva u registra i izvrsava ecall (softverski prekid))
// ova funkcija zapravo predstavlja ABI interfejs
void prepareArgsAndEcall(sysCallArgs* ptr);

#endif