#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

BuddyAllocator& BuddyAllocator::getInstance() {
    static BuddyAllocator buddyAllocator;
    return buddyAllocator;
}

void BuddyAllocator::setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocks) {
    setFirstAlignedAddress(firstAlignedAddress);
    setTotalNumberOfMemoryBlocks(totalNumberOfMemoryBlocks);
}

void BuddyAllocator::setFirstAlignedAddress(void* firstAlignedAddress) {
    this->firstAlignedAddress = firstAlignedAddress;
}

void BuddyAllocator::setTotalNumberOfMemoryBlocks(int totalNumberOfMemoryBlocks) {
    this->totalNumberOfMemoryBlocks = totalNumberOfMemoryBlocks;
}