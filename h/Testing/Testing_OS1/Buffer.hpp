#ifndef BUFFER_HPP
#define BUFFER_HPP

#include "../../Code/SystemCalls/syscall_c.h"
#include "Printing.hpp"

namespace BufferTestC {
    class Buffer {
    private:
        int cap;
        int *buffer;
        int head, tail;

        sem_t spaceAvailable;
        sem_t itemAvailable;
        sem_t mutexHead;
        sem_t mutexTail;

    public:
        Buffer(int _cap);
        ~Buffer();

        void put(int val);
        int get();

        int getCnt();

    };
}

#endif