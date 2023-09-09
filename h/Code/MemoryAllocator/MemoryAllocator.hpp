#ifndef MEMORYALLOCATOR_HPP
#define MEMORYALLOCATOR_HPP

#include "../../../lib/hw.h"

class MemoryAllocator {
public:
    static MemoryAllocator& getInstance();
    MemoryAllocator(const MemoryAllocator&) = delete;
    void operator=(const MemoryAllocator&) = delete;
    void* allocateSegment(size_t numberOfRequestedBlocks);
    int deallocateSegment(void* memorySegmentForDealloaction);
    size_t getTotalNumberOfFreeBytes();
    size_t getNumberOfBytesInLargestFreeSegment();
private:
    typedef struct FreeSegment {
        size_t numberOfBlocks;
        FreeSegment* next;
        FreeSegment* prev;
    } FreeSegment;

    FreeSegment* freeListHead;
    size_t firstAlignedAddress;
    size_t totalNumberOfBlocks;

    MemoryAllocator();
    static void initializeFreeSegmentsList(MemoryAllocator* memoryAllocator);
    void removeFromFreeSegmentsList(FreeSegment* freeSegment, size_t numberOfRequestedBlocks);
    void addRemainingFragmentToFreeSegmentsList(FreeSegment* freeSegment, size_t numberOfRequestedBlocks);
    static bool isInvalidMemorySegment(void* memorySegmentForDealloaction);
    FreeSegment* findPreviousFreeSegment(FreeSegment* memorySegmentForDealloaction);
    static bool isPreviousFreeSegmentMergeable(FreeSegment* previousFreeSegment, FreeSegment* newFreeSegment);
    static bool isNextFreeSegmentMergeable(FreeSegment* nextFreeSegment, FreeSegment* newFreeSegment);
    int mergeWithNextFreeSegment(FreeSegment* newFreeSegment, FreeSegment* nextFreeSegment);
    static int mergeWithPreviousFreeSegment(FreeSegment* newFreeSegment, FreeSegment* previousFreeSegment);
    int insertAfterPreviousFreeSegment(FreeSegment* newFreeSegment, FreeSegment* previousFreeSegment);
};

#endif