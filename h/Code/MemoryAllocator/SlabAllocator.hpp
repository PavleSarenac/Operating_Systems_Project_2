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
    static kmem_cache_t* initializeNewCache(kmem_cache_t* newCache, const char* cacheName, size_t objectSizeInBytes,
                                            void (*objectConstructor)(void*), void (*objectDestructor)(void*));
    static kmem_slab_t* getSlabWithFreeObject(kmem_cache_t* cache);
    static kmem_slab_t* allocateNewFreeSlab(kmem_cache_t* cache);
    static kmem_slab_t* initializeNewFreeSlab(kmem_cache_t* cache, kmem_slab_t* newFreeSlab);
    static void* getObjectFromSlab(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabToCorrectSlabList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromFreeToDirtyList(kmem_cache_t* cache, kmem_slab_t* slab);
    static void moveSlabFromDirtyToFullList(kmem_cache_t* cache, kmem_slab_t* slab);
    static int getTotalUsedMemoryInBytesInCache(kmem_cache_t* cache);
    static int getTotalAllocatedMemoryInBytesInCache(kmem_cache_t* cache);
};

#endif
