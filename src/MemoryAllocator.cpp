#include "../h/MemoryAllocator.hpp"

MemoryAllocator& MemoryAllocator::getInstance() {
    static MemoryAllocator memoryAllocator;
    return memoryAllocator;
}

MemoryAllocator::MemoryAllocator() {
    // inicijalno postoji jedan slobodan segment koji je velicine celog heap-a (memorije koja je slobodna za alokaciju)
    // sustina je da pocetna adresa bloka memorije koji se vraca korisniku mora da bude deljiva sa MEM_BLOCK_SIZE
    // pre tog bloka mora postojati struktura za ulancavanje slobodnih segmenata (FreeSegment) i ona ce, iako je velicine 24 bajta
    // a MEM_BLOCK_SIZE je 64 bajta, zauzeti ceo jedan blok velicine MEM_BLOCK_SIZE, posto se korisniku mora vratiti poravnata adresa,
    // a to je onda adresa prvog narednog bloka velicine MEM_BLOCK_SIZE
    size_t firstAlignedAddress =
            reinterpret_cast<size_t>(HEAP_START_ADDR) +
            ((reinterpret_cast<size_t>(HEAP_START_ADDR) % MEM_BLOCK_SIZE) ?
             (MEM_BLOCK_SIZE - (reinterpret_cast<size_t>(HEAP_START_ADDR)) % MEM_BLOCK_SIZE): 0);
    // koristio sam iznad reinterpret_cast jer sam konvertovao pokazivac u ceo broj, a ispod jer sam konvertovao ceo broj u pokazivac
    freeListHead = reinterpret_cast<FreeSegment*>(firstAlignedAddress);
    freeListHead->next = nullptr;
    freeListHead->prev = nullptr;
    // na pocetku taj jedan veliki slobodan segment ima freeListHead->size blokova velicine MEM_BLOCK_SIZE
    totalNumberOfBlocks = (reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 - firstAlignedAddress) / MEM_BLOCK_SIZE;
    freeListHead->size = totalNumberOfBlocks;
}

void* MemoryAllocator::allocateSegment(size_t size) { // parametar size je broj blokova velicine MEM_BLOCK_SIZE koje je korisnik trazio
    if (size >= totalNumberOfBlocks) return nullptr; // ako je zatrazeno vise blokova memorije nego sto ukupno ima na raspolaganju
    for (FreeSegment* curr = freeListHead; curr; curr = curr->next) {
            // poredim curr->size - 1 sa size jer je u curr->size uracunat i blok u kom je struktura za ulancavanje, a njega korisnik
            // ne sme da koristi za svoje potrebe jer bi nam tako narusio strukturu i izgubili bismo informaciju o velicini bloka
            // memorije koju je korisnik alocirao
        if ((curr->size - 1) - size <= 1) {
            // slucaj kada je preostali fragment suvise mali (1 blok velicine MEM_BLOCK_SIZE) da bi se evidentirao kao slobodan (tada ga
            // ne umecemo u listu slodobnih segmenata); fragment mora imati najmanje dva bloka velicine MEM_BLOCK_SIZE jer je potreban
            // jedan ceo blok samo za strukturu za ulancavanje, pa ce onda u tom slucaju korisnik na raspolaganju imati jedan blok
            if (curr->prev) curr->prev->next = curr->next;
            else freeListHead = curr->next;
            if (curr->next) curr->next->prev = curr->prev;
            // velicina bloka memorije koju je korisnik trazio (size + 1 jer racunam i blok za strukturu za ulancavanje)
            curr->size = size + 1;
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
        } else if (curr->size > size && (curr->size - 1) - size >= 2) {
            // slucaj kada preostali fragment ima smisla evidentirati kao slobodan (tada ga umecemo u listu slobodnih fragmenata)
            // preskacemo memoriju i strukturu za ulancavanje koju cemo vratiti korisniku (zato size + 1) da bismo dosli do pocetka
            // novog slobodnog fragmenta koji cemo sada da umetnemo u listu slobodnih segmenata
            auto newFreeFragment = (FreeSegment*)(reinterpret_cast<char*>(curr) + (size + 1) * MEM_BLOCK_SIZE);
            if (curr->prev) curr->prev->next = newFreeFragment;
            else freeListHead = newFreeFragment;
            if (curr->next) curr->next->prev = newFreeFragment;
            newFreeFragment->prev = curr->prev;
            newFreeFragment->next = curr->next;
            newFreeFragment->size = curr->size - (size + 1);
            // velicina bloka memorije koju je korisnik trazio (size + 1 jer racunam i blok za strukturu za ulancavanje)
            curr->size = size + 1;
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
        }
    }
    return nullptr;
}

