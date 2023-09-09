#include "../../../h/Code/MemoryAllocator/MemoryAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

MemoryAllocator::MemoryAllocator() {
    firstAlignedAddress = MemoryAllocationHelperFunctions::getFirstAlignedAddressForFirstFitAllocator();
    totalNumberOfBlocks = MemoryAllocationHelperFunctions::getTotalNumberOf8BMemoryBlocksForFirstFitAllocator();
    initializeFreeSegmentsList(this);
}

MemoryAllocator& MemoryAllocator::getInstance() {
    static MemoryAllocator memoryAllocator;
    return memoryAllocator;
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

int MemoryAllocator::deallocateSegment(void* memorySegmentForDealloaction) {
    if (isInvalidMemorySegment(memorySegmentForDealloaction)) {
        return -1;
    }
    auto newFreeSegment = reinterpret_cast<FreeSegment*>(static_cast<char*>(memorySegmentForDealloaction) - MEM_BLOCK_SIZE);
    FreeSegment* previousFreeSegment = findPreviousFreeSegment(static_cast<FreeSegment*>(memorySegmentForDealloaction));
    FreeSegment* nextFreeSegment = previousFreeSegment ? previousFreeSegment->next : freeListHead;
    if (isPreviousFreeSegmentMergeable(previousFreeSegment, newFreeSegment)) {
        return mergeWithPreviousFreeSegment(newFreeSegment, previousFreeSegment);
    }
    if (isNextFreeSegmentMergeable(nextFreeSegment, newFreeSegment)) {
        return mergeWithNextFreeSegment(newFreeSegment, nextFreeSegment);
    }
    return insertAfterPreviousFreeSegment(newFreeSegment, previousFreeSegment);
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

bool MemoryAllocator::isInvalidMemorySegment(void* memorySegmentForDealloaction) {
    bool isMemorySegmentOutOfRange =
            (reinterpret_cast<size_t>(memorySegmentForDealloaction) <= reinterpret_cast<size_t>(HEAP_START_ADDR))
            ||
            (reinterpret_cast<size_t>(memorySegmentForDealloaction) > reinterpret_cast<size_t>(HEAP_END_ADDR) - 1);
    if (!memorySegmentForDealloaction || isMemorySegmentOutOfRange) return true;
    else return false;
}

MemoryAllocator::FreeSegment* MemoryAllocator::findPreviousFreeSegment(FreeSegment* memorySegmentForDealloaction) {
    FreeSegment* previousFreeSegment;
    if (!freeListHead || memorySegmentForDealloaction < freeListHead) {
        previousFreeSegment = nullptr;
    } else {
        for (previousFreeSegment = freeListHead; previousFreeSegment->next && memorySegmentForDealloaction > previousFreeSegment->next; previousFreeSegment = previousFreeSegment->next);
    }
    return previousFreeSegment;
}

bool MemoryAllocator::isPreviousFreeSegmentMergeable(FreeSegment* previousFreeSegment, FreeSegment* newFreeSegment) {
    return previousFreeSegment
        &&
        reinterpret_cast<char*>(previousFreeSegment) + (previousFreeSegment->numberOfBlocks + 1) * MEM_BLOCK_SIZE == reinterpret_cast<char*>(newFreeSegment);
}

bool MemoryAllocator::isNextFreeSegmentMergeable(FreeSegment* nextFreeSegment, FreeSegment* newFreeSegment) {
    return nextFreeSegment
        &&
        reinterpret_cast<char*>(newFreeSegment) + (newFreeSegment->numberOfBlocks + 1) * MEM_BLOCK_SIZE == reinterpret_cast<char*>(nextFreeSegment);
}

int MemoryAllocator::mergeWithNextFreeSegment(FreeSegment* newFreeSegment, FreeSegment* nextFreeSegment) {
    newFreeSegment->numberOfBlocks += nextFreeSegment->numberOfBlocks + 1;
    newFreeSegment->next = nextFreeSegment->next;
    newFreeSegment->prev = nextFreeSegment->prev;
    if (nextFreeSegment->next) nextFreeSegment->next->prev = newFreeSegment;
    if (nextFreeSegment->prev) nextFreeSegment->prev->next = newFreeSegment;
    else freeListHead = newFreeSegment;
    return 0;
}

int MemoryAllocator::mergeWithPreviousFreeSegment(FreeSegment* newFreeSegment, FreeSegment* previousFreeSegment) {
    previousFreeSegment->numberOfBlocks += newFreeSegment->numberOfBlocks + 1;
    if (isNextFreeSegmentMergeable(previousFreeSegment->next, previousFreeSegment)) {
        previousFreeSegment->numberOfBlocks += previousFreeSegment->next->numberOfBlocks + 1;
        previousFreeSegment->next = previousFreeSegment->next->next;
        if (previousFreeSegment->next) previousFreeSegment->next->prev = previousFreeSegment;
    }
    return 0;
}

int MemoryAllocator::insertAfterPreviousFreeSegment(FreeSegment* newFreeSegment, FreeSegment* previousFreeSegment) {
    newFreeSegment->prev = previousFreeSegment;
    if (previousFreeSegment) newFreeSegment->next = previousFreeSegment->next;
    else newFreeSegment->next = freeListHead;
    if (newFreeSegment->next) newFreeSegment->next->prev = newFreeSegment;
    if (previousFreeSegment) previousFreeSegment->next = newFreeSegment;
    else freeListHead = newFreeSegment;
    return 0;
}

size_t MemoryAllocator::getTotalNumberOfFreeBytes() {
    size_t totalNumberOfFreeBytes = 0;
    for (FreeSegment* freeSegment = freeListHead; freeSegment; freeSegment = freeSegment->next) {
        totalNumberOfFreeBytes += freeSegment->numberOfBlocks * MEM_BLOCK_SIZE;
    }
    return totalNumberOfFreeBytes;
}

size_t MemoryAllocator::getNumberOfBytesInLargestFreeSegment() {
    size_t largestNumberOfBytes = 0;
    for (FreeSegment* freeSegment = freeListHead; freeSegment; freeSegment = freeSegment->next) {
        if (freeSegment->numberOfBlocks * MEM_BLOCK_SIZE > largestNumberOfBytes) {
            largestNumberOfBytes = freeSegment->numberOfBlocks * MEM_BLOCK_SIZE;
        }
    }
    return largestNumberOfBytes;
}