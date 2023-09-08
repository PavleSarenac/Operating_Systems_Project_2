#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

void SlabAllocatorTest::runTests() {
    assertAllocateObject();
}

void SlabAllocatorTest::assertAllocateObject() {
    MemoryAllocationHelperFunctions::initializeBuddyAllocator();
    class Class1 {
    public:
        char c[4000];
    };
    kmem_cache_t* cache1 = kmem_cache_create("Class1", sizeof(Class1), nullptr, nullptr);

    const int arrSize = 100;
    Class1* arr1[arrSize];
    for (int i = 0; i < arrSize; i++) {
        arr1[i] = (Class1*)kmem_cache_alloc(cache1);
    }
    kmem_cache_info(cache1);
}