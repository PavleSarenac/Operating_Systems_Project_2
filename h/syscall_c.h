#ifndef SYSCALL_C_H
#define SYSCALL_C_H

#include "../lib/hw.h"
#include "ABI_Interface.h"

void* mem_alloc(size_t size);
int mem_free(void* ptr);

class _thread;
typedef _thread* thread_t;
int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg);
int thread_exit();
void thread_dispatch();
int thread_create_cpp(thread_t* handle, void(*start_routine)(void*), void* arg);
int scheduler_put(thread_t thread);
int getThreadId();

class _sem;
typedef _sem* sem_t;
int sem_open(sem_t* handle, unsigned init);
int sem_close(sem_t handle);
int sem_wait(sem_t id);
int sem_signal(sem_t id);

int time_sleep(time_t time);

const int EOF = -1;
char getc();
void putc(char c);

void switchSupervisorToUser();
void switchUserToSupervisor();

#endif