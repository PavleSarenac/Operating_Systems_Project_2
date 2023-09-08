#include "../../../h/Code/MemoryAllocator/slab.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"
#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"

void kmem_init(void *space, int block_num) {
    BuddyAllocator::getInstance().setup(space, block_num);
}

kmem_cache_t *kmem_cache_create(const char *name, size_t size, void (*ctor)(void *), void (*dtor)(void *)) {
    if (name == nullptr || size <= 0) return nullptr;
    return SlabAllocator::createCache(name, size, ctor, dtor);
}

void *kmem_cache_alloc(kmem_cache_t *cachep) {
    if (!cachep) return nullptr;
    return SlabAllocator::allocateObject(cachep);
}

void kmem_cache_free(kmem_cache_t *cachep, void *objp) {
    if (cachep == nullptr || objp == nullptr) return;
    SlabAllocator::deallocateObject(cachep, objp);
}

void *kmalloc(size_t size) {
    if (size <= 0) return nullptr;
    return SlabAllocator::allocateBuffer(size);
}

void kfree(const void *objp) {
    if (objp == nullptr) return;
    SlabAllocator::deallocateBuffer(objp);
}

void kmem_cache_info(kmem_cache_t *cachep) {
    if (!cachep) return;
    SlabAllocator::printCacheInfo(cachep);
}