#ifndef PERIODIC_THREADS_CPP_API_TEST_HPP
#define PERIODIC_THREADS_CPP_API_TEST_HPP

#include "../../Code/SystemCalls/syscall_cpp.hpp"

namespace PeriodicThreadsTest {
    Semaphore* myOwnMutex;
    Semaphore* myOwnWaitForAll;

    class A : public PeriodicThread {
    public:
        explicit A(time_t period) : PeriodicThread(period) {}

    protected:
        void run() override {
            while (!shouldThisThreadEnd) {
                periodicActivation();
                time_sleep(sleepTime);
            }
            myOwnWaitForAll->signal();
        }

    private:
        void periodicActivation() override {
            myOwnMutex->wait();
            putc('A');
            putc('\n');
            myOwnMutex->signal();
        }
    };

    class B : public PeriodicThread {
    public:
        explicit B(time_t period) : PeriodicThread(period) {}

    protected:
        void run() override {
            while (!shouldThisThreadEnd) {
                periodicActivation();
                time_sleep(sleepTime);
            }
            myOwnWaitForAll->signal();
        }

    private:
        void periodicActivation() override {
            myOwnMutex->wait();
            putc('B');
            putc('\n');
            myOwnMutex->signal();
        }
    };

    class C : public PeriodicThread {
    public:
        explicit C(time_t period) : PeriodicThread(period) {}

    protected:
        void run() override {
            while (!shouldThisThreadEnd) {
                periodicActivation();
                time_sleep(sleepTime);
            }
            myOwnWaitForAll->signal();
        }

    private:
        void periodicActivation() override {
            myOwnMutex->wait();
            putc('C');
            putc('\n');
            myOwnMutex->signal();
        }
    };

    void Periodic_Threads_CPP_API_Test() {
        myOwnMutex = new Semaphore();
        myOwnWaitForAll = new Semaphore(0);

        A* a = new A(5);
        B* b = new B(5);
        C* c = new C(5);

        PeriodicThread* threads[3];
        threads[0] = a;
        threads[1] = b;
        threads[2] = c;

        threads[0]->start();
        threads[1]->start();
        threads[2]->start();

        int endThis = 0;
        for (int i = 0; i < 3; i++) {
            char chr = getc();
            if (chr == 'k') {
                threads[endThis++]->endPeriodicThread();
            } else {
                i--;
            }
        }

        for (int i = 0; i < 3; i++) {
            myOwnWaitForAll->wait();
        }

        delete myOwnMutex;
        delete myOwnWaitForAll;
    }
}

#endif
