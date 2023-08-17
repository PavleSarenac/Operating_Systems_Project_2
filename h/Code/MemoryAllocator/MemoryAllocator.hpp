#ifndef MEMORYALLOCATOR_HPP
#define MEMORYALLOCATOR_HPP

#include "../../../lib/hw.h"

class MemoryAllocator {
public:
    static MemoryAllocator& getInstance();

    MemoryAllocator(const MemoryAllocator&) = delete;

    void operator=(const MemoryAllocator&) = delete;

    void* allocateSegment(size_t numberOfRequestedBlocks);

    int deallocateSegment(void* ptr);
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

    static size_t calculateFirstAlignedAddress();

    static size_t calculateTotalNumberOfMemoryBlocks(MemoryAllocator* memoryAllocator);

    static void initializeFreeSegmentsList(MemoryAllocator* memoryAllocator);

    void removeFromFreeSegmentsList(FreeSegment* freeSegment, size_t numberOfRequestedBlocks);

    void addRemainingFragmentToFreeSegmentsList(FreeSegment* freeSegment, size_t numberOfRequestedBlocks);
};

#endif