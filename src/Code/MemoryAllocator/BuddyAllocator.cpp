#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

BuddyAllocator::BuddyAllocator() {}

BuddyAllocator& BuddyAllocator::getInstance() {
    static BuddyAllocator buddyAllocator;
    return buddyAllocator;
}

void BuddyAllocator::setup(void* firstAlignedAddress, int totalNumberOfBlocks) {
    if (totalNumberOfBlocks > static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocksForBuddyAllocator()))
        return;
    this->firstAlignedAddress = firstAlignedAddress;
    this->maxUsedExponent = getExponentForNumberOfBlocks(totalNumberOfBlocks);
    this->maxUsedNumberOfBlocksOfSameSize = 1 << this->maxUsedExponent;
    for (int i = maxUsedExponent, numberOfBlocks = 1; i >= 0; i--, numberOfBlocks <<= 1) {
        numberOfBlocksOfSameSize[i] = numberOfBlocks;
        for (int j = 0; j < numberOfBlocks; j++) {
            isBlockFree[i][j] = false;
        }
    }
    isBlockFree[this->maxUsedExponent][0] = true;
}

void* BuddyAllocator::allocate(int numberOfBytes) {
    if (numberOfBytes == 0) return nullptr;
    int minNeededExponent = getExponentForNumberOfBytes(numberOfBytes);
    int currentExponent = minNeededExponent;
    int freeBlockIndex = -1;
    while (currentExponent <= maxUsedExponent) {
        freeBlockIndex = getFreeBlockIndex(currentExponent);
        if (freeBlockIndex >= 0) break;
        currentExponent++;
    }
    if (freeBlockIndex == -1) return nullptr;
    isBlockFree[currentExponent][freeBlockIndex] = false;
    while (--currentExponent >= minNeededExponent) {
        freeBlockIndex <<= 1;
        isBlockFree[currentExponent][freeBlockIndex + 1] = true;
    }
    return getBlockAddress(minNeededExponent, freeBlockIndex);
}

void BuddyAllocator::deallocate(void* blockForDeallocation, size_t numberOfBytes) {
    int exponent = getExponentForNumberOfBytes(numberOfBytes);
    int blockIndex = getBlockIndexFromAddress(blockForDeallocation, exponent);
    while (exponent < maxUsedExponent) {
        int buddyIndex = blockIndex % 2 ? blockIndex - 1 : blockIndex + 1;
        if (!isBlockFree[exponent][buddyIndex]) {
            isBlockFree[exponent][blockIndex] = true;
            return;
        }
        isBlockFree[exponent][buddyIndex] = false;
        blockIndex >>= 1;
        exponent++;
    }
    isBlockFree[exponent][blockIndex] = true;
}

int BuddyAllocator::getExponentForNumberOfBlocks(int numberOfBlocks) {
    if (numberOfBlocks == 0) return 0;
    int exponent = 0, numberOfAllocatedBlocks = 1;
    while (numberOfAllocatedBlocks < numberOfBlocks) {
        numberOfAllocatedBlocks <<= 1;
        exponent++;
    }
    return exponent;
}

int BuddyAllocator::getExponentForNumberOfBytes(int numberOfBytes) {
    int numberOfBlocks = numberOfBytes / BLOCK_SIZE + ((numberOfBytes % BLOCK_SIZE != 0) ? 1 : 0);
    return getExponentForNumberOfBlocks(numberOfBlocks);
}

int BuddyAllocator::getFreeBlockIndex(int exponent) const {
    if (exponent < 0 || exponent > maxUsedExponent) return - 1;
    for (int i = 0; i < numberOfBlocksOfSameSize[exponent]; i++)
        if (isBlockFree[exponent][i]) return i;
    return -1;
}

void* BuddyAllocator::getBlockAddress(int exponent, int blockIndex) const {
     return static_cast<char*>(firstAlignedAddress)
            + exponent * (maxUsedNumberOfBlocksOfSameSize * BLOCK_SIZE)
            + blockIndex * BLOCK_SIZE;
}

int BuddyAllocator::getBlockIndexFromAddress(void* blockAddress, int exponent) const {
    return static_cast<int>((reinterpret_cast<size_t>(blockAddress) - reinterpret_cast<size_t>(getBlockAddress(exponent, 0))) / BLOCK_SIZE);
}