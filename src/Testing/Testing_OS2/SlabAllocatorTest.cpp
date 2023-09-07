#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"

void SlabAllocatorTest::runTests() {
    assertAllocateObject();
}

void SlabAllocatorTest::assertAllocateObject() {
    class Class1 {
    public:
        char c;
    };
    kmem_cache_t* cache1 = kmem_cache_create("Class1", sizeof(Class1), nullptr, nullptr);

    Class1* arr1[1];
    for (auto &i : arr1) {
        i = reinterpret_cast<Class1*>(kmem_cache_alloc(cache1));
    }

    kmem_cache_info(cache1);
}