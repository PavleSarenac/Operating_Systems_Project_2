#ifndef BUDDYALLOCATOR_HPP
#define BUDDYALLOCATOR_HPP

#include "../../../lib/hw.h"
#include "../../Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

class BuddyAllocator {
public:
    static const int MAX_EXPONENT = 14;
    static const int MAX_NUMBER_OF_BLOCKS_OF_SAME_SIZE = 1 << 14;

    static BuddyAllocator& getInstance();
    BuddyAllocator(const BuddyAllocator&) = delete;
    void operator=(const BuddyAllocator&) = delete;
    void setup(void* firstAlignedAddress, int totalNumberOfBlocks);
    void* allocate(int numberOfBytes);
private:
    int numberOfBlocksOfSameSize[MAX_EXPONENT + 1];
    bool isBlockFree[MAX_EXPONENT + 1][MAX_NUMBER_OF_BLOCKS_OF_SAME_SIZE];
    void* firstAlignedAddress;
    int maxUsedExponent, maxUsedNumberOfBlocksOfSameSize;

    BuddyAllocator();
    static int getExponentForNumberOfBlocks(int numberOfBlocks);
    static int getExponentForNumberOfBytes(int numberOfBytes);
    int getFreeBlockIndex(int exponent) const;
    void* getBlockAddress(int exponent, int blockIndex) const;

    friend class BuddyAllocatorTest;
};

#endif