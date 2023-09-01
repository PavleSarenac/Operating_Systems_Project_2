#include "../../../h/Code/MemoryAllocator/slab.hpp"
#include "../../../h/Code/MemoryAllocator/BuddyAllocator.hpp"

void kmem_init(void *space, int block_num) {
    BuddyAllocator::getInstance().setup(space, block_num);
}