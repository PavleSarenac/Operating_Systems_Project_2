#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"

kmem_cache_t* SlabAllocator::headOfCacheList = nullptr;

SlabAllocator& SlabAllocator::getInstance() {
    static SlabAllocator slabAllocator;
    return slabAllocator;
}

kmem_cache_t* SlabAllocator::createCache(const char *cacheName, size_t objectSizeInBytes,
                                          void (*objectConstructor)(void *), void (*objectDestructor)(void *)) {
    kmem_cache_t* existingCache = findExistingCache(cacheName);
    if (existingCache) return existingCache;
    auto newCache = static_cast<kmem_cache_t*>(BuddyAllocator::getInstance().allocate(sizeof(kmem_cache_t)));
    return initializeNewCache(newCache, cacheName, objectSizeInBytes, objectConstructor, objectDestructor);
}

void* SlabAllocator::allocateObject(kmem_cache_t* cache) {
    kmem_slab_t* slab = getSlabWithFreeObject(cache);
    return getObjectFromSlab(cache, slab);
}

void SlabAllocator::printCacheInfo(kmem_cache_t* cache) {
    printString("-------------------------------------------------------------------\n");
    printString("Cache name: "); printString(cache->cacheName); printString("\n");
    printString("Size of one object in bytes: "); printInt(cache->objectSizeInBytes); printString("\n");
    printString("Size of whole cache in number of blocks with size 4096B: "); printInt(cache->cacheSizeInBlocks); printString("\n");
    printString("Total number of slabs: "); printInt(cache->numberOfSlabs); printString("\n");
    printString("Number of objects in one slab: "); printInt(cache->numberOfObjectsInOneSlab); printString("\n");
    printString("Percent of used memory in cache: "); printInt(SlabAllocator::getTotalUsedMemoryInBytesInCache(cache));
    printString("B/"); printInt(SlabAllocator::getTotalAllocatedMemoryInBytesInCache(cache)); printString("B\n");
    printString("--------------------------Additional info--------------------------\n");
    printString("Number of free slabs: "); printInt(getNumberOfFreeSlabs(cache)); printString("\n");
    printString("Number of dirty slabs: "); printInt(getNumberOfDirtySlabs(cache)); printString("\n");
    printString("Number of full slabs: "); printInt(getNumberOfFullSlabs(cache)); printString("\n");
    printString("-------------------------------------------------------------------\n");
}

kmem_cache_t* SlabAllocator::findExistingCache(const char* cacheName) {
    for (kmem_cache_t* currentCache = headOfCacheList; currentCache; currentCache = currentCache->nextCache)
        if (areCacheNamesEqual(currentCache->cacheName, cacheName)) return currentCache;
    return nullptr;
}

bool SlabAllocator::areCacheNamesEqual(char existingCacheName[MAX_CACHE_NAME_LENGTH], const char* newCacheName) {
    char* newCachePointer = const_cast<char*>(newCacheName);
    int existingCacheIndex = 0;
    while (*newCachePointer != '\0') {
        if (*newCachePointer != existingCacheName[existingCacheIndex]) return false;
        newCachePointer++;
        existingCacheIndex++;
    }
    return true;
}

int SlabAllocator::getNumberOfFreeSlabs(kmem_cache_t* cache) {
    int numberOfFreeSlabs = 0;
    for (kmem_slab_t* currentSlab = cache->headOfFreeSlabsList; currentSlab; currentSlab = currentSlab->nextSlab)
        numberOfFreeSlabs++;
    return numberOfFreeSlabs;
}

int SlabAllocator::getNumberOfDirtySlabs(kmem_cache_t* cache) {
    int numberOfDirtySlabs = 0;
    for (kmem_slab_t* currentSlab = cache->headOfDirtySlabsList; currentSlab; currentSlab = currentSlab->nextSlab)
        numberOfDirtySlabs++;
    return numberOfDirtySlabs;
}

int SlabAllocator::getNumberOfFullSlabs(kmem_cache_t* cache) {
    int numberOfFullSlabs = 0;
    for (kmem_slab_t* currentSlab = cache->headOfFullSlabsList; currentSlab; currentSlab = currentSlab->nextSlab)
        numberOfFullSlabs++;
    return numberOfFullSlabs;
}

kmem_cache_t* SlabAllocator::initializeNewCache(kmem_cache_t *newCache, const char *cacheName, size_t objectSizeInBytes,
                                                void (*objectConstructor)(void *), void (*objectDestructor)(void *)) {
    for (int i = 0; ; i++) {
        newCache->cacheName[i] = cacheName[i];
        if (cacheName[i] == '\0') break;
    }
    newCache->objectSizeInBytes = objectSizeInBytes;
    newCache->cacheSizeInBlocks = 0;
    newCache->numberOfSlabs = 0;
    newCache->numberOfObjectsInOneSlab = calculateNumberOfSlotsInSlab(objectSizeInBytes);
    newCache->objectConstructor = objectConstructor;
    newCache->objectDestructor = objectDestructor;
    newCache->headOfFreeSlabsList = nullptr;
    newCache->headOfDirtySlabsList = nullptr;
    newCache->headOfFullSlabsList = nullptr;
    newCache->nextCache = headOfCacheList;
    headOfCacheList = newCache;
    return newCache;
}

