#ifndef SLABALLOCATORTEST_HPP
#define SLABALLOCATORTEST_HPP

#include "../../Code/MemoryAllocator/slab.hpp"

class SlabAllocatorTest {
public:
    static void runTests();
    static kmem_cache_t* objectAllocFreeTest();
    static void bufferAllocFreeTest();
};

#endif
