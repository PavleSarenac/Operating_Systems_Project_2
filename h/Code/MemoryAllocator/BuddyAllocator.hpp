#ifndef BUDDYALLOCATOR_HPP
#define BUDDYALLOCATOR_HPP

#include "../../../lib/hw.h"

class BuddyAllocator {
public:
    static BuddyAllocator& getInstance();

    BuddyAllocator(const BuddyAllocator&) = delete;

    void operator=(const BuddyAllocator&) = delete;

    void setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocksForSlabAllocation);
private:
    void* firstAlignedAddress;
    int totalNumberOfMemoryBlocksForSlabAllocation;

    BuddyAllocator() {}

    void setFirstAlignedAddress(void* firstAlignedAddress);

    void setTotalNumberOfMemoryBlocksForSlabAllocation(int totalNumberOfMemoryBlocksForSlabAllocation);
};

#endif