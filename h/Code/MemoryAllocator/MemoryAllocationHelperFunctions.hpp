#ifndef MEMORYALLOCATIONHELPERFUNCTIONS_HPP
#define MEMORYALLOCATIONHELPERFUNCTIONS_HPP

#include "../../../lib/hw.h"
#include "../../../h/Code/MemoryAllocator/slab.hpp"

namespace MemoryAllocationHelperFunctions {
    size_t getFirstAlignedAddressForBuddyAllocator();
    size_t getTotalNumberOfMemoryBlocks();
    size_t getTotalNumberOfMemoryBlocksForBuddyAllocator();
    void initializeBuddyAllocator();
}

#endif
