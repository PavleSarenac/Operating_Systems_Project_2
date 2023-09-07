#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"

void SlabAllocatorTest::runTests() {
    assertAllocateObject();
}

void SlabAllocatorTest::assertAllocateObject() {
    class Class1 {
    public:
        long long c;
        char arr[220];
    };
    kmem_cache_t* cache = kmem_cache_create("Class1", sizeof(Class1), nullptr, nullptr);
    kmem_cache_info(cache);
    auto obj1Class1 = reinterpret_cast<Class1*>(kmem_cache_alloc(cache));
    obj1Class1->c = 2900;
    kmem_cache_info(cache);
    kmem_cache_t* cache2 = kmem_cache_create("Class1", sizeof(Class1), nullptr, nullptr);
    kmem_cache_info(cache2);
    printInt(cache == cache2);
}