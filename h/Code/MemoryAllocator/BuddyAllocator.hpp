#ifndef BUDDYALLOCATOR_HPP
#define BUDDYALLOCATOR_HPP

#include "../../../lib/hw.h"

class BuddyAllocator {
public:
    static const int MAX_EXPONENT = 14;
    static const int MAX_NUMBER_OF_BLOCKS_OF_SAME_SIZE = 1 << 14;

    static BuddyAllocator& getInstance();
    BuddyAllocator(const BuddyAllocator&) = delete;
    void operator=(const BuddyAllocator&) = delete;
    void setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocks);
private:
    int numberOfBlocksOfSameSize[MAX_EXPONENT + 1];
    bool isBlockFree[MAX_EXPONENT + 1][MAX_NUMBER_OF_BLOCKS_OF_SAME_SIZE];

    void* firstAlignedAddress;
    int maxUsedExponent;
    int maxUsedNumberOfBlocksOfSameSize;

    BuddyAllocator();
    static int getMaxUsedExponent(int totalNumberOfMemoryBlocks);
};

#endif