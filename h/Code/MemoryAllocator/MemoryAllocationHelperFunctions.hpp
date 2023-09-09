#ifndef MEMORYALLOCATIONHELPERFUNCTIONS_HPP
#define MEMORYALLOCATIONHELPERFUNCTIONS_HPP

#include "../../../lib/hw.h"
#include "../../../h/Code/MemoryAllocator/slab.hpp"

namespace MemoryAllocationHelperFunctions {
    size_t getFirstAlignedAddressForBuddyAllocator();
    size_t getLastAvailableAddressForBuddyAllocator();
    size_t getTotalNumberOfBytesAssignedToBuddyAllocator();
    size_t getTotalNumberOf4KBMemoryBlocksAssignedToBuddyAllocator();
    size_t getTotalNumberOfUsedMemoryBlocksForBuddyAllocator();
    size_t getTotalNumberOfUsedBytesForBuddyAllocator();
    size_t getFirstAlignedAddressForFirstFitAllocator();
    size_t getTotalNumberOf8BMemoryBlocksForFirstFitAllocator();
    size_t getExponentForNumberOfBytes(size_t numberOfBytes);
    void printBuddyAllocatorInfo();
    void printFirstFitAllocatorInfo();
    void initializeBuddyAllocator();
}

#endif
