#ifndef BUDDYALLOCATOR_HPP
#define BUDDYALLOCATOR_HPP

#include "../../../lib/hw.h"

class BuddyAllocator {
public:
    static BuddyAllocator& getInstance();

    BuddyAllocator(const BuddyAllocator&) = delete;

    void operator=(const BuddyAllocator&) = delete;

    void setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocks);
private:
    void* firstAlignedAddress;
    int totalNumberOfMemoryBlocks;

    BuddyAllocator() {}

    void setFirstAlignedAddress(void* firstAlignedAddress);

    void setTotalNumberOfMemoryBlocks(int totalNumberOfMemoryBlocks);
};

#endif