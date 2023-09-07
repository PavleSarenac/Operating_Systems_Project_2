#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

size_t MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator() {
    auto heapStartAddress = reinterpret_cast<size_t>(HEAP_START_ADDR);
    bool isHeapStartAddressAligned = heapStartAddress % BLOCK_SIZE == 0;
    size_t offsetForAlignment = isHeapStartAddressAligned ? 0 : (BLOCK_SIZE - heapStartAddress % BLOCK_SIZE);
    return heapStartAddress + offsetForAlignment;
}

size_t MemoryAllocationHelperFunctions::getLastAvailableAddressForBuddyAllocator() {
    auto heapStartAddress = reinterpret_cast<size_t>(HEAP_START_ADDR);
    auto heapEndAddress = reinterpret_cast<size_t>(HEAP_END_ADDR) - 1;
    size_t lastAvailableAddressForBuddyAllocator = heapStartAddress + (((heapEndAddress - heapStartAddress) * 125) / 1000);
    return lastAvailableAddressForBuddyAllocator;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOfBytesAssignedToBuddyAllocator() {
    return getLastAvailableAddressForBuddyAllocator() - getFirstAlignedAddressForBuddyAllocator();
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOf4KBMemoryBlocksAssignedToBuddyAllocator() {
    return getTotalNumberOfBytesAssignedToBuddyAllocator() / BLOCK_SIZE;
}

size_t MemoryAllocationHelperFunctions::getFirstAlignedAddressForFirstFitAllocator() {
    auto firstAvailableAddressAfterBuddyAllocator = getLastAvailableAddressForBuddyAllocator() + 1;
    bool isHeapStartAddressAligned = firstAvailableAddressAfterBuddyAllocator % MEM_BLOCK_SIZE == 0;
    size_t offsetForAlignment = isHeapStartAddressAligned ? 0 : (MEM_BLOCK_SIZE - firstAvailableAddressAfterBuddyAllocator % MEM_BLOCK_SIZE);
    return firstAvailableAddressAfterBuddyAllocator + offsetForAlignment;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOf8BMemoryBlocksForFirstFitAllocator() {
    size_t firstAlignedAddress = getFirstAlignedAddressForFirstFitAllocator();
    size_t lastAvailableAddress = reinterpret_cast<size_t>(HEAP_END_ADDR) - 1;
    return (lastAvailableAddress - firstAlignedAddress) / MEM_BLOCK_SIZE;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator() {
    size_t initialTotalNumberOfMemoryBlocksForBuddyAlocator = getTotalNumberOf4KBMemoryBlocksAssignedToBuddyAllocator();
    size_t finalTotalNumberOfMemoryBlocksForBuddyAllocator = 1;
    while (finalTotalNumberOfMemoryBlocksForBuddyAllocator <= initialTotalNumberOfMemoryBlocksForBuddyAlocator) {
        finalTotalNumberOfMemoryBlocksForBuddyAllocator <<= 1;
    }
    finalTotalNumberOfMemoryBlocksForBuddyAllocator >>= 1;
    return finalTotalNumberOfMemoryBlocksForBuddyAllocator;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOfUsedBytesForBuddyAllocator() {
    return getTotalNumberOfUsedMemoryBlocksForBuddyAllocator() * BLOCK_SIZE;
}

void MemoryAllocationHelperFunctions::initializeBuddyAllocator() {
    BuddyAllocator::getInstance().setup(
            reinterpret_cast<void*>(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator()),
            static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator()));
}