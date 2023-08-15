#ifndef MEMORYALLOCATOR_HPP
#define MEMORYALLOCATOR_HPP

#include "../../../lib/hw.h"

class MemoryAllocator {
public:
    static MemoryAllocator& getInstance();

    MemoryAllocator(const MemoryAllocator&) = delete;

    void operator=(const MemoryAllocator&) = delete;

    void* allocateSegment(size_t size);

    int deallocateSegment(void* ptr);
private:
    MemoryAllocator();

    static size_t calculateFirstAlignedAddress();

    static size_t calculateTotalNumberOfMemoryBlocks(MemoryAllocator* memoryAllocator);

    static void initializeFreeSegmentsList(MemoryAllocator* memoryAllocator);

    struct FreeSegment {
        size_t size;
        FreeSegment* next;
        FreeSegment* prev;
    };
    FreeSegment* freeListHead;
    size_t firstAlignedAddress;
    size_t totalNumberOfBlocks;
};

#endif