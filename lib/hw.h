#pragma once

typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long uint64;

typedef uint64 size_t;
typedef uint64 time_t;

static const size_t DEFAULT_STACK_SIZE = 4096;
static const size_t DEFAULT_TIME_SLICE = 2;

extern const void* HEAP_START_ADDR;
extern const void* HEAP_END_ADDR;

static const size_t MEM_BLOCK_SIZE = 64;

// ovo ispod su adrese registara kontrolera konzole (8 bajtova imaju adrese) - svi registri su velicine jednog bajta
// statusni registar kontrolera konzole
extern const uint64 CONSOLE_STATUS;
// registar kontrolera konzole za slanje podataka
extern const uint64 CONSOLE_TX_DATA;
// registar kontrolera konzole za prijem podataka
extern const uint64 CONSOLE_RX_DATA;

// kod prekida od konzole - ovaj broj ce vratiti kontroler prekida kada se pozove funkcija plic_claim, a u pitanju je prekid od konzole
static const uint64 CONSOLE_IRQ = 10;
// ako je bit na poziciji 5 statusnog registra kontrolera konzole aktivan, to znaci
// da kontroler konzole moze da primi jedan podatak za slanje na konzolu
static const uint64 CONSOLE_TX_STATUS_BIT = 1 << 5;
// ako je bit na poziciji 0 statusnog registra kontrolera konzole aktivan, to znaci
// da se iz kontrolera konzole moze procitati podatak koji je stigao od konzole
static const uint64 CONSOLE_RX_STATUS_BIT = 1;

#ifdef __cplusplus
extern "C" {
#endif

    int plic_claim(void);

    void plic_complete(int irq);

#ifdef __cplusplus
}
#endif
