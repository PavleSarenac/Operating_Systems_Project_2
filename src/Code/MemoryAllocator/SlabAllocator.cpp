#include "../../../h/Code/MemoryAllocator/SlabAllocator.hpp"

SlabAllocator& SlabAllocator::getInstance() {
    static SlabAllocator slabAllocator;
    return slabAllocator;
}

