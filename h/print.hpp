#ifndef PRINT_HPP
#define PRINT_HPP

#include "../lib/hw.h"

// funkcija za ispis greske iz koja ce se pozivati u prekidnoj rutini za unutrasnje prekide koji signaliziraju gresku (svi sem ecall)
extern void printErrorMessage(uint64 scause, uint64 stval, uint64 sepc);

#endif