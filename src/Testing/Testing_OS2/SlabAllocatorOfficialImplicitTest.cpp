#include "../../../h/Code/SystemCalls/syscall_c.hpp"
#include "../../../h/Code/SystemCalls/syscall_cpp.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"
#include "../../../h/Testing/Testing_OS2/SlabAllocatorOfficialImplicitTest.hpp"
#include "../../../h/Code/MemoryAllocator/MemoryAllocationHelperFunctions.hpp"
#include "../../../h/Code/Console/KernelBuffer.hpp"

struct thread_data {
    int id;
};

class ForkThread : public Thread {
public:
    ForkThread(long _id) noexcept : Thread(), id(_id), finished(false) {}
    virtual void run()  {
        printString("Started thread id:");
        printSizet(id);
        printString("\n");

        MemoryAllocationHelperFunctions::printFirstFitAllocatorInfo();
        printString("\n");
        MemoryAllocationHelperFunctions::printBuddyAllocatorInfo();

        ForkThread* thread = new ForkThread(id + 1);
        ForkThread** threads = (ForkThread** ) mem_alloc(sizeof(ForkThread*) * id);

        if (threads != nullptr) {
            for (long i = 0; i < id; i++) {
                threads[i] = new ForkThread(id);
            }

            if (thread != nullptr) {
                if (thread->start() == 0) {

                    for (int i = 0; i < 5000; i++) {
                        for (int j = 0; j < 5000; j++) {

                        }
                        thread_dispatch();
                    }

                    while (!thread->isFinished()) {
                        thread_dispatch();
                    }
                }
                delete thread;
            }

            for (long i = 0; i < id; i++) {
                delete threads[i];
            }

            mem_free(threads);
        }

        printString("Finished thread id:");
        printSizet(id);
        printString("\n");

        MemoryAllocationHelperFunctions::printFirstFitAllocatorInfo();
        printString("\n");
        MemoryAllocationHelperFunctions::printBuddyAllocatorInfo();
        printString("\n");
        kmem_cache_t* cache = kmem_cache_create("KernelBuffer", sizeof(KernelBuffer), nullptr, nullptr);
        kmem_cache_info(cache);
        kmem_cache_t* cache2 = kmem_cache_create("size-12", (1 << 14), nullptr, nullptr);
        kmem_cache_info(cache2);

        finished = true;
    }

    bool isFinished() const {
        return finished;
    }

private:
    long id;
    bool finished;
};


void userMainSlabAllocatorOfficialImplicitTest() {
    ForkThread thread(1);

    thread.start();

    while (!thread.isFinished()) {
        thread_dispatch();
    }

    printString("User main finished\n");
}
