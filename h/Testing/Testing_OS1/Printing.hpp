#ifndef PRINTING_HPP
#define PRINTING_HPP

#include "../../Code/SystemCalls/syscall_c.hpp"

typedef unsigned long uint64;

extern "C" uint64 copy_and_swap(uint64 &lock, uint64 expected, uint64 desired);

void printString(char const *string);

char* getString(char *buf, int max);

int stringToInt(const char *s);

void printInt(int xx, int base=10, int sgn=0);

void printSizet(unsigned long long xx, int base=10);

#endif