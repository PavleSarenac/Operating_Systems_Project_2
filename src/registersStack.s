# 1 "src/registersStack.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/riscv64-linux-gnu/include/stdc-predef.h" 1 3
# 32 "<command-line>" 2
# 1 "src/registersStack.S"
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


    addi sp,sp,-256


    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr

    ret

.extern _ZN5Riscv16popMostRegistersEv
.global _ZN5Riscv16popMostRegistersEv
.type _ZN5Riscv16popMostRegistersEv, @function
_ZN5Riscv16popMostRegistersEv:


    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr


    addi sp,sp,256

    ret
