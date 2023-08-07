#ifndef Z_NJIHOVO_BUFFER_HPP
#define Z_NJIHOVO_BUFFER_HPP

#include "../h/syscall_c.h"
#include "Z_Njihovo_Printing.hpp"

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

#endif