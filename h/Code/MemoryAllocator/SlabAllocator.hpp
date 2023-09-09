#ifndef SLABALLOCATOR_HPP
#define SLABALLOCATOR_HPP

#include "slab.hpp"

class SlabAllocator {
public:
    static const int MIN_BUFFER_SIZE_EXPONENT = 5;
    static const int MAX_BUFFER_SIZE_EXPONENT = 17;
    static kmem_cache_t* headOfCacheList;

    SlabAllocator() = delete;
    SlabAllocator(const SlabAllocator&) = delete;
    void operator=(const SlabAllocator&) = delete;
    static kmem_cache_t* createCache(const char* cacheName, size_t objectSizeInBytes,
                              void (*objectConstructor)(void*), void (*objectDestructor)(void*));
    static int shrinkCache(kmem_cache_t* cache);
    static void* allocateObject(kmem_cache_t* cache);
    static void deallocateObject(kmem_cache_t* cache, void* objectPointer);
    static void* allocateBuffer(size_t bufferSizeInBytes);
    static void deallocateBuffer(const void* bufferPointer);
    static void printCacheInfo(kmem_cache_t* cache);
private:
    static kmem_cache_t* findExistingCache(const char* cacheName);
    static kmem_cache_t* initializeNewCache(kmem_cache_t* newCache, const char* cacheName, size_t objectSizeInBytes,
                                            void (*objectConstructor)(void*), void (*objectDestructor)(void*));
    static size_t calculateNumberOfSlotsInSlab(size_t objectSizeInBytes);
    static kmem_slab_t* getSlabWithFreeObject(kmem_cache_t* cache);
    static kmem_slab_t* allocateNewFreeSlab(kmem_cache_t* cache);
    static kmem_slab_t* initializeNewFreeSlab(kmem_cache_t* cache, kmem_slab_t* newFreeSlab);
    static void callConstructorForAllObjectsInSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static void* getObjectFromSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabToCorrectSlabListAfterAllocation(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromFreeToDirtyList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromDirtyToFullList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromFreeToFullList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabToCorrectSlabListAfterDeallocation(kmem_cache_t* cache, kmem_slab_t* slab);
    static void changeSlabListAfterDeallocation(kmem_slab_t* slab, kmem_slab_t*& headOfCurrentList, kmem_slab_t*& headOfNewList);
    static int getTotalUsedMemoryInBytesInCache(kmem_cache_t* cache);
    static int getTotalAllocatedMemoryInBytesInCache(kmem_cache_t* cache);
    static int getNumberOfFreeSlabs(kmem_cache_t* cache);
    static int getNumberOfDirtySlabs(kmem_cache_t* cache);
    static int getNumberOfFullSlabs(kmem_cache_t* cache);
    static int getTotalNumberOfFreeSlotsInFreeSlabsList(kmem_cache_t* cache);
    static int getTotalNumberOfFreeSlotsInDirtySlabsList(kmem_cache_t* cache);
    static int getTotalNumberOfFreeSlotsInFullSlabsList(kmem_cache_t* cache);
    static bool areCacheNamesEqual(const char existingCacheName[MAX_CACHE_NAME_LENGTH], const char* newCacheName);
    static bool deallocateObjectInSlabList(kmem_cache_t* cache, kmem_slab_t* headOfSlabList, void* objectPointer);
    static size_t getFirstObjectAddressInSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static size_t getLastObjectAddressInSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static const char* getBufferCacheName(size_t exponent);
    static int deallocateFreeSlabsList(kmem_cache_t* cache);
};

#endif
