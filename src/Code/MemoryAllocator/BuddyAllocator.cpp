#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

BuddyAllocator& BuddyAllocator::getInstance() {
    static BuddyAllocator buddyAllocator;
    return buddyAllocator;
}

void BuddyAllocator::setup(void* firstAlignedAddress, int totalNumberOfMemoryBlocksForSlabAllocation) {
    setFirstAlignedAddressForBuddyAllocation(firstAlignedAddress);
    setTotalNumberOfMemoryBlocksForBuddyAllocation(totalNumberOfMemoryBlocksForSlabAllocation);
}

void BuddyAllocator::setFirstAlignedAddressForBuddyAllocation(void* firstAlignedAddressForBuddyAllocation) {
    this->firstAlignedAddressForBuddyAllocation = firstAlignedAddressForBuddyAllocation;
}

void BuddyAllocator::setTotalNumberOfMemoryBlocksForBuddyAllocation(int totalNumberOfMemoryBlocksForBuddyAllocation) {
    this->totalNumberOfMemoryBlocksForBuddyAllocation = totalNumberOfMemoryBlocksForBuddyAllocation;
}