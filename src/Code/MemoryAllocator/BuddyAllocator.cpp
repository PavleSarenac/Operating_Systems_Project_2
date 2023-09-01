#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

BuddyAllocator& BuddyAllocator::getInstance() {
    static BuddyAllocator buddyAllocator;
    return buddyAllocator;
}

void BuddyAllocator::setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocksForSlabAllocation) {
    setFirstAlignedAddress(firstAlignedAddress);
    setTotalNumberOfMemoryBlocksForSlabAllocation(totalNumberOfMemoryBlocksForSlabAllocation);
}

void BuddyAllocator::setFirstAlignedAddress(void* firstAlignedAddress) {
    this->firstAlignedAddress = firstAlignedAddress;
}

void BuddyAllocator::setTotalNumberOfMemoryBlocksForSlabAllocation(int totalNumberOfMemoryBlocksForSlabAllocation) {
    this->totalNumberOfMemoryBlocksForSlabAllocation = totalNumberOfMemoryBlocksForSlabAllocation;
}

