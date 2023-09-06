#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

void SlabAllocatorTest::runTests() {
    assertAllocateObject();
}

void SlabAllocatorTest::assertAllocateObject() {
    class Class1 {
    public:
        void print() { printString("\n\neeeeeeeeee\n\n"); }
        long long c;
        char arr[2200];
    };
    kmem_init(reinterpret_cast<void*>(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator()),
              static_cast<int>(MemoryAllocationHelperFunctions::getTotalNumberOfMemoryBlocksForBuddyAllocator()));
    kmem_cache_t* cache = kmem_cache_create("Class1", sizeof(Class1), nullptr, nullptr);
    auto obj1Class1 = reinterpret_cast<Class1*>(kmem_cache_alloc(cache));
    obj1Class1->c = 2900;
    obj1Class1->arr[2159] = 'b';
    obj1Class1->print();
    kmem_cache_info(cache);
}