#ifndef BUDDYALLOCATORTEST_HPP
#define BUDDYALLOCATORTEST_HPP

#include "../../Code/MemoryAllocator/BuddyAllocator.hpp"
#include "../../Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

class BuddyAllocatorTest {
public:
    static void runTests();
    static bool assertGetExponentForNumberOfBlocks();
    static bool assertGetExponentForNumberOfBytes();
    static bool assertSetup();
    static bool assertGetBlockAddress();
    static bool assertAllocate();
    static bool assertDeallocate();
private:
    static size_t getNumberOfFreeBlocks();
};

#endif
