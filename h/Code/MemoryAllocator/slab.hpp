#ifndef SLAB_HPP
#define SLAB_HPP

#include "../../../lib/hw.h"

#define BLOCK_SIZE (4096)
#define MAX_CACHE_NAME_LENGTH (15)
typedef struct kmem_slab_s {
    size_t numberOfFreeSlots;
    int firstFreeSlotIndex;
    kmem_slab_s* nextSlab;
    int slots[];
} kmem_slab_t;
typedef struct kmem_cache_s {
    char cacheName[MAX_CACHE_NAME_LENGTH];
    size_t objectSizeInBytes;
    size_t cacheSizeInBlocks;
    size_t numberOfSlabs;
    size_t numberOfObjectsInOneSlab;
    void (*objectConstructor)(void*);
    void (*objectDestructor)(void*);
    kmem_slab_t* headOfFreeSlabsList;
    kmem_slab_t* headOfDirtySlabsList;
    kmem_slab_t* headOfFullSlabsList;
    kmem_cache_s* nextCache;
} kmem_cache_t;

void kmem_init(void *space, int block_num);
kmem_cache_t *kmem_cache_create(const char *name, size_t size,
                                void (*ctor)(void *), void (*dtor)(void *)); // Allocate cache
int kmem_cache_shrink(kmem_cache_t *cachep); // Shrink cache
void *kmem_cache_alloc(kmem_cache_t *cachep); // Allocate one object from cache
void kmem_cache_free(kmem_cache_t *cachep, void *objp); // Deallocate one object from cache
void *kmalloc(size_t size); // Alloacate one small memory buffer
void kfree(const void *objp); // Deallocate one small memory buffer
void kmem_cache_destroy(kmem_cache_t *cachep); // Deallocate cache
void kmem_cache_info(kmem_cache_t *cachep); // Print cache info
int kmem_cache_error(kmem_cache_t *cachep); // Print error message

#endif