#ifndef SLABALLOCATOR_HPP
#define SLABALLOCATOR_HPP

#include "../../../lib/hw.h"

class SlabAllocator {
public:
    static SlabAllocator& getInstance();

    SlabAllocator(const SlabAllocator&) = delete;

    void operator=(const SlabAllocator&) = delete;
private:
    SlabAllocator();
};

#endif
