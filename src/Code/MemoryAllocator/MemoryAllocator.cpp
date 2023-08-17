#include "../../../h/Code/MemoryAllocator/MemoryAllocator.hpp"

MemoryAllocator& MemoryAllocator::getInstance() {
    static MemoryAllocator memoryAllocator;
    return memoryAllocator;
}

MemoryAllocator::MemoryAllocator() {
    firstAlignedAddress = calculateFirstAlignedAddress();
    totalNumberOfBlocks = calculateTotalNumberOfMemoryBlocks(this);
    initializeFreeSegmentsList(this);
}

void* MemoryAllocator::allocateSegment(size_t numberOfRequestedBlocks) {
    if (numberOfRequestedBlocks >= totalNumberOfBlocks) return nullptr;
    for (FreeSegment* freeSegment = freeListHead; freeSegment; freeSegment = freeSegment->next) {
        bool isFreeSegmentEnough = freeSegment->numberOfBlocks >= numberOfRequestedBlocks;
        bool isRemainingFragmentUsable = freeSegment->numberOfBlocks - numberOfRequestedBlocks >= 2;
        if (isFreeSegmentEnough) {
            char* allocatedSegment = reinterpret_cast<char*>(freeSegment) + MEM_BLOCK_SIZE;
            if (isRemainingFragmentUsable) {
                addRemainingFragmentToFreeSegmentsList(freeSegment, numberOfRequestedBlocks);
            } else {
                removeFromFreeSegmentsList(freeSegment, numberOfRequestedBlocks);
            }
            return allocatedSegment;
        }
    }
    return nullptr;
}

size_t MemoryAllocator::calculateFirstAlignedAddress() {
    auto heapStartAddress = reinterpret_cast<size_t>(HEAP_START_ADDR);
    bool isHeapStartAddressAligned = heapStartAddress % MEM_BLOCK_SIZE == 0;
    size_t offsetForAlignment = isHeapStartAddressAligned ? 0 : (MEM_BLOCK_SIZE - heapStartAddress % MEM_BLOCK_SIZE);
    return heapStartAddress + offsetForAlignment;
}

size_t MemoryAllocator::calculateTotalNumberOfMemoryBlocks(MemoryAllocator* memoryAllocator) {
    size_t lastAvailableAddress = reinterpret_cast<size_t>(HEAP_END_ADDR) - 1;
    return (lastAvailableAddress - memoryAllocator->firstAlignedAddress) / MEM_BLOCK_SIZE;
}

void MemoryAllocator::initializeFreeSegmentsList(MemoryAllocator* memoryAllocator) {
    memoryAllocator->freeListHead = reinterpret_cast<FreeSegment*>(memoryAllocator->firstAlignedAddress);
    memoryAllocator->freeListHead->numberOfBlocks = memoryAllocator->totalNumberOfBlocks - 1;
    memoryAllocator->freeListHead->next = nullptr;
    memoryAllocator->freeListHead->prev = nullptr;
}

void MemoryAllocator::removeFromFreeSegmentsList(FreeSegment* freeSegment, size_t numberOfRequestedBlocks) {
    if (freeSegment->prev) freeSegment->prev->next = freeSegment->next;
    else freeListHead = freeSegment->next;
    if (freeSegment->next) freeSegment->next->prev = freeSegment->prev;
    freeSegment->numberOfBlocks = numberOfRequestedBlocks + 1;
}

