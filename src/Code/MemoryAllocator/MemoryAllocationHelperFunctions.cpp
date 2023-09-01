#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

size_t MemoryAllocationHelperFunctions::getFirstAlignedAddress() {
    auto heapStartAddress = reinterpret_cast<size_t>(HEAP_START_ADDR);
    bool isHeapStartAddressAligned = heapStartAddress % MEM_BLOCK_SIZE == 0;
    size_t offsetForAlignment = isHeapStartAddressAligned ? 0 : (MEM_BLOCK_SIZE - heapStartAddress % MEM_BLOCK_SIZE);
    return heapStartAddress + offsetForAlignment;
}

size_t MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocks() {
    size_t firstAlignedAddress = getFirstAlignedAddress();
    size_t lastAvailableAddress = reinterpret_cast<size_t>(HEAP_END_ADDR) - 1;
    return (lastAvailableAddress - firstAlignedAddress) / MEM_BLOCK_SIZE;
}

size_t MemoryAllocationHelperFunctions::getNumberOfMemoryBlocksForSlabAllocator() {
    size_t totalNumberOfMemoryBlocks = getTotalNumberOfMemoryBlocks();
    return (totalNumberOfMemoryBlocks * 125) / 1000;
}