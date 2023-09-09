#include "../../../h/Testing/Testing_OS2/SlabAllocatorTest.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"

const int arrSize = 2000;
class Class1 {
public:
    char c[500];
};
Class1* arr1[arrSize];
void* bufferArr[arrSize];

void SlabAllocatorTest::runTests() {
    objectAllocFreeTest();
    //bufferAllocFreeTest();
    //objectAllocFreeTest();
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
    for (int i = 0; i < arrSize; i++) {
        kmem_cache_free(cache1, arr1[i]);
    }
    printString("*****************************AFTER DEALLOCATION****************************\n\n");
    kmem_cache_info(cache1);
}

void SlabAllocatorTest::bufferAllocFreeTest() {
    for (int i = 0; i < arrSize; i++) {
        bufferArr[i] = kmalloc(300);
    }
    kmem_cache_t* bufferSize5 = kmem_cache_create("size-9", 1, nullptr, nullptr);
    kmem_cache_info(bufferSize5);
    for (int i = 0; i < arrSize; i++) {
        kfree(bufferArr[i]);
    }
    kmem_cache_info(bufferSize5);

    printInt(kmem_cache_shrink(bufferSize5));
    printString("\n");
    for (int i = 0; i < 20; i++)
        bufferArr[i] = kmalloc(300);
    for (int i = 0; i < 20; i++)
        kfree(bufferArr[i]);
    kmem_cache_info(bufferSize5);
    printInt(kmem_cache_shrink(bufferSize5));
    printString("\n");
    kmem_cache_info(bufferSize5);
    kmem_cache_destroy(bufferSize5);
}