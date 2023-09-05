#include "../../../h/Code/MemoryAllocator/slab.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

void kmem_init(void *space, int block_num) {
    BuddyAllocator::getInstance().setup(space, block_num);
}

kmem_cache_t *kmem_cache_create(const char *name, size_t size, void (*ctor)(void *), void (*dtor)(void *)) {
    return nullptr;
}