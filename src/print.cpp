#include "../h/print.hpp"
#include "../h/Riscv.hpp"
#include "../h/Z_Njihovo_Printing.hpp"

void printErrorMessage(uint64 scause, uint64 stval, uint64 sepc) {
    uint64 sstatus = Riscv::readSstatus();
    Riscv::maskClearBitsSstatus(Riscv::SSTATUS_SIE); // zabrana spoljasnjih prekida (softverskih prekida od tajmera i spoljasnjih hardverskih prekida)
    printString("unutrasnji prekid ");
    switch (scause) {
        case 0x0000000000000002UL:
            printString("(ilegalna instrukcija)\n");
            break;
        case 0x0000000000000005UL:
            printString("(nedozvoljena adresa citanja)\n");
            break;
        case 0x0000000000000007UL:
            printString("(nedozvoljena adresa upisa)\n");
            break;
    }
    printString("scause (opis prekida): "); printInt(scause);
    printString("; sepc (adresa prekinute instrukcije): "); printInt(sepc);
    printString("; stval (dodatan opis izuzetka): "); printInt(stval);
    printString("\n\n");
    Riscv::writeSstatus(sstatus); // restauracija inicijalnog sstatus registra
}