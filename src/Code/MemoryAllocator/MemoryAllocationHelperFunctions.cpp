#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocator.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"

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

size_t MemoryAllocationHelperFunctions::getExponentForNumberOfBytes(size_t numberOfBytes) {
    if (numberOfBytes == 0) return 0;
    size_t exponent = 0, numberOfAllocatedBytes = 1;
    while (numberOfAllocatedBytes < numberOfBytes) {
        numberOfAllocatedBytes <<= 1;
        exponent++;
    }
    return exponent;
}

void MemoryAllocationHelperFunctions::initializeBuddyAllocator() {
    BuddyAllocator::getInstance().setup(
            reinterpret_cast<void*>(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator()),
            static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator()));
}

void MemoryAllocationHelperFunctions::printBuddyAllocatorInfo() {
    printString("Heap start address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_START_ADDR), 16); printString("\n");
    printString("Heap end address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_END_ADDR), 16); printString("\n");
    printString("BuddyAllocator first address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator(), 16); printString("\n");
    printString("BuddyAllocator last address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getLastAvailableAddressForBuddyAllocator(), 16); printString("\n");
    printString("FirstFitAllocator first address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getFirstAlignedAddressForFirstFitAllocator(), 16); printString("\n");
    printString("BuddyAllocator total number of initially assigned bytes: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfBytesAssignedToBuddyAllocator()); printString("B\n");
    printString("BuddyAllocator total number of initially assigned 4KB blocks: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOf4KBMemoryBlocksAssignedToBuddyAllocator()); printString("\n");
    printString("BuddyAllocator total number of actually assigned bytes: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedBytesForBuddyAllocator()); printString("B\n");
    printString("BuddyAllocator total number of actually assigned 4KB blocks: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator()); printString("\n");
    printString("BuddyAllocator percent of used bytes: ");
    printSizet(BuddyAllocator::getInstance().getNumberOfAllocatedBytes()); printString("B/");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedBytesForBuddyAllocator()); printString("B\n");
    printString("BuddyAllocator percent of used 4KB blocks: ");
    printSizet(BuddyAllocator::getInstance().getNumberOfUsedBlocks()); printString("/");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator()); printString("\n");
    printString("\n");
}

void MemoryAllocationHelperFunctions::printFirstFitAllocatorInfo() {
    printString("Heap start address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_START_ADDR), 16); printString("\n");
    printString("Heap end address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_END_ADDR), 16); printString("\n");
    printString("FirstFitAllocator first address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getFirstAlignedAddressForFirstFitAllocator(), 16); printString("\n");
    printString("FirstFitAllocator last address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_END_ADDR) - 1, 16); printString("\n");
    printString("FirstFitAllocator percent of used memory in bytes: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOf8BMemoryBlocksForFirstFitAllocator() * MEM_BLOCK_SIZE
        - MemoryAllocator::getInstance().getTotalNumberOfFreeBytes());
    printString("B/");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOf8BMemoryBlocksForFirstFitAllocator() * MEM_BLOCK_SIZE);
    printString("B\n");
    printString("FirstFitAllocator largest free segment in bytes: ");
    printSizet(MemoryAllocator::getInstance().getNumberOfBytesInLargestFreeSegment());
    printString("B\n");
    printString("FirstFitAllocator percent of used memory in 8B blocks: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOf8BMemoryBlocksForFirstFitAllocator()
               - (MemoryAllocator::getInstance().getTotalNumberOfFreeBytes() / MEM_BLOCK_SIZE));
    printString("/");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOf8BMemoryBlocksForFirstFitAllocator());
    printString("\n");
    printString("FirstFitAllocator largest free segment in 8B blocks: ");
    printSizet(MemoryAllocator::getInstance().getNumberOfBytesInLargestFreeSegment() / MEM_BLOCK_SIZE);
    printString("\n");
}