#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

const int slabAllocatorTestClassArraySize = 2000;
class SlabAllocatorTestClass {
public:
    char c[500];
};
SlabAllocatorTestClass* slabAllocatorTestClassArray[slabAllocatorTestClassArraySize];
void* slabAllocatorTestClassBufferArray[slabAllocatorTestClassArraySize];

void SlabAllocatorTest::runTests() {
    objectAllocFreeTest();
    bufferAllocFreeTest();
    kmem_cache_t* cache1 = objectAllocFreeTest();
    kmem_cache_destroy(cache1);
}

kmem_cache_t* SlabAllocatorTest::objectAllocFreeTest() {
    kmem_cache_t* cache1 = kmem_cache_create("Class1", sizeof(SlabAllocatorTestClass), nullptr, nullptr);
    printString("*****************************BEFORE ALLOCATION*****************************\n\n");
    kmem_cache_info(cache1);
    for (int i = 0; i < slabAllocatorTestClassArraySize; i++) {
        slabAllocatorTestClassArray[i] = (SlabAllocatorTestClass*)kmem_cache_alloc(cache1);
    }
    printString("*****************************AFTER ALLOCATION******************************\n\n");
    kmem_cache_info(cache1);
    kmem_cache_free(cache1, slabAllocatorTestClassArray[0]);
    for (int i = 0; i < slabAllocatorTestClassArraySize; i++) {
        kmem_cache_free(cache1, slabAllocatorTestClassArray[i]);
    }
    printString("*****************************AFTER DEALLOCATION****************************\n\n");
    kmem_cache_info(cache1);
    return cache1;
}

void SlabAllocatorTest::bufferAllocFreeTest() {
    for (int i = 0; i < slabAllocatorTestClassArraySize; i++) {
        slabAllocatorTestClassBufferArray[i] = kmalloc(300);
    }
    kmem_cache_t* bufferSize5 = kmem_cache_create("size-9", 1, nullptr, nullptr);
    kmem_cache_info(bufferSize5);
    for (int i = 0; i < slabAllocatorTestClassArraySize; i++) {
        kfree(slabAllocatorTestClassBufferArray[i]);
    }
    kmem_cache_info(bufferSize5);

    printInt(kmem_cache_shrink(bufferSize5));
    printString("\n");
    for (int i = 0; i < 20; i++)
        slabAllocatorTestClassBufferArray[i] = kmalloc(300);
    for (int i = 0; i < 20; i++)
        kfree(slabAllocatorTestClassBufferArray[i]);
    kmem_cache_info(bufferSize5);
    printInt(kmem_cache_shrink(bufferSize5));
    printString("\n");
    kmem_cache_info(bufferSize5);
    kmem_cache_destroy(bufferSize5);
}