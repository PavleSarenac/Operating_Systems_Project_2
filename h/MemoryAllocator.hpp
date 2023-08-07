#ifndef MEMORYALLOCATOR_HPP
#define MEMORYALLOCATOR_HPP

#include "../lib/hw.h"

/*
 * MemoryAllocator sam dizajnirao kao singleton klasu, tj. obezbedio sam da moze da se napravi
 * samo jedan objekat ove klase
 */
class MemoryAllocator {
public:
    static MemoryAllocator& getInstance();

    MemoryAllocator(const MemoryAllocator&) = delete;

    void operator=(const MemoryAllocator&) = delete;

    void* allocateSegment(size_t size);

    int deallocateSegment(void* ptr);
private:
    MemoryAllocator();
    // struktura za ulancavanje slobodnih segmenata - ona ce uvek zauzeti jedan ceo blok velicine MEM_BLOCK_SIZE jer memorija koja
    // se vraca korisniku na koriscenje mora pocinjati na adresi deljivoj sa MEM_BLOCK_SIZE (poravnata adresa)
    struct FreeSegment {
        // broj blokova velicine MEM_BLOCK_SIZE koji sadrzi tekuci slobodan segment (ukljucujuci i blok u kom je struktura za ulancavanje)
        size_t size;
        FreeSegment* next;
        FreeSegment* prev;
    };
    FreeSegment* freeListHead;
    size_t totalNumberOfBlocks;
};

#endif