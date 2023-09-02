#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

BuddyAllocator::BuddyAllocator() {
    for (int i = MAX_EXPONENT, numberOfBlocks = 1; i >= 0; i--, numberOfBlocks <<= 1) {
        numberOfBlocksOfSameSize[i] = numberOfBlocks;
        for (int j = 0; j < MAX_NUMBER_OF_BLOCKS_OF_SAME_SIZE; j++) {
            isBlockFree[i][j] = false;
        }
    }
    isBlockFree[MAX_EXPONENT][0] = true;
}

BuddyAllocator& BuddyAllocator::getInstance() {
    static BuddyAllocator buddyAllocator;
    return buddyAllocator;
}

void BuddyAllocator::setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocks) {
    this->firstAlignedAddress = firstAlignedAddress;
    this->maxUsedExponent = getMaxUsedExponent(totalNumberOfMemoryBlocks);
    this->maxUsedNumberOfBlocksOfSameSize = 1 << this->maxUsedExponent;
}

int BuddyAllocator::getMaxUsedExponent(int totalNumberOfMemoryBlocks) {
    int maxUsedExponent = 0;
    for (int i = 0; totalNumberOfMemoryBlocks; i++) {
        if (i > 0) maxUsedExponent++;
        totalNumberOfMemoryBlocks >>= 1;
    }
    return maxUsedExponent;
}