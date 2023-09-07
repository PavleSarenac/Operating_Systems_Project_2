#ifndef SLABALLOCATOR_HPP
#define SLABALLOCATOR_HPP

#include "slab.hpp"

class SlabAllocator {
public:
    static kmem_cache_t* headOfCacheList;

    static SlabAllocator& getInstance();
    SlabAllocator(const SlabAllocator&) = delete;
    void operator=(const SlabAllocator&) = delete;
    static kmem_cache_t* createCache(const char* cacheName, size_t objectSizeInBytes,
                              void (*objectConstructor)(void*), void (*objectDestructor)(void*));
    static void* allocateObject(kmem_cache_t* cache);
    static void printCacheInfo(kmem_cache_t* cache);
private:
    SlabAllocator() = default;
    static kmem_cache_t* findExistingCache(const char* cacheName);
    static kmem_cache_t* initializeNewCache(kmem_cache_t* newCache, const char* cacheName, size_t objectSizeInBytes,
                                            void (*objectConstructor)(void*), void (*objectDestructor)(void*));
    static size_t calculateNumberOfSlotsInSlab(size_t objectSizeInBytes);
    static kmem_slab_t* getSlabWithFreeObject(kmem_cache_t* cache);
    static kmem_slab_t* allocateNewFreeSlab(kmem_cache_t* cache);
    static kmem_slab_t* initializeNewFreeSlab(kmem_cache_t* cache, kmem_slab_t* newFreeSlab);
    static void callConstructorForAllObjectsInSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static void* getObjectFromSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabToCorrectSlabList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromFreeToDirtyList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromDirtyToFullList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromFreeToFullList(kmem_cache_t* cache, kmem_slab_t* slab);
    static int getTotalUsedMemoryInBytesInCache(kmem_cache_t* cache);
    static int getTotalAllocatedMemoryInBytesInCache(kmem_cache_t* cache);
    static int getNumberOfFreeSlabs(kmem_cache_t* cache);
    static int getNumberOfDirtySlabs(kmem_cache_t* cache);
    static int getNumberOfFullSlabs(kmem_cache_t* cache);
    static bool areCacheNamesEqual(const char existingCacheName[MAX_CACHE_NAME_LENGTH], const char* newCacheName);
};

#endif