// parametar ptr je pokazivac na memoriju koju korisnik zeli da oslobodi; static_cast<char*>(ptr) - MEM_BLOCK_SIZE je adresa pocetka
// strukture za ulancavanje od segmenta memorije koju korisnik zeli da oslobodi
int MemoryAllocator::deallocateSegment(void *ptr) {
    if (!ptr || !(
        reinterpret_cast<size_t>(HEAP_START_ADDR) <= reinterpret_cast<size_t>(ptr) &&
        reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 >= reinterpret_cast<size_t>(ptr))) return -1;
    // postavljam ptr da pokazuje na pocetak strukture za ulancavanje segmenta memorije koji treba osloboditi
    ptr = static_cast<char*>(ptr) - MEM_BLOCK_SIZE;
    // nalazenje mesta gde treba umetnuti novi slobodan segment (to je segment na koji pokazuje pokazivac ptr)
    FreeSegment* curr;
    if (!freeListHead || static_cast<FreeSegment*>(ptr) < freeListHead) {
        // novi slobodan segment treba umetnuti na pocetak liste slobodnih segmenata
        curr = nullptr;
    } else {
        // nalazenje mesta (to ce biti odmah nakon curr) gde treba umetnuti novi slobodan segment
        for (curr = freeListHead; curr->next && static_cast<FreeSegment*>(ptr) > curr->next; curr = curr->next);
    }
    // pokusaj spajanja novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (curr)
    if (curr && reinterpret_cast<char*>(curr) + curr->size * MEM_BLOCK_SIZE == static_cast<char*>(ptr)) {
        // spajanje novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (curr)
        curr->size += (static_cast<FreeSegment*>(ptr))->size;
        // pokusaj spajanja slobodnog segmenta (curr) sa narednim slobodnim segmentom (curr->next)
        if (curr->next && reinterpret_cast<char*>(curr) + curr->size * MEM_BLOCK_SIZE == reinterpret_cast<char*>(curr->next)) {
            // spajanje slobodnog segmenta (curr) sa narednim slobodnim segmentom (curr->next)
            curr->size += curr->next->size;
            // uklanjanje segmenta curr->next iz liste slobodnih segmenata
            curr->next = curr->next->next;
            if (curr->next) curr->next->prev = curr;
        }
        return 0;
    } else {
        // pokusaj spajanja novog slobodnog segmenta (ptr) sa sledecim slobodnim segmentom (nextFreeSegment)
        FreeSegment* nextFreeSegment = curr ? curr->next : freeListHead;
        if (nextFreeSegment &&
        static_cast<char*>(ptr) + (static_cast<FreeSegment*>(ptr))->size * MEM_BLOCK_SIZE == reinterpret_cast<char*>(nextFreeSegment)) {
            // spajanje novog slobodnog segmenta (ptr) sa sledecim slobodnim segmentom (nextFreeSegment) - izbacuje se nextFreeSegment iz liste
            auto newFreeSegment = static_cast<FreeSegment*>(ptr);
            newFreeSegment->size += nextFreeSegment->size;
            newFreeSegment->prev = nextFreeSegment->prev;
            newFreeSegment->next = nextFreeSegment->next;
            if (nextFreeSegment->next) nextFreeSegment->next->prev = newFreeSegment;
            if (nextFreeSegment->prev) nextFreeSegment->prev->next = newFreeSegment;
            else freeListHead = newFreeSegment;
            return 0;
        } else {
            // ova grana se izvrsava ako nema potrebe za bilo kakvim spajanjem slobodnih segmenata - jednostavno se
            // umece novi slobodni segment (ptr) nakon prethodnog slobodnog segmenta (curr)
            auto newFreeSegment = static_cast<FreeSegment*>(ptr);
            newFreeSegment->prev = curr;
            if (curr) newFreeSegment->next = curr->next;
            else newFreeSegment->next = freeListHead;
            if (newFreeSegment->next) newFreeSegment->next->prev = newFreeSegment;
            if (curr) curr->next = newFreeSegment;
            else freeListHead = newFreeSegment;
            return 0;
        }
    }
}
