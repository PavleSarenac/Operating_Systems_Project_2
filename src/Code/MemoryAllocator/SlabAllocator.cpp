#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"

kmem_cache_t* SlabAllocator::headOfCacheList = nullptr;

kmem_cache_t* SlabAllocator::createCache(const char *cacheName, size_t objectSizeInBytes,
                                          void (*objectConstructor)(void *), void (*objectDestructor)(void *)) {
    bool isObjectSizeTooBig = objectSizeInBytes >
            ((BLOCK_SIZE * ((1 << (BuddyAllocator::getInstance().getMaxUsedExponent() - 1)))) - (sizeof(kmem_slab_t) + sizeof(int)));
    if (isObjectSizeTooBig) return nullptr;
    kmem_cache_t* existingCache = findExistingCache(cacheName);
    if (existingCache) return existingCache;
    auto newCache = static_cast<kmem_cache_t*>(BuddyAllocator::getInstance().allocate(sizeof(kmem_cache_t)));
    return initializeNewCache(newCache, cacheName, objectSizeInBytes, objectConstructor, objectDestructor);
}

void* SlabAllocator::allocateObject(kmem_cache_t* cache) {
    kmem_slab_t* slab = getSlabWithFreeObject(cache);
    return getObjectFromSlab(cache, slab);
}

void SlabAllocator::deallocateObject(kmem_cache_t* cache, void* objectPointer) {
    if (deallocateObjectInSlabList(cache, cache->headOfDirtySlabsList, objectPointer)) return;
    deallocateObjectInSlabList(cache, cache->headOfFullSlabsList, objectPointer);
}

void* SlabAllocator::allocateBuffer(size_t bufferSizeInBytes) {
    size_t exponent = MemoryAllocationHelperFunctions::getExponentForNumberOfBytes(bufferSizeInBytes);
    if (exponent > MAX_BUFFER_SIZE_EXPONENT) return nullptr;
    size_t finalBufferSizeInBytes;
    if (exponent < MIN_BUFFER_SIZE_EXPONENT) {
        finalBufferSizeInBytes = 1 << MIN_BUFFER_SIZE_EXPONENT;
        exponent = MIN_BUFFER_SIZE_EXPONENT;
    } else {
        finalBufferSizeInBytes = 1 << exponent;
    }
    const char* bufferCacheName = getBufferCacheName(exponent);
    kmem_cache_t* bufferCache = createCache(bufferCacheName, finalBufferSizeInBytes, nullptr, nullptr);
    return allocateObject(bufferCache);
}

