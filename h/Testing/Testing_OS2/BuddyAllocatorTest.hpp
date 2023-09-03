#ifndef BUDDYALLOCATORTEST_HPP
#define BUDDYALLOCATORTEST_HPP

#include "../../Code/MemoryAllocator/BuddyAllocator.hpp"
#include "../../Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

class BuddyAllocatorTest {
public:
    static void runTests();
    static void assertGetExponentForNumberOfBlocks();
    static void assertGetExponentForNumberOfBytes();
    static void assertSetup();
    static void assertGetBlockAddress();
    static void assertAllocate();
};

#endif
