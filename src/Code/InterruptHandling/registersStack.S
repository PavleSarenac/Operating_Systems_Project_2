.extern _ZN5Riscv21pushSysCallParametersEv
.global _ZN5Riscv21pushSysCallParametersEv
.type _ZN5Riscv21pushSysCallParametersEv, @function
_ZN5Riscv21pushSysCallParametersEv:

    .irp index, 0,1,2,3,4,5,6,7
    sd a\index,\index*8(sp)
    .endr

    ret

.extern _ZN5Riscv17pushMostRegistersEv
.global _ZN5Riscv17pushMostRegistersEv
.type _ZN5Riscv17pushMostRegistersEv, @function
_ZN5Riscv17pushMostRegistersEv:
    // iako se cuvaju samo registri x3..x31 na steku (dakle, dovoljno je 8*29=232 bajta), 232 nije deljivo sa 16, a adresa na koju pokazuje sp
    // uvek mora biti deljiva sa 16, tako da zato alociramo 256 bajtova na steku - 256 je deljivo sa 16
    addi sp,sp,-256

    // cuvanje registara x3..x31 na steku
    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr

    ret

.extern _ZN5Riscv16popMostRegistersEv
.global _ZN5Riscv16popMostRegistersEv
.type _ZN5Riscv16popMostRegistersEv, @function
_ZN5Riscv16popMostRegistersEv:

    // restauracija registara x3..x31 sa steka
    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr

    // ciscenje steka
    addi sp,sp,256

    ret