void SlabAllocator::printCacheInfo(kmem_cache_t* cache) {
    printString("---------------------------Mandatory cache info----------------------------\n");
    printString("Cache name: "); printString(cache->cacheName); printString("\n");
    printString("Size of one object in bytes: "); printSizet(cache->objectSizeInBytes); printString("\n");
    printString("Size of all slabs in number of 4KB blocks: "); printSizet(cache->cacheSizeInBlocks); printString("\n");
    printString("Total number of slabs: "); printSizet(cache->numberOfSlabs); printString("\n");
    printString("Number of objects in one slab: "); printSizet(cache->numberOfObjectsInOneSlab); printString("\n");
    printString("Percent of used bytes in cache: "); printInt(SlabAllocator::getTotalUsedMemoryInBytesInCache(cache));
    printString("B/"); printInt(SlabAllocator::getTotalAllocatedMemoryInBytesInCache(cache)); printString("B\n");
    printString("---------------------------Additional cache info---------------------------\n");
    printString("Number of free slabs: "); printInt(getNumberOfFreeSlabs(cache));
    printString(" (number of free slots: "); printInt(getTotalNumberOfFreeSlotsInFreeSlabsList(cache));
    printString(")\n");
    printString("Number of dirty slabs: "); printInt(getNumberOfDirtySlabs(cache));
    printString(" (number of free slots: "); printInt(getTotalNumberOfFreeSlotsInDirtySlabsList(cache));
    printString(")\n");
    printString("Number of full slabs: "); printInt(getNumberOfFullSlabs(cache));
    printString(" (number of free slots: "); printInt(getTotalNumberOfFreeSlotsInFullSlabsList(cache));
    printString(")\n");
    printString("Size of one slab in number of 4KB blocks: ");
    printSizet(cache->cacheSizeInBlocks ? cache->cacheSizeInBlocks/cache->numberOfSlabs : 0);
    printString("\n");
    printString("--------------------------------Other info---------------------------------\n");
    printString("Heap start address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_START_ADDR), 16); printString("\n");
    printString("Heap end address: 0x");
    printSizet(reinterpret_cast<size_t>(HEAP_END_ADDR), 16); printString("\n");
    printString("BuddyAllocator first address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getFirstAlignedAddressForBuddyAllocator(), 16); printString("\n");
    printString("BuddyAllocator last address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getLastAvailableAddressForBuddyAllocator(), 16); printString("\n");
    printString("FirstFitAllocator first address: 0x");
    printSizet(MemoryAllocationHelperFunctions::getFirstAlignedAddressForFirstFitAllocator(), 16); printString("\n");
    printString("BuddyAllocator total number of initially assigned bytes: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfBytesAssignedToBuddyAllocator()); printString("B\n");
    printString("BuddyAllocator total number of initially assigned 4KB blocks: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOf4KBMemoryBlocksAssignedToBuddyAllocator()); printString("\n");
    printString("BuddyAllocator total number of actually assigned bytes: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedBytesForBuddyAllocator()); printString("B\n");
    printString("BuddyAllocator total number of actually assigned 4KB blocks: ");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator()); printString("\n");
    printString("BuddyAllocator percent of used bytes: ");
    printSizet(BuddyAllocator::getInstance().getNumberOfAllocatedBytes()); printString("B/");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedBytesForBuddyAllocator()); printString("B\n");
    printString("BuddyAllocator percent of used 4KB blocks: ");
    printSizet(BuddyAllocator::getInstance().getNumberOfUsedBlocks()); printString("/");
    printSizet(MemoryAllocationHelperFunctions::getTotalNumberOfUsedMemoryBlocksForBuddyAllocator()); printString("\n");
    printString("\n");
}

kmem_cache_t* SlabAllocator::findExistingCache(const char* cacheName) {
    for (kmem_cache_t* currentCache = headOfCacheList; currentCache; currentCache = currentCache->nextCache)
        if (areCacheNamesEqual(currentCache->cacheName, cacheName)) return currentCache;
    return nullptr;
}

bool SlabAllocator::areCacheNamesEqual(const char existingCacheName[MAX_CACHE_NAME_LENGTH], const char* newCacheName) {
    char* newCachePointer = const_cast<char*>(newCacheName);
    int existingCacheIndex = 0;
    while (*newCachePointer != '\0') {
        if (*newCachePointer != existingCacheName[existingCacheIndex]) return false;
        newCachePointer++;
        existingCacheIndex++;
    }
    return true;
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
    if (sizeof(kmem_slab_t) + sizeof(int) * 2 + objectSizeInBytes * 2 > BLOCK_SIZE * 2) return 1;
    size_t numberOfSlots = 0;
    while (sizeof(kmem_slab_t) + numberOfSlots * sizeof(int) + numberOfSlots * objectSizeInBytes <= BLOCK_SIZE * 2) {
        numberOfSlots++;
    }
    return --numberOfSlots;
}

kmem_slab_t* SlabAllocator::getSlabWithFreeObject(kmem_cache_t* cache) {
    kmem_slab_t* slab;
    if (cache->headOfDirtySlabsList && cache->headOfDirtySlabsList->numberOfFreeSlots > 0) {
        slab = cache->headOfDirtySlabsList;
    } else if (cache->headOfFreeSlabsList && cache->headOfFreeSlabsList->numberOfFreeSlots > 0) {
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
    if (newFreeSlab == nullptr) return newFreeSlab;
    cache->cacheSizeInBlocks += (1 << BuddyAllocator::getExponentForNumberOfBytes(totalSlabSizeInBytes));
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
    if (cache->objectConstructor) callConstructorForAllObjectsInSlab(cache, newFreeSlab);
    newFreeSlab->nextSlab = cache->headOfFreeSlabsList;
    cache->headOfFreeSlabsList = newFreeSlab;
    return newFreeSlab;
}

void SlabAllocator::callConstructorForAllObjectsInSlab(kmem_cache_t* cache, kmem_slab_t* slab) {
    for (size_t i = 0; i < cache->numberOfObjectsInOneSlab; i++) {
        void* object = reinterpret_cast<char*>(slab) + sizeof(kmem_slab_t) +
                       sizeof(int) * cache->numberOfObjectsInOneSlab + i * cache->objectSizeInBytes;
        cache->objectConstructor(object);
    }
}

void* SlabAllocator::getObjectFromSlab(kmem_cache_t* cache, kmem_slab_t* slab) {
    if (slab == nullptr) return nullptr;
    void* object = reinterpret_cast<char*>(slab) + sizeof(kmem_slab_t) + sizeof(int) * cache->numberOfObjectsInOneSlab +
                   slab->firstFreeSlotIndex * cache->objectSizeInBytes;
    slab->firstFreeSlotIndex = slab->slots[slab->firstFreeSlotIndex];
    slab->numberOfFreeSlots--;
    moveSlabToCorrectSlabListAfterAllocation(cache, slab);
    return object;
}

void SlabAllocator::moveSlabToCorrectSlabListAfterAllocation(kmem_cache_t* cache, kmem_slab_t* slab) {
    if (slab->numberOfFreeSlots == 0 && cache->numberOfObjectsInOneSlab > 1) {
        moveSlabFromDirtyToFullList(cache, slab);
    } else if (slab->numberOfFreeSlots == 0) {
        moveSlabFromFreeToFullList(cache, slab);
    } else if (slab->numberOfFreeSlots == cache->numberOfObjectsInOneSlab - 1) {
        moveSlabFromFreeToDirtyList(cache, slab);
    }
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

void SlabAllocator::moveSlabFromFreeToDirtyList(kmem_cache_t* cache, kmem_slab_t* slab) {
    cache->headOfFreeSlabsList = cache->headOfFreeSlabsList->nextSlab;
    slab->nextSlab = cache->headOfDirtySlabsList;
    cache->headOfDirtySlabsList = slab;
}

bool SlabAllocator::deallocateObjectInSlabList(kmem_cache_t* cache, kmem_slab_t* headOfSlabList, void* objectPointer) {
    for (kmem_slab_t* currentSlab = headOfSlabList; currentSlab; currentSlab = currentSlab->nextSlab) {
        size_t firstObjectAddressInCurrentSlab = getFirstObjectAddressInSlab(cache, currentSlab);
        size_t lastObjectAddressInCurrentSlab = getLastObjectAddressInSlab(cache, currentSlab);
        size_t currentObjectAddress = firstObjectAddressInCurrentSlab;
        int objectIndex = 0;
        while (currentObjectAddress <= lastObjectAddressInCurrentSlab) {
            if (reinterpret_cast<size_t>(objectPointer) == currentObjectAddress) {
                if (cache->objectDestructor) cache->objectDestructor(objectPointer);
                if (cache->objectConstructor) cache->objectConstructor(objectPointer);
                currentSlab->numberOfFreeSlots++;
                currentSlab->slots[objectIndex] = currentSlab->firstFreeSlotIndex;
                currentSlab->firstFreeSlotIndex = objectIndex;
                moveSlabToCorrectSlabListAfterDeallocation(cache, currentSlab);
                return true;
            }
            currentObjectAddress += cache->objectSizeInBytes;
            objectIndex++;
        }
    }
    return false;
}

size_t SlabAllocator::getFirstObjectAddressInSlab(kmem_cache_t* cache, kmem_slab_t* slab) {
    return reinterpret_cast<size_t>(slab) + sizeof(kmem_slab_t) + sizeof(int) * cache->numberOfObjectsInOneSlab;
}

size_t SlabAllocator::getLastObjectAddressInSlab(kmem_cache_t* cache, kmem_slab_t* slab) {
    return getFirstObjectAddressInSlab(cache, slab) + (cache->numberOfObjectsInOneSlab - 1) * cache->objectSizeInBytes;
}

void SlabAllocator::moveSlabToCorrectSlabListAfterDeallocation(kmem_cache_t* cache, kmem_slab_t* slab) {
    if (slab->numberOfFreeSlots == 1 && cache->numberOfObjectsInOneSlab > 1) {
        changeSlabListAfterDeallocation(slab, cache->headOfFullSlabsList, cache->headOfDirtySlabsList);
    } else if (slab->numberOfFreeSlots == 1) {
        changeSlabListAfterDeallocation(slab, cache->headOfFullSlabsList, cache->headOfFreeSlabsList);
    } else if (slab->numberOfFreeSlots == cache->numberOfObjectsInOneSlab) {
        changeSlabListAfterDeallocation(slab, cache->headOfDirtySlabsList, cache->headOfFreeSlabsList);
    }
}

void SlabAllocator::changeSlabListAfterDeallocation(kmem_slab_t* slab, kmem_slab_t*& headOfCurrentList, kmem_slab_t*& headOfNewList) {
    kmem_slab_t* previousSlab = nullptr;
    for (kmem_slab_t* currentSlab = headOfCurrentList; currentSlab; currentSlab = currentSlab->nextSlab) {
        if (currentSlab == slab) {
            if (previousSlab) {
                previousSlab->nextSlab = currentSlab->nextSlab;
            } else {
                headOfCurrentList = headOfCurrentList->nextSlab;
            }
            currentSlab->nextSlab = headOfNewList;
            headOfNewList = currentSlab;
            return;
        }
        previousSlab = currentSlab;
    }
}

const char* SlabAllocator::getBufferCacheName(size_t exponent) {
    char allDigits[] = "0123456789";
    const int NUMBER_BASE = 10;
    char* bufferCacheName = const_cast<char*>("size-");
    char reverseExponentString[3];
    int reverseExponentStringPosition = 0, bufferCacheNamePosition = 5;
    do {
        reverseExponentString[reverseExponentStringPosition++] = allDigits[exponent % NUMBER_BASE];
    } while((exponent /= NUMBER_BASE) != 0);
    reverseExponentString[reverseExponentStringPosition] = '\0';

    while (--reverseExponentStringPosition >= 0)
        bufferCacheName[bufferCacheNamePosition++] = reverseExponentString[reverseExponentStringPosition];
    bufferCacheName[bufferCacheNamePosition] = '\0';
    return bufferCacheName;
}

int SlabAllocator::getTotalNumberOfFreeSlotsInFreeSlabsList(kmem_cache_t* cache) {
    int totalNumberOfFreeSlots = 0;
    for (kmem_slab_t* currentSlab = cache->headOfFreeSlabsList; currentSlab; currentSlab = currentSlab->nextSlab) {
        totalNumberOfFreeSlots += currentSlab->numberOfFreeSlots;
    }
    return totalNumberOfFreeSlots;
}

int SlabAllocator::getTotalNumberOfFreeSlotsInDirtySlabsList(kmem_cache_t* cache) {
    int totalNumberOfFreeSlots = 0;
    for (kmem_slab_t* currentSlab = cache->headOfDirtySlabsList; currentSlab; currentSlab = currentSlab->nextSlab) {
        totalNumberOfFreeSlots += currentSlab->numberOfFreeSlots;
    }
    return totalNumberOfFreeSlots;
}

int SlabAllocator::getTotalNumberOfFreeSlotsInFullSlabsList(kmem_cache_t* cache) {
    int totalNumberOfFreeSlots = 0;
    for (kmem_slab_t* currentSlab = cache->headOfFullSlabsList; currentSlab; currentSlab = currentSlab->nextSlab) {
        totalNumberOfFreeSlots += currentSlab->numberOfFreeSlots;
    }
    return totalNumberOfFreeSlots;
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