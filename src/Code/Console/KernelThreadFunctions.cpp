#include "../../../h/Code/Console/KernelThreadFunctions.hpp"
#include "../../../h/Code/Console/KernelBuffer.hpp"

void putcKernelThreadFunction(void* arg) {
    switchUserToSupervisor();
    while (true) {
        while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
            // sve dok je konzola spremna da primi podatak saljemo joj
            char newCharacter = KernelBuffer::putcGetInstance()->removeFromBuffer();
            if (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
                *reinterpret_cast<char*>(CONSOLE_TX_DATA) = newCharacter;
            }
        }
    }
}