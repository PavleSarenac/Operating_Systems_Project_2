#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

void SlabAllocatorTest::runTests() {
    printString("Running tests for SlabAllocator.\n\n");
    if (!assertAllocateObject()) {
        printString("*****Some tests for BuddyAllocator have failed*****\n\n");
    } else {
        printString("All tests for SlabAllocator have passed.\n\n");
    }
}

bool SlabAllocatorTest::assertAllocateObject() {
    printString("Testing allocateObject method.\n");
    bool testPassed = true;

    class Class1 {
    public:
        long long c;
    };
    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    kmem_cache_t* cache = SlabAllocator::createCache("Class1", sizeof(Class1), nullptr, nullptr);
    auto obj1Class1 = reinterpret_cast<Class1*>(kmem_cache_alloc(cache));
    obj1Class1->c = 'a';
    auto obj2Class1 = reinterpret_cast<Class1*>(kmem_cache_alloc(cache));
    obj2Class1->c = 'a';
    SlabAllocator::printCacheInfo(cache);

    if (testPassed) {
        printString("All assertions for allocateObject method have passed.\n\n");
        return true;
    } else {
        printString("*****There are failed assertions for allocateObject method*****\n\n");
        return false;
    }
}