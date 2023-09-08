#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

const int arrSize = 10000;
class Class1 {
public:
    char c[3000];
};
Class1* arr1[arrSize];

void SlabAllocatorTest::runTests() {
    //objectAllocFreeTest();
    bufferAllocFreeTest();
}

void SlabAllocatorTest::objectAllocFreeTest() {
    kmem_cache_t* cache1 = kmem_cache_create("Class1", sizeof(Class1), nullptr, nullptr);
    printString("*****************************BEFORE ALLOCATION*****************************\n\n");
    kmem_cache_info(cache1);
    for (int i = 0; i < arrSize; i++) {
        arr1[i] = (Class1*)kmem_cache_alloc(cache1);
    }
    printString("*****************************AFTER ALLOCATION******************************\n\n");
    kmem_cache_info(cache1);
    kmem_cache_free(cache1, arr1[0]);
    for (int i = 0; i < arrSize - 77; i++) {
        kmem_cache_free(cache1, arr1[i]);
    }
    printString("*****************************AFTER DEALLOCATION****************************\n\n");
    kmem_cache_info(cache1);
}

void SlabAllocatorTest::bufferAllocFreeTest() {
    void* buff = kmalloc(1 << 17);
    kmalloc(1 << 17);
    kmalloc(1 << 17);
    kmalloc(1 << 17);
    kmalloc((1 << 15) - 55);
    kmem_cache_t* bufferSize5 = kmem_cache_create("size-17", 1, nullptr, nullptr);
    kmem_cache_info(bufferSize5);
}