.extern _ZN5Riscv20handleSupervisorTrapEv // uvoz funkcije za obradu sistemskog poziva/prekida/izuzetka
.align 4 // adresa prekidne rutine mora poravnata na 4 bajta (da bi poslednja 2 bita bila 0 - onda ce se, po dokumentaciji, skociti bas na tu adresu)
.global _ZN5Riscv14supervisorTrapEv // izvoz prekidne rutine (supervisorTrap) tako da bude vidljiva u globalnom prostoru
.type _ZN5Riscv14supervisorTrapEv, @function // naglasavanje prevodiocu da prekidna rutina (supervisorTrap) predstavlja funkciju
_ZN5Riscv14supervisorTrapEv:
    // alokacija prostora na steku za vrednosti svih 32 registra opste namene (x0..x31)
    addi sp,sp,-256

    // cuvanje svih programski dostupnih registara (koji su dostupni i u korisnickom i u sistemskog rezimu) na steku
    // https://sourceware.org/binutils/docs/as/Irp.html - ovde je definisana "assembly petlja" iskoriscena ispod
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr

    // poziv funkcije handleSupervisorTrap koja treba da obradi sistemski poziv/prekid/izuzetak u zavisnosti od razloga ulaska u prekidnu rutinu
    call _ZN5Riscv20handleSupervisorTrapEv

    // restauracija svih programski dostupnih registara (koji su dostupni i u korisnickom i u sistemskog rezimu) - x0..x31
    // https://sourceware.org/binutils/docs/as/Irp.html - ovde je definisana "assembly petlja" iskoriscena ispod
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index,\index*8(sp)
    .endr

    // ciscenje steka - dealokacija prostora
    addi sp,sp,256

    sret