size_t SlabAllocator::calculateNumberOfSlotsInSlab(size_t objectSizeInBytes) {
    if (objectSizeInBytes > BLOCK_SIZE) return 1;
    size_t numberOfSlots = 0;
    while (sizeof(kmem_slab_t) + numberOfSlots * sizeof(int) + numberOfSlots * objectSizeInBytes <= BLOCK_SIZE) {
        numberOfSlots++;
    }
    return --numberOfSlots;
}

kmem_slab_t* SlabAllocator::getSlabWithFreeObject(kmem_cache_t* cache) {
    kmem_slab_t* slab;
    if (cache->headOfDirtySlabsList) {
        slab = cache->headOfDirtySlabsList;
    } else if (cache->headOfFreeSlabsList) {
        slab = cache->headOfFreeSlabsList;
    } else {
        slab = allocateNewFreeSlab(cache);
    }
    return slab;
}

kmem_slab_t* SlabAllocator::allocateNewFreeSlab(kmem_cache_t* cache) {
    size_t totalSlabSizeInBytes = sizeof(kmem_slab_t) + sizeof(int) * cache->numberOfObjectsInOneSlab
            + cache->numberOfObjectsInOneSlab * cache->objectSizeInBytes;
    auto newFreeSlab = static_cast<kmem_slab_t*>(BuddyAllocator::getInstance().allocate(totalSlabSizeInBytes));
    cache->cacheSizeInBlocks += (totalSlabSizeInBytes / BLOCK_SIZE + (totalSlabSizeInBytes % BLOCK_SIZE != 0 ? 1 : 0));
    cache->numberOfSlabs++;
    return initializeNewFreeSlab(cache, newFreeSlab);
}

kmem_slab_t* SlabAllocator::initializeNewFreeSlab(kmem_cache_t* cache, kmem_slab_t* newFreeSlab) {
    newFreeSlab->numberOfFreeSlots = cache->numberOfObjectsInOneSlab;
    newFreeSlab->firstFreeSlotIndex = 0;
    for (size_t i = 0; i < newFreeSlab->numberOfFreeSlots; i++) {
        newFreeSlab->slots[i] = i + 1;
    }
    newFreeSlab->slots[newFreeSlab->numberOfFreeSlots - 1] = -1;
    newFreeSlab->nextSlab = cache->headOfFreeSlabsList;
    cache->headOfFreeSlabsList = newFreeSlab;
    return newFreeSlab;
}

void* SlabAllocator::getObjectFromSlab(kmem_cache_t* cache, kmem_slab_t* slab) {
    void* object = reinterpret_cast<char*>(slab) + sizeof(kmem_slab_t) + sizeof(int) * cache->numberOfObjectsInOneSlab +
            slab->firstFreeSlotIndex * cache->objectSizeInBytes;
    slab->firstFreeSlotIndex = slab->slots[slab->firstFreeSlotIndex];
    slab->numberOfFreeSlots--;
    moveSlabToCorrectSlabList(cache, slab);
    return object;
}

void SlabAllocator::moveSlabToCorrectSlabList(kmem_cache_t* cache, kmem_slab_t* slab) {
    if (slab->numberOfFreeSlots == 0 && cache->numberOfObjectsInOneSlab > 1) {
        moveSlabFromDirtyToFullList(cache, slab);
    } else if (slab->numberOfFreeSlots == 0) {
        moveSlabFromFreeToFullList(cache, slab);
    } else if (slab->numberOfFreeSlots == cache->numberOfObjectsInOneSlab - 1) {
        moveSlabFromFreeToDirtyList(cache, slab);
    }
}

void SlabAllocator::moveSlabFromFreeToDirtyList(kmem_cache_t* cache, kmem_slab_t* slab) {
    cache->headOfFreeSlabsList = cache->headOfFreeSlabsList->nextSlab;
    slab->nextSlab = cache->headOfDirtySlabsList;
    cache->headOfDirtySlabsList = slab;
}

void SlabAllocator::moveSlabFromDirtyToFullList(kmem_cache_t* cache, kmem_slab_t* slab) {
    cache->headOfDirtySlabsList = cache->headOfDirtySlabsList->nextSlab;
    slab->nextSlab = cache->headOfFullSlabsList;
    cache->headOfFullSlabsList = slab;
}

void SlabAllocator::moveSlabFromFreeToFullList(kmem_cache_t* cache, kmem_slab_t* slab) {
    cache->headOfFreeSlabsList = cache->headOfFreeSlabsList->nextSlab;
    slab->nextSlab = cache->headOfFullSlabsList;
    cache->headOfFullSlabsList = slab;
}

int SlabAllocator::getTotalUsedMemoryInBytesInCache(kmem_cache_t* cache) {
    int totalMemoryUsedByCache = 0;
    kmem_slab_t* currentDirtySlab = cache->headOfDirtySlabsList;
    while (currentDirtySlab) {
        totalMemoryUsedByCache += (cache->numberOfObjectsInOneSlab - currentDirtySlab->numberOfFreeSlots) * cache->objectSizeInBytes;
        currentDirtySlab = currentDirtySlab->nextSlab;
    }
    kmem_slab_t* currentFullSlab = cache->headOfFullSlabsList;
    while (currentFullSlab) {
        totalMemoryUsedByCache += cache->numberOfObjectsInOneSlab * cache->objectSizeInBytes;
        currentFullSlab = currentFullSlab->nextSlab;
    }
    return totalMemoryUsedByCache;
}

int SlabAllocator::getTotalAllocatedMemoryInBytesInCache(kmem_cache_t* cache) {
    return cache->cacheSizeInBlocks * BLOCK_SIZE;
}