void MemoryAllocator::addRemainingFragmentToFreeSegmentsList(FreeSegment* freeSegment, size_t numberOfRequestedBlocks) {
    auto remainingFragment = (FreeSegment*)(reinterpret_cast<char*>(freeSegment) + (numberOfRequestedBlocks + 1) * MEM_BLOCK_SIZE);
    if (freeSegment->prev) freeSegment->prev->next = remainingFragment;
    else freeListHead = remainingFragment;
    if (freeSegment->next) freeSegment->next->prev = remainingFragment;
    remainingFragment->prev = freeSegment->prev;
    remainingFragment->next = freeSegment->next;
    remainingFragment->numberOfBlocks = freeSegment->numberOfBlocks - (numberOfRequestedBlocks + 1) - 1;
    freeSegment->numberOfBlocks = numberOfRequestedBlocks + 1;
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
    FreeSegment* freeSegment;
    if (!freeListHead || static_cast<FreeSegment*>(ptr) < freeListHead) {
        // novi slobodan segment treba umetnuti na pocetak liste slobodnih segmenata
        freeSegment = nullptr;
    } else {
        // nalazenje mesta (to ce biti odmah nakon freeSegment) gde treba umetnuti novi slobodan segment
        for (freeSegment = freeListHead; freeSegment->next && static_cast<FreeSegment*>(ptr) > freeSegment->next; freeSegment = freeSegment->next);
    }
    // pokusaj spajanja novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (freeSegment)
    if (freeSegment && reinterpret_cast<char*>(freeSegment) + (freeSegment->numberOfBlocks + 1) * MEM_BLOCK_SIZE == static_cast<char*>(ptr)) {
        // spajanje novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (freeSegment)
        freeSegment->numberOfBlocks += (static_cast<FreeSegment*>(ptr))->numberOfBlocks + 1;
        // pokusaj spajanja slobodnog segmenta (freeSegment) sa narednim slobodnim segmentom (freeSegment->next)
        if (freeSegment->next && reinterpret_cast<char*>(freeSegment) + (freeSegment->numberOfBlocks + 1) * MEM_BLOCK_SIZE == reinterpret_cast<char*>(freeSegment->next)) {
            // spajanje slobodnog segmenta (freeSegment) sa narednim slobodnim segmentom (freeSegment->next)
            freeSegment->numberOfBlocks += freeSegment->next->numberOfBlocks + 1;
            // uklanjanje segmenta freeSegment->next iz liste slobodnih segmenata
            freeSegment->next = freeSegment->next->next;
            if (freeSegment->next) freeSegment->next->prev = freeSegment;
        }
        return 0;
    } else {
        // pokusaj spajanja novog slobodnog segmenta (ptr) sa sledecim slobodnim segmentom (nextFreeSegment)
        FreeSegment* nextFreeSegment = freeSegment ? freeSegment->next : freeListHead;
        if (nextFreeSegment &&
        static_cast<char*>(ptr) + ((static_cast<FreeSegment*>(ptr))->numberOfBlocks + 1) * MEM_BLOCK_SIZE == reinterpret_cast<char*>(nextFreeSegment)) {
            // spajanje novog slobodnog segmenta (ptr) sa sledecim slobodnim segmentom (nextFreeSegment) - izbacuje se nextFreeSegment iz liste
            auto newFreeSegment = static_cast<FreeSegment*>(ptr);
            newFreeSegment->numberOfBlocks += nextFreeSegment->numberOfBlocks + 1;
            newFreeSegment->prev = nextFreeSegment->prev;
            newFreeSegment->next = nextFreeSegment->next;
            if (nextFreeSegment->next) nextFreeSegment->next->prev = newFreeSegment;
            if (nextFreeSegment->prev) nextFreeSegment->prev->next = newFreeSegment;
            else freeListHead = newFreeSegment;
            return 0;
        } else {
            // ova grana se izvrsava ako nema potrebe za bilo kakvim spajanjem slobodnih segmenata - jednostavno se
            // umece novi slobodni segment (ptr) nakon prethodnog slobodnog segmenta (freeSegment)
            auto newFreeSegment = static_cast<FreeSegment*>(ptr);
            newFreeSegment->prev = freeSegment;
            if (freeSegment) newFreeSegment->next = freeSegment->next;
            else newFreeSegment->next = freeListHead;
            if (newFreeSegment->next) newFreeSegment->next->prev = newFreeSegment;
            if (freeSegment) freeSegment->next = newFreeSegment;
            else freeListHead = newFreeSegment;
            return 0;
        }
    }
}
