#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

size_t MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator() {
    auto heapStartAddress = reinterpret_cast<size_t>(HEAP_START_ADDR);
    bool isHeapStartAddressAligned = heapStartAddress % BLOCK_SIZE == 0;
    size_t offsetForAlignment = isHeapStartAddressAligned ? 0 : (BLOCK_SIZE - heapStartAddress % BLOCK_SIZE);
    return heapStartAddress + offsetForAlignment;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocks() {
    size_t firstAlignedAddress = getFirstAlignedAddressForBuddyAllocator();
    size_t lastAvailableAddress = reinterpret_cast<size_t>(HEAP_END_ADDR) - 1;
    return (lastAvailableAddress - firstAlignedAddress) / BLOCK_SIZE;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocksForBuddyAllocator() {
    size_t initialTotalNumberOfMemoryBlocksForBuddyAlocator = (getTotalNumberOfMemoryBlocks() * 125) / 1000;
    size_t finalTotalNumberOfMemoryBlocksForBuddyAllocator = 1;
    while (finalTotalNumberOfMemoryBlocksForBuddyAllocator <= initialTotalNumberOfMemoryBlocksForBuddyAlocator) {
        finalTotalNumberOfMemoryBlocksForBuddyAllocator <<= 1;
    }
    finalTotalNumberOfMemoryBlocksForBuddyAllocator >>= 1;
    return finalTotalNumberOfMemoryBlocksForBuddyAllocator;
}

void MemoryAllocationHelperFunctions::initializeBuddyAllocator() {
    BuddyAllocator::getInstance().setup(
            reinterpret_cast<void*>(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator()),
            static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocksForBuddyAllocator()));
}