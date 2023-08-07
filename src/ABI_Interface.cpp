#include "../h/ABI_Interface.h"

// ova funkcija predstavlja ABI (Application Binary Interface) - binarni INTERFEJS sistemskih poziva koji se vrse pomocu softverskog prekida (ecall)
// ciljnog procesora; ABI interfejs obezbedjuje prenos argumenata sistemskog poziva preko registara procesora, prelazak u privilegovani rezim rada
// procesora i prelazak na kod jezgra;
// implementacija prekidne rutine (supervisorTrap) predstavlja IMPLEMENTACIJU ABI sloja interfejsa jezgra
void prepareArgsAndEcall(sysCallArgs* ptr) {
    __asm__ volatile ("mv a1,%[arg1]" : : [arg1] "r"(ptr->arg1)); // upis parametra ovog sistemskog poziva u registar a1
    __asm__ volatile ("mv a2,%[arg2]" : : [arg2] "r"(ptr->arg2)); // upis parametra ovog sistemskog poziva u registar a2
    __asm__ volatile ("mv a3,%[arg3]" : : [arg3] "r"(ptr->arg3)); // upis parametra ovog sistemskog poziva u registar a3
    __asm__ volatile ("mv a4,%[arg4]" : : [arg4] "r"(ptr->arg4)); // upis parametra ovog sistemskog poziva u registar a4
    __asm__ volatile ("mv a0,%[arg0]" : : [arg0] "r"(ptr->arg0)); // upis koda sistemskog poziva u registar a0
    __asm__ volatile ("ecall"); // instrukcija softverskog prekida
}