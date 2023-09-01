#ifndef MEMORYALLOCATIONHELPERFUNCTIONS_HPP
#define MEMORYALLOCATIONHELPERFUNCTIONS_HPP

#include "../../../lib/hw.h"

namespace MemoryAllocationHelperFunctions {
    size_t getFirstAlignedAddress();

    size_t getTotalNumberOfMemoryBlocks();

    size_t getNumberOfMemoryBlocksForSlabAllocator();
}

#endif
