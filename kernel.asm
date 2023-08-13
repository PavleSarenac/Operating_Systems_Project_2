
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	ca013103          	ld	sp,-864(sp) # 8000bca0 <_GLOBAL_OFFSET_TABLE_+0x48>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	6fd060ef          	jal	ra,80006f18 <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <copy_and_swap>:
# a2 holds desired value
# a0 holds return value, 0 if successful, !0 otherwise

.global copy_and_swap
copy_and_swap:
    lr.w t0, (a0)          # Load original value.
    80001000:	100522af          	lr.w	t0,(a0)
    bne t0, a1, fail       # Doesn’t match, so fail.
    80001004:	00b29a63          	bne	t0,a1,80001018 <fail>
    sc.w t0, a2, (a0)      # Try to update.
    80001008:	18c522af          	sc.w	t0,a2,(a0)
    bnez t0, copy_and_swap # Retry if store-conditional failed.
    8000100c:	fe029ae3          	bnez	t0,80001000 <copy_and_swap>
    li a0, 0               # Set return to success.
    80001010:	00000513          	li	a0,0
    jr ra                  # Return.
    80001014:	00008067          	ret

0000000080001018 <fail>:
    fail:
    li a0, 1               # Set return to failure.
    80001018:	00100513          	li	a0,1
    8000101c:	00008067          	ret

0000000080001020 <_ZN5Riscv21pushSysCallParametersEv>:
.type _ZN5Riscv21pushSysCallParametersEv, @function
_ZN5Riscv21pushSysCallParametersEv:

    .irp index, 0,1,2,3,4,5,6,7
    sd a\index,\index*8(sp)
    .endr
    80001020:	00a13023          	sd	a0,0(sp)
    80001024:	00b13423          	sd	a1,8(sp)
    80001028:	00c13823          	sd	a2,16(sp)
    8000102c:	00d13c23          	sd	a3,24(sp)
    80001030:	02e13023          	sd	a4,32(sp)
    80001034:	02f13423          	sd	a5,40(sp)
    80001038:	03013823          	sd	a6,48(sp)
    8000103c:	03113c23          	sd	a7,56(sp)

    ret
    80001040:	00008067          	ret

0000000080001044 <_ZN5Riscv17pushMostRegistersEv>:
.global _ZN5Riscv17pushMostRegistersEv
.type _ZN5Riscv17pushMostRegistersEv, @function
_ZN5Riscv17pushMostRegistersEv:
    // iako se cuvaju samo registri x3..x31 na steku (dakle, dovoljno je 8*29=232 bajta), 232 nije deljivo sa 16, a adresa na koju pokazuje sp
    // uvek mora biti deljiva sa 16, tako da zato alociramo 256 bajtova na steku - 256 je deljivo sa 16
    addi sp,sp,-256
    80001044:	f0010113          	addi	sp,sp,-256

    // cuvanje registara x3..x31 na steku
    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr
    80001048:	00313c23          	sd	gp,24(sp)
    8000104c:	02413023          	sd	tp,32(sp)
    80001050:	02513423          	sd	t0,40(sp)
    80001054:	02613823          	sd	t1,48(sp)
    80001058:	02713c23          	sd	t2,56(sp)
    8000105c:	04813023          	sd	s0,64(sp)
    80001060:	04913423          	sd	s1,72(sp)
    80001064:	04a13823          	sd	a0,80(sp)
    80001068:	04b13c23          	sd	a1,88(sp)
    8000106c:	06c13023          	sd	a2,96(sp)
    80001070:	06d13423          	sd	a3,104(sp)
    80001074:	06e13823          	sd	a4,112(sp)
    80001078:	06f13c23          	sd	a5,120(sp)
    8000107c:	09013023          	sd	a6,128(sp)
    80001080:	09113423          	sd	a7,136(sp)
    80001084:	09213823          	sd	s2,144(sp)
    80001088:	09313c23          	sd	s3,152(sp)
    8000108c:	0b413023          	sd	s4,160(sp)
    80001090:	0b513423          	sd	s5,168(sp)
    80001094:	0b613823          	sd	s6,176(sp)
    80001098:	0b713c23          	sd	s7,184(sp)
    8000109c:	0d813023          	sd	s8,192(sp)
    800010a0:	0d913423          	sd	s9,200(sp)
    800010a4:	0da13823          	sd	s10,208(sp)
    800010a8:	0db13c23          	sd	s11,216(sp)
    800010ac:	0fc13023          	sd	t3,224(sp)
    800010b0:	0fd13423          	sd	t4,232(sp)
    800010b4:	0fe13823          	sd	t5,240(sp)
    800010b8:	0ff13c23          	sd	t6,248(sp)

    ret
    800010bc:	00008067          	ret

00000000800010c0 <_ZN5Riscv16popMostRegistersEv>:
_ZN5Riscv16popMostRegistersEv:

    // restauracija registara x3..x31 sa steka
    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr
    800010c0:	00313c23          	sd	gp,24(sp)
    800010c4:	02413023          	sd	tp,32(sp)
    800010c8:	02513423          	sd	t0,40(sp)
    800010cc:	02613823          	sd	t1,48(sp)
    800010d0:	02713c23          	sd	t2,56(sp)
    800010d4:	04813023          	sd	s0,64(sp)
    800010d8:	04913423          	sd	s1,72(sp)
    800010dc:	04a13823          	sd	a0,80(sp)
    800010e0:	04b13c23          	sd	a1,88(sp)
    800010e4:	06c13023          	sd	a2,96(sp)
    800010e8:	06d13423          	sd	a3,104(sp)
    800010ec:	06e13823          	sd	a4,112(sp)
    800010f0:	06f13c23          	sd	a5,120(sp)
    800010f4:	09013023          	sd	a6,128(sp)
    800010f8:	09113423          	sd	a7,136(sp)
    800010fc:	09213823          	sd	s2,144(sp)
    80001100:	09313c23          	sd	s3,152(sp)
    80001104:	0b413023          	sd	s4,160(sp)
    80001108:	0b513423          	sd	s5,168(sp)
    8000110c:	0b613823          	sd	s6,176(sp)
    80001110:	0b713c23          	sd	s7,184(sp)
    80001114:	0d813023          	sd	s8,192(sp)
    80001118:	0d913423          	sd	s9,200(sp)
    8000111c:	0da13823          	sd	s10,208(sp)
    80001120:	0db13c23          	sd	s11,216(sp)
    80001124:	0fc13023          	sd	t3,224(sp)
    80001128:	0fd13423          	sd	t4,232(sp)
    8000112c:	0fe13823          	sd	t5,240(sp)
    80001130:	0ff13c23          	sd	t6,248(sp)

    // ciscenje steka
    addi sp,sp,256
    80001134:	10010113          	addi	sp,sp,256

    80001138:	00008067          	ret
    8000113c:	0000                	unimp
	...

0000000080001140 <_ZN5Riscv14supervisorTrapEv>:
.align 4 // adresa prekidne rutine mora poravnata na 4 bajta (da bi poslednja 2 bita bila 0 - onda ce se, po dokumentaciji, skociti bas na tu adresu)
.global _ZN5Riscv14supervisorTrapEv // izvoz prekidne rutine (supervisorTrap) tako da bude vidljiva u globalnom prostoru
.type _ZN5Riscv14supervisorTrapEv, @function // naglasavanje prevodiocu da prekidna rutina (supervisorTrap) predstavlja funkciju
_ZN5Riscv14supervisorTrapEv:
    // alokacija prostora na steku za vrednosti svih 32 registra opste namene (x0..x31)
    addi sp,sp,-256
    80001140:	f0010113          	addi	sp,sp,-256

    // cuvanje svih programski dostupnih registara (koji su dostupni i u korisnickom i u sistemskog rezimu) na steku
    // https://sourceware.org/binutils/docs/as/Irp.html - ovde je definisana "assembly petlja" iskoriscena ispod
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index,\index*8(sp)
    .endr
    80001144:	00013023          	sd	zero,0(sp)
    80001148:	00113423          	sd	ra,8(sp)
    8000114c:	00213823          	sd	sp,16(sp)
    80001150:	00313c23          	sd	gp,24(sp)
    80001154:	02413023          	sd	tp,32(sp)
    80001158:	02513423          	sd	t0,40(sp)
    8000115c:	02613823          	sd	t1,48(sp)
    80001160:	02713c23          	sd	t2,56(sp)
    80001164:	04813023          	sd	s0,64(sp)
    80001168:	04913423          	sd	s1,72(sp)
    8000116c:	04a13823          	sd	a0,80(sp)
    80001170:	04b13c23          	sd	a1,88(sp)
    80001174:	06c13023          	sd	a2,96(sp)
    80001178:	06d13423          	sd	a3,104(sp)
    8000117c:	06e13823          	sd	a4,112(sp)
    80001180:	06f13c23          	sd	a5,120(sp)
    80001184:	09013023          	sd	a6,128(sp)
    80001188:	09113423          	sd	a7,136(sp)
    8000118c:	09213823          	sd	s2,144(sp)
    80001190:	09313c23          	sd	s3,152(sp)
    80001194:	0b413023          	sd	s4,160(sp)
    80001198:	0b513423          	sd	s5,168(sp)
    8000119c:	0b613823          	sd	s6,176(sp)
    800011a0:	0b713c23          	sd	s7,184(sp)
    800011a4:	0d813023          	sd	s8,192(sp)
    800011a8:	0d913423          	sd	s9,200(sp)
    800011ac:	0da13823          	sd	s10,208(sp)
    800011b0:	0db13c23          	sd	s11,216(sp)
    800011b4:	0fc13023          	sd	t3,224(sp)
    800011b8:	0fd13423          	sd	t4,232(sp)
    800011bc:	0fe13823          	sd	t5,240(sp)
    800011c0:	0ff13c23          	sd	t6,248(sp)

    // poziv funkcije handleSupervisorTrap koja treba da obradi sistemski poziv/prekid/izuzetak u zavisnosti od razloga ulaska u prekidnu rutinu
    call _ZN5Riscv20handleSupervisorTrapEv
    800011c4:	6f9000ef          	jal	ra,800020bc <_ZN5Riscv20handleSupervisorTrapEv>

    // restauracija svih programski dostupnih registara (koji su dostupni i u korisnickom i u sistemskog rezimu) - x0..x31
    // https://sourceware.org/binutils/docs/as/Irp.html - ovde je definisana "assembly petlja" iskoriscena ispod
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index,\index*8(sp)
    .endr
    800011c8:	00013003          	ld	zero,0(sp)
    800011cc:	00813083          	ld	ra,8(sp)
    800011d0:	01013103          	ld	sp,16(sp)
    800011d4:	01813183          	ld	gp,24(sp)
    800011d8:	02013203          	ld	tp,32(sp)
    800011dc:	02813283          	ld	t0,40(sp)
    800011e0:	03013303          	ld	t1,48(sp)
    800011e4:	03813383          	ld	t2,56(sp)
    800011e8:	04013403          	ld	s0,64(sp)
    800011ec:	04813483          	ld	s1,72(sp)
    800011f0:	05013503          	ld	a0,80(sp)
    800011f4:	05813583          	ld	a1,88(sp)
    800011f8:	06013603          	ld	a2,96(sp)
    800011fc:	06813683          	ld	a3,104(sp)
    80001200:	07013703          	ld	a4,112(sp)
    80001204:	07813783          	ld	a5,120(sp)
    80001208:	08013803          	ld	a6,128(sp)
    8000120c:	08813883          	ld	a7,136(sp)
    80001210:	09013903          	ld	s2,144(sp)
    80001214:	09813983          	ld	s3,152(sp)
    80001218:	0a013a03          	ld	s4,160(sp)
    8000121c:	0a813a83          	ld	s5,168(sp)
    80001220:	0b013b03          	ld	s6,176(sp)
    80001224:	0b813b83          	ld	s7,184(sp)
    80001228:	0c013c03          	ld	s8,192(sp)
    8000122c:	0c813c83          	ld	s9,200(sp)
    80001230:	0d013d03          	ld	s10,208(sp)
    80001234:	0d813d83          	ld	s11,216(sp)
    80001238:	0e013e03          	ld	t3,224(sp)
    8000123c:	0e813e83          	ld	t4,232(sp)
    80001240:	0f013f03          	ld	t5,240(sp)
    80001244:	0f813f83          	ld	t6,248(sp)

    // ciscenje steka - dealokacija prostora
    addi sp,sp,256
    80001248:	10010113          	addi	sp,sp,256

    8000124c:	10200073          	sret

0000000080001250 <_ZN13BufferTestCPP9BufferCPPC1Ei>:
#include "../../../h/Testing/Testing_OS1/Buffer_CPP_API.hpp"

BufferTestCPP::BufferCPP::BufferCPP(int _cap) : cap(_cap + 1), head(0), tail(0) {
    80001250:	fd010113          	addi	sp,sp,-48
    80001254:	02113423          	sd	ra,40(sp)
    80001258:	02813023          	sd	s0,32(sp)
    8000125c:	00913c23          	sd	s1,24(sp)
    80001260:	01213823          	sd	s2,16(sp)
    80001264:	01313423          	sd	s3,8(sp)
    80001268:	03010413          	addi	s0,sp,48
    8000126c:	00050493          	mv	s1,a0
    80001270:	00058913          	mv	s2,a1
    80001274:	0015879b          	addiw	a5,a1,1
    80001278:	0007851b          	sext.w	a0,a5
    8000127c:	00f4a023          	sw	a5,0(s1)
    80001280:	0004a823          	sw	zero,16(s1)
    80001284:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    80001288:	00251513          	slli	a0,a0,0x2
    8000128c:	00005097          	auipc	ra,0x5
    80001290:	040080e7          	jalr	64(ra) # 800062cc <_Z9mem_allocm>
    80001294:	00a4b423          	sd	a0,8(s1)
    itemAvailable = new Semaphore(0);
    80001298:	01000513          	li	a0,16
    8000129c:	00005097          	auipc	ra,0x5
    800012a0:	7e0080e7          	jalr	2016(ra) # 80006a7c <_Znwm>
    800012a4:	00050993          	mv	s3,a0
    800012a8:	00000593          	li	a1,0
    800012ac:	00006097          	auipc	ra,0x6
    800012b0:	a68080e7          	jalr	-1432(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    800012b4:	0334b023          	sd	s3,32(s1)
    spaceAvailable = new Semaphore(_cap);
    800012b8:	01000513          	li	a0,16
    800012bc:	00005097          	auipc	ra,0x5
    800012c0:	7c0080e7          	jalr	1984(ra) # 80006a7c <_Znwm>
    800012c4:	00050993          	mv	s3,a0
    800012c8:	00090593          	mv	a1,s2
    800012cc:	00006097          	auipc	ra,0x6
    800012d0:	a48080e7          	jalr	-1464(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    800012d4:	0134bc23          	sd	s3,24(s1)
    mutexHead = new Semaphore(1);
    800012d8:	01000513          	li	a0,16
    800012dc:	00005097          	auipc	ra,0x5
    800012e0:	7a0080e7          	jalr	1952(ra) # 80006a7c <_Znwm>
    800012e4:	00050913          	mv	s2,a0
    800012e8:	00100593          	li	a1,1
    800012ec:	00006097          	auipc	ra,0x6
    800012f0:	a28080e7          	jalr	-1496(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    800012f4:	0324b423          	sd	s2,40(s1)
    mutexTail = new Semaphore(1);
    800012f8:	01000513          	li	a0,16
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	780080e7          	jalr	1920(ra) # 80006a7c <_Znwm>
    80001304:	00050913          	mv	s2,a0
    80001308:	00100593          	li	a1,1
    8000130c:	00006097          	auipc	ra,0x6
    80001310:	a08080e7          	jalr	-1528(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    80001314:	0324b823          	sd	s2,48(s1)
}
    80001318:	02813083          	ld	ra,40(sp)
    8000131c:	02013403          	ld	s0,32(sp)
    80001320:	01813483          	ld	s1,24(sp)
    80001324:	01013903          	ld	s2,16(sp)
    80001328:	00813983          	ld	s3,8(sp)
    8000132c:	03010113          	addi	sp,sp,48
    80001330:	00008067          	ret
    80001334:	00050493          	mv	s1,a0
    itemAvailable = new Semaphore(0);
    80001338:	00098513          	mv	a0,s3
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	790080e7          	jalr	1936(ra) # 80006acc <_ZdlPv>
    80001344:	00048513          	mv	a0,s1
    80001348:	0000c097          	auipc	ra,0xc
    8000134c:	de0080e7          	jalr	-544(ra) # 8000d128 <_Unwind_Resume>
    80001350:	00050493          	mv	s1,a0
    spaceAvailable = new Semaphore(_cap);
    80001354:	00098513          	mv	a0,s3
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	774080e7          	jalr	1908(ra) # 80006acc <_ZdlPv>
    80001360:	00048513          	mv	a0,s1
    80001364:	0000c097          	auipc	ra,0xc
    80001368:	dc4080e7          	jalr	-572(ra) # 8000d128 <_Unwind_Resume>
    8000136c:	00050493          	mv	s1,a0
    mutexHead = new Semaphore(1);
    80001370:	00090513          	mv	a0,s2
    80001374:	00005097          	auipc	ra,0x5
    80001378:	758080e7          	jalr	1880(ra) # 80006acc <_ZdlPv>
    8000137c:	00048513          	mv	a0,s1
    80001380:	0000c097          	auipc	ra,0xc
    80001384:	da8080e7          	jalr	-600(ra) # 8000d128 <_Unwind_Resume>
    80001388:	00050493          	mv	s1,a0
    mutexTail = new Semaphore(1);
    8000138c:	00090513          	mv	a0,s2
    80001390:	00005097          	auipc	ra,0x5
    80001394:	73c080e7          	jalr	1852(ra) # 80006acc <_ZdlPv>
    80001398:	00048513          	mv	a0,s1
    8000139c:	0000c097          	auipc	ra,0xc
    800013a0:	d8c080e7          	jalr	-628(ra) # 8000d128 <_Unwind_Resume>

00000000800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>:
    delete spaceAvailable;
    delete mutexTail;
    delete mutexHead;
}

void BufferTestCPP::BufferCPP::put(int val) {
    800013a4:	fe010113          	addi	sp,sp,-32
    800013a8:	00113c23          	sd	ra,24(sp)
    800013ac:	00813823          	sd	s0,16(sp)
    800013b0:	00913423          	sd	s1,8(sp)
    800013b4:	01213023          	sd	s2,0(sp)
    800013b8:	02010413          	addi	s0,sp,32
    800013bc:	00050493          	mv	s1,a0
    800013c0:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    800013c4:	01853503          	ld	a0,24(a0) # 1018 <_entry-0x7fffefe8>
    800013c8:	00006097          	auipc	ra,0x6
    800013cc:	984080e7          	jalr	-1660(ra) # 80006d4c <_ZN9Semaphore4waitEv>

    mutexTail->wait();
    800013d0:	0304b503          	ld	a0,48(s1)
    800013d4:	00006097          	auipc	ra,0x6
    800013d8:	978080e7          	jalr	-1672(ra) # 80006d4c <_ZN9Semaphore4waitEv>
    buffer[tail] = val;
    800013dc:	0084b783          	ld	a5,8(s1)
    800013e0:	0144a703          	lw	a4,20(s1)
    800013e4:	00271713          	slli	a4,a4,0x2
    800013e8:	00e787b3          	add	a5,a5,a4
    800013ec:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    800013f0:	0144a783          	lw	a5,20(s1)
    800013f4:	0017879b          	addiw	a5,a5,1
    800013f8:	0004a703          	lw	a4,0(s1)
    800013fc:	02e7e7bb          	remw	a5,a5,a4
    80001400:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    80001404:	0304b503          	ld	a0,48(s1)
    80001408:	00006097          	auipc	ra,0x6
    8000140c:	970080e7          	jalr	-1680(ra) # 80006d78 <_ZN9Semaphore6signalEv>

    itemAvailable->signal();
    80001410:	0204b503          	ld	a0,32(s1)
    80001414:	00006097          	auipc	ra,0x6
    80001418:	964080e7          	jalr	-1692(ra) # 80006d78 <_ZN9Semaphore6signalEv>

}
    8000141c:	01813083          	ld	ra,24(sp)
    80001420:	01013403          	ld	s0,16(sp)
    80001424:	00813483          	ld	s1,8(sp)
    80001428:	00013903          	ld	s2,0(sp)
    8000142c:	02010113          	addi	sp,sp,32
    80001430:	00008067          	ret

0000000080001434 <_ZN13BufferTestCPP9BufferCPP3getEv>:

int BufferTestCPP::BufferCPP::get() {
    80001434:	fe010113          	addi	sp,sp,-32
    80001438:	00113c23          	sd	ra,24(sp)
    8000143c:	00813823          	sd	s0,16(sp)
    80001440:	00913423          	sd	s1,8(sp)
    80001444:	01213023          	sd	s2,0(sp)
    80001448:	02010413          	addi	s0,sp,32
    8000144c:	00050493          	mv	s1,a0
    itemAvailable->wait();
    80001450:	02053503          	ld	a0,32(a0)
    80001454:	00006097          	auipc	ra,0x6
    80001458:	8f8080e7          	jalr	-1800(ra) # 80006d4c <_ZN9Semaphore4waitEv>

    mutexHead->wait();
    8000145c:	0284b503          	ld	a0,40(s1)
    80001460:	00006097          	auipc	ra,0x6
    80001464:	8ec080e7          	jalr	-1812(ra) # 80006d4c <_ZN9Semaphore4waitEv>

    int ret = buffer[head];
    80001468:	0084b703          	ld	a4,8(s1)
    8000146c:	0104a783          	lw	a5,16(s1)
    80001470:	00279693          	slli	a3,a5,0x2
    80001474:	00d70733          	add	a4,a4,a3
    80001478:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    8000147c:	0017879b          	addiw	a5,a5,1
    80001480:	0004a703          	lw	a4,0(s1)
    80001484:	02e7e7bb          	remw	a5,a5,a4
    80001488:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    8000148c:	0284b503          	ld	a0,40(s1)
    80001490:	00006097          	auipc	ra,0x6
    80001494:	8e8080e7          	jalr	-1816(ra) # 80006d78 <_ZN9Semaphore6signalEv>

    spaceAvailable->signal();
    80001498:	0184b503          	ld	a0,24(s1)
    8000149c:	00006097          	auipc	ra,0x6
    800014a0:	8dc080e7          	jalr	-1828(ra) # 80006d78 <_ZN9Semaphore6signalEv>

    return ret;
}
    800014a4:	00090513          	mv	a0,s2
    800014a8:	01813083          	ld	ra,24(sp)
    800014ac:	01013403          	ld	s0,16(sp)
    800014b0:	00813483          	ld	s1,8(sp)
    800014b4:	00013903          	ld	s2,0(sp)
    800014b8:	02010113          	addi	sp,sp,32
    800014bc:	00008067          	ret

00000000800014c0 <_ZN13BufferTestCPP9BufferCPP6getCntEv>:

int BufferTestCPP::BufferCPP::getCnt() {
    800014c0:	fe010113          	addi	sp,sp,-32
    800014c4:	00113c23          	sd	ra,24(sp)
    800014c8:	00813823          	sd	s0,16(sp)
    800014cc:	00913423          	sd	s1,8(sp)
    800014d0:	01213023          	sd	s2,0(sp)
    800014d4:	02010413          	addi	s0,sp,32
    800014d8:	00050493          	mv	s1,a0
    int ret;

    mutexHead->wait();
    800014dc:	02853503          	ld	a0,40(a0)
    800014e0:	00006097          	auipc	ra,0x6
    800014e4:	86c080e7          	jalr	-1940(ra) # 80006d4c <_ZN9Semaphore4waitEv>
    mutexTail->wait();
    800014e8:	0304b503          	ld	a0,48(s1)
    800014ec:	00006097          	auipc	ra,0x6
    800014f0:	860080e7          	jalr	-1952(ra) # 80006d4c <_ZN9Semaphore4waitEv>

    if (tail >= head) {
    800014f4:	0144a783          	lw	a5,20(s1)
    800014f8:	0104a903          	lw	s2,16(s1)
    800014fc:	0327ce63          	blt	a5,s2,80001538 <_ZN13BufferTestCPP9BufferCPP6getCntEv+0x78>
        ret = tail - head;
    80001500:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    mutexTail->signal();
    80001504:	0304b503          	ld	a0,48(s1)
    80001508:	00006097          	auipc	ra,0x6
    8000150c:	870080e7          	jalr	-1936(ra) # 80006d78 <_ZN9Semaphore6signalEv>
    mutexHead->signal();
    80001510:	0284b503          	ld	a0,40(s1)
    80001514:	00006097          	auipc	ra,0x6
    80001518:	864080e7          	jalr	-1948(ra) # 80006d78 <_ZN9Semaphore6signalEv>

    return ret;
}
    8000151c:	00090513          	mv	a0,s2
    80001520:	01813083          	ld	ra,24(sp)
    80001524:	01013403          	ld	s0,16(sp)
    80001528:	00813483          	ld	s1,8(sp)
    8000152c:	00013903          	ld	s2,0(sp)
    80001530:	02010113          	addi	sp,sp,32
    80001534:	00008067          	ret
        ret = cap - head + tail;
    80001538:	0004a703          	lw	a4,0(s1)
    8000153c:	4127093b          	subw	s2,a4,s2
    80001540:	00f9093b          	addw	s2,s2,a5
    80001544:	fc1ff06f          	j	80001504 <_ZN13BufferTestCPP9BufferCPP6getCntEv+0x44>

0000000080001548 <_ZN13BufferTestCPP9BufferCPPD1Ev>:
BufferTestCPP::BufferCPP::~BufferCPP() {
    80001548:	fe010113          	addi	sp,sp,-32
    8000154c:	00113c23          	sd	ra,24(sp)
    80001550:	00813823          	sd	s0,16(sp)
    80001554:	00913423          	sd	s1,8(sp)
    80001558:	02010413          	addi	s0,sp,32
    8000155c:	00050493          	mv	s1,a0
    Console::putc('\n');
    80001560:	00a00513          	li	a0,10
    80001564:	00006097          	auipc	ra,0x6
    80001568:	8dc080e7          	jalr	-1828(ra) # 80006e40 <_ZN7Console4putcEc>
    printString("Buffer deleted!\n");
    8000156c:	00008517          	auipc	a0,0x8
    80001570:	ab450513          	addi	a0,a0,-1356 # 80009020 <CONSOLE_STATUS+0x10>
    80001574:	00000097          	auipc	ra,0x0
    80001578:	0d4080e7          	jalr	212(ra) # 80001648 <_Z11printStringPKc>
    while (getCnt()) {
    8000157c:	00048513          	mv	a0,s1
    80001580:	00000097          	auipc	ra,0x0
    80001584:	f40080e7          	jalr	-192(ra) # 800014c0 <_ZN13BufferTestCPP9BufferCPP6getCntEv>
    80001588:	02050c63          	beqz	a0,800015c0 <_ZN13BufferTestCPP9BufferCPPD1Ev+0x78>
        char ch = buffer[head];
    8000158c:	0084b783          	ld	a5,8(s1)
    80001590:	0104a703          	lw	a4,16(s1)
    80001594:	00271713          	slli	a4,a4,0x2
    80001598:	00e787b3          	add	a5,a5,a4
        Console::putc(ch);
    8000159c:	0007c503          	lbu	a0,0(a5)
    800015a0:	00006097          	auipc	ra,0x6
    800015a4:	8a0080e7          	jalr	-1888(ra) # 80006e40 <_ZN7Console4putcEc>
        head = (head + 1) % cap;
    800015a8:	0104a783          	lw	a5,16(s1)
    800015ac:	0017879b          	addiw	a5,a5,1
    800015b0:	0004a703          	lw	a4,0(s1)
    800015b4:	02e7e7bb          	remw	a5,a5,a4
    800015b8:	00f4a823          	sw	a5,16(s1)
    while (getCnt()) {
    800015bc:	fc1ff06f          	j	8000157c <_ZN13BufferTestCPP9BufferCPPD1Ev+0x34>
    Console::putc('!');
    800015c0:	02100513          	li	a0,33
    800015c4:	00006097          	auipc	ra,0x6
    800015c8:	87c080e7          	jalr	-1924(ra) # 80006e40 <_ZN7Console4putcEc>
    Console::putc('\n');
    800015cc:	00a00513          	li	a0,10
    800015d0:	00006097          	auipc	ra,0x6
    800015d4:	870080e7          	jalr	-1936(ra) # 80006e40 <_ZN7Console4putcEc>
    mem_free(buffer);
    800015d8:	0084b503          	ld	a0,8(s1)
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	d54080e7          	jalr	-684(ra) # 80006330 <_Z8mem_freePv>
    delete itemAvailable;
    800015e4:	0204b503          	ld	a0,32(s1)
    800015e8:	00050863          	beqz	a0,800015f8 <_ZN13BufferTestCPP9BufferCPPD1Ev+0xb0>
    800015ec:	00053783          	ld	a5,0(a0)
    800015f0:	0087b783          	ld	a5,8(a5)
    800015f4:	000780e7          	jalr	a5
    delete spaceAvailable;
    800015f8:	0184b503          	ld	a0,24(s1)
    800015fc:	00050863          	beqz	a0,8000160c <_ZN13BufferTestCPP9BufferCPPD1Ev+0xc4>
    80001600:	00053783          	ld	a5,0(a0)
    80001604:	0087b783          	ld	a5,8(a5)
    80001608:	000780e7          	jalr	a5
    delete mutexTail;
    8000160c:	0304b503          	ld	a0,48(s1)
    80001610:	00050863          	beqz	a0,80001620 <_ZN13BufferTestCPP9BufferCPPD1Ev+0xd8>
    80001614:	00053783          	ld	a5,0(a0)
    80001618:	0087b783          	ld	a5,8(a5)
    8000161c:	000780e7          	jalr	a5
    delete mutexHead;
    80001620:	0284b503          	ld	a0,40(s1)
    80001624:	00050863          	beqz	a0,80001634 <_ZN13BufferTestCPP9BufferCPPD1Ev+0xec>
    80001628:	00053783          	ld	a5,0(a0)
    8000162c:	0087b783          	ld	a5,8(a5)
    80001630:	000780e7          	jalr	a5
}
    80001634:	01813083          	ld	ra,24(sp)
    80001638:	01013403          	ld	s0,16(sp)
    8000163c:	00813483          	ld	s1,8(sp)
    80001640:	02010113          	addi	sp,sp,32
    80001644:	00008067          	ret

0000000080001648 <_Z11printStringPKc>:

#define LOCK() while(copy_and_swap(lockPrint, 0, 1))
#define UNLOCK() while(copy_and_swap(lockPrint, 1, 0))

void printString(char const *string)
{
    80001648:	fe010113          	addi	sp,sp,-32
    8000164c:	00113c23          	sd	ra,24(sp)
    80001650:	00813823          	sd	s0,16(sp)
    80001654:	00913423          	sd	s1,8(sp)
    80001658:	02010413          	addi	s0,sp,32
    8000165c:	00050493          	mv	s1,a0
    LOCK();
    80001660:	00100613          	li	a2,1
    80001664:	00000593          	li	a1,0
    80001668:	0000a517          	auipc	a0,0xa
    8000166c:	69850513          	addi	a0,a0,1688 # 8000bd00 <lockPrint>
    80001670:	00000097          	auipc	ra,0x0
    80001674:	990080e7          	jalr	-1648(ra) # 80001000 <copy_and_swap>
    80001678:	fe0514e3          	bnez	a0,80001660 <_Z11printStringPKc+0x18>
    while (*string != '\0')
    8000167c:	0004c503          	lbu	a0,0(s1)
    80001680:	00050a63          	beqz	a0,80001694 <_Z11printStringPKc+0x4c>
    {
        putc(*string);
    80001684:	00005097          	auipc	ra,0x5
    80001688:	1f0080e7          	jalr	496(ra) # 80006874 <_Z4putcc>
        string++;
    8000168c:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    80001690:	fedff06f          	j	8000167c <_Z11printStringPKc+0x34>
    }
    UNLOCK();
    80001694:	00000613          	li	a2,0
    80001698:	00100593          	li	a1,1
    8000169c:	0000a517          	auipc	a0,0xa
    800016a0:	66450513          	addi	a0,a0,1636 # 8000bd00 <lockPrint>
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	95c080e7          	jalr	-1700(ra) # 80001000 <copy_and_swap>
    800016ac:	fe0514e3          	bnez	a0,80001694 <_Z11printStringPKc+0x4c>
}
    800016b0:	01813083          	ld	ra,24(sp)
    800016b4:	01013403          	ld	s0,16(sp)
    800016b8:	00813483          	ld	s1,8(sp)
    800016bc:	02010113          	addi	sp,sp,32
    800016c0:	00008067          	ret

00000000800016c4 <_Z9getStringPci>:

char* getString(char *buf, int max) {
    800016c4:	fd010113          	addi	sp,sp,-48
    800016c8:	02113423          	sd	ra,40(sp)
    800016cc:	02813023          	sd	s0,32(sp)
    800016d0:	00913c23          	sd	s1,24(sp)
    800016d4:	01213823          	sd	s2,16(sp)
    800016d8:	01313423          	sd	s3,8(sp)
    800016dc:	01413023          	sd	s4,0(sp)
    800016e0:	03010413          	addi	s0,sp,48
    800016e4:	00050993          	mv	s3,a0
    800016e8:	00058a13          	mv	s4,a1
    LOCK();
    800016ec:	00100613          	li	a2,1
    800016f0:	00000593          	li	a1,0
    800016f4:	0000a517          	auipc	a0,0xa
    800016f8:	60c50513          	addi	a0,a0,1548 # 8000bd00 <lockPrint>
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	904080e7          	jalr	-1788(ra) # 80001000 <copy_and_swap>
    80001704:	fe0514e3          	bnez	a0,800016ec <_Z9getStringPci+0x28>
    int i, cc;
    char c;

    for(i=0; i+1 < max; ){
    80001708:	00000913          	li	s2,0
    8000170c:	00090493          	mv	s1,s2
    80001710:	0019091b          	addiw	s2,s2,1
    80001714:	03495a63          	bge	s2,s4,80001748 <_Z9getStringPci+0x84>
        cc = getc();
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	104080e7          	jalr	260(ra) # 8000681c <_Z4getcv>
        if(cc < 1)
    80001720:	02050463          	beqz	a0,80001748 <_Z9getStringPci+0x84>
            break;
        c = cc;
        buf[i++] = c;
    80001724:	009984b3          	add	s1,s3,s1
    80001728:	00a48023          	sb	a0,0(s1)
        if(c == '\n' || c == '\r')
    8000172c:	00a00793          	li	a5,10
    80001730:	00f50a63          	beq	a0,a5,80001744 <_Z9getStringPci+0x80>
    80001734:	00d00793          	li	a5,13
    80001738:	fcf51ae3          	bne	a0,a5,8000170c <_Z9getStringPci+0x48>
        buf[i++] = c;
    8000173c:	00090493          	mv	s1,s2
    80001740:	0080006f          	j	80001748 <_Z9getStringPci+0x84>
    80001744:	00090493          	mv	s1,s2
            break;
    }
    buf[i] = '\0';
    80001748:	009984b3          	add	s1,s3,s1
    8000174c:	00048023          	sb	zero,0(s1)

    UNLOCK();
    80001750:	00000613          	li	a2,0
    80001754:	00100593          	li	a1,1
    80001758:	0000a517          	auipc	a0,0xa
    8000175c:	5a850513          	addi	a0,a0,1448 # 8000bd00 <lockPrint>
    80001760:	00000097          	auipc	ra,0x0
    80001764:	8a0080e7          	jalr	-1888(ra) # 80001000 <copy_and_swap>
    80001768:	fe0514e3          	bnez	a0,80001750 <_Z9getStringPci+0x8c>
    return buf;
}
    8000176c:	00098513          	mv	a0,s3
    80001770:	02813083          	ld	ra,40(sp)
    80001774:	02013403          	ld	s0,32(sp)
    80001778:	01813483          	ld	s1,24(sp)
    8000177c:	01013903          	ld	s2,16(sp)
    80001780:	00813983          	ld	s3,8(sp)
    80001784:	00013a03          	ld	s4,0(sp)
    80001788:	03010113          	addi	sp,sp,48
    8000178c:	00008067          	ret

0000000080001790 <_Z11stringToIntPKc>:

int stringToInt(const char *s) {
    80001790:	ff010113          	addi	sp,sp,-16
    80001794:	00813423          	sd	s0,8(sp)
    80001798:	01010413          	addi	s0,sp,16
    8000179c:	00050693          	mv	a3,a0
    int n;

    n = 0;
    800017a0:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    800017a4:	0006c603          	lbu	a2,0(a3)
    800017a8:	fd06071b          	addiw	a4,a2,-48
    800017ac:	0ff77713          	andi	a4,a4,255
    800017b0:	00900793          	li	a5,9
    800017b4:	02e7e063          	bltu	a5,a4,800017d4 <_Z11stringToIntPKc+0x44>
        n = n * 10 + *s++ - '0';
    800017b8:	0025179b          	slliw	a5,a0,0x2
    800017bc:	00a787bb          	addw	a5,a5,a0
    800017c0:	0017979b          	slliw	a5,a5,0x1
    800017c4:	00168693          	addi	a3,a3,1
    800017c8:	00c787bb          	addw	a5,a5,a2
    800017cc:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    800017d0:	fd5ff06f          	j	800017a4 <_Z11stringToIntPKc+0x14>
    return n;
}
    800017d4:	00813403          	ld	s0,8(sp)
    800017d8:	01010113          	addi	sp,sp,16
    800017dc:	00008067          	ret

00000000800017e0 <_Z8printIntiii>:

char digits[] = "0123456789ABCDEF";

void printInt(int xx, int base, int sgn)
{
    800017e0:	fc010113          	addi	sp,sp,-64
    800017e4:	02113c23          	sd	ra,56(sp)
    800017e8:	02813823          	sd	s0,48(sp)
    800017ec:	02913423          	sd	s1,40(sp)
    800017f0:	03213023          	sd	s2,32(sp)
    800017f4:	01313c23          	sd	s3,24(sp)
    800017f8:	04010413          	addi	s0,sp,64
    800017fc:	00050493          	mv	s1,a0
    80001800:	00058913          	mv	s2,a1
    80001804:	00060993          	mv	s3,a2
    LOCK();
    80001808:	00100613          	li	a2,1
    8000180c:	00000593          	li	a1,0
    80001810:	0000a517          	auipc	a0,0xa
    80001814:	4f050513          	addi	a0,a0,1264 # 8000bd00 <lockPrint>
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	7e8080e7          	jalr	2024(ra) # 80001000 <copy_and_swap>
    80001820:	fe0514e3          	bnez	a0,80001808 <_Z8printIntiii+0x28>
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    80001824:	00098463          	beqz	s3,8000182c <_Z8printIntiii+0x4c>
    80001828:	0804c463          	bltz	s1,800018b0 <_Z8printIntiii+0xd0>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    8000182c:	0004851b          	sext.w	a0,s1
    neg = 0;
    80001830:	00000593          	li	a1,0
    }

    i = 0;
    80001834:	00000493          	li	s1,0
    do{
        buf[i++] = digits[x % base];
    80001838:	0009079b          	sext.w	a5,s2
    8000183c:	0325773b          	remuw	a4,a0,s2
    80001840:	00048613          	mv	a2,s1
    80001844:	0014849b          	addiw	s1,s1,1
    80001848:	02071693          	slli	a3,a4,0x20
    8000184c:	0206d693          	srli	a3,a3,0x20
    80001850:	0000a717          	auipc	a4,0xa
    80001854:	15870713          	addi	a4,a4,344 # 8000b9a8 <digits>
    80001858:	00d70733          	add	a4,a4,a3
    8000185c:	00074683          	lbu	a3,0(a4)
    80001860:	fd040713          	addi	a4,s0,-48
    80001864:	00c70733          	add	a4,a4,a2
    80001868:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    8000186c:	0005071b          	sext.w	a4,a0
    80001870:	0325553b          	divuw	a0,a0,s2
    80001874:	fcf772e3          	bgeu	a4,a5,80001838 <_Z8printIntiii+0x58>
    if(neg)
    80001878:	00058c63          	beqz	a1,80001890 <_Z8printIntiii+0xb0>
        buf[i++] = '-';
    8000187c:	fd040793          	addi	a5,s0,-48
    80001880:	009784b3          	add	s1,a5,s1
    80001884:	02d00793          	li	a5,45
    80001888:	fef48823          	sb	a5,-16(s1)
    8000188c:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    80001890:	fff4849b          	addiw	s1,s1,-1
    80001894:	0204c463          	bltz	s1,800018bc <_Z8printIntiii+0xdc>
        putc(buf[i]);
    80001898:	fd040793          	addi	a5,s0,-48
    8000189c:	009787b3          	add	a5,a5,s1
    800018a0:	ff07c503          	lbu	a0,-16(a5)
    800018a4:	00005097          	auipc	ra,0x5
    800018a8:	fd0080e7          	jalr	-48(ra) # 80006874 <_Z4putcc>
    800018ac:	fe5ff06f          	j	80001890 <_Z8printIntiii+0xb0>
        x = -xx;
    800018b0:	4090053b          	negw	a0,s1
        neg = 1;
    800018b4:	00100593          	li	a1,1
        x = -xx;
    800018b8:	f7dff06f          	j	80001834 <_Z8printIntiii+0x54>

    UNLOCK();
    800018bc:	00000613          	li	a2,0
    800018c0:	00100593          	li	a1,1
    800018c4:	0000a517          	auipc	a0,0xa
    800018c8:	43c50513          	addi	a0,a0,1084 # 8000bd00 <lockPrint>
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	734080e7          	jalr	1844(ra) # 80001000 <copy_and_swap>
    800018d4:	fe0514e3          	bnez	a0,800018bc <_Z8printIntiii+0xdc>
    800018d8:	03813083          	ld	ra,56(sp)
    800018dc:	03013403          	ld	s0,48(sp)
    800018e0:	02813483          	ld	s1,40(sp)
    800018e4:	02013903          	ld	s2,32(sp)
    800018e8:	01813983          	ld	s3,24(sp)
    800018ec:	04010113          	addi	sp,sp,64
    800018f0:	00008067          	ret

00000000800018f4 <_ZN11BufferTestC6BufferC1Ei>:
#include "../../../h/Testing/Testing_OS1/Buffer.hpp"

BufferTestC::Buffer::Buffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    800018f4:	fe010113          	addi	sp,sp,-32
    800018f8:	00113c23          	sd	ra,24(sp)
    800018fc:	00813823          	sd	s0,16(sp)
    80001900:	00913423          	sd	s1,8(sp)
    80001904:	01213023          	sd	s2,0(sp)
    80001908:	02010413          	addi	s0,sp,32
    8000190c:	00050493          	mv	s1,a0
    80001910:	00058913          	mv	s2,a1
    80001914:	0015879b          	addiw	a5,a1,1
    80001918:	0007851b          	sext.w	a0,a5
    8000191c:	00f4a023          	sw	a5,0(s1)
    80001920:	0004a823          	sw	zero,16(s1)
    80001924:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    80001928:	00251513          	slli	a0,a0,0x2
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	9a0080e7          	jalr	-1632(ra) # 800062cc <_Z9mem_allocm>
    80001934:	00a4b423          	sd	a0,8(s1)
    sem_open(&itemAvailable, 0);
    80001938:	00000593          	li	a1,0
    8000193c:	02048513          	addi	a0,s1,32
    80001940:	00005097          	auipc	ra,0x5
    80001944:	cfc080e7          	jalr	-772(ra) # 8000663c <_Z8sem_openPP3semj>
    sem_open(&spaceAvailable, _cap);
    80001948:	00090593          	mv	a1,s2
    8000194c:	01848513          	addi	a0,s1,24
    80001950:	00005097          	auipc	ra,0x5
    80001954:	cec080e7          	jalr	-788(ra) # 8000663c <_Z8sem_openPP3semj>
    sem_open(&mutexHead, 1);
    80001958:	00100593          	li	a1,1
    8000195c:	02848513          	addi	a0,s1,40
    80001960:	00005097          	auipc	ra,0x5
    80001964:	cdc080e7          	jalr	-804(ra) # 8000663c <_Z8sem_openPP3semj>
    sem_open(&mutexTail, 1);
    80001968:	00100593          	li	a1,1
    8000196c:	03048513          	addi	a0,s1,48
    80001970:	00005097          	auipc	ra,0x5
    80001974:	ccc080e7          	jalr	-820(ra) # 8000663c <_Z8sem_openPP3semj>
}
    80001978:	01813083          	ld	ra,24(sp)
    8000197c:	01013403          	ld	s0,16(sp)
    80001980:	00813483          	ld	s1,8(sp)
    80001984:	00013903          	ld	s2,0(sp)
    80001988:	02010113          	addi	sp,sp,32
    8000198c:	00008067          	ret

0000000080001990 <_ZN11BufferTestC6Buffer3putEi>:
    sem_close(spaceAvailable);
    sem_close(mutexTail);
    sem_close(mutexHead);
}

void BufferTestC::Buffer::put(int val) {
    80001990:	fe010113          	addi	sp,sp,-32
    80001994:	00113c23          	sd	ra,24(sp)
    80001998:	00813823          	sd	s0,16(sp)
    8000199c:	00913423          	sd	s1,8(sp)
    800019a0:	01213023          	sd	s2,0(sp)
    800019a4:	02010413          	addi	s0,sp,32
    800019a8:	00050493          	mv	s1,a0
    800019ac:	00058913          	mv	s2,a1
    sem_wait(spaceAvailable);
    800019b0:	01853503          	ld	a0,24(a0)
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	d58080e7          	jalr	-680(ra) # 8000670c <_Z8sem_waitP3sem>

    sem_wait(mutexTail);
    800019bc:	0304b503          	ld	a0,48(s1)
    800019c0:	00005097          	auipc	ra,0x5
    800019c4:	d4c080e7          	jalr	-692(ra) # 8000670c <_Z8sem_waitP3sem>
    buffer[tail] = val;
    800019c8:	0084b783          	ld	a5,8(s1)
    800019cc:	0144a703          	lw	a4,20(s1)
    800019d0:	00271713          	slli	a4,a4,0x2
    800019d4:	00e787b3          	add	a5,a5,a4
    800019d8:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    800019dc:	0144a783          	lw	a5,20(s1)
    800019e0:	0017879b          	addiw	a5,a5,1
    800019e4:	0004a703          	lw	a4,0(s1)
    800019e8:	02e7e7bb          	remw	a5,a5,a4
    800019ec:	00f4aa23          	sw	a5,20(s1)
    sem_signal(mutexTail);
    800019f0:	0304b503          	ld	a0,48(s1)
    800019f4:	00005097          	auipc	ra,0x5
    800019f8:	d70080e7          	jalr	-656(ra) # 80006764 <_Z10sem_signalP3sem>

    sem_signal(itemAvailable);
    800019fc:	0204b503          	ld	a0,32(s1)
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	d64080e7          	jalr	-668(ra) # 80006764 <_Z10sem_signalP3sem>

}
    80001a08:	01813083          	ld	ra,24(sp)
    80001a0c:	01013403          	ld	s0,16(sp)
    80001a10:	00813483          	ld	s1,8(sp)
    80001a14:	00013903          	ld	s2,0(sp)
    80001a18:	02010113          	addi	sp,sp,32
    80001a1c:	00008067          	ret

0000000080001a20 <_ZN11BufferTestC6Buffer3getEv>:

int BufferTestC::Buffer::get() {
    80001a20:	fe010113          	addi	sp,sp,-32
    80001a24:	00113c23          	sd	ra,24(sp)
    80001a28:	00813823          	sd	s0,16(sp)
    80001a2c:	00913423          	sd	s1,8(sp)
    80001a30:	01213023          	sd	s2,0(sp)
    80001a34:	02010413          	addi	s0,sp,32
    80001a38:	00050493          	mv	s1,a0
    sem_wait(itemAvailable);
    80001a3c:	02053503          	ld	a0,32(a0)
    80001a40:	00005097          	auipc	ra,0x5
    80001a44:	ccc080e7          	jalr	-820(ra) # 8000670c <_Z8sem_waitP3sem>

    sem_wait(mutexHead);
    80001a48:	0284b503          	ld	a0,40(s1)
    80001a4c:	00005097          	auipc	ra,0x5
    80001a50:	cc0080e7          	jalr	-832(ra) # 8000670c <_Z8sem_waitP3sem>

    int ret = buffer[head];
    80001a54:	0084b703          	ld	a4,8(s1)
    80001a58:	0104a783          	lw	a5,16(s1)
    80001a5c:	00279693          	slli	a3,a5,0x2
    80001a60:	00d70733          	add	a4,a4,a3
    80001a64:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    80001a68:	0017879b          	addiw	a5,a5,1
    80001a6c:	0004a703          	lw	a4,0(s1)
    80001a70:	02e7e7bb          	remw	a5,a5,a4
    80001a74:	00f4a823          	sw	a5,16(s1)
    sem_signal(mutexHead);
    80001a78:	0284b503          	ld	a0,40(s1)
    80001a7c:	00005097          	auipc	ra,0x5
    80001a80:	ce8080e7          	jalr	-792(ra) # 80006764 <_Z10sem_signalP3sem>

    sem_signal(spaceAvailable);
    80001a84:	0184b503          	ld	a0,24(s1)
    80001a88:	00005097          	auipc	ra,0x5
    80001a8c:	cdc080e7          	jalr	-804(ra) # 80006764 <_Z10sem_signalP3sem>

    return ret;
}
    80001a90:	00090513          	mv	a0,s2
    80001a94:	01813083          	ld	ra,24(sp)
    80001a98:	01013403          	ld	s0,16(sp)
    80001a9c:	00813483          	ld	s1,8(sp)
    80001aa0:	00013903          	ld	s2,0(sp)
    80001aa4:	02010113          	addi	sp,sp,32
    80001aa8:	00008067          	ret

0000000080001aac <_ZN11BufferTestC6Buffer6getCntEv>:

int BufferTestC::Buffer::getCnt() {
    80001aac:	fe010113          	addi	sp,sp,-32
    80001ab0:	00113c23          	sd	ra,24(sp)
    80001ab4:	00813823          	sd	s0,16(sp)
    80001ab8:	00913423          	sd	s1,8(sp)
    80001abc:	01213023          	sd	s2,0(sp)
    80001ac0:	02010413          	addi	s0,sp,32
    80001ac4:	00050493          	mv	s1,a0
    int ret;

    sem_wait(mutexHead);
    80001ac8:	02853503          	ld	a0,40(a0)
    80001acc:	00005097          	auipc	ra,0x5
    80001ad0:	c40080e7          	jalr	-960(ra) # 8000670c <_Z8sem_waitP3sem>
    sem_wait(mutexTail);
    80001ad4:	0304b503          	ld	a0,48(s1)
    80001ad8:	00005097          	auipc	ra,0x5
    80001adc:	c34080e7          	jalr	-972(ra) # 8000670c <_Z8sem_waitP3sem>

    if (tail >= head) {
    80001ae0:	0144a783          	lw	a5,20(s1)
    80001ae4:	0104a903          	lw	s2,16(s1)
    80001ae8:	0327ce63          	blt	a5,s2,80001b24 <_ZN11BufferTestC6Buffer6getCntEv+0x78>
        ret = tail - head;
    80001aec:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    sem_signal(mutexTail);
    80001af0:	0304b503          	ld	a0,48(s1)
    80001af4:	00005097          	auipc	ra,0x5
    80001af8:	c70080e7          	jalr	-912(ra) # 80006764 <_Z10sem_signalP3sem>
    sem_signal(mutexHead);
    80001afc:	0284b503          	ld	a0,40(s1)
    80001b00:	00005097          	auipc	ra,0x5
    80001b04:	c64080e7          	jalr	-924(ra) # 80006764 <_Z10sem_signalP3sem>

    return ret;
}
    80001b08:	00090513          	mv	a0,s2
    80001b0c:	01813083          	ld	ra,24(sp)
    80001b10:	01013403          	ld	s0,16(sp)
    80001b14:	00813483          	ld	s1,8(sp)
    80001b18:	00013903          	ld	s2,0(sp)
    80001b1c:	02010113          	addi	sp,sp,32
    80001b20:	00008067          	ret
        ret = cap - head + tail;
    80001b24:	0004a703          	lw	a4,0(s1)
    80001b28:	4127093b          	subw	s2,a4,s2
    80001b2c:	00f9093b          	addw	s2,s2,a5
    80001b30:	fc1ff06f          	j	80001af0 <_ZN11BufferTestC6Buffer6getCntEv+0x44>

0000000080001b34 <_ZN11BufferTestC6BufferD1Ev>:
BufferTestC::Buffer::~Buffer() {
    80001b34:	fe010113          	addi	sp,sp,-32
    80001b38:	00113c23          	sd	ra,24(sp)
    80001b3c:	00813823          	sd	s0,16(sp)
    80001b40:	00913423          	sd	s1,8(sp)
    80001b44:	02010413          	addi	s0,sp,32
    80001b48:	00050493          	mv	s1,a0
    putc('\n');
    80001b4c:	00a00513          	li	a0,10
    80001b50:	00005097          	auipc	ra,0x5
    80001b54:	d24080e7          	jalr	-732(ra) # 80006874 <_Z4putcc>
    printString("Buffer deleted!\n");
    80001b58:	00007517          	auipc	a0,0x7
    80001b5c:	4c850513          	addi	a0,a0,1224 # 80009020 <CONSOLE_STATUS+0x10>
    80001b60:	00000097          	auipc	ra,0x0
    80001b64:	ae8080e7          	jalr	-1304(ra) # 80001648 <_Z11printStringPKc>
    while (getCnt() > 0) {
    80001b68:	00048513          	mv	a0,s1
    80001b6c:	00000097          	auipc	ra,0x0
    80001b70:	f40080e7          	jalr	-192(ra) # 80001aac <_ZN11BufferTestC6Buffer6getCntEv>
    80001b74:	02a05c63          	blez	a0,80001bac <_ZN11BufferTestC6BufferD1Ev+0x78>
        char ch = buffer[head];
    80001b78:	0084b783          	ld	a5,8(s1)
    80001b7c:	0104a703          	lw	a4,16(s1)
    80001b80:	00271713          	slli	a4,a4,0x2
    80001b84:	00e787b3          	add	a5,a5,a4
        putc(ch);
    80001b88:	0007c503          	lbu	a0,0(a5)
    80001b8c:	00005097          	auipc	ra,0x5
    80001b90:	ce8080e7          	jalr	-792(ra) # 80006874 <_Z4putcc>
        head = (head + 1) % cap;
    80001b94:	0104a783          	lw	a5,16(s1)
    80001b98:	0017879b          	addiw	a5,a5,1
    80001b9c:	0004a703          	lw	a4,0(s1)
    80001ba0:	02e7e7bb          	remw	a5,a5,a4
    80001ba4:	00f4a823          	sw	a5,16(s1)
    while (getCnt() > 0) {
    80001ba8:	fc1ff06f          	j	80001b68 <_ZN11BufferTestC6BufferD1Ev+0x34>
    putc('!');
    80001bac:	02100513          	li	a0,33
    80001bb0:	00005097          	auipc	ra,0x5
    80001bb4:	cc4080e7          	jalr	-828(ra) # 80006874 <_Z4putcc>
    putc('\n');
    80001bb8:	00a00513          	li	a0,10
    80001bbc:	00005097          	auipc	ra,0x5
    80001bc0:	cb8080e7          	jalr	-840(ra) # 80006874 <_Z4putcc>
    mem_free(buffer);
    80001bc4:	0084b503          	ld	a0,8(s1)
    80001bc8:	00004097          	auipc	ra,0x4
    80001bcc:	768080e7          	jalr	1896(ra) # 80006330 <_Z8mem_freePv>
    sem_close(itemAvailable);
    80001bd0:	0204b503          	ld	a0,32(s1)
    80001bd4:	00005097          	auipc	ra,0x5
    80001bd8:	ae0080e7          	jalr	-1312(ra) # 800066b4 <_Z9sem_closeP3sem>
    sem_close(spaceAvailable);
    80001bdc:	0184b503          	ld	a0,24(s1)
    80001be0:	00005097          	auipc	ra,0x5
    80001be4:	ad4080e7          	jalr	-1324(ra) # 800066b4 <_Z9sem_closeP3sem>
    sem_close(mutexTail);
    80001be8:	0304b503          	ld	a0,48(s1)
    80001bec:	00005097          	auipc	ra,0x5
    80001bf0:	ac8080e7          	jalr	-1336(ra) # 800066b4 <_Z9sem_closeP3sem>
    sem_close(mutexHead);
    80001bf4:	0284b503          	ld	a0,40(s1)
    80001bf8:	00005097          	auipc	ra,0x5
    80001bfc:	abc080e7          	jalr	-1348(ra) # 800066b4 <_Z9sem_closeP3sem>
}
    80001c00:	01813083          	ld	ra,24(sp)
    80001c04:	01013403          	ld	s0,16(sp)
    80001c08:	00813483          	ld	s1,8(sp)
    80001c0c:	02010113          	addi	sp,sp,32
    80001c10:	00008067          	ret

0000000080001c14 <_Z8userMainv>:
//#include "../../../h/Testing/Testing_OS1/Consumer_Producer_CPP_Sync_API_Test.hpp" // zadatak 3., kompletan CPP API sa semaforima, sinhrona promena konteksta

//#include "../../../h/Testing/Testing_OS1/ThreadSleep_C_API_Test.hpp" // thread_sleep test C API
//#include "../../../h/Testing/Testing_OS1/Consumer_Producer_CPP_API_Test.hpp" // zadatak 4. CPP API i asinhrona promena konteksta

void userMain() {
    80001c14:	ff010113          	addi	sp,sp,-16
    80001c18:	00813423          	sd	s0,8(sp)
    80001c1c:	01010413          	addi	s0,sp,16
    //producerConsumer_C_API(); // zadatak 3., kompletan C API sa semaforima, sinhrona promena konteksta
    //producerConsumer_CPP_Sync_API(); // zadatak 3., kompletan CPP API sa semaforima, sinhrona promena konteksta

    //testSleeping(); // thread_sleep test C API
    //ConsumerProducerCPP::testConsumerProducer(); // zadatak 4. CPP API i asinhrona promena konteksta, kompletan test svega
    80001c20:	00813403          	ld	s0,8(sp)
    80001c24:	01010113          	addi	sp,sp,16
    80001c28:	00008067          	ret

0000000080001c2c <_ZN15MemoryAllocatorC1Ev>:
MemoryAllocator& MemoryAllocator::getInstance() {
    static MemoryAllocator memoryAllocator;
    return memoryAllocator;
}

MemoryAllocator::MemoryAllocator() {
    80001c2c:	ff010113          	addi	sp,sp,-16
    80001c30:	00813423          	sd	s0,8(sp)
    80001c34:	01010413          	addi	s0,sp,16
    // pre tog bloka mora postojati struktura za ulancavanje slobodnih segmenata (FreeSegment) i ona ce, iako je velicine 24 bajta
    // a MEM_BLOCK_SIZE je 64 bajta, zauzeti ceo jedan blok velicine MEM_BLOCK_SIZE, posto se korisniku mora vratiti poravnata adresa,
    // a to je onda adresa prvog narednog bloka velicine MEM_BLOCK_SIZE
    size_t firstAlignedAddress =
            reinterpret_cast<size_t>(HEAP_START_ADDR) +
            ((reinterpret_cast<size_t>(HEAP_START_ADDR) % MEM_BLOCK_SIZE) ?
    80001c38:	0000a797          	auipc	a5,0xa
    80001c3c:	0387b783          	ld	a5,56(a5) # 8000bc70 <_GLOBAL_OFFSET_TABLE_+0x18>
    80001c40:	0007b783          	ld	a5,0(a5)
    80001c44:	03f7f713          	andi	a4,a5,63
    80001c48:	00070663          	beqz	a4,80001c54 <_ZN15MemoryAllocatorC1Ev+0x28>
    80001c4c:	04000693          	li	a3,64
    80001c50:	40e68733          	sub	a4,a3,a4
    size_t firstAlignedAddress =
    80001c54:	00e78733          	add	a4,a5,a4
             (MEM_BLOCK_SIZE - (reinterpret_cast<size_t>(HEAP_START_ADDR)) % MEM_BLOCK_SIZE): 0);
    // koristio sam iznad reinterpret_cast jer sam konvertovao pokazivac u ceo broj, a ispod jer sam konvertovao ceo broj u pokazivac
    freeListHead = reinterpret_cast<FreeSegment*>(firstAlignedAddress);
    80001c58:	00e53023          	sd	a4,0(a0)
    freeListHead->next = nullptr;
    80001c5c:	00073423          	sd	zero,8(a4)
    freeListHead->prev = nullptr;
    80001c60:	00053783          	ld	a5,0(a0)
    80001c64:	0007b823          	sd	zero,16(a5)
    // na pocetku taj jedan veliki slobodan segment ima freeListHead->size blokova velicine MEM_BLOCK_SIZE
    totalNumberOfBlocks = (reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 - firstAlignedAddress) / MEM_BLOCK_SIZE;
    80001c68:	0000a797          	auipc	a5,0xa
    80001c6c:	0407b783          	ld	a5,64(a5) # 8000bca8 <_GLOBAL_OFFSET_TABLE_+0x50>
    80001c70:	0007b783          	ld	a5,0(a5)
    80001c74:	40e787b3          	sub	a5,a5,a4
    80001c78:	fff78793          	addi	a5,a5,-1
    80001c7c:	0067d793          	srli	a5,a5,0x6
    80001c80:	00f53423          	sd	a5,8(a0)
    freeListHead->size = totalNumberOfBlocks;
    80001c84:	00053703          	ld	a4,0(a0)
    80001c88:	00f73023          	sd	a5,0(a4)
}
    80001c8c:	00813403          	ld	s0,8(sp)
    80001c90:	01010113          	addi	sp,sp,16
    80001c94:	00008067          	ret

0000000080001c98 <_ZN15MemoryAllocator11getInstanceEv>:
    static MemoryAllocator memoryAllocator;
    80001c98:	0000a797          	auipc	a5,0xa
    80001c9c:	0707c783          	lbu	a5,112(a5) # 8000bd08 <_ZGVZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    80001ca0:	00078863          	beqz	a5,80001cb0 <_ZN15MemoryAllocator11getInstanceEv+0x18>
}
    80001ca4:	0000a517          	auipc	a0,0xa
    80001ca8:	06c50513          	addi	a0,a0,108 # 8000bd10 <_ZZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    80001cac:	00008067          	ret
MemoryAllocator& MemoryAllocator::getInstance() {
    80001cb0:	ff010113          	addi	sp,sp,-16
    80001cb4:	00113423          	sd	ra,8(sp)
    80001cb8:	00813023          	sd	s0,0(sp)
    80001cbc:	01010413          	addi	s0,sp,16
    static MemoryAllocator memoryAllocator;
    80001cc0:	0000a517          	auipc	a0,0xa
    80001cc4:	05050513          	addi	a0,a0,80 # 8000bd10 <_ZZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	f64080e7          	jalr	-156(ra) # 80001c2c <_ZN15MemoryAllocatorC1Ev>
    80001cd0:	00100793          	li	a5,1
    80001cd4:	0000a717          	auipc	a4,0xa
    80001cd8:	02f70a23          	sb	a5,52(a4) # 8000bd08 <_ZGVZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
}
    80001cdc:	0000a517          	auipc	a0,0xa
    80001ce0:	03450513          	addi	a0,a0,52 # 8000bd10 <_ZZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    80001ce4:	00813083          	ld	ra,8(sp)
    80001ce8:	00013403          	ld	s0,0(sp)
    80001cec:	01010113          	addi	sp,sp,16
    80001cf0:	00008067          	ret

0000000080001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>:

void* MemoryAllocator::allocateSegment(size_t size) { // parametar size je broj blokova velicine MEM_BLOCK_SIZE koje je korisnik trazio
    80001cf4:	ff010113          	addi	sp,sp,-16
    80001cf8:	00813423          	sd	s0,8(sp)
    80001cfc:	01010413          	addi	s0,sp,16
    if (size >= totalNumberOfBlocks) return nullptr; // ako je zatrazeno vise blokova memorije nego sto ukupno ima na raspolaganju
    80001d00:	00853783          	ld	a5,8(a0)
    80001d04:	0cf5f663          	bgeu	a1,a5,80001dd0 <_ZN15MemoryAllocator15allocateSegmentEm+0xdc>
    80001d08:	00050613          	mv	a2,a0
    for (FreeSegment* curr = freeListHead; curr; curr = curr->next) {
    80001d0c:	00053503          	ld	a0,0(a0)
    80001d10:	0540006f          	j	80001d64 <_ZN15MemoryAllocator15allocateSegmentEm+0x70>
            // memorije koju je korisnik alocirao
        if ((curr->size - 1) - size <= 1) {
            // slucaj kada je preostali fragment suvise mali (1 blok velicine MEM_BLOCK_SIZE) da bi se evidentirao kao slobodan (tada ga
            // ne umecemo u listu slodobnih segmenata); fragment mora imati najmanje dva bloka velicine MEM_BLOCK_SIZE jer je potreban
            // jedan ceo blok samo za strukturu za ulancavanje, pa ce onda u tom slucaju korisnik na raspolaganju imati jedan blok
            if (curr->prev) curr->prev->next = curr->next;
    80001d14:	01053783          	ld	a5,16(a0)
    80001d18:	02078a63          	beqz	a5,80001d4c <_ZN15MemoryAllocator15allocateSegmentEm+0x58>
    80001d1c:	00853703          	ld	a4,8(a0)
    80001d20:	00e7b423          	sd	a4,8(a5)
            else freeListHead = curr->next;
            if (curr->next) curr->next->prev = curr->prev;
    80001d24:	00853783          	ld	a5,8(a0)
    80001d28:	00078663          	beqz	a5,80001d34 <_ZN15MemoryAllocator15allocateSegmentEm+0x40>
    80001d2c:	01053703          	ld	a4,16(a0)
    80001d30:	00e7b823          	sd	a4,16(a5)
            // velicina bloka memorije koju je korisnik trazio (size + 1 jer racunam i blok za strukturu za ulancavanje)
            curr->size = size + 1;
    80001d34:	00158593          	addi	a1,a1,1
    80001d38:	00b53023          	sd	a1,0(a0)
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
    80001d3c:	04050513          	addi	a0,a0,64
            curr->size = size + 1;
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
        }
    }
    return nullptr;
}
    80001d40:	00813403          	ld	s0,8(sp)
    80001d44:	01010113          	addi	sp,sp,16
    80001d48:	00008067          	ret
            else freeListHead = curr->next;
    80001d4c:	00853783          	ld	a5,8(a0)
    80001d50:	00f63023          	sd	a5,0(a2)
    80001d54:	fd1ff06f          	j	80001d24 <_ZN15MemoryAllocator15allocateSegmentEm+0x30>
            else freeListHead = newFreeFragment;
    80001d58:	00f63023          	sd	a5,0(a2)
    80001d5c:	03c0006f          	j	80001d98 <_ZN15MemoryAllocator15allocateSegmentEm+0xa4>
    for (FreeSegment* curr = freeListHead; curr; curr = curr->next) {
    80001d60:	00853503          	ld	a0,8(a0)
    80001d64:	fc050ee3          	beqz	a0,80001d40 <_ZN15MemoryAllocator15allocateSegmentEm+0x4c>
        if ((curr->size - 1) - size <= 1) {
    80001d68:	00053703          	ld	a4,0(a0)
    80001d6c:	40b707b3          	sub	a5,a4,a1
    80001d70:	fff78793          	addi	a5,a5,-1
    80001d74:	00100693          	li	a3,1
    80001d78:	f8f6fee3          	bgeu	a3,a5,80001d14 <_ZN15MemoryAllocator15allocateSegmentEm+0x20>
        } else if (curr->size > size && (curr->size - 1) - size >= 2) {
    80001d7c:	fee5f2e3          	bgeu	a1,a4,80001d60 <_ZN15MemoryAllocator15allocateSegmentEm+0x6c>
            auto newFreeFragment = (FreeSegment*)(reinterpret_cast<char*>(curr) + (size + 1) * MEM_BLOCK_SIZE);
    80001d80:	00158693          	addi	a3,a1,1
    80001d84:	00669793          	slli	a5,a3,0x6
    80001d88:	00f507b3          	add	a5,a0,a5
            if (curr->prev) curr->prev->next = newFreeFragment;
    80001d8c:	01053703          	ld	a4,16(a0)
    80001d90:	fc0704e3          	beqz	a4,80001d58 <_ZN15MemoryAllocator15allocateSegmentEm+0x64>
    80001d94:	00f73423          	sd	a5,8(a4)
            if (curr->next) curr->next->prev = newFreeFragment;
    80001d98:	00853703          	ld	a4,8(a0)
    80001d9c:	00070463          	beqz	a4,80001da4 <_ZN15MemoryAllocator15allocateSegmentEm+0xb0>
    80001da0:	00f73823          	sd	a5,16(a4)
            newFreeFragment->prev = curr->prev;
    80001da4:	01053703          	ld	a4,16(a0)
    80001da8:	00e7b823          	sd	a4,16(a5)
            newFreeFragment->next = curr->next;
    80001dac:	00853703          	ld	a4,8(a0)
    80001db0:	00e7b423          	sd	a4,8(a5)
            newFreeFragment->size = curr->size - (size + 1);
    80001db4:	00053703          	ld	a4,0(a0)
    80001db8:	40b705b3          	sub	a1,a4,a1
    80001dbc:	fff58593          	addi	a1,a1,-1
    80001dc0:	00b7b023          	sd	a1,0(a5)
            curr->size = size + 1;
    80001dc4:	00d53023          	sd	a3,0(a0)
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
    80001dc8:	04050513          	addi	a0,a0,64
    80001dcc:	f75ff06f          	j	80001d40 <_ZN15MemoryAllocator15allocateSegmentEm+0x4c>
    if (size >= totalNumberOfBlocks) return nullptr; // ako je zatrazeno vise blokova memorije nego sto ukupno ima na raspolaganju
    80001dd0:	00000513          	li	a0,0
    80001dd4:	f6dff06f          	j	80001d40 <_ZN15MemoryAllocator15allocateSegmentEm+0x4c>

0000000080001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>:

// parametar ptr je pokazivac na memoriju koju korisnik zeli da oslobodi; static_cast<char*>(ptr) - MEM_BLOCK_SIZE je adresa pocetka
// strukture za ulancavanje od segmenta memorije koju korisnik zeli da oslobodi
int MemoryAllocator::deallocateSegment(void *ptr) {
    80001dd8:	ff010113          	addi	sp,sp,-16
    80001ddc:	00813423          	sd	s0,8(sp)
    80001de0:	01010413          	addi	s0,sp,16
    if (!ptr || !(
    80001de4:	14058a63          	beqz	a1,80001f38 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x160>
        reinterpret_cast<size_t>(HEAP_START_ADDR) <= reinterpret_cast<size_t>(ptr) &&
    80001de8:	0000a797          	auipc	a5,0xa
    80001dec:	e887b783          	ld	a5,-376(a5) # 8000bc70 <_GLOBAL_OFFSET_TABLE_+0x18>
    80001df0:	0007b783          	ld	a5,0(a5)
    if (!ptr || !(
    80001df4:	14f5e663          	bltu	a1,a5,80001f40 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x168>
        reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 >= reinterpret_cast<size_t>(ptr))) return -1;
    80001df8:	0000a797          	auipc	a5,0xa
    80001dfc:	eb07b783          	ld	a5,-336(a5) # 8000bca8 <_GLOBAL_OFFSET_TABLE_+0x50>
    80001e00:	0007b783          	ld	a5,0(a5)
    80001e04:	fff78793          	addi	a5,a5,-1
    if (!ptr || !(
    80001e08:	14b7e063          	bltu	a5,a1,80001f48 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x170>
    // postavljam ptr da pokazuje na pocetak strukture za ulancavanje segmenta memorije koji treba osloboditi
    ptr = static_cast<char*>(ptr) - MEM_BLOCK_SIZE;
    80001e0c:	fc058693          	addi	a3,a1,-64
    // nalazenje mesta gde treba umetnuti novi slobodan segment (to je segment na koji pokazuje pokazivac ptr)
    FreeSegment* curr;
    if (!freeListHead || static_cast<FreeSegment*>(ptr) < freeListHead) {
    80001e10:	00053603          	ld	a2,0(a0)
    80001e14:	06060a63          	beqz	a2,80001e88 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xb0>
    80001e18:	06c6ec63          	bltu	a3,a2,80001e90 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xb8>
        // novi slobodan segment treba umetnuti na pocetak liste slobodnih segmenata
        curr = nullptr;
    } else {
        // nalazenje mesta (to ce biti odmah nakon curr) gde treba umetnuti novi slobodan segment
        for (curr = freeListHead; curr->next && static_cast<FreeSegment*>(ptr) > curr->next; curr = curr->next);
    80001e1c:	00060793          	mv	a5,a2
    80001e20:	00078713          	mv	a4,a5
    80001e24:	0087b783          	ld	a5,8(a5)
    80001e28:	00078463          	beqz	a5,80001e30 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x58>
    80001e2c:	fed7eae3          	bltu	a5,a3,80001e20 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x48>
    }
    // pokusaj spajanja novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (curr)
    if (curr && reinterpret_cast<char*>(curr) + curr->size * MEM_BLOCK_SIZE == static_cast<char*>(ptr)) {
    80001e30:	06070263          	beqz	a4,80001e94 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xbc>
    80001e34:	00073883          	ld	a7,0(a4)
    80001e38:	00689813          	slli	a6,a7,0x6
    80001e3c:	01070833          	add	a6,a4,a6
    80001e40:	04d81a63          	bne	a6,a3,80001e94 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xbc>
        // spajanje novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (curr)
        curr->size += (static_cast<FreeSegment*>(ptr))->size;
    80001e44:	fc05b683          	ld	a3,-64(a1)
    80001e48:	00d888b3          	add	a7,a7,a3
    80001e4c:	01173023          	sd	a7,0(a4)
        // pokusaj spajanja slobodnog segmenta (curr) sa narednim slobodnim segmentom (curr->next)
        if (curr->next && reinterpret_cast<char*>(curr) + curr->size * MEM_BLOCK_SIZE == reinterpret_cast<char*>(curr->next)) {
    80001e50:	00078863          	beqz	a5,80001e60 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x88>
    80001e54:	00689693          	slli	a3,a7,0x6
    80001e58:	00d706b3          	add	a3,a4,a3
    80001e5c:	00d78663          	beq	a5,a3,80001e68 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x90>
            curr->size += curr->next->size;
            // uklanjanje segmenta curr->next iz liste slobodnih segmenata
            curr->next = curr->next->next;
            if (curr->next) curr->next->prev = curr;
        }
        return 0;
    80001e60:	00000513          	li	a0,0
    80001e64:	0740006f          	j	80001ed8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
            curr->size += curr->next->size;
    80001e68:	0007b683          	ld	a3,0(a5)
    80001e6c:	00d888b3          	add	a7,a7,a3
    80001e70:	01173023          	sd	a7,0(a4)
            curr->next = curr->next->next;
    80001e74:	0087b783          	ld	a5,8(a5)
    80001e78:	00f73423          	sd	a5,8(a4)
            if (curr->next) curr->next->prev = curr;
    80001e7c:	fe0782e3          	beqz	a5,80001e60 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x88>
    80001e80:	00e7b823          	sd	a4,16(a5)
    80001e84:	fddff06f          	j	80001e60 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x88>
        curr = nullptr;
    80001e88:	00060713          	mv	a4,a2
    80001e8c:	0080006f          	j	80001e94 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xbc>
    80001e90:	00000713          	li	a4,0
    } else {
        // pokusaj spajanja novog slobodnog segmenta (ptr) sa sledecim slobodnim segmentom (nextFreeSegment)
        FreeSegment* nextFreeSegment = curr ? curr->next : freeListHead;
    80001e94:	00070463          	beqz	a4,80001e9c <_ZN15MemoryAllocator17deallocateSegmentEPv+0xc4>
    80001e98:	00873603          	ld	a2,8(a4)
        if (nextFreeSegment &&
    80001e9c:	00060a63          	beqz	a2,80001eb0 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xd8>
        static_cast<char*>(ptr) + (static_cast<FreeSegment*>(ptr))->size * MEM_BLOCK_SIZE == reinterpret_cast<char*>(nextFreeSegment)) {
    80001ea0:	fc05b803          	ld	a6,-64(a1)
    80001ea4:	00681793          	slli	a5,a6,0x6
    80001ea8:	00f687b3          	add	a5,a3,a5
        if (nextFreeSegment &&
    80001eac:	02c78c63          	beq	a5,a2,80001ee4 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x10c>
            return 0;
        } else {
            // ova grana se izvrsava ako nema potrebe za bilo kakvim spajanjem slobodnih segmenata - jednostavno se
            // umece novi slobodni segment (ptr) nakon prethodnog slobodnog segmenta (curr)
            auto newFreeSegment = static_cast<FreeSegment*>(ptr);
            newFreeSegment->prev = curr;
    80001eb0:	fce5b823          	sd	a4,-48(a1)
            if (curr) newFreeSegment->next = curr->next;
    80001eb4:	06070863          	beqz	a4,80001f24 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x14c>
    80001eb8:	00873783          	ld	a5,8(a4)
    80001ebc:	fcf5b423          	sd	a5,-56(a1)
            else newFreeSegment->next = freeListHead;
            if (newFreeSegment->next) newFreeSegment->next->prev = newFreeSegment;
    80001ec0:	fc85b783          	ld	a5,-56(a1)
    80001ec4:	00078463          	beqz	a5,80001ecc <_ZN15MemoryAllocator17deallocateSegmentEPv+0xf4>
    80001ec8:	00d7b823          	sd	a3,16(a5)
            if (curr) curr->next = newFreeSegment;
    80001ecc:	06070263          	beqz	a4,80001f30 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x158>
    80001ed0:	00d73423          	sd	a3,8(a4)
            else freeListHead = newFreeSegment;
            return 0;
    80001ed4:	00000513          	li	a0,0
        }
    }
}
    80001ed8:	00813403          	ld	s0,8(sp)
    80001edc:	01010113          	addi	sp,sp,16
    80001ee0:	00008067          	ret
            newFreeSegment->size += nextFreeSegment->size;
    80001ee4:	00063783          	ld	a5,0(a2)
    80001ee8:	00f80833          	add	a6,a6,a5
    80001eec:	fd05b023          	sd	a6,-64(a1)
            newFreeSegment->prev = nextFreeSegment->prev;
    80001ef0:	01063783          	ld	a5,16(a2)
    80001ef4:	fcf5b823          	sd	a5,-48(a1)
            newFreeSegment->next = nextFreeSegment->next;
    80001ef8:	00863783          	ld	a5,8(a2)
    80001efc:	fcf5b423          	sd	a5,-56(a1)
            if (nextFreeSegment->next) nextFreeSegment->next->prev = newFreeSegment;
    80001f00:	00078463          	beqz	a5,80001f08 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x130>
    80001f04:	00d7b823          	sd	a3,16(a5)
            if (nextFreeSegment->prev) nextFreeSegment->prev->next = newFreeSegment;
    80001f08:	01063783          	ld	a5,16(a2)
    80001f0c:	00078863          	beqz	a5,80001f1c <_ZN15MemoryAllocator17deallocateSegmentEPv+0x144>
    80001f10:	00d7b423          	sd	a3,8(a5)
            return 0;
    80001f14:	00000513          	li	a0,0
    80001f18:	fc1ff06f          	j	80001ed8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
            else freeListHead = newFreeSegment;
    80001f1c:	00d53023          	sd	a3,0(a0)
    80001f20:	ff5ff06f          	j	80001f14 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x13c>
            else newFreeSegment->next = freeListHead;
    80001f24:	00053783          	ld	a5,0(a0)
    80001f28:	fcf5b423          	sd	a5,-56(a1)
    80001f2c:	f95ff06f          	j	80001ec0 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xe8>
            else freeListHead = newFreeSegment;
    80001f30:	00d53023          	sd	a3,0(a0)
    80001f34:	fa1ff06f          	j	80001ed4 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xfc>
        reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 >= reinterpret_cast<size_t>(ptr))) return -1;
    80001f38:	fff00513          	li	a0,-1
    80001f3c:	f9dff06f          	j	80001ed8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
    80001f40:	fff00513          	li	a0,-1
    80001f44:	f95ff06f          	j	80001ed8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
    80001f48:	fff00513          	li	a0,-1
    80001f4c:	f8dff06f          	j	80001ed8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>

0000000080001f50 <_Z12idleFunctionPv>:
#include "../../../h/Code/Thread/TCB.hpp"

// ovo je telo funkcije koje ce izvrsavati idle nit (besposlena, vrti se u beskonacnoj petlji)
// ona se daje procesoru samo onda kada nema drugih spremnih niti u scheduleru
[[noreturn]] void idleFunction(void* arg) { while (true) { } }
    80001f50:	ff010113          	addi	sp,sp,-16
    80001f54:	00813423          	sd	s0,8(sp)
    80001f58:	01010413          	addi	s0,sp,16
    80001f5c:	0000006f          	j	80001f5c <_Z12idleFunctionPv+0xc>

0000000080001f60 <_Z19removeFromSchedulerRP3TCBS1_>:

// uzimamo element sa pocetka ulancane liste
TCB* removeFromScheduler(TCB*& head, TCB*& tail) {
    80001f60:	ff010113          	addi	sp,sp,-16
    80001f64:	00813423          	sd	s0,8(sp)
    80001f68:	01010413          	addi	s0,sp,16
    80001f6c:	00050793          	mv	a5,a0
    if (!head || !tail) return nullptr; // ovaj slucaj moze da se dogodi samo ako idle nit jos nije ubacena, a trazena je nit iz schedulera
    80001f70:	00053503          	ld	a0,0(a0)
    80001f74:	02050263          	beqz	a0,80001f98 <_Z19removeFromSchedulerRP3TCBS1_+0x38>
    80001f78:	0005b703          	ld	a4,0(a1)
    80001f7c:	02070463          	beqz	a4,80001fa4 <_Z19removeFromSchedulerRP3TCBS1_+0x44>
    if (head == tail) return head; // slucaj kada je u scheduleru samo idle nit - nju vracamo i ne izbacujemo nikad iz schedulera
    80001f80:	00e50c63          	beq	a0,a4,80001f98 <_Z19removeFromSchedulerRP3TCBS1_+0x38>

    // privatne atribute schedulerPrevThread i schedulerNextThread sam ispravno enkapsulirao jer su oni upravo privatni
    // i mogu se modifikovati samo kroz setter metode, a mogu da se procitaju samo preko getter metoda
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    TCB* getNextThreadScheduler() const { return schedulerNextThread; }
    80001f84:	03853703          	ld	a4,56(a0)
    TCB* thread = head;
    head = head->getNextThreadScheduler();
    80001f88:	00e7b023          	sd	a4,0(a5)
    80001f8c:	03853783          	ld	a5,56(a0)
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    80001f90:	0407b023          	sd	zero,64(a5)
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }
    80001f94:	02053c23          	sd	zero,56(a0)
    thread->getNextThreadScheduler()->setPrevThreadScheduler(nullptr);
    thread->setNextThreadScheduler(nullptr);
    return thread;
}
    80001f98:	00813403          	ld	s0,8(sp)
    80001f9c:	01010113          	addi	sp,sp,16
    80001fa0:	00008067          	ret
    if (!head || !tail) return nullptr; // ovaj slucaj moze da se dogodi samo ako idle nit jos nije ubacena, a trazena je nit iz schedulera
    80001fa4:	00070513          	mv	a0,a4
    80001fa8:	ff1ff06f          	j	80001f98 <_Z19removeFromSchedulerRP3TCBS1_+0x38>

0000000080001fac <_Z19insertIntoSchedulerRP3TCBS1_S0_>:

// umecemo u ulancanu listu; ukoliko prvi put umecemo, to je slucaj kada se umece idle nit;
// kada budemo umetali sve naredne niti, umecemo ih tako da idle nit uvek bude poslednja;
// idle nit se nikada ne izbacuje iz scheduler-a nakon sto se ubaci u scheduler;
void insertIntoScheduler(TCB*& head, TCB*& tail, TCB* tcb) {
    80001fac:	ff010113          	addi	sp,sp,-16
    80001fb0:	00813423          	sd	s0,8(sp)
    80001fb4:	01010413          	addi	s0,sp,16
    if (!tcb) return;
    80001fb8:	04060463          	beqz	a2,80002000 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x54>
    if (!head || !tail) { head = tail = tcb; return; } // ubacivanje idle niti na pocetku dok je jos nismo prvi put ubacili
    80001fbc:	00053783          	ld	a5,0(a0)
    80001fc0:	04078663          	beqz	a5,8000200c <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x60>
    80001fc4:	0005b783          	ld	a5,0(a1)
    80001fc8:	04078263          	beqz	a5,8000200c <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x60>
    Body getBody() const { return body; }
    80001fcc:	00063683          	ld	a3,0(a2)
    if (tcb->getBody() == &idleFunction) return; // pokusaj ubacivanja idle niti kada je ona vec u scheduleru - bez efekta
    80001fd0:	00000717          	auipc	a4,0x0
    80001fd4:	f8070713          	addi	a4,a4,-128 # 80001f50 <_Z12idleFunctionPv>
    80001fd8:	02e68463          	beq	a3,a4,80002000 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x54>
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }
    80001fdc:	02f63c23          	sd	a5,56(a2)
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    80001fe0:	0407b783          	ld	a5,64(a5)
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    80001fe4:	04f63023          	sd	a5,64(a2)
    tcb->setNextThreadScheduler(tail);
    tcb->setPrevThreadScheduler(tail->getPrevThreadScheduler());
    if (tail->getPrevThreadScheduler()) tail->getPrevThreadScheduler()->setNextThreadScheduler(tcb);
    80001fe8:	0005b783          	ld	a5,0(a1)
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    80001fec:	0407b783          	ld	a5,64(a5)
    80001ff0:	02078463          	beqz	a5,80002018 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x6c>
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }
    80001ff4:	02c7bc23          	sd	a2,56(a5)
    else head = tcb;
    tail->setPrevThreadScheduler(tcb);
    80001ff8:	0005b783          	ld	a5,0(a1)
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    80001ffc:	04c7b023          	sd	a2,64(a5)
}
    80002000:	00813403          	ld	s0,8(sp)
    80002004:	01010113          	addi	sp,sp,16
    80002008:	00008067          	ret
    if (!head || !tail) { head = tail = tcb; return; } // ubacivanje idle niti na pocetku dok je jos nismo prvi put ubacili
    8000200c:	00c5b023          	sd	a2,0(a1)
    80002010:	00c53023          	sd	a2,0(a0)
    80002014:	fedff06f          	j	80002000 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x54>
    else head = tcb;
    80002018:	00c53023          	sd	a2,0(a0)
    8000201c:	fddff06f          	j	80001ff8 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x4c>

0000000080002020 <_ZN9Scheduler11getInstanceEv>:
#include "../../../h/Code/Scheduler/Scheduler.hpp"

Scheduler& Scheduler::getInstance() {
    80002020:	ff010113          	addi	sp,sp,-16
    80002024:	00813423          	sd	s0,8(sp)
    80002028:	01010413          	addi	s0,sp,16
    static Scheduler scheduler;
    return scheduler;
}
    8000202c:	0000a517          	auipc	a0,0xa
    80002030:	cf450513          	addi	a0,a0,-780 # 8000bd20 <_ZZN9Scheduler11getInstanceEvE9scheduler>
    80002034:	00813403          	ld	s0,8(sp)
    80002038:	01010113          	addi	sp,sp,16
    8000203c:	00008067          	ret

0000000080002040 <_ZN9Scheduler3getEv>:

// uzima se nit sa pocetka ulancane liste schedulera i daje se procesoru
// u slucaju da takve niti nema, onda se procesoru daje nit koja izvrsava funkciju idleFunction (beskonacno se vrti u praznoj petlji)
TCB* Scheduler::get() {
    80002040:	ff010113          	addi	sp,sp,-16
    80002044:	00113423          	sd	ra,8(sp)
    80002048:	00813023          	sd	s0,0(sp)
    8000204c:	01010413          	addi	s0,sp,16
    return removeFromScheduler(schedulerHead, scheduletTail);
    80002050:	00850593          	addi	a1,a0,8
    80002054:	00000097          	auipc	ra,0x0
    80002058:	f0c080e7          	jalr	-244(ra) # 80001f60 <_Z19removeFromSchedulerRP3TCBS1_>
}
    8000205c:	00813083          	ld	ra,8(sp)
    80002060:	00013403          	ld	s0,0(sp)
    80002064:	01010113          	addi	sp,sp,16
    80002068:	00008067          	ret

000000008000206c <_ZN9Scheduler3putEP3TCB>:

// nova nit se smesta na kraj ulancane liste schedulera
void Scheduler::put(TCB* tcb) {
    8000206c:	ff010113          	addi	sp,sp,-16
    80002070:	00113423          	sd	ra,8(sp)
    80002074:	00813023          	sd	s0,0(sp)
    80002078:	01010413          	addi	s0,sp,16
    8000207c:	00058613          	mv	a2,a1
    insertIntoScheduler(schedulerHead, scheduletTail, tcb);
    80002080:	00850593          	addi	a1,a0,8
    80002084:	00000097          	auipc	ra,0x0
    80002088:	f28080e7          	jalr	-216(ra) # 80001fac <_Z19insertIntoSchedulerRP3TCBS1_S0_>
    8000208c:	00813083          	ld	ra,8(sp)
    80002090:	00013403          	ld	s0,0(sp)
    80002094:	01010113          	addi	sp,sp,16
    80002098:	00008067          	ret

000000008000209c <_ZN5Riscv18exitSupervisorTrapEv>:
#include "../../../h/Code/MemoryAllocator/MemoryAllocator.hpp"
#include "../../../h/Code/Thread/TCB.hpp"
#include "../../../h/Code/Semaphore/KernelSemaphore.hpp"
#include "../../../h/Code/Console/KernelBuffer.hpp"

void Riscv::exitSupervisorTrap() {
    8000209c:	ff010113          	addi	sp,sp,-16
    800020a0:	00813423          	sd	s0,8(sp)
    800020a4:	01010413          	addi	s0,sp,16
    __asm__ volatile ("csrw sepc, ra"); // u sepc postavljamo vrednost ra jer hocemo da se tu vratimo nakon sret koji cemo pozvati
    800020a8:	14109073          	csrw	sepc,ra
    __asm__ volatile ("sret");
    800020ac:	10200073          	sret
    // sret instrukcija radi sledece:
    // prelazi se u rezim koji pise u SPP, u pc se upisuje vrednost iz sepc i u bit SIE sstatus registra se upisuje vrednost bita SPIE
}
    800020b0:	00813403          	ld	s0,8(sp)
    800020b4:	01010113          	addi	sp,sp,16
    800020b8:	00008067          	ret

00000000800020bc <_ZN5Riscv20handleSupervisorTrapEv>:

void Riscv::handleSupervisorTrap() {
    800020bc:	f4010113          	addi	sp,sp,-192
    800020c0:	0a113c23          	sd	ra,184(sp)
    800020c4:	0a813823          	sd	s0,176(sp)
    800020c8:	0a913423          	sd	s1,168(sp)
    800020cc:	0b213023          	sd	s2,160(sp)
    800020d0:	0c010413          	addi	s0,sp,192

    // alokacija prostora na steku za registre a0-a7; hocemo na steku da ih sacuvamo jer su to parametri sistemskih poziva a kompajler moze da ih uprlja
    __asm__ volatile ("addi sp,sp,-64");
    800020d4:	fc010113          	addi	sp,sp,-64
    // cuvanje registara a0-a7 na steku
    pushSysCallParameters();
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	f48080e7          	jalr	-184(ra) # 80001020 <_ZN5Riscv21pushSysCallParametersEv>
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
}

inline uint64 Riscv::readScause() {
    uint64 volatile scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    800020e0:	142027f3          	csrr	a5,scause
    800020e4:	f8f43023          	sd	a5,-128(s0)
    return scause;
    800020e8:	f8043783          	ld	a5,-128(s0)

    // citanje razloga ulaska u prekidnu rutinu i smestanje u promenljivu scause
    uint64 volatile scause = readScause();
    800020ec:	fcf43c23          	sd	a5,-40(s0)

    if (scause == 0x0000000000000008UL || scause == 0x0000000000000009UL) {
    800020f0:	fd843703          	ld	a4,-40(s0)
    800020f4:	00800793          	li	a5,8
    800020f8:	08f70463          	beq	a4,a5,80002180 <_ZN5Riscv20handleSupervisorTrapEv+0xc4>
    800020fc:	fd843703          	ld	a4,-40(s0)
    80002100:	00900793          	li	a5,9
    80002104:	06f70e63          	beq	a4,a5,80002180 <_ZN5Riscv20handleSupervisorTrapEv+0xc4>
        writeSepc(sepc);
        if (sysCallCode != 0x50 && sysCallCode != 0x51) {
            writeSstatus(sstatus);
        }

    } else if (scause == 0x0000000000000002UL) {
    80002108:	fd843703          	ld	a4,-40(s0)
    8000210c:	00200793          	li	a5,2
    80002110:	38f70663          	beq	a4,a5,8000249c <_ZN5Riscv20handleSupervisorTrapEv+0x3e0>
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: ilegalna instrukcija

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x0000000000000005UL) {
    80002114:	fd843703          	ld	a4,-40(s0)
    80002118:	00500793          	li	a5,5
    8000211c:	3af70463          	beq	a4,a5,800024c4 <_ZN5Riscv20handleSupervisorTrapEv+0x408>
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: nedozvoljena adresa citanja

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x0000000000000007UL) {
    80002120:	fd843703          	ld	a4,-40(s0)
    80002124:	00700793          	li	a5,7
    80002128:	3cf70263          	beq	a4,a5,800024ec <_ZN5Riscv20handleSupervisorTrapEv+0x430>
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: nedozvoljena adresa upisa

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x8000000000000001UL) {
    8000212c:	fd843703          	ld	a4,-40(s0)
    80002130:	fff00793          	li	a5,-1
    80002134:	03f79793          	slli	a5,a5,0x3f
    80002138:	00178793          	addi	a5,a5,1
    8000213c:	3cf70c63          	beq	a4,a5,80002514 <_ZN5Riscv20handleSupervisorTrapEv+0x458>
            TCB::dispatch(); // promena konteksta
            writeSepc(sepc);
            writeSstatus(sstatus);
        }

    } else if (scause == 0x8000000000000009UL) {
    80002140:	fd843703          	ld	a4,-40(s0)
    80002144:	fff00793          	li	a5,-1
    80002148:	03f79793          	slli	a5,a5,0x3f
    8000214c:	00978793          	addi	a5,a5,9
    80002150:	18f71063          	bne	a4,a5,800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
        // spoljasnji prekid (tajmer ili konzola): da; razlog prekida: spoljasnji hardverski prekid od konzole

        // od kontrolera prekida saznajemo koji uredjaj je generisao prekid pozivajuci funkciju plic_claim
        int externalInterruptCode = plic_claim();
    80002154:	00005097          	auipc	ra,0x5
    80002158:	620080e7          	jalr	1568(ra) # 80007774 <plic_claim>
    8000215c:	00050913          	mv	s2,a0

        if (externalInterruptCode == CONSOLE_IRQ) {
    80002160:	00a00793          	li	a5,10
    80002164:	42f50863          	beq	a0,a5,80002594 <_ZN5Riscv20handleSupervisorTrapEv+0x4d8>
            }

        }

        // kontroler prekida se obavestava da je prekid obradjen
        plic_complete(externalInterruptCode);
    80002168:	00090513          	mv	a0,s2
    8000216c:	00005097          	auipc	ra,0x5
    80002170:	640080e7          	jalr	1600(ra) # 800077ac <plic_complete>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    80002174:	20000793          	li	a5,512
    80002178:	1447b073          	csrc	sip,a5
}
    8000217c:	1540006f          	j	800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80002180:	141027f3          	csrr	a5,sepc
    80002184:	f8f43823          	sd	a5,-112(s0)
    return sepc;
    80002188:	f9043783          	ld	a5,-112(s0)
        uint64 volatile sepc = readSepc() + 4;
    8000218c:	00478793          	addi	a5,a5,4
    80002190:	f4f43423          	sd	a5,-184(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80002194:	100027f3          	csrr	a5,sstatus
    80002198:	f8f43423          	sd	a5,-120(s0)
    return sstatus;
    8000219c:	f8843783          	ld	a5,-120(s0)
        uint64 volatile sstatus = readSstatus();
    800021a0:	f4f43823          	sd	a5,-176(s0)
        __asm__ volatile ("ld %[sysCallCode],0(sp)" : [sysCallCode] "=r"(sysCallCode));
    800021a4:	00013783          	ld	a5,0(sp)
    800021a8:	f4f43c23          	sd	a5,-168(s0)
        if (sysCallCode == 0x01) {
    800021ac:	f5843703          	ld	a4,-168(s0)
    800021b0:	00100793          	li	a5,1
    800021b4:	0cf70863          	beq	a4,a5,80002284 <_ZN5Riscv20handleSupervisorTrapEv+0x1c8>
        } else if (sysCallCode == 0x02) {
    800021b8:	f5843703          	ld	a4,-168(s0)
    800021bc:	00200793          	li	a5,2
    800021c0:	12f70663          	beq	a4,a5,800022ec <_ZN5Riscv20handleSupervisorTrapEv+0x230>
        } else if (sysCallCode == 0x11) {
    800021c4:	f5843703          	ld	a4,-168(s0)
    800021c8:	01100793          	li	a5,17
    800021cc:	14f70263          	beq	a4,a5,80002310 <_ZN5Riscv20handleSupervisorTrapEv+0x254>
        } else if (sysCallCode == 0x12) {
    800021d0:	f5843703          	ld	a4,-168(s0)
    800021d4:	01200793          	li	a5,18
    800021d8:	14f70e63          	beq	a4,a5,80002334 <_ZN5Riscv20handleSupervisorTrapEv+0x278>
        } else if (sysCallCode == 0x13) {
    800021dc:	f5843703          	ld	a4,-168(s0)
    800021e0:	01300793          	li	a5,19
    800021e4:	16f70863          	beq	a4,a5,80002354 <_ZN5Riscv20handleSupervisorTrapEv+0x298>
        } else if (sysCallCode == 0x14) {
    800021e8:	f5843703          	ld	a4,-168(s0)
    800021ec:	01400793          	li	a5,20
    800021f0:	16f70863          	beq	a4,a5,80002360 <_ZN5Riscv20handleSupervisorTrapEv+0x2a4>
        } else if (sysCallCode == 0x15) {
    800021f4:	f5843703          	ld	a4,-168(s0)
    800021f8:	01500793          	li	a5,21
    800021fc:	18f70463          	beq	a4,a5,80002384 <_ZN5Riscv20handleSupervisorTrapEv+0x2c8>
        } else if (sysCallCode == 0x16) {
    80002200:	f5843703          	ld	a4,-168(s0)
    80002204:	01600793          	li	a5,22
    80002208:	18f70c63          	beq	a4,a5,800023a0 <_ZN5Riscv20handleSupervisorTrapEv+0x2e4>
        else if (sysCallCode == 0x21) {
    8000220c:	f5843703          	ld	a4,-168(s0)
    80002210:	02100793          	li	a5,33
    80002214:	1af70a63          	beq	a4,a5,800023c8 <_ZN5Riscv20handleSupervisorTrapEv+0x30c>
        } else if (sysCallCode == 0x22) {
    80002218:	f5843703          	ld	a4,-168(s0)
    8000221c:	02200793          	li	a5,34
    80002220:	1cf70463          	beq	a4,a5,800023e8 <_ZN5Riscv20handleSupervisorTrapEv+0x32c>
        } else if (sysCallCode == 0x23) {
    80002224:	f5843703          	ld	a4,-168(s0)
    80002228:	02300793          	li	a5,35
    8000222c:	1cf70863          	beq	a4,a5,800023fc <_ZN5Riscv20handleSupervisorTrapEv+0x340>
        } else if (sysCallCode == 0x24) {
    80002230:	f5843703          	ld	a4,-168(s0)
    80002234:	02400793          	li	a5,36
    80002238:	1ef70a63          	beq	a4,a5,8000242c <_ZN5Riscv20handleSupervisorTrapEv+0x370>
        } else if (sysCallCode == 0x31) {
    8000223c:	f5843703          	ld	a4,-168(s0)
    80002240:	03100793          	li	a5,49
    80002244:	1ef70c63          	beq	a4,a5,8000243c <_ZN5Riscv20handleSupervisorTrapEv+0x380>
        } else if (sysCallCode == 0x41) {
    80002248:	f5843703          	ld	a4,-168(s0)
    8000224c:	04100793          	li	a5,65
    80002250:	20f70463          	beq	a4,a5,80002458 <_ZN5Riscv20handleSupervisorTrapEv+0x39c>
        } else if (sysCallCode == 0x42) {
    80002254:	f5843703          	ld	a4,-168(s0)
    80002258:	04200793          	li	a5,66
    8000225c:	20f70a63          	beq	a4,a5,80002470 <_ZN5Riscv20handleSupervisorTrapEv+0x3b4>
        } else if (sysCallCode == 0x50) {
    80002260:	f5843703          	ld	a4,-168(s0)
    80002264:	05000793          	li	a5,80
    80002268:	22f70463          	beq	a4,a5,80002490 <_ZN5Riscv20handleSupervisorTrapEv+0x3d4>
        } else if (sysCallCode == 0x51) {
    8000226c:	f5843703          	ld	a4,-168(s0)
    80002270:	05100793          	li	a5,81
    80002274:	02f71863          	bne	a4,a5,800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    80002278:	10000793          	li	a5,256
    8000227c:	1007a073          	csrs	sstatus,a5
}
    80002280:	0240006f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[numberOfBlocks],8(sp)" : [numberOfBlocks] "=r"(numberOfBlocks));
    80002284:	00813783          	ld	a5,8(sp)
    80002288:	f6f43023          	sd	a5,-160(s0)
            void* allocatedMemory = MemoryAllocator::getInstance().allocateSegment(numberOfBlocks);
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	a0c080e7          	jalr	-1524(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80002294:	f6043583          	ld	a1,-160(s0)
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	a5c080e7          	jalr	-1444(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
            __asm__ volatile ("mv a0,%[allocatedMemory]" : : [allocatedMemory] "r"(allocatedMemory));
    800022a0:	00050513          	mv	a0,a0
        __asm__ volatile ("sd a0,10*8(s0)"); // a0 je zapravo registar x10 - pise u dokumentaciji
    800022a4:	04a43823          	sd	a0,80(s0)
        writeSepc(sepc);
    800022a8:	f4843783          	ld	a5,-184(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    800022ac:	14179073          	csrw	sepc,a5
        if (sysCallCode != 0x50 && sysCallCode != 0x51) {
    800022b0:	f5843703          	ld	a4,-168(s0)
    800022b4:	05000793          	li	a5,80
    800022b8:	00f70c63          	beq	a4,a5,800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    800022bc:	f5843703          	ld	a4,-168(s0)
    800022c0:	05100793          	li	a5,81
    800022c4:	00f70663          	beq	a4,a5,800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
            writeSstatus(sstatus);
    800022c8:	f5043783          	ld	a5,-176(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    800022cc:	10079073          	csrw	sstatus,a5
        maskClearBitsSip(SIP_SEIP); // brise se zahtev za spoljasnjim hardverskim prekidom
    }

    // ciscenje steka - vise nisu potrebni parametri sistemskog poziva/prekida/izuzetka na steku posto je sad to obradjeno
    __asm__ volatile ("addi sp,sp,64");
    800022d0:	04010113          	addi	sp,sp,64

    800022d4:	0b813083          	ld	ra,184(sp)
    800022d8:	0b013403          	ld	s0,176(sp)
    800022dc:	0a813483          	ld	s1,168(sp)
    800022e0:	0a013903          	ld	s2,160(sp)
    800022e4:	0c010113          	addi	sp,sp,192
    800022e8:	00008067          	ret
            __asm__ volatile ("ld %[freeThisMemory],8(sp)" : [freeThisMemory] "=r"(freeThisMemory));
    800022ec:	00813783          	ld	a5,8(sp)
    800022f0:	f6f43423          	sd	a5,-152(s0)
            int successInfo = MemoryAllocator::getInstance().deallocateSegment(freeThisMemory);
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	9a4080e7          	jalr	-1628(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    800022fc:	f6843583          	ld	a1,-152(s0)
    80002300:	00000097          	auipc	ra,0x0
    80002304:	ad8080e7          	jalr	-1320(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
            __asm__ volatile ("mv a0,%[successInfo]" : : [successInfo] "r"(successInfo));
    80002308:	00050513          	mv	a0,a0
    8000230c:	f99ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    80002310:	00813483          	ld	s1,8(sp)
            __asm__ volatile ("ld %[startRoutine],16(sp)" : [startRoutine] "=r"(startRoutine));
    80002314:	01013503          	ld	a0,16(sp)
            __asm__ volatile ("ld %[arg],24(sp)" : [arg] "=r"(arg));
    80002318:	01813583          	ld	a1,24(sp)
            __asm__ volatile ("ld %[stack],32(sp)" : [stack] "=r"(stack));
    8000231c:	02013603          	ld	a2,32(sp)
            *handle = TCB::createThread(startRoutine, arg, stack, false);
    80002320:	00000693          	li	a3,0
    80002324:	00004097          	auipc	ra,0x4
    80002328:	ddc080e7          	jalr	-548(ra) # 80006100 <_ZN3TCB12createThreadEPFvPvES0_S0_b>
    8000232c:	00a4b023          	sd	a0,0(s1)
    80002330:	f75ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            TCB::runningThread->setFinished(true);
    80002334:	0000a797          	auipc	a5,0xa
    80002338:	95c7b783          	ld	a5,-1700(a5) # 8000bc90 <_GLOBAL_OFFSET_TABLE_+0x38>
    8000233c:	0007b783          	ld	a5,0(a5)
    // zelimo da bas ta nit main-a nastavi da se izvrsava
    static TCB* createThread(Body body, void* arg, void* stack, bool cppApi);

    // obezbedjena enkapsulacija - atribut finished je privatan i moze se citati samo kroz getter metod, a menjati preko setter metoda
    bool getFinished() const { return finished; }
    void setFinished(bool value) { finished = value; }
    80002340:	00100713          	li	a4,1
    80002344:	02e78823          	sb	a4,48(a5)
            TCB::dispatch();
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	eac080e7          	jalr	-340(ra) # 800061f4 <_ZN3TCB8dispatchEv>
    80002350:	f55ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            TCB::dispatch();
    80002354:	00004097          	auipc	ra,0x4
    80002358:	ea0080e7          	jalr	-352(ra) # 800061f4 <_ZN3TCB8dispatchEv>
    8000235c:	f49ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    80002360:	00813483          	ld	s1,8(sp)
            __asm__ volatile ("ld %[startRoutine],16(sp)" : [startRoutine] "=r"(startRoutine));
    80002364:	01013503          	ld	a0,16(sp)
            __asm__ volatile ("ld %[arg],24(sp)" : [arg] "=r"(arg));
    80002368:	01813583          	ld	a1,24(sp)
            __asm__ volatile ("ld %[stack],32(sp)" : [stack] "=r"(stack));
    8000236c:	02013603          	ld	a2,32(sp)
            *handle = TCB::createThread(startRoutine, arg, stack, true);
    80002370:	00100693          	li	a3,1
    80002374:	00004097          	auipc	ra,0x4
    80002378:	d8c080e7          	jalr	-628(ra) # 80006100 <_ZN3TCB12createThreadEPFvPvES0_S0_b>
    8000237c:	00a4b023          	sd	a0,0(s1)
    80002380:	f25ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[thread],8(sp)" : [thread] "=r"(thread)); // citanje iz registra a1
    80002384:	00813483          	ld	s1,8(sp)
            Scheduler::getInstance().put(thread);
    80002388:	00000097          	auipc	ra,0x0
    8000238c:	c98080e7          	jalr	-872(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    80002390:	00048593          	mv	a1,s1
    80002394:	00000097          	auipc	ra,0x0
    80002398:	cd8080e7          	jalr	-808(ra) # 8000206c <_ZN9Scheduler3putEP3TCB>
    8000239c:	f09ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            int volatile threadId = TCB::runningThread->getThreadId();
    800023a0:	0000a797          	auipc	a5,0xa
    800023a4:	8f07b783          	ld	a5,-1808(a5) # 8000bc90 <_GLOBAL_OFFSET_TABLE_+0x38>
    800023a8:	0007b783          	ld	a5,0(a5)
    // ove metode sluze za postavljanje i dohvatanje flag-a koji nam govori da li je tekuca nit nasilno odblokirana tako sto je
    // semafor na kojem je ona cekala zatvoren sistemskim pozivom sem_close - u tom slucaju sem_wait treba da vrati gresku
    void setWaitSemaphoreFailed(bool value) { waitSemaphoreFailed = value; }
    bool getWaitSemaphoreFailed() const { return waitSemaphoreFailed; }

    int getThreadId() const { return threadId; }
    800023ac:	06c7a783          	lw	a5,108(a5)
    800023b0:	f4f42223          	sw	a5,-188(s0)
            TCB::dispatch();
    800023b4:	00004097          	auipc	ra,0x4
    800023b8:	e40080e7          	jalr	-448(ra) # 800061f4 <_ZN3TCB8dispatchEv>
            __asm__ volatile ("mv a0,%[threadId]" : : [threadId] "r"(threadId));
    800023bc:	f4442783          	lw	a5,-188(s0)
    800023c0:	00078513          	mv	a0,a5
    800023c4:	ee1ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    800023c8:	00813483          	ld	s1,8(sp)
            __asm__ volatile ("ld %[initialSemaphoreValue],16(sp)" : [initialSemaphoreValue] "=r"(initialSemaphoreValue)); // citanje iz registra a2
    800023cc:	01013503          	ld	a0,16(sp)
            *handle = KernelSemaphore::createSemaphore(initialSemaphoreValue);
    800023d0:	03051513          	slli	a0,a0,0x30
    800023d4:	03055513          	srli	a0,a0,0x30
    800023d8:	00003097          	auipc	ra,0x3
    800023dc:	080080e7          	jalr	128(ra) # 80005458 <_ZN15KernelSemaphore15createSemaphoreEt>
    800023e0:	00a4b023          	sd	a0,0(s1)
    800023e4:	ec1ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    800023e8:	00813503          	ld	a0,8(sp)
            int successInfo = KernelSemaphore::closeSemaphore(handle);
    800023ec:	00003097          	auipc	ra,0x3
    800023f0:	2cc080e7          	jalr	716(ra) # 800056b8 <_ZN15KernelSemaphore14closeSemaphoreEPS_>
            __asm__ volatile ("mv a0,%[successInfo]" : : [successInfo] "r"(successInfo));
    800023f4:	00050513          	mv	a0,a0
    800023f8:	eadff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[semaphoreId],8(sp)" : [semaphoreId] "=r"(semaphoreId)); // citanje iz registra a1
    800023fc:	00813503          	ld	a0,8(sp)
            semaphoreId->wait();
    80002400:	00003097          	auipc	ra,0x3
    80002404:	1dc080e7          	jalr	476(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>
            if (TCB::runningThread->getWaitSemaphoreFailed()) __asm__ volatile ("li a0,-1"); // slucaj kada je nit odblokirana sa sem_close umesto sem_signal
    80002408:	0000a797          	auipc	a5,0xa
    8000240c:	8887b783          	ld	a5,-1912(a5) # 8000bc90 <_GLOBAL_OFFSET_TABLE_+0x38>
    80002410:	0007b783          	ld	a5,0(a5)
    bool getWaitSemaphoreFailed() const { return waitSemaphoreFailed; }
    80002414:	0687c783          	lbu	a5,104(a5)
    80002418:	00078663          	beqz	a5,80002424 <_ZN5Riscv20handleSupervisorTrapEv+0x368>
    8000241c:	fff00513          	li	a0,-1
    80002420:	e85ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            else __asm__ volatile ("li a0,1"); // slucaj kada je nit odblokirana normalno pomocu sistemskog poziva sem_signal
    80002424:	00100513          	li	a0,1
    80002428:	e7dff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[semaphoreId],8(sp)" : [semaphoreId] "=r"(semaphoreId)); // citanje iz registra a1
    8000242c:	00813503          	ld	a0,8(sp)
            semaphoreId->signal();
    80002430:	00003097          	auipc	ra,0x3
    80002434:	310080e7          	jalr	784(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>
    80002438:	e6dff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[time], 8(sp)" : [time] "=r"(time)); // citanje iz registra a1
    8000243c:	00813503          	ld	a0,8(sp)
            TCB::insertSleepThread(time);
    80002440:	00004097          	auipc	ra,0x4
    80002444:	900080e7          	jalr	-1792(ra) # 80005d40 <_ZN3TCB17insertSleepThreadEm>
            TCB::suspendCurrentThread();
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	e24080e7          	jalr	-476(ra) # 8000626c <_ZN3TCB20suspendCurrentThreadEv>
            __asm__ volatile ("li a0,1");
    80002450:	00100513          	li	a0,1
    80002454:	e51ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            char inputCharacter = KernelBuffer::getcGetInstance()->removeFromBuffer();
    80002458:	00003097          	auipc	ra,0x3
    8000245c:	59c080e7          	jalr	1436(ra) # 800059f4 <_ZN12KernelBuffer15getcGetInstanceEv>
    80002460:	00003097          	auipc	ra,0x3
    80002464:	764080e7          	jalr	1892(ra) # 80005bc4 <_ZN12KernelBuffer16removeFromBufferEv>
            __asm__ volatile ("mv a0,%[inputCharacter]" : : [inputCharacter] "r"(inputCharacter));
    80002468:	00050513          	mv	a0,a0
    8000246c:	e39ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[outputCharacter], 8(sp)" : [outputCharacter] "=r"(outputCharacter)); // citanje iz registra a1
    80002470:	00813483          	ld	s1,8(sp)
    80002474:	0ff4f493          	andi	s1,s1,255
            KernelBuffer::putcGetInstance()->insertIntoBuffer(outputCharacter);
    80002478:	00003097          	auipc	ra,0x3
    8000247c:	4fc080e7          	jalr	1276(ra) # 80005974 <_ZN12KernelBuffer15putcGetInstanceEv>
    80002480:	00048593          	mv	a1,s1
    80002484:	00003097          	auipc	ra,0x3
    80002488:	6b0080e7          	jalr	1712(ra) # 80005b34 <_ZN12KernelBuffer16insertIntoBufferEi>
    8000248c:	e19ff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    80002490:	10000793          	li	a5,256
    80002494:	1007b073          	csrc	sstatus,a5
}
    80002498:	e0dff06f          	j	800022a4 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
        printErrorMessage(scause, readStval(), readSepc());
    8000249c:	fd843503          	ld	a0,-40(s0)
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
}

inline uint64 Riscv::readStval() {
    uint64 volatile stval;
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    800024a0:	143027f3          	csrr	a5,stval
    800024a4:	faf43023          	sd	a5,-96(s0)
    return stval;
    800024a8:	fa043583          	ld	a1,-96(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800024ac:	141027f3          	csrr	a5,sepc
    800024b0:	f8f43c23          	sd	a5,-104(s0)
    return sepc;
    800024b4:	f9843603          	ld	a2,-104(s0)
    800024b8:	00003097          	auipc	ra,0x3
    800024bc:	e1c080e7          	jalr	-484(ra) # 800052d4 <_Z17printErrorMessagemmm>
    800024c0:	e11ff06f          	j	800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
        printErrorMessage(scause, readStval(), readSepc());
    800024c4:	fd843503          	ld	a0,-40(s0)
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    800024c8:	143027f3          	csrr	a5,stval
    800024cc:	faf43823          	sd	a5,-80(s0)
    return stval;
    800024d0:	fb043583          	ld	a1,-80(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800024d4:	141027f3          	csrr	a5,sepc
    800024d8:	faf43423          	sd	a5,-88(s0)
    return sepc;
    800024dc:	fa843603          	ld	a2,-88(s0)
    800024e0:	00003097          	auipc	ra,0x3
    800024e4:	df4080e7          	jalr	-524(ra) # 800052d4 <_Z17printErrorMessagemmm>
    800024e8:	de9ff06f          	j	800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
        printErrorMessage(scause, readStval(), readSepc());
    800024ec:	fd843503          	ld	a0,-40(s0)
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    800024f0:	143027f3          	csrr	a5,stval
    800024f4:	fcf43023          	sd	a5,-64(s0)
    return stval;
    800024f8:	fc043583          	ld	a1,-64(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800024fc:	141027f3          	csrr	a5,sepc
    80002500:	faf43c23          	sd	a5,-72(s0)
    return sepc;
    80002504:	fb843603          	ld	a2,-72(s0)
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	dcc080e7          	jalr	-564(ra) # 800052d4 <_Z17printErrorMessagemmm>
    80002510:	dc1ff06f          	j	800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    80002514:	00200793          	li	a5,2
    80002518:	1447b073          	csrc	sip,a5
        TCB::updateSleepThreadList(); // azuriranje liste uspavanih niti
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	8f8080e7          	jalr	-1800(ra) # 80005e14 <_ZN3TCB21updateSleepThreadListEv>
        TCB::timeSliceCounter++; // povecava se brojac perioda tajmera za tekucu nit (runningThread)
    80002524:	00009717          	auipc	a4,0x9
    80002528:	76473703          	ld	a4,1892(a4) # 8000bc88 <_GLOBAL_OFFSET_TABLE_+0x30>
    8000252c:	00073783          	ld	a5,0(a4)
    80002530:	00178793          	addi	a5,a5,1
    80002534:	00f73023          	sd	a5,0(a4)
        if (TCB::timeSliceCounter >= TCB::runningThread->getTimeSlice()) {
    80002538:	00009717          	auipc	a4,0x9
    8000253c:	75873703          	ld	a4,1880(a4) # 8000bc90 <_GLOBAL_OFFSET_TABLE_+0x38>
    80002540:	00073703          	ld	a4,0(a4)
    uint64 getTimeSlice() const { return timeSlice; }
    80002544:	01073703          	ld	a4,16(a4)
    80002548:	d8e7e4e3          	bltu	a5,a4,800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    8000254c:	141027f3          	csrr	a5,sepc
    80002550:	fcf43823          	sd	a5,-48(s0)
    return sepc;
    80002554:	fd043783          	ld	a5,-48(s0)
            uint64 volatile sepc = readSepc();
    80002558:	f6f43823          	sd	a5,-144(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    8000255c:	100027f3          	csrr	a5,sstatus
    80002560:	fcf43423          	sd	a5,-56(s0)
    return sstatus;
    80002564:	fc843783          	ld	a5,-56(s0)
            uint64 volatile sstatus = readSstatus();
    80002568:	f6f43c23          	sd	a5,-136(s0)
            TCB::timeSliceCounter = 0;
    8000256c:	00009797          	auipc	a5,0x9
    80002570:	71c7b783          	ld	a5,1820(a5) # 8000bc88 <_GLOBAL_OFFSET_TABLE_+0x30>
    80002574:	0007b023          	sd	zero,0(a5)
            TCB::dispatch(); // promena konteksta
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	c7c080e7          	jalr	-900(ra) # 800061f4 <_ZN3TCB8dispatchEv>
            writeSepc(sepc);
    80002580:	f7043783          	ld	a5,-144(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    80002584:	14179073          	csrw	sepc,a5
            writeSstatus(sstatus);
    80002588:	f7843783          	ld	a5,-136(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    8000258c:	10079073          	csrw	sstatus,a5
}
    80002590:	d41ff06f          	j	800022d0 <_ZN5Riscv20handleSupervisorTrapEv+0x214>
            while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {
    80002594:	00009797          	auipc	a5,0x9
    80002598:	6d47b783          	ld	a5,1748(a5) # 8000bc68 <_GLOBAL_OFFSET_TABLE_+0x10>
    8000259c:	0007b783          	ld	a5,0(a5)
    800025a0:	0007c783          	lbu	a5,0(a5)
    800025a4:	0017f793          	andi	a5,a5,1
    800025a8:	bc0780e3          	beqz	a5,80002168 <_ZN5Riscv20handleSupervisorTrapEv+0xac>
                int consoleInput = *reinterpret_cast<char*>(CONSOLE_RX_DATA);
    800025ac:	00009797          	auipc	a5,0x9
    800025b0:	6b47b783          	ld	a5,1716(a5) # 8000bc60 <_GLOBAL_OFFSET_TABLE_+0x8>
    800025b4:	0007b783          	ld	a5,0(a5)
    800025b8:	0007c483          	lbu	s1,0(a5)
                KernelBuffer::getcGetInstance()->insertIntoBuffer(consoleInput);
    800025bc:	00003097          	auipc	ra,0x3
    800025c0:	438080e7          	jalr	1080(ra) # 800059f4 <_ZN12KernelBuffer15getcGetInstanceEv>
    800025c4:	00048593          	mv	a1,s1
    800025c8:	00003097          	auipc	ra,0x3
    800025cc:	56c080e7          	jalr	1388(ra) # 80005b34 <_ZN12KernelBuffer16insertIntoBufferEi>
            while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {
    800025d0:	fc5ff06f          	j	80002594 <_ZN5Riscv20handleSupervisorTrapEv+0x4d8>

00000000800025d4 <_Z8userMainPv>:
#include "../../h/Testing/Testing_OS1/Consumer_Producer_CPP_Sync_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/ThreadSleep_C_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Consumer_Producer_CPP_API_Test.hpp"
#include "../../h/Testing/Testing_OS1/Periodic_Threads_CPP_API_Test.hpp"

void userMain(void* arg) {
    800025d4:	ff010113          	addi	sp,sp,-16
    800025d8:	00813423          	sd	s0,8(sp)
    800025dc:	01010413          	addi	s0,sp,16

    //ThreadSleepTest::Thread_Sleep_C_API_Test(); // uspavljivanje i budjenje niti, C API test (prosao)
    //ConsumerProducerAsyncCPP::Consumer_Producer_Async_CPP_API_Test(); // CPP API i asinhrona promena konteksta, kompletan test svega (prosao)

    //PeriodicThreadsTest::Periodic_Threads_CPP_API_Test();  // test periodicnih niti (prosao)
}
    800025e0:	00813403          	ld	s0,8(sp)
    800025e4:	01010113          	addi	sp,sp,16
    800025e8:	00008067          	ret

00000000800025ec <_ZN12ThreadsTestC11workerBodyAEPv>:
        if (n == 0 || n == 1) { return n; }
        if (n % 10 == 0) { thread_dispatch(); }
        return fibonacci(n - 1) + fibonacci(n - 2);
    }

    void workerBodyA(void* arg) {
    800025ec:	fe010113          	addi	sp,sp,-32
    800025f0:	00113c23          	sd	ra,24(sp)
    800025f4:	00813823          	sd	s0,16(sp)
    800025f8:	00913423          	sd	s1,8(sp)
    800025fc:	01213023          	sd	s2,0(sp)
    80002600:	02010413          	addi	s0,sp,32
        for (uint64 i = 0; i < 10; i++) {
    80002604:	00000913          	li	s2,0
    80002608:	0380006f          	j	80002640 <_ZN12ThreadsTestC11workerBodyAEPv+0x54>
            printString("A: i="); printInt(i); printString("\n");
            for (uint64 j = 0; j < 10000; j++) {
                for (uint64 k = 0; k < 30000; k++) { }
                thread_dispatch();
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	e7c080e7          	jalr	-388(ra) # 80006488 <_Z15thread_dispatchv>
            for (uint64 j = 0; j < 10000; j++) {
    80002614:	00148493          	addi	s1,s1,1
    80002618:	000027b7          	lui	a5,0x2
    8000261c:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80002620:	0097ee63          	bltu	a5,s1,8000263c <_ZN12ThreadsTestC11workerBodyAEPv+0x50>
                for (uint64 k = 0; k < 30000; k++) { }
    80002624:	00000713          	li	a4,0
    80002628:	000077b7          	lui	a5,0x7
    8000262c:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80002630:	fce7eee3          	bltu	a5,a4,8000260c <_ZN12ThreadsTestC11workerBodyAEPv+0x20>
    80002634:	00170713          	addi	a4,a4,1
    80002638:	ff1ff06f          	j	80002628 <_ZN12ThreadsTestC11workerBodyAEPv+0x3c>
        for (uint64 i = 0; i < 10; i++) {
    8000263c:	00190913          	addi	s2,s2,1
    80002640:	00900793          	li	a5,9
    80002644:	0527e063          	bltu	a5,s2,80002684 <_ZN12ThreadsTestC11workerBodyAEPv+0x98>
            printString("A: i="); printInt(i); printString("\n");
    80002648:	00007517          	auipc	a0,0x7
    8000264c:	9f050513          	addi	a0,a0,-1552 # 80009038 <CONSOLE_STATUS+0x28>
    80002650:	fffff097          	auipc	ra,0xfffff
    80002654:	ff8080e7          	jalr	-8(ra) # 80001648 <_Z11printStringPKc>
    80002658:	00000613          	li	a2,0
    8000265c:	00a00593          	li	a1,10
    80002660:	0009051b          	sext.w	a0,s2
    80002664:	fffff097          	auipc	ra,0xfffff
    80002668:	17c080e7          	jalr	380(ra) # 800017e0 <_Z8printIntiii>
    8000266c:	00007517          	auipc	a0,0x7
    80002670:	b1c50513          	addi	a0,a0,-1252 # 80009188 <CONSOLE_STATUS+0x178>
    80002674:	fffff097          	auipc	ra,0xfffff
    80002678:	fd4080e7          	jalr	-44(ra) # 80001648 <_Z11printStringPKc>
            for (uint64 j = 0; j < 10000; j++) {
    8000267c:	00000493          	li	s1,0
    80002680:	f99ff06f          	j	80002618 <_ZN12ThreadsTestC11workerBodyAEPv+0x2c>
            }
        }
        printString("A finished!\n");
    80002684:	00007517          	auipc	a0,0x7
    80002688:	9bc50513          	addi	a0,a0,-1604 # 80009040 <CONSOLE_STATUS+0x30>
    8000268c:	fffff097          	auipc	ra,0xfffff
    80002690:	fbc080e7          	jalr	-68(ra) # 80001648 <_Z11printStringPKc>
        finishedA = true;
    80002694:	00100793          	li	a5,1
    80002698:	00009717          	auipc	a4,0x9
    8000269c:	68f70c23          	sb	a5,1688(a4) # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    }
    800026a0:	01813083          	ld	ra,24(sp)
    800026a4:	01013403          	ld	s0,16(sp)
    800026a8:	00813483          	ld	s1,8(sp)
    800026ac:	00013903          	ld	s2,0(sp)
    800026b0:	02010113          	addi	sp,sp,32
    800026b4:	00008067          	ret

00000000800026b8 <_ZN12ThreadsTestC11workerBodyBEPv>:

    void workerBodyB(void* arg) {
    800026b8:	fe010113          	addi	sp,sp,-32
    800026bc:	00113c23          	sd	ra,24(sp)
    800026c0:	00813823          	sd	s0,16(sp)
    800026c4:	00913423          	sd	s1,8(sp)
    800026c8:	01213023          	sd	s2,0(sp)
    800026cc:	02010413          	addi	s0,sp,32
        for (uint64 i = 0; i < 16; i++) {
    800026d0:	00000913          	li	s2,0
    800026d4:	0380006f          	j	8000270c <_ZN12ThreadsTestC11workerBodyBEPv+0x54>
            printString("B: i="); printInt(i); printString("\n");
            for (uint64 j = 0; j < 10000; j++) {
                for (uint64 k = 0; k < 30000; k++) { }
                thread_dispatch();
    800026d8:	00004097          	auipc	ra,0x4
    800026dc:	db0080e7          	jalr	-592(ra) # 80006488 <_Z15thread_dispatchv>
            for (uint64 j = 0; j < 10000; j++) {
    800026e0:	00148493          	addi	s1,s1,1
    800026e4:	000027b7          	lui	a5,0x2
    800026e8:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    800026ec:	0097ee63          	bltu	a5,s1,80002708 <_ZN12ThreadsTestC11workerBodyBEPv+0x50>
                for (uint64 k = 0; k < 30000; k++) { }
    800026f0:	00000713          	li	a4,0
    800026f4:	000077b7          	lui	a5,0x7
    800026f8:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    800026fc:	fce7eee3          	bltu	a5,a4,800026d8 <_ZN12ThreadsTestC11workerBodyBEPv+0x20>
    80002700:	00170713          	addi	a4,a4,1
    80002704:	ff1ff06f          	j	800026f4 <_ZN12ThreadsTestC11workerBodyBEPv+0x3c>
        for (uint64 i = 0; i < 16; i++) {
    80002708:	00190913          	addi	s2,s2,1
    8000270c:	00f00793          	li	a5,15
    80002710:	0527e063          	bltu	a5,s2,80002750 <_ZN12ThreadsTestC11workerBodyBEPv+0x98>
            printString("B: i="); printInt(i); printString("\n");
    80002714:	00007517          	auipc	a0,0x7
    80002718:	93c50513          	addi	a0,a0,-1732 # 80009050 <CONSOLE_STATUS+0x40>
    8000271c:	fffff097          	auipc	ra,0xfffff
    80002720:	f2c080e7          	jalr	-212(ra) # 80001648 <_Z11printStringPKc>
    80002724:	00000613          	li	a2,0
    80002728:	00a00593          	li	a1,10
    8000272c:	0009051b          	sext.w	a0,s2
    80002730:	fffff097          	auipc	ra,0xfffff
    80002734:	0b0080e7          	jalr	176(ra) # 800017e0 <_Z8printIntiii>
    80002738:	00007517          	auipc	a0,0x7
    8000273c:	a5050513          	addi	a0,a0,-1456 # 80009188 <CONSOLE_STATUS+0x178>
    80002740:	fffff097          	auipc	ra,0xfffff
    80002744:	f08080e7          	jalr	-248(ra) # 80001648 <_Z11printStringPKc>
            for (uint64 j = 0; j < 10000; j++) {
    80002748:	00000493          	li	s1,0
    8000274c:	f99ff06f          	j	800026e4 <_ZN12ThreadsTestC11workerBodyBEPv+0x2c>
            }
        }
        printString("B finished!\n");
    80002750:	00007517          	auipc	a0,0x7
    80002754:	90850513          	addi	a0,a0,-1784 # 80009058 <CONSOLE_STATUS+0x48>
    80002758:	fffff097          	auipc	ra,0xfffff
    8000275c:	ef0080e7          	jalr	-272(ra) # 80001648 <_Z11printStringPKc>
        finishedB = true;
    80002760:	00100793          	li	a5,1
    80002764:	00009717          	auipc	a4,0x9
    80002768:	5cf706a3          	sb	a5,1485(a4) # 8000bd31 <_ZN12ThreadsTestC9finishedBE>
        thread_dispatch();
    8000276c:	00004097          	auipc	ra,0x4
    80002770:	d1c080e7          	jalr	-740(ra) # 80006488 <_Z15thread_dispatchv>
    }
    80002774:	01813083          	ld	ra,24(sp)
    80002778:	01013403          	ld	s0,16(sp)
    8000277c:	00813483          	ld	s1,8(sp)
    80002780:	00013903          	ld	s2,0(sp)
    80002784:	02010113          	addi	sp,sp,32
    80002788:	00008067          	ret

000000008000278c <_ZN21ConsumerProducerSyncC16producerKeyboardEPv>:
        sem_t wait;
    };

    volatile int threadEnd = 0;

    void producerKeyboard(void *arg) {
    8000278c:	fe010113          	addi	sp,sp,-32
    80002790:	00113c23          	sd	ra,24(sp)
    80002794:	00813823          	sd	s0,16(sp)
    80002798:	00913423          	sd	s1,8(sp)
    8000279c:	01213023          	sd	s2,0(sp)
    800027a0:	02010413          	addi	s0,sp,32
    800027a4:	00050493          	mv	s1,a0
        struct thread_data *data = (struct thread_data *) arg;

        int key;
        int i = 0;
    800027a8:	00000913          	li	s2,0
    800027ac:	00c0006f          	j	800027b8 <_ZN21ConsumerProducerSyncC16producerKeyboardEPv+0x2c>
        while ((key = getc()) != 0x1b) {
            data->buffer->put(key);
            i++;

            if (i % (10 * data->id) == 0) {
                thread_dispatch();
    800027b0:	00004097          	auipc	ra,0x4
    800027b4:	cd8080e7          	jalr	-808(ra) # 80006488 <_Z15thread_dispatchv>
        while ((key = getc()) != 0x1b) {
    800027b8:	00004097          	auipc	ra,0x4
    800027bc:	064080e7          	jalr	100(ra) # 8000681c <_Z4getcv>
    800027c0:	0005059b          	sext.w	a1,a0
    800027c4:	01b00793          	li	a5,27
    800027c8:	02f58a63          	beq	a1,a5,800027fc <_ZN21ConsumerProducerSyncC16producerKeyboardEPv+0x70>
            data->buffer->put(key);
    800027cc:	0084b503          	ld	a0,8(s1)
    800027d0:	fffff097          	auipc	ra,0xfffff
    800027d4:	bd4080e7          	jalr	-1068(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
            i++;
    800027d8:	0019071b          	addiw	a4,s2,1
    800027dc:	0007091b          	sext.w	s2,a4
            if (i % (10 * data->id) == 0) {
    800027e0:	0004a683          	lw	a3,0(s1)
    800027e4:	0026979b          	slliw	a5,a3,0x2
    800027e8:	00d787bb          	addw	a5,a5,a3
    800027ec:	0017979b          	slliw	a5,a5,0x1
    800027f0:	02f767bb          	remw	a5,a4,a5
    800027f4:	fc0792e3          	bnez	a5,800027b8 <_ZN21ConsumerProducerSyncC16producerKeyboardEPv+0x2c>
    800027f8:	fb9ff06f          	j	800027b0 <_ZN21ConsumerProducerSyncC16producerKeyboardEPv+0x24>
            }
        }

        threadEnd = 1;
    800027fc:	00100793          	li	a5,1
    80002800:	00009717          	auipc	a4,0x9
    80002804:	52f72a23          	sw	a5,1332(a4) # 8000bd34 <_ZN21ConsumerProducerSyncC9threadEndE>
        data->buffer->put('!');
    80002808:	02100593          	li	a1,33
    8000280c:	0084b503          	ld	a0,8(s1)
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	b94080e7          	jalr	-1132(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>

        sem_signal(data->wait);
    80002818:	0104b503          	ld	a0,16(s1)
    8000281c:	00004097          	auipc	ra,0x4
    80002820:	f48080e7          	jalr	-184(ra) # 80006764 <_Z10sem_signalP3sem>
    }
    80002824:	01813083          	ld	ra,24(sp)
    80002828:	01013403          	ld	s0,16(sp)
    8000282c:	00813483          	ld	s1,8(sp)
    80002830:	00013903          	ld	s2,0(sp)
    80002834:	02010113          	addi	sp,sp,32
    80002838:	00008067          	ret

000000008000283c <_ZN21ConsumerProducerSyncC8producerEPv>:

    void producer(void *arg) {
    8000283c:	fe010113          	addi	sp,sp,-32
    80002840:	00113c23          	sd	ra,24(sp)
    80002844:	00813823          	sd	s0,16(sp)
    80002848:	00913423          	sd	s1,8(sp)
    8000284c:	01213023          	sd	s2,0(sp)
    80002850:	02010413          	addi	s0,sp,32
    80002854:	00050493          	mv	s1,a0
        struct thread_data *data = (struct thread_data *) arg;

        int i = 0;
    80002858:	00000913          	li	s2,0
    8000285c:	00c0006f          	j	80002868 <_ZN21ConsumerProducerSyncC8producerEPv+0x2c>
        while (!threadEnd) {
            data->buffer->put(data->id + '0');
            i++;

            if (i % (10 * data->id) == 0) {
                thread_dispatch();
    80002860:	00004097          	auipc	ra,0x4
    80002864:	c28080e7          	jalr	-984(ra) # 80006488 <_Z15thread_dispatchv>
        while (!threadEnd) {
    80002868:	00009797          	auipc	a5,0x9
    8000286c:	4cc7a783          	lw	a5,1228(a5) # 8000bd34 <_ZN21ConsumerProducerSyncC9threadEndE>
    80002870:	02079e63          	bnez	a5,800028ac <_ZN21ConsumerProducerSyncC8producerEPv+0x70>
            data->buffer->put(data->id + '0');
    80002874:	0004a583          	lw	a1,0(s1)
    80002878:	0305859b          	addiw	a1,a1,48
    8000287c:	0084b503          	ld	a0,8(s1)
    80002880:	fffff097          	auipc	ra,0xfffff
    80002884:	b24080e7          	jalr	-1244(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
            i++;
    80002888:	0019071b          	addiw	a4,s2,1
    8000288c:	0007091b          	sext.w	s2,a4
            if (i % (10 * data->id) == 0) {
    80002890:	0004a683          	lw	a3,0(s1)
    80002894:	0026979b          	slliw	a5,a3,0x2
    80002898:	00d787bb          	addw	a5,a5,a3
    8000289c:	0017979b          	slliw	a5,a5,0x1
    800028a0:	02f767bb          	remw	a5,a4,a5
    800028a4:	fc0792e3          	bnez	a5,80002868 <_ZN21ConsumerProducerSyncC8producerEPv+0x2c>
    800028a8:	fb9ff06f          	j	80002860 <_ZN21ConsumerProducerSyncC8producerEPv+0x24>
            }
        }

        sem_signal(data->wait);
    800028ac:	0104b503          	ld	a0,16(s1)
    800028b0:	00004097          	auipc	ra,0x4
    800028b4:	eb4080e7          	jalr	-332(ra) # 80006764 <_Z10sem_signalP3sem>
    }
    800028b8:	01813083          	ld	ra,24(sp)
    800028bc:	01013403          	ld	s0,16(sp)
    800028c0:	00813483          	ld	s1,8(sp)
    800028c4:	00013903          	ld	s2,0(sp)
    800028c8:	02010113          	addi	sp,sp,32
    800028cc:	00008067          	ret

00000000800028d0 <_ZN21ConsumerProducerSyncC8consumerEPv>:

    void consumer(void *arg) {
    800028d0:	fd010113          	addi	sp,sp,-48
    800028d4:	02113423          	sd	ra,40(sp)
    800028d8:	02813023          	sd	s0,32(sp)
    800028dc:	00913c23          	sd	s1,24(sp)
    800028e0:	01213823          	sd	s2,16(sp)
    800028e4:	01313423          	sd	s3,8(sp)
    800028e8:	03010413          	addi	s0,sp,48
    800028ec:	00050913          	mv	s2,a0
        struct thread_data *data = (struct thread_data *) arg;

        int i = 0;
    800028f0:	00000993          	li	s3,0
    800028f4:	01c0006f          	j	80002910 <_ZN21ConsumerProducerSyncC8consumerEPv+0x40>
            i++;

            putc(key);

            if (i % (5 * data->id) == 0) {
                thread_dispatch();
    800028f8:	00004097          	auipc	ra,0x4
    800028fc:	b90080e7          	jalr	-1136(ra) # 80006488 <_Z15thread_dispatchv>
    80002900:	0500006f          	j	80002950 <_ZN21ConsumerProducerSyncC8consumerEPv+0x80>
            }

            if (i % 80 == 0) {
                putc('\n');
    80002904:	00a00513          	li	a0,10
    80002908:	00004097          	auipc	ra,0x4
    8000290c:	f6c080e7          	jalr	-148(ra) # 80006874 <_Z4putcc>
        while (!threadEnd) {
    80002910:	00009797          	auipc	a5,0x9
    80002914:	4247a783          	lw	a5,1060(a5) # 8000bd34 <_ZN21ConsumerProducerSyncC9threadEndE>
    80002918:	06079063          	bnez	a5,80002978 <_ZN21ConsumerProducerSyncC8consumerEPv+0xa8>
            int key = data->buffer->get();
    8000291c:	00893503          	ld	a0,8(s2)
    80002920:	fffff097          	auipc	ra,0xfffff
    80002924:	b14080e7          	jalr	-1260(ra) # 80001434 <_ZN13BufferTestCPP9BufferCPP3getEv>
            i++;
    80002928:	0019849b          	addiw	s1,s3,1
    8000292c:	0004899b          	sext.w	s3,s1
            putc(key);
    80002930:	0ff57513          	andi	a0,a0,255
    80002934:	00004097          	auipc	ra,0x4
    80002938:	f40080e7          	jalr	-192(ra) # 80006874 <_Z4putcc>
            if (i % (5 * data->id) == 0) {
    8000293c:	00092703          	lw	a4,0(s2)
    80002940:	0027179b          	slliw	a5,a4,0x2
    80002944:	00e787bb          	addw	a5,a5,a4
    80002948:	02f4e7bb          	remw	a5,s1,a5
    8000294c:	fa0786e3          	beqz	a5,800028f8 <_ZN21ConsumerProducerSyncC8consumerEPv+0x28>
            if (i % 80 == 0) {
    80002950:	05000793          	li	a5,80
    80002954:	02f4e4bb          	remw	s1,s1,a5
    80002958:	fa049ce3          	bnez	s1,80002910 <_ZN21ConsumerProducerSyncC8consumerEPv+0x40>
    8000295c:	fa9ff06f          	j	80002904 <_ZN21ConsumerProducerSyncC8consumerEPv+0x34>
            }
        }

        while (data->buffer->getCnt() > 0) {
            int key = data->buffer->get();
    80002960:	00893503          	ld	a0,8(s2)
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	ad0080e7          	jalr	-1328(ra) # 80001434 <_ZN13BufferTestCPP9BufferCPP3getEv>
            putc(key);
    8000296c:	0ff57513          	andi	a0,a0,255
    80002970:	00004097          	auipc	ra,0x4
    80002974:	f04080e7          	jalr	-252(ra) # 80006874 <_Z4putcc>
        while (data->buffer->getCnt() > 0) {
    80002978:	00893503          	ld	a0,8(s2)
    8000297c:	fffff097          	auipc	ra,0xfffff
    80002980:	b44080e7          	jalr	-1212(ra) # 800014c0 <_ZN13BufferTestCPP9BufferCPP6getCntEv>
    80002984:	fca04ee3          	bgtz	a0,80002960 <_ZN21ConsumerProducerSyncC8consumerEPv+0x90>
        }

        sem_signal(data->wait);
    80002988:	01093503          	ld	a0,16(s2)
    8000298c:	00004097          	auipc	ra,0x4
    80002990:	dd8080e7          	jalr	-552(ra) # 80006764 <_Z10sem_signalP3sem>
    }
    80002994:	02813083          	ld	ra,40(sp)
    80002998:	02013403          	ld	s0,32(sp)
    8000299c:	01813483          	ld	s1,24(sp)
    800029a0:	01013903          	ld	s2,16(sp)
    800029a4:	00813983          	ld	s3,8(sp)
    800029a8:	03010113          	addi	sp,sp,48
    800029ac:	00008067          	ret

00000000800029b0 <_ZN15ThreadSleepTest9sleepyRunEPv>:
#include "Printing.hpp"

namespace ThreadSleepTest {
    bool finished[2];

    void sleepyRun(void *arg) {
    800029b0:	fe010113          	addi	sp,sp,-32
    800029b4:	00113c23          	sd	ra,24(sp)
    800029b8:	00813823          	sd	s0,16(sp)
    800029bc:	00913423          	sd	s1,8(sp)
    800029c0:	01213023          	sd	s2,0(sp)
    800029c4:	02010413          	addi	s0,sp,32
        time_t sleep_time = *((time_t *) arg);
    800029c8:	00053903          	ld	s2,0(a0)
        int i = 6;
    800029cc:	00600493          	li	s1,6
        while (--i > 0) {
    800029d0:	fff4849b          	addiw	s1,s1,-1
    800029d4:	04905463          	blez	s1,80002a1c <_ZN15ThreadSleepTest9sleepyRunEPv+0x6c>

            printString("Hello ");
    800029d8:	00006517          	auipc	a0,0x6
    800029dc:	69050513          	addi	a0,a0,1680 # 80009068 <CONSOLE_STATUS+0x58>
    800029e0:	fffff097          	auipc	ra,0xfffff
    800029e4:	c68080e7          	jalr	-920(ra) # 80001648 <_Z11printStringPKc>
            printInt(sleep_time);
    800029e8:	00000613          	li	a2,0
    800029ec:	00a00593          	li	a1,10
    800029f0:	0009051b          	sext.w	a0,s2
    800029f4:	fffff097          	auipc	ra,0xfffff
    800029f8:	dec080e7          	jalr	-532(ra) # 800017e0 <_Z8printIntiii>
            printString(" !\n");
    800029fc:	00006517          	auipc	a0,0x6
    80002a00:	67450513          	addi	a0,a0,1652 # 80009070 <CONSOLE_STATUS+0x60>
    80002a04:	fffff097          	auipc	ra,0xfffff
    80002a08:	c44080e7          	jalr	-956(ra) # 80001648 <_Z11printStringPKc>
            time_sleep(sleep_time);
    80002a0c:	00090513          	mv	a0,s2
    80002a10:	00004097          	auipc	ra,0x4
    80002a14:	da8080e7          	jalr	-600(ra) # 800067b8 <_Z10time_sleepm>
        while (--i > 0) {
    80002a18:	fb9ff06f          	j	800029d0 <_ZN15ThreadSleepTest9sleepyRunEPv+0x20>
        }
        finished[sleep_time/10-1] = true;
    80002a1c:	00a00793          	li	a5,10
    80002a20:	02f95933          	divu	s2,s2,a5
    80002a24:	fff90913          	addi	s2,s2,-1
    80002a28:	00009797          	auipc	a5,0x9
    80002a2c:	30878793          	addi	a5,a5,776 # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    80002a30:	01278933          	add	s2,a5,s2
    80002a34:	00100793          	li	a5,1
    80002a38:	00f90c23          	sb	a5,24(s2)
    }
    80002a3c:	01813083          	ld	ra,24(sp)
    80002a40:	01013403          	ld	s0,16(sp)
    80002a44:	00813483          	ld	s1,8(sp)
    80002a48:	00013903          	ld	s2,0(sp)
    80002a4c:	02010113          	addi	sp,sp,32
    80002a50:	00008067          	ret

0000000080002a54 <_ZN12ThreadsTestC9fibonacciEm>:
    uint64 fibonacci(uint64 n) {
    80002a54:	fe010113          	addi	sp,sp,-32
    80002a58:	00113c23          	sd	ra,24(sp)
    80002a5c:	00813823          	sd	s0,16(sp)
    80002a60:	00913423          	sd	s1,8(sp)
    80002a64:	01213023          	sd	s2,0(sp)
    80002a68:	02010413          	addi	s0,sp,32
    80002a6c:	00050493          	mv	s1,a0
        if (n == 0 || n == 1) { return n; }
    80002a70:	00100793          	li	a5,1
    80002a74:	02a7f863          	bgeu	a5,a0,80002aa4 <_ZN12ThreadsTestC9fibonacciEm+0x50>
        if (n % 10 == 0) { thread_dispatch(); }
    80002a78:	00a00793          	li	a5,10
    80002a7c:	02f577b3          	remu	a5,a0,a5
    80002a80:	02078e63          	beqz	a5,80002abc <_ZN12ThreadsTestC9fibonacciEm+0x68>
        return fibonacci(n - 1) + fibonacci(n - 2);
    80002a84:	fff48513          	addi	a0,s1,-1
    80002a88:	00000097          	auipc	ra,0x0
    80002a8c:	fcc080e7          	jalr	-52(ra) # 80002a54 <_ZN12ThreadsTestC9fibonacciEm>
    80002a90:	00050913          	mv	s2,a0
    80002a94:	ffe48513          	addi	a0,s1,-2
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	fbc080e7          	jalr	-68(ra) # 80002a54 <_ZN12ThreadsTestC9fibonacciEm>
    80002aa0:	00a90533          	add	a0,s2,a0
    }
    80002aa4:	01813083          	ld	ra,24(sp)
    80002aa8:	01013403          	ld	s0,16(sp)
    80002aac:	00813483          	ld	s1,8(sp)
    80002ab0:	00013903          	ld	s2,0(sp)
    80002ab4:	02010113          	addi	sp,sp,32
    80002ab8:	00008067          	ret
        if (n % 10 == 0) { thread_dispatch(); }
    80002abc:	00004097          	auipc	ra,0x4
    80002ac0:	9cc080e7          	jalr	-1588(ra) # 80006488 <_Z15thread_dispatchv>
    80002ac4:	fc1ff06f          	j	80002a84 <_ZN12ThreadsTestC9fibonacciEm+0x30>

0000000080002ac8 <_ZN12ThreadsTestC11workerBodyCEPv>:

    void workerBodyC(void* arg) {
    80002ac8:	fe010113          	addi	sp,sp,-32
    80002acc:	00113c23          	sd	ra,24(sp)
    80002ad0:	00813823          	sd	s0,16(sp)
    80002ad4:	00913423          	sd	s1,8(sp)
    80002ad8:	01213023          	sd	s2,0(sp)
    80002adc:	02010413          	addi	s0,sp,32
        uint8 i = 0;
    80002ae0:	00000493          	li	s1,0
    80002ae4:	0400006f          	j	80002b24 <_ZN12ThreadsTestC11workerBodyCEPv+0x5c>
        for (; i < 3; i++) {
            printString("C: i="); printInt(i); printString("\n");
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	59050513          	addi	a0,a0,1424 # 80009078 <CONSOLE_STATUS+0x68>
    80002af0:	fffff097          	auipc	ra,0xfffff
    80002af4:	b58080e7          	jalr	-1192(ra) # 80001648 <_Z11printStringPKc>
    80002af8:	00000613          	li	a2,0
    80002afc:	00a00593          	li	a1,10
    80002b00:	00048513          	mv	a0,s1
    80002b04:	fffff097          	auipc	ra,0xfffff
    80002b08:	cdc080e7          	jalr	-804(ra) # 800017e0 <_Z8printIntiii>
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	67c50513          	addi	a0,a0,1660 # 80009188 <CONSOLE_STATUS+0x178>
    80002b14:	fffff097          	auipc	ra,0xfffff
    80002b18:	b34080e7          	jalr	-1228(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 3; i++) {
    80002b1c:	0014849b          	addiw	s1,s1,1
    80002b20:	0ff4f493          	andi	s1,s1,255
    80002b24:	00200793          	li	a5,2
    80002b28:	fc97f0e3          	bgeu	a5,s1,80002ae8 <_ZN12ThreadsTestC11workerBodyCEPv+0x20>
        }

        printString("C: dispatch\n");
    80002b2c:	00006517          	auipc	a0,0x6
    80002b30:	55450513          	addi	a0,a0,1364 # 80009080 <CONSOLE_STATUS+0x70>
    80002b34:	fffff097          	auipc	ra,0xfffff
    80002b38:	b14080e7          	jalr	-1260(ra) # 80001648 <_Z11printStringPKc>
        __asm__ ("li t1, 7");
    80002b3c:	00700313          	li	t1,7
        thread_dispatch();
    80002b40:	00004097          	auipc	ra,0x4
    80002b44:	948080e7          	jalr	-1720(ra) # 80006488 <_Z15thread_dispatchv>

        uint64 t1 = 0;
        __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80002b48:	00030913          	mv	s2,t1

        printString("C: t1="); printInt(t1); printString("\n");
    80002b4c:	00006517          	auipc	a0,0x6
    80002b50:	54450513          	addi	a0,a0,1348 # 80009090 <CONSOLE_STATUS+0x80>
    80002b54:	fffff097          	auipc	ra,0xfffff
    80002b58:	af4080e7          	jalr	-1292(ra) # 80001648 <_Z11printStringPKc>
    80002b5c:	00000613          	li	a2,0
    80002b60:	00a00593          	li	a1,10
    80002b64:	0009051b          	sext.w	a0,s2
    80002b68:	fffff097          	auipc	ra,0xfffff
    80002b6c:	c78080e7          	jalr	-904(ra) # 800017e0 <_Z8printIntiii>
    80002b70:	00006517          	auipc	a0,0x6
    80002b74:	61850513          	addi	a0,a0,1560 # 80009188 <CONSOLE_STATUS+0x178>
    80002b78:	fffff097          	auipc	ra,0xfffff
    80002b7c:	ad0080e7          	jalr	-1328(ra) # 80001648 <_Z11printStringPKc>

        uint64 result = fibonacci(12);
    80002b80:	00c00513          	li	a0,12
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	ed0080e7          	jalr	-304(ra) # 80002a54 <_ZN12ThreadsTestC9fibonacciEm>
    80002b8c:	00050913          	mv	s2,a0
        printString("C: fibonaci="); printInt(result); printString("\n");
    80002b90:	00006517          	auipc	a0,0x6
    80002b94:	50850513          	addi	a0,a0,1288 # 80009098 <CONSOLE_STATUS+0x88>
    80002b98:	fffff097          	auipc	ra,0xfffff
    80002b9c:	ab0080e7          	jalr	-1360(ra) # 80001648 <_Z11printStringPKc>
    80002ba0:	00000613          	li	a2,0
    80002ba4:	00a00593          	li	a1,10
    80002ba8:	0009051b          	sext.w	a0,s2
    80002bac:	fffff097          	auipc	ra,0xfffff
    80002bb0:	c34080e7          	jalr	-972(ra) # 800017e0 <_Z8printIntiii>
    80002bb4:	00006517          	auipc	a0,0x6
    80002bb8:	5d450513          	addi	a0,a0,1492 # 80009188 <CONSOLE_STATUS+0x178>
    80002bbc:	fffff097          	auipc	ra,0xfffff
    80002bc0:	a8c080e7          	jalr	-1396(ra) # 80001648 <_Z11printStringPKc>
    80002bc4:	0400006f          	j	80002c04 <_ZN12ThreadsTestC11workerBodyCEPv+0x13c>

        for (; i < 6; i++) {
            printString("C: i="); printInt(i); printString("\n");
    80002bc8:	00006517          	auipc	a0,0x6
    80002bcc:	4b050513          	addi	a0,a0,1200 # 80009078 <CONSOLE_STATUS+0x68>
    80002bd0:	fffff097          	auipc	ra,0xfffff
    80002bd4:	a78080e7          	jalr	-1416(ra) # 80001648 <_Z11printStringPKc>
    80002bd8:	00000613          	li	a2,0
    80002bdc:	00a00593          	li	a1,10
    80002be0:	00048513          	mv	a0,s1
    80002be4:	fffff097          	auipc	ra,0xfffff
    80002be8:	bfc080e7          	jalr	-1028(ra) # 800017e0 <_Z8printIntiii>
    80002bec:	00006517          	auipc	a0,0x6
    80002bf0:	59c50513          	addi	a0,a0,1436 # 80009188 <CONSOLE_STATUS+0x178>
    80002bf4:	fffff097          	auipc	ra,0xfffff
    80002bf8:	a54080e7          	jalr	-1452(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 6; i++) {
    80002bfc:	0014849b          	addiw	s1,s1,1
    80002c00:	0ff4f493          	andi	s1,s1,255
    80002c04:	00500793          	li	a5,5
    80002c08:	fc97f0e3          	bgeu	a5,s1,80002bc8 <_ZN12ThreadsTestC11workerBodyCEPv+0x100>
        }

        printString("C finished!\n");
    80002c0c:	00006517          	auipc	a0,0x6
    80002c10:	49c50513          	addi	a0,a0,1180 # 800090a8 <CONSOLE_STATUS+0x98>
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	a34080e7          	jalr	-1484(ra) # 80001648 <_Z11printStringPKc>
        finishedC = true;
    80002c1c:	00100793          	li	a5,1
    80002c20:	00009717          	auipc	a4,0x9
    80002c24:	12f70c23          	sb	a5,312(a4) # 8000bd58 <_ZN12ThreadsTestC9finishedCE>
        thread_dispatch();
    80002c28:	00004097          	auipc	ra,0x4
    80002c2c:	860080e7          	jalr	-1952(ra) # 80006488 <_Z15thread_dispatchv>
    }
    80002c30:	01813083          	ld	ra,24(sp)
    80002c34:	01013403          	ld	s0,16(sp)
    80002c38:	00813483          	ld	s1,8(sp)
    80002c3c:	00013903          	ld	s2,0(sp)
    80002c40:	02010113          	addi	sp,sp,32
    80002c44:	00008067          	ret

0000000080002c48 <_ZN12ThreadsTestC11workerBodyDEPv>:

    void workerBodyD(void* arg) {
    80002c48:	fe010113          	addi	sp,sp,-32
    80002c4c:	00113c23          	sd	ra,24(sp)
    80002c50:	00813823          	sd	s0,16(sp)
    80002c54:	00913423          	sd	s1,8(sp)
    80002c58:	01213023          	sd	s2,0(sp)
    80002c5c:	02010413          	addi	s0,sp,32
        uint8 i = 10;
    80002c60:	00a00493          	li	s1,10
    80002c64:	0400006f          	j	80002ca4 <_ZN12ThreadsTestC11workerBodyDEPv+0x5c>
        for (; i < 13; i++) {
            printString("D: i="); printInt(i); printString("\n");
    80002c68:	00006517          	auipc	a0,0x6
    80002c6c:	45050513          	addi	a0,a0,1104 # 800090b8 <CONSOLE_STATUS+0xa8>
    80002c70:	fffff097          	auipc	ra,0xfffff
    80002c74:	9d8080e7          	jalr	-1576(ra) # 80001648 <_Z11printStringPKc>
    80002c78:	00000613          	li	a2,0
    80002c7c:	00a00593          	li	a1,10
    80002c80:	00048513          	mv	a0,s1
    80002c84:	fffff097          	auipc	ra,0xfffff
    80002c88:	b5c080e7          	jalr	-1188(ra) # 800017e0 <_Z8printIntiii>
    80002c8c:	00006517          	auipc	a0,0x6
    80002c90:	4fc50513          	addi	a0,a0,1276 # 80009188 <CONSOLE_STATUS+0x178>
    80002c94:	fffff097          	auipc	ra,0xfffff
    80002c98:	9b4080e7          	jalr	-1612(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 13; i++) {
    80002c9c:	0014849b          	addiw	s1,s1,1
    80002ca0:	0ff4f493          	andi	s1,s1,255
    80002ca4:	00c00793          	li	a5,12
    80002ca8:	fc97f0e3          	bgeu	a5,s1,80002c68 <_ZN12ThreadsTestC11workerBodyDEPv+0x20>
        }

        printString("D: dispatch\n");
    80002cac:	00006517          	auipc	a0,0x6
    80002cb0:	41450513          	addi	a0,a0,1044 # 800090c0 <CONSOLE_STATUS+0xb0>
    80002cb4:	fffff097          	auipc	ra,0xfffff
    80002cb8:	994080e7          	jalr	-1644(ra) # 80001648 <_Z11printStringPKc>
        __asm__ ("li t1, 5");
    80002cbc:	00500313          	li	t1,5
        thread_dispatch();
    80002cc0:	00003097          	auipc	ra,0x3
    80002cc4:	7c8080e7          	jalr	1992(ra) # 80006488 <_Z15thread_dispatchv>

        uint64 result = fibonacci(16);
    80002cc8:	01000513          	li	a0,16
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	d88080e7          	jalr	-632(ra) # 80002a54 <_ZN12ThreadsTestC9fibonacciEm>
    80002cd4:	00050913          	mv	s2,a0
        printString("D: fibonaci="); printInt(result); printString("\n");
    80002cd8:	00006517          	auipc	a0,0x6
    80002cdc:	3f850513          	addi	a0,a0,1016 # 800090d0 <CONSOLE_STATUS+0xc0>
    80002ce0:	fffff097          	auipc	ra,0xfffff
    80002ce4:	968080e7          	jalr	-1688(ra) # 80001648 <_Z11printStringPKc>
    80002ce8:	00000613          	li	a2,0
    80002cec:	00a00593          	li	a1,10
    80002cf0:	0009051b          	sext.w	a0,s2
    80002cf4:	fffff097          	auipc	ra,0xfffff
    80002cf8:	aec080e7          	jalr	-1300(ra) # 800017e0 <_Z8printIntiii>
    80002cfc:	00006517          	auipc	a0,0x6
    80002d00:	48c50513          	addi	a0,a0,1164 # 80009188 <CONSOLE_STATUS+0x178>
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	944080e7          	jalr	-1724(ra) # 80001648 <_Z11printStringPKc>
    80002d0c:	0400006f          	j	80002d4c <_ZN12ThreadsTestC11workerBodyDEPv+0x104>

        for (; i < 16; i++) {
            printString("D: i="); printInt(i); printString("\n");
    80002d10:	00006517          	auipc	a0,0x6
    80002d14:	3a850513          	addi	a0,a0,936 # 800090b8 <CONSOLE_STATUS+0xa8>
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	930080e7          	jalr	-1744(ra) # 80001648 <_Z11printStringPKc>
    80002d20:	00000613          	li	a2,0
    80002d24:	00a00593          	li	a1,10
    80002d28:	00048513          	mv	a0,s1
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	ab4080e7          	jalr	-1356(ra) # 800017e0 <_Z8printIntiii>
    80002d34:	00006517          	auipc	a0,0x6
    80002d38:	45450513          	addi	a0,a0,1108 # 80009188 <CONSOLE_STATUS+0x178>
    80002d3c:	fffff097          	auipc	ra,0xfffff
    80002d40:	90c080e7          	jalr	-1780(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 16; i++) {
    80002d44:	0014849b          	addiw	s1,s1,1
    80002d48:	0ff4f493          	andi	s1,s1,255
    80002d4c:	00f00793          	li	a5,15
    80002d50:	fc97f0e3          	bgeu	a5,s1,80002d10 <_ZN12ThreadsTestC11workerBodyDEPv+0xc8>
        }

        printString("D finished!\n");
    80002d54:	00006517          	auipc	a0,0x6
    80002d58:	38c50513          	addi	a0,a0,908 # 800090e0 <CONSOLE_STATUS+0xd0>
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	8ec080e7          	jalr	-1812(ra) # 80001648 <_Z11printStringPKc>
        finishedD = true;
    80002d64:	00100793          	li	a5,1
    80002d68:	00009717          	auipc	a4,0x9
    80002d6c:	fef708a3          	sb	a5,-15(a4) # 8000bd59 <_ZN12ThreadsTestC9finishedDE>
        thread_dispatch();
    80002d70:	00003097          	auipc	ra,0x3
    80002d74:	718080e7          	jalr	1816(ra) # 80006488 <_Z15thread_dispatchv>
    }
    80002d78:	01813083          	ld	ra,24(sp)
    80002d7c:	01013403          	ld	s0,16(sp)
    80002d80:	00813483          	ld	s1,8(sp)
    80002d84:	00013903          	ld	s2,0(sp)
    80002d88:	02010113          	addi	sp,sp,32
    80002d8c:	00008067          	ret

0000000080002d90 <_ZN12ThreadsTestC18Threads_C_API_testEv>:


    void Threads_C_API_test() {
    80002d90:	fd010113          	addi	sp,sp,-48
    80002d94:	02113423          	sd	ra,40(sp)
    80002d98:	02813023          	sd	s0,32(sp)
    80002d9c:	03010413          	addi	s0,sp,48
        thread_t threads[4];
        thread_create(&threads[0], workerBodyA, nullptr);
    80002da0:	00000613          	li	a2,0
    80002da4:	00000597          	auipc	a1,0x0
    80002da8:	84858593          	addi	a1,a1,-1976 # 800025ec <_ZN12ThreadsTestC11workerBodyAEPv>
    80002dac:	fd040513          	addi	a0,s0,-48
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	5d8080e7          	jalr	1496(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        printString("ThreadA created\n");
    80002db8:	00006517          	auipc	a0,0x6
    80002dbc:	33850513          	addi	a0,a0,824 # 800090f0 <CONSOLE_STATUS+0xe0>
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	888080e7          	jalr	-1912(ra) # 80001648 <_Z11printStringPKc>

        thread_create(&threads[1], workerBodyB, nullptr);
    80002dc8:	00000613          	li	a2,0
    80002dcc:	00000597          	auipc	a1,0x0
    80002dd0:	8ec58593          	addi	a1,a1,-1812 # 800026b8 <_ZN12ThreadsTestC11workerBodyBEPv>
    80002dd4:	fd840513          	addi	a0,s0,-40
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	5b0080e7          	jalr	1456(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        printString("ThreadB created\n");
    80002de0:	00006517          	auipc	a0,0x6
    80002de4:	32850513          	addi	a0,a0,808 # 80009108 <CONSOLE_STATUS+0xf8>
    80002de8:	fffff097          	auipc	ra,0xfffff
    80002dec:	860080e7          	jalr	-1952(ra) # 80001648 <_Z11printStringPKc>

        thread_create(&threads[2], workerBodyC, nullptr);
    80002df0:	00000613          	li	a2,0
    80002df4:	00000597          	auipc	a1,0x0
    80002df8:	cd458593          	addi	a1,a1,-812 # 80002ac8 <_ZN12ThreadsTestC11workerBodyCEPv>
    80002dfc:	fe040513          	addi	a0,s0,-32
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	588080e7          	jalr	1416(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        printString("ThreadC created\n");
    80002e08:	00006517          	auipc	a0,0x6
    80002e0c:	31850513          	addi	a0,a0,792 # 80009120 <CONSOLE_STATUS+0x110>
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	838080e7          	jalr	-1992(ra) # 80001648 <_Z11printStringPKc>

        thread_create(&threads[3], workerBodyD, nullptr);
    80002e18:	00000613          	li	a2,0
    80002e1c:	00000597          	auipc	a1,0x0
    80002e20:	e2c58593          	addi	a1,a1,-468 # 80002c48 <_ZN12ThreadsTestC11workerBodyDEPv>
    80002e24:	fe840513          	addi	a0,s0,-24
    80002e28:	00003097          	auipc	ra,0x3
    80002e2c:	560080e7          	jalr	1376(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        printString("ThreadD created\n");
    80002e30:	00006517          	auipc	a0,0x6
    80002e34:	30850513          	addi	a0,a0,776 # 80009138 <CONSOLE_STATUS+0x128>
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	810080e7          	jalr	-2032(ra) # 80001648 <_Z11printStringPKc>
    80002e40:	00c0006f          	j	80002e4c <_ZN12ThreadsTestC18Threads_C_API_testEv+0xbc>

        while (!(finishedA && finishedB && finishedC && finishedD)) {
            thread_dispatch();
    80002e44:	00003097          	auipc	ra,0x3
    80002e48:	644080e7          	jalr	1604(ra) # 80006488 <_Z15thread_dispatchv>
        while (!(finishedA && finishedB && finishedC && finishedD)) {
    80002e4c:	00009797          	auipc	a5,0x9
    80002e50:	ee47c783          	lbu	a5,-284(a5) # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    80002e54:	fe0788e3          	beqz	a5,80002e44 <_ZN12ThreadsTestC18Threads_C_API_testEv+0xb4>
    80002e58:	00009797          	auipc	a5,0x9
    80002e5c:	ed97c783          	lbu	a5,-295(a5) # 8000bd31 <_ZN12ThreadsTestC9finishedBE>
    80002e60:	fe0782e3          	beqz	a5,80002e44 <_ZN12ThreadsTestC18Threads_C_API_testEv+0xb4>
    80002e64:	00009797          	auipc	a5,0x9
    80002e68:	ef47c783          	lbu	a5,-268(a5) # 8000bd58 <_ZN12ThreadsTestC9finishedCE>
    80002e6c:	fc078ce3          	beqz	a5,80002e44 <_ZN12ThreadsTestC18Threads_C_API_testEv+0xb4>
    80002e70:	00009797          	auipc	a5,0x9
    80002e74:	ee97c783          	lbu	a5,-279(a5) # 8000bd59 <_ZN12ThreadsTestC9finishedDE>
    80002e78:	fc0786e3          	beqz	a5,80002e44 <_ZN12ThreadsTestC18Threads_C_API_testEv+0xb4>
        }

    }
    80002e7c:	02813083          	ld	ra,40(sp)
    80002e80:	02013403          	ld	s0,32(sp)
    80002e84:	03010113          	addi	sp,sp,48
    80002e88:	00008067          	ret

0000000080002e8c <_ZN14ThreadsTestCPP9fibonacciEm>:
    bool finishedA = false;
    bool finishedB = false;
    bool finishedC = false;
    bool finishedD = false;

    uint64 fibonacci(uint64 n) {
    80002e8c:	fe010113          	addi	sp,sp,-32
    80002e90:	00113c23          	sd	ra,24(sp)
    80002e94:	00813823          	sd	s0,16(sp)
    80002e98:	00913423          	sd	s1,8(sp)
    80002e9c:	01213023          	sd	s2,0(sp)
    80002ea0:	02010413          	addi	s0,sp,32
    80002ea4:	00050493          	mv	s1,a0
        if (n == 0 || n == 1) { return n; }
    80002ea8:	00100793          	li	a5,1
    80002eac:	02a7f863          	bgeu	a5,a0,80002edc <_ZN14ThreadsTestCPP9fibonacciEm+0x50>
        if (n % 10 == 0) { thread_dispatch(); }
    80002eb0:	00a00793          	li	a5,10
    80002eb4:	02f577b3          	remu	a5,a0,a5
    80002eb8:	02078e63          	beqz	a5,80002ef4 <_ZN14ThreadsTestCPP9fibonacciEm+0x68>
        return fibonacci(n - 1) + fibonacci(n - 2);
    80002ebc:	fff48513          	addi	a0,s1,-1
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	fcc080e7          	jalr	-52(ra) # 80002e8c <_ZN14ThreadsTestCPP9fibonacciEm>
    80002ec8:	00050913          	mv	s2,a0
    80002ecc:	ffe48513          	addi	a0,s1,-2
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	fbc080e7          	jalr	-68(ra) # 80002e8c <_ZN14ThreadsTestCPP9fibonacciEm>
    80002ed8:	00a90533          	add	a0,s2,a0
    }
    80002edc:	01813083          	ld	ra,24(sp)
    80002ee0:	01013403          	ld	s0,16(sp)
    80002ee4:	00813483          	ld	s1,8(sp)
    80002ee8:	00013903          	ld	s2,0(sp)
    80002eec:	02010113          	addi	sp,sp,32
    80002ef0:	00008067          	ret
        if (n % 10 == 0) { thread_dispatch(); }
    80002ef4:	00003097          	auipc	ra,0x3
    80002ef8:	594080e7          	jalr	1428(ra) # 80006488 <_Z15thread_dispatchv>
    80002efc:	fc1ff06f          	j	80002ebc <_ZN14ThreadsTestCPP9fibonacciEm+0x30>

0000000080002f00 <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv>:

        void run() override {
            workerBodyD(nullptr);
        }
    };
    void WorkerA::workerBodyA(void *arg) {
    80002f00:	fe010113          	addi	sp,sp,-32
    80002f04:	00113c23          	sd	ra,24(sp)
    80002f08:	00813823          	sd	s0,16(sp)
    80002f0c:	00913423          	sd	s1,8(sp)
    80002f10:	01213023          	sd	s2,0(sp)
    80002f14:	02010413          	addi	s0,sp,32
        for (uint64 i = 0; i < 10; i++) {
    80002f18:	00000913          	li	s2,0
    80002f1c:	0380006f          	j	80002f54 <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv+0x54>
            printString("A: i="); printInt(i); printString("\n");
            for (uint64 j = 0; j < 10000; j++) {
                for (uint64 k = 0; k < 30000; k++) { }
                thread_dispatch();
    80002f20:	00003097          	auipc	ra,0x3
    80002f24:	568080e7          	jalr	1384(ra) # 80006488 <_Z15thread_dispatchv>
            for (uint64 j = 0; j < 10000; j++) {
    80002f28:	00148493          	addi	s1,s1,1
    80002f2c:	000027b7          	lui	a5,0x2
    80002f30:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80002f34:	0097ee63          	bltu	a5,s1,80002f50 <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv+0x50>
                for (uint64 k = 0; k < 30000; k++) { }
    80002f38:	00000713          	li	a4,0
    80002f3c:	000077b7          	lui	a5,0x7
    80002f40:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80002f44:	fce7eee3          	bltu	a5,a4,80002f20 <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv+0x20>
    80002f48:	00170713          	addi	a4,a4,1
    80002f4c:	ff1ff06f          	j	80002f3c <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv+0x3c>
        for (uint64 i = 0; i < 10; i++) {
    80002f50:	00190913          	addi	s2,s2,1
    80002f54:	00900793          	li	a5,9
    80002f58:	0527e063          	bltu	a5,s2,80002f98 <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv+0x98>
            printString("A: i="); printInt(i); printString("\n");
    80002f5c:	00006517          	auipc	a0,0x6
    80002f60:	0dc50513          	addi	a0,a0,220 # 80009038 <CONSOLE_STATUS+0x28>
    80002f64:	ffffe097          	auipc	ra,0xffffe
    80002f68:	6e4080e7          	jalr	1764(ra) # 80001648 <_Z11printStringPKc>
    80002f6c:	00000613          	li	a2,0
    80002f70:	00a00593          	li	a1,10
    80002f74:	0009051b          	sext.w	a0,s2
    80002f78:	fffff097          	auipc	ra,0xfffff
    80002f7c:	868080e7          	jalr	-1944(ra) # 800017e0 <_Z8printIntiii>
    80002f80:	00006517          	auipc	a0,0x6
    80002f84:	20850513          	addi	a0,a0,520 # 80009188 <CONSOLE_STATUS+0x178>
    80002f88:	ffffe097          	auipc	ra,0xffffe
    80002f8c:	6c0080e7          	jalr	1728(ra) # 80001648 <_Z11printStringPKc>
            for (uint64 j = 0; j < 10000; j++) {
    80002f90:	00000493          	li	s1,0
    80002f94:	f99ff06f          	j	80002f2c <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv+0x2c>
            }
        }
        printString("A finished!\n");
    80002f98:	00006517          	auipc	a0,0x6
    80002f9c:	0a850513          	addi	a0,a0,168 # 80009040 <CONSOLE_STATUS+0x30>
    80002fa0:	ffffe097          	auipc	ra,0xffffe
    80002fa4:	6a8080e7          	jalr	1704(ra) # 80001648 <_Z11printStringPKc>
        finishedA = true;
    80002fa8:	00100793          	li	a5,1
    80002fac:	00009717          	auipc	a4,0x9
    80002fb0:	daf70723          	sb	a5,-594(a4) # 8000bd5a <_ZN14ThreadsTestCPP9finishedAE>
    }
    80002fb4:	01813083          	ld	ra,24(sp)
    80002fb8:	01013403          	ld	s0,16(sp)
    80002fbc:	00813483          	ld	s1,8(sp)
    80002fc0:	00013903          	ld	s2,0(sp)
    80002fc4:	02010113          	addi	sp,sp,32
    80002fc8:	00008067          	ret

0000000080002fcc <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv>:

    void WorkerB::workerBodyB(void *arg) {
    80002fcc:	fe010113          	addi	sp,sp,-32
    80002fd0:	00113c23          	sd	ra,24(sp)
    80002fd4:	00813823          	sd	s0,16(sp)
    80002fd8:	00913423          	sd	s1,8(sp)
    80002fdc:	01213023          	sd	s2,0(sp)
    80002fe0:	02010413          	addi	s0,sp,32
        for (uint64 i = 0; i < 16; i++) {
    80002fe4:	00000913          	li	s2,0
    80002fe8:	0380006f          	j	80003020 <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv+0x54>
            printString("B: i="); printInt(i); printString("\n");
            for (uint64 j = 0; j < 10000; j++) {
                for (uint64 k = 0; k < 30000; k++) {  }
                thread_dispatch();
    80002fec:	00003097          	auipc	ra,0x3
    80002ff0:	49c080e7          	jalr	1180(ra) # 80006488 <_Z15thread_dispatchv>
            for (uint64 j = 0; j < 10000; j++) {
    80002ff4:	00148493          	addi	s1,s1,1
    80002ff8:	000027b7          	lui	a5,0x2
    80002ffc:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80003000:	0097ee63          	bltu	a5,s1,8000301c <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv+0x50>
                for (uint64 k = 0; k < 30000; k++) {  }
    80003004:	00000713          	li	a4,0
    80003008:	000077b7          	lui	a5,0x7
    8000300c:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80003010:	fce7eee3          	bltu	a5,a4,80002fec <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv+0x20>
    80003014:	00170713          	addi	a4,a4,1
    80003018:	ff1ff06f          	j	80003008 <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv+0x3c>
        for (uint64 i = 0; i < 16; i++) {
    8000301c:	00190913          	addi	s2,s2,1
    80003020:	00f00793          	li	a5,15
    80003024:	0527e063          	bltu	a5,s2,80003064 <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv+0x98>
            printString("B: i="); printInt(i); printString("\n");
    80003028:	00006517          	auipc	a0,0x6
    8000302c:	02850513          	addi	a0,a0,40 # 80009050 <CONSOLE_STATUS+0x40>
    80003030:	ffffe097          	auipc	ra,0xffffe
    80003034:	618080e7          	jalr	1560(ra) # 80001648 <_Z11printStringPKc>
    80003038:	00000613          	li	a2,0
    8000303c:	00a00593          	li	a1,10
    80003040:	0009051b          	sext.w	a0,s2
    80003044:	ffffe097          	auipc	ra,0xffffe
    80003048:	79c080e7          	jalr	1948(ra) # 800017e0 <_Z8printIntiii>
    8000304c:	00006517          	auipc	a0,0x6
    80003050:	13c50513          	addi	a0,a0,316 # 80009188 <CONSOLE_STATUS+0x178>
    80003054:	ffffe097          	auipc	ra,0xffffe
    80003058:	5f4080e7          	jalr	1524(ra) # 80001648 <_Z11printStringPKc>
            for (uint64 j = 0; j < 10000; j++) {
    8000305c:	00000493          	li	s1,0
    80003060:	f99ff06f          	j	80002ff8 <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv+0x2c>
            }
        }
        printString("B finished!\n");
    80003064:	00006517          	auipc	a0,0x6
    80003068:	ff450513          	addi	a0,a0,-12 # 80009058 <CONSOLE_STATUS+0x48>
    8000306c:	ffffe097          	auipc	ra,0xffffe
    80003070:	5dc080e7          	jalr	1500(ra) # 80001648 <_Z11printStringPKc>
        finishedB = true;
    80003074:	00100793          	li	a5,1
    80003078:	00009717          	auipc	a4,0x9
    8000307c:	cef701a3          	sb	a5,-797(a4) # 8000bd5b <_ZN14ThreadsTestCPP9finishedBE>
        thread_dispatch();
    80003080:	00003097          	auipc	ra,0x3
    80003084:	408080e7          	jalr	1032(ra) # 80006488 <_Z15thread_dispatchv>
    }
    80003088:	01813083          	ld	ra,24(sp)
    8000308c:	01013403          	ld	s0,16(sp)
    80003090:	00813483          	ld	s1,8(sp)
    80003094:	00013903          	ld	s2,0(sp)
    80003098:	02010113          	addi	sp,sp,32
    8000309c:	00008067          	ret

00000000800030a0 <_ZN14ThreadsTestCPP7WorkerC11workerBodyCEPv>:

    void WorkerC::workerBodyC(void *arg) {
    800030a0:	fe010113          	addi	sp,sp,-32
    800030a4:	00113c23          	sd	ra,24(sp)
    800030a8:	00813823          	sd	s0,16(sp)
    800030ac:	00913423          	sd	s1,8(sp)
    800030b0:	01213023          	sd	s2,0(sp)
    800030b4:	02010413          	addi	s0,sp,32
        uint8 i = 0;
    800030b8:	00000493          	li	s1,0
    800030bc:	0400006f          	j	800030fc <_ZN14ThreadsTestCPP7WorkerC11workerBodyCEPv+0x5c>
        for (; i < 3; i++) {
            printString("C: i="); printInt(i); printString("\n");
    800030c0:	00006517          	auipc	a0,0x6
    800030c4:	fb850513          	addi	a0,a0,-72 # 80009078 <CONSOLE_STATUS+0x68>
    800030c8:	ffffe097          	auipc	ra,0xffffe
    800030cc:	580080e7          	jalr	1408(ra) # 80001648 <_Z11printStringPKc>
    800030d0:	00000613          	li	a2,0
    800030d4:	00a00593          	li	a1,10
    800030d8:	00048513          	mv	a0,s1
    800030dc:	ffffe097          	auipc	ra,0xffffe
    800030e0:	704080e7          	jalr	1796(ra) # 800017e0 <_Z8printIntiii>
    800030e4:	00006517          	auipc	a0,0x6
    800030e8:	0a450513          	addi	a0,a0,164 # 80009188 <CONSOLE_STATUS+0x178>
    800030ec:	ffffe097          	auipc	ra,0xffffe
    800030f0:	55c080e7          	jalr	1372(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 3; i++) {
    800030f4:	0014849b          	addiw	s1,s1,1
    800030f8:	0ff4f493          	andi	s1,s1,255
    800030fc:	00200793          	li	a5,2
    80003100:	fc97f0e3          	bgeu	a5,s1,800030c0 <_ZN14ThreadsTestCPP7WorkerC11workerBodyCEPv+0x20>
        }

        printString("C: dispatch\n");
    80003104:	00006517          	auipc	a0,0x6
    80003108:	f7c50513          	addi	a0,a0,-132 # 80009080 <CONSOLE_STATUS+0x70>
    8000310c:	ffffe097          	auipc	ra,0xffffe
    80003110:	53c080e7          	jalr	1340(ra) # 80001648 <_Z11printStringPKc>
        __asm__ ("li t1, 7");
    80003114:	00700313          	li	t1,7
        thread_dispatch();
    80003118:	00003097          	auipc	ra,0x3
    8000311c:	370080e7          	jalr	880(ra) # 80006488 <_Z15thread_dispatchv>

        uint64 t1 = 0;
        __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80003120:	00030913          	mv	s2,t1

        printString("C: t1="); printInt(t1); printString("\n");
    80003124:	00006517          	auipc	a0,0x6
    80003128:	f6c50513          	addi	a0,a0,-148 # 80009090 <CONSOLE_STATUS+0x80>
    8000312c:	ffffe097          	auipc	ra,0xffffe
    80003130:	51c080e7          	jalr	1308(ra) # 80001648 <_Z11printStringPKc>
    80003134:	00000613          	li	a2,0
    80003138:	00a00593          	li	a1,10
    8000313c:	0009051b          	sext.w	a0,s2
    80003140:	ffffe097          	auipc	ra,0xffffe
    80003144:	6a0080e7          	jalr	1696(ra) # 800017e0 <_Z8printIntiii>
    80003148:	00006517          	auipc	a0,0x6
    8000314c:	04050513          	addi	a0,a0,64 # 80009188 <CONSOLE_STATUS+0x178>
    80003150:	ffffe097          	auipc	ra,0xffffe
    80003154:	4f8080e7          	jalr	1272(ra) # 80001648 <_Z11printStringPKc>

        uint64 result = fibonacci(12);
    80003158:	00c00513          	li	a0,12
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	d30080e7          	jalr	-720(ra) # 80002e8c <_ZN14ThreadsTestCPP9fibonacciEm>
    80003164:	00050913          	mv	s2,a0
        printString("C: fibonaci="); printInt(result); printString("\n");
    80003168:	00006517          	auipc	a0,0x6
    8000316c:	f3050513          	addi	a0,a0,-208 # 80009098 <CONSOLE_STATUS+0x88>
    80003170:	ffffe097          	auipc	ra,0xffffe
    80003174:	4d8080e7          	jalr	1240(ra) # 80001648 <_Z11printStringPKc>
    80003178:	00000613          	li	a2,0
    8000317c:	00a00593          	li	a1,10
    80003180:	0009051b          	sext.w	a0,s2
    80003184:	ffffe097          	auipc	ra,0xffffe
    80003188:	65c080e7          	jalr	1628(ra) # 800017e0 <_Z8printIntiii>
    8000318c:	00006517          	auipc	a0,0x6
    80003190:	ffc50513          	addi	a0,a0,-4 # 80009188 <CONSOLE_STATUS+0x178>
    80003194:	ffffe097          	auipc	ra,0xffffe
    80003198:	4b4080e7          	jalr	1204(ra) # 80001648 <_Z11printStringPKc>
    8000319c:	0400006f          	j	800031dc <_ZN14ThreadsTestCPP7WorkerC11workerBodyCEPv+0x13c>

        for (; i < 6; i++) {
            printString("C: i="); printInt(i); printString("\n");
    800031a0:	00006517          	auipc	a0,0x6
    800031a4:	ed850513          	addi	a0,a0,-296 # 80009078 <CONSOLE_STATUS+0x68>
    800031a8:	ffffe097          	auipc	ra,0xffffe
    800031ac:	4a0080e7          	jalr	1184(ra) # 80001648 <_Z11printStringPKc>
    800031b0:	00000613          	li	a2,0
    800031b4:	00a00593          	li	a1,10
    800031b8:	00048513          	mv	a0,s1
    800031bc:	ffffe097          	auipc	ra,0xffffe
    800031c0:	624080e7          	jalr	1572(ra) # 800017e0 <_Z8printIntiii>
    800031c4:	00006517          	auipc	a0,0x6
    800031c8:	fc450513          	addi	a0,a0,-60 # 80009188 <CONSOLE_STATUS+0x178>
    800031cc:	ffffe097          	auipc	ra,0xffffe
    800031d0:	47c080e7          	jalr	1148(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 6; i++) {
    800031d4:	0014849b          	addiw	s1,s1,1
    800031d8:	0ff4f493          	andi	s1,s1,255
    800031dc:	00500793          	li	a5,5
    800031e0:	fc97f0e3          	bgeu	a5,s1,800031a0 <_ZN14ThreadsTestCPP7WorkerC11workerBodyCEPv+0x100>
        }

        printString("C finished!\n");
    800031e4:	00006517          	auipc	a0,0x6
    800031e8:	ec450513          	addi	a0,a0,-316 # 800090a8 <CONSOLE_STATUS+0x98>
    800031ec:	ffffe097          	auipc	ra,0xffffe
    800031f0:	45c080e7          	jalr	1116(ra) # 80001648 <_Z11printStringPKc>
        finishedC = true;
    800031f4:	00100793          	li	a5,1
    800031f8:	00009717          	auipc	a4,0x9
    800031fc:	b6f70223          	sb	a5,-1180(a4) # 8000bd5c <_ZN14ThreadsTestCPP9finishedCE>
        thread_dispatch();
    80003200:	00003097          	auipc	ra,0x3
    80003204:	288080e7          	jalr	648(ra) # 80006488 <_Z15thread_dispatchv>
    }
    80003208:	01813083          	ld	ra,24(sp)
    8000320c:	01013403          	ld	s0,16(sp)
    80003210:	00813483          	ld	s1,8(sp)
    80003214:	00013903          	ld	s2,0(sp)
    80003218:	02010113          	addi	sp,sp,32
    8000321c:	00008067          	ret

0000000080003220 <_ZN14ThreadsTestCPP7WorkerD11workerBodyDEPv>:

    void WorkerD::workerBodyD(void* arg) {
    80003220:	fe010113          	addi	sp,sp,-32
    80003224:	00113c23          	sd	ra,24(sp)
    80003228:	00813823          	sd	s0,16(sp)
    8000322c:	00913423          	sd	s1,8(sp)
    80003230:	01213023          	sd	s2,0(sp)
    80003234:	02010413          	addi	s0,sp,32
        uint8 i = 10;
    80003238:	00a00493          	li	s1,10
    8000323c:	0400006f          	j	8000327c <_ZN14ThreadsTestCPP7WorkerD11workerBodyDEPv+0x5c>
        for (; i < 13; i++) {
            printString("D: i="); printInt(i); printString("\n");
    80003240:	00006517          	auipc	a0,0x6
    80003244:	e7850513          	addi	a0,a0,-392 # 800090b8 <CONSOLE_STATUS+0xa8>
    80003248:	ffffe097          	auipc	ra,0xffffe
    8000324c:	400080e7          	jalr	1024(ra) # 80001648 <_Z11printStringPKc>
    80003250:	00000613          	li	a2,0
    80003254:	00a00593          	li	a1,10
    80003258:	00048513          	mv	a0,s1
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	584080e7          	jalr	1412(ra) # 800017e0 <_Z8printIntiii>
    80003264:	00006517          	auipc	a0,0x6
    80003268:	f2450513          	addi	a0,a0,-220 # 80009188 <CONSOLE_STATUS+0x178>
    8000326c:	ffffe097          	auipc	ra,0xffffe
    80003270:	3dc080e7          	jalr	988(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 13; i++) {
    80003274:	0014849b          	addiw	s1,s1,1
    80003278:	0ff4f493          	andi	s1,s1,255
    8000327c:	00c00793          	li	a5,12
    80003280:	fc97f0e3          	bgeu	a5,s1,80003240 <_ZN14ThreadsTestCPP7WorkerD11workerBodyDEPv+0x20>
        }

        printString("D: dispatch\n");
    80003284:	00006517          	auipc	a0,0x6
    80003288:	e3c50513          	addi	a0,a0,-452 # 800090c0 <CONSOLE_STATUS+0xb0>
    8000328c:	ffffe097          	auipc	ra,0xffffe
    80003290:	3bc080e7          	jalr	956(ra) # 80001648 <_Z11printStringPKc>
        __asm__ ("li t1, 5");
    80003294:	00500313          	li	t1,5
        thread_dispatch();
    80003298:	00003097          	auipc	ra,0x3
    8000329c:	1f0080e7          	jalr	496(ra) # 80006488 <_Z15thread_dispatchv>

        uint64 result = fibonacci(16);
    800032a0:	01000513          	li	a0,16
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	be8080e7          	jalr	-1048(ra) # 80002e8c <_ZN14ThreadsTestCPP9fibonacciEm>
    800032ac:	00050913          	mv	s2,a0
        printString("D: fibonaci="); printInt(result); printString("\n");
    800032b0:	00006517          	auipc	a0,0x6
    800032b4:	e2050513          	addi	a0,a0,-480 # 800090d0 <CONSOLE_STATUS+0xc0>
    800032b8:	ffffe097          	auipc	ra,0xffffe
    800032bc:	390080e7          	jalr	912(ra) # 80001648 <_Z11printStringPKc>
    800032c0:	00000613          	li	a2,0
    800032c4:	00a00593          	li	a1,10
    800032c8:	0009051b          	sext.w	a0,s2
    800032cc:	ffffe097          	auipc	ra,0xffffe
    800032d0:	514080e7          	jalr	1300(ra) # 800017e0 <_Z8printIntiii>
    800032d4:	00006517          	auipc	a0,0x6
    800032d8:	eb450513          	addi	a0,a0,-332 # 80009188 <CONSOLE_STATUS+0x178>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	36c080e7          	jalr	876(ra) # 80001648 <_Z11printStringPKc>
    800032e4:	0400006f          	j	80003324 <_ZN14ThreadsTestCPP7WorkerD11workerBodyDEPv+0x104>

        for (; i < 16; i++) {
            printString("D: i="); printInt(i); printString("\n");
    800032e8:	00006517          	auipc	a0,0x6
    800032ec:	dd050513          	addi	a0,a0,-560 # 800090b8 <CONSOLE_STATUS+0xa8>
    800032f0:	ffffe097          	auipc	ra,0xffffe
    800032f4:	358080e7          	jalr	856(ra) # 80001648 <_Z11printStringPKc>
    800032f8:	00000613          	li	a2,0
    800032fc:	00a00593          	li	a1,10
    80003300:	00048513          	mv	a0,s1
    80003304:	ffffe097          	auipc	ra,0xffffe
    80003308:	4dc080e7          	jalr	1244(ra) # 800017e0 <_Z8printIntiii>
    8000330c:	00006517          	auipc	a0,0x6
    80003310:	e7c50513          	addi	a0,a0,-388 # 80009188 <CONSOLE_STATUS+0x178>
    80003314:	ffffe097          	auipc	ra,0xffffe
    80003318:	334080e7          	jalr	820(ra) # 80001648 <_Z11printStringPKc>
        for (; i < 16; i++) {
    8000331c:	0014849b          	addiw	s1,s1,1
    80003320:	0ff4f493          	andi	s1,s1,255
    80003324:	00f00793          	li	a5,15
    80003328:	fc97f0e3          	bgeu	a5,s1,800032e8 <_ZN14ThreadsTestCPP7WorkerD11workerBodyDEPv+0xc8>
        }

        printString("D finished!\n");
    8000332c:	00006517          	auipc	a0,0x6
    80003330:	db450513          	addi	a0,a0,-588 # 800090e0 <CONSOLE_STATUS+0xd0>
    80003334:	ffffe097          	auipc	ra,0xffffe
    80003338:	314080e7          	jalr	788(ra) # 80001648 <_Z11printStringPKc>
        finishedD = true;
    8000333c:	00100793          	li	a5,1
    80003340:	00009717          	auipc	a4,0x9
    80003344:	a0f70ea3          	sb	a5,-1507(a4) # 8000bd5d <_ZN14ThreadsTestCPP9finishedDE>
        thread_dispatch();
    80003348:	00003097          	auipc	ra,0x3
    8000334c:	140080e7          	jalr	320(ra) # 80006488 <_Z15thread_dispatchv>
    }
    80003350:	01813083          	ld	ra,24(sp)
    80003354:	01013403          	ld	s0,16(sp)
    80003358:	00813483          	ld	s1,8(sp)
    8000335c:	00013903          	ld	s2,0(sp)
    80003360:	02010113          	addi	sp,sp,32
    80003364:	00008067          	ret

0000000080003368 <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv>:


    void Threads_CPP_API_test() {
    80003368:	fc010113          	addi	sp,sp,-64
    8000336c:	02113c23          	sd	ra,56(sp)
    80003370:	02813823          	sd	s0,48(sp)
    80003374:	02913423          	sd	s1,40(sp)
    80003378:	03213023          	sd	s2,32(sp)
    8000337c:	04010413          	addi	s0,sp,64
        Thread* threads[4];

        threads[0] = new WorkerA();
    80003380:	01000513          	li	a0,16
    80003384:	00003097          	auipc	ra,0x3
    80003388:	6f8080e7          	jalr	1784(ra) # 80006a7c <_Znwm>
    8000338c:	00050493          	mv	s1,a0
        WorkerA():Thread() {}
    80003390:	00004097          	auipc	ra,0x4
    80003394:	940080e7          	jalr	-1728(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80003398:	00008797          	auipc	a5,0x8
    8000339c:	63878793          	addi	a5,a5,1592 # 8000b9d0 <_ZTVN14ThreadsTestCPP7WorkerAE+0x10>
    800033a0:	00f4b023          	sd	a5,0(s1)
        threads[0] = new WorkerA();
    800033a4:	fc943023          	sd	s1,-64(s0)
        printString("ThreadA created\n");
    800033a8:	00006517          	auipc	a0,0x6
    800033ac:	d4850513          	addi	a0,a0,-696 # 800090f0 <CONSOLE_STATUS+0xe0>
    800033b0:	ffffe097          	auipc	ra,0xffffe
    800033b4:	298080e7          	jalr	664(ra) # 80001648 <_Z11printStringPKc>

        threads[1] = new WorkerB();
    800033b8:	01000513          	li	a0,16
    800033bc:	00003097          	auipc	ra,0x3
    800033c0:	6c0080e7          	jalr	1728(ra) # 80006a7c <_Znwm>
    800033c4:	00050493          	mv	s1,a0
        WorkerB():Thread() {}
    800033c8:	00004097          	auipc	ra,0x4
    800033cc:	908080e7          	jalr	-1784(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    800033d0:	00008797          	auipc	a5,0x8
    800033d4:	62878793          	addi	a5,a5,1576 # 8000b9f8 <_ZTVN14ThreadsTestCPP7WorkerBE+0x10>
    800033d8:	00f4b023          	sd	a5,0(s1)
        threads[1] = new WorkerB();
    800033dc:	fc943423          	sd	s1,-56(s0)
        printString("ThreadB created\n");
    800033e0:	00006517          	auipc	a0,0x6
    800033e4:	d2850513          	addi	a0,a0,-728 # 80009108 <CONSOLE_STATUS+0xf8>
    800033e8:	ffffe097          	auipc	ra,0xffffe
    800033ec:	260080e7          	jalr	608(ra) # 80001648 <_Z11printStringPKc>

        threads[2] = new WorkerC();
    800033f0:	01000513          	li	a0,16
    800033f4:	00003097          	auipc	ra,0x3
    800033f8:	688080e7          	jalr	1672(ra) # 80006a7c <_Znwm>
    800033fc:	00050493          	mv	s1,a0
        WorkerC():Thread() {}
    80003400:	00004097          	auipc	ra,0x4
    80003404:	8d0080e7          	jalr	-1840(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80003408:	00008797          	auipc	a5,0x8
    8000340c:	61878793          	addi	a5,a5,1560 # 8000ba20 <_ZTVN14ThreadsTestCPP7WorkerCE+0x10>
    80003410:	00f4b023          	sd	a5,0(s1)
        threads[2] = new WorkerC();
    80003414:	fc943823          	sd	s1,-48(s0)
        printString("ThreadC created\n");
    80003418:	00006517          	auipc	a0,0x6
    8000341c:	d0850513          	addi	a0,a0,-760 # 80009120 <CONSOLE_STATUS+0x110>
    80003420:	ffffe097          	auipc	ra,0xffffe
    80003424:	228080e7          	jalr	552(ra) # 80001648 <_Z11printStringPKc>

        threads[3] = new WorkerD();
    80003428:	01000513          	li	a0,16
    8000342c:	00003097          	auipc	ra,0x3
    80003430:	650080e7          	jalr	1616(ra) # 80006a7c <_Znwm>
    80003434:	00050493          	mv	s1,a0
        WorkerD():Thread() {}
    80003438:	00004097          	auipc	ra,0x4
    8000343c:	898080e7          	jalr	-1896(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80003440:	00008797          	auipc	a5,0x8
    80003444:	60878793          	addi	a5,a5,1544 # 8000ba48 <_ZTVN14ThreadsTestCPP7WorkerDE+0x10>
    80003448:	00f4b023          	sd	a5,0(s1)
        threads[3] = new WorkerD();
    8000344c:	fc943c23          	sd	s1,-40(s0)
        printString("ThreadD created\n");
    80003450:	00006517          	auipc	a0,0x6
    80003454:	ce850513          	addi	a0,a0,-792 # 80009138 <CONSOLE_STATUS+0x128>
    80003458:	ffffe097          	auipc	ra,0xffffe
    8000345c:	1f0080e7          	jalr	496(ra) # 80001648 <_Z11printStringPKc>

        for(int i=0; i<4; i++) {
    80003460:	00000493          	li	s1,0
    80003464:	00300793          	li	a5,3
    80003468:	0297c663          	blt	a5,s1,80003494 <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x12c>
            threads[i]->start();
    8000346c:	00349793          	slli	a5,s1,0x3
    80003470:	fe040713          	addi	a4,s0,-32
    80003474:	00f707b3          	add	a5,a4,a5
    80003478:	fe07b503          	ld	a0,-32(a5)
    8000347c:	00003097          	auipc	ra,0x3
    80003480:	7b0080e7          	jalr	1968(ra) # 80006c2c <_ZN6Thread5startEv>
        for(int i=0; i<4; i++) {
    80003484:	0014849b          	addiw	s1,s1,1
    80003488:	fddff06f          	j	80003464 <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0xfc>
        }

        while (!(finishedA && finishedB && finishedC && finishedD)) {
            Thread::dispatch();
    8000348c:	00003097          	auipc	ra,0x3
    80003490:	7cc080e7          	jalr	1996(ra) # 80006c58 <_ZN6Thread8dispatchEv>
        while (!(finishedA && finishedB && finishedC && finishedD)) {
    80003494:	00009797          	auipc	a5,0x9
    80003498:	8c67c783          	lbu	a5,-1850(a5) # 8000bd5a <_ZN14ThreadsTestCPP9finishedAE>
    8000349c:	fe0788e3          	beqz	a5,8000348c <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x124>
    800034a0:	00009797          	auipc	a5,0x9
    800034a4:	8bb7c783          	lbu	a5,-1861(a5) # 8000bd5b <_ZN14ThreadsTestCPP9finishedBE>
    800034a8:	fe0782e3          	beqz	a5,8000348c <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x124>
    800034ac:	00009797          	auipc	a5,0x9
    800034b0:	8b07c783          	lbu	a5,-1872(a5) # 8000bd5c <_ZN14ThreadsTestCPP9finishedCE>
    800034b4:	fc078ce3          	beqz	a5,8000348c <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x124>
    800034b8:	00009797          	auipc	a5,0x9
    800034bc:	8a57c783          	lbu	a5,-1883(a5) # 8000bd5d <_ZN14ThreadsTestCPP9finishedDE>
    800034c0:	fc0786e3          	beqz	a5,8000348c <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x124>
        }

        for (auto thread: threads) { delete thread; }
    800034c4:	fc040493          	addi	s1,s0,-64
    800034c8:	0080006f          	j	800034d0 <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x168>
    800034cc:	00848493          	addi	s1,s1,8
    800034d0:	fe040793          	addi	a5,s0,-32
    800034d4:	08f48663          	beq	s1,a5,80003560 <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x1f8>
    800034d8:	0004b503          	ld	a0,0(s1)
    800034dc:	fe0508e3          	beqz	a0,800034cc <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x164>
    800034e0:	00053783          	ld	a5,0(a0)
    800034e4:	0087b783          	ld	a5,8(a5)
    800034e8:	000780e7          	jalr	a5
    800034ec:	fe1ff06f          	j	800034cc <_ZN14ThreadsTestCPP20Threads_CPP_API_testEv+0x164>
    800034f0:	00050913          	mv	s2,a0
        threads[0] = new WorkerA();
    800034f4:	00048513          	mv	a0,s1
    800034f8:	00003097          	auipc	ra,0x3
    800034fc:	5d4080e7          	jalr	1492(ra) # 80006acc <_ZdlPv>
    80003500:	00090513          	mv	a0,s2
    80003504:	0000a097          	auipc	ra,0xa
    80003508:	c24080e7          	jalr	-988(ra) # 8000d128 <_Unwind_Resume>
    8000350c:	00050913          	mv	s2,a0
        threads[1] = new WorkerB();
    80003510:	00048513          	mv	a0,s1
    80003514:	00003097          	auipc	ra,0x3
    80003518:	5b8080e7          	jalr	1464(ra) # 80006acc <_ZdlPv>
    8000351c:	00090513          	mv	a0,s2
    80003520:	0000a097          	auipc	ra,0xa
    80003524:	c08080e7          	jalr	-1016(ra) # 8000d128 <_Unwind_Resume>
    80003528:	00050913          	mv	s2,a0
        threads[2] = new WorkerC();
    8000352c:	00048513          	mv	a0,s1
    80003530:	00003097          	auipc	ra,0x3
    80003534:	59c080e7          	jalr	1436(ra) # 80006acc <_ZdlPv>
    80003538:	00090513          	mv	a0,s2
    8000353c:	0000a097          	auipc	ra,0xa
    80003540:	bec080e7          	jalr	-1044(ra) # 8000d128 <_Unwind_Resume>
    80003544:	00050913          	mv	s2,a0
        threads[3] = new WorkerD();
    80003548:	00048513          	mv	a0,s1
    8000354c:	00003097          	auipc	ra,0x3
    80003550:	580080e7          	jalr	1408(ra) # 80006acc <_ZdlPv>
    80003554:	00090513          	mv	a0,s2
    80003558:	0000a097          	auipc	ra,0xa
    8000355c:	bd0080e7          	jalr	-1072(ra) # 8000d128 <_Unwind_Resume>
    }
    80003560:	03813083          	ld	ra,56(sp)
    80003564:	03013403          	ld	s0,48(sp)
    80003568:	02813483          	ld	s1,40(sp)
    8000356c:	02013903          	ld	s2,32(sp)
    80003570:	04010113          	addi	sp,sp,64
    80003574:	00008067          	ret

0000000080003578 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv>:

    void Consumer_Producer_Sync_C_API_Test() {
    80003578:	f9010113          	addi	sp,sp,-112
    8000357c:	06113423          	sd	ra,104(sp)
    80003580:	06813023          	sd	s0,96(sp)
    80003584:	04913c23          	sd	s1,88(sp)
    80003588:	05213823          	sd	s2,80(sp)
    8000358c:	05313423          	sd	s3,72(sp)
    80003590:	05413023          	sd	s4,64(sp)
    80003594:	03513c23          	sd	s5,56(sp)
    80003598:	03613823          	sd	s6,48(sp)
    8000359c:	07010413          	addi	s0,sp,112
            sem_wait(waitForAll);
        }

        sem_close(waitForAll);

        delete buffer;
    800035a0:	00010b13          	mv	s6,sp
        printString("Unesite broj proizvodjaca?\n");
    800035a4:	00006517          	auipc	a0,0x6
    800035a8:	bac50513          	addi	a0,a0,-1108 # 80009150 <CONSOLE_STATUS+0x140>
    800035ac:	ffffe097          	auipc	ra,0xffffe
    800035b0:	09c080e7          	jalr	156(ra) # 80001648 <_Z11printStringPKc>
        getString(input, 30);
    800035b4:	01e00593          	li	a1,30
    800035b8:	fa040493          	addi	s1,s0,-96
    800035bc:	00048513          	mv	a0,s1
    800035c0:	ffffe097          	auipc	ra,0xffffe
    800035c4:	104080e7          	jalr	260(ra) # 800016c4 <_Z9getStringPci>
        threadNum = stringToInt(input);
    800035c8:	00048513          	mv	a0,s1
    800035cc:	ffffe097          	auipc	ra,0xffffe
    800035d0:	1c4080e7          	jalr	452(ra) # 80001790 <_Z11stringToIntPKc>
    800035d4:	00050913          	mv	s2,a0
        printString("Unesite velicinu bafera?\n");
    800035d8:	00006517          	auipc	a0,0x6
    800035dc:	b9850513          	addi	a0,a0,-1128 # 80009170 <CONSOLE_STATUS+0x160>
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	068080e7          	jalr	104(ra) # 80001648 <_Z11printStringPKc>
        getString(input, 30);
    800035e8:	01e00593          	li	a1,30
    800035ec:	00048513          	mv	a0,s1
    800035f0:	ffffe097          	auipc	ra,0xffffe
    800035f4:	0d4080e7          	jalr	212(ra) # 800016c4 <_Z9getStringPci>
        n = stringToInt(input);
    800035f8:	00048513          	mv	a0,s1
    800035fc:	ffffe097          	auipc	ra,0xffffe
    80003600:	194080e7          	jalr	404(ra) # 80001790 <_Z11stringToIntPKc>
    80003604:	00050493          	mv	s1,a0
        printString("Broj proizvodjaca "); printInt(threadNum);
    80003608:	00006517          	auipc	a0,0x6
    8000360c:	b8850513          	addi	a0,a0,-1144 # 80009190 <CONSOLE_STATUS+0x180>
    80003610:	ffffe097          	auipc	ra,0xffffe
    80003614:	038080e7          	jalr	56(ra) # 80001648 <_Z11printStringPKc>
    80003618:	00000613          	li	a2,0
    8000361c:	00a00593          	li	a1,10
    80003620:	00090513          	mv	a0,s2
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	1bc080e7          	jalr	444(ra) # 800017e0 <_Z8printIntiii>
        printString(" i velicina bafera "); printInt(n);
    8000362c:	00006517          	auipc	a0,0x6
    80003630:	b7c50513          	addi	a0,a0,-1156 # 800091a8 <CONSOLE_STATUS+0x198>
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	014080e7          	jalr	20(ra) # 80001648 <_Z11printStringPKc>
    8000363c:	00000613          	li	a2,0
    80003640:	00a00593          	li	a1,10
    80003644:	00048513          	mv	a0,s1
    80003648:	ffffe097          	auipc	ra,0xffffe
    8000364c:	198080e7          	jalr	408(ra) # 800017e0 <_Z8printIntiii>
        printString(".\n");
    80003650:	00006517          	auipc	a0,0x6
    80003654:	b7050513          	addi	a0,a0,-1168 # 800091c0 <CONSOLE_STATUS+0x1b0>
    80003658:	ffffe097          	auipc	ra,0xffffe
    8000365c:	ff0080e7          	jalr	-16(ra) # 80001648 <_Z11printStringPKc>
        if(threadNum > n) {
    80003660:	0324c463          	blt	s1,s2,80003688 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x110>
        } else if (threadNum < 1) {
    80003664:	03205c63          	blez	s2,8000369c <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x124>
        BufferTestCPP::BufferCPP *buffer = new BufferTestCPP::BufferCPP(n);
    80003668:	03800513          	li	a0,56
    8000366c:	00003097          	auipc	ra,0x3
    80003670:	410080e7          	jalr	1040(ra) # 80006a7c <_Znwm>
    80003674:	00050a13          	mv	s4,a0
    80003678:	00048593          	mv	a1,s1
    8000367c:	ffffe097          	auipc	ra,0xffffe
    80003680:	bd4080e7          	jalr	-1068(ra) # 80001250 <_ZN13BufferTestCPP9BufferCPPC1Ei>
    80003684:	0300006f          	j	800036b4 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x13c>
            printString("Broj proizvodjaca ne sme biti veci od velicine bafera!\n");
    80003688:	00006517          	auipc	a0,0x6
    8000368c:	b4050513          	addi	a0,a0,-1216 # 800091c8 <CONSOLE_STATUS+0x1b8>
    80003690:	ffffe097          	auipc	ra,0xffffe
    80003694:	fb8080e7          	jalr	-72(ra) # 80001648 <_Z11printStringPKc>
            return;
    80003698:	0140006f          	j	800036ac <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x134>
            printString("Broj proizvodjaca mora biti veci od nula!\n");
    8000369c:	00006517          	auipc	a0,0x6
    800036a0:	b6450513          	addi	a0,a0,-1180 # 80009200 <CONSOLE_STATUS+0x1f0>
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	fa4080e7          	jalr	-92(ra) # 80001648 <_Z11printStringPKc>
            return;
    800036ac:	000b0113          	mv	sp,s6
    800036b0:	1500006f          	j	80003800 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x288>
        sem_open(&waitForAll, 0);
    800036b4:	00000593          	li	a1,0
    800036b8:	00008517          	auipc	a0,0x8
    800036bc:	6a850513          	addi	a0,a0,1704 # 8000bd60 <_ZN21ConsumerProducerSyncC10waitForAllE>
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	f7c080e7          	jalr	-132(ra) # 8000663c <_Z8sem_openPP3semj>
        thread_t threads[threadNum];
    800036c8:	00391793          	slli	a5,s2,0x3
    800036cc:	00f78793          	addi	a5,a5,15
    800036d0:	ff07f793          	andi	a5,a5,-16
    800036d4:	40f10133          	sub	sp,sp,a5
    800036d8:	00010a93          	mv	s5,sp
        struct thread_data data[threadNum + 1];
    800036dc:	0019071b          	addiw	a4,s2,1
    800036e0:	00171793          	slli	a5,a4,0x1
    800036e4:	00e787b3          	add	a5,a5,a4
    800036e8:	00379793          	slli	a5,a5,0x3
    800036ec:	00f78793          	addi	a5,a5,15
    800036f0:	ff07f793          	andi	a5,a5,-16
    800036f4:	40f10133          	sub	sp,sp,a5
    800036f8:	00010993          	mv	s3,sp
        data[threadNum].id = threadNum;
    800036fc:	00191613          	slli	a2,s2,0x1
    80003700:	012607b3          	add	a5,a2,s2
    80003704:	00379793          	slli	a5,a5,0x3
    80003708:	00f987b3          	add	a5,s3,a5
    8000370c:	0127a023          	sw	s2,0(a5)
        data[threadNum].buffer = buffer;
    80003710:	0147b423          	sd	s4,8(a5)
        data[threadNum].wait = waitForAll;
    80003714:	00008717          	auipc	a4,0x8
    80003718:	64c73703          	ld	a4,1612(a4) # 8000bd60 <_ZN21ConsumerProducerSyncC10waitForAllE>
    8000371c:	00e7b823          	sd	a4,16(a5)
        thread_create(&consumerThread, consumer, data + threadNum);
    80003720:	00078613          	mv	a2,a5
    80003724:	fffff597          	auipc	a1,0xfffff
    80003728:	1ac58593          	addi	a1,a1,428 # 800028d0 <_ZN21ConsumerProducerSyncC8consumerEPv>
    8000372c:	f9840513          	addi	a0,s0,-104
    80003730:	00003097          	auipc	ra,0x3
    80003734:	c58080e7          	jalr	-936(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        for (int i = 0; i < threadNum; i++) {
    80003738:	00000493          	li	s1,0
    8000373c:	0280006f          	j	80003764 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x1ec>
            thread_create(threads + i,
    80003740:	fffff597          	auipc	a1,0xfffff
    80003744:	04c58593          	addi	a1,a1,76 # 8000278c <_ZN21ConsumerProducerSyncC16producerKeyboardEPv>
                          data + i);
    80003748:	00179613          	slli	a2,a5,0x1
    8000374c:	00f60633          	add	a2,a2,a5
    80003750:	00361613          	slli	a2,a2,0x3
            thread_create(threads + i,
    80003754:	00c98633          	add	a2,s3,a2
    80003758:	00003097          	auipc	ra,0x3
    8000375c:	c30080e7          	jalr	-976(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        for (int i = 0; i < threadNum; i++) {
    80003760:	0014849b          	addiw	s1,s1,1
    80003764:	0524d263          	bge	s1,s2,800037a8 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x230>
            data[i].id = i;
    80003768:	00149793          	slli	a5,s1,0x1
    8000376c:	009787b3          	add	a5,a5,s1
    80003770:	00379793          	slli	a5,a5,0x3
    80003774:	00f987b3          	add	a5,s3,a5
    80003778:	0097a023          	sw	s1,0(a5)
            data[i].buffer = buffer;
    8000377c:	0147b423          	sd	s4,8(a5)
            data[i].wait = waitForAll;
    80003780:	00008717          	auipc	a4,0x8
    80003784:	5e073703          	ld	a4,1504(a4) # 8000bd60 <_ZN21ConsumerProducerSyncC10waitForAllE>
    80003788:	00e7b823          	sd	a4,16(a5)
            thread_create(threads + i,
    8000378c:	00048793          	mv	a5,s1
    80003790:	00349513          	slli	a0,s1,0x3
    80003794:	00aa8533          	add	a0,s5,a0
    80003798:	fa9054e3          	blez	s1,80003740 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x1c8>
    8000379c:	fffff597          	auipc	a1,0xfffff
    800037a0:	0a058593          	addi	a1,a1,160 # 8000283c <_ZN21ConsumerProducerSyncC8producerEPv>
    800037a4:	fa5ff06f          	j	80003748 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x1d0>
        thread_dispatch();
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	ce0080e7          	jalr	-800(ra) # 80006488 <_Z15thread_dispatchv>
        for (int i = 0; i <= threadNum; i++) {
    800037b0:	00000493          	li	s1,0
    800037b4:	00994e63          	blt	s2,s1,800037d0 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x258>
            sem_wait(waitForAll);
    800037b8:	00008517          	auipc	a0,0x8
    800037bc:	5a853503          	ld	a0,1448(a0) # 8000bd60 <_ZN21ConsumerProducerSyncC10waitForAllE>
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	f4c080e7          	jalr	-180(ra) # 8000670c <_Z8sem_waitP3sem>
        for (int i = 0; i <= threadNum; i++) {
    800037c8:	0014849b          	addiw	s1,s1,1
    800037cc:	fe9ff06f          	j	800037b4 <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x23c>
        sem_close(waitForAll);
    800037d0:	00008517          	auipc	a0,0x8
    800037d4:	59053503          	ld	a0,1424(a0) # 8000bd60 <_ZN21ConsumerProducerSyncC10waitForAllE>
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	edc080e7          	jalr	-292(ra) # 800066b4 <_Z9sem_closeP3sem>
        delete buffer;
    800037e0:	000a0e63          	beqz	s4,800037fc <_ZN21ConsumerProducerSyncC33Consumer_Producer_Sync_C_API_TestEv+0x284>
    800037e4:	000a0513          	mv	a0,s4
    800037e8:	ffffe097          	auipc	ra,0xffffe
    800037ec:	d60080e7          	jalr	-672(ra) # 80001548 <_ZN13BufferTestCPP9BufferCPPD1Ev>
    800037f0:	000a0513          	mv	a0,s4
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	2d8080e7          	jalr	728(ra) # 80006acc <_ZdlPv>
    800037fc:	000b0113          	mv	sp,s6

    }
    80003800:	f9040113          	addi	sp,s0,-112
    80003804:	06813083          	ld	ra,104(sp)
    80003808:	06013403          	ld	s0,96(sp)
    8000380c:	05813483          	ld	s1,88(sp)
    80003810:	05013903          	ld	s2,80(sp)
    80003814:	04813983          	ld	s3,72(sp)
    80003818:	04013a03          	ld	s4,64(sp)
    8000381c:	03813a83          	ld	s5,56(sp)
    80003820:	03013b03          	ld	s6,48(sp)
    80003824:	07010113          	addi	sp,sp,112
    80003828:	00008067          	ret
    8000382c:	00050493          	mv	s1,a0
        BufferTestCPP::BufferCPP *buffer = new BufferTestCPP::BufferCPP(n);
    80003830:	000a0513          	mv	a0,s4
    80003834:	00003097          	auipc	ra,0x3
    80003838:	298080e7          	jalr	664(ra) # 80006acc <_ZdlPv>
    8000383c:	00048513          	mv	a0,s1
    80003840:	0000a097          	auipc	ra,0xa
    80003844:	8e8080e7          	jalr	-1816(ra) # 8000d128 <_Unwind_Resume>

0000000080003848 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard16producerKeyboardEPv>:
        void run() override {
            producerKeyboard(td);
        }
    };

    void ProducerKeyboard::producerKeyboard(void *arg) {
    80003848:	fd010113          	addi	sp,sp,-48
    8000384c:	02113423          	sd	ra,40(sp)
    80003850:	02813023          	sd	s0,32(sp)
    80003854:	00913c23          	sd	s1,24(sp)
    80003858:	01213823          	sd	s2,16(sp)
    8000385c:	01313423          	sd	s3,8(sp)
    80003860:	03010413          	addi	s0,sp,48
    80003864:	00050993          	mv	s3,a0
    80003868:	00058493          	mv	s1,a1
        struct thread_data *data = (struct thread_data *) arg;

        int key;
        int i = 0;
    8000386c:	00000913          	li	s2,0
    80003870:	00c0006f          	j	8000387c <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard16producerKeyboardEPv+0x34>
        while ((key = getc()) != 0x1b) {
            data->buffer->put(key);
            i++;

            if (i % (10 * data->id) == 0) {
                Thread::dispatch();
    80003874:	00003097          	auipc	ra,0x3
    80003878:	3e4080e7          	jalr	996(ra) # 80006c58 <_ZN6Thread8dispatchEv>
        while ((key = getc()) != 0x1b) {
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	fa0080e7          	jalr	-96(ra) # 8000681c <_Z4getcv>
    80003884:	0005059b          	sext.w	a1,a0
    80003888:	01b00793          	li	a5,27
    8000388c:	02f58a63          	beq	a1,a5,800038c0 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard16producerKeyboardEPv+0x78>
            data->buffer->put(key);
    80003890:	0084b503          	ld	a0,8(s1)
    80003894:	ffffe097          	auipc	ra,0xffffe
    80003898:	b10080e7          	jalr	-1264(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
            i++;
    8000389c:	0019071b          	addiw	a4,s2,1
    800038a0:	0007091b          	sext.w	s2,a4
            if (i % (10 * data->id) == 0) {
    800038a4:	0004a683          	lw	a3,0(s1)
    800038a8:	0026979b          	slliw	a5,a3,0x2
    800038ac:	00d787bb          	addw	a5,a5,a3
    800038b0:	0017979b          	slliw	a5,a5,0x1
    800038b4:	02f767bb          	remw	a5,a4,a5
    800038b8:	fc0792e3          	bnez	a5,8000387c <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard16producerKeyboardEPv+0x34>
    800038bc:	fb9ff06f          	j	80003874 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard16producerKeyboardEPv+0x2c>
            }
        }

        threadEnd = 1;
    800038c0:	00100793          	li	a5,1
    800038c4:	00008717          	auipc	a4,0x8
    800038c8:	4af72223          	sw	a5,1188(a4) # 8000bd68 <_ZN23ConsumerProducerSyncCPP9threadEndE>
        td->buffer->put('!');
    800038cc:	0109b783          	ld	a5,16(s3)
    800038d0:	02100593          	li	a1,33
    800038d4:	0087b503          	ld	a0,8(a5)
    800038d8:	ffffe097          	auipc	ra,0xffffe
    800038dc:	acc080e7          	jalr	-1332(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>

        data->wait->signal();
    800038e0:	0104b503          	ld	a0,16(s1)
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	494080e7          	jalr	1172(ra) # 80006d78 <_ZN9Semaphore6signalEv>
    }
    800038ec:	02813083          	ld	ra,40(sp)
    800038f0:	02013403          	ld	s0,32(sp)
    800038f4:	01813483          	ld	s1,24(sp)
    800038f8:	01013903          	ld	s2,16(sp)
    800038fc:	00813983          	ld	s3,8(sp)
    80003900:	03010113          	addi	sp,sp,48
    80003904:	00008067          	ret

0000000080003908 <_ZN23ConsumerProducerSyncCPP8Producer8producerEPv>:
        void run() override {
            producer(td);
        }
    };

    void Producer::producer(void *arg) {
    80003908:	fe010113          	addi	sp,sp,-32
    8000390c:	00113c23          	sd	ra,24(sp)
    80003910:	00813823          	sd	s0,16(sp)
    80003914:	00913423          	sd	s1,8(sp)
    80003918:	01213023          	sd	s2,0(sp)
    8000391c:	02010413          	addi	s0,sp,32
    80003920:	00058493          	mv	s1,a1
        struct thread_data *data = (struct thread_data *) arg;

        int i = 0;
    80003924:	00000913          	li	s2,0
    80003928:	00c0006f          	j	80003934 <_ZN23ConsumerProducerSyncCPP8Producer8producerEPv+0x2c>
        while (!threadEnd) {
            data->buffer->put(data->id + '0');
            i++;

            if (i % (10 * data->id) == 0) {
                Thread::dispatch();
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	32c080e7          	jalr	812(ra) # 80006c58 <_ZN6Thread8dispatchEv>
        while (!threadEnd) {
    80003934:	00008797          	auipc	a5,0x8
    80003938:	4347a783          	lw	a5,1076(a5) # 8000bd68 <_ZN23ConsumerProducerSyncCPP9threadEndE>
    8000393c:	02079e63          	bnez	a5,80003978 <_ZN23ConsumerProducerSyncCPP8Producer8producerEPv+0x70>
            data->buffer->put(data->id + '0');
    80003940:	0004a583          	lw	a1,0(s1)
    80003944:	0305859b          	addiw	a1,a1,48
    80003948:	0084b503          	ld	a0,8(s1)
    8000394c:	ffffe097          	auipc	ra,0xffffe
    80003950:	a58080e7          	jalr	-1448(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
            i++;
    80003954:	0019071b          	addiw	a4,s2,1
    80003958:	0007091b          	sext.w	s2,a4
            if (i % (10 * data->id) == 0) {
    8000395c:	0004a683          	lw	a3,0(s1)
    80003960:	0026979b          	slliw	a5,a3,0x2
    80003964:	00d787bb          	addw	a5,a5,a3
    80003968:	0017979b          	slliw	a5,a5,0x1
    8000396c:	02f767bb          	remw	a5,a4,a5
    80003970:	fc0792e3          	bnez	a5,80003934 <_ZN23ConsumerProducerSyncCPP8Producer8producerEPv+0x2c>
    80003974:	fb9ff06f          	j	8000392c <_ZN23ConsumerProducerSyncCPP8Producer8producerEPv+0x24>
            }
        }

        data->wait->signal();
    80003978:	0104b503          	ld	a0,16(s1)
    8000397c:	00003097          	auipc	ra,0x3
    80003980:	3fc080e7          	jalr	1020(ra) # 80006d78 <_ZN9Semaphore6signalEv>
    }
    80003984:	01813083          	ld	ra,24(sp)
    80003988:	01013403          	ld	s0,16(sp)
    8000398c:	00813483          	ld	s1,8(sp)
    80003990:	00013903          	ld	s2,0(sp)
    80003994:	02010113          	addi	sp,sp,32
    80003998:	00008067          	ret

000000008000399c <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv>:
        void run() override {
            consumer(td);
        }
    };

    void Consumer::consumer(void *arg) {
    8000399c:	fd010113          	addi	sp,sp,-48
    800039a0:	02113423          	sd	ra,40(sp)
    800039a4:	02813023          	sd	s0,32(sp)
    800039a8:	00913c23          	sd	s1,24(sp)
    800039ac:	01213823          	sd	s2,16(sp)
    800039b0:	01313423          	sd	s3,8(sp)
    800039b4:	01413023          	sd	s4,0(sp)
    800039b8:	03010413          	addi	s0,sp,48
    800039bc:	00050993          	mv	s3,a0
    800039c0:	00058913          	mv	s2,a1
        struct thread_data *data = (struct thread_data *) arg;

        int i = 0;
    800039c4:	00000a13          	li	s4,0
    800039c8:	01c0006f          	j	800039e4 <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0x48>
            i++;

            putc(key);

            if (i % (5 * data->id) == 0) {
                Thread::dispatch();
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	28c080e7          	jalr	652(ra) # 80006c58 <_ZN6Thread8dispatchEv>
    800039d4:	0500006f          	j	80003a24 <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0x88>
            }

            if (i % 80 == 0) {
                putc('\n');
    800039d8:	00a00513          	li	a0,10
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	e98080e7          	jalr	-360(ra) # 80006874 <_Z4putcc>
        while (!threadEnd) {
    800039e4:	00008797          	auipc	a5,0x8
    800039e8:	3847a783          	lw	a5,900(a5) # 8000bd68 <_ZN23ConsumerProducerSyncCPP9threadEndE>
    800039ec:	06079263          	bnez	a5,80003a50 <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0xb4>
            int key = data->buffer->get();
    800039f0:	00893503          	ld	a0,8(s2)
    800039f4:	ffffe097          	auipc	ra,0xffffe
    800039f8:	a40080e7          	jalr	-1472(ra) # 80001434 <_ZN13BufferTestCPP9BufferCPP3getEv>
            i++;
    800039fc:	001a049b          	addiw	s1,s4,1
    80003a00:	00048a1b          	sext.w	s4,s1
            putc(key);
    80003a04:	0ff57513          	andi	a0,a0,255
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	e6c080e7          	jalr	-404(ra) # 80006874 <_Z4putcc>
            if (i % (5 * data->id) == 0) {
    80003a10:	00092703          	lw	a4,0(s2)
    80003a14:	0027179b          	slliw	a5,a4,0x2
    80003a18:	00e787bb          	addw	a5,a5,a4
    80003a1c:	02f4e7bb          	remw	a5,s1,a5
    80003a20:	fa0786e3          	beqz	a5,800039cc <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0x30>
            if (i % 80 == 0) {
    80003a24:	05000793          	li	a5,80
    80003a28:	02f4e4bb          	remw	s1,s1,a5
    80003a2c:	fa049ce3          	bnez	s1,800039e4 <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0x48>
    80003a30:	fa9ff06f          	j	800039d8 <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0x3c>
            }
        }


        while (td->buffer->getCnt() > 0) {
            int key = td->buffer->get();
    80003a34:	0109b783          	ld	a5,16(s3)
    80003a38:	0087b503          	ld	a0,8(a5)
    80003a3c:	ffffe097          	auipc	ra,0xffffe
    80003a40:	9f8080e7          	jalr	-1544(ra) # 80001434 <_ZN13BufferTestCPP9BufferCPP3getEv>
            Console::putc(key);
    80003a44:	0ff57513          	andi	a0,a0,255
    80003a48:	00003097          	auipc	ra,0x3
    80003a4c:	3f8080e7          	jalr	1016(ra) # 80006e40 <_ZN7Console4putcEc>
        while (td->buffer->getCnt() > 0) {
    80003a50:	0109b783          	ld	a5,16(s3)
    80003a54:	0087b503          	ld	a0,8(a5)
    80003a58:	ffffe097          	auipc	ra,0xffffe
    80003a5c:	a68080e7          	jalr	-1432(ra) # 800014c0 <_ZN13BufferTestCPP9BufferCPP6getCntEv>
    80003a60:	fca04ae3          	bgtz	a0,80003a34 <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv+0x98>
        }

        data->wait->signal();
    80003a64:	01093503          	ld	a0,16(s2)
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	310080e7          	jalr	784(ra) # 80006d78 <_ZN9Semaphore6signalEv>
    }
    80003a70:	02813083          	ld	ra,40(sp)
    80003a74:	02013403          	ld	s0,32(sp)
    80003a78:	01813483          	ld	s1,24(sp)
    80003a7c:	01013903          	ld	s2,16(sp)
    80003a80:	00813983          	ld	s3,8(sp)
    80003a84:	00013a03          	ld	s4,0(sp)
    80003a88:	03010113          	addi	sp,sp,48
    80003a8c:	00008067          	ret

0000000080003a90 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv>:

    void Consumer_Producer_Sync_CPP_API_Test() {
    80003a90:	f8010113          	addi	sp,sp,-128
    80003a94:	06113c23          	sd	ra,120(sp)
    80003a98:	06813823          	sd	s0,112(sp)
    80003a9c:	06913423          	sd	s1,104(sp)
    80003aa0:	07213023          	sd	s2,96(sp)
    80003aa4:	05313c23          	sd	s3,88(sp)
    80003aa8:	05413823          	sd	s4,80(sp)
    80003aac:	05513423          	sd	s5,72(sp)
    80003ab0:	05613023          	sd	s6,64(sp)
    80003ab4:	03713c23          	sd	s7,56(sp)
    80003ab8:	03813823          	sd	s8,48(sp)
    80003abc:	03913423          	sd	s9,40(sp)
    80003ac0:	08010413          	addi	s0,sp,128
        for (int i = 0; i < threadNum; i++) {
            delete threads[i];
        }
        delete consumerThread;
        delete waitForAll;
        delete buffer;
    80003ac4:	00010b93          	mv	s7,sp
        printString("Unesite broj proizvodjaca?\n");
    80003ac8:	00005517          	auipc	a0,0x5
    80003acc:	68850513          	addi	a0,a0,1672 # 80009150 <CONSOLE_STATUS+0x140>
    80003ad0:	ffffe097          	auipc	ra,0xffffe
    80003ad4:	b78080e7          	jalr	-1160(ra) # 80001648 <_Z11printStringPKc>
        getString(input, 30);
    80003ad8:	01e00593          	li	a1,30
    80003adc:	f8040493          	addi	s1,s0,-128
    80003ae0:	00048513          	mv	a0,s1
    80003ae4:	ffffe097          	auipc	ra,0xffffe
    80003ae8:	be0080e7          	jalr	-1056(ra) # 800016c4 <_Z9getStringPci>
        threadNum = stringToInt(input);
    80003aec:	00048513          	mv	a0,s1
    80003af0:	ffffe097          	auipc	ra,0xffffe
    80003af4:	ca0080e7          	jalr	-864(ra) # 80001790 <_Z11stringToIntPKc>
    80003af8:	00050913          	mv	s2,a0
        printString("Unesite velicinu bafera?\n");
    80003afc:	00005517          	auipc	a0,0x5
    80003b00:	67450513          	addi	a0,a0,1652 # 80009170 <CONSOLE_STATUS+0x160>
    80003b04:	ffffe097          	auipc	ra,0xffffe
    80003b08:	b44080e7          	jalr	-1212(ra) # 80001648 <_Z11printStringPKc>
        getString(input, 30);
    80003b0c:	01e00593          	li	a1,30
    80003b10:	00048513          	mv	a0,s1
    80003b14:	ffffe097          	auipc	ra,0xffffe
    80003b18:	bb0080e7          	jalr	-1104(ra) # 800016c4 <_Z9getStringPci>
        n = stringToInt(input);
    80003b1c:	00048513          	mv	a0,s1
    80003b20:	ffffe097          	auipc	ra,0xffffe
    80003b24:	c70080e7          	jalr	-912(ra) # 80001790 <_Z11stringToIntPKc>
    80003b28:	00050493          	mv	s1,a0
        printString("Broj proizvodjaca "); printInt(threadNum);
    80003b2c:	00005517          	auipc	a0,0x5
    80003b30:	66450513          	addi	a0,a0,1636 # 80009190 <CONSOLE_STATUS+0x180>
    80003b34:	ffffe097          	auipc	ra,0xffffe
    80003b38:	b14080e7          	jalr	-1260(ra) # 80001648 <_Z11printStringPKc>
    80003b3c:	00000613          	li	a2,0
    80003b40:	00a00593          	li	a1,10
    80003b44:	00090513          	mv	a0,s2
    80003b48:	ffffe097          	auipc	ra,0xffffe
    80003b4c:	c98080e7          	jalr	-872(ra) # 800017e0 <_Z8printIntiii>
        printString(" i velicina bafera "); printInt(n);
    80003b50:	00005517          	auipc	a0,0x5
    80003b54:	65850513          	addi	a0,a0,1624 # 800091a8 <CONSOLE_STATUS+0x198>
    80003b58:	ffffe097          	auipc	ra,0xffffe
    80003b5c:	af0080e7          	jalr	-1296(ra) # 80001648 <_Z11printStringPKc>
    80003b60:	00000613          	li	a2,0
    80003b64:	00a00593          	li	a1,10
    80003b68:	00048513          	mv	a0,s1
    80003b6c:	ffffe097          	auipc	ra,0xffffe
    80003b70:	c74080e7          	jalr	-908(ra) # 800017e0 <_Z8printIntiii>
        printString(".\n");
    80003b74:	00005517          	auipc	a0,0x5
    80003b78:	64c50513          	addi	a0,a0,1612 # 800091c0 <CONSOLE_STATUS+0x1b0>
    80003b7c:	ffffe097          	auipc	ra,0xffffe
    80003b80:	acc080e7          	jalr	-1332(ra) # 80001648 <_Z11printStringPKc>
        if(threadNum > n) {
    80003b84:	0324c463          	blt	s1,s2,80003bac <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x11c>
        } else if (threadNum < 1) {
    80003b88:	03205c63          	blez	s2,80003bc0 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x130>
        BufferTestCPP::BufferCPP *buffer = new BufferTestCPP::BufferCPP(n);
    80003b8c:	03800513          	li	a0,56
    80003b90:	00003097          	auipc	ra,0x3
    80003b94:	eec080e7          	jalr	-276(ra) # 80006a7c <_Znwm>
    80003b98:	00050a93          	mv	s5,a0
    80003b9c:	00048593          	mv	a1,s1
    80003ba0:	ffffd097          	auipc	ra,0xffffd
    80003ba4:	6b0080e7          	jalr	1712(ra) # 80001250 <_ZN13BufferTestCPP9BufferCPPC1Ei>
    80003ba8:	0300006f          	j	80003bd8 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x148>
            printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    80003bac:	00005517          	auipc	a0,0x5
    80003bb0:	68450513          	addi	a0,a0,1668 # 80009230 <CONSOLE_STATUS+0x220>
    80003bb4:	ffffe097          	auipc	ra,0xffffe
    80003bb8:	a94080e7          	jalr	-1388(ra) # 80001648 <_Z11printStringPKc>
            return;
    80003bbc:	0140006f          	j	80003bd0 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x140>
            printString("Broj proizvodjaca mora biti veci od nula!\n");
    80003bc0:	00005517          	auipc	a0,0x5
    80003bc4:	64050513          	addi	a0,a0,1600 # 80009200 <CONSOLE_STATUS+0x1f0>
    80003bc8:	ffffe097          	auipc	ra,0xffffe
    80003bcc:	a80080e7          	jalr	-1408(ra) # 80001648 <_Z11printStringPKc>
            return;
    80003bd0:	000b8113          	mv	sp,s7
    80003bd4:	2400006f          	j	80003e14 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x384>
        waitForAll = new Semaphore(0);
    80003bd8:	01000513          	li	a0,16
    80003bdc:	00003097          	auipc	ra,0x3
    80003be0:	ea0080e7          	jalr	-352(ra) # 80006a7c <_Znwm>
    80003be4:	00050493          	mv	s1,a0
    80003be8:	00000593          	li	a1,0
    80003bec:	00003097          	auipc	ra,0x3
    80003bf0:	128080e7          	jalr	296(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    80003bf4:	00008717          	auipc	a4,0x8
    80003bf8:	13c70713          	addi	a4,a4,316 # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    80003bfc:	04973023          	sd	s1,64(a4)
        Thread* threads[threadNum];
    80003c00:	00391793          	slli	a5,s2,0x3
    80003c04:	00f78793          	addi	a5,a5,15
    80003c08:	ff07f793          	andi	a5,a5,-16
    80003c0c:	40f10133          	sub	sp,sp,a5
    80003c10:	00010993          	mv	s3,sp
        struct thread_data data[threadNum + 1];
    80003c14:	0019069b          	addiw	a3,s2,1
    80003c18:	00169793          	slli	a5,a3,0x1
    80003c1c:	00d787b3          	add	a5,a5,a3
    80003c20:	00379793          	slli	a5,a5,0x3
    80003c24:	00f78793          	addi	a5,a5,15
    80003c28:	ff07f793          	andi	a5,a5,-16
    80003c2c:	40f10133          	sub	sp,sp,a5
    80003c30:	00010a13          	mv	s4,sp
        data[threadNum].id = threadNum;
    80003c34:	00191493          	slli	s1,s2,0x1
    80003c38:	012487b3          	add	a5,s1,s2
    80003c3c:	00379793          	slli	a5,a5,0x3
    80003c40:	00fa07b3          	add	a5,s4,a5
    80003c44:	0127a023          	sw	s2,0(a5)
        data[threadNum].buffer = buffer;
    80003c48:	0157b423          	sd	s5,8(a5)
        data[threadNum].wait = waitForAll;
    80003c4c:	04073703          	ld	a4,64(a4)
    80003c50:	00e7b823          	sd	a4,16(a5)
        consumerThread = new Consumer(data+threadNum);
    80003c54:	01800513          	li	a0,24
    80003c58:	00003097          	auipc	ra,0x3
    80003c5c:	e24080e7          	jalr	-476(ra) # 80006a7c <_Znwm>
    80003c60:	00050b13          	mv	s6,a0
    80003c64:	012484b3          	add	s1,s1,s2
    80003c68:	00349493          	slli	s1,s1,0x3
    80003c6c:	009a04b3          	add	s1,s4,s1
        Consumer(thread_data* _td):Thread(), td(_td) {}
    80003c70:	00003097          	auipc	ra,0x3
    80003c74:	060080e7          	jalr	96(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80003c78:	00008797          	auipc	a5,0x8
    80003c7c:	e4878793          	addi	a5,a5,-440 # 8000bac0 <_ZTVN23ConsumerProducerSyncCPP8ConsumerE+0x10>
    80003c80:	00fb3023          	sd	a5,0(s6)
    80003c84:	009b3823          	sd	s1,16(s6)
        consumerThread->start();
    80003c88:	000b0513          	mv	a0,s6
    80003c8c:	00003097          	auipc	ra,0x3
    80003c90:	fa0080e7          	jalr	-96(ra) # 80006c2c <_ZN6Thread5startEv>
        for (int i = 0; i < threadNum; i++) {
    80003c94:	00000493          	li	s1,0
    80003c98:	0380006f          	j	80003cd0 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x240>
        Producer(thread_data* _td):Thread(), td(_td) {}
    80003c9c:	00008797          	auipc	a5,0x8
    80003ca0:	dfc78793          	addi	a5,a5,-516 # 8000ba98 <_ZTVN23ConsumerProducerSyncCPP8ProducerE+0x10>
    80003ca4:	00fcb023          	sd	a5,0(s9)
    80003ca8:	018cb823          	sd	s8,16(s9)
                threads[i] = new Producer(data+i);
    80003cac:	00349793          	slli	a5,s1,0x3
    80003cb0:	00f987b3          	add	a5,s3,a5
    80003cb4:	0197b023          	sd	s9,0(a5)
            threads[i]->start();
    80003cb8:	00349793          	slli	a5,s1,0x3
    80003cbc:	00f987b3          	add	a5,s3,a5
    80003cc0:	0007b503          	ld	a0,0(a5)
    80003cc4:	00003097          	auipc	ra,0x3
    80003cc8:	f68080e7          	jalr	-152(ra) # 80006c2c <_ZN6Thread5startEv>
        for (int i = 0; i < threadNum; i++) {
    80003ccc:	0014849b          	addiw	s1,s1,1
    80003cd0:	0b24d063          	bge	s1,s2,80003d70 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x2e0>
            data[i].id = i;
    80003cd4:	00149793          	slli	a5,s1,0x1
    80003cd8:	009787b3          	add	a5,a5,s1
    80003cdc:	00379793          	slli	a5,a5,0x3
    80003ce0:	00fa07b3          	add	a5,s4,a5
    80003ce4:	0097a023          	sw	s1,0(a5)
            data[i].buffer = buffer;
    80003ce8:	0157b423          	sd	s5,8(a5)
            data[i].wait = waitForAll;
    80003cec:	00008717          	auipc	a4,0x8
    80003cf0:	08473703          	ld	a4,132(a4) # 8000bd70 <_ZN23ConsumerProducerSyncCPP10waitForAllE>
    80003cf4:	00e7b823          	sd	a4,16(a5)
            if(i>0) {
    80003cf8:	02905863          	blez	s1,80003d28 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x298>
                threads[i] = new Producer(data+i);
    80003cfc:	01800513          	li	a0,24
    80003d00:	00003097          	auipc	ra,0x3
    80003d04:	d7c080e7          	jalr	-644(ra) # 80006a7c <_Znwm>
    80003d08:	00050c93          	mv	s9,a0
    80003d0c:	00149c13          	slli	s8,s1,0x1
    80003d10:	009c0c33          	add	s8,s8,s1
    80003d14:	003c1c13          	slli	s8,s8,0x3
    80003d18:	018a0c33          	add	s8,s4,s8
        Producer(thread_data* _td):Thread(), td(_td) {}
    80003d1c:	00003097          	auipc	ra,0x3
    80003d20:	fb4080e7          	jalr	-76(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80003d24:	f79ff06f          	j	80003c9c <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x20c>
                threads[i] = new ProducerKeyboard(data+i);
    80003d28:	01800513          	li	a0,24
    80003d2c:	00003097          	auipc	ra,0x3
    80003d30:	d50080e7          	jalr	-688(ra) # 80006a7c <_Znwm>
    80003d34:	00050c93          	mv	s9,a0
    80003d38:	00149c13          	slli	s8,s1,0x1
    80003d3c:	009c0c33          	add	s8,s8,s1
    80003d40:	003c1c13          	slli	s8,s8,0x3
    80003d44:	018a0c33          	add	s8,s4,s8
        ProducerKeyboard(thread_data* _td):Thread(), td(_td) {}
    80003d48:	00003097          	auipc	ra,0x3
    80003d4c:	f88080e7          	jalr	-120(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80003d50:	00008797          	auipc	a5,0x8
    80003d54:	d2078793          	addi	a5,a5,-736 # 8000ba70 <_ZTVN23ConsumerProducerSyncCPP16ProducerKeyboardE+0x10>
    80003d58:	00fcb023          	sd	a5,0(s9)
    80003d5c:	018cb823          	sd	s8,16(s9)
                threads[i] = new ProducerKeyboard(data+i);
    80003d60:	00349793          	slli	a5,s1,0x3
    80003d64:	00f987b3          	add	a5,s3,a5
    80003d68:	0197b023          	sd	s9,0(a5)
    80003d6c:	f4dff06f          	j	80003cb8 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x228>
        Thread::dispatch();
    80003d70:	00003097          	auipc	ra,0x3
    80003d74:	ee8080e7          	jalr	-280(ra) # 80006c58 <_ZN6Thread8dispatchEv>
        for (int i = 0; i <= threadNum; i++) {
    80003d78:	00000493          	li	s1,0
    80003d7c:	00994e63          	blt	s2,s1,80003d98 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x308>
            waitForAll->wait();
    80003d80:	00008517          	auipc	a0,0x8
    80003d84:	ff053503          	ld	a0,-16(a0) # 8000bd70 <_ZN23ConsumerProducerSyncCPP10waitForAllE>
    80003d88:	00003097          	auipc	ra,0x3
    80003d8c:	fc4080e7          	jalr	-60(ra) # 80006d4c <_ZN9Semaphore4waitEv>
        for (int i = 0; i <= threadNum; i++) {
    80003d90:	0014849b          	addiw	s1,s1,1
    80003d94:	fe9ff06f          	j	80003d7c <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x2ec>
        for (int i = 0; i < threadNum; i++) {
    80003d98:	00000493          	li	s1,0
    80003d9c:	0080006f          	j	80003da4 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x314>
    80003da0:	0014849b          	addiw	s1,s1,1
    80003da4:	0324d263          	bge	s1,s2,80003dc8 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x338>
            delete threads[i];
    80003da8:	00349793          	slli	a5,s1,0x3
    80003dac:	00f987b3          	add	a5,s3,a5
    80003db0:	0007b503          	ld	a0,0(a5)
    80003db4:	fe0506e3          	beqz	a0,80003da0 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x310>
    80003db8:	00053783          	ld	a5,0(a0)
    80003dbc:	0087b783          	ld	a5,8(a5)
    80003dc0:	000780e7          	jalr	a5
    80003dc4:	fddff06f          	j	80003da0 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x310>
        delete consumerThread;
    80003dc8:	000b0a63          	beqz	s6,80003ddc <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x34c>
    80003dcc:	000b3783          	ld	a5,0(s6)
    80003dd0:	0087b783          	ld	a5,8(a5)
    80003dd4:	000b0513          	mv	a0,s6
    80003dd8:	000780e7          	jalr	a5
        delete waitForAll;
    80003ddc:	00008517          	auipc	a0,0x8
    80003de0:	f9453503          	ld	a0,-108(a0) # 8000bd70 <_ZN23ConsumerProducerSyncCPP10waitForAllE>
    80003de4:	00050863          	beqz	a0,80003df4 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x364>
    80003de8:	00053783          	ld	a5,0(a0)
    80003dec:	0087b783          	ld	a5,8(a5)
    80003df0:	000780e7          	jalr	a5
        delete buffer;
    80003df4:	000a8e63          	beqz	s5,80003e10 <_ZN23ConsumerProducerSyncCPP35Consumer_Producer_Sync_CPP_API_TestEv+0x380>
    80003df8:	000a8513          	mv	a0,s5
    80003dfc:	ffffd097          	auipc	ra,0xffffd
    80003e00:	74c080e7          	jalr	1868(ra) # 80001548 <_ZN13BufferTestCPP9BufferCPPD1Ev>
    80003e04:	000a8513          	mv	a0,s5
    80003e08:	00003097          	auipc	ra,0x3
    80003e0c:	cc4080e7          	jalr	-828(ra) # 80006acc <_ZdlPv>
    80003e10:	000b8113          	mv	sp,s7

    }
    80003e14:	f8040113          	addi	sp,s0,-128
    80003e18:	07813083          	ld	ra,120(sp)
    80003e1c:	07013403          	ld	s0,112(sp)
    80003e20:	06813483          	ld	s1,104(sp)
    80003e24:	06013903          	ld	s2,96(sp)
    80003e28:	05813983          	ld	s3,88(sp)
    80003e2c:	05013a03          	ld	s4,80(sp)
    80003e30:	04813a83          	ld	s5,72(sp)
    80003e34:	04013b03          	ld	s6,64(sp)
    80003e38:	03813b83          	ld	s7,56(sp)
    80003e3c:	03013c03          	ld	s8,48(sp)
    80003e40:	02813c83          	ld	s9,40(sp)
    80003e44:	08010113          	addi	sp,sp,128
    80003e48:	00008067          	ret
    80003e4c:	00050493          	mv	s1,a0
        BufferTestCPP::BufferCPP *buffer = new BufferTestCPP::BufferCPP(n);
    80003e50:	000a8513          	mv	a0,s5
    80003e54:	00003097          	auipc	ra,0x3
    80003e58:	c78080e7          	jalr	-904(ra) # 80006acc <_ZdlPv>
    80003e5c:	00048513          	mv	a0,s1
    80003e60:	00009097          	auipc	ra,0x9
    80003e64:	2c8080e7          	jalr	712(ra) # 8000d128 <_Unwind_Resume>
    80003e68:	00050913          	mv	s2,a0
        waitForAll = new Semaphore(0);
    80003e6c:	00048513          	mv	a0,s1
    80003e70:	00003097          	auipc	ra,0x3
    80003e74:	c5c080e7          	jalr	-932(ra) # 80006acc <_ZdlPv>
    80003e78:	00090513          	mv	a0,s2
    80003e7c:	00009097          	auipc	ra,0x9
    80003e80:	2ac080e7          	jalr	684(ra) # 8000d128 <_Unwind_Resume>
    80003e84:	00050493          	mv	s1,a0
        consumerThread = new Consumer(data+threadNum);
    80003e88:	000b0513          	mv	a0,s6
    80003e8c:	00003097          	auipc	ra,0x3
    80003e90:	c40080e7          	jalr	-960(ra) # 80006acc <_ZdlPv>
    80003e94:	00048513          	mv	a0,s1
    80003e98:	00009097          	auipc	ra,0x9
    80003e9c:	290080e7          	jalr	656(ra) # 8000d128 <_Unwind_Resume>
    80003ea0:	00050493          	mv	s1,a0
                threads[i] = new Producer(data+i);
    80003ea4:	000c8513          	mv	a0,s9
    80003ea8:	00003097          	auipc	ra,0x3
    80003eac:	c24080e7          	jalr	-988(ra) # 80006acc <_ZdlPv>
    80003eb0:	00048513          	mv	a0,s1
    80003eb4:	00009097          	auipc	ra,0x9
    80003eb8:	274080e7          	jalr	628(ra) # 8000d128 <_Unwind_Resume>
    80003ebc:	00050493          	mv	s1,a0
                threads[i] = new ProducerKeyboard(data+i);
    80003ec0:	000c8513          	mv	a0,s9
    80003ec4:	00003097          	auipc	ra,0x3
    80003ec8:	c08080e7          	jalr	-1016(ra) # 80006acc <_ZdlPv>
    80003ecc:	00048513          	mv	a0,s1
    80003ed0:	00009097          	auipc	ra,0x9
    80003ed4:	258080e7          	jalr	600(ra) # 8000d128 <_Unwind_Resume>

0000000080003ed8 <_ZN15ThreadSleepTest23Thread_Sleep_C_API_TestEv>:

    void Thread_Sleep_C_API_Test() {
    80003ed8:	fc010113          	addi	sp,sp,-64
    80003edc:	02113c23          	sd	ra,56(sp)
    80003ee0:	02813823          	sd	s0,48(sp)
    80003ee4:	02913423          	sd	s1,40(sp)
    80003ee8:	04010413          	addi	s0,sp,64
        const int sleepy_thread_count = 2;
        time_t sleep_times[sleepy_thread_count] = {10, 20};
    80003eec:	00a00793          	li	a5,10
    80003ef0:	fcf43823          	sd	a5,-48(s0)
    80003ef4:	01400793          	li	a5,20
    80003ef8:	fcf43c23          	sd	a5,-40(s0)
        thread_t sleepyThread[sleepy_thread_count];

        for (int i = 0; i < sleepy_thread_count; i++) {
    80003efc:	00000493          	li	s1,0
    80003f00:	02c0006f          	j	80003f2c <_ZN15ThreadSleepTest23Thread_Sleep_C_API_TestEv+0x54>
            thread_create(&sleepyThread[i], sleepyRun, sleep_times + i);
    80003f04:	00349793          	slli	a5,s1,0x3
    80003f08:	fd040613          	addi	a2,s0,-48
    80003f0c:	00f60633          	add	a2,a2,a5
    80003f10:	fffff597          	auipc	a1,0xfffff
    80003f14:	aa058593          	addi	a1,a1,-1376 # 800029b0 <_ZN15ThreadSleepTest9sleepyRunEPv>
    80003f18:	fc040513          	addi	a0,s0,-64
    80003f1c:	00f50533          	add	a0,a0,a5
    80003f20:	00002097          	auipc	ra,0x2
    80003f24:	468080e7          	jalr	1128(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
        for (int i = 0; i < sleepy_thread_count; i++) {
    80003f28:	0014849b          	addiw	s1,s1,1
    80003f2c:	00100793          	li	a5,1
    80003f30:	fc97dae3          	bge	a5,s1,80003f04 <_ZN15ThreadSleepTest23Thread_Sleep_C_API_TestEv+0x2c>
        }

        while (!(finished[0] && finished[1])) {}
    80003f34:	00008797          	auipc	a5,0x8
    80003f38:	e147c783          	lbu	a5,-492(a5) # 8000bd48 <_ZN15ThreadSleepTest8finishedE>
    80003f3c:	fe078ce3          	beqz	a5,80003f34 <_ZN15ThreadSleepTest23Thread_Sleep_C_API_TestEv+0x5c>
    80003f40:	00008797          	auipc	a5,0x8
    80003f44:	e097c783          	lbu	a5,-503(a5) # 8000bd49 <_ZN15ThreadSleepTest8finishedE+0x1>
    80003f48:	fe0786e3          	beqz	a5,80003f34 <_ZN15ThreadSleepTest23Thread_Sleep_C_API_TestEv+0x5c>
    }
    80003f4c:	03813083          	ld	ra,56(sp)
    80003f50:	03013403          	ld	s0,48(sp)
    80003f54:	02813483          	ld	s1,40(sp)
    80003f58:	04010113          	addi	sp,sp,64
    80003f5c:	00008067          	ret

0000000080003f60 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv>:

            td->sem->signal();
        }
    };

    void Consumer_Producer_Async_CPP_API_Test() {
    80003f60:	f8010113          	addi	sp,sp,-128
    80003f64:	06113c23          	sd	ra,120(sp)
    80003f68:	06813823          	sd	s0,112(sp)
    80003f6c:	06913423          	sd	s1,104(sp)
    80003f70:	07213023          	sd	s2,96(sp)
    80003f74:	05313c23          	sd	s3,88(sp)
    80003f78:	05413823          	sd	s4,80(sp)
    80003f7c:	05513423          	sd	s5,72(sp)
    80003f80:	05613023          	sd	s6,64(sp)
    80003f84:	03713c23          	sd	s7,56(sp)
    80003f88:	03813823          	sd	s8,48(sp)
    80003f8c:	03913423          	sd	s9,40(sp)
    80003f90:	08010413          	addi	s0,sp,128
        delete waitForAll;
        for (int i = 0; i < threadNum; i++) {
            delete producers[i];
        }
        delete consumer;
        delete buffer;
    80003f94:	00010c13          	mv	s8,sp
        printString("Unesite broj proizvodjaca?\n");
    80003f98:	00005517          	auipc	a0,0x5
    80003f9c:	1b850513          	addi	a0,a0,440 # 80009150 <CONSOLE_STATUS+0x140>
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	6a8080e7          	jalr	1704(ra) # 80001648 <_Z11printStringPKc>
        getString(input, 30);
    80003fa8:	01e00593          	li	a1,30
    80003fac:	f8040493          	addi	s1,s0,-128
    80003fb0:	00048513          	mv	a0,s1
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	710080e7          	jalr	1808(ra) # 800016c4 <_Z9getStringPci>
        threadNum = stringToInt(input);
    80003fbc:	00048513          	mv	a0,s1
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	7d0080e7          	jalr	2000(ra) # 80001790 <_Z11stringToIntPKc>
    80003fc8:	00050993          	mv	s3,a0
        printString("Unesite velicinu bafera?\n");
    80003fcc:	00005517          	auipc	a0,0x5
    80003fd0:	1a450513          	addi	a0,a0,420 # 80009170 <CONSOLE_STATUS+0x160>
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	674080e7          	jalr	1652(ra) # 80001648 <_Z11printStringPKc>
        getString(input, 30);
    80003fdc:	01e00593          	li	a1,30
    80003fe0:	00048513          	mv	a0,s1
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	6e0080e7          	jalr	1760(ra) # 800016c4 <_Z9getStringPci>
        n = stringToInt(input);
    80003fec:	00048513          	mv	a0,s1
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	7a0080e7          	jalr	1952(ra) # 80001790 <_Z11stringToIntPKc>
    80003ff8:	00050493          	mv	s1,a0
        printString("Broj proizvodjaca "); printInt(threadNum);
    80003ffc:	00005517          	auipc	a0,0x5
    80004000:	19450513          	addi	a0,a0,404 # 80009190 <CONSOLE_STATUS+0x180>
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	644080e7          	jalr	1604(ra) # 80001648 <_Z11printStringPKc>
    8000400c:	00000613          	li	a2,0
    80004010:	00a00593          	li	a1,10
    80004014:	00098513          	mv	a0,s3
    80004018:	ffffd097          	auipc	ra,0xffffd
    8000401c:	7c8080e7          	jalr	1992(ra) # 800017e0 <_Z8printIntiii>
        printString(" i velicina bafera "); printInt(n);
    80004020:	00005517          	auipc	a0,0x5
    80004024:	18850513          	addi	a0,a0,392 # 800091a8 <CONSOLE_STATUS+0x198>
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	620080e7          	jalr	1568(ra) # 80001648 <_Z11printStringPKc>
    80004030:	00000613          	li	a2,0
    80004034:	00a00593          	li	a1,10
    80004038:	00048513          	mv	a0,s1
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	7a4080e7          	jalr	1956(ra) # 800017e0 <_Z8printIntiii>
        printString(".\n");
    80004044:	00005517          	auipc	a0,0x5
    80004048:	17c50513          	addi	a0,a0,380 # 800091c0 <CONSOLE_STATUS+0x1b0>
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	5fc080e7          	jalr	1532(ra) # 80001648 <_Z11printStringPKc>
        if(threadNum > n) {
    80004054:	0334c463          	blt	s1,s3,8000407c <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x11c>
        } else if (threadNum < 1) {
    80004058:	03305c63          	blez	s3,80004090 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x130>
        BufferTestCPP::BufferCPP *buffer = new BufferTestCPP::BufferCPP(n);
    8000405c:	03800513          	li	a0,56
    80004060:	00003097          	auipc	ra,0x3
    80004064:	a1c080e7          	jalr	-1508(ra) # 80006a7c <_Znwm>
    80004068:	00050a93          	mv	s5,a0
    8000406c:	00048593          	mv	a1,s1
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	1e0080e7          	jalr	480(ra) # 80001250 <_ZN13BufferTestCPP9BufferCPPC1Ei>
    80004078:	0300006f          	j	800040a8 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x148>
            printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    8000407c:	00005517          	auipc	a0,0x5
    80004080:	1b450513          	addi	a0,a0,436 # 80009230 <CONSOLE_STATUS+0x220>
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	5c4080e7          	jalr	1476(ra) # 80001648 <_Z11printStringPKc>
            return;
    8000408c:	0140006f          	j	800040a0 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x140>
            printString("Broj proizvodjaca mora biti veci od nula!\n");
    80004090:	00005517          	auipc	a0,0x5
    80004094:	17050513          	addi	a0,a0,368 # 80009200 <CONSOLE_STATUS+0x1f0>
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	5b0080e7          	jalr	1456(ra) # 80001648 <_Z11printStringPKc>
            return;
    800040a0:	000c0113          	mv	sp,s8
    800040a4:	21c0006f          	j	800042c0 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x360>
        waitForAll = new Semaphore(0);
    800040a8:	01000513          	li	a0,16
    800040ac:	00003097          	auipc	ra,0x3
    800040b0:	9d0080e7          	jalr	-1584(ra) # 80006a7c <_Znwm>
    800040b4:	00050493          	mv	s1,a0
    800040b8:	00000593          	li	a1,0
    800040bc:	00003097          	auipc	ra,0x3
    800040c0:	c58080e7          	jalr	-936(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    800040c4:	00008717          	auipc	a4,0x8
    800040c8:	c6c70713          	addi	a4,a4,-916 # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    800040cc:	04973423          	sd	s1,72(a4)
        Thread *producers[threadNum];
    800040d0:	00399793          	slli	a5,s3,0x3
    800040d4:	00f78793          	addi	a5,a5,15
    800040d8:	ff07f793          	andi	a5,a5,-16
    800040dc:	40f10133          	sub	sp,sp,a5
    800040e0:	00010a13          	mv	s4,sp
        thread_data threadData[threadNum + 1];
    800040e4:	0019869b          	addiw	a3,s3,1
    800040e8:	00169793          	slli	a5,a3,0x1
    800040ec:	00d787b3          	add	a5,a5,a3
    800040f0:	00379793          	slli	a5,a5,0x3
    800040f4:	00f78793          	addi	a5,a5,15
    800040f8:	ff07f793          	andi	a5,a5,-16
    800040fc:	40f10133          	sub	sp,sp,a5
    80004100:	00010b13          	mv	s6,sp
        threadData[threadNum].id = threadNum;
    80004104:	00199493          	slli	s1,s3,0x1
    80004108:	013484b3          	add	s1,s1,s3
    8000410c:	00349493          	slli	s1,s1,0x3
    80004110:	009b04b3          	add	s1,s6,s1
    80004114:	0134a023          	sw	s3,0(s1)
        threadData[threadNum].buffer = buffer;
    80004118:	0154b423          	sd	s5,8(s1)
        threadData[threadNum].sem = waitForAll;
    8000411c:	04873783          	ld	a5,72(a4)
    80004120:	00f4b823          	sd	a5,16(s1)
        Thread *consumer = new Consumer(&threadData[threadNum]);
    80004124:	01800513          	li	a0,24
    80004128:	00003097          	auipc	ra,0x3
    8000412c:	954080e7          	jalr	-1708(ra) # 80006a7c <_Znwm>
    80004130:	00050b93          	mv	s7,a0
        Consumer(thread_data *_td) : Thread(), td(_td) {}
    80004134:	00003097          	auipc	ra,0x3
    80004138:	b9c080e7          	jalr	-1124(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    8000413c:	00008797          	auipc	a5,0x8
    80004140:	9fc78793          	addi	a5,a5,-1540 # 8000bb38 <_ZTVN24ConsumerProducerAsyncCPP8ConsumerE+0x10>
    80004144:	00fbb023          	sd	a5,0(s7)
    80004148:	009bb823          	sd	s1,16(s7)
        consumer->start();
    8000414c:	000b8513          	mv	a0,s7
    80004150:	00003097          	auipc	ra,0x3
    80004154:	adc080e7          	jalr	-1316(ra) # 80006c2c <_ZN6Thread5startEv>
        threadData[0].id = 0;
    80004158:	000b2023          	sw	zero,0(s6)
        threadData[0].buffer = buffer;
    8000415c:	015b3423          	sd	s5,8(s6)
        threadData[0].sem = waitForAll;
    80004160:	00008797          	auipc	a5,0x8
    80004164:	c187b783          	ld	a5,-1000(a5) # 8000bd78 <_ZN24ConsumerProducerAsyncCPP10waitForAllE>
    80004168:	00fb3823          	sd	a5,16(s6)
        producers[0] = new ProducerKeyborad(&threadData[0]);
    8000416c:	01800513          	li	a0,24
    80004170:	00003097          	auipc	ra,0x3
    80004174:	90c080e7          	jalr	-1780(ra) # 80006a7c <_Znwm>
    80004178:	00050493          	mv	s1,a0
        ProducerKeyborad(thread_data *_td) : Thread(), td(_td) {}
    8000417c:	00003097          	auipc	ra,0x3
    80004180:	b54080e7          	jalr	-1196(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80004184:	00008797          	auipc	a5,0x8
    80004188:	96478793          	addi	a5,a5,-1692 # 8000bae8 <_ZTVN24ConsumerProducerAsyncCPP16ProducerKeyboradE+0x10>
    8000418c:	00f4b023          	sd	a5,0(s1)
    80004190:	0164b823          	sd	s6,16(s1)
        producers[0] = new ProducerKeyborad(&threadData[0]);
    80004194:	009a3023          	sd	s1,0(s4)
        producers[0]->start();
    80004198:	00048513          	mv	a0,s1
    8000419c:	00003097          	auipc	ra,0x3
    800041a0:	a90080e7          	jalr	-1392(ra) # 80006c2c <_ZN6Thread5startEv>
        for (int i = 1; i < threadNum; i++) {
    800041a4:	00100913          	li	s2,1
    800041a8:	0300006f          	j	800041d8 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x278>
        Producer(thread_data *_td) : Thread(), td(_td) {}
    800041ac:	00008797          	auipc	a5,0x8
    800041b0:	96478793          	addi	a5,a5,-1692 # 8000bb10 <_ZTVN24ConsumerProducerAsyncCPP8ProducerE+0x10>
    800041b4:	00fcb023          	sd	a5,0(s9)
    800041b8:	009cb823          	sd	s1,16(s9)
            producers[i] = new Producer(&threadData[i]);
    800041bc:	00391793          	slli	a5,s2,0x3
    800041c0:	00fa07b3          	add	a5,s4,a5
    800041c4:	0197b023          	sd	s9,0(a5)
            producers[i]->start();
    800041c8:	000c8513          	mv	a0,s9
    800041cc:	00003097          	auipc	ra,0x3
    800041d0:	a60080e7          	jalr	-1440(ra) # 80006c2c <_ZN6Thread5startEv>
        for (int i = 1; i < threadNum; i++) {
    800041d4:	0019091b          	addiw	s2,s2,1
    800041d8:	05395263          	bge	s2,s3,8000421c <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x2bc>
            threadData[i].id = i;
    800041dc:	00191493          	slli	s1,s2,0x1
    800041e0:	012484b3          	add	s1,s1,s2
    800041e4:	00349493          	slli	s1,s1,0x3
    800041e8:	009b04b3          	add	s1,s6,s1
    800041ec:	0124a023          	sw	s2,0(s1)
            threadData[i].buffer = buffer;
    800041f0:	0154b423          	sd	s5,8(s1)
            threadData[i].sem = waitForAll;
    800041f4:	00008797          	auipc	a5,0x8
    800041f8:	b847b783          	ld	a5,-1148(a5) # 8000bd78 <_ZN24ConsumerProducerAsyncCPP10waitForAllE>
    800041fc:	00f4b823          	sd	a5,16(s1)
            producers[i] = new Producer(&threadData[i]);
    80004200:	01800513          	li	a0,24
    80004204:	00003097          	auipc	ra,0x3
    80004208:	878080e7          	jalr	-1928(ra) # 80006a7c <_Znwm>
    8000420c:	00050c93          	mv	s9,a0
        Producer(thread_data *_td) : Thread(), td(_td) {}
    80004210:	00003097          	auipc	ra,0x3
    80004214:	ac0080e7          	jalr	-1344(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80004218:	f95ff06f          	j	800041ac <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x24c>
        Thread::dispatch();
    8000421c:	00003097          	auipc	ra,0x3
    80004220:	a3c080e7          	jalr	-1476(ra) # 80006c58 <_ZN6Thread8dispatchEv>
        for (int i = 0; i <= threadNum; i++) {
    80004224:	00000493          	li	s1,0
    80004228:	0099ce63          	blt	s3,s1,80004244 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x2e4>
            waitForAll->wait();
    8000422c:	00008517          	auipc	a0,0x8
    80004230:	b4c53503          	ld	a0,-1204(a0) # 8000bd78 <_ZN24ConsumerProducerAsyncCPP10waitForAllE>
    80004234:	00003097          	auipc	ra,0x3
    80004238:	b18080e7          	jalr	-1256(ra) # 80006d4c <_ZN9Semaphore4waitEv>
        for (int i = 0; i <= threadNum; i++) {
    8000423c:	0014849b          	addiw	s1,s1,1
    80004240:	fe9ff06f          	j	80004228 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x2c8>
        delete waitForAll;
    80004244:	00008517          	auipc	a0,0x8
    80004248:	b3453503          	ld	a0,-1228(a0) # 8000bd78 <_ZN24ConsumerProducerAsyncCPP10waitForAllE>
    8000424c:	00050863          	beqz	a0,8000425c <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x2fc>
    80004250:	00053783          	ld	a5,0(a0)
    80004254:	0087b783          	ld	a5,8(a5)
    80004258:	000780e7          	jalr	a5
        for (int i = 0; i <= threadNum; i++) {
    8000425c:	00000493          	li	s1,0
    80004260:	0080006f          	j	80004268 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x308>
        for (int i = 0; i < threadNum; i++) {
    80004264:	0014849b          	addiw	s1,s1,1
    80004268:	0334d263          	bge	s1,s3,8000428c <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x32c>
            delete producers[i];
    8000426c:	00349793          	slli	a5,s1,0x3
    80004270:	00fa07b3          	add	a5,s4,a5
    80004274:	0007b503          	ld	a0,0(a5)
    80004278:	fe0506e3          	beqz	a0,80004264 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x304>
    8000427c:	00053783          	ld	a5,0(a0)
    80004280:	0087b783          	ld	a5,8(a5)
    80004284:	000780e7          	jalr	a5
    80004288:	fddff06f          	j	80004264 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x304>
        delete consumer;
    8000428c:	000b8a63          	beqz	s7,800042a0 <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x340>
    80004290:	000bb783          	ld	a5,0(s7)
    80004294:	0087b783          	ld	a5,8(a5)
    80004298:	000b8513          	mv	a0,s7
    8000429c:	000780e7          	jalr	a5
        delete buffer;
    800042a0:	000a8e63          	beqz	s5,800042bc <_ZN24ConsumerProducerAsyncCPP36Consumer_Producer_Async_CPP_API_TestEv+0x35c>
    800042a4:	000a8513          	mv	a0,s5
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	2a0080e7          	jalr	672(ra) # 80001548 <_ZN13BufferTestCPP9BufferCPPD1Ev>
    800042b0:	000a8513          	mv	a0,s5
    800042b4:	00003097          	auipc	ra,0x3
    800042b8:	818080e7          	jalr	-2024(ra) # 80006acc <_ZdlPv>
    800042bc:	000c0113          	mv	sp,s8
    }
    800042c0:	f8040113          	addi	sp,s0,-128
    800042c4:	07813083          	ld	ra,120(sp)
    800042c8:	07013403          	ld	s0,112(sp)
    800042cc:	06813483          	ld	s1,104(sp)
    800042d0:	06013903          	ld	s2,96(sp)
    800042d4:	05813983          	ld	s3,88(sp)
    800042d8:	05013a03          	ld	s4,80(sp)
    800042dc:	04813a83          	ld	s5,72(sp)
    800042e0:	04013b03          	ld	s6,64(sp)
    800042e4:	03813b83          	ld	s7,56(sp)
    800042e8:	03013c03          	ld	s8,48(sp)
    800042ec:	02813c83          	ld	s9,40(sp)
    800042f0:	08010113          	addi	sp,sp,128
    800042f4:	00008067          	ret
    800042f8:	00050493          	mv	s1,a0
        BufferTestCPP::BufferCPP *buffer = new BufferTestCPP::BufferCPP(n);
    800042fc:	000a8513          	mv	a0,s5
    80004300:	00002097          	auipc	ra,0x2
    80004304:	7cc080e7          	jalr	1996(ra) # 80006acc <_ZdlPv>
    80004308:	00048513          	mv	a0,s1
    8000430c:	00009097          	auipc	ra,0x9
    80004310:	e1c080e7          	jalr	-484(ra) # 8000d128 <_Unwind_Resume>
    80004314:	00050913          	mv	s2,a0
        waitForAll = new Semaphore(0);
    80004318:	00048513          	mv	a0,s1
    8000431c:	00002097          	auipc	ra,0x2
    80004320:	7b0080e7          	jalr	1968(ra) # 80006acc <_ZdlPv>
    80004324:	00090513          	mv	a0,s2
    80004328:	00009097          	auipc	ra,0x9
    8000432c:	e00080e7          	jalr	-512(ra) # 8000d128 <_Unwind_Resume>
    80004330:	00050493          	mv	s1,a0
        Thread *consumer = new Consumer(&threadData[threadNum]);
    80004334:	000b8513          	mv	a0,s7
    80004338:	00002097          	auipc	ra,0x2
    8000433c:	794080e7          	jalr	1940(ra) # 80006acc <_ZdlPv>
    80004340:	00048513          	mv	a0,s1
    80004344:	00009097          	auipc	ra,0x9
    80004348:	de4080e7          	jalr	-540(ra) # 8000d128 <_Unwind_Resume>
    8000434c:	00050913          	mv	s2,a0
        producers[0] = new ProducerKeyborad(&threadData[0]);
    80004350:	00048513          	mv	a0,s1
    80004354:	00002097          	auipc	ra,0x2
    80004358:	778080e7          	jalr	1912(ra) # 80006acc <_ZdlPv>
    8000435c:	00090513          	mv	a0,s2
    80004360:	00009097          	auipc	ra,0x9
    80004364:	dc8080e7          	jalr	-568(ra) # 8000d128 <_Unwind_Resume>
    80004368:	00050493          	mv	s1,a0
            producers[i] = new Producer(&threadData[i]);
    8000436c:	000c8513          	mv	a0,s9
    80004370:	00002097          	auipc	ra,0x2
    80004374:	75c080e7          	jalr	1884(ra) # 80006acc <_ZdlPv>
    80004378:	00048513          	mv	a0,s1
    8000437c:	00009097          	auipc	ra,0x9
    80004380:	dac080e7          	jalr	-596(ra) # 8000d128 <_Unwind_Resume>

0000000080004384 <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv>:
            putc('\n');
            myOwnMutex->signal();
        }
    };

    void Periodic_Threads_CPP_API_Test() {
    80004384:	fb010113          	addi	sp,sp,-80
    80004388:	04113423          	sd	ra,72(sp)
    8000438c:	04813023          	sd	s0,64(sp)
    80004390:	02913c23          	sd	s1,56(sp)
    80004394:	03213823          	sd	s2,48(sp)
    80004398:	03313423          	sd	s3,40(sp)
    8000439c:	05010413          	addi	s0,sp,80
        myOwnMutex = new Semaphore();
    800043a0:	01000513          	li	a0,16
    800043a4:	00002097          	auipc	ra,0x2
    800043a8:	6d8080e7          	jalr	1752(ra) # 80006a7c <_Znwm>
    800043ac:	00050493          	mv	s1,a0
    800043b0:	00100593          	li	a1,1
    800043b4:	00003097          	auipc	ra,0x3
    800043b8:	960080e7          	jalr	-1696(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    800043bc:	00008797          	auipc	a5,0x8
    800043c0:	9897b223          	sd	s1,-1660(a5) # 8000bd40 <_ZN19PeriodicThreadsTest10myOwnMutexE>
        myOwnWaitForAll = new Semaphore(0);
    800043c4:	01000513          	li	a0,16
    800043c8:	00002097          	auipc	ra,0x2
    800043cc:	6b4080e7          	jalr	1716(ra) # 80006a7c <_Znwm>
    800043d0:	00050493          	mv	s1,a0
    800043d4:	00000593          	li	a1,0
    800043d8:	00003097          	auipc	ra,0x3
    800043dc:	93c080e7          	jalr	-1732(ra) # 80006d14 <_ZN9SemaphoreC1Ej>
    800043e0:	00008797          	auipc	a5,0x8
    800043e4:	9697b823          	sd	s1,-1680(a5) # 8000bd50 <_ZN19PeriodicThreadsTest15myOwnWaitForAllE>

        A* a = new A(5);
    800043e8:	02000513          	li	a0,32
    800043ec:	00002097          	auipc	ra,0x2
    800043f0:	690080e7          	jalr	1680(ra) # 80006a7c <_Znwm>
    800043f4:	00050993          	mv	s3,a0
        explicit A(time_t period) : PeriodicThread(period) {}
    800043f8:	00500593          	li	a1,5
    800043fc:	00003097          	auipc	ra,0x3
    80004400:	9c8080e7          	jalr	-1592(ra) # 80006dc4 <_ZN14PeriodicThreadC1Em>
    80004404:	00007797          	auipc	a5,0x7
    80004408:	75c78793          	addi	a5,a5,1884 # 8000bb60 <_ZTVN19PeriodicThreadsTest1AE+0x10>
    8000440c:	00f9b023          	sd	a5,0(s3)
        B* b = new B(5);
    80004410:	02000513          	li	a0,32
    80004414:	00002097          	auipc	ra,0x2
    80004418:	668080e7          	jalr	1640(ra) # 80006a7c <_Znwm>
    8000441c:	00050913          	mv	s2,a0
        explicit B(time_t period) : PeriodicThread(period) {}
    80004420:	00500593          	li	a1,5
    80004424:	00003097          	auipc	ra,0x3
    80004428:	9a0080e7          	jalr	-1632(ra) # 80006dc4 <_ZN14PeriodicThreadC1Em>
    8000442c:	00007797          	auipc	a5,0x7
    80004430:	76478793          	addi	a5,a5,1892 # 8000bb90 <_ZTVN19PeriodicThreadsTest1BE+0x10>
    80004434:	00f93023          	sd	a5,0(s2)
        C* c = new C(5);
    80004438:	02000513          	li	a0,32
    8000443c:	00002097          	auipc	ra,0x2
    80004440:	640080e7          	jalr	1600(ra) # 80006a7c <_Znwm>
    80004444:	00050493          	mv	s1,a0
        explicit C(time_t period) : PeriodicThread(period) {}
    80004448:	00500593          	li	a1,5
    8000444c:	00003097          	auipc	ra,0x3
    80004450:	978080e7          	jalr	-1672(ra) # 80006dc4 <_ZN14PeriodicThreadC1Em>
    80004454:	00007797          	auipc	a5,0x7
    80004458:	76c78793          	addi	a5,a5,1900 # 8000bbc0 <_ZTVN19PeriodicThreadsTest1CE+0x10>
    8000445c:	00f4b023          	sd	a5,0(s1)

        PeriodicThread* threads[3];
        threads[0] = a;
    80004460:	fb343c23          	sd	s3,-72(s0)
        threads[1] = b;
    80004464:	fd243023          	sd	s2,-64(s0)
        threads[2] = c;
    80004468:	fc943423          	sd	s1,-56(s0)

        threads[0]->start();
    8000446c:	00098513          	mv	a0,s3
    80004470:	00002097          	auipc	ra,0x2
    80004474:	7bc080e7          	jalr	1980(ra) # 80006c2c <_ZN6Thread5startEv>
        threads[1]->start();
    80004478:	00090513          	mv	a0,s2
    8000447c:	00002097          	auipc	ra,0x2
    80004480:	7b0080e7          	jalr	1968(ra) # 80006c2c <_ZN6Thread5startEv>
        threads[2]->start();
    80004484:	00048513          	mv	a0,s1
    80004488:	00002097          	auipc	ra,0x2
    8000448c:	7a4080e7          	jalr	1956(ra) # 80006c2c <_ZN6Thread5startEv>

        int endThis = 0;
        for (int i = 0; i < 3; i++) {
    80004490:	00000493          	li	s1,0
        int endThis = 0;
    80004494:	00000913          	li	s2,0
    80004498:	0280006f          	j	800044c0 <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x13c>
            char chr = getc();
            if (chr == 'k') {
                threads[endThis++]->endPeriodicThread();
    8000449c:	0019099b          	addiw	s3,s2,1
    800044a0:	00391913          	slli	s2,s2,0x3
    800044a4:	fd040793          	addi	a5,s0,-48
    800044a8:	01278933          	add	s2,a5,s2
    800044ac:	fe893503          	ld	a0,-24(s2)
    800044b0:	00003097          	auipc	ra,0x3
    800044b4:	8f4080e7          	jalr	-1804(ra) # 80006da4 <_ZN14PeriodicThread17endPeriodicThreadEv>
    800044b8:	00098913          	mv	s2,s3
        for (int i = 0; i < 3; i++) {
    800044bc:	0014849b          	addiw	s1,s1,1
    800044c0:	00200793          	li	a5,2
    800044c4:	0097ce63          	blt	a5,s1,800044e0 <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x15c>
            char chr = getc();
    800044c8:	00002097          	auipc	ra,0x2
    800044cc:	354080e7          	jalr	852(ra) # 8000681c <_Z4getcv>
            if (chr == 'k') {
    800044d0:	06b00793          	li	a5,107
    800044d4:	fcf504e3          	beq	a0,a5,8000449c <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x118>
            } else {
                i--;
    800044d8:	fff4849b          	addiw	s1,s1,-1
    800044dc:	fe1ff06f          	j	800044bc <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x138>
            }
        }

        for (int i = 0; i < 3; i++) {
    800044e0:	00000493          	li	s1,0
    800044e4:	00200793          	li	a5,2
    800044e8:	0097ce63          	blt	a5,s1,80004504 <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x180>
            myOwnWaitForAll->wait();
    800044ec:	00008517          	auipc	a0,0x8
    800044f0:	86453503          	ld	a0,-1948(a0) # 8000bd50 <_ZN19PeriodicThreadsTest15myOwnWaitForAllE>
    800044f4:	00003097          	auipc	ra,0x3
    800044f8:	858080e7          	jalr	-1960(ra) # 80006d4c <_ZN9Semaphore4waitEv>
        for (int i = 0; i < 3; i++) {
    800044fc:	0014849b          	addiw	s1,s1,1
    80004500:	fe5ff06f          	j	800044e4 <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x160>
        }

        delete myOwnMutex;
    80004504:	00008517          	auipc	a0,0x8
    80004508:	83c53503          	ld	a0,-1988(a0) # 8000bd40 <_ZN19PeriodicThreadsTest10myOwnMutexE>
    8000450c:	00050863          	beqz	a0,8000451c <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x198>
    80004510:	00053783          	ld	a5,0(a0)
    80004514:	0087b783          	ld	a5,8(a5)
    80004518:	000780e7          	jalr	a5
        delete myOwnWaitForAll;
    8000451c:	00008517          	auipc	a0,0x8
    80004520:	83453503          	ld	a0,-1996(a0) # 8000bd50 <_ZN19PeriodicThreadsTest15myOwnWaitForAllE>
    80004524:	00050863          	beqz	a0,80004534 <_ZN19PeriodicThreadsTest29Periodic_Threads_CPP_API_TestEv+0x1b0>
    80004528:	00053783          	ld	a5,0(a0)
    8000452c:	0087b783          	ld	a5,8(a5)
    80004530:	000780e7          	jalr	a5
    }
    80004534:	04813083          	ld	ra,72(sp)
    80004538:	04013403          	ld	s0,64(sp)
    8000453c:	03813483          	ld	s1,56(sp)
    80004540:	03013903          	ld	s2,48(sp)
    80004544:	02813983          	ld	s3,40(sp)
    80004548:	05010113          	addi	sp,sp,80
    8000454c:	00008067          	ret
    80004550:	00050913          	mv	s2,a0
        myOwnMutex = new Semaphore();
    80004554:	00048513          	mv	a0,s1
    80004558:	00002097          	auipc	ra,0x2
    8000455c:	574080e7          	jalr	1396(ra) # 80006acc <_ZdlPv>
    80004560:	00090513          	mv	a0,s2
    80004564:	00009097          	auipc	ra,0x9
    80004568:	bc4080e7          	jalr	-1084(ra) # 8000d128 <_Unwind_Resume>
    8000456c:	00050913          	mv	s2,a0
        myOwnWaitForAll = new Semaphore(0);
    80004570:	00048513          	mv	a0,s1
    80004574:	00002097          	auipc	ra,0x2
    80004578:	558080e7          	jalr	1368(ra) # 80006acc <_ZdlPv>
    8000457c:	00090513          	mv	a0,s2
    80004580:	00009097          	auipc	ra,0x9
    80004584:	ba8080e7          	jalr	-1112(ra) # 8000d128 <_Unwind_Resume>
    80004588:	00050493          	mv	s1,a0
        A* a = new A(5);
    8000458c:	00098513          	mv	a0,s3
    80004590:	00002097          	auipc	ra,0x2
    80004594:	53c080e7          	jalr	1340(ra) # 80006acc <_ZdlPv>
    80004598:	00048513          	mv	a0,s1
    8000459c:	00009097          	auipc	ra,0x9
    800045a0:	b8c080e7          	jalr	-1140(ra) # 8000d128 <_Unwind_Resume>
    800045a4:	00050493          	mv	s1,a0
        B* b = new B(5);
    800045a8:	00090513          	mv	a0,s2
    800045ac:	00002097          	auipc	ra,0x2
    800045b0:	520080e7          	jalr	1312(ra) # 80006acc <_ZdlPv>
    800045b4:	00048513          	mv	a0,s1
    800045b8:	00009097          	auipc	ra,0x9
    800045bc:	b70080e7          	jalr	-1168(ra) # 8000d128 <_Unwind_Resume>
    800045c0:	00050913          	mv	s2,a0
        C* c = new C(5);
    800045c4:	00048513          	mv	a0,s1
    800045c8:	00002097          	auipc	ra,0x2
    800045cc:	504080e7          	jalr	1284(ra) # 80006acc <_ZdlPv>
    800045d0:	00090513          	mv	a0,s2
    800045d4:	00009097          	auipc	ra,0x9
    800045d8:	b54080e7          	jalr	-1196(ra) # 8000d128 <_Unwind_Resume>

00000000800045dc <main>:

// funkcija main je u nadleznosti jezgra - jezgro ima kontrolu onda nad radnjama koje ce se izvrsiti pri pokretanju programa
// nakon toga, funkcija main treba da pokrene nit nad funkcijom userMain
void main() {
    800045dc:	fc010113          	addi	sp,sp,-64
    800045e0:	02113c23          	sd	ra,56(sp)
    800045e4:	02813823          	sd	s0,48(sp)
    800045e8:	02913423          	sd	s1,40(sp)
    800045ec:	04010413          	addi	s0,sp,64

    // upisivanje adrese prekidne rutine u registar stvec
    Riscv::writeStvec(reinterpret_cast<uint64>(&Riscv::supervisorTrap));
    800045f0:	00007797          	auipc	a5,0x7
    800045f4:	6907b783          	ld	a5,1680(a5) # 8000bc80 <_GLOBAL_OFFSET_TABLE_+0x28>
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    return stvec;
}

inline void Riscv::writeStvec(uint64 stvec) {
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
    800045f8:	10579073          	csrw	stvec,a5

    // kreiranje niti za main funkciju da bismo postavili pokazivac TCB::runningThread na nit main-a - tako ce moci da radi promena konteksta
    thread_t mainThreadHandle;
    thread_create(&mainThreadHandle, nullptr, nullptr);
    800045fc:	00000613          	li	a2,0
    80004600:	00000593          	li	a1,0
    80004604:	fd840513          	addi	a0,s0,-40
    80004608:	00002097          	auipc	ra,0x2
    8000460c:	d80080e7          	jalr	-640(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
    TCB::runningThread = (TCB*)(mainThreadHandle);
    80004610:	00007797          	auipc	a5,0x7
    80004614:	6807b783          	ld	a5,1664(a5) # 8000bc90 <_GLOBAL_OFFSET_TABLE_+0x38>
    80004618:	fd843703          	ld	a4,-40(s0)
    8000461c:	00e7b023          	sd	a4,0(a5)

    // kreiranje idle niti i ubacivanje nje u scheduler (ubacivanje niti u scheduler se radi u konstruktoru klase TCB (klase koja apstrahuje nit))
    // idle nit se nikada ne izbacuje iz schedulera i uvek ce biti na kraju schedulera
    thread_t idleThreadHandle;
    thread_create(&idleThreadHandle, &idleFunction, nullptr);
    80004620:	00000613          	li	a2,0
    80004624:	00007597          	auipc	a1,0x7
    80004628:	68c5b583          	ld	a1,1676(a1) # 8000bcb0 <_GLOBAL_OFFSET_TABLE_+0x58>
    8000462c:	fd040513          	addi	a0,s0,-48
    80004630:	00002097          	auipc	ra,0x2
    80004634:	d58080e7          	jalr	-680(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>

    // kreiranje niti nad funkcijom userMain i ubacivanje nje u scheduler (ubacivanje niti u scheduler se radi u konstruktoru klase TCB)
    thread_t userMainThreadHandle;
    thread_create(&userMainThreadHandle, &userMain, nullptr);
    80004638:	00000613          	li	a2,0
    8000463c:	ffffe597          	auipc	a1,0xffffe
    80004640:	f9858593          	addi	a1,a1,-104 # 800025d4 <_Z8userMainPv>
    80004644:	fc840513          	addi	a0,s0,-56
    80004648:	00002097          	auipc	ra,0x2
    8000464c:	d40080e7          	jalr	-704(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>

    thread_t putcKernelThread;
    thread_create(&putcKernelThread, &putcKernelThreadFunction, nullptr);
    80004650:	00000613          	li	a2,0
    80004654:	00007597          	auipc	a1,0x7
    80004658:	6645b583          	ld	a1,1636(a1) # 8000bcb8 <_GLOBAL_OFFSET_TABLE_+0x60>
    8000465c:	fc040513          	addi	a0,s0,-64
    80004660:	00002097          	auipc	ra,0x2
    80004664:	d28080e7          	jalr	-728(ra) # 80006388 <_Z13thread_createPP6threadPFvPvES2_>
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    80004668:	00200793          	li	a5,2
    8000466c:	1007a073          	csrs	sstatus,a5
}
    80004670:	00c0006f          	j	8000467c <main+0xa0>
    // omogucujem spoljasnje prekide jer trenutno radimo sve u sistemskom rezimu, a tu su oni podrazumevano onemoguceni;
    // radicu u sistemskom rezimu sve dok ne dodjem do kraja projekta kad cu imati i semafore i ispis;
    Riscv::maskSetBitsSstatus(Riscv::SSTATUS_SIE);

    while (!((TCB*)userMainThreadHandle)->getFinished() || KernelBuffer::putcGetInstance()->getNumberOfElements() > 0) {
        thread_dispatch();
    80004674:	00002097          	auipc	ra,0x2
    80004678:	e14080e7          	jalr	-492(ra) # 80006488 <_Z15thread_dispatchv>
    while (!((TCB*)userMainThreadHandle)->getFinished() || KernelBuffer::putcGetInstance()->getNumberOfElements() > 0) {
    8000467c:	fc843783          	ld	a5,-56(s0)
    // u tom slucaju, u konstrukciji te niti ne treba je davati scheduleru na raspolaganje, jer bi je to suspendovalo -
    // zelimo da bas ta nit main-a nastavi da se izvrsava
    static TCB* createThread(Body body, void* arg, void* stack, bool cppApi);

    // obezbedjena enkapsulacija - atribut finished je privatan i moze se citati samo kroz getter metod, a menjati preko setter metoda
    bool getFinished() const { return finished; }
    80004680:	0307c783          	lbu	a5,48(a5)
    80004684:	fe0788e3          	beqz	a5,80004674 <main+0x98>
    80004688:	00001097          	auipc	ra,0x1
    8000468c:	2ec080e7          	jalr	748(ra) # 80005974 <_ZN12KernelBuffer15putcGetInstanceEv>
    80004690:	00001097          	auipc	ra,0x1
    80004694:	5c0080e7          	jalr	1472(ra) # 80005c50 <_ZN12KernelBuffer19getNumberOfElementsEv>
    80004698:	fca04ee3          	bgtz	a0,80004674 <main+0x98>
    }

    // moram da dealociram bafer eksplicitno jer KernelBuffer::getInstance unutar sebe ne pravi staticki objekat klase, vec
    // dinamicki alocira na heap-u, sto znaci da se nece unistiti sam taj objekat kada se zavrsi main (upravo posto nije rec o
    // statickom objektu) i zato moramo mi ovde eksplicitno da ga unistimo
    delete KernelBuffer::getcGetInstance();
    8000469c:	00001097          	auipc	ra,0x1
    800046a0:	358080e7          	jalr	856(ra) # 800059f4 <_ZN12KernelBuffer15getcGetInstanceEv>
    800046a4:	00050493          	mv	s1,a0
    800046a8:	00050c63          	beqz	a0,800046c0 <main+0xe4>
    800046ac:	00001097          	auipc	ra,0x1
    800046b0:	3c8080e7          	jalr	968(ra) # 80005a74 <_ZN12KernelBufferD1Ev>
    800046b4:	00048513          	mv	a0,s1
    800046b8:	00001097          	auipc	ra,0x1
    800046bc:	1b0080e7          	jalr	432(ra) # 80005868 <_ZN12KernelBufferdlEPv>
    // ne brisem bafer za putc jer treba da se ispise Kernel Finished za sta treba taj bafer
    800046c0:	03813083          	ld	ra,56(sp)
    800046c4:	03013403          	ld	s0,48(sp)
    800046c8:	02813483          	ld	s1,40(sp)
    800046cc:	04010113          	addi	sp,sp,64
    800046d0:	00008067          	ret

00000000800046d4 <_ZN14ThreadsTestCPP7WorkerAD1Ev>:
    class WorkerA: public Thread {
    800046d4:	ff010113          	addi	sp,sp,-16
    800046d8:	00113423          	sd	ra,8(sp)
    800046dc:	00813023          	sd	s0,0(sp)
    800046e0:	01010413          	addi	s0,sp,16
    800046e4:	00007797          	auipc	a5,0x7
    800046e8:	2ec78793          	addi	a5,a5,748 # 8000b9d0 <_ZTVN14ThreadsTestCPP7WorkerAE+0x10>
    800046ec:	00f53023          	sd	a5,0(a0)
    800046f0:	00002097          	auipc	ra,0x2
    800046f4:	46c080e7          	jalr	1132(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800046f8:	00813083          	ld	ra,8(sp)
    800046fc:	00013403          	ld	s0,0(sp)
    80004700:	01010113          	addi	sp,sp,16
    80004704:	00008067          	ret

0000000080004708 <_ZN14ThreadsTestCPP7WorkerAD0Ev>:
    80004708:	fe010113          	addi	sp,sp,-32
    8000470c:	00113c23          	sd	ra,24(sp)
    80004710:	00813823          	sd	s0,16(sp)
    80004714:	00913423          	sd	s1,8(sp)
    80004718:	02010413          	addi	s0,sp,32
    8000471c:	00050493          	mv	s1,a0
    80004720:	00007797          	auipc	a5,0x7
    80004724:	2b078793          	addi	a5,a5,688 # 8000b9d0 <_ZTVN14ThreadsTestCPP7WorkerAE+0x10>
    80004728:	00f53023          	sd	a5,0(a0)
    8000472c:	00002097          	auipc	ra,0x2
    80004730:	430080e7          	jalr	1072(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004734:	00048513          	mv	a0,s1
    80004738:	00002097          	auipc	ra,0x2
    8000473c:	394080e7          	jalr	916(ra) # 80006acc <_ZdlPv>
    80004740:	01813083          	ld	ra,24(sp)
    80004744:	01013403          	ld	s0,16(sp)
    80004748:	00813483          	ld	s1,8(sp)
    8000474c:	02010113          	addi	sp,sp,32
    80004750:	00008067          	ret

0000000080004754 <_ZN14ThreadsTestCPP7WorkerBD1Ev>:
    class WorkerB: public Thread {
    80004754:	ff010113          	addi	sp,sp,-16
    80004758:	00113423          	sd	ra,8(sp)
    8000475c:	00813023          	sd	s0,0(sp)
    80004760:	01010413          	addi	s0,sp,16
    80004764:	00007797          	auipc	a5,0x7
    80004768:	29478793          	addi	a5,a5,660 # 8000b9f8 <_ZTVN14ThreadsTestCPP7WorkerBE+0x10>
    8000476c:	00f53023          	sd	a5,0(a0)
    80004770:	00002097          	auipc	ra,0x2
    80004774:	3ec080e7          	jalr	1004(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004778:	00813083          	ld	ra,8(sp)
    8000477c:	00013403          	ld	s0,0(sp)
    80004780:	01010113          	addi	sp,sp,16
    80004784:	00008067          	ret

0000000080004788 <_ZN14ThreadsTestCPP7WorkerBD0Ev>:
    80004788:	fe010113          	addi	sp,sp,-32
    8000478c:	00113c23          	sd	ra,24(sp)
    80004790:	00813823          	sd	s0,16(sp)
    80004794:	00913423          	sd	s1,8(sp)
    80004798:	02010413          	addi	s0,sp,32
    8000479c:	00050493          	mv	s1,a0
    800047a0:	00007797          	auipc	a5,0x7
    800047a4:	25878793          	addi	a5,a5,600 # 8000b9f8 <_ZTVN14ThreadsTestCPP7WorkerBE+0x10>
    800047a8:	00f53023          	sd	a5,0(a0)
    800047ac:	00002097          	auipc	ra,0x2
    800047b0:	3b0080e7          	jalr	944(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800047b4:	00048513          	mv	a0,s1
    800047b8:	00002097          	auipc	ra,0x2
    800047bc:	314080e7          	jalr	788(ra) # 80006acc <_ZdlPv>
    800047c0:	01813083          	ld	ra,24(sp)
    800047c4:	01013403          	ld	s0,16(sp)
    800047c8:	00813483          	ld	s1,8(sp)
    800047cc:	02010113          	addi	sp,sp,32
    800047d0:	00008067          	ret

00000000800047d4 <_ZN14ThreadsTestCPP7WorkerCD1Ev>:
    class WorkerC: public Thread {
    800047d4:	ff010113          	addi	sp,sp,-16
    800047d8:	00113423          	sd	ra,8(sp)
    800047dc:	00813023          	sd	s0,0(sp)
    800047e0:	01010413          	addi	s0,sp,16
    800047e4:	00007797          	auipc	a5,0x7
    800047e8:	23c78793          	addi	a5,a5,572 # 8000ba20 <_ZTVN14ThreadsTestCPP7WorkerCE+0x10>
    800047ec:	00f53023          	sd	a5,0(a0)
    800047f0:	00002097          	auipc	ra,0x2
    800047f4:	36c080e7          	jalr	876(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800047f8:	00813083          	ld	ra,8(sp)
    800047fc:	00013403          	ld	s0,0(sp)
    80004800:	01010113          	addi	sp,sp,16
    80004804:	00008067          	ret

0000000080004808 <_ZN14ThreadsTestCPP7WorkerCD0Ev>:
    80004808:	fe010113          	addi	sp,sp,-32
    8000480c:	00113c23          	sd	ra,24(sp)
    80004810:	00813823          	sd	s0,16(sp)
    80004814:	00913423          	sd	s1,8(sp)
    80004818:	02010413          	addi	s0,sp,32
    8000481c:	00050493          	mv	s1,a0
    80004820:	00007797          	auipc	a5,0x7
    80004824:	20078793          	addi	a5,a5,512 # 8000ba20 <_ZTVN14ThreadsTestCPP7WorkerCE+0x10>
    80004828:	00f53023          	sd	a5,0(a0)
    8000482c:	00002097          	auipc	ra,0x2
    80004830:	330080e7          	jalr	816(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004834:	00048513          	mv	a0,s1
    80004838:	00002097          	auipc	ra,0x2
    8000483c:	294080e7          	jalr	660(ra) # 80006acc <_ZdlPv>
    80004840:	01813083          	ld	ra,24(sp)
    80004844:	01013403          	ld	s0,16(sp)
    80004848:	00813483          	ld	s1,8(sp)
    8000484c:	02010113          	addi	sp,sp,32
    80004850:	00008067          	ret

0000000080004854 <_ZN14ThreadsTestCPP7WorkerDD1Ev>:
    class WorkerD: public Thread {
    80004854:	ff010113          	addi	sp,sp,-16
    80004858:	00113423          	sd	ra,8(sp)
    8000485c:	00813023          	sd	s0,0(sp)
    80004860:	01010413          	addi	s0,sp,16
    80004864:	00007797          	auipc	a5,0x7
    80004868:	1e478793          	addi	a5,a5,484 # 8000ba48 <_ZTVN14ThreadsTestCPP7WorkerDE+0x10>
    8000486c:	00f53023          	sd	a5,0(a0)
    80004870:	00002097          	auipc	ra,0x2
    80004874:	2ec080e7          	jalr	748(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004878:	00813083          	ld	ra,8(sp)
    8000487c:	00013403          	ld	s0,0(sp)
    80004880:	01010113          	addi	sp,sp,16
    80004884:	00008067          	ret

0000000080004888 <_ZN14ThreadsTestCPP7WorkerDD0Ev>:
    80004888:	fe010113          	addi	sp,sp,-32
    8000488c:	00113c23          	sd	ra,24(sp)
    80004890:	00813823          	sd	s0,16(sp)
    80004894:	00913423          	sd	s1,8(sp)
    80004898:	02010413          	addi	s0,sp,32
    8000489c:	00050493          	mv	s1,a0
    800048a0:	00007797          	auipc	a5,0x7
    800048a4:	1a878793          	addi	a5,a5,424 # 8000ba48 <_ZTVN14ThreadsTestCPP7WorkerDE+0x10>
    800048a8:	00f53023          	sd	a5,0(a0)
    800048ac:	00002097          	auipc	ra,0x2
    800048b0:	2b0080e7          	jalr	688(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800048b4:	00048513          	mv	a0,s1
    800048b8:	00002097          	auipc	ra,0x2
    800048bc:	214080e7          	jalr	532(ra) # 80006acc <_ZdlPv>
    800048c0:	01813083          	ld	ra,24(sp)
    800048c4:	01013403          	ld	s0,16(sp)
    800048c8:	00813483          	ld	s1,8(sp)
    800048cc:	02010113          	addi	sp,sp,32
    800048d0:	00008067          	ret

00000000800048d4 <_ZN23ConsumerProducerSyncCPP8ConsumerD1Ev>:
    class Consumer:public Thread {
    800048d4:	ff010113          	addi	sp,sp,-16
    800048d8:	00113423          	sd	ra,8(sp)
    800048dc:	00813023          	sd	s0,0(sp)
    800048e0:	01010413          	addi	s0,sp,16
    800048e4:	00007797          	auipc	a5,0x7
    800048e8:	1dc78793          	addi	a5,a5,476 # 8000bac0 <_ZTVN23ConsumerProducerSyncCPP8ConsumerE+0x10>
    800048ec:	00f53023          	sd	a5,0(a0)
    800048f0:	00002097          	auipc	ra,0x2
    800048f4:	26c080e7          	jalr	620(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800048f8:	00813083          	ld	ra,8(sp)
    800048fc:	00013403          	ld	s0,0(sp)
    80004900:	01010113          	addi	sp,sp,16
    80004904:	00008067          	ret

0000000080004908 <_ZN23ConsumerProducerSyncCPP8ConsumerD0Ev>:
    80004908:	fe010113          	addi	sp,sp,-32
    8000490c:	00113c23          	sd	ra,24(sp)
    80004910:	00813823          	sd	s0,16(sp)
    80004914:	00913423          	sd	s1,8(sp)
    80004918:	02010413          	addi	s0,sp,32
    8000491c:	00050493          	mv	s1,a0
    80004920:	00007797          	auipc	a5,0x7
    80004924:	1a078793          	addi	a5,a5,416 # 8000bac0 <_ZTVN23ConsumerProducerSyncCPP8ConsumerE+0x10>
    80004928:	00f53023          	sd	a5,0(a0)
    8000492c:	00002097          	auipc	ra,0x2
    80004930:	230080e7          	jalr	560(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004934:	00048513          	mv	a0,s1
    80004938:	00002097          	auipc	ra,0x2
    8000493c:	194080e7          	jalr	404(ra) # 80006acc <_ZdlPv>
    80004940:	01813083          	ld	ra,24(sp)
    80004944:	01013403          	ld	s0,16(sp)
    80004948:	00813483          	ld	s1,8(sp)
    8000494c:	02010113          	addi	sp,sp,32
    80004950:	00008067          	ret

0000000080004954 <_ZN23ConsumerProducerSyncCPP8ProducerD1Ev>:
    class Producer:public Thread {
    80004954:	ff010113          	addi	sp,sp,-16
    80004958:	00113423          	sd	ra,8(sp)
    8000495c:	00813023          	sd	s0,0(sp)
    80004960:	01010413          	addi	s0,sp,16
    80004964:	00007797          	auipc	a5,0x7
    80004968:	13478793          	addi	a5,a5,308 # 8000ba98 <_ZTVN23ConsumerProducerSyncCPP8ProducerE+0x10>
    8000496c:	00f53023          	sd	a5,0(a0)
    80004970:	00002097          	auipc	ra,0x2
    80004974:	1ec080e7          	jalr	492(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004978:	00813083          	ld	ra,8(sp)
    8000497c:	00013403          	ld	s0,0(sp)
    80004980:	01010113          	addi	sp,sp,16
    80004984:	00008067          	ret

0000000080004988 <_ZN23ConsumerProducerSyncCPP8ProducerD0Ev>:
    80004988:	fe010113          	addi	sp,sp,-32
    8000498c:	00113c23          	sd	ra,24(sp)
    80004990:	00813823          	sd	s0,16(sp)
    80004994:	00913423          	sd	s1,8(sp)
    80004998:	02010413          	addi	s0,sp,32
    8000499c:	00050493          	mv	s1,a0
    800049a0:	00007797          	auipc	a5,0x7
    800049a4:	0f878793          	addi	a5,a5,248 # 8000ba98 <_ZTVN23ConsumerProducerSyncCPP8ProducerE+0x10>
    800049a8:	00f53023          	sd	a5,0(a0)
    800049ac:	00002097          	auipc	ra,0x2
    800049b0:	1b0080e7          	jalr	432(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800049b4:	00048513          	mv	a0,s1
    800049b8:	00002097          	auipc	ra,0x2
    800049bc:	114080e7          	jalr	276(ra) # 80006acc <_ZdlPv>
    800049c0:	01813083          	ld	ra,24(sp)
    800049c4:	01013403          	ld	s0,16(sp)
    800049c8:	00813483          	ld	s1,8(sp)
    800049cc:	02010113          	addi	sp,sp,32
    800049d0:	00008067          	ret

00000000800049d4 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboardD1Ev>:
    class ProducerKeyboard:public Thread {
    800049d4:	ff010113          	addi	sp,sp,-16
    800049d8:	00113423          	sd	ra,8(sp)
    800049dc:	00813023          	sd	s0,0(sp)
    800049e0:	01010413          	addi	s0,sp,16
    800049e4:	00007797          	auipc	a5,0x7
    800049e8:	08c78793          	addi	a5,a5,140 # 8000ba70 <_ZTVN23ConsumerProducerSyncCPP16ProducerKeyboardE+0x10>
    800049ec:	00f53023          	sd	a5,0(a0)
    800049f0:	00002097          	auipc	ra,0x2
    800049f4:	16c080e7          	jalr	364(ra) # 80006b5c <_ZN6ThreadD1Ev>
    800049f8:	00813083          	ld	ra,8(sp)
    800049fc:	00013403          	ld	s0,0(sp)
    80004a00:	01010113          	addi	sp,sp,16
    80004a04:	00008067          	ret

0000000080004a08 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboardD0Ev>:
    80004a08:	fe010113          	addi	sp,sp,-32
    80004a0c:	00113c23          	sd	ra,24(sp)
    80004a10:	00813823          	sd	s0,16(sp)
    80004a14:	00913423          	sd	s1,8(sp)
    80004a18:	02010413          	addi	s0,sp,32
    80004a1c:	00050493          	mv	s1,a0
    80004a20:	00007797          	auipc	a5,0x7
    80004a24:	05078793          	addi	a5,a5,80 # 8000ba70 <_ZTVN23ConsumerProducerSyncCPP16ProducerKeyboardE+0x10>
    80004a28:	00f53023          	sd	a5,0(a0)
    80004a2c:	00002097          	auipc	ra,0x2
    80004a30:	130080e7          	jalr	304(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004a34:	00048513          	mv	a0,s1
    80004a38:	00002097          	auipc	ra,0x2
    80004a3c:	094080e7          	jalr	148(ra) # 80006acc <_ZdlPv>
    80004a40:	01813083          	ld	ra,24(sp)
    80004a44:	01013403          	ld	s0,16(sp)
    80004a48:	00813483          	ld	s1,8(sp)
    80004a4c:	02010113          	addi	sp,sp,32
    80004a50:	00008067          	ret

0000000080004a54 <_ZN24ConsumerProducerAsyncCPP8ConsumerD1Ev>:
    class Consumer : public Thread {
    80004a54:	ff010113          	addi	sp,sp,-16
    80004a58:	00113423          	sd	ra,8(sp)
    80004a5c:	00813023          	sd	s0,0(sp)
    80004a60:	01010413          	addi	s0,sp,16
    80004a64:	00007797          	auipc	a5,0x7
    80004a68:	0d478793          	addi	a5,a5,212 # 8000bb38 <_ZTVN24ConsumerProducerAsyncCPP8ConsumerE+0x10>
    80004a6c:	00f53023          	sd	a5,0(a0)
    80004a70:	00002097          	auipc	ra,0x2
    80004a74:	0ec080e7          	jalr	236(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004a78:	00813083          	ld	ra,8(sp)
    80004a7c:	00013403          	ld	s0,0(sp)
    80004a80:	01010113          	addi	sp,sp,16
    80004a84:	00008067          	ret

0000000080004a88 <_ZN24ConsumerProducerAsyncCPP8ConsumerD0Ev>:
    80004a88:	fe010113          	addi	sp,sp,-32
    80004a8c:	00113c23          	sd	ra,24(sp)
    80004a90:	00813823          	sd	s0,16(sp)
    80004a94:	00913423          	sd	s1,8(sp)
    80004a98:	02010413          	addi	s0,sp,32
    80004a9c:	00050493          	mv	s1,a0
    80004aa0:	00007797          	auipc	a5,0x7
    80004aa4:	09878793          	addi	a5,a5,152 # 8000bb38 <_ZTVN24ConsumerProducerAsyncCPP8ConsumerE+0x10>
    80004aa8:	00f53023          	sd	a5,0(a0)
    80004aac:	00002097          	auipc	ra,0x2
    80004ab0:	0b0080e7          	jalr	176(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004ab4:	00048513          	mv	a0,s1
    80004ab8:	00002097          	auipc	ra,0x2
    80004abc:	014080e7          	jalr	20(ra) # 80006acc <_ZdlPv>
    80004ac0:	01813083          	ld	ra,24(sp)
    80004ac4:	01013403          	ld	s0,16(sp)
    80004ac8:	00813483          	ld	s1,8(sp)
    80004acc:	02010113          	addi	sp,sp,32
    80004ad0:	00008067          	ret

0000000080004ad4 <_ZN24ConsumerProducerAsyncCPP16ProducerKeyboradD1Ev>:
    class ProducerKeyborad : public Thread {
    80004ad4:	ff010113          	addi	sp,sp,-16
    80004ad8:	00113423          	sd	ra,8(sp)
    80004adc:	00813023          	sd	s0,0(sp)
    80004ae0:	01010413          	addi	s0,sp,16
    80004ae4:	00007797          	auipc	a5,0x7
    80004ae8:	00478793          	addi	a5,a5,4 # 8000bae8 <_ZTVN24ConsumerProducerAsyncCPP16ProducerKeyboradE+0x10>
    80004aec:	00f53023          	sd	a5,0(a0)
    80004af0:	00002097          	auipc	ra,0x2
    80004af4:	06c080e7          	jalr	108(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004af8:	00813083          	ld	ra,8(sp)
    80004afc:	00013403          	ld	s0,0(sp)
    80004b00:	01010113          	addi	sp,sp,16
    80004b04:	00008067          	ret

0000000080004b08 <_ZN24ConsumerProducerAsyncCPP16ProducerKeyboradD0Ev>:
    80004b08:	fe010113          	addi	sp,sp,-32
    80004b0c:	00113c23          	sd	ra,24(sp)
    80004b10:	00813823          	sd	s0,16(sp)
    80004b14:	00913423          	sd	s1,8(sp)
    80004b18:	02010413          	addi	s0,sp,32
    80004b1c:	00050493          	mv	s1,a0
    80004b20:	00007797          	auipc	a5,0x7
    80004b24:	fc878793          	addi	a5,a5,-56 # 8000bae8 <_ZTVN24ConsumerProducerAsyncCPP16ProducerKeyboradE+0x10>
    80004b28:	00f53023          	sd	a5,0(a0)
    80004b2c:	00002097          	auipc	ra,0x2
    80004b30:	030080e7          	jalr	48(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004b34:	00048513          	mv	a0,s1
    80004b38:	00002097          	auipc	ra,0x2
    80004b3c:	f94080e7          	jalr	-108(ra) # 80006acc <_ZdlPv>
    80004b40:	01813083          	ld	ra,24(sp)
    80004b44:	01013403          	ld	s0,16(sp)
    80004b48:	00813483          	ld	s1,8(sp)
    80004b4c:	02010113          	addi	sp,sp,32
    80004b50:	00008067          	ret

0000000080004b54 <_ZN24ConsumerProducerAsyncCPP8ProducerD1Ev>:
    class Producer : public Thread {
    80004b54:	ff010113          	addi	sp,sp,-16
    80004b58:	00113423          	sd	ra,8(sp)
    80004b5c:	00813023          	sd	s0,0(sp)
    80004b60:	01010413          	addi	s0,sp,16
    80004b64:	00007797          	auipc	a5,0x7
    80004b68:	fac78793          	addi	a5,a5,-84 # 8000bb10 <_ZTVN24ConsumerProducerAsyncCPP8ProducerE+0x10>
    80004b6c:	00f53023          	sd	a5,0(a0)
    80004b70:	00002097          	auipc	ra,0x2
    80004b74:	fec080e7          	jalr	-20(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004b78:	00813083          	ld	ra,8(sp)
    80004b7c:	00013403          	ld	s0,0(sp)
    80004b80:	01010113          	addi	sp,sp,16
    80004b84:	00008067          	ret

0000000080004b88 <_ZN24ConsumerProducerAsyncCPP8ProducerD0Ev>:
    80004b88:	fe010113          	addi	sp,sp,-32
    80004b8c:	00113c23          	sd	ra,24(sp)
    80004b90:	00813823          	sd	s0,16(sp)
    80004b94:	00913423          	sd	s1,8(sp)
    80004b98:	02010413          	addi	s0,sp,32
    80004b9c:	00050493          	mv	s1,a0
    80004ba0:	00007797          	auipc	a5,0x7
    80004ba4:	f7078793          	addi	a5,a5,-144 # 8000bb10 <_ZTVN24ConsumerProducerAsyncCPP8ProducerE+0x10>
    80004ba8:	00f53023          	sd	a5,0(a0)
    80004bac:	00002097          	auipc	ra,0x2
    80004bb0:	fb0080e7          	jalr	-80(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004bb4:	00048513          	mv	a0,s1
    80004bb8:	00002097          	auipc	ra,0x2
    80004bbc:	f14080e7          	jalr	-236(ra) # 80006acc <_ZdlPv>
    80004bc0:	01813083          	ld	ra,24(sp)
    80004bc4:	01013403          	ld	s0,16(sp)
    80004bc8:	00813483          	ld	s1,8(sp)
    80004bcc:	02010113          	addi	sp,sp,32
    80004bd0:	00008067          	ret

0000000080004bd4 <_ZN19PeriodicThreadsTest1AD1Ev>:
    class A : public PeriodicThread {
    80004bd4:	ff010113          	addi	sp,sp,-16
    80004bd8:	00113423          	sd	ra,8(sp)
    80004bdc:	00813023          	sd	s0,0(sp)
    80004be0:	01010413          	addi	s0,sp,16

private:
    sem_t myHandle;
};

class PeriodicThread : public Thread {
    80004be4:	00007797          	auipc	a5,0x7
    80004be8:	0947b783          	ld	a5,148(a5) # 8000bc78 <_GLOBAL_OFFSET_TABLE_+0x20>
    80004bec:	01078793          	addi	a5,a5,16
    80004bf0:	00f53023          	sd	a5,0(a0)
    80004bf4:	00002097          	auipc	ra,0x2
    80004bf8:	f68080e7          	jalr	-152(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004bfc:	00813083          	ld	ra,8(sp)
    80004c00:	00013403          	ld	s0,0(sp)
    80004c04:	01010113          	addi	sp,sp,16
    80004c08:	00008067          	ret

0000000080004c0c <_ZN19PeriodicThreadsTest1AD0Ev>:
    80004c0c:	fe010113          	addi	sp,sp,-32
    80004c10:	00113c23          	sd	ra,24(sp)
    80004c14:	00813823          	sd	s0,16(sp)
    80004c18:	00913423          	sd	s1,8(sp)
    80004c1c:	02010413          	addi	s0,sp,32
    80004c20:	00050493          	mv	s1,a0
    80004c24:	00007797          	auipc	a5,0x7
    80004c28:	0547b783          	ld	a5,84(a5) # 8000bc78 <_GLOBAL_OFFSET_TABLE_+0x20>
    80004c2c:	01078793          	addi	a5,a5,16
    80004c30:	00f53023          	sd	a5,0(a0)
    80004c34:	00002097          	auipc	ra,0x2
    80004c38:	f28080e7          	jalr	-216(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004c3c:	00048513          	mv	a0,s1
    80004c40:	00002097          	auipc	ra,0x2
    80004c44:	e8c080e7          	jalr	-372(ra) # 80006acc <_ZdlPv>
    80004c48:	01813083          	ld	ra,24(sp)
    80004c4c:	01013403          	ld	s0,16(sp)
    80004c50:	00813483          	ld	s1,8(sp)
    80004c54:	02010113          	addi	sp,sp,32
    80004c58:	00008067          	ret

0000000080004c5c <_ZN19PeriodicThreadsTest1BD1Ev>:
    class B : public PeriodicThread {
    80004c5c:	ff010113          	addi	sp,sp,-16
    80004c60:	00113423          	sd	ra,8(sp)
    80004c64:	00813023          	sd	s0,0(sp)
    80004c68:	01010413          	addi	s0,sp,16
    80004c6c:	00007797          	auipc	a5,0x7
    80004c70:	00c7b783          	ld	a5,12(a5) # 8000bc78 <_GLOBAL_OFFSET_TABLE_+0x20>
    80004c74:	01078793          	addi	a5,a5,16
    80004c78:	00f53023          	sd	a5,0(a0)
    80004c7c:	00002097          	auipc	ra,0x2
    80004c80:	ee0080e7          	jalr	-288(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004c84:	00813083          	ld	ra,8(sp)
    80004c88:	00013403          	ld	s0,0(sp)
    80004c8c:	01010113          	addi	sp,sp,16
    80004c90:	00008067          	ret

0000000080004c94 <_ZN19PeriodicThreadsTest1BD0Ev>:
    80004c94:	fe010113          	addi	sp,sp,-32
    80004c98:	00113c23          	sd	ra,24(sp)
    80004c9c:	00813823          	sd	s0,16(sp)
    80004ca0:	00913423          	sd	s1,8(sp)
    80004ca4:	02010413          	addi	s0,sp,32
    80004ca8:	00050493          	mv	s1,a0
    80004cac:	00007797          	auipc	a5,0x7
    80004cb0:	fcc7b783          	ld	a5,-52(a5) # 8000bc78 <_GLOBAL_OFFSET_TABLE_+0x20>
    80004cb4:	01078793          	addi	a5,a5,16
    80004cb8:	00f53023          	sd	a5,0(a0)
    80004cbc:	00002097          	auipc	ra,0x2
    80004cc0:	ea0080e7          	jalr	-352(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004cc4:	00048513          	mv	a0,s1
    80004cc8:	00002097          	auipc	ra,0x2
    80004ccc:	e04080e7          	jalr	-508(ra) # 80006acc <_ZdlPv>
    80004cd0:	01813083          	ld	ra,24(sp)
    80004cd4:	01013403          	ld	s0,16(sp)
    80004cd8:	00813483          	ld	s1,8(sp)
    80004cdc:	02010113          	addi	sp,sp,32
    80004ce0:	00008067          	ret

0000000080004ce4 <_ZN19PeriodicThreadsTest1CD1Ev>:
    class C : public PeriodicThread {
    80004ce4:	ff010113          	addi	sp,sp,-16
    80004ce8:	00113423          	sd	ra,8(sp)
    80004cec:	00813023          	sd	s0,0(sp)
    80004cf0:	01010413          	addi	s0,sp,16
    80004cf4:	00007797          	auipc	a5,0x7
    80004cf8:	f847b783          	ld	a5,-124(a5) # 8000bc78 <_GLOBAL_OFFSET_TABLE_+0x20>
    80004cfc:	01078793          	addi	a5,a5,16
    80004d00:	00f53023          	sd	a5,0(a0)
    80004d04:	00002097          	auipc	ra,0x2
    80004d08:	e58080e7          	jalr	-424(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004d0c:	00813083          	ld	ra,8(sp)
    80004d10:	00013403          	ld	s0,0(sp)
    80004d14:	01010113          	addi	sp,sp,16
    80004d18:	00008067          	ret

0000000080004d1c <_ZN19PeriodicThreadsTest1CD0Ev>:
    80004d1c:	fe010113          	addi	sp,sp,-32
    80004d20:	00113c23          	sd	ra,24(sp)
    80004d24:	00813823          	sd	s0,16(sp)
    80004d28:	00913423          	sd	s1,8(sp)
    80004d2c:	02010413          	addi	s0,sp,32
    80004d30:	00050493          	mv	s1,a0
    80004d34:	00007797          	auipc	a5,0x7
    80004d38:	f447b783          	ld	a5,-188(a5) # 8000bc78 <_GLOBAL_OFFSET_TABLE_+0x20>
    80004d3c:	01078793          	addi	a5,a5,16
    80004d40:	00f53023          	sd	a5,0(a0)
    80004d44:	00002097          	auipc	ra,0x2
    80004d48:	e18080e7          	jalr	-488(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80004d4c:	00048513          	mv	a0,s1
    80004d50:	00002097          	auipc	ra,0x2
    80004d54:	d7c080e7          	jalr	-644(ra) # 80006acc <_ZdlPv>
    80004d58:	01813083          	ld	ra,24(sp)
    80004d5c:	01013403          	ld	s0,16(sp)
    80004d60:	00813483          	ld	s1,8(sp)
    80004d64:	02010113          	addi	sp,sp,32
    80004d68:	00008067          	ret

0000000080004d6c <_ZN24ConsumerProducerAsyncCPP16ProducerKeyborad3runEv>:
        void run() override {
    80004d6c:	fe010113          	addi	sp,sp,-32
    80004d70:	00113c23          	sd	ra,24(sp)
    80004d74:	00813823          	sd	s0,16(sp)
    80004d78:	00913423          	sd	s1,8(sp)
    80004d7c:	02010413          	addi	s0,sp,32
    80004d80:	00050493          	mv	s1,a0
            while ((key = getc()) != 0x1b) {
    80004d84:	00002097          	auipc	ra,0x2
    80004d88:	a98080e7          	jalr	-1384(ra) # 8000681c <_Z4getcv>
    80004d8c:	0005059b          	sext.w	a1,a0
    80004d90:	01b00793          	li	a5,27
    80004d94:	00f58c63          	beq	a1,a5,80004dac <_ZN24ConsumerProducerAsyncCPP16ProducerKeyborad3runEv+0x40>
                td->buffer->put(key);
    80004d98:	0104b783          	ld	a5,16(s1)
    80004d9c:	0087b503          	ld	a0,8(a5)
    80004da0:	ffffc097          	auipc	ra,0xffffc
    80004da4:	604080e7          	jalr	1540(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
            while ((key = getc()) != 0x1b) {
    80004da8:	fddff06f          	j	80004d84 <_ZN24ConsumerProducerAsyncCPP16ProducerKeyborad3runEv+0x18>
            threadEnd = 1;
    80004dac:	00100793          	li	a5,1
    80004db0:	00007717          	auipc	a4,0x7
    80004db4:	f8f72423          	sw	a5,-120(a4) # 8000bd38 <_ZN24ConsumerProducerAsyncCPP9threadEndE>
            td->buffer->put('!');
    80004db8:	0104b783          	ld	a5,16(s1)
    80004dbc:	02100593          	li	a1,33
    80004dc0:	0087b503          	ld	a0,8(a5)
    80004dc4:	ffffc097          	auipc	ra,0xffffc
    80004dc8:	5e0080e7          	jalr	1504(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
            td->sem->signal();
    80004dcc:	0104b783          	ld	a5,16(s1)
    80004dd0:	0107b503          	ld	a0,16(a5)
    80004dd4:	00002097          	auipc	ra,0x2
    80004dd8:	fa4080e7          	jalr	-92(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80004ddc:	01813083          	ld	ra,24(sp)
    80004de0:	01013403          	ld	s0,16(sp)
    80004de4:	00813483          	ld	s1,8(sp)
    80004de8:	02010113          	addi	sp,sp,32
    80004dec:	00008067          	ret

0000000080004df0 <_ZN24ConsumerProducerAsyncCPP8Consumer3runEv>:
        void run() override {
    80004df0:	fd010113          	addi	sp,sp,-48
    80004df4:	02113423          	sd	ra,40(sp)
    80004df8:	02813023          	sd	s0,32(sp)
    80004dfc:	00913c23          	sd	s1,24(sp)
    80004e00:	01213823          	sd	s2,16(sp)
    80004e04:	01313423          	sd	s3,8(sp)
    80004e08:	03010413          	addi	s0,sp,48
    80004e0c:	00050913          	mv	s2,a0
            int i = 0;
    80004e10:	00000993          	li	s3,0
    80004e14:	0100006f          	j	80004e24 <_ZN24ConsumerProducerAsyncCPP8Consumer3runEv+0x34>
                    Console::putc('\n');
    80004e18:	00a00513          	li	a0,10
    80004e1c:	00002097          	auipc	ra,0x2
    80004e20:	024080e7          	jalr	36(ra) # 80006e40 <_ZN7Console4putcEc>
            while (!threadEnd) {
    80004e24:	00007797          	auipc	a5,0x7
    80004e28:	f147a783          	lw	a5,-236(a5) # 8000bd38 <_ZN24ConsumerProducerAsyncCPP9threadEndE>
    80004e2c:	04079a63          	bnez	a5,80004e80 <_ZN24ConsumerProducerAsyncCPP8Consumer3runEv+0x90>
                int key = td->buffer->get();
    80004e30:	01093783          	ld	a5,16(s2)
    80004e34:	0087b503          	ld	a0,8(a5)
    80004e38:	ffffc097          	auipc	ra,0xffffc
    80004e3c:	5fc080e7          	jalr	1532(ra) # 80001434 <_ZN13BufferTestCPP9BufferCPP3getEv>
                i++;
    80004e40:	0019849b          	addiw	s1,s3,1
    80004e44:	0004899b          	sext.w	s3,s1
                Console::putc(key);
    80004e48:	0ff57513          	andi	a0,a0,255
    80004e4c:	00002097          	auipc	ra,0x2
    80004e50:	ff4080e7          	jalr	-12(ra) # 80006e40 <_ZN7Console4putcEc>
                if (i % 80 == 0) {
    80004e54:	05000793          	li	a5,80
    80004e58:	02f4e4bb          	remw	s1,s1,a5
    80004e5c:	fc0494e3          	bnez	s1,80004e24 <_ZN24ConsumerProducerAsyncCPP8Consumer3runEv+0x34>
    80004e60:	fb9ff06f          	j	80004e18 <_ZN24ConsumerProducerAsyncCPP8Consumer3runEv+0x28>
                int key = td->buffer->get();
    80004e64:	01093783          	ld	a5,16(s2)
    80004e68:	0087b503          	ld	a0,8(a5)
    80004e6c:	ffffc097          	auipc	ra,0xffffc
    80004e70:	5c8080e7          	jalr	1480(ra) # 80001434 <_ZN13BufferTestCPP9BufferCPP3getEv>
                Console::putc(key);
    80004e74:	0ff57513          	andi	a0,a0,255
    80004e78:	00002097          	auipc	ra,0x2
    80004e7c:	fc8080e7          	jalr	-56(ra) # 80006e40 <_ZN7Console4putcEc>
            while (td->buffer->getCnt() > 0) {
    80004e80:	01093783          	ld	a5,16(s2)
    80004e84:	0087b503          	ld	a0,8(a5)
    80004e88:	ffffc097          	auipc	ra,0xffffc
    80004e8c:	638080e7          	jalr	1592(ra) # 800014c0 <_ZN13BufferTestCPP9BufferCPP6getCntEv>
    80004e90:	fca04ae3          	bgtz	a0,80004e64 <_ZN24ConsumerProducerAsyncCPP8Consumer3runEv+0x74>
            td->sem->signal();
    80004e94:	01093783          	ld	a5,16(s2)
    80004e98:	0107b503          	ld	a0,16(a5)
    80004e9c:	00002097          	auipc	ra,0x2
    80004ea0:	edc080e7          	jalr	-292(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80004ea4:	02813083          	ld	ra,40(sp)
    80004ea8:	02013403          	ld	s0,32(sp)
    80004eac:	01813483          	ld	s1,24(sp)
    80004eb0:	01013903          	ld	s2,16(sp)
    80004eb4:	00813983          	ld	s3,8(sp)
    80004eb8:	03010113          	addi	sp,sp,48
    80004ebc:	00008067          	ret

0000000080004ec0 <_ZN19PeriodicThreadsTest1A18periodicActivationEv>:
        void periodicActivation() override {
    80004ec0:	fe010113          	addi	sp,sp,-32
    80004ec4:	00113c23          	sd	ra,24(sp)
    80004ec8:	00813823          	sd	s0,16(sp)
    80004ecc:	00913423          	sd	s1,8(sp)
    80004ed0:	02010413          	addi	s0,sp,32
            myOwnMutex->wait();
    80004ed4:	00007497          	auipc	s1,0x7
    80004ed8:	e5c48493          	addi	s1,s1,-420 # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    80004edc:	0104b503          	ld	a0,16(s1)
    80004ee0:	00002097          	auipc	ra,0x2
    80004ee4:	e6c080e7          	jalr	-404(ra) # 80006d4c <_ZN9Semaphore4waitEv>
            putc('A');
    80004ee8:	04100513          	li	a0,65
    80004eec:	00002097          	auipc	ra,0x2
    80004ef0:	988080e7          	jalr	-1656(ra) # 80006874 <_Z4putcc>
            putc('\n');
    80004ef4:	00a00513          	li	a0,10
    80004ef8:	00002097          	auipc	ra,0x2
    80004efc:	97c080e7          	jalr	-1668(ra) # 80006874 <_Z4putcc>
            myOwnMutex->signal();
    80004f00:	0104b503          	ld	a0,16(s1)
    80004f04:	00002097          	auipc	ra,0x2
    80004f08:	e74080e7          	jalr	-396(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80004f0c:	01813083          	ld	ra,24(sp)
    80004f10:	01013403          	ld	s0,16(sp)
    80004f14:	00813483          	ld	s1,8(sp)
    80004f18:	02010113          	addi	sp,sp,32
    80004f1c:	00008067          	ret

0000000080004f20 <_ZN19PeriodicThreadsTest1B18periodicActivationEv>:
        void periodicActivation() override {
    80004f20:	fe010113          	addi	sp,sp,-32
    80004f24:	00113c23          	sd	ra,24(sp)
    80004f28:	00813823          	sd	s0,16(sp)
    80004f2c:	00913423          	sd	s1,8(sp)
    80004f30:	02010413          	addi	s0,sp,32
            myOwnMutex->wait();
    80004f34:	00007497          	auipc	s1,0x7
    80004f38:	dfc48493          	addi	s1,s1,-516 # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    80004f3c:	0104b503          	ld	a0,16(s1)
    80004f40:	00002097          	auipc	ra,0x2
    80004f44:	e0c080e7          	jalr	-500(ra) # 80006d4c <_ZN9Semaphore4waitEv>
            putc('B');
    80004f48:	04200513          	li	a0,66
    80004f4c:	00002097          	auipc	ra,0x2
    80004f50:	928080e7          	jalr	-1752(ra) # 80006874 <_Z4putcc>
            putc('\n');
    80004f54:	00a00513          	li	a0,10
    80004f58:	00002097          	auipc	ra,0x2
    80004f5c:	91c080e7          	jalr	-1764(ra) # 80006874 <_Z4putcc>
            myOwnMutex->signal();
    80004f60:	0104b503          	ld	a0,16(s1)
    80004f64:	00002097          	auipc	ra,0x2
    80004f68:	e14080e7          	jalr	-492(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80004f6c:	01813083          	ld	ra,24(sp)
    80004f70:	01013403          	ld	s0,16(sp)
    80004f74:	00813483          	ld	s1,8(sp)
    80004f78:	02010113          	addi	sp,sp,32
    80004f7c:	00008067          	ret

0000000080004f80 <_ZN19PeriodicThreadsTest1C18periodicActivationEv>:
        void periodicActivation() override {
    80004f80:	fe010113          	addi	sp,sp,-32
    80004f84:	00113c23          	sd	ra,24(sp)
    80004f88:	00813823          	sd	s0,16(sp)
    80004f8c:	00913423          	sd	s1,8(sp)
    80004f90:	02010413          	addi	s0,sp,32
            myOwnMutex->wait();
    80004f94:	00007497          	auipc	s1,0x7
    80004f98:	d9c48493          	addi	s1,s1,-612 # 8000bd30 <_ZN12ThreadsTestC9finishedAE>
    80004f9c:	0104b503          	ld	a0,16(s1)
    80004fa0:	00002097          	auipc	ra,0x2
    80004fa4:	dac080e7          	jalr	-596(ra) # 80006d4c <_ZN9Semaphore4waitEv>
            putc('C');
    80004fa8:	04300513          	li	a0,67
    80004fac:	00002097          	auipc	ra,0x2
    80004fb0:	8c8080e7          	jalr	-1848(ra) # 80006874 <_Z4putcc>
            putc('\n');
    80004fb4:	00a00513          	li	a0,10
    80004fb8:	00002097          	auipc	ra,0x2
    80004fbc:	8bc080e7          	jalr	-1860(ra) # 80006874 <_Z4putcc>
            myOwnMutex->signal();
    80004fc0:	0104b503          	ld	a0,16(s1)
    80004fc4:	00002097          	auipc	ra,0x2
    80004fc8:	db4080e7          	jalr	-588(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80004fcc:	01813083          	ld	ra,24(sp)
    80004fd0:	01013403          	ld	s0,16(sp)
    80004fd4:	00813483          	ld	s1,8(sp)
    80004fd8:	02010113          	addi	sp,sp,32
    80004fdc:	00008067          	ret

0000000080004fe0 <_ZN19PeriodicThreadsTest1A3runEv>:
        void run() override {
    80004fe0:	fe010113          	addi	sp,sp,-32
    80004fe4:	00113c23          	sd	ra,24(sp)
    80004fe8:	00813823          	sd	s0,16(sp)
    80004fec:	00913423          	sd	s1,8(sp)
    80004ff0:	02010413          	addi	s0,sp,32
    80004ff4:	00050493          	mv	s1,a0
            while (!shouldThisThreadEnd) {
    80004ff8:	0184c783          	lbu	a5,24(s1)
    80004ffc:	02079263          	bnez	a5,80005020 <_ZN19PeriodicThreadsTest1A3runEv+0x40>
                periodicActivation();
    80005000:	0004b783          	ld	a5,0(s1)
    80005004:	0187b783          	ld	a5,24(a5)
    80005008:	00048513          	mv	a0,s1
    8000500c:	000780e7          	jalr	a5
                time_sleep(sleepTime);
    80005010:	0104b503          	ld	a0,16(s1)
    80005014:	00001097          	auipc	ra,0x1
    80005018:	7a4080e7          	jalr	1956(ra) # 800067b8 <_Z10time_sleepm>
            while (!shouldThisThreadEnd) {
    8000501c:	fddff06f          	j	80004ff8 <_ZN19PeriodicThreadsTest1A3runEv+0x18>
            myOwnWaitForAll->signal();
    80005020:	00007517          	auipc	a0,0x7
    80005024:	d3053503          	ld	a0,-720(a0) # 8000bd50 <_ZN19PeriodicThreadsTest15myOwnWaitForAllE>
    80005028:	00002097          	auipc	ra,0x2
    8000502c:	d50080e7          	jalr	-688(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80005030:	01813083          	ld	ra,24(sp)
    80005034:	01013403          	ld	s0,16(sp)
    80005038:	00813483          	ld	s1,8(sp)
    8000503c:	02010113          	addi	sp,sp,32
    80005040:	00008067          	ret

0000000080005044 <_ZN19PeriodicThreadsTest1B3runEv>:
        void run() override {
    80005044:	fe010113          	addi	sp,sp,-32
    80005048:	00113c23          	sd	ra,24(sp)
    8000504c:	00813823          	sd	s0,16(sp)
    80005050:	00913423          	sd	s1,8(sp)
    80005054:	02010413          	addi	s0,sp,32
    80005058:	00050493          	mv	s1,a0
            while (!shouldThisThreadEnd) {
    8000505c:	0184c783          	lbu	a5,24(s1)
    80005060:	02079263          	bnez	a5,80005084 <_ZN19PeriodicThreadsTest1B3runEv+0x40>
                periodicActivation();
    80005064:	0004b783          	ld	a5,0(s1)
    80005068:	0187b783          	ld	a5,24(a5)
    8000506c:	00048513          	mv	a0,s1
    80005070:	000780e7          	jalr	a5
                time_sleep(sleepTime);
    80005074:	0104b503          	ld	a0,16(s1)
    80005078:	00001097          	auipc	ra,0x1
    8000507c:	740080e7          	jalr	1856(ra) # 800067b8 <_Z10time_sleepm>
            while (!shouldThisThreadEnd) {
    80005080:	fddff06f          	j	8000505c <_ZN19PeriodicThreadsTest1B3runEv+0x18>
            myOwnWaitForAll->signal();
    80005084:	00007517          	auipc	a0,0x7
    80005088:	ccc53503          	ld	a0,-820(a0) # 8000bd50 <_ZN19PeriodicThreadsTest15myOwnWaitForAllE>
    8000508c:	00002097          	auipc	ra,0x2
    80005090:	cec080e7          	jalr	-788(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80005094:	01813083          	ld	ra,24(sp)
    80005098:	01013403          	ld	s0,16(sp)
    8000509c:	00813483          	ld	s1,8(sp)
    800050a0:	02010113          	addi	sp,sp,32
    800050a4:	00008067          	ret

00000000800050a8 <_ZN19PeriodicThreadsTest1C3runEv>:
        void run() override {
    800050a8:	fe010113          	addi	sp,sp,-32
    800050ac:	00113c23          	sd	ra,24(sp)
    800050b0:	00813823          	sd	s0,16(sp)
    800050b4:	00913423          	sd	s1,8(sp)
    800050b8:	02010413          	addi	s0,sp,32
    800050bc:	00050493          	mv	s1,a0
            while (!shouldThisThreadEnd) {
    800050c0:	0184c783          	lbu	a5,24(s1)
    800050c4:	02079263          	bnez	a5,800050e8 <_ZN19PeriodicThreadsTest1C3runEv+0x40>
                periodicActivation();
    800050c8:	0004b783          	ld	a5,0(s1)
    800050cc:	0187b783          	ld	a5,24(a5)
    800050d0:	00048513          	mv	a0,s1
    800050d4:	000780e7          	jalr	a5
                time_sleep(sleepTime);
    800050d8:	0104b503          	ld	a0,16(s1)
    800050dc:	00001097          	auipc	ra,0x1
    800050e0:	6dc080e7          	jalr	1756(ra) # 800067b8 <_Z10time_sleepm>
            while (!shouldThisThreadEnd) {
    800050e4:	fddff06f          	j	800050c0 <_ZN19PeriodicThreadsTest1C3runEv+0x18>
            myOwnWaitForAll->signal();
    800050e8:	00007517          	auipc	a0,0x7
    800050ec:	c6853503          	ld	a0,-920(a0) # 8000bd50 <_ZN19PeriodicThreadsTest15myOwnWaitForAllE>
    800050f0:	00002097          	auipc	ra,0x2
    800050f4:	c88080e7          	jalr	-888(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    800050f8:	01813083          	ld	ra,24(sp)
    800050fc:	01013403          	ld	s0,16(sp)
    80005100:	00813483          	ld	s1,8(sp)
    80005104:	02010113          	addi	sp,sp,32
    80005108:	00008067          	ret

000000008000510c <_ZN24ConsumerProducerAsyncCPP8Producer3runEv>:
        void run() override {
    8000510c:	fe010113          	addi	sp,sp,-32
    80005110:	00113c23          	sd	ra,24(sp)
    80005114:	00813823          	sd	s0,16(sp)
    80005118:	00913423          	sd	s1,8(sp)
    8000511c:	01213023          	sd	s2,0(sp)
    80005120:	02010413          	addi	s0,sp,32
    80005124:	00050493          	mv	s1,a0
            int i = 0;
    80005128:	00000913          	li	s2,0
            while (!threadEnd) {
    8000512c:	00007797          	auipc	a5,0x7
    80005130:	c0c7a783          	lw	a5,-1012(a5) # 8000bd38 <_ZN24ConsumerProducerAsyncCPP9threadEndE>
    80005134:	04079263          	bnez	a5,80005178 <_ZN24ConsumerProducerAsyncCPP8Producer3runEv+0x6c>
                td->buffer->put(td->id + '0');
    80005138:	0104b783          	ld	a5,16(s1)
    8000513c:	0007a583          	lw	a1,0(a5)
    80005140:	0305859b          	addiw	a1,a1,48
    80005144:	0087b503          	ld	a0,8(a5)
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	25c080e7          	jalr	604(ra) # 800013a4 <_ZN13BufferTestCPP9BufferCPP3putEi>
                i++;
    80005150:	0019071b          	addiw	a4,s2,1
    80005154:	0007091b          	sext.w	s2,a4
                Thread::sleep((i+td->id)%5);
    80005158:	0104b783          	ld	a5,16(s1)
    8000515c:	0007a783          	lw	a5,0(a5)
    80005160:	00e787bb          	addw	a5,a5,a4
    80005164:	00500513          	li	a0,5
    80005168:	02a7e53b          	remw	a0,a5,a0
    8000516c:	00002097          	auipc	ra,0x2
    80005170:	b14080e7          	jalr	-1260(ra) # 80006c80 <_ZN6Thread5sleepEm>
            while (!threadEnd) {
    80005174:	fb9ff06f          	j	8000512c <_ZN24ConsumerProducerAsyncCPP8Producer3runEv+0x20>
            td->sem->signal();
    80005178:	0104b783          	ld	a5,16(s1)
    8000517c:	0107b503          	ld	a0,16(a5)
    80005180:	00002097          	auipc	ra,0x2
    80005184:	bf8080e7          	jalr	-1032(ra) # 80006d78 <_ZN9Semaphore6signalEv>
        }
    80005188:	01813083          	ld	ra,24(sp)
    8000518c:	01013403          	ld	s0,16(sp)
    80005190:	00813483          	ld	s1,8(sp)
    80005194:	00013903          	ld	s2,0(sp)
    80005198:	02010113          	addi	sp,sp,32
    8000519c:	00008067          	ret

00000000800051a0 <_ZN14ThreadsTestCPP7WorkerA3runEv>:
        void run() override {
    800051a0:	ff010113          	addi	sp,sp,-16
    800051a4:	00113423          	sd	ra,8(sp)
    800051a8:	00813023          	sd	s0,0(sp)
    800051ac:	01010413          	addi	s0,sp,16
            workerBodyA(nullptr);
    800051b0:	00000593          	li	a1,0
    800051b4:	ffffe097          	auipc	ra,0xffffe
    800051b8:	d4c080e7          	jalr	-692(ra) # 80002f00 <_ZN14ThreadsTestCPP7WorkerA11workerBodyAEPv>
        }
    800051bc:	00813083          	ld	ra,8(sp)
    800051c0:	00013403          	ld	s0,0(sp)
    800051c4:	01010113          	addi	sp,sp,16
    800051c8:	00008067          	ret

00000000800051cc <_ZN14ThreadsTestCPP7WorkerB3runEv>:
        void run() override {
    800051cc:	ff010113          	addi	sp,sp,-16
    800051d0:	00113423          	sd	ra,8(sp)
    800051d4:	00813023          	sd	s0,0(sp)
    800051d8:	01010413          	addi	s0,sp,16
            workerBodyB(nullptr);
    800051dc:	00000593          	li	a1,0
    800051e0:	ffffe097          	auipc	ra,0xffffe
    800051e4:	dec080e7          	jalr	-532(ra) # 80002fcc <_ZN14ThreadsTestCPP7WorkerB11workerBodyBEPv>
        }
    800051e8:	00813083          	ld	ra,8(sp)
    800051ec:	00013403          	ld	s0,0(sp)
    800051f0:	01010113          	addi	sp,sp,16
    800051f4:	00008067          	ret

00000000800051f8 <_ZN14ThreadsTestCPP7WorkerC3runEv>:
        void run() override {
    800051f8:	ff010113          	addi	sp,sp,-16
    800051fc:	00113423          	sd	ra,8(sp)
    80005200:	00813023          	sd	s0,0(sp)
    80005204:	01010413          	addi	s0,sp,16
            workerBodyC(nullptr);
    80005208:	00000593          	li	a1,0
    8000520c:	ffffe097          	auipc	ra,0xffffe
    80005210:	e94080e7          	jalr	-364(ra) # 800030a0 <_ZN14ThreadsTestCPP7WorkerC11workerBodyCEPv>
        }
    80005214:	00813083          	ld	ra,8(sp)
    80005218:	00013403          	ld	s0,0(sp)
    8000521c:	01010113          	addi	sp,sp,16
    80005220:	00008067          	ret

0000000080005224 <_ZN14ThreadsTestCPP7WorkerD3runEv>:
        void run() override {
    80005224:	ff010113          	addi	sp,sp,-16
    80005228:	00113423          	sd	ra,8(sp)
    8000522c:	00813023          	sd	s0,0(sp)
    80005230:	01010413          	addi	s0,sp,16
            workerBodyD(nullptr);
    80005234:	00000593          	li	a1,0
    80005238:	ffffe097          	auipc	ra,0xffffe
    8000523c:	fe8080e7          	jalr	-24(ra) # 80003220 <_ZN14ThreadsTestCPP7WorkerD11workerBodyDEPv>
        }
    80005240:	00813083          	ld	ra,8(sp)
    80005244:	00013403          	ld	s0,0(sp)
    80005248:	01010113          	addi	sp,sp,16
    8000524c:	00008067          	ret

0000000080005250 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard3runEv>:
        void run() override {
    80005250:	ff010113          	addi	sp,sp,-16
    80005254:	00113423          	sd	ra,8(sp)
    80005258:	00813023          	sd	s0,0(sp)
    8000525c:	01010413          	addi	s0,sp,16
            producerKeyboard(td);
    80005260:	01053583          	ld	a1,16(a0)
    80005264:	ffffe097          	auipc	ra,0xffffe
    80005268:	5e4080e7          	jalr	1508(ra) # 80003848 <_ZN23ConsumerProducerSyncCPP16ProducerKeyboard16producerKeyboardEPv>
        }
    8000526c:	00813083          	ld	ra,8(sp)
    80005270:	00013403          	ld	s0,0(sp)
    80005274:	01010113          	addi	sp,sp,16
    80005278:	00008067          	ret

000000008000527c <_ZN23ConsumerProducerSyncCPP8Producer3runEv>:
        void run() override {
    8000527c:	ff010113          	addi	sp,sp,-16
    80005280:	00113423          	sd	ra,8(sp)
    80005284:	00813023          	sd	s0,0(sp)
    80005288:	01010413          	addi	s0,sp,16
            producer(td);
    8000528c:	01053583          	ld	a1,16(a0)
    80005290:	ffffe097          	auipc	ra,0xffffe
    80005294:	678080e7          	jalr	1656(ra) # 80003908 <_ZN23ConsumerProducerSyncCPP8Producer8producerEPv>
        }
    80005298:	00813083          	ld	ra,8(sp)
    8000529c:	00013403          	ld	s0,0(sp)
    800052a0:	01010113          	addi	sp,sp,16
    800052a4:	00008067          	ret

00000000800052a8 <_ZN23ConsumerProducerSyncCPP8Consumer3runEv>:
        void run() override {
    800052a8:	ff010113          	addi	sp,sp,-16
    800052ac:	00113423          	sd	ra,8(sp)
    800052b0:	00813023          	sd	s0,0(sp)
    800052b4:	01010413          	addi	s0,sp,16
            consumer(td);
    800052b8:	01053583          	ld	a1,16(a0)
    800052bc:	ffffe097          	auipc	ra,0xffffe
    800052c0:	6e0080e7          	jalr	1760(ra) # 8000399c <_ZN23ConsumerProducerSyncCPP8Consumer8consumerEPv>
        }
    800052c4:	00813083          	ld	ra,8(sp)
    800052c8:	00013403          	ld	s0,0(sp)
    800052cc:	01010113          	addi	sp,sp,16
    800052d0:	00008067          	ret

00000000800052d4 <_Z17printErrorMessagemmm>:
#include "../../../h/Code/Printing/print.hpp"
#include "../../../h/Code/InterruptHandling/Riscv.hpp"
#include "../../../h/Testing/Testing_OS1/Printing.hpp"

void printErrorMessage(uint64 scause, uint64 stval, uint64 sepc) {
    800052d4:	fc010113          	addi	sp,sp,-64
    800052d8:	02113c23          	sd	ra,56(sp)
    800052dc:	02813823          	sd	s0,48(sp)
    800052e0:	02913423          	sd	s1,40(sp)
    800052e4:	03213023          	sd	s2,32(sp)
    800052e8:	01313c23          	sd	s3,24(sp)
    800052ec:	01413823          	sd	s4,16(sp)
    800052f0:	04010413          	addi	s0,sp,64
    800052f4:	00050493          	mv	s1,a0
    800052f8:	00058913          	mv	s2,a1
    800052fc:	00060993          	mv	s3,a2
// poziva funkcije
inline uint64 Riscv::readSstatus() {
    // volatile kvalifikator obezbedjuje da prevodilac ne izvrsi optimizaciju i sacuva lokalnu promenljivu u nekom od opstenamenskih
    // registara - umesto toga, sacuvace je na steku
    uint64 volatile sstatus;
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80005300:	100027f3          	csrr	a5,sstatus
    80005304:	fcf43423          	sd	a5,-56(s0)
    return sstatus;
    80005308:	fc843a03          	ld	s4,-56(s0)
inline void Riscv::maskSetBitsSstatus(uint64 mask) {
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}

inline void Riscv::maskClearBitsSstatus(uint64 mask) {
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    8000530c:	00200793          	li	a5,2
    80005310:	1007b073          	csrc	sstatus,a5
    uint64 sstatus = Riscv::readSstatus();
    Riscv::maskClearBitsSstatus(Riscv::SSTATUS_SIE); // zabrana spoljasnjih prekida (softverskih prekida od tajmera i spoljasnjih hardverskih prekida)
    printString("unutrasnji prekid ");
    80005314:	00004517          	auipc	a0,0x4
    80005318:	f5c50513          	addi	a0,a0,-164 # 80009270 <CONSOLE_STATUS+0x260>
    8000531c:	ffffc097          	auipc	ra,0xffffc
    80005320:	32c080e7          	jalr	812(ra) # 80001648 <_Z11printStringPKc>
    switch (scause) {
    80005324:	00500793          	li	a5,5
    80005328:	0cf48463          	beq	s1,a5,800053f0 <_Z17printErrorMessagemmm+0x11c>
    8000532c:	00700793          	li	a5,7
    80005330:	0cf48a63          	beq	s1,a5,80005404 <_Z17printErrorMessagemmm+0x130>
    80005334:	00200793          	li	a5,2
    80005338:	0af48263          	beq	s1,a5,800053dc <_Z17printErrorMessagemmm+0x108>
            break;
        case 0x0000000000000007UL:
            printString("(nedozvoljena adresa upisa)\n");
            break;
    }
    printString("scause (opis prekida): "); printInt(scause);
    8000533c:	00004517          	auipc	a0,0x4
    80005340:	fa450513          	addi	a0,a0,-92 # 800092e0 <CONSOLE_STATUS+0x2d0>
    80005344:	ffffc097          	auipc	ra,0xffffc
    80005348:	304080e7          	jalr	772(ra) # 80001648 <_Z11printStringPKc>
    8000534c:	00000613          	li	a2,0
    80005350:	00a00593          	li	a1,10
    80005354:	0004851b          	sext.w	a0,s1
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	488080e7          	jalr	1160(ra) # 800017e0 <_Z8printIntiii>
    printString("; sepc (adresa prekinute instrukcije): "); printInt(sepc);
    80005360:	00004517          	auipc	a0,0x4
    80005364:	f9850513          	addi	a0,a0,-104 # 800092f8 <CONSOLE_STATUS+0x2e8>
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	2e0080e7          	jalr	736(ra) # 80001648 <_Z11printStringPKc>
    80005370:	00000613          	li	a2,0
    80005374:	00a00593          	li	a1,10
    80005378:	0009851b          	sext.w	a0,s3
    8000537c:	ffffc097          	auipc	ra,0xffffc
    80005380:	464080e7          	jalr	1124(ra) # 800017e0 <_Z8printIntiii>
    printString("; stval (dodatan opis izuzetka): "); printInt(stval);
    80005384:	00004517          	auipc	a0,0x4
    80005388:	f9c50513          	addi	a0,a0,-100 # 80009320 <CONSOLE_STATUS+0x310>
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	2bc080e7          	jalr	700(ra) # 80001648 <_Z11printStringPKc>
    80005394:	00000613          	li	a2,0
    80005398:	00a00593          	li	a1,10
    8000539c:	0009051b          	sext.w	a0,s2
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	440080e7          	jalr	1088(ra) # 800017e0 <_Z8printIntiii>
    printString("\n\n");
    800053a8:	00004517          	auipc	a0,0x4
    800053ac:	fa050513          	addi	a0,a0,-96 # 80009348 <CONSOLE_STATUS+0x338>
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	298080e7          	jalr	664(ra) # 80001648 <_Z11printStringPKc>
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    800053b8:	100a1073          	csrw	sstatus,s4
    Riscv::writeSstatus(sstatus); // restauracija inicijalnog sstatus registra
    800053bc:	03813083          	ld	ra,56(sp)
    800053c0:	03013403          	ld	s0,48(sp)
    800053c4:	02813483          	ld	s1,40(sp)
    800053c8:	02013903          	ld	s2,32(sp)
    800053cc:	01813983          	ld	s3,24(sp)
    800053d0:	01013a03          	ld	s4,16(sp)
    800053d4:	04010113          	addi	sp,sp,64
    800053d8:	00008067          	ret
            printString("(ilegalna instrukcija)\n");
    800053dc:	00004517          	auipc	a0,0x4
    800053e0:	eac50513          	addi	a0,a0,-340 # 80009288 <CONSOLE_STATUS+0x278>
    800053e4:	ffffc097          	auipc	ra,0xffffc
    800053e8:	264080e7          	jalr	612(ra) # 80001648 <_Z11printStringPKc>
            break;
    800053ec:	f51ff06f          	j	8000533c <_Z17printErrorMessagemmm+0x68>
            printString("(nedozvoljena adresa citanja)\n");
    800053f0:	00004517          	auipc	a0,0x4
    800053f4:	eb050513          	addi	a0,a0,-336 # 800092a0 <CONSOLE_STATUS+0x290>
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	250080e7          	jalr	592(ra) # 80001648 <_Z11printStringPKc>
            break;
    80005400:	f3dff06f          	j	8000533c <_Z17printErrorMessagemmm+0x68>
            printString("(nedozvoljena adresa upisa)\n");
    80005404:	00004517          	auipc	a0,0x4
    80005408:	ebc50513          	addi	a0,a0,-324 # 800092c0 <CONSOLE_STATUS+0x2b0>
    8000540c:	ffffc097          	auipc	ra,0xffffc
    80005410:	23c080e7          	jalr	572(ra) # 80001648 <_Z11printStringPKc>
            break;
    80005414:	f29ff06f          	j	8000533c <_Z17printErrorMessagemmm+0x68>

0000000080005418 <_ZN15KernelSemaphorenwEm>:
    if (++semaphoreValue <= 0) {
        unblockFirstThreadInList();
    }
}

void* KernelSemaphore::operator new(size_t n) {
    80005418:	fe010113          	addi	sp,sp,-32
    8000541c:	00113c23          	sd	ra,24(sp)
    80005420:	00813823          	sd	s0,16(sp)
    80005424:	00913423          	sd	s1,8(sp)
    80005428:	02010413          	addi	s0,sp,32
    8000542c:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80005430:	ffffd097          	auipc	ra,0xffffd
    80005434:	868080e7          	jalr	-1944(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005438:	00048593          	mv	a1,s1
    8000543c:	ffffd097          	auipc	ra,0xffffd
    80005440:	8b8080e7          	jalr	-1864(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    80005444:	01813083          	ld	ra,24(sp)
    80005448:	01013403          	ld	s0,16(sp)
    8000544c:	00813483          	ld	s1,8(sp)
    80005450:	02010113          	addi	sp,sp,32
    80005454:	00008067          	ret

0000000080005458 <_ZN15KernelSemaphore15createSemaphoreEt>:
KernelSemaphore* KernelSemaphore::createSemaphore(unsigned short initialSemaphoreValue) {
    80005458:	fe010113          	addi	sp,sp,-32
    8000545c:	00113c23          	sd	ra,24(sp)
    80005460:	00813823          	sd	s0,16(sp)
    80005464:	00913423          	sd	s1,8(sp)
    80005468:	02010413          	addi	s0,sp,32
    8000546c:	00050493          	mv	s1,a0
    return new KernelSemaphore(initialSemaphoreValue);
    80005470:	01800513          	li	a0,24
    80005474:	00000097          	auipc	ra,0x0
    80005478:	fa4080e7          	jalr	-92(ra) # 80005418 <_ZN15KernelSemaphorenwEm>
protected:
    void blockCurrentThread();
    TCB* unblockFirstThreadInList();

private:
    explicit KernelSemaphore(unsigned short initialSemaphoreValue = 1) : semaphoreValue(initialSemaphoreValue) {}
    8000547c:	00952023          	sw	s1,0(a0)
    80005480:	00053423          	sd	zero,8(a0)
    80005484:	00053823          	sd	zero,16(a0)
}
    80005488:	01813083          	ld	ra,24(sp)
    8000548c:	01013403          	ld	s0,16(sp)
    80005490:	00813483          	ld	s1,8(sp)
    80005494:	02010113          	addi	sp,sp,32
    80005498:	00008067          	ret

000000008000549c <_ZN15KernelSemaphorenaEm>:

void* KernelSemaphore::operator new[](size_t n) {
    8000549c:	fe010113          	addi	sp,sp,-32
    800054a0:	00113c23          	sd	ra,24(sp)
    800054a4:	00813823          	sd	s0,16(sp)
    800054a8:	00913423          	sd	s1,8(sp)
    800054ac:	02010413          	addi	s0,sp,32
    800054b0:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    800054b4:	ffffc097          	auipc	ra,0xffffc
    800054b8:	7e4080e7          	jalr	2020(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    800054bc:	00048593          	mv	a1,s1
    800054c0:	ffffd097          	auipc	ra,0xffffd
    800054c4:	834080e7          	jalr	-1996(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    800054c8:	01813083          	ld	ra,24(sp)
    800054cc:	01013403          	ld	s0,16(sp)
    800054d0:	00813483          	ld	s1,8(sp)
    800054d4:	02010113          	addi	sp,sp,32
    800054d8:	00008067          	ret

00000000800054dc <_ZN15KernelSemaphoredlEPv>:

void KernelSemaphore::operator delete(void *ptr) {
    800054dc:	fe010113          	addi	sp,sp,-32
    800054e0:	00113c23          	sd	ra,24(sp)
    800054e4:	00813823          	sd	s0,16(sp)
    800054e8:	00913423          	sd	s1,8(sp)
    800054ec:	02010413          	addi	s0,sp,32
    800054f0:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    800054f4:	ffffc097          	auipc	ra,0xffffc
    800054f8:	7a4080e7          	jalr	1956(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    800054fc:	00048593          	mv	a1,s1
    80005500:	ffffd097          	auipc	ra,0xffffd
    80005504:	8d8080e7          	jalr	-1832(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80005508:	01813083          	ld	ra,24(sp)
    8000550c:	01013403          	ld	s0,16(sp)
    80005510:	00813483          	ld	s1,8(sp)
    80005514:	02010113          	addi	sp,sp,32
    80005518:	00008067          	ret

000000008000551c <_ZN15KernelSemaphoredaEPv>:

void KernelSemaphore::operator delete[](void *ptr) {
    8000551c:	fe010113          	addi	sp,sp,-32
    80005520:	00113c23          	sd	ra,24(sp)
    80005524:	00813823          	sd	s0,16(sp)
    80005528:	00913423          	sd	s1,8(sp)
    8000552c:	02010413          	addi	s0,sp,32
    80005530:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80005534:	ffffc097          	auipc	ra,0xffffc
    80005538:	764080e7          	jalr	1892(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    8000553c:	00048593          	mv	a1,s1
    80005540:	ffffd097          	auipc	ra,0xffffd
    80005544:	898080e7          	jalr	-1896(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80005548:	01813083          	ld	ra,24(sp)
    8000554c:	01013403          	ld	s0,16(sp)
    80005550:	00813483          	ld	s1,8(sp)
    80005554:	02010113          	addi	sp,sp,32
    80005558:	00008067          	ret

000000008000555c <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB>:
    TCB* tcb = removeThreadFromBlockedList();
    if (tcb) Scheduler::getInstance().put(tcb);
    return tcb;
}

void KernelSemaphore::insertThreadIntoBlockedList(TCB *tcb) {
    8000555c:	ff010113          	addi	sp,sp,-16
    80005560:	00813423          	sd	s0,8(sp)
    80005564:	01010413          	addi	s0,sp,16
    if (!blockedThreadsHead || !blockedThreadsTail) {
    80005568:	00853783          	ld	a5,8(a0)
    8000556c:	00078e63          	beqz	a5,80005588 <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB+0x2c>
    80005570:	01053783          	ld	a5,16(a0)
    80005574:	00078a63          	beqz	a5,80005588 <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB+0x2c>
    void setSleepTime(uint64 time) { sleepTime = time; }
    uint64 getSleepTime() const { return sleepTime; }

    // ove metode sluze kao pomoc za ulancavanje niti u listu blokiranih niti na semaforu
    TCB* getNextSemaphoreThread() const { return semaphoreNextThread; }
    void setNextSemaphoreThread(TCB* next) { semaphoreNextThread = next; }
    80005578:	06b7b023          	sd	a1,96(a5)
        blockedThreadsHead = blockedThreadsTail = tcb;
        blockedThreadsHead->setNextSemaphoreThread(nullptr);
    } else {
        blockedThreadsTail->setNextSemaphoreThread(tcb);
        blockedThreadsTail = tcb;
    8000557c:	00b53823          	sd	a1,16(a0)
    80005580:	0605b023          	sd	zero,96(a1)
        blockedThreadsTail->setNextSemaphoreThread(nullptr);
    }
}
    80005584:	0100006f          	j	80005594 <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB+0x38>
        blockedThreadsHead = blockedThreadsTail = tcb;
    80005588:	00b53823          	sd	a1,16(a0)
    8000558c:	00b53423          	sd	a1,8(a0)
    80005590:	0605b023          	sd	zero,96(a1)
}
    80005594:	00813403          	ld	s0,8(sp)
    80005598:	01010113          	addi	sp,sp,16
    8000559c:	00008067          	ret

00000000800055a0 <_ZN15KernelSemaphore18blockCurrentThreadEv>:
void KernelSemaphore::blockCurrentThread() {
    800055a0:	ff010113          	addi	sp,sp,-16
    800055a4:	00113423          	sd	ra,8(sp)
    800055a8:	00813023          	sd	s0,0(sp)
    800055ac:	01010413          	addi	s0,sp,16
    insertThreadIntoBlockedList(TCB::runningThread);
    800055b0:	00006797          	auipc	a5,0x6
    800055b4:	6e07b783          	ld	a5,1760(a5) # 8000bc90 <_GLOBAL_OFFSET_TABLE_+0x38>
    800055b8:	0007b583          	ld	a1,0(a5)
    800055bc:	00000097          	auipc	ra,0x0
    800055c0:	fa0080e7          	jalr	-96(ra) # 8000555c <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB>
    TCB::suspendCurrentThread();
    800055c4:	00001097          	auipc	ra,0x1
    800055c8:	ca8080e7          	jalr	-856(ra) # 8000626c <_ZN3TCB20suspendCurrentThreadEv>
}
    800055cc:	00813083          	ld	ra,8(sp)
    800055d0:	00013403          	ld	s0,0(sp)
    800055d4:	01010113          	addi	sp,sp,16
    800055d8:	00008067          	ret

00000000800055dc <_ZN15KernelSemaphore4waitEv>:
    if (--semaphoreValue < 0) {
    800055dc:	00052783          	lw	a5,0(a0)
    800055e0:	fff7879b          	addiw	a5,a5,-1
    800055e4:	00f52023          	sw	a5,0(a0)
    800055e8:	02079713          	slli	a4,a5,0x20
    800055ec:	00074463          	bltz	a4,800055f4 <_ZN15KernelSemaphore4waitEv+0x18>
    800055f0:	00008067          	ret
void KernelSemaphore::wait() {
    800055f4:	ff010113          	addi	sp,sp,-16
    800055f8:	00113423          	sd	ra,8(sp)
    800055fc:	00813023          	sd	s0,0(sp)
    80005600:	01010413          	addi	s0,sp,16
       blockCurrentThread();
    80005604:	00000097          	auipc	ra,0x0
    80005608:	f9c080e7          	jalr	-100(ra) # 800055a0 <_ZN15KernelSemaphore18blockCurrentThreadEv>
}
    8000560c:	00813083          	ld	ra,8(sp)
    80005610:	00013403          	ld	s0,0(sp)
    80005614:	01010113          	addi	sp,sp,16
    80005618:	00008067          	ret

000000008000561c <_ZN15KernelSemaphore27removeThreadFromBlockedListEv>:

TCB* KernelSemaphore::removeThreadFromBlockedList() {
    8000561c:	ff010113          	addi	sp,sp,-16
    80005620:	00813423          	sd	s0,8(sp)
    80005624:	01010413          	addi	s0,sp,16
    80005628:	00050793          	mv	a5,a0
    if (!blockedThreadsHead || !blockedThreadsTail) return nullptr;
    8000562c:	00853503          	ld	a0,8(a0)
    80005630:	00050e63          	beqz	a0,8000564c <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x30>
    80005634:	0107b703          	ld	a4,16(a5)
    80005638:	02070463          	beqz	a4,80005660 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x44>
    TCB* getNextSemaphoreThread() const { return semaphoreNextThread; }
    8000563c:	06053703          	ld	a4,96(a0)
    TCB* oldThread = blockedThreadsHead;
    blockedThreadsHead = blockedThreadsHead->getNextSemaphoreThread();
    80005640:	00e7b423          	sd	a4,8(a5)
    if (!blockedThreadsHead) blockedThreadsTail = nullptr;
    80005644:	00070a63          	beqz	a4,80005658 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x3c>
    void setNextSemaphoreThread(TCB* next) { semaphoreNextThread = next; }
    80005648:	06053023          	sd	zero,96(a0)
    oldThread->setNextSemaphoreThread(nullptr);
    return oldThread;
    8000564c:	00813403          	ld	s0,8(sp)
    80005650:	01010113          	addi	sp,sp,16
    80005654:	00008067          	ret
    if (!blockedThreadsHead) blockedThreadsTail = nullptr;
    80005658:	0007b823          	sd	zero,16(a5)
    8000565c:	fedff06f          	j	80005648 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x2c>
    if (!blockedThreadsHead || !blockedThreadsTail) return nullptr;
    80005660:	00070513          	mv	a0,a4
    80005664:	fe9ff06f          	j	8000564c <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x30>

0000000080005668 <_ZN15KernelSemaphore24unblockFirstThreadInListEv>:
TCB* KernelSemaphore::unblockFirstThreadInList() {
    80005668:	fe010113          	addi	sp,sp,-32
    8000566c:	00113c23          	sd	ra,24(sp)
    80005670:	00813823          	sd	s0,16(sp)
    80005674:	00913423          	sd	s1,8(sp)
    80005678:	02010413          	addi	s0,sp,32
    TCB* tcb = removeThreadFromBlockedList();
    8000567c:	00000097          	auipc	ra,0x0
    80005680:	fa0080e7          	jalr	-96(ra) # 8000561c <_ZN15KernelSemaphore27removeThreadFromBlockedListEv>
    80005684:	00050493          	mv	s1,a0
    if (tcb) Scheduler::getInstance().put(tcb);
    80005688:	00050c63          	beqz	a0,800056a0 <_ZN15KernelSemaphore24unblockFirstThreadInListEv+0x38>
    8000568c:	ffffd097          	auipc	ra,0xffffd
    80005690:	994080e7          	jalr	-1644(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    80005694:	00048593          	mv	a1,s1
    80005698:	ffffd097          	auipc	ra,0xffffd
    8000569c:	9d4080e7          	jalr	-1580(ra) # 8000206c <_ZN9Scheduler3putEP3TCB>
}
    800056a0:	00048513          	mv	a0,s1
    800056a4:	01813083          	ld	ra,24(sp)
    800056a8:	01013403          	ld	s0,16(sp)
    800056ac:	00813483          	ld	s1,8(sp)
    800056b0:	02010113          	addi	sp,sp,32
    800056b4:	00008067          	ret

00000000800056b8 <_ZN15KernelSemaphore14closeSemaphoreEPS_>:
int KernelSemaphore::closeSemaphore(KernelSemaphore *semaphore) {
    800056b8:	fe010113          	addi	sp,sp,-32
    800056bc:	00113c23          	sd	ra,24(sp)
    800056c0:	00813823          	sd	s0,16(sp)
    800056c4:	00913423          	sd	s1,8(sp)
    800056c8:	02010413          	addi	s0,sp,32
    800056cc:	00050493          	mv	s1,a0
    if (!semaphore) return -1;
    800056d0:	02050463          	beqz	a0,800056f8 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x40>
    while (semaphore->blockedThreadsHead) {
    800056d4:	0084b783          	ld	a5,8(s1)
    800056d8:	02078463          	beqz	a5,80005700 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x48>
        TCB* unblockedThread = semaphore->unblockFirstThreadInList(); // odblokiranje svih niti koje cekaju na tekucem semaforu
    800056dc:	00048513          	mv	a0,s1
    800056e0:	00000097          	auipc	ra,0x0
    800056e4:	f88080e7          	jalr	-120(ra) # 80005668 <_ZN15KernelSemaphore24unblockFirstThreadInListEv>
        if (unblockedThread) unblockedThread->setWaitSemaphoreFailed(true); // sem_wait sistemski poziv pozvan za sve ove niti treba da vrati gresku
    800056e8:	fe0506e3          	beqz	a0,800056d4 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x1c>
    // ove metode sluze za postavljanje i dohvatanje flag-a koji nam govori da li je tekuca nit nasilno odblokirana tako sto je
    // semafor na kojem je ona cekala zatvoren sistemskim pozivom sem_close - u tom slucaju sem_wait treba da vrati gresku
    void setWaitSemaphoreFailed(bool value) { waitSemaphoreFailed = value; }
    800056ec:	00100793          	li	a5,1
    800056f0:	06f50423          	sb	a5,104(a0)
    800056f4:	fe1ff06f          	j	800056d4 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x1c>
    if (!semaphore) return -1;
    800056f8:	fff00513          	li	a0,-1
    800056fc:	0080006f          	j	80005704 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x4c>
    return 0;
    80005700:	00000513          	li	a0,0
}
    80005704:	01813083          	ld	ra,24(sp)
    80005708:	01013403          	ld	s0,16(sp)
    8000570c:	00813483          	ld	s1,8(sp)
    80005710:	02010113          	addi	sp,sp,32
    80005714:	00008067          	ret

0000000080005718 <_ZN15KernelSemaphoreD1Ev>:
KernelSemaphore::~KernelSemaphore() {
    80005718:	ff010113          	addi	sp,sp,-16
    8000571c:	00113423          	sd	ra,8(sp)
    80005720:	00813023          	sd	s0,0(sp)
    80005724:	01010413          	addi	s0,sp,16
    KernelSemaphore::closeSemaphore(this);
    80005728:	00000097          	auipc	ra,0x0
    8000572c:	f90080e7          	jalr	-112(ra) # 800056b8 <_ZN15KernelSemaphore14closeSemaphoreEPS_>
}
    80005730:	00813083          	ld	ra,8(sp)
    80005734:	00013403          	ld	s0,0(sp)
    80005738:	01010113          	addi	sp,sp,16
    8000573c:	00008067          	ret

0000000080005740 <_ZN15KernelSemaphore6signalEv>:
    if (++semaphoreValue <= 0) {
    80005740:	00052783          	lw	a5,0(a0)
    80005744:	0017879b          	addiw	a5,a5,1
    80005748:	0007871b          	sext.w	a4,a5
    8000574c:	00f52023          	sw	a5,0(a0)
    80005750:	00e05463          	blez	a4,80005758 <_ZN15KernelSemaphore6signalEv+0x18>
    80005754:	00008067          	ret
void KernelSemaphore::signal() {
    80005758:	ff010113          	addi	sp,sp,-16
    8000575c:	00113423          	sd	ra,8(sp)
    80005760:	00813023          	sd	s0,0(sp)
    80005764:	01010413          	addi	s0,sp,16
        unblockFirstThreadInList();
    80005768:	00000097          	auipc	ra,0x0
    8000576c:	f00080e7          	jalr	-256(ra) # 80005668 <_ZN15KernelSemaphore24unblockFirstThreadInListEv>
}
    80005770:	00813083          	ld	ra,8(sp)
    80005774:	00013403          	ld	s0,0(sp)
    80005778:	01010113          	addi	sp,sp,16
    8000577c:	00008067          	ret

0000000080005780 <_Z24putcKernelThreadFunctionPv>:
#include "../../../h/Code/Console/KernelThreadFunctions.hpp"
#include "../../../h/Code/Console/KernelBuffer.hpp"

void putcKernelThreadFunction(void* arg) {
    80005780:	fe010113          	addi	sp,sp,-32
    80005784:	00113c23          	sd	ra,24(sp)
    80005788:	00813823          	sd	s0,16(sp)
    8000578c:	00913423          	sd	s1,8(sp)
    80005790:	02010413          	addi	s0,sp,32
    switchUserToSupervisor();
    80005794:	00001097          	auipc	ra,0x1
    80005798:	180080e7          	jalr	384(ra) # 80006914 <_Z22switchUserToSupervisorv>
    while (true) {
        while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
    8000579c:	00006797          	auipc	a5,0x6
    800057a0:	4cc7b783          	ld	a5,1228(a5) # 8000bc68 <_GLOBAL_OFFSET_TABLE_+0x10>
    800057a4:	0007b483          	ld	s1,0(a5)
    800057a8:	0004c783          	lbu	a5,0(s1)
    800057ac:	0207f793          	andi	a5,a5,32
    800057b0:	fe0786e3          	beqz	a5,8000579c <_Z24putcKernelThreadFunctionPv+0x1c>
            // sve dok je konzola spremna da primi podatak saljemo joj
            char newCharacter = KernelBuffer::putcGetInstance()->removeFromBuffer();
    800057b4:	00000097          	auipc	ra,0x0
    800057b8:	1c0080e7          	jalr	448(ra) # 80005974 <_ZN12KernelBuffer15putcGetInstanceEv>
    800057bc:	00000097          	auipc	ra,0x0
    800057c0:	408080e7          	jalr	1032(ra) # 80005bc4 <_ZN12KernelBuffer16removeFromBufferEv>
    800057c4:	0ff57513          	andi	a0,a0,255
            if (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
    800057c8:	0004c783          	lbu	a5,0(s1)
    800057cc:	0207f793          	andi	a5,a5,32
    800057d0:	fc0786e3          	beqz	a5,8000579c <_Z24putcKernelThreadFunctionPv+0x1c>
                *reinterpret_cast<char*>(CONSOLE_TX_DATA) = newCharacter;
    800057d4:	00006797          	auipc	a5,0x6
    800057d8:	4c47b783          	ld	a5,1220(a5) # 8000bc98 <_GLOBAL_OFFSET_TABLE_+0x40>
    800057dc:	0007b783          	ld	a5,0(a5)
    800057e0:	00a78023          	sb	a0,0(a5)
    800057e4:	fb9ff06f          	j	8000579c <_Z24putcKernelThreadFunctionPv+0x1c>

00000000800057e8 <_ZN12KernelBuffernwEm>:
    } else {
        return getcKernelBufferHandle;
    }
}

void* KernelBuffer::operator new(size_t n) {
    800057e8:	fe010113          	addi	sp,sp,-32
    800057ec:	00113c23          	sd	ra,24(sp)
    800057f0:	00813823          	sd	s0,16(sp)
    800057f4:	00913423          	sd	s1,8(sp)
    800057f8:	02010413          	addi	s0,sp,32
    800057fc:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80005800:	ffffc097          	auipc	ra,0xffffc
    80005804:	498080e7          	jalr	1176(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005808:	00048593          	mv	a1,s1
    8000580c:	ffffc097          	auipc	ra,0xffffc
    80005810:	4e8080e7          	jalr	1256(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    80005814:	01813083          	ld	ra,24(sp)
    80005818:	01013403          	ld	s0,16(sp)
    8000581c:	00813483          	ld	s1,8(sp)
    80005820:	02010113          	addi	sp,sp,32
    80005824:	00008067          	ret

0000000080005828 <_ZN12KernelBuffernaEm>:

void* KernelBuffer::operator new[](size_t n) {
    80005828:	fe010113          	addi	sp,sp,-32
    8000582c:	00113c23          	sd	ra,24(sp)
    80005830:	00813823          	sd	s0,16(sp)
    80005834:	00913423          	sd	s1,8(sp)
    80005838:	02010413          	addi	s0,sp,32
    8000583c:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80005840:	ffffc097          	auipc	ra,0xffffc
    80005844:	458080e7          	jalr	1112(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005848:	00048593          	mv	a1,s1
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	4a8080e7          	jalr	1192(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    80005854:	01813083          	ld	ra,24(sp)
    80005858:	01013403          	ld	s0,16(sp)
    8000585c:	00813483          	ld	s1,8(sp)
    80005860:	02010113          	addi	sp,sp,32
    80005864:	00008067          	ret

0000000080005868 <_ZN12KernelBufferdlEPv>:

void KernelBuffer::operator delete(void *ptr) {
    80005868:	fe010113          	addi	sp,sp,-32
    8000586c:	00113c23          	sd	ra,24(sp)
    80005870:	00813823          	sd	s0,16(sp)
    80005874:	00913423          	sd	s1,8(sp)
    80005878:	02010413          	addi	s0,sp,32
    8000587c:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80005880:	ffffc097          	auipc	ra,0xffffc
    80005884:	418080e7          	jalr	1048(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005888:	00048593          	mv	a1,s1
    8000588c:	ffffc097          	auipc	ra,0xffffc
    80005890:	54c080e7          	jalr	1356(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80005894:	01813083          	ld	ra,24(sp)
    80005898:	01013403          	ld	s0,16(sp)
    8000589c:	00813483          	ld	s1,8(sp)
    800058a0:	02010113          	addi	sp,sp,32
    800058a4:	00008067          	ret

00000000800058a8 <_ZN12KernelBufferdaEPv>:

void KernelBuffer::operator delete[](void *ptr) {
    800058a8:	fe010113          	addi	sp,sp,-32
    800058ac:	00113c23          	sd	ra,24(sp)
    800058b0:	00813823          	sd	s0,16(sp)
    800058b4:	00913423          	sd	s1,8(sp)
    800058b8:	02010413          	addi	s0,sp,32
    800058bc:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    800058c0:	ffffc097          	auipc	ra,0xffffc
    800058c4:	3d8080e7          	jalr	984(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    800058c8:	00048593          	mv	a1,s1
    800058cc:	ffffc097          	auipc	ra,0xffffc
    800058d0:	50c080e7          	jalr	1292(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    800058d4:	01813083          	ld	ra,24(sp)
    800058d8:	01013403          	ld	s0,16(sp)
    800058dc:	00813483          	ld	s1,8(sp)
    800058e0:	02010113          	addi	sp,sp,32
    800058e4:	00008067          	ret

00000000800058e8 <_ZN12KernelBufferC1Ev>:

KernelBuffer::KernelBuffer() {
    800058e8:	fe010113          	addi	sp,sp,-32
    800058ec:	00113c23          	sd	ra,24(sp)
    800058f0:	00813823          	sd	s0,16(sp)
    800058f4:	00913423          	sd	s1,8(sp)
    800058f8:	02010413          	addi	s0,sp,32
    800058fc:	00050493          	mv	s1,a0
    capacity = 8192; // 8 KB
    80005900:	000027b7          	lui	a5,0x2
    80005904:	00f52023          	sw	a5,0(a0)
    head = tail = 0;
    80005908:	00052a23          	sw	zero,20(a0)
    8000590c:	00052823          	sw	zero,16(a0)
    buffer = static_cast<int*>(KernelBuffer::operator new(capacity * sizeof(int)));
    80005910:	00008537          	lui	a0,0x8
    80005914:	00000097          	auipc	ra,0x0
    80005918:	ed4080e7          	jalr	-300(ra) # 800057e8 <_ZN12KernelBuffernwEm>
    8000591c:	00a4b423          	sd	a0,8(s1)
    spaceAvailable = KernelSemaphore::createSemaphore(capacity);
    80005920:	0004d503          	lhu	a0,0(s1)
    80005924:	00000097          	auipc	ra,0x0
    80005928:	b34080e7          	jalr	-1228(ra) # 80005458 <_ZN15KernelSemaphore15createSemaphoreEt>
    8000592c:	00a4bc23          	sd	a0,24(s1)
    itemAvailable = KernelSemaphore::createSemaphore(0);
    80005930:	00000513          	li	a0,0
    80005934:	00000097          	auipc	ra,0x0
    80005938:	b24080e7          	jalr	-1244(ra) # 80005458 <_ZN15KernelSemaphore15createSemaphoreEt>
    8000593c:	02a4b023          	sd	a0,32(s1)
    mutexHead = KernelSemaphore::createSemaphore(1);
    80005940:	00100513          	li	a0,1
    80005944:	00000097          	auipc	ra,0x0
    80005948:	b14080e7          	jalr	-1260(ra) # 80005458 <_ZN15KernelSemaphore15createSemaphoreEt>
    8000594c:	02a4b423          	sd	a0,40(s1)
    mutexTail = KernelSemaphore::createSemaphore(1);
    80005950:	00100513          	li	a0,1
    80005954:	00000097          	auipc	ra,0x0
    80005958:	b04080e7          	jalr	-1276(ra) # 80005458 <_ZN15KernelSemaphore15createSemaphoreEt>
    8000595c:	02a4b823          	sd	a0,48(s1)
}
    80005960:	01813083          	ld	ra,24(sp)
    80005964:	01013403          	ld	s0,16(sp)
    80005968:	00813483          	ld	s1,8(sp)
    8000596c:	02010113          	addi	sp,sp,32
    80005970:	00008067          	ret

0000000080005974 <_ZN12KernelBuffer15putcGetInstanceEv>:
KernelBuffer* KernelBuffer::putcGetInstance() {
    80005974:	fe010113          	addi	sp,sp,-32
    80005978:	00113c23          	sd	ra,24(sp)
    8000597c:	00813823          	sd	s0,16(sp)
    80005980:	00913423          	sd	s1,8(sp)
    80005984:	01213023          	sd	s2,0(sp)
    80005988:	02010413          	addi	s0,sp,32
    if (!putcKernelBufferHandle) {
    8000598c:	00006497          	auipc	s1,0x6
    80005990:	3f44b483          	ld	s1,1012(s1) # 8000bd80 <_ZN12KernelBuffer22putcKernelBufferHandleE>
    80005994:	02048063          	beqz	s1,800059b4 <_ZN12KernelBuffer15putcGetInstanceEv+0x40>
}
    80005998:	00048513          	mv	a0,s1
    8000599c:	01813083          	ld	ra,24(sp)
    800059a0:	01013403          	ld	s0,16(sp)
    800059a4:	00813483          	ld	s1,8(sp)
    800059a8:	00013903          	ld	s2,0(sp)
    800059ac:	02010113          	addi	sp,sp,32
    800059b0:	00008067          	ret
        putcKernelBufferHandle = new KernelBuffer;
    800059b4:	03800513          	li	a0,56
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	e30080e7          	jalr	-464(ra) # 800057e8 <_ZN12KernelBuffernwEm>
    800059c0:	00050493          	mv	s1,a0
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	f24080e7          	jalr	-220(ra) # 800058e8 <_ZN12KernelBufferC1Ev>
    800059cc:	00006797          	auipc	a5,0x6
    800059d0:	3a97ba23          	sd	s1,948(a5) # 8000bd80 <_ZN12KernelBuffer22putcKernelBufferHandleE>
        return putcKernelBufferHandle;
    800059d4:	fc5ff06f          	j	80005998 <_ZN12KernelBuffer15putcGetInstanceEv+0x24>
    800059d8:	00050913          	mv	s2,a0
        putcKernelBufferHandle = new KernelBuffer;
    800059dc:	00048513          	mv	a0,s1
    800059e0:	00000097          	auipc	ra,0x0
    800059e4:	e88080e7          	jalr	-376(ra) # 80005868 <_ZN12KernelBufferdlEPv>
    800059e8:	00090513          	mv	a0,s2
    800059ec:	00007097          	auipc	ra,0x7
    800059f0:	73c080e7          	jalr	1852(ra) # 8000d128 <_Unwind_Resume>

00000000800059f4 <_ZN12KernelBuffer15getcGetInstanceEv>:
KernelBuffer* KernelBuffer::getcGetInstance() {
    800059f4:	fe010113          	addi	sp,sp,-32
    800059f8:	00113c23          	sd	ra,24(sp)
    800059fc:	00813823          	sd	s0,16(sp)
    80005a00:	00913423          	sd	s1,8(sp)
    80005a04:	01213023          	sd	s2,0(sp)
    80005a08:	02010413          	addi	s0,sp,32
    if (!getcKernelBufferHandle) {
    80005a0c:	00006497          	auipc	s1,0x6
    80005a10:	37c4b483          	ld	s1,892(s1) # 8000bd88 <_ZN12KernelBuffer22getcKernelBufferHandleE>
    80005a14:	02048063          	beqz	s1,80005a34 <_ZN12KernelBuffer15getcGetInstanceEv+0x40>
}
    80005a18:	00048513          	mv	a0,s1
    80005a1c:	01813083          	ld	ra,24(sp)
    80005a20:	01013403          	ld	s0,16(sp)
    80005a24:	00813483          	ld	s1,8(sp)
    80005a28:	00013903          	ld	s2,0(sp)
    80005a2c:	02010113          	addi	sp,sp,32
    80005a30:	00008067          	ret
        getcKernelBufferHandle = new KernelBuffer;
    80005a34:	03800513          	li	a0,56
    80005a38:	00000097          	auipc	ra,0x0
    80005a3c:	db0080e7          	jalr	-592(ra) # 800057e8 <_ZN12KernelBuffernwEm>
    80005a40:	00050493          	mv	s1,a0
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	ea4080e7          	jalr	-348(ra) # 800058e8 <_ZN12KernelBufferC1Ev>
    80005a4c:	00006797          	auipc	a5,0x6
    80005a50:	3297be23          	sd	s1,828(a5) # 8000bd88 <_ZN12KernelBuffer22getcKernelBufferHandleE>
        return getcKernelBufferHandle;
    80005a54:	fc5ff06f          	j	80005a18 <_ZN12KernelBuffer15getcGetInstanceEv+0x24>
    80005a58:	00050913          	mv	s2,a0
        getcKernelBufferHandle = new KernelBuffer;
    80005a5c:	00048513          	mv	a0,s1
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	e08080e7          	jalr	-504(ra) # 80005868 <_ZN12KernelBufferdlEPv>
    80005a68:	00090513          	mv	a0,s2
    80005a6c:	00007097          	auipc	ra,0x7
    80005a70:	6bc080e7          	jalr	1724(ra) # 8000d128 <_Unwind_Resume>

0000000080005a74 <_ZN12KernelBufferD1Ev>:

KernelBuffer::~KernelBuffer() {
    80005a74:	fe010113          	addi	sp,sp,-32
    80005a78:	00113c23          	sd	ra,24(sp)
    80005a7c:	00813823          	sd	s0,16(sp)
    80005a80:	00913423          	sd	s1,8(sp)
    80005a84:	01213023          	sd	s2,0(sp)
    80005a88:	02010413          	addi	s0,sp,32
    80005a8c:	00050493          	mv	s1,a0
    KernelBuffer::operator delete[](buffer);
    80005a90:	00853503          	ld	a0,8(a0) # 8008 <_entry-0x7fff7ff8>
    80005a94:	00000097          	auipc	ra,0x0
    80005a98:	e14080e7          	jalr	-492(ra) # 800058a8 <_ZN12KernelBufferdaEPv>
    delete spaceAvailable;
    80005a9c:	0184b903          	ld	s2,24(s1)
    80005aa0:	00090e63          	beqz	s2,80005abc <_ZN12KernelBufferD1Ev+0x48>
    80005aa4:	00090513          	mv	a0,s2
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	c70080e7          	jalr	-912(ra) # 80005718 <_ZN15KernelSemaphoreD1Ev>
    80005ab0:	00090513          	mv	a0,s2
    80005ab4:	00000097          	auipc	ra,0x0
    80005ab8:	a28080e7          	jalr	-1496(ra) # 800054dc <_ZN15KernelSemaphoredlEPv>
    delete itemAvailable;
    80005abc:	0204b903          	ld	s2,32(s1)
    80005ac0:	00090e63          	beqz	s2,80005adc <_ZN12KernelBufferD1Ev+0x68>
    80005ac4:	00090513          	mv	a0,s2
    80005ac8:	00000097          	auipc	ra,0x0
    80005acc:	c50080e7          	jalr	-944(ra) # 80005718 <_ZN15KernelSemaphoreD1Ev>
    80005ad0:	00090513          	mv	a0,s2
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	a08080e7          	jalr	-1528(ra) # 800054dc <_ZN15KernelSemaphoredlEPv>
    delete mutexHead;
    80005adc:	0284b903          	ld	s2,40(s1)
    80005ae0:	00090e63          	beqz	s2,80005afc <_ZN12KernelBufferD1Ev+0x88>
    80005ae4:	00090513          	mv	a0,s2
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	c30080e7          	jalr	-976(ra) # 80005718 <_ZN15KernelSemaphoreD1Ev>
    80005af0:	00090513          	mv	a0,s2
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	9e8080e7          	jalr	-1560(ra) # 800054dc <_ZN15KernelSemaphoredlEPv>
    delete mutexTail;
    80005afc:	0304b483          	ld	s1,48(s1)
    80005b00:	00048e63          	beqz	s1,80005b1c <_ZN12KernelBufferD1Ev+0xa8>
    80005b04:	00048513          	mv	a0,s1
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	c10080e7          	jalr	-1008(ra) # 80005718 <_ZN15KernelSemaphoreD1Ev>
    80005b10:	00048513          	mv	a0,s1
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	9c8080e7          	jalr	-1592(ra) # 800054dc <_ZN15KernelSemaphoredlEPv>
}
    80005b1c:	01813083          	ld	ra,24(sp)
    80005b20:	01013403          	ld	s0,16(sp)
    80005b24:	00813483          	ld	s1,8(sp)
    80005b28:	00013903          	ld	s2,0(sp)
    80005b2c:	02010113          	addi	sp,sp,32
    80005b30:	00008067          	ret

0000000080005b34 <_ZN12KernelBuffer16insertIntoBufferEi>:

void KernelBuffer::insertIntoBuffer(int value) {
    80005b34:	fe010113          	addi	sp,sp,-32
    80005b38:	00113c23          	sd	ra,24(sp)
    80005b3c:	00813823          	sd	s0,16(sp)
    80005b40:	00913423          	sd	s1,8(sp)
    80005b44:	01213023          	sd	s2,0(sp)
    80005b48:	02010413          	addi	s0,sp,32
    80005b4c:	00050493          	mv	s1,a0
    80005b50:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    80005b54:	01853503          	ld	a0,24(a0)
    80005b58:	00000097          	auipc	ra,0x0
    80005b5c:	a84080e7          	jalr	-1404(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>

    mutexTail->wait();
    80005b60:	0304b503          	ld	a0,48(s1)
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	a78080e7          	jalr	-1416(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>
    buffer[tail] = value;
    80005b6c:	0084b783          	ld	a5,8(s1)
    80005b70:	0144a703          	lw	a4,20(s1)
    80005b74:	00271713          	slli	a4,a4,0x2
    80005b78:	00e787b3          	add	a5,a5,a4
    80005b7c:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % capacity;
    80005b80:	0144a783          	lw	a5,20(s1)
    80005b84:	0017879b          	addiw	a5,a5,1
    80005b88:	0004a703          	lw	a4,0(s1)
    80005b8c:	02e7e7bb          	remw	a5,a5,a4
    80005b90:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    80005b94:	0304b503          	ld	a0,48(s1)
    80005b98:	00000097          	auipc	ra,0x0
    80005b9c:	ba8080e7          	jalr	-1112(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>

    itemAvailable->signal();
    80005ba0:	0204b503          	ld	a0,32(s1)
    80005ba4:	00000097          	auipc	ra,0x0
    80005ba8:	b9c080e7          	jalr	-1124(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>
}
    80005bac:	01813083          	ld	ra,24(sp)
    80005bb0:	01013403          	ld	s0,16(sp)
    80005bb4:	00813483          	ld	s1,8(sp)
    80005bb8:	00013903          	ld	s2,0(sp)
    80005bbc:	02010113          	addi	sp,sp,32
    80005bc0:	00008067          	ret

0000000080005bc4 <_ZN12KernelBuffer16removeFromBufferEv>:

int KernelBuffer::removeFromBuffer() {
    80005bc4:	fe010113          	addi	sp,sp,-32
    80005bc8:	00113c23          	sd	ra,24(sp)
    80005bcc:	00813823          	sd	s0,16(sp)
    80005bd0:	00913423          	sd	s1,8(sp)
    80005bd4:	01213023          	sd	s2,0(sp)
    80005bd8:	02010413          	addi	s0,sp,32
    80005bdc:	00050493          	mv	s1,a0
    itemAvailable->wait();
    80005be0:	02053503          	ld	a0,32(a0)
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	9f8080e7          	jalr	-1544(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>

    mutexHead->wait();
    80005bec:	0284b503          	ld	a0,40(s1)
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	9ec080e7          	jalr	-1556(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>
    int value = buffer[head];
    80005bf8:	0084b703          	ld	a4,8(s1)
    80005bfc:	0104a783          	lw	a5,16(s1)
    80005c00:	00279693          	slli	a3,a5,0x2
    80005c04:	00d70733          	add	a4,a4,a3
    80005c08:	00072903          	lw	s2,0(a4)
    head = (head + 1) % capacity;
    80005c0c:	0017879b          	addiw	a5,a5,1
    80005c10:	0004a703          	lw	a4,0(s1)
    80005c14:	02e7e7bb          	remw	a5,a5,a4
    80005c18:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    80005c1c:	0284b503          	ld	a0,40(s1)
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	b20080e7          	jalr	-1248(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>

    spaceAvailable->signal();
    80005c28:	0184b503          	ld	a0,24(s1)
    80005c2c:	00000097          	auipc	ra,0x0
    80005c30:	b14080e7          	jalr	-1260(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>

    return value;
}
    80005c34:	00090513          	mv	a0,s2
    80005c38:	01813083          	ld	ra,24(sp)
    80005c3c:	01013403          	ld	s0,16(sp)
    80005c40:	00813483          	ld	s1,8(sp)
    80005c44:	00013903          	ld	s2,0(sp)
    80005c48:	02010113          	addi	sp,sp,32
    80005c4c:	00008067          	ret

0000000080005c50 <_ZN12KernelBuffer19getNumberOfElementsEv>:

int KernelBuffer::getNumberOfElements() {
    80005c50:	fe010113          	addi	sp,sp,-32
    80005c54:	00113c23          	sd	ra,24(sp)
    80005c58:	00813823          	sd	s0,16(sp)
    80005c5c:	00913423          	sd	s1,8(sp)
    80005c60:	01213023          	sd	s2,0(sp)
    80005c64:	02010413          	addi	s0,sp,32
    80005c68:	00050493          	mv	s1,a0
    int value;

    mutexHead->wait();
    80005c6c:	02853503          	ld	a0,40(a0)
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	96c080e7          	jalr	-1684(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>
    mutexTail->wait();
    80005c78:	0304b503          	ld	a0,48(s1)
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	960080e7          	jalr	-1696(ra) # 800055dc <_ZN15KernelSemaphore4waitEv>

    if (tail >= head) {
    80005c84:	0144a783          	lw	a5,20(s1)
    80005c88:	0104a903          	lw	s2,16(s1)
    80005c8c:	0327ce63          	blt	a5,s2,80005cc8 <_ZN12KernelBuffer19getNumberOfElementsEv+0x78>
        value = tail - head;
    80005c90:	4127893b          	subw	s2,a5,s2
    } else {
        value = capacity - head + tail;
    }

    mutexHead->signal();
    80005c94:	0284b503          	ld	a0,40(s1)
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	aa8080e7          	jalr	-1368(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>
    mutexTail->signal();
    80005ca0:	0304b503          	ld	a0,48(s1)
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	a9c080e7          	jalr	-1380(ra) # 80005740 <_ZN15KernelSemaphore6signalEv>

    return value;
    80005cac:	00090513          	mv	a0,s2
    80005cb0:	01813083          	ld	ra,24(sp)
    80005cb4:	01013403          	ld	s0,16(sp)
    80005cb8:	00813483          	ld	s1,8(sp)
    80005cbc:	00013903          	ld	s2,0(sp)
    80005cc0:	02010113          	addi	sp,sp,32
    80005cc4:	00008067          	ret
        value = capacity - head + tail;
    80005cc8:	0004a703          	lw	a4,0(s1)
    80005ccc:	4127093b          	subw	s2,a4,s2
    80005cd0:	00f9093b          	addw	s2,s2,a5
    80005cd4:	fc1ff06f          	j	80005c94 <_ZN12KernelBuffer19getNumberOfElementsEv+0x44>

0000000080005cd8 <_ZN3TCB13threadWrapperEv>:
    TCB* oldThread = TCB::runningThread;
    TCB::runningThread = Scheduler::getInstance().get();
    TCB::contextSwitch(&oldThread->context, &TCB::runningThread->context);
}

void TCB::threadWrapper() {
    80005cd8:	fe010113          	addi	sp,sp,-32
    80005cdc:	00113c23          	sd	ra,24(sp)
    80005ce0:	00813823          	sd	s0,16(sp)
    80005ce4:	00913423          	sd	s1,8(sp)
    80005ce8:	02010413          	addi	s0,sp,32
    Riscv::exitSupervisorTrap();
    80005cec:	ffffc097          	auipc	ra,0xffffc
    80005cf0:	3b0080e7          	jalr	944(ra) # 8000209c <_ZN5Riscv18exitSupervisorTrapEv>
    switchSupervisorToUser();
    80005cf4:	00001097          	auipc	ra,0x1
    80005cf8:	bd0080e7          	jalr	-1072(ra) # 800068c4 <_Z22switchSupervisorToUserv>
    runningThread->body(runningThread->arg);
    80005cfc:	00006497          	auipc	s1,0x6
    80005d00:	09448493          	addi	s1,s1,148 # 8000bd90 <_ZN3TCB13runningThreadE>
    80005d04:	0004b783          	ld	a5,0(s1)
    80005d08:	0007b703          	ld	a4,0(a5)
    80005d0c:	0087b503          	ld	a0,8(a5)
    80005d10:	000700e7          	jalr	a4
    if (!runningThread->getFinished()) {
    80005d14:	0004b783          	ld	a5,0(s1)
    // u tom slucaju, u konstrukciji te niti ne treba je davati scheduleru na raspolaganje, jer bi je to suspendovalo -
    // zelimo da bas ta nit main-a nastavi da se izvrsava
    static TCB* createThread(Body body, void* arg, void* stack, bool cppApi);

    // obezbedjena enkapsulacija - atribut finished je privatan i moze se citati samo kroz getter metod, a menjati preko setter metoda
    bool getFinished() const { return finished; }
    80005d18:	0307c783          	lbu	a5,48(a5)
    80005d1c:	00078c63          	beqz	a5,80005d34 <_ZN3TCB13threadWrapperEv+0x5c>
        thread_exit(); // sistemski poziv thread_exit za gasenje tekuce niti - unutar ovog poziva ce se promeniti i kontekst
    }
}
    80005d20:	01813083          	ld	ra,24(sp)
    80005d24:	01013403          	ld	s0,16(sp)
    80005d28:	00813483          	ld	s1,8(sp)
    80005d2c:	02010113          	addi	sp,sp,32
    80005d30:	00008067          	ret
        thread_exit(); // sistemski poziv thread_exit za gasenje tekuce niti - unutar ovog poziva ce se promeniti i kontekst
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	700080e7          	jalr	1792(ra) # 80006434 <_Z11thread_exitv>
}
    80005d3c:	fe5ff06f          	j	80005d20 <_ZN3TCB13threadWrapperEv+0x48>

0000000080005d40 <_ZN3TCB17insertSleepThreadEm>:
void TCB::insertSleepThread(uint64 time) {
    80005d40:	ff010113          	addi	sp,sp,-16
    80005d44:	00813423          	sd	s0,8(sp)
    80005d48:	01010413          	addi	s0,sp,16
    if (!sleepHead || !sleepTail) {
    80005d4c:	00006797          	auipc	a5,0x6
    80005d50:	04c7b783          	ld	a5,76(a5) # 8000bd98 <_ZN3TCB9sleepHeadE>
    80005d54:	02078663          	beqz	a5,80005d80 <_ZN3TCB17insertSleepThreadEm+0x40>
    80005d58:	00006617          	auipc	a2,0x6
    80005d5c:	04863603          	ld	a2,72(a2) # 8000bda0 <_ZN3TCB9sleepTailE>
    80005d60:	02060063          	beqz	a2,80005d80 <_ZN3TCB17insertSleepThreadEm+0x40>
    uint64 currSumOfSleepTimes = 0;
    80005d64:	00000713          	li	a4,0
    for (TCB* curr = sleepHead; curr; curr = curr->getNextSleepThread()) {
    80005d68:	08078063          	beqz	a5,80005de8 <_ZN3TCB17insertSleepThreadEm+0xa8>
    TCB* getPrevSleepThread() const { return sleepPrevThread; }
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    TCB* getNextSleepThread() const { return sleepNextThread; }
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    void setSleepTime(uint64 time) { sleepTime = time; }
    uint64 getSleepTime() const { return sleepTime; }
    80005d6c:	0487b683          	ld	a3,72(a5)
        currSumOfSleepTimes += curr->getSleepTime();
    80005d70:	00d70733          	add	a4,a4,a3
        if (time < currSumOfSleepTimes) {
    80005d74:	02e56463          	bltu	a0,a4,80005d9c <_ZN3TCB17insertSleepThreadEm+0x5c>
    TCB* getNextSleepThread() const { return sleepNextThread; }
    80005d78:	0507b783          	ld	a5,80(a5)
    for (TCB* curr = sleepHead; curr; curr = curr->getNextSleepThread()) {
    80005d7c:	fedff06f          	j	80005d68 <_ZN3TCB17insertSleepThreadEm+0x28>
        sleepHead = sleepTail = runningThread;
    80005d80:	00006717          	auipc	a4,0x6
    80005d84:	01070713          	addi	a4,a4,16 # 8000bd90 <_ZN3TCB13runningThreadE>
    80005d88:	00073783          	ld	a5,0(a4)
    80005d8c:	00f73823          	sd	a5,16(a4)
    80005d90:	00f73423          	sd	a5,8(a4)
    void setSleepTime(uint64 time) { sleepTime = time; }
    80005d94:	04a7b423          	sd	a0,72(a5)
        return;
    80005d98:	0700006f          	j	80005e08 <_ZN3TCB17insertSleepThreadEm+0xc8>
            runningThread->setNextSleepThread(curr);
    80005d9c:	00006697          	auipc	a3,0x6
    80005da0:	ff46b683          	ld	a3,-12(a3) # 8000bd90 <_ZN3TCB13runningThreadE>
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80005da4:	04f6b823          	sd	a5,80(a3)
    TCB* getPrevSleepThread() const { return sleepPrevThread; }
    80005da8:	0587b603          	ld	a2,88(a5)
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80005dac:	04c6bc23          	sd	a2,88(a3)
            if (!curr->getPrevSleepThread()) {
    80005db0:	02060063          	beqz	a2,80005dd0 <_ZN3TCB17insertSleepThreadEm+0x90>
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80005db4:	04d63823          	sd	a3,80(a2)
    uint64 getSleepTime() const { return sleepTime; }
    80005db8:	0487b603          	ld	a2,72(a5)
                runningThread->setSleepTime(time - (currSumOfSleepTimes - curr->getSleepTime()));
    80005dbc:	40e60733          	sub	a4,a2,a4
    80005dc0:	00a70733          	add	a4,a4,a0
    void setSleepTime(uint64 time) { sleepTime = time; }
    80005dc4:	04e6b423          	sd	a4,72(a3)
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80005dc8:	04d7bc23          	sd	a3,88(a5)
            return;
    80005dcc:	03c0006f          	j	80005e08 <_ZN3TCB17insertSleepThreadEm+0xc8>
    void setSleepTime(uint64 time) { sleepTime = time; }
    80005dd0:	04a6b423          	sd	a0,72(a3)
                curr->setSleepTime(currSumOfSleepTimes - time);
    80005dd4:	40a70733          	sub	a4,a4,a0
    80005dd8:	04e7b423          	sd	a4,72(a5)
                sleepHead = runningThread;
    80005ddc:	00006717          	auipc	a4,0x6
    80005de0:	fad73e23          	sd	a3,-68(a4) # 8000bd98 <_ZN3TCB9sleepHeadE>
    80005de4:	fe5ff06f          	j	80005dc8 <_ZN3TCB17insertSleepThreadEm+0x88>
    runningThread->setPrevSleepThread(sleepTail);
    80005de8:	00006697          	auipc	a3,0x6
    80005dec:	fa868693          	addi	a3,a3,-88 # 8000bd90 <_ZN3TCB13runningThreadE>
    80005df0:	0006b783          	ld	a5,0(a3)
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80005df4:	04c7bc23          	sd	a2,88(a5)
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80005df8:	04f63823          	sd	a5,80(a2)
    runningThread->setSleepTime(time - currSumOfSleepTimes);
    80005dfc:	40e50733          	sub	a4,a0,a4
    void setSleepTime(uint64 time) { sleepTime = time; }
    80005e00:	04e7b423          	sd	a4,72(a5)
    sleepTail = runningThread;
    80005e04:	00f6b823          	sd	a5,16(a3)
}
    80005e08:	00813403          	ld	s0,8(sp)
    80005e0c:	01010113          	addi	sp,sp,16
    80005e10:	00008067          	ret

0000000080005e14 <_ZN3TCB21updateSleepThreadListEv>:
void TCB::updateSleepThreadList() {
    80005e14:	fe010113          	addi	sp,sp,-32
    80005e18:	00113c23          	sd	ra,24(sp)
    80005e1c:	00813823          	sd	s0,16(sp)
    80005e20:	00913423          	sd	s1,8(sp)
    80005e24:	01213023          	sd	s2,0(sp)
    80005e28:	02010413          	addi	s0,sp,32
    if (!sleepHead || !sleepTail) return;
    80005e2c:	00006497          	auipc	s1,0x6
    80005e30:	f6c4b483          	ld	s1,-148(s1) # 8000bd98 <_ZN3TCB9sleepHeadE>
    80005e34:	02048263          	beqz	s1,80005e58 <_ZN3TCB21updateSleepThreadListEv+0x44>
    80005e38:	00006797          	auipc	a5,0x6
    80005e3c:	f687b783          	ld	a5,-152(a5) # 8000bda0 <_ZN3TCB9sleepTailE>
    80005e40:	00078c63          	beqz	a5,80005e58 <_ZN3TCB21updateSleepThreadListEv+0x44>
    uint64 getSleepTime() const { return sleepTime; }
    80005e44:	0484b783          	ld	a5,72(s1)
    sleepHead->setSleepTime(sleepHead->getSleepTime() - 1);
    80005e48:	fff78793          	addi	a5,a5,-1
    void setSleepTime(uint64 time) { sleepTime = time; }
    80005e4c:	04f4b423          	sd	a5,72(s1)
    TCB* curr = sleepHead;
    80005e50:	03c0006f          	j	80005e8c <_ZN3TCB21updateSleepThreadListEv+0x78>
    if (!curr) sleepHead = sleepTail = nullptr;
    80005e54:	04048e63          	beqz	s1,80005eb0 <_ZN3TCB21updateSleepThreadListEv+0x9c>
}
    80005e58:	01813083          	ld	ra,24(sp)
    80005e5c:	01013403          	ld	s0,16(sp)
    80005e60:	00813483          	ld	s1,8(sp)
    80005e64:	00013903          	ld	s2,0(sp)
    80005e68:	02010113          	addi	sp,sp,32
    80005e6c:	00008067          	ret
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80005e70:	0404b823          	sd	zero,80(s1)
        Scheduler::getInstance().put(oldCurr);
    80005e74:	ffffc097          	auipc	ra,0xffffc
    80005e78:	1ac080e7          	jalr	428(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    80005e7c:	00048593          	mv	a1,s1
    80005e80:	ffffc097          	auipc	ra,0xffffc
    80005e84:	1ec080e7          	jalr	492(ra) # 8000206c <_ZN9Scheduler3putEP3TCB>
        curr = curr->getNextSleepThread();
    80005e88:	00090493          	mv	s1,s2
    while (curr && curr->getSleepTime() == 0) {
    80005e8c:	fc0484e3          	beqz	s1,80005e54 <_ZN3TCB21updateSleepThreadListEv+0x40>
    uint64 getSleepTime() const { return sleepTime; }
    80005e90:	0484b783          	ld	a5,72(s1)
    80005e94:	fc0790e3          	bnez	a5,80005e54 <_ZN3TCB21updateSleepThreadListEv+0x40>
    TCB* getNextSleepThread() const { return sleepNextThread; }
    80005e98:	0504b903          	ld	s2,80(s1)
        sleepHead = curr;
    80005e9c:	00006797          	auipc	a5,0x6
    80005ea0:	ef27be23          	sd	s2,-260(a5) # 8000bd98 <_ZN3TCB9sleepHeadE>
        if (curr) curr->setPrevSleepThread(nullptr);
    80005ea4:	fc0906e3          	beqz	s2,80005e70 <_ZN3TCB21updateSleepThreadListEv+0x5c>
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80005ea8:	04093c23          	sd	zero,88(s2)
    80005eac:	fc5ff06f          	j	80005e70 <_ZN3TCB21updateSleepThreadListEv+0x5c>
    if (!curr) sleepHead = sleepTail = nullptr;
    80005eb0:	00006797          	auipc	a5,0x6
    80005eb4:	ee078793          	addi	a5,a5,-288 # 8000bd90 <_ZN3TCB13runningThreadE>
    80005eb8:	0007b823          	sd	zero,16(a5)
    80005ebc:	0007b423          	sd	zero,8(a5)
    80005ec0:	f99ff06f          	j	80005e58 <_ZN3TCB21updateSleepThreadListEv+0x44>

0000000080005ec4 <_ZN3TCBnwEm>:
void* TCB::operator new(size_t n) {
    80005ec4:	fe010113          	addi	sp,sp,-32
    80005ec8:	00113c23          	sd	ra,24(sp)
    80005ecc:	00813823          	sd	s0,16(sp)
    80005ed0:	00913423          	sd	s1,8(sp)
    80005ed4:	02010413          	addi	s0,sp,32
    80005ed8:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80005edc:	ffffc097          	auipc	ra,0xffffc
    80005ee0:	dbc080e7          	jalr	-580(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005ee4:	00048593          	mv	a1,s1
    80005ee8:	ffffc097          	auipc	ra,0xffffc
    80005eec:	e0c080e7          	jalr	-500(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
}
    80005ef0:	01813083          	ld	ra,24(sp)
    80005ef4:	01013403          	ld	s0,16(sp)
    80005ef8:	00813483          	ld	s1,8(sp)
    80005efc:	02010113          	addi	sp,sp,32
    80005f00:	00008067          	ret

0000000080005f04 <_ZN3TCBnaEm>:
void* TCB::operator new[](size_t n) {
    80005f04:	fe010113          	addi	sp,sp,-32
    80005f08:	00113c23          	sd	ra,24(sp)
    80005f0c:	00813823          	sd	s0,16(sp)
    80005f10:	00913423          	sd	s1,8(sp)
    80005f14:	02010413          	addi	s0,sp,32
    80005f18:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80005f1c:	ffffc097          	auipc	ra,0xffffc
    80005f20:	d7c080e7          	jalr	-644(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005f24:	00048593          	mv	a1,s1
    80005f28:	ffffc097          	auipc	ra,0xffffc
    80005f2c:	dcc080e7          	jalr	-564(ra) # 80001cf4 <_ZN15MemoryAllocator15allocateSegmentEm>
}
    80005f30:	01813083          	ld	ra,24(sp)
    80005f34:	01013403          	ld	s0,16(sp)
    80005f38:	00813483          	ld	s1,8(sp)
    80005f3c:	02010113          	addi	sp,sp,32
    80005f40:	00008067          	ret

0000000080005f44 <_ZN3TCBdlEPv>:
void TCB::operator delete(void *ptr) {
    80005f44:	fe010113          	addi	sp,sp,-32
    80005f48:	00113c23          	sd	ra,24(sp)
    80005f4c:	00813823          	sd	s0,16(sp)
    80005f50:	00913423          	sd	s1,8(sp)
    80005f54:	02010413          	addi	s0,sp,32
    80005f58:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80005f5c:	ffffc097          	auipc	ra,0xffffc
    80005f60:	d3c080e7          	jalr	-708(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005f64:	00048593          	mv	a1,s1
    80005f68:	ffffc097          	auipc	ra,0xffffc
    80005f6c:	e70080e7          	jalr	-400(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80005f70:	01813083          	ld	ra,24(sp)
    80005f74:	01013403          	ld	s0,16(sp)
    80005f78:	00813483          	ld	s1,8(sp)
    80005f7c:	02010113          	addi	sp,sp,32
    80005f80:	00008067          	ret

0000000080005f84 <_ZN3TCBdaEPv>:
void TCB::operator delete[](void *ptr) {
    80005f84:	fe010113          	addi	sp,sp,-32
    80005f88:	00113c23          	sd	ra,24(sp)
    80005f8c:	00813823          	sd	s0,16(sp)
    80005f90:	00913423          	sd	s1,8(sp)
    80005f94:	02010413          	addi	s0,sp,32
    80005f98:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80005f9c:	ffffc097          	auipc	ra,0xffffc
    80005fa0:	cfc080e7          	jalr	-772(ra) # 80001c98 <_ZN15MemoryAllocator11getInstanceEv>
    80005fa4:	00048593          	mv	a1,s1
    80005fa8:	ffffc097          	auipc	ra,0xffffc
    80005fac:	e30080e7          	jalr	-464(ra) # 80001dd8 <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80005fb0:	01813083          	ld	ra,24(sp)
    80005fb4:	01013403          	ld	s0,16(sp)
    80005fb8:	00813483          	ld	s1,8(sp)
    80005fbc:	02010113          	addi	sp,sp,32
    80005fc0:	00008067          	ret

0000000080005fc4 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_>:
void TCB::initializeClassAttributes(TCB* thisPointer, Body body, void* arg, void* stack) {
    80005fc4:	ff010113          	addi	sp,sp,-16
    80005fc8:	00813423          	sd	s0,8(sp)
    80005fcc:	01010413          	addi	s0,sp,16
    thisPointer->body = body;
    80005fd0:	00b53023          	sd	a1,0(a0)
    thisPointer->arg = arg;
    80005fd4:	00c53423          	sd	a2,8(a0)
    thisPointer->stack = static_cast<uint64*>(stack);
    80005fd8:	00d53c23          	sd	a3,24(a0)
    thisPointer->context.ra = reinterpret_cast<uint64>(&threadWrapper);
    80005fdc:	00000797          	auipc	a5,0x0
    80005fe0:	cfc78793          	addi	a5,a5,-772 # 80005cd8 <_ZN3TCB13threadWrapperEv>
    80005fe4:	02f53023          	sd	a5,32(a0)
    thisPointer->context.sp = stack ? reinterpret_cast<uint64>(&static_cast<uint64*>(stack)[DEFAULT_STACK_SIZE / sizeof(uint64)]) : 0;
    80005fe8:	02068c63          	beqz	a3,80006020 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_+0x5c>
    80005fec:	000017b7          	lui	a5,0x1
    80005ff0:	00f686b3          	add	a3,a3,a5
    80005ff4:	02d53423          	sd	a3,40(a0)
    thisPointer->finished = false;
    80005ff8:	02050823          	sb	zero,48(a0)
    thisPointer->threadId = TCB::staticThreadId++;
    80005ffc:	00006717          	auipc	a4,0x6
    80006000:	d9470713          	addi	a4,a4,-620 # 8000bd90 <_ZN3TCB13runningThreadE>
    80006004:	01872783          	lw	a5,24(a4)
    80006008:	0017869b          	addiw	a3,a5,1
    8000600c:	00d72c23          	sw	a3,24(a4)
    80006010:	06f52623          	sw	a5,108(a0)
}
    80006014:	00813403          	ld	s0,8(sp)
    80006018:	01010113          	addi	sp,sp,16
    8000601c:	00008067          	ret
    thisPointer->context.sp = stack ? reinterpret_cast<uint64>(&static_cast<uint64*>(stack)[DEFAULT_STACK_SIZE / sizeof(uint64)]) : 0;
    80006020:	00000693          	li	a3,0
    80006024:	fd1ff06f          	j	80005ff4 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_+0x30>

0000000080006028 <_ZN3TCBC1EPFvPvES0_S0_>:
TCB::TCB(Body body, void* arg, void* stack) {
    80006028:	fe010113          	addi	sp,sp,-32
    8000602c:	00113c23          	sd	ra,24(sp)
    80006030:	00813823          	sd	s0,16(sp)
    80006034:	00913423          	sd	s1,8(sp)
    80006038:	01213023          	sd	s2,0(sp)
    8000603c:	02010413          	addi	s0,sp,32
    80006040:	00050493          	mv	s1,a0
    80006044:	00058913          	mv	s2,a1
    80006048:	00200793          	li	a5,2
    8000604c:	00f53823          	sd	a5,16(a0)
    80006050:	02053023          	sd	zero,32(a0)
    80006054:	02053423          	sd	zero,40(a0)
    80006058:	02053c23          	sd	zero,56(a0)
    8000605c:	04053023          	sd	zero,64(a0)
    80006060:	04053423          	sd	zero,72(a0)
    80006064:	04053823          	sd	zero,80(a0)
    80006068:	04053c23          	sd	zero,88(a0)
    8000606c:	06053023          	sd	zero,96(a0)
    80006070:	06050423          	sb	zero,104(a0)
    initializeClassAttributes(this, body, arg, stack);
    80006074:	00000097          	auipc	ra,0x0
    80006078:	f50080e7          	jalr	-176(ra) # 80005fc4 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_>
    if (body) Scheduler::getInstance().put(this);
    8000607c:	00090c63          	beqz	s2,80006094 <_ZN3TCBC1EPFvPvES0_S0_+0x6c>
    80006080:	ffffc097          	auipc	ra,0xffffc
    80006084:	fa0080e7          	jalr	-96(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    80006088:	00048593          	mv	a1,s1
    8000608c:	ffffc097          	auipc	ra,0xffffc
    80006090:	fe0080e7          	jalr	-32(ra) # 8000206c <_ZN9Scheduler3putEP3TCB>
}
    80006094:	01813083          	ld	ra,24(sp)
    80006098:	01013403          	ld	s0,16(sp)
    8000609c:	00813483          	ld	s1,8(sp)
    800060a0:	00013903          	ld	s2,0(sp)
    800060a4:	02010113          	addi	sp,sp,32
    800060a8:	00008067          	ret

00000000800060ac <_ZN3TCBC1EPFvPvES0_S0_b>:
TCB::TCB(Body body, void* arg, void* stack, bool cppApi) {
    800060ac:	ff010113          	addi	sp,sp,-16
    800060b0:	00113423          	sd	ra,8(sp)
    800060b4:	00813023          	sd	s0,0(sp)
    800060b8:	01010413          	addi	s0,sp,16
    800060bc:	00200713          	li	a4,2
    800060c0:	00e53823          	sd	a4,16(a0)
    800060c4:	02053023          	sd	zero,32(a0)
    800060c8:	02053423          	sd	zero,40(a0)
    800060cc:	02053c23          	sd	zero,56(a0)
    800060d0:	04053023          	sd	zero,64(a0)
    800060d4:	04053423          	sd	zero,72(a0)
    800060d8:	04053823          	sd	zero,80(a0)
    800060dc:	04053c23          	sd	zero,88(a0)
    800060e0:	06053023          	sd	zero,96(a0)
    800060e4:	06050423          	sb	zero,104(a0)
    initializeClassAttributes(this, body, arg, stack);
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	edc080e7          	jalr	-292(ra) # 80005fc4 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_>
}
    800060f0:	00813083          	ld	ra,8(sp)
    800060f4:	00013403          	ld	s0,0(sp)
    800060f8:	01010113          	addi	sp,sp,16
    800060fc:	00008067          	ret

0000000080006100 <_ZN3TCB12createThreadEPFvPvES0_S0_b>:
TCB* TCB::createThread(Body body, void* arg, void* stack, bool cppApi) {
    80006100:	fc010113          	addi	sp,sp,-64
    80006104:	02113c23          	sd	ra,56(sp)
    80006108:	02813823          	sd	s0,48(sp)
    8000610c:	02913423          	sd	s1,40(sp)
    80006110:	03213023          	sd	s2,32(sp)
    80006114:	01313c23          	sd	s3,24(sp)
    80006118:	01413823          	sd	s4,16(sp)
    8000611c:	01513423          	sd	s5,8(sp)
    80006120:	04010413          	addi	s0,sp,64
    80006124:	00050993          	mv	s3,a0
    80006128:	00058a13          	mv	s4,a1
    8000612c:	00060a93          	mv	s5,a2
    if (cppApi) {
    80006130:	04068c63          	beqz	a3,80006188 <_ZN3TCB12createThreadEPFvPvES0_S0_b+0x88>
    80006134:	00068493          	mv	s1,a3
        return new TCB(body, arg, stack, cppApi);
    80006138:	07000513          	li	a0,112
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	d88080e7          	jalr	-632(ra) # 80005ec4 <_ZN3TCBnwEm>
    80006144:	00050913          	mv	s2,a0
    80006148:	00048713          	mv	a4,s1
    8000614c:	000a8693          	mv	a3,s5
    80006150:	000a0613          	mv	a2,s4
    80006154:	00098593          	mv	a1,s3
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	f54080e7          	jalr	-172(ra) # 800060ac <_ZN3TCBC1EPFvPvES0_S0_b>
}
    80006160:	00090513          	mv	a0,s2
    80006164:	03813083          	ld	ra,56(sp)
    80006168:	03013403          	ld	s0,48(sp)
    8000616c:	02813483          	ld	s1,40(sp)
    80006170:	02013903          	ld	s2,32(sp)
    80006174:	01813983          	ld	s3,24(sp)
    80006178:	01013a03          	ld	s4,16(sp)
    8000617c:	00813a83          	ld	s5,8(sp)
    80006180:	04010113          	addi	sp,sp,64
    80006184:	00008067          	ret
        return new TCB(body, arg, stack);
    80006188:	07000513          	li	a0,112
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	d38080e7          	jalr	-712(ra) # 80005ec4 <_ZN3TCBnwEm>
    80006194:	00050913          	mv	s2,a0
    80006198:	000a8693          	mv	a3,s5
    8000619c:	000a0613          	mv	a2,s4
    800061a0:	00098593          	mv	a1,s3
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	e84080e7          	jalr	-380(ra) # 80006028 <_ZN3TCBC1EPFvPvES0_S0_>
    800061ac:	fb5ff06f          	j	80006160 <_ZN3TCB12createThreadEPFvPvES0_S0_b+0x60>
    800061b0:	00050493          	mv	s1,a0
    800061b4:	00090513          	mv	a0,s2
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	d8c080e7          	jalr	-628(ra) # 80005f44 <_ZN3TCBdlEPv>
    800061c0:	00048513          	mv	a0,s1
    800061c4:	00007097          	auipc	ra,0x7
    800061c8:	f64080e7          	jalr	-156(ra) # 8000d128 <_Unwind_Resume>

00000000800061cc <_ZN3TCB13contextSwitchEPNS_7ContextES1_>:

void TCB::contextSwitch(TCB::Context *oldContext, TCB::Context *runningContext) {
    800061cc:	ff010113          	addi	sp,sp,-16
    800061d0:	00813423          	sd	s0,8(sp)
    800061d4:	01010413          	addi	s0,sp,16
    // prvi parametar funkcije (pokazivac na strukturu stare niti - oldContext) se prosledjuje kroz registar a0
    // cuvanje registara ra i sp tekuce niti u njenoj strukturi
    __asm__ volatile ("sd ra, 0*8(a0)");
    800061d8:	00153023          	sd	ra,0(a0)
    __asm__ volatile ("sd sp, 1*8(a0)");
    800061dc:	00253423          	sd	sp,8(a0)

    // drugi parametar funkcije (pokazivac na strukturu nove niti - runningContext) se prosledjuje kroz registar a1
    // restauracija registara ra i sp nove niti iz njene strukture
    __asm__ volatile ("ld ra, 0*8(a1)");
    800061e0:	0005b083          	ld	ra,0(a1)
    __asm__ volatile ("ld sp, 1*8(a1)");
    800061e4:	0085b103          	ld	sp,8(a1)
    800061e8:	00813403          	ld	s0,8(sp)
    800061ec:	01010113          	addi	sp,sp,16
    800061f0:	00008067          	ret

00000000800061f4 <_ZN3TCB8dispatchEv>:
void TCB::dispatch() {
    800061f4:	fe010113          	addi	sp,sp,-32
    800061f8:	00113c23          	sd	ra,24(sp)
    800061fc:	00813823          	sd	s0,16(sp)
    80006200:	00913423          	sd	s1,8(sp)
    80006204:	02010413          	addi	s0,sp,32
    TCB* oldThread = runningThread;
    80006208:	00006497          	auipc	s1,0x6
    8000620c:	b884b483          	ld	s1,-1144(s1) # 8000bd90 <_ZN3TCB13runningThreadE>
    bool getFinished() const { return finished; }
    80006210:	0304c783          	lbu	a5,48(s1)
    if (!oldThread->getFinished()) Scheduler::getInstance().put(oldThread);
    80006214:	04078063          	beqz	a5,80006254 <_ZN3TCB8dispatchEv+0x60>
    runningThread = Scheduler::getInstance().get();
    80006218:	ffffc097          	auipc	ra,0xffffc
    8000621c:	e08080e7          	jalr	-504(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    80006220:	ffffc097          	auipc	ra,0xffffc
    80006224:	e20080e7          	jalr	-480(ra) # 80002040 <_ZN9Scheduler3getEv>
    80006228:	00006797          	auipc	a5,0x6
    8000622c:	b6a7b423          	sd	a0,-1176(a5) # 8000bd90 <_ZN3TCB13runningThreadE>
    TCB::contextSwitch(&oldThread->context, &runningThread->context);
    80006230:	02050593          	addi	a1,a0,32
    80006234:	02048513          	addi	a0,s1,32
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	f94080e7          	jalr	-108(ra) # 800061cc <_ZN3TCB13contextSwitchEPNS_7ContextES1_>
}
    80006240:	01813083          	ld	ra,24(sp)
    80006244:	01013403          	ld	s0,16(sp)
    80006248:	00813483          	ld	s1,8(sp)
    8000624c:	02010113          	addi	sp,sp,32
    80006250:	00008067          	ret
    if (!oldThread->getFinished()) Scheduler::getInstance().put(oldThread);
    80006254:	ffffc097          	auipc	ra,0xffffc
    80006258:	dcc080e7          	jalr	-564(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    8000625c:	00048593          	mv	a1,s1
    80006260:	ffffc097          	auipc	ra,0xffffc
    80006264:	e0c080e7          	jalr	-500(ra) # 8000206c <_ZN9Scheduler3putEP3TCB>
    80006268:	fb1ff06f          	j	80006218 <_ZN3TCB8dispatchEv+0x24>

000000008000626c <_ZN3TCB20suspendCurrentThreadEv>:
void TCB::suspendCurrentThread() {
    8000626c:	fe010113          	addi	sp,sp,-32
    80006270:	00113c23          	sd	ra,24(sp)
    80006274:	00813823          	sd	s0,16(sp)
    80006278:	00913423          	sd	s1,8(sp)
    8000627c:	01213023          	sd	s2,0(sp)
    80006280:	02010413          	addi	s0,sp,32
    TCB* oldThread = TCB::runningThread;
    80006284:	00006497          	auipc	s1,0x6
    80006288:	b0c48493          	addi	s1,s1,-1268 # 8000bd90 <_ZN3TCB13runningThreadE>
    8000628c:	0004b903          	ld	s2,0(s1)
    TCB::runningThread = Scheduler::getInstance().get();
    80006290:	ffffc097          	auipc	ra,0xffffc
    80006294:	d90080e7          	jalr	-624(ra) # 80002020 <_ZN9Scheduler11getInstanceEv>
    80006298:	ffffc097          	auipc	ra,0xffffc
    8000629c:	da8080e7          	jalr	-600(ra) # 80002040 <_ZN9Scheduler3getEv>
    800062a0:	00a4b023          	sd	a0,0(s1)
    TCB::contextSwitch(&oldThread->context, &TCB::runningThread->context);
    800062a4:	02050593          	addi	a1,a0,32
    800062a8:	02090513          	addi	a0,s2,32
    800062ac:	00000097          	auipc	ra,0x0
    800062b0:	f20080e7          	jalr	-224(ra) # 800061cc <_ZN3TCB13contextSwitchEPNS_7ContextES1_>
}
    800062b4:	01813083          	ld	ra,24(sp)
    800062b8:	01013403          	ld	s0,16(sp)
    800062bc:	00813483          	ld	s1,8(sp)
    800062c0:	00013903          	ld	s2,0(sp)
    800062c4:	02010113          	addi	sp,sp,32
    800062c8:	00008067          	ret

00000000800062cc <_Z9mem_allocm>:
#include "../../../h/Code/SystemCalls/syscall_c.h"

void* mem_alloc(size_t size) { // size je broj bajtova koje je korisnik trazio - to cu zaokruziti na ceo broj blokova tako da korisnik dobije tacno toliko ili cak i vise memorije
    800062cc:	ff010113          	addi	sp,sp,-16
    800062d0:	00113423          	sd	ra,8(sp)
    800062d4:	00813023          	sd	s0,0(sp)
    800062d8:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x01; // kod ovog sistemskog poziva
    size_t numberOfBlocks = size % MEM_BLOCK_SIZE ? size / MEM_BLOCK_SIZE + 1 : size / MEM_BLOCK_SIZE; // bajtovi zaokruzeni na blokove velicine MEM_BLOCK_SIZE
    800062dc:	03f57793          	andi	a5,a0,63
    800062e0:	04078463          	beqz	a5,80006328 <_Z9mem_allocm+0x5c>
    800062e4:	00655513          	srli	a0,a0,0x6
    800062e8:	00150793          	addi	a5,a0,1

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800062ec:	00006517          	auipc	a0,0x6
    800062f0:	acc50513          	addi	a0,a0,-1332 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800062f4:	00100713          	li	a4,1
    800062f8:	00e53023          	sd	a4,0(a0)
    arguments.arg1 = numberOfBlocks;
    800062fc:	00f53423          	sd	a5,8(a0)
    arguments.arg2 = 0;
    80006300:	00053823          	sd	zero,16(a0)
    arguments.arg3 = 0;
    80006304:	00053c23          	sd	zero,24(a0)
    arguments.arg4 = 0;
    80006308:	02053023          	sd	zero,32(a0)
    prepareArgsAndEcall(&arguments);
    8000630c:	00000097          	auipc	ra,0x0
    80006310:	658080e7          	jalr	1624(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde adresa alocirane memorije, to upisujem u ptr i vracam korisniku
    void* ptr;
    __asm__ volatile ("mv a0,%[ptr]" : [ptr] "=r"(ptr));
    80006314:	00050513          	mv	a0,a0
    return ptr;
}
    80006318:	00813083          	ld	ra,8(sp)
    8000631c:	00013403          	ld	s0,0(sp)
    80006320:	01010113          	addi	sp,sp,16
    80006324:	00008067          	ret
    size_t numberOfBlocks = size % MEM_BLOCK_SIZE ? size / MEM_BLOCK_SIZE + 1 : size / MEM_BLOCK_SIZE; // bajtovi zaokruzeni na blokove velicine MEM_BLOCK_SIZE
    80006328:	00655793          	srli	a5,a0,0x6
    8000632c:	fc1ff06f          	j	800062ec <_Z9mem_allocm+0x20>

0000000080006330 <_Z8mem_freePv>:

int mem_free(void* ptr) {
    80006330:	ff010113          	addi	sp,sp,-16
    80006334:	00113423          	sd	ra,8(sp)
    80006338:	00813023          	sd	s0,0(sp)
    8000633c:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x02; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006340:	00006797          	auipc	a5,0x6
    80006344:	a7878793          	addi	a5,a5,-1416 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    80006348:	00200713          	li	a4,2
    8000634c:	02e7b423          	sd	a4,40(a5)
    arguments.arg1 = reinterpret_cast<uint64>(ptr);
    80006350:	02a7b823          	sd	a0,48(a5)
    arguments.arg2 = 0;
    80006354:	0207bc23          	sd	zero,56(a5)
    arguments.arg3 = 0;
    80006358:	0407b023          	sd	zero,64(a5)
    arguments.arg4 = 0;
    8000635c:	0407b423          	sd	zero,72(a5)
    prepareArgsAndEcall(&arguments);
    80006360:	00006517          	auipc	a0,0x6
    80006364:	a8050513          	addi	a0,a0,-1408 # 8000bde0 <_ZZ8mem_freePvE9arguments>
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	5fc080e7          	jalr	1532(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    80006370:	00050513          	mv	a0,a0
    return successInfo;
}
    80006374:	0005051b          	sext.w	a0,a0
    80006378:	00813083          	ld	ra,8(sp)
    8000637c:	00013403          	ld	s0,0(sp)
    80006380:	01010113          	addi	sp,sp,16
    80006384:	00008067          	ret

0000000080006388 <_Z13thread_createPP6threadPFvPvES2_>:

int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg) { // handle je dvostruki pokazivac u koji treba upisati adresu kreirane niti
    80006388:	fd010113          	addi	sp,sp,-48
    8000638c:	02113423          	sd	ra,40(sp)
    80006390:	02813023          	sd	s0,32(sp)
    80006394:	00913c23          	sd	s1,24(sp)
    80006398:	01213823          	sd	s2,16(sp)
    8000639c:	01313423          	sd	s3,8(sp)
    800063a0:	03010413          	addi	s0,sp,48
    800063a4:	00050913          	mv	s2,a0
    800063a8:	00058493          	mv	s1,a1
    800063ac:	00060993          	mv	s3,a2
    uint64 sysCallCode = 0x11; // kod ovog sistemskog poziva
    void* stack;
    if (!start_routine) { // ako je start_routine nullptr, znaci treba pokrenuti nit nad main-om, a za to ne treba da alociramo stek jer ga vec main ima
    800063b0:	06058663          	beqz	a1,8000641c <_Z13thread_createPP6threadPFvPvES2_+0x94>
        stack = nullptr;
    } else {
        // hocemo da na steku ima mesta za DEFAULT_STACK_SIZE (4096) bajtova - ima mesta za 512 vrednosti velicine uint64 (8 bajtova)
        stack = mem_alloc(DEFAULT_STACK_SIZE);
    800063b4:	00001537          	lui	a0,0x1
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	f14080e7          	jalr	-236(ra) # 800062cc <_Z9mem_allocm>
        if (!stack) return -1;
    800063c0:	06050263          	beqz	a0,80006424 <_Z13thread_createPP6threadPFvPvES2_+0x9c>
    }

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800063c4:	00006797          	auipc	a5,0x6
    800063c8:	9f478793          	addi	a5,a5,-1548 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800063cc:	01100713          	li	a4,17
    800063d0:	04e7b823          	sd	a4,80(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreirane niti
    800063d4:	0527bc23          	sd	s2,88(a5)
    arguments.arg2 = reinterpret_cast<uint64>(start_routine); // adresa funkcije koju treba da izvrsava novokreirana nit
    800063d8:	0697b023          	sd	s1,96(a5)
    arguments.arg3 = reinterpret_cast<uint64>(arg); // adresa argumenta koji treba proslediti funkciji start_routine
    800063dc:	0737b423          	sd	s3,104(a5)
    arguments.arg4 = reinterpret_cast<uint64>(stack); // adresa na kojoj je alociran stek za ovu nit koju treba napraviti
    800063e0:	06a7b823          	sd	a0,112(a5)
    prepareArgsAndEcall(&arguments);
    800063e4:	00006517          	auipc	a0,0x6
    800063e8:	a2450513          	addi	a0,a0,-1500 # 8000be08 <_ZZ13thread_createPP6threadPFvPvES2_E9arguments>
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	578080e7          	jalr	1400(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // slucaj kada je neuspesno alociran prostor za novu nit (u prekidnoj rutini se poziva TCB::createThread)
    if (*handle == nullptr) return -1;
    800063f4:	00093783          	ld	a5,0(s2)
    800063f8:	02078a63          	beqz	a5,8000642c <_Z13thread_createPP6threadPFvPvES2_+0xa4>

    return 0;
    800063fc:	00000513          	li	a0,0
}
    80006400:	02813083          	ld	ra,40(sp)
    80006404:	02013403          	ld	s0,32(sp)
    80006408:	01813483          	ld	s1,24(sp)
    8000640c:	01013903          	ld	s2,16(sp)
    80006410:	00813983          	ld	s3,8(sp)
    80006414:	03010113          	addi	sp,sp,48
    80006418:	00008067          	ret
        stack = nullptr;
    8000641c:	00000513          	li	a0,0
    80006420:	fa5ff06f          	j	800063c4 <_Z13thread_createPP6threadPFvPvES2_+0x3c>
        if (!stack) return -1;
    80006424:	fff00513          	li	a0,-1
    80006428:	fd9ff06f          	j	80006400 <_Z13thread_createPP6threadPFvPvES2_+0x78>
    if (*handle == nullptr) return -1;
    8000642c:	fff00513          	li	a0,-1
    80006430:	fd1ff06f          	j	80006400 <_Z13thread_createPP6threadPFvPvES2_+0x78>

0000000080006434 <_Z11thread_exitv>:

int thread_exit() {
    80006434:	ff010113          	addi	sp,sp,-16
    80006438:	00113423          	sd	ra,8(sp)
    8000643c:	00813023          	sd	s0,0(sp)
    80006440:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x12; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006444:	00006797          	auipc	a5,0x6
    80006448:	97478793          	addi	a5,a5,-1676 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    8000644c:	01200713          	li	a4,18
    80006450:	06e7bc23          	sd	a4,120(a5)
    arguments.arg1 = 0;
    80006454:	0807b023          	sd	zero,128(a5)
    arguments.arg2 = 0;
    80006458:	0807b423          	sd	zero,136(a5)
    arguments.arg3 = 0;
    8000645c:	0807b823          	sd	zero,144(a5)
    arguments.arg4 = 0;
    80006460:	0807bc23          	sd	zero,152(a5)
    prepareArgsAndEcall(&arguments);
    80006464:	00006517          	auipc	a0,0x6
    80006468:	9cc50513          	addi	a0,a0,-1588 # 8000be30 <_ZZ11thread_exitvE9arguments>
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	4f8080e7          	jalr	1272(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // ukoliko se sistemski poziv thread_exit vrati ovde, to znaci da nit nije uspesno ugasena i da se nije promenio kontekst, zato
    // se vraca definitivno kod greske u tom slucaju
    return -1;
}
    80006474:	fff00513          	li	a0,-1
    80006478:	00813083          	ld	ra,8(sp)
    8000647c:	00013403          	ld	s0,0(sp)
    80006480:	01010113          	addi	sp,sp,16
    80006484:	00008067          	ret

0000000080006488 <_Z15thread_dispatchv>:

void thread_dispatch() {
    80006488:	ff010113          	addi	sp,sp,-16
    8000648c:	00113423          	sd	ra,8(sp)
    80006490:	00813023          	sd	s0,0(sp)
    80006494:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x13; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006498:	00006797          	auipc	a5,0x6
    8000649c:	92078793          	addi	a5,a5,-1760 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800064a0:	01300713          	li	a4,19
    800064a4:	0ae7b023          	sd	a4,160(a5)
    arguments.arg1 = 0;
    800064a8:	0a07b423          	sd	zero,168(a5)
    arguments.arg2 = 0;
    800064ac:	0a07b823          	sd	zero,176(a5)
    arguments.arg3 = 0;
    800064b0:	0a07bc23          	sd	zero,184(a5)
    arguments.arg4 = 0;
    800064b4:	0c07b023          	sd	zero,192(a5)
    prepareArgsAndEcall(&arguments);
    800064b8:	00006517          	auipc	a0,0x6
    800064bc:	9a050513          	addi	a0,a0,-1632 # 8000be58 <_ZZ15thread_dispatchvE9arguments>
    800064c0:	00000097          	auipc	ra,0x0
    800064c4:	4a4080e7          	jalr	1188(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>
}
    800064c8:	00813083          	ld	ra,8(sp)
    800064cc:	00013403          	ld	s0,0(sp)
    800064d0:	01010113          	addi	sp,sp,16
    800064d4:	00008067          	ret

00000000800064d8 <_Z17thread_create_cppPP6threadPFvPvES2_>:

int thread_create_cpp(thread_t* handle, void(*start_routine)(void*), void* arg) {
    800064d8:	fd010113          	addi	sp,sp,-48
    800064dc:	02113423          	sd	ra,40(sp)
    800064e0:	02813023          	sd	s0,32(sp)
    800064e4:	00913c23          	sd	s1,24(sp)
    800064e8:	01213823          	sd	s2,16(sp)
    800064ec:	01313423          	sd	s3,8(sp)
    800064f0:	03010413          	addi	s0,sp,48
    800064f4:	00050913          	mv	s2,a0
    800064f8:	00058493          	mv	s1,a1
    800064fc:	00060993          	mv	s3,a2
    uint64 sysCallCode = 0x14; // kod ovog sistemskog poziva
    void* stack;
    if (!start_routine) { // ako je start_routine nullptr, znaci treba pokrenuti nit nad main-om, a za to ne treba da alociramo stek jer ga vec main ima
    80006500:	06058663          	beqz	a1,8000656c <_Z17thread_create_cppPP6threadPFvPvES2_+0x94>
        stack = nullptr;
    } else {
        // hocemo da na steku ima mesta za DEFAULT_STACK_SIZE (4096) bajtova - ima mesta za 512 vrednosti velicine uint64 (8 bajtova)
        stack = mem_alloc(DEFAULT_STACK_SIZE);
    80006504:	00001537          	lui	a0,0x1
    80006508:	00000097          	auipc	ra,0x0
    8000650c:	dc4080e7          	jalr	-572(ra) # 800062cc <_Z9mem_allocm>
        if (!stack) return -1;
    80006510:	06050263          	beqz	a0,80006574 <_Z17thread_create_cppPP6threadPFvPvES2_+0x9c>
    }

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006514:	00006797          	auipc	a5,0x6
    80006518:	8a478793          	addi	a5,a5,-1884 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    8000651c:	01400713          	li	a4,20
    80006520:	0ce7b423          	sd	a4,200(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreirane niti
    80006524:	0d27b823          	sd	s2,208(a5)
    arguments.arg2 = reinterpret_cast<uint64>(start_routine); // adresa funkcije koju treba da izvrsava novokreirana nit
    80006528:	0c97bc23          	sd	s1,216(a5)
    arguments.arg3 = reinterpret_cast<uint64>(arg); // adresa argumenta koji treba proslediti funkciji start_routine
    8000652c:	0f37b023          	sd	s3,224(a5)
    arguments.arg4 = reinterpret_cast<uint64>(stack); // adresa na kojoj je alociran stek za ovu nit koju treba napraviti
    80006530:	0ea7b423          	sd	a0,232(a5)
    prepareArgsAndEcall(&arguments);
    80006534:	00006517          	auipc	a0,0x6
    80006538:	94c50513          	addi	a0,a0,-1716 # 8000be80 <_ZZ17thread_create_cppPP6threadPFvPvES2_E9arguments>
    8000653c:	00000097          	auipc	ra,0x0
    80006540:	428080e7          	jalr	1064(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // slucaj kada je neuspesno alociran prostor za novu nit (u prekidnoj rutini se poziva TCB::createThread)
    if (*handle == nullptr) return -1;
    80006544:	00093783          	ld	a5,0(s2)
    80006548:	02078a63          	beqz	a5,8000657c <_Z17thread_create_cppPP6threadPFvPvES2_+0xa4>

    return 0;
    8000654c:	00000513          	li	a0,0
}
    80006550:	02813083          	ld	ra,40(sp)
    80006554:	02013403          	ld	s0,32(sp)
    80006558:	01813483          	ld	s1,24(sp)
    8000655c:	01013903          	ld	s2,16(sp)
    80006560:	00813983          	ld	s3,8(sp)
    80006564:	03010113          	addi	sp,sp,48
    80006568:	00008067          	ret
        stack = nullptr;
    8000656c:	00000513          	li	a0,0
    80006570:	fa5ff06f          	j	80006514 <_Z17thread_create_cppPP6threadPFvPvES2_+0x3c>
        if (!stack) return -1;
    80006574:	fff00513          	li	a0,-1
    80006578:	fd9ff06f          	j	80006550 <_Z17thread_create_cppPP6threadPFvPvES2_+0x78>
    if (*handle == nullptr) return -1;
    8000657c:	fff00513          	li	a0,-1
    80006580:	fd1ff06f          	j	80006550 <_Z17thread_create_cppPP6threadPFvPvES2_+0x78>

0000000080006584 <_Z13scheduler_putP6thread>:

int scheduler_put(thread_t thread) {
    uint64 sysCallCode = 0x15; // kod ovog sistemskog poziva
    if (!thread) return -1;
    80006584:	04050c63          	beqz	a0,800065dc <_Z13scheduler_putP6thread+0x58>
int scheduler_put(thread_t thread) {
    80006588:	ff010113          	addi	sp,sp,-16
    8000658c:	00113423          	sd	ra,8(sp)
    80006590:	00813023          	sd	s0,0(sp)
    80006594:	01010413          	addi	s0,sp,16

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006598:	00006797          	auipc	a5,0x6
    8000659c:	82078793          	addi	a5,a5,-2016 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800065a0:	01500713          	li	a4,21
    800065a4:	0ee7b823          	sd	a4,240(a5)
    arguments.arg1 = reinterpret_cast<uint64>(thread);
    800065a8:	0ea7bc23          	sd	a0,248(a5)
    arguments.arg2 = 0;
    800065ac:	1007b023          	sd	zero,256(a5)
    arguments.arg3 = 0;
    800065b0:	1007b423          	sd	zero,264(a5)
    arguments.arg4 = 0;
    800065b4:	1007b823          	sd	zero,272(a5)
    prepareArgsAndEcall(&arguments);
    800065b8:	00006517          	auipc	a0,0x6
    800065bc:	8f050513          	addi	a0,a0,-1808 # 8000bea8 <_ZZ13scheduler_putP6threadE9arguments>
    800065c0:	00000097          	auipc	ra,0x0
    800065c4:	3a4080e7          	jalr	932(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // ovaj sistemski poziv uvek uspeva jer je ovo jednostavno uvezivanje u listu schedulera bez dinamicke alokacije memorije
    return 0;
    800065c8:	00000513          	li	a0,0
}
    800065cc:	00813083          	ld	ra,8(sp)
    800065d0:	00013403          	ld	s0,0(sp)
    800065d4:	01010113          	addi	sp,sp,16
    800065d8:	00008067          	ret
    if (!thread) return -1;
    800065dc:	fff00513          	li	a0,-1
}
    800065e0:	00008067          	ret

00000000800065e4 <_Z11getThreadIdv>:

int getThreadId() {
    800065e4:	ff010113          	addi	sp,sp,-16
    800065e8:	00113423          	sd	ra,8(sp)
    800065ec:	00813023          	sd	s0,0(sp)
    800065f0:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x16; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800065f4:	00005797          	auipc	a5,0x5
    800065f8:	7c478793          	addi	a5,a5,1988 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800065fc:	01600713          	li	a4,22
    80006600:	10e7bc23          	sd	a4,280(a5)
    arguments.arg1 = 0;
    80006604:	1207b023          	sd	zero,288(a5)
    arguments.arg2 = 0;
    80006608:	1207b423          	sd	zero,296(a5)
    arguments.arg3 = 0;
    8000660c:	1207b823          	sd	zero,304(a5)
    arguments.arg4 = 0;
    80006610:	1207bc23          	sd	zero,312(a5)
    prepareArgsAndEcall(&arguments);
    80006614:	00006517          	auipc	a0,0x6
    80006618:	8bc50513          	addi	a0,a0,-1860 # 8000bed0 <_ZZ11getThreadIdvE9arguments>
    8000661c:	00000097          	auipc	ra,0x0
    80006620:	348080e7          	jalr	840(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    80006624:	00050513          	mv	a0,a0
    return successInfo;
}
    80006628:	0005051b          	sext.w	a0,a0
    8000662c:	00813083          	ld	ra,8(sp)
    80006630:	00013403          	ld	s0,0(sp)
    80006634:	01010113          	addi	sp,sp,16
    80006638:	00008067          	ret

000000008000663c <_Z8sem_openPP3semj>:

int sem_open(sem_t* handle, unsigned init) {
    8000663c:	fe010113          	addi	sp,sp,-32
    80006640:	00113c23          	sd	ra,24(sp)
    80006644:	00813823          	sd	s0,16(sp)
    80006648:	00913423          	sd	s1,8(sp)
    8000664c:	02010413          	addi	s0,sp,32
    80006650:	00050493          	mv	s1,a0
    uint64 sysCallCode = 0x21; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006654:	00005797          	auipc	a5,0x5
    80006658:	76478793          	addi	a5,a5,1892 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    8000665c:	02100713          	li	a4,33
    80006660:	14e7b023          	sd	a4,320(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreiranog semafora
    80006664:	14a7b423          	sd	a0,328(a5)
    arguments.arg2 = init;
    80006668:	02059593          	slli	a1,a1,0x20
    8000666c:	0205d593          	srli	a1,a1,0x20
    80006670:	14b7b823          	sd	a1,336(a5)
    arguments.arg3 = 0;
    80006674:	1407bc23          	sd	zero,344(a5)
    arguments.arg4 = 0;
    80006678:	1607b023          	sd	zero,352(a5)
    prepareArgsAndEcall(&arguments);
    8000667c:	00006517          	auipc	a0,0x6
    80006680:	87c50513          	addi	a0,a0,-1924 # 8000bef8 <_ZZ8sem_openPP3semjE9arguments>
    80006684:	00000097          	auipc	ra,0x0
    80006688:	2e0080e7          	jalr	736(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // slucaj kada je neuspesno alociran prostor za nov semafor (u prekidnoj rutini se poziva KernelSemaphore::createSemaphore)
    if (*handle == nullptr) return -1;
    8000668c:	0004b783          	ld	a5,0(s1)
    80006690:	00078e63          	beqz	a5,800066ac <_Z8sem_openPP3semj+0x70>

    return 0;
    80006694:	00000513          	li	a0,0
}
    80006698:	01813083          	ld	ra,24(sp)
    8000669c:	01013403          	ld	s0,16(sp)
    800066a0:	00813483          	ld	s1,8(sp)
    800066a4:	02010113          	addi	sp,sp,32
    800066a8:	00008067          	ret
    if (*handle == nullptr) return -1;
    800066ac:	fff00513          	li	a0,-1
    800066b0:	fe9ff06f          	j	80006698 <_Z8sem_openPP3semj+0x5c>

00000000800066b4 <_Z9sem_closeP3sem>:

int sem_close(sem_t handle) {
    800066b4:	ff010113          	addi	sp,sp,-16
    800066b8:	00113423          	sd	ra,8(sp)
    800066bc:	00813023          	sd	s0,0(sp)
    800066c0:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x22; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800066c4:	00005797          	auipc	a5,0x5
    800066c8:	6f478793          	addi	a5,a5,1780 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800066cc:	02200713          	li	a4,34
    800066d0:	16e7b423          	sd	a4,360(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa semafora kojeg treba osloboditi
    800066d4:	16a7b823          	sd	a0,368(a5)
    arguments.arg2 = 0;
    800066d8:	1607bc23          	sd	zero,376(a5)
    arguments.arg3 = 0;
    800066dc:	1807b023          	sd	zero,384(a5)
    arguments.arg4 = 0;
    800066e0:	1807b423          	sd	zero,392(a5)
    prepareArgsAndEcall(&arguments);
    800066e4:	00006517          	auipc	a0,0x6
    800066e8:	83c50513          	addi	a0,a0,-1988 # 8000bf20 <_ZZ9sem_closeP3semE9arguments>
    800066ec:	00000097          	auipc	ra,0x0
    800066f0:	278080e7          	jalr	632(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    800066f4:	00050513          	mv	a0,a0
    return successInfo;
}
    800066f8:	0005051b          	sext.w	a0,a0
    800066fc:	00813083          	ld	ra,8(sp)
    80006700:	00013403          	ld	s0,0(sp)
    80006704:	01010113          	addi	sp,sp,16
    80006708:	00008067          	ret

000000008000670c <_Z8sem_waitP3sem>:

int sem_wait(sem_t id) {
    8000670c:	ff010113          	addi	sp,sp,-16
    80006710:	00113423          	sd	ra,8(sp)
    80006714:	00813023          	sd	s0,0(sp)
    80006718:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x23; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    8000671c:	00005797          	auipc	a5,0x5
    80006720:	69c78793          	addi	a5,a5,1692 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    80006724:	02300713          	li	a4,35
    80006728:	18e7b823          	sd	a4,400(a5)
    arguments.arg1 = reinterpret_cast<uint64>(id); // adresa semafora za koji treba da se pozove metod wait
    8000672c:	18a7bc23          	sd	a0,408(a5)
    arguments.arg2 = 0;
    80006730:	1a07b023          	sd	zero,416(a5)
    arguments.arg3 = 0;
    80006734:	1a07b423          	sd	zero,424(a5)
    arguments.arg4 = 0;
    80006738:	1a07b823          	sd	zero,432(a5)
    prepareArgsAndEcall(&arguments);
    8000673c:	00006517          	auipc	a0,0x6
    80006740:	80c50513          	addi	a0,a0,-2036 # 8000bf48 <_ZZ8sem_waitP3semE9arguments>
    80006744:	00000097          	auipc	ra,0x0
    80006748:	220080e7          	jalr	544(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    8000674c:	00050513          	mv	a0,a0
    return successInfo;
}
    80006750:	0005051b          	sext.w	a0,a0
    80006754:	00813083          	ld	ra,8(sp)
    80006758:	00013403          	ld	s0,0(sp)
    8000675c:	01010113          	addi	sp,sp,16
    80006760:	00008067          	ret

0000000080006764 <_Z10sem_signalP3sem>:

int sem_signal(sem_t id) {
    80006764:	ff010113          	addi	sp,sp,-16
    80006768:	00113423          	sd	ra,8(sp)
    8000676c:	00813023          	sd	s0,0(sp)
    80006770:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x24; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006774:	00005797          	auipc	a5,0x5
    80006778:	64478793          	addi	a5,a5,1604 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    8000677c:	02400713          	li	a4,36
    80006780:	1ae7bc23          	sd	a4,440(a5)
    arguments.arg1 = reinterpret_cast<uint64>(id); // adresa semafora za koji treba da se pozove metod signal
    80006784:	1ca7b023          	sd	a0,448(a5)
    arguments.arg2 = 0;
    80006788:	1c07b423          	sd	zero,456(a5)
    arguments.arg3 = 0;
    8000678c:	1c07b823          	sd	zero,464(a5)
    arguments.arg4 = 0;
    80006790:	1c07bc23          	sd	zero,472(a5)
    prepareArgsAndEcall(&arguments);
    80006794:	00005517          	auipc	a0,0x5
    80006798:	7dc50513          	addi	a0,a0,2012 # 8000bf70 <_ZZ10sem_signalP3semE9arguments>
    8000679c:	00000097          	auipc	ra,0x0
    800067a0:	1c8080e7          	jalr	456(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // sem_signal se uvek uspesno obavi - nema ni rizika od eventualnog loseg rada alokatora memorije jer uopste ne alociram
    // i dealociram dinamicki elemente ulancane liste blokiranih niti na semaforu, vec pomocu pokazivaca kao nestatickih atributa
    // klase TCB formiram ulancanu listu
    return 0;
}
    800067a4:	00000513          	li	a0,0
    800067a8:	00813083          	ld	ra,8(sp)
    800067ac:	00013403          	ld	s0,0(sp)
    800067b0:	01010113          	addi	sp,sp,16
    800067b4:	00008067          	ret

00000000800067b8 <_Z10time_sleepm>:

int time_sleep(time_t time) { // time_t je zapravo uint64
    uint64 sysCallCode = 0x31; // kod ovog sistemskog poziva

    if (time == 0) return 0;
    800067b8:	00051663          	bnez	a0,800067c4 <_Z10time_sleepm+0xc>
    800067bc:	00000513          	li	a0,0
    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}
    800067c0:	00008067          	ret
int time_sleep(time_t time) { // time_t je zapravo uint64
    800067c4:	ff010113          	addi	sp,sp,-16
    800067c8:	00113423          	sd	ra,8(sp)
    800067cc:	00813023          	sd	s0,0(sp)
    800067d0:	01010413          	addi	s0,sp,16
    arguments.arg0 = sysCallCode;
    800067d4:	00005797          	auipc	a5,0x5
    800067d8:	5e478793          	addi	a5,a5,1508 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800067dc:	03100713          	li	a4,49
    800067e0:	1ee7b023          	sd	a4,480(a5)
    arguments.arg1 = time;
    800067e4:	1ea7b423          	sd	a0,488(a5)
    arguments.arg2 = 0;
    800067e8:	1e07b823          	sd	zero,496(a5)
    arguments.arg3 = 0;
    800067ec:	1e07bc23          	sd	zero,504(a5)
    arguments.arg4 = 0;
    800067f0:	2007b023          	sd	zero,512(a5)
    prepareArgsAndEcall(&arguments);
    800067f4:	00005517          	auipc	a0,0x5
    800067f8:	7a450513          	addi	a0,a0,1956 # 8000bf98 <_ZZ10time_sleepmE9arguments>
    800067fc:	00000097          	auipc	ra,0x0
    80006800:	168080e7          	jalr	360(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    80006804:	00050513          	mv	a0,a0
    80006808:	0005051b          	sext.w	a0,a0
}
    8000680c:	00813083          	ld	ra,8(sp)
    80006810:	00013403          	ld	s0,0(sp)
    80006814:	01010113          	addi	sp,sp,16
    80006818:	00008067          	ret

000000008000681c <_Z4getcv>:

char getc() {
    8000681c:	ff010113          	addi	sp,sp,-16
    80006820:	00113423          	sd	ra,8(sp)
    80006824:	00813023          	sd	s0,0(sp)
    80006828:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x41; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    8000682c:	00005797          	auipc	a5,0x5
    80006830:	58c78793          	addi	a5,a5,1420 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    80006834:	04100713          	li	a4,65
    80006838:	20e7b423          	sd	a4,520(a5)
    arguments.arg1 = 0;
    8000683c:	2007b823          	sd	zero,528(a5)
    arguments.arg2 = 0;
    80006840:	2007bc23          	sd	zero,536(a5)
    arguments.arg3 = 0;
    80006844:	2207b023          	sd	zero,544(a5)
    arguments.arg4 = 0;
    80006848:	2207b423          	sd	zero,552(a5)
    prepareArgsAndEcall(&arguments);
    8000684c:	00005517          	auipc	a0,0x5
    80006850:	77450513          	addi	a0,a0,1908 # 8000bfc0 <_ZZ4getcvE9arguments>
    80006854:	00000097          	auipc	ra,0x0
    80006858:	110080e7          	jalr	272(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>

    char inputCharacter;
    __asm__ volatile ("mv a0,%[inputCharacter]" : [inputCharacter] "=r"(inputCharacter));
    8000685c:	00050513          	mv	a0,a0
    return inputCharacter;
}
    80006860:	0ff57513          	andi	a0,a0,255
    80006864:	00813083          	ld	ra,8(sp)
    80006868:	00013403          	ld	s0,0(sp)
    8000686c:	01010113          	addi	sp,sp,16
    80006870:	00008067          	ret

0000000080006874 <_Z4putcc>:

void putc(char c) {
    80006874:	ff010113          	addi	sp,sp,-16
    80006878:	00113423          	sd	ra,8(sp)
    8000687c:	00813023          	sd	s0,0(sp)
    80006880:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x42; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006884:	00005797          	auipc	a5,0x5
    80006888:	53478793          	addi	a5,a5,1332 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    8000688c:	04200713          	li	a4,66
    80006890:	22e7b823          	sd	a4,560(a5)
    arguments.arg1 = c;
    80006894:	22a7bc23          	sd	a0,568(a5)
    arguments.arg2 = 0;
    80006898:	2407b023          	sd	zero,576(a5)
    arguments.arg3 = 0;
    8000689c:	2407b423          	sd	zero,584(a5)
    arguments.arg4 = 0;
    800068a0:	2407b823          	sd	zero,592(a5)
    prepareArgsAndEcall(&arguments);
    800068a4:	00005517          	auipc	a0,0x5
    800068a8:	74450513          	addi	a0,a0,1860 # 8000bfe8 <_ZZ4putccE9arguments>
    800068ac:	00000097          	auipc	ra,0x0
    800068b0:	0b8080e7          	jalr	184(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>
}
    800068b4:	00813083          	ld	ra,8(sp)
    800068b8:	00013403          	ld	s0,0(sp)
    800068bc:	01010113          	addi	sp,sp,16
    800068c0:	00008067          	ret

00000000800068c4 <_Z22switchSupervisorToUserv>:

void switchSupervisorToUser() {
    800068c4:	ff010113          	addi	sp,sp,-16
    800068c8:	00113423          	sd	ra,8(sp)
    800068cc:	00813023          	sd	s0,0(sp)
    800068d0:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x50; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800068d4:	00005797          	auipc	a5,0x5
    800068d8:	4e478793          	addi	a5,a5,1252 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    800068dc:	05000713          	li	a4,80
    800068e0:	24e7bc23          	sd	a4,600(a5)
    arguments.arg1 = 0;
    800068e4:	2607b023          	sd	zero,608(a5)
    arguments.arg2 = 0;
    800068e8:	2607b423          	sd	zero,616(a5)
    arguments.arg3 = 0;
    800068ec:	2607b823          	sd	zero,624(a5)
    arguments.arg4 = 0;
    800068f0:	2607bc23          	sd	zero,632(a5)
    prepareArgsAndEcall(&arguments);
    800068f4:	00005517          	auipc	a0,0x5
    800068f8:	71c50513          	addi	a0,a0,1820 # 8000c010 <_ZZ22switchSupervisorToUservE9arguments>
    800068fc:	00000097          	auipc	ra,0x0
    80006900:	068080e7          	jalr	104(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>
}
    80006904:	00813083          	ld	ra,8(sp)
    80006908:	00013403          	ld	s0,0(sp)
    8000690c:	01010113          	addi	sp,sp,16
    80006910:	00008067          	ret

0000000080006914 <_Z22switchUserToSupervisorv>:

void switchUserToSupervisor() {
    80006914:	ff010113          	addi	sp,sp,-16
    80006918:	00113423          	sd	ra,8(sp)
    8000691c:	00813023          	sd	s0,0(sp)
    80006920:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x51; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80006924:	00005797          	auipc	a5,0x5
    80006928:	49478793          	addi	a5,a5,1172 # 8000bdb8 <_ZZ9mem_allocmE9arguments>
    8000692c:	05100713          	li	a4,81
    80006930:	28e7b023          	sd	a4,640(a5)
    arguments.arg1 = 0;
    80006934:	2807b423          	sd	zero,648(a5)
    arguments.arg2 = 0;
    80006938:	2807b823          	sd	zero,656(a5)
    arguments.arg3 = 0;
    8000693c:	2807bc23          	sd	zero,664(a5)
    arguments.arg4 = 0;
    80006940:	2a07b023          	sd	zero,672(a5)
    prepareArgsAndEcall(&arguments);
    80006944:	00005517          	auipc	a0,0x5
    80006948:	6f450513          	addi	a0,a0,1780 # 8000c038 <_ZZ22switchUserToSupervisorvE9arguments>
    8000694c:	00000097          	auipc	ra,0x0
    80006950:	018080e7          	jalr	24(ra) # 80006964 <_Z19prepareArgsAndEcallP11sysCallArgs>
    80006954:	00813083          	ld	ra,8(sp)
    80006958:	00013403          	ld	s0,0(sp)
    8000695c:	01010113          	addi	sp,sp,16
    80006960:	00008067          	ret

0000000080006964 <_Z19prepareArgsAndEcallP11sysCallArgs>:

// ova funkcija predstavlja ABI (Application Binary Interface) - binarni INTERFEJS sistemskih poziva koji se vrse pomocu softverskog prekida (ecall)
// ciljnog procesora; ABI interfejs obezbedjuje prenos argumenata sistemskog poziva preko registara procesora, prelazak u privilegovani rezim rada
// procesora i prelazak na kod jezgra;
// implementacija prekidne rutine (supervisorTrap) predstavlja IMPLEMENTACIJU ABI sloja interfejsa jezgra
void prepareArgsAndEcall(sysCallArgs* ptr) {
    80006964:	ff010113          	addi	sp,sp,-16
    80006968:	00813423          	sd	s0,8(sp)
    8000696c:	01010413          	addi	s0,sp,16
    __asm__ volatile ("mv a1,%[arg1]" : : [arg1] "r"(ptr->arg1)); // upis parametra ovog sistemskog poziva u registar a1
    80006970:	00853783          	ld	a5,8(a0)
    80006974:	00078593          	mv	a1,a5
    __asm__ volatile ("mv a2,%[arg2]" : : [arg2] "r"(ptr->arg2)); // upis parametra ovog sistemskog poziva u registar a2
    80006978:	01053783          	ld	a5,16(a0)
    8000697c:	00078613          	mv	a2,a5
    __asm__ volatile ("mv a3,%[arg3]" : : [arg3] "r"(ptr->arg3)); // upis parametra ovog sistemskog poziva u registar a3
    80006980:	01853783          	ld	a5,24(a0)
    80006984:	00078693          	mv	a3,a5
    __asm__ volatile ("mv a4,%[arg4]" : : [arg4] "r"(ptr->arg4)); // upis parametra ovog sistemskog poziva u registar a4
    80006988:	02053783          	ld	a5,32(a0)
    8000698c:	00078713          	mv	a4,a5
    __asm__ volatile ("mv a0,%[arg0]" : : [arg0] "r"(ptr->arg0)); // upis koda sistemskog poziva u registar a0
    80006990:	00053783          	ld	a5,0(a0)
    80006994:	00078513          	mv	a0,a5
    __asm__ volatile ("ecall"); // instrukcija softverskog prekida
    80006998:	00000073          	ecall
    8000699c:	00813403          	ld	s0,8(sp)
    800069a0:	01010113          	addi	sp,sp,16
    800069a4:	00008067          	ret

00000000800069a8 <_ZN6Thread20callRunForThisThreadEPv>:

Thread::Thread() {
    thread_create_cpp(&myHandle, &callRunForThisThread, this);
}

void Thread::callRunForThisThread(void* thisPointer) {
    800069a8:	ff010113          	addi	sp,sp,-16
    800069ac:	00113423          	sd	ra,8(sp)
    800069b0:	00813023          	sd	s0,0(sp)
    800069b4:	01010413          	addi	s0,sp,16
    static_cast<Thread*>(thisPointer)->run();
    800069b8:	00053783          	ld	a5,0(a0)
    800069bc:	0107b783          	ld	a5,16(a5)
    800069c0:	000780e7          	jalr	a5
}
    800069c4:	00813083          	ld	ra,8(sp)
    800069c8:	00013403          	ld	s0,0(sp)
    800069cc:	01010113          	addi	sp,sp,16
    800069d0:	00008067          	ret

00000000800069d4 <_ZN14PeriodicThread3runEv>:

int Semaphore::signal() {
    return sem_signal(myHandle);
}

void PeriodicThread::run() {
    800069d4:	fe010113          	addi	sp,sp,-32
    800069d8:	00113c23          	sd	ra,24(sp)
    800069dc:	00813823          	sd	s0,16(sp)
    800069e0:	00913423          	sd	s1,8(sp)
    800069e4:	02010413          	addi	s0,sp,32
    800069e8:	00050493          	mv	s1,a0
    while (!shouldThisThreadEnd) {
    800069ec:	0184c783          	lbu	a5,24(s1)
    800069f0:	02079263          	bnez	a5,80006a14 <_ZN14PeriodicThread3runEv+0x40>
        periodicActivation();
    800069f4:	0004b783          	ld	a5,0(s1)
    800069f8:	0187b783          	ld	a5,24(a5)
    800069fc:	00048513          	mv	a0,s1
    80006a00:	000780e7          	jalr	a5
        time_sleep(sleepTime);
    80006a04:	0104b503          	ld	a0,16(s1)
    80006a08:	00000097          	auipc	ra,0x0
    80006a0c:	db0080e7          	jalr	-592(ra) # 800067b8 <_Z10time_sleepm>
    while (!shouldThisThreadEnd) {
    80006a10:	fddff06f          	j	800069ec <_ZN14PeriodicThread3runEv+0x18>
    }
}
    80006a14:	01813083          	ld	ra,24(sp)
    80006a18:	01013403          	ld	s0,16(sp)
    80006a1c:	00813483          	ld	s1,8(sp)
    80006a20:	02010113          	addi	sp,sp,32
    80006a24:	00008067          	ret

0000000080006a28 <_ZN9SemaphoreD1Ev>:
Semaphore::~Semaphore() {
    80006a28:	fe010113          	addi	sp,sp,-32
    80006a2c:	00113c23          	sd	ra,24(sp)
    80006a30:	00813823          	sd	s0,16(sp)
    80006a34:	00913423          	sd	s1,8(sp)
    80006a38:	02010413          	addi	s0,sp,32
    80006a3c:	00005797          	auipc	a5,0x5
    80006a40:	1dc78793          	addi	a5,a5,476 # 8000bc18 <_ZTV9Semaphore+0x10>
    80006a44:	00f53023          	sd	a5,0(a0)
    delete (KernelSemaphore*)myHandle;
    80006a48:	00853483          	ld	s1,8(a0)
    80006a4c:	00048e63          	beqz	s1,80006a68 <_ZN9SemaphoreD1Ev+0x40>
    80006a50:	00048513          	mv	a0,s1
    80006a54:	fffff097          	auipc	ra,0xfffff
    80006a58:	cc4080e7          	jalr	-828(ra) # 80005718 <_ZN15KernelSemaphoreD1Ev>
    80006a5c:	00048513          	mv	a0,s1
    80006a60:	fffff097          	auipc	ra,0xfffff
    80006a64:	a7c080e7          	jalr	-1412(ra) # 800054dc <_ZN15KernelSemaphoredlEPv>
}
    80006a68:	01813083          	ld	ra,24(sp)
    80006a6c:	01013403          	ld	s0,16(sp)
    80006a70:	00813483          	ld	s1,8(sp)
    80006a74:	02010113          	addi	sp,sp,32
    80006a78:	00008067          	ret

0000000080006a7c <_Znwm>:
void* operator new(size_t n) {
    80006a7c:	ff010113          	addi	sp,sp,-16
    80006a80:	00113423          	sd	ra,8(sp)
    80006a84:	00813023          	sd	s0,0(sp)
    80006a88:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    80006a8c:	00000097          	auipc	ra,0x0
    80006a90:	840080e7          	jalr	-1984(ra) # 800062cc <_Z9mem_allocm>
}
    80006a94:	00813083          	ld	ra,8(sp)
    80006a98:	00013403          	ld	s0,0(sp)
    80006a9c:	01010113          	addi	sp,sp,16
    80006aa0:	00008067          	ret

0000000080006aa4 <_Znam>:
void* operator new[](size_t n) {
    80006aa4:	ff010113          	addi	sp,sp,-16
    80006aa8:	00113423          	sd	ra,8(sp)
    80006aac:	00813023          	sd	s0,0(sp)
    80006ab0:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    80006ab4:	00000097          	auipc	ra,0x0
    80006ab8:	818080e7          	jalr	-2024(ra) # 800062cc <_Z9mem_allocm>
}
    80006abc:	00813083          	ld	ra,8(sp)
    80006ac0:	00013403          	ld	s0,0(sp)
    80006ac4:	01010113          	addi	sp,sp,16
    80006ac8:	00008067          	ret

0000000080006acc <_ZdlPv>:
void operator delete(void* ptr) {
    80006acc:	ff010113          	addi	sp,sp,-16
    80006ad0:	00113423          	sd	ra,8(sp)
    80006ad4:	00813023          	sd	s0,0(sp)
    80006ad8:	01010413          	addi	s0,sp,16
    mem_free(ptr);
    80006adc:	00000097          	auipc	ra,0x0
    80006ae0:	854080e7          	jalr	-1964(ra) # 80006330 <_Z8mem_freePv>
}
    80006ae4:	00813083          	ld	ra,8(sp)
    80006ae8:	00013403          	ld	s0,0(sp)
    80006aec:	01010113          	addi	sp,sp,16
    80006af0:	00008067          	ret

0000000080006af4 <_ZN9SemaphoreD0Ev>:
Semaphore::~Semaphore() {
    80006af4:	fe010113          	addi	sp,sp,-32
    80006af8:	00113c23          	sd	ra,24(sp)
    80006afc:	00813823          	sd	s0,16(sp)
    80006b00:	00913423          	sd	s1,8(sp)
    80006b04:	02010413          	addi	s0,sp,32
    80006b08:	00050493          	mv	s1,a0
}
    80006b0c:	00000097          	auipc	ra,0x0
    80006b10:	f1c080e7          	jalr	-228(ra) # 80006a28 <_ZN9SemaphoreD1Ev>
    80006b14:	00048513          	mv	a0,s1
    80006b18:	00000097          	auipc	ra,0x0
    80006b1c:	fb4080e7          	jalr	-76(ra) # 80006acc <_ZdlPv>
    80006b20:	01813083          	ld	ra,24(sp)
    80006b24:	01013403          	ld	s0,16(sp)
    80006b28:	00813483          	ld	s1,8(sp)
    80006b2c:	02010113          	addi	sp,sp,32
    80006b30:	00008067          	ret

0000000080006b34 <_ZdaPv>:
void operator delete[](void* ptr) {
    80006b34:	ff010113          	addi	sp,sp,-16
    80006b38:	00113423          	sd	ra,8(sp)
    80006b3c:	00813023          	sd	s0,0(sp)
    80006b40:	01010413          	addi	s0,sp,16
    mem_free(ptr);
    80006b44:	fffff097          	auipc	ra,0xfffff
    80006b48:	7ec080e7          	jalr	2028(ra) # 80006330 <_Z8mem_freePv>
}
    80006b4c:	00813083          	ld	ra,8(sp)
    80006b50:	00013403          	ld	s0,0(sp)
    80006b54:	01010113          	addi	sp,sp,16
    80006b58:	00008067          	ret

0000000080006b5c <_ZN6ThreadD1Ev>:
Thread::~Thread() {
    80006b5c:	fe010113          	addi	sp,sp,-32
    80006b60:	00113c23          	sd	ra,24(sp)
    80006b64:	00813823          	sd	s0,16(sp)
    80006b68:	00913423          	sd	s1,8(sp)
    80006b6c:	02010413          	addi	s0,sp,32
    80006b70:	00005797          	auipc	a5,0x5
    80006b74:	08078793          	addi	a5,a5,128 # 8000bbf0 <_ZTV6Thread+0x10>
    80006b78:	00f53023          	sd	a5,0(a0)
    delete (TCB*)(myHandle);
    80006b7c:	00853483          	ld	s1,8(a0)
    80006b80:	02048063          	beqz	s1,80006ba0 <_ZN6ThreadD1Ev+0x44>
    static void* operator new(size_t n);
    static void* operator new[](size_t n);
    static void operator delete(void* ptr);
    static void operator delete[](void* ptr);

    ~TCB() { delete[] stack; }
    80006b84:	0184b503          	ld	a0,24(s1)
    80006b88:	00050663          	beqz	a0,80006b94 <_ZN6ThreadD1Ev+0x38>
    80006b8c:	00000097          	auipc	ra,0x0
    80006b90:	fa8080e7          	jalr	-88(ra) # 80006b34 <_ZdaPv>
    80006b94:	00048513          	mv	a0,s1
    80006b98:	fffff097          	auipc	ra,0xfffff
    80006b9c:	3ac080e7          	jalr	940(ra) # 80005f44 <_ZN3TCBdlEPv>
}
    80006ba0:	01813083          	ld	ra,24(sp)
    80006ba4:	01013403          	ld	s0,16(sp)
    80006ba8:	00813483          	ld	s1,8(sp)
    80006bac:	02010113          	addi	sp,sp,32
    80006bb0:	00008067          	ret

0000000080006bb4 <_ZN6ThreadD0Ev>:
Thread::~Thread() {
    80006bb4:	fe010113          	addi	sp,sp,-32
    80006bb8:	00113c23          	sd	ra,24(sp)
    80006bbc:	00813823          	sd	s0,16(sp)
    80006bc0:	00913423          	sd	s1,8(sp)
    80006bc4:	02010413          	addi	s0,sp,32
    80006bc8:	00050493          	mv	s1,a0
}
    80006bcc:	00000097          	auipc	ra,0x0
    80006bd0:	f90080e7          	jalr	-112(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80006bd4:	00048513          	mv	a0,s1
    80006bd8:	00000097          	auipc	ra,0x0
    80006bdc:	ef4080e7          	jalr	-268(ra) # 80006acc <_ZdlPv>
    80006be0:	01813083          	ld	ra,24(sp)
    80006be4:	01013403          	ld	s0,16(sp)
    80006be8:	00813483          	ld	s1,8(sp)
    80006bec:	02010113          	addi	sp,sp,32
    80006bf0:	00008067          	ret

0000000080006bf4 <_ZN6ThreadC1EPFvPvES0_>:
Thread::Thread(void (*body)(void*), void *arg) {
    80006bf4:	ff010113          	addi	sp,sp,-16
    80006bf8:	00113423          	sd	ra,8(sp)
    80006bfc:	00813023          	sd	s0,0(sp)
    80006c00:	01010413          	addi	s0,sp,16
    80006c04:	00005797          	auipc	a5,0x5
    80006c08:	fec78793          	addi	a5,a5,-20 # 8000bbf0 <_ZTV6Thread+0x10>
    80006c0c:	00f53023          	sd	a5,0(a0)
    thread_create_cpp(&myHandle, body, arg);
    80006c10:	00850513          	addi	a0,a0,8
    80006c14:	00000097          	auipc	ra,0x0
    80006c18:	8c4080e7          	jalr	-1852(ra) # 800064d8 <_Z17thread_create_cppPP6threadPFvPvES2_>
}
    80006c1c:	00813083          	ld	ra,8(sp)
    80006c20:	00013403          	ld	s0,0(sp)
    80006c24:	01010113          	addi	sp,sp,16
    80006c28:	00008067          	ret

0000000080006c2c <_ZN6Thread5startEv>:
int Thread::start() {
    80006c2c:	ff010113          	addi	sp,sp,-16
    80006c30:	00113423          	sd	ra,8(sp)
    80006c34:	00813023          	sd	s0,0(sp)
    80006c38:	01010413          	addi	s0,sp,16
    return scheduler_put(myHandle);
    80006c3c:	00853503          	ld	a0,8(a0)
    80006c40:	00000097          	auipc	ra,0x0
    80006c44:	944080e7          	jalr	-1724(ra) # 80006584 <_Z13scheduler_putP6thread>
}
    80006c48:	00813083          	ld	ra,8(sp)
    80006c4c:	00013403          	ld	s0,0(sp)
    80006c50:	01010113          	addi	sp,sp,16
    80006c54:	00008067          	ret

0000000080006c58 <_ZN6Thread8dispatchEv>:
void Thread::dispatch() {
    80006c58:	ff010113          	addi	sp,sp,-16
    80006c5c:	00113423          	sd	ra,8(sp)
    80006c60:	00813023          	sd	s0,0(sp)
    80006c64:	01010413          	addi	s0,sp,16
    thread_dispatch();
    80006c68:	00000097          	auipc	ra,0x0
    80006c6c:	820080e7          	jalr	-2016(ra) # 80006488 <_Z15thread_dispatchv>
}
    80006c70:	00813083          	ld	ra,8(sp)
    80006c74:	00013403          	ld	s0,0(sp)
    80006c78:	01010113          	addi	sp,sp,16
    80006c7c:	00008067          	ret

0000000080006c80 <_ZN6Thread5sleepEm>:
int Thread::sleep(time_t time) {
    80006c80:	ff010113          	addi	sp,sp,-16
    80006c84:	00113423          	sd	ra,8(sp)
    80006c88:	00813023          	sd	s0,0(sp)
    80006c8c:	01010413          	addi	s0,sp,16
    return time_sleep(time);
    80006c90:	00000097          	auipc	ra,0x0
    80006c94:	b28080e7          	jalr	-1240(ra) # 800067b8 <_Z10time_sleepm>
}
    80006c98:	00813083          	ld	ra,8(sp)
    80006c9c:	00013403          	ld	s0,0(sp)
    80006ca0:	01010113          	addi	sp,sp,16
    80006ca4:	00008067          	ret

0000000080006ca8 <_ZN6Thread11getThreadIdEv>:
int Thread::getThreadId() {
    80006ca8:	ff010113          	addi	sp,sp,-16
    80006cac:	00113423          	sd	ra,8(sp)
    80006cb0:	00813023          	sd	s0,0(sp)
    80006cb4:	01010413          	addi	s0,sp,16
    return ::getThreadId();
    80006cb8:	00000097          	auipc	ra,0x0
    80006cbc:	92c080e7          	jalr	-1748(ra) # 800065e4 <_Z11getThreadIdv>
}
    80006cc0:	00813083          	ld	ra,8(sp)
    80006cc4:	00013403          	ld	s0,0(sp)
    80006cc8:	01010113          	addi	sp,sp,16
    80006ccc:	00008067          	ret

0000000080006cd0 <_ZN6ThreadC1Ev>:
Thread::Thread() {
    80006cd0:	ff010113          	addi	sp,sp,-16
    80006cd4:	00113423          	sd	ra,8(sp)
    80006cd8:	00813023          	sd	s0,0(sp)
    80006cdc:	01010413          	addi	s0,sp,16
    80006ce0:	00005797          	auipc	a5,0x5
    80006ce4:	f1078793          	addi	a5,a5,-240 # 8000bbf0 <_ZTV6Thread+0x10>
    80006ce8:	00f53023          	sd	a5,0(a0)
    thread_create_cpp(&myHandle, &callRunForThisThread, this);
    80006cec:	00050613          	mv	a2,a0
    80006cf0:	00000597          	auipc	a1,0x0
    80006cf4:	cb858593          	addi	a1,a1,-840 # 800069a8 <_ZN6Thread20callRunForThisThreadEPv>
    80006cf8:	00850513          	addi	a0,a0,8
    80006cfc:	fffff097          	auipc	ra,0xfffff
    80006d00:	7dc080e7          	jalr	2012(ra) # 800064d8 <_Z17thread_create_cppPP6threadPFvPvES2_>
}
    80006d04:	00813083          	ld	ra,8(sp)
    80006d08:	00013403          	ld	s0,0(sp)
    80006d0c:	01010113          	addi	sp,sp,16
    80006d10:	00008067          	ret

0000000080006d14 <_ZN9SemaphoreC1Ej>:
Semaphore::Semaphore(unsigned int init) {
    80006d14:	ff010113          	addi	sp,sp,-16
    80006d18:	00113423          	sd	ra,8(sp)
    80006d1c:	00813023          	sd	s0,0(sp)
    80006d20:	01010413          	addi	s0,sp,16
    80006d24:	00005797          	auipc	a5,0x5
    80006d28:	ef478793          	addi	a5,a5,-268 # 8000bc18 <_ZTV9Semaphore+0x10>
    80006d2c:	00f53023          	sd	a5,0(a0)
    sem_open(&myHandle, init);
    80006d30:	00850513          	addi	a0,a0,8
    80006d34:	00000097          	auipc	ra,0x0
    80006d38:	908080e7          	jalr	-1784(ra) # 8000663c <_Z8sem_openPP3semj>
}
    80006d3c:	00813083          	ld	ra,8(sp)
    80006d40:	00013403          	ld	s0,0(sp)
    80006d44:	01010113          	addi	sp,sp,16
    80006d48:	00008067          	ret

0000000080006d4c <_ZN9Semaphore4waitEv>:
int Semaphore::wait() {
    80006d4c:	ff010113          	addi	sp,sp,-16
    80006d50:	00113423          	sd	ra,8(sp)
    80006d54:	00813023          	sd	s0,0(sp)
    80006d58:	01010413          	addi	s0,sp,16
    return sem_wait(myHandle);
    80006d5c:	00853503          	ld	a0,8(a0)
    80006d60:	00000097          	auipc	ra,0x0
    80006d64:	9ac080e7          	jalr	-1620(ra) # 8000670c <_Z8sem_waitP3sem>
}
    80006d68:	00813083          	ld	ra,8(sp)
    80006d6c:	00013403          	ld	s0,0(sp)
    80006d70:	01010113          	addi	sp,sp,16
    80006d74:	00008067          	ret

0000000080006d78 <_ZN9Semaphore6signalEv>:
int Semaphore::signal() {
    80006d78:	ff010113          	addi	sp,sp,-16
    80006d7c:	00113423          	sd	ra,8(sp)
    80006d80:	00813023          	sd	s0,0(sp)
    80006d84:	01010413          	addi	s0,sp,16
    return sem_signal(myHandle);
    80006d88:	00853503          	ld	a0,8(a0)
    80006d8c:	00000097          	auipc	ra,0x0
    80006d90:	9d8080e7          	jalr	-1576(ra) # 80006764 <_Z10sem_signalP3sem>
}
    80006d94:	00813083          	ld	ra,8(sp)
    80006d98:	00013403          	ld	s0,0(sp)
    80006d9c:	01010113          	addi	sp,sp,16
    80006da0:	00008067          	ret

0000000080006da4 <_ZN14PeriodicThread17endPeriodicThreadEv>:

void PeriodicThread::endPeriodicThread() {
    80006da4:	ff010113          	addi	sp,sp,-16
    80006da8:	00813423          	sd	s0,8(sp)
    80006dac:	01010413          	addi	s0,sp,16
    shouldThisThreadEnd = true;
    80006db0:	00100793          	li	a5,1
    80006db4:	00f50c23          	sb	a5,24(a0)
}
    80006db8:	00813403          	ld	s0,8(sp)
    80006dbc:	01010113          	addi	sp,sp,16
    80006dc0:	00008067          	ret

0000000080006dc4 <_ZN14PeriodicThreadC1Em>:

PeriodicThread::PeriodicThread(time_t period) {
    80006dc4:	fe010113          	addi	sp,sp,-32
    80006dc8:	00113c23          	sd	ra,24(sp)
    80006dcc:	00813823          	sd	s0,16(sp)
    80006dd0:	00913423          	sd	s1,8(sp)
    80006dd4:	01213023          	sd	s2,0(sp)
    80006dd8:	02010413          	addi	s0,sp,32
    80006ddc:	00050493          	mv	s1,a0
    80006de0:	00058913          	mv	s2,a1
    80006de4:	00000097          	auipc	ra,0x0
    80006de8:	eec080e7          	jalr	-276(ra) # 80006cd0 <_ZN6ThreadC1Ev>
    80006dec:	00005797          	auipc	a5,0x5
    80006df0:	e4c78793          	addi	a5,a5,-436 # 8000bc38 <_ZTV14PeriodicThread+0x10>
    80006df4:	00f4b023          	sd	a5,0(s1)
    sleepTime = period;
    80006df8:	0124b823          	sd	s2,16(s1)
    shouldThisThreadEnd = false;
    80006dfc:	00048c23          	sb	zero,24(s1)
}
    80006e00:	01813083          	ld	ra,24(sp)
    80006e04:	01013403          	ld	s0,16(sp)
    80006e08:	00813483          	ld	s1,8(sp)
    80006e0c:	00013903          	ld	s2,0(sp)
    80006e10:	02010113          	addi	sp,sp,32
    80006e14:	00008067          	ret

0000000080006e18 <_ZN7Console4getcEv>:


char Console::getc() {
    80006e18:	ff010113          	addi	sp,sp,-16
    80006e1c:	00113423          	sd	ra,8(sp)
    80006e20:	00813023          	sd	s0,0(sp)
    80006e24:	01010413          	addi	s0,sp,16
    return ::getc();
    80006e28:	00000097          	auipc	ra,0x0
    80006e2c:	9f4080e7          	jalr	-1548(ra) # 8000681c <_Z4getcv>
}
    80006e30:	00813083          	ld	ra,8(sp)
    80006e34:	00013403          	ld	s0,0(sp)
    80006e38:	01010113          	addi	sp,sp,16
    80006e3c:	00008067          	ret

0000000080006e40 <_ZN7Console4putcEc>:

void Console::putc(char c) {
    80006e40:	ff010113          	addi	sp,sp,-16
    80006e44:	00113423          	sd	ra,8(sp)
    80006e48:	00813023          	sd	s0,0(sp)
    80006e4c:	01010413          	addi	s0,sp,16
    ::putc(c);
    80006e50:	00000097          	auipc	ra,0x0
    80006e54:	a24080e7          	jalr	-1500(ra) # 80006874 <_Z4putcc>
    80006e58:	00813083          	ld	ra,8(sp)
    80006e5c:	00013403          	ld	s0,0(sp)
    80006e60:	01010113          	addi	sp,sp,16
    80006e64:	00008067          	ret

0000000080006e68 <_ZN6Thread3runEv>:

    int getThreadId();

protected:
    Thread();
    virtual void run() {}
    80006e68:	ff010113          	addi	sp,sp,-16
    80006e6c:	00813423          	sd	s0,8(sp)
    80006e70:	01010413          	addi	s0,sp,16
    80006e74:	00813403          	ld	s0,8(sp)
    80006e78:	01010113          	addi	sp,sp,16
    80006e7c:	00008067          	ret

0000000080006e80 <_ZN14PeriodicThread18periodicActivationEv>:
public:
    void endPeriodicThread();
protected:
    explicit PeriodicThread(time_t period);
    void run() override;
    virtual void periodicActivation() {}
    80006e80:	ff010113          	addi	sp,sp,-16
    80006e84:	00813423          	sd	s0,8(sp)
    80006e88:	01010413          	addi	s0,sp,16
    80006e8c:	00813403          	ld	s0,8(sp)
    80006e90:	01010113          	addi	sp,sp,16
    80006e94:	00008067          	ret

0000000080006e98 <_ZN14PeriodicThreadD1Ev>:
class PeriodicThread : public Thread {
    80006e98:	ff010113          	addi	sp,sp,-16
    80006e9c:	00113423          	sd	ra,8(sp)
    80006ea0:	00813023          	sd	s0,0(sp)
    80006ea4:	01010413          	addi	s0,sp,16
    80006ea8:	00005797          	auipc	a5,0x5
    80006eac:	d9078793          	addi	a5,a5,-624 # 8000bc38 <_ZTV14PeriodicThread+0x10>
    80006eb0:	00f53023          	sd	a5,0(a0)
    80006eb4:	00000097          	auipc	ra,0x0
    80006eb8:	ca8080e7          	jalr	-856(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80006ebc:	00813083          	ld	ra,8(sp)
    80006ec0:	00013403          	ld	s0,0(sp)
    80006ec4:	01010113          	addi	sp,sp,16
    80006ec8:	00008067          	ret

0000000080006ecc <_ZN14PeriodicThreadD0Ev>:
    80006ecc:	fe010113          	addi	sp,sp,-32
    80006ed0:	00113c23          	sd	ra,24(sp)
    80006ed4:	00813823          	sd	s0,16(sp)
    80006ed8:	00913423          	sd	s1,8(sp)
    80006edc:	02010413          	addi	s0,sp,32
    80006ee0:	00050493          	mv	s1,a0
    80006ee4:	00005797          	auipc	a5,0x5
    80006ee8:	d5478793          	addi	a5,a5,-684 # 8000bc38 <_ZTV14PeriodicThread+0x10>
    80006eec:	00f53023          	sd	a5,0(a0)
    80006ef0:	00000097          	auipc	ra,0x0
    80006ef4:	c6c080e7          	jalr	-916(ra) # 80006b5c <_ZN6ThreadD1Ev>
    80006ef8:	00048513          	mv	a0,s1
    80006efc:	00000097          	auipc	ra,0x0
    80006f00:	bd0080e7          	jalr	-1072(ra) # 80006acc <_ZdlPv>
    80006f04:	01813083          	ld	ra,24(sp)
    80006f08:	01013403          	ld	s0,16(sp)
    80006f0c:	00813483          	ld	s1,8(sp)
    80006f10:	02010113          	addi	sp,sp,32
    80006f14:	00008067          	ret

0000000080006f18 <start>:
    80006f18:	ff010113          	addi	sp,sp,-16
    80006f1c:	00813423          	sd	s0,8(sp)
    80006f20:	01010413          	addi	s0,sp,16
    80006f24:	300027f3          	csrr	a5,mstatus
    80006f28:	ffffe737          	lui	a4,0xffffe
    80006f2c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff153f>
    80006f30:	00e7f7b3          	and	a5,a5,a4
    80006f34:	00001737          	lui	a4,0x1
    80006f38:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006f3c:	00e7e7b3          	or	a5,a5,a4
    80006f40:	30079073          	csrw	mstatus,a5
    80006f44:	00000797          	auipc	a5,0x0
    80006f48:	16078793          	addi	a5,a5,352 # 800070a4 <system_main>
    80006f4c:	34179073          	csrw	mepc,a5
    80006f50:	00000793          	li	a5,0
    80006f54:	18079073          	csrw	satp,a5
    80006f58:	000107b7          	lui	a5,0x10
    80006f5c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80006f60:	30279073          	csrw	medeleg,a5
    80006f64:	30379073          	csrw	mideleg,a5
    80006f68:	104027f3          	csrr	a5,sie
    80006f6c:	2227e793          	ori	a5,a5,546
    80006f70:	10479073          	csrw	sie,a5
    80006f74:	fff00793          	li	a5,-1
    80006f78:	00a7d793          	srli	a5,a5,0xa
    80006f7c:	3b079073          	csrw	pmpaddr0,a5
    80006f80:	00f00793          	li	a5,15
    80006f84:	3a079073          	csrw	pmpcfg0,a5
    80006f88:	f14027f3          	csrr	a5,mhartid
    80006f8c:	0200c737          	lui	a4,0x200c
    80006f90:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80006f94:	0007869b          	sext.w	a3,a5
    80006f98:	00269713          	slli	a4,a3,0x2
    80006f9c:	000f4637          	lui	a2,0xf4
    80006fa0:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006fa4:	00d70733          	add	a4,a4,a3
    80006fa8:	0037979b          	slliw	a5,a5,0x3
    80006fac:	020046b7          	lui	a3,0x2004
    80006fb0:	00d787b3          	add	a5,a5,a3
    80006fb4:	00c585b3          	add	a1,a1,a2
    80006fb8:	00371693          	slli	a3,a4,0x3
    80006fbc:	00005717          	auipc	a4,0x5
    80006fc0:	0a470713          	addi	a4,a4,164 # 8000c060 <timer_scratch>
    80006fc4:	00b7b023          	sd	a1,0(a5)
    80006fc8:	00d70733          	add	a4,a4,a3
    80006fcc:	00f73c23          	sd	a5,24(a4)
    80006fd0:	02c73023          	sd	a2,32(a4)
    80006fd4:	34071073          	csrw	mscratch,a4
    80006fd8:	00000797          	auipc	a5,0x0
    80006fdc:	6e878793          	addi	a5,a5,1768 # 800076c0 <timervec>
    80006fe0:	30579073          	csrw	mtvec,a5
    80006fe4:	300027f3          	csrr	a5,mstatus
    80006fe8:	0087e793          	ori	a5,a5,8
    80006fec:	30079073          	csrw	mstatus,a5
    80006ff0:	304027f3          	csrr	a5,mie
    80006ff4:	0807e793          	ori	a5,a5,128
    80006ff8:	30479073          	csrw	mie,a5
    80006ffc:	f14027f3          	csrr	a5,mhartid
    80007000:	0007879b          	sext.w	a5,a5
    80007004:	00078213          	mv	tp,a5
    80007008:	30200073          	mret
    8000700c:	00813403          	ld	s0,8(sp)
    80007010:	01010113          	addi	sp,sp,16
    80007014:	00008067          	ret

0000000080007018 <timerinit>:
    80007018:	ff010113          	addi	sp,sp,-16
    8000701c:	00813423          	sd	s0,8(sp)
    80007020:	01010413          	addi	s0,sp,16
    80007024:	f14027f3          	csrr	a5,mhartid
    80007028:	0200c737          	lui	a4,0x200c
    8000702c:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80007030:	0007869b          	sext.w	a3,a5
    80007034:	00269713          	slli	a4,a3,0x2
    80007038:	000f4637          	lui	a2,0xf4
    8000703c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80007040:	00d70733          	add	a4,a4,a3
    80007044:	0037979b          	slliw	a5,a5,0x3
    80007048:	020046b7          	lui	a3,0x2004
    8000704c:	00d787b3          	add	a5,a5,a3
    80007050:	00c585b3          	add	a1,a1,a2
    80007054:	00371693          	slli	a3,a4,0x3
    80007058:	00005717          	auipc	a4,0x5
    8000705c:	00870713          	addi	a4,a4,8 # 8000c060 <timer_scratch>
    80007060:	00b7b023          	sd	a1,0(a5)
    80007064:	00d70733          	add	a4,a4,a3
    80007068:	00f73c23          	sd	a5,24(a4)
    8000706c:	02c73023          	sd	a2,32(a4)
    80007070:	34071073          	csrw	mscratch,a4
    80007074:	00000797          	auipc	a5,0x0
    80007078:	64c78793          	addi	a5,a5,1612 # 800076c0 <timervec>
    8000707c:	30579073          	csrw	mtvec,a5
    80007080:	300027f3          	csrr	a5,mstatus
    80007084:	0087e793          	ori	a5,a5,8
    80007088:	30079073          	csrw	mstatus,a5
    8000708c:	304027f3          	csrr	a5,mie
    80007090:	0807e793          	ori	a5,a5,128
    80007094:	30479073          	csrw	mie,a5
    80007098:	00813403          	ld	s0,8(sp)
    8000709c:	01010113          	addi	sp,sp,16
    800070a0:	00008067          	ret

00000000800070a4 <system_main>:
    800070a4:	fe010113          	addi	sp,sp,-32
    800070a8:	00813823          	sd	s0,16(sp)
    800070ac:	00913423          	sd	s1,8(sp)
    800070b0:	00113c23          	sd	ra,24(sp)
    800070b4:	02010413          	addi	s0,sp,32
    800070b8:	00000097          	auipc	ra,0x0
    800070bc:	0c4080e7          	jalr	196(ra) # 8000717c <cpuid>
    800070c0:	00005497          	auipc	s1,0x5
    800070c4:	c1048493          	addi	s1,s1,-1008 # 8000bcd0 <started>
    800070c8:	02050263          	beqz	a0,800070ec <system_main+0x48>
    800070cc:	0004a783          	lw	a5,0(s1)
    800070d0:	0007879b          	sext.w	a5,a5
    800070d4:	fe078ce3          	beqz	a5,800070cc <system_main+0x28>
    800070d8:	0ff0000f          	fence
    800070dc:	00002517          	auipc	a0,0x2
    800070e0:	2a450513          	addi	a0,a0,676 # 80009380 <CONSOLE_STATUS+0x370>
    800070e4:	00001097          	auipc	ra,0x1
    800070e8:	a78080e7          	jalr	-1416(ra) # 80007b5c <panic>
    800070ec:	00001097          	auipc	ra,0x1
    800070f0:	9cc080e7          	jalr	-1588(ra) # 80007ab8 <consoleinit>
    800070f4:	00001097          	auipc	ra,0x1
    800070f8:	158080e7          	jalr	344(ra) # 8000824c <printfinit>
    800070fc:	00002517          	auipc	a0,0x2
    80007100:	08c50513          	addi	a0,a0,140 # 80009188 <CONSOLE_STATUS+0x178>
    80007104:	00001097          	auipc	ra,0x1
    80007108:	ab4080e7          	jalr	-1356(ra) # 80007bb8 <__printf>
    8000710c:	00002517          	auipc	a0,0x2
    80007110:	24450513          	addi	a0,a0,580 # 80009350 <CONSOLE_STATUS+0x340>
    80007114:	00001097          	auipc	ra,0x1
    80007118:	aa4080e7          	jalr	-1372(ra) # 80007bb8 <__printf>
    8000711c:	00002517          	auipc	a0,0x2
    80007120:	06c50513          	addi	a0,a0,108 # 80009188 <CONSOLE_STATUS+0x178>
    80007124:	00001097          	auipc	ra,0x1
    80007128:	a94080e7          	jalr	-1388(ra) # 80007bb8 <__printf>
    8000712c:	00001097          	auipc	ra,0x1
    80007130:	4ac080e7          	jalr	1196(ra) # 800085d8 <kinit>
    80007134:	00000097          	auipc	ra,0x0
    80007138:	148080e7          	jalr	328(ra) # 8000727c <trapinit>
    8000713c:	00000097          	auipc	ra,0x0
    80007140:	16c080e7          	jalr	364(ra) # 800072a8 <trapinithart>
    80007144:	00000097          	auipc	ra,0x0
    80007148:	5bc080e7          	jalr	1468(ra) # 80007700 <plicinit>
    8000714c:	00000097          	auipc	ra,0x0
    80007150:	5dc080e7          	jalr	1500(ra) # 80007728 <plicinithart>
    80007154:	00000097          	auipc	ra,0x0
    80007158:	078080e7          	jalr	120(ra) # 800071cc <userinit>
    8000715c:	0ff0000f          	fence
    80007160:	00100793          	li	a5,1
    80007164:	00002517          	auipc	a0,0x2
    80007168:	20450513          	addi	a0,a0,516 # 80009368 <CONSOLE_STATUS+0x358>
    8000716c:	00f4a023          	sw	a5,0(s1)
    80007170:	00001097          	auipc	ra,0x1
    80007174:	a48080e7          	jalr	-1464(ra) # 80007bb8 <__printf>
    80007178:	0000006f          	j	80007178 <system_main+0xd4>

000000008000717c <cpuid>:
    8000717c:	ff010113          	addi	sp,sp,-16
    80007180:	00813423          	sd	s0,8(sp)
    80007184:	01010413          	addi	s0,sp,16
    80007188:	00020513          	mv	a0,tp
    8000718c:	00813403          	ld	s0,8(sp)
    80007190:	0005051b          	sext.w	a0,a0
    80007194:	01010113          	addi	sp,sp,16
    80007198:	00008067          	ret

000000008000719c <mycpu>:
    8000719c:	ff010113          	addi	sp,sp,-16
    800071a0:	00813423          	sd	s0,8(sp)
    800071a4:	01010413          	addi	s0,sp,16
    800071a8:	00020793          	mv	a5,tp
    800071ac:	00813403          	ld	s0,8(sp)
    800071b0:	0007879b          	sext.w	a5,a5
    800071b4:	00779793          	slli	a5,a5,0x7
    800071b8:	00006517          	auipc	a0,0x6
    800071bc:	ed850513          	addi	a0,a0,-296 # 8000d090 <cpus>
    800071c0:	00f50533          	add	a0,a0,a5
    800071c4:	01010113          	addi	sp,sp,16
    800071c8:	00008067          	ret

00000000800071cc <userinit>:
    800071cc:	ff010113          	addi	sp,sp,-16
    800071d0:	00813423          	sd	s0,8(sp)
    800071d4:	01010413          	addi	s0,sp,16
    800071d8:	00813403          	ld	s0,8(sp)
    800071dc:	01010113          	addi	sp,sp,16
    800071e0:	ffffd317          	auipc	t1,0xffffd
    800071e4:	3fc30067          	jr	1020(t1) # 800045dc <main>

00000000800071e8 <either_copyout>:
    800071e8:	ff010113          	addi	sp,sp,-16
    800071ec:	00813023          	sd	s0,0(sp)
    800071f0:	00113423          	sd	ra,8(sp)
    800071f4:	01010413          	addi	s0,sp,16
    800071f8:	02051663          	bnez	a0,80007224 <either_copyout+0x3c>
    800071fc:	00058513          	mv	a0,a1
    80007200:	00060593          	mv	a1,a2
    80007204:	0006861b          	sext.w	a2,a3
    80007208:	00002097          	auipc	ra,0x2
    8000720c:	c5c080e7          	jalr	-932(ra) # 80008e64 <__memmove>
    80007210:	00813083          	ld	ra,8(sp)
    80007214:	00013403          	ld	s0,0(sp)
    80007218:	00000513          	li	a0,0
    8000721c:	01010113          	addi	sp,sp,16
    80007220:	00008067          	ret
    80007224:	00002517          	auipc	a0,0x2
    80007228:	18450513          	addi	a0,a0,388 # 800093a8 <CONSOLE_STATUS+0x398>
    8000722c:	00001097          	auipc	ra,0x1
    80007230:	930080e7          	jalr	-1744(ra) # 80007b5c <panic>

0000000080007234 <either_copyin>:
    80007234:	ff010113          	addi	sp,sp,-16
    80007238:	00813023          	sd	s0,0(sp)
    8000723c:	00113423          	sd	ra,8(sp)
    80007240:	01010413          	addi	s0,sp,16
    80007244:	02059463          	bnez	a1,8000726c <either_copyin+0x38>
    80007248:	00060593          	mv	a1,a2
    8000724c:	0006861b          	sext.w	a2,a3
    80007250:	00002097          	auipc	ra,0x2
    80007254:	c14080e7          	jalr	-1004(ra) # 80008e64 <__memmove>
    80007258:	00813083          	ld	ra,8(sp)
    8000725c:	00013403          	ld	s0,0(sp)
    80007260:	00000513          	li	a0,0
    80007264:	01010113          	addi	sp,sp,16
    80007268:	00008067          	ret
    8000726c:	00002517          	auipc	a0,0x2
    80007270:	16450513          	addi	a0,a0,356 # 800093d0 <CONSOLE_STATUS+0x3c0>
    80007274:	00001097          	auipc	ra,0x1
    80007278:	8e8080e7          	jalr	-1816(ra) # 80007b5c <panic>

000000008000727c <trapinit>:
    8000727c:	ff010113          	addi	sp,sp,-16
    80007280:	00813423          	sd	s0,8(sp)
    80007284:	01010413          	addi	s0,sp,16
    80007288:	00813403          	ld	s0,8(sp)
    8000728c:	00002597          	auipc	a1,0x2
    80007290:	16c58593          	addi	a1,a1,364 # 800093f8 <CONSOLE_STATUS+0x3e8>
    80007294:	00006517          	auipc	a0,0x6
    80007298:	e7c50513          	addi	a0,a0,-388 # 8000d110 <tickslock>
    8000729c:	01010113          	addi	sp,sp,16
    800072a0:	00001317          	auipc	t1,0x1
    800072a4:	5c830067          	jr	1480(t1) # 80008868 <initlock>

00000000800072a8 <trapinithart>:
    800072a8:	ff010113          	addi	sp,sp,-16
    800072ac:	00813423          	sd	s0,8(sp)
    800072b0:	01010413          	addi	s0,sp,16
    800072b4:	00000797          	auipc	a5,0x0
    800072b8:	2fc78793          	addi	a5,a5,764 # 800075b0 <kernelvec>
    800072bc:	10579073          	csrw	stvec,a5
    800072c0:	00813403          	ld	s0,8(sp)
    800072c4:	01010113          	addi	sp,sp,16
    800072c8:	00008067          	ret

00000000800072cc <usertrap>:
    800072cc:	ff010113          	addi	sp,sp,-16
    800072d0:	00813423          	sd	s0,8(sp)
    800072d4:	01010413          	addi	s0,sp,16
    800072d8:	00813403          	ld	s0,8(sp)
    800072dc:	01010113          	addi	sp,sp,16
    800072e0:	00008067          	ret

00000000800072e4 <usertrapret>:
    800072e4:	ff010113          	addi	sp,sp,-16
    800072e8:	00813423          	sd	s0,8(sp)
    800072ec:	01010413          	addi	s0,sp,16
    800072f0:	00813403          	ld	s0,8(sp)
    800072f4:	01010113          	addi	sp,sp,16
    800072f8:	00008067          	ret

00000000800072fc <kerneltrap>:
    800072fc:	fe010113          	addi	sp,sp,-32
    80007300:	00813823          	sd	s0,16(sp)
    80007304:	00113c23          	sd	ra,24(sp)
    80007308:	00913423          	sd	s1,8(sp)
    8000730c:	02010413          	addi	s0,sp,32
    80007310:	142025f3          	csrr	a1,scause
    80007314:	100027f3          	csrr	a5,sstatus
    80007318:	0027f793          	andi	a5,a5,2
    8000731c:	10079c63          	bnez	a5,80007434 <kerneltrap+0x138>
    80007320:	142027f3          	csrr	a5,scause
    80007324:	0207ce63          	bltz	a5,80007360 <kerneltrap+0x64>
    80007328:	00002517          	auipc	a0,0x2
    8000732c:	11850513          	addi	a0,a0,280 # 80009440 <CONSOLE_STATUS+0x430>
    80007330:	00001097          	auipc	ra,0x1
    80007334:	888080e7          	jalr	-1912(ra) # 80007bb8 <__printf>
    80007338:	141025f3          	csrr	a1,sepc
    8000733c:	14302673          	csrr	a2,stval
    80007340:	00002517          	auipc	a0,0x2
    80007344:	11050513          	addi	a0,a0,272 # 80009450 <CONSOLE_STATUS+0x440>
    80007348:	00001097          	auipc	ra,0x1
    8000734c:	870080e7          	jalr	-1936(ra) # 80007bb8 <__printf>
    80007350:	00002517          	auipc	a0,0x2
    80007354:	11850513          	addi	a0,a0,280 # 80009468 <CONSOLE_STATUS+0x458>
    80007358:	00001097          	auipc	ra,0x1
    8000735c:	804080e7          	jalr	-2044(ra) # 80007b5c <panic>
    80007360:	0ff7f713          	andi	a4,a5,255
    80007364:	00900693          	li	a3,9
    80007368:	04d70063          	beq	a4,a3,800073a8 <kerneltrap+0xac>
    8000736c:	fff00713          	li	a4,-1
    80007370:	03f71713          	slli	a4,a4,0x3f
    80007374:	00170713          	addi	a4,a4,1
    80007378:	fae798e3          	bne	a5,a4,80007328 <kerneltrap+0x2c>
    8000737c:	00000097          	auipc	ra,0x0
    80007380:	e00080e7          	jalr	-512(ra) # 8000717c <cpuid>
    80007384:	06050663          	beqz	a0,800073f0 <kerneltrap+0xf4>
    80007388:	144027f3          	csrr	a5,sip
    8000738c:	ffd7f793          	andi	a5,a5,-3
    80007390:	14479073          	csrw	sip,a5
    80007394:	01813083          	ld	ra,24(sp)
    80007398:	01013403          	ld	s0,16(sp)
    8000739c:	00813483          	ld	s1,8(sp)
    800073a0:	02010113          	addi	sp,sp,32
    800073a4:	00008067          	ret
    800073a8:	00000097          	auipc	ra,0x0
    800073ac:	3cc080e7          	jalr	972(ra) # 80007774 <plic_claim>
    800073b0:	00a00793          	li	a5,10
    800073b4:	00050493          	mv	s1,a0
    800073b8:	06f50863          	beq	a0,a5,80007428 <kerneltrap+0x12c>
    800073bc:	fc050ce3          	beqz	a0,80007394 <kerneltrap+0x98>
    800073c0:	00050593          	mv	a1,a0
    800073c4:	00002517          	auipc	a0,0x2
    800073c8:	05c50513          	addi	a0,a0,92 # 80009420 <CONSOLE_STATUS+0x410>
    800073cc:	00000097          	auipc	ra,0x0
    800073d0:	7ec080e7          	jalr	2028(ra) # 80007bb8 <__printf>
    800073d4:	01013403          	ld	s0,16(sp)
    800073d8:	01813083          	ld	ra,24(sp)
    800073dc:	00048513          	mv	a0,s1
    800073e0:	00813483          	ld	s1,8(sp)
    800073e4:	02010113          	addi	sp,sp,32
    800073e8:	00000317          	auipc	t1,0x0
    800073ec:	3c430067          	jr	964(t1) # 800077ac <plic_complete>
    800073f0:	00006517          	auipc	a0,0x6
    800073f4:	d2050513          	addi	a0,a0,-736 # 8000d110 <tickslock>
    800073f8:	00001097          	auipc	ra,0x1
    800073fc:	494080e7          	jalr	1172(ra) # 8000888c <acquire>
    80007400:	00005717          	auipc	a4,0x5
    80007404:	8d470713          	addi	a4,a4,-1836 # 8000bcd4 <ticks>
    80007408:	00072783          	lw	a5,0(a4)
    8000740c:	00006517          	auipc	a0,0x6
    80007410:	d0450513          	addi	a0,a0,-764 # 8000d110 <tickslock>
    80007414:	0017879b          	addiw	a5,a5,1
    80007418:	00f72023          	sw	a5,0(a4)
    8000741c:	00001097          	auipc	ra,0x1
    80007420:	53c080e7          	jalr	1340(ra) # 80008958 <release>
    80007424:	f65ff06f          	j	80007388 <kerneltrap+0x8c>
    80007428:	00001097          	auipc	ra,0x1
    8000742c:	098080e7          	jalr	152(ra) # 800084c0 <uartintr>
    80007430:	fa5ff06f          	j	800073d4 <kerneltrap+0xd8>
    80007434:	00002517          	auipc	a0,0x2
    80007438:	fcc50513          	addi	a0,a0,-52 # 80009400 <CONSOLE_STATUS+0x3f0>
    8000743c:	00000097          	auipc	ra,0x0
    80007440:	720080e7          	jalr	1824(ra) # 80007b5c <panic>

0000000080007444 <clockintr>:
    80007444:	fe010113          	addi	sp,sp,-32
    80007448:	00813823          	sd	s0,16(sp)
    8000744c:	00913423          	sd	s1,8(sp)
    80007450:	00113c23          	sd	ra,24(sp)
    80007454:	02010413          	addi	s0,sp,32
    80007458:	00006497          	auipc	s1,0x6
    8000745c:	cb848493          	addi	s1,s1,-840 # 8000d110 <tickslock>
    80007460:	00048513          	mv	a0,s1
    80007464:	00001097          	auipc	ra,0x1
    80007468:	428080e7          	jalr	1064(ra) # 8000888c <acquire>
    8000746c:	00005717          	auipc	a4,0x5
    80007470:	86870713          	addi	a4,a4,-1944 # 8000bcd4 <ticks>
    80007474:	00072783          	lw	a5,0(a4)
    80007478:	01013403          	ld	s0,16(sp)
    8000747c:	01813083          	ld	ra,24(sp)
    80007480:	00048513          	mv	a0,s1
    80007484:	0017879b          	addiw	a5,a5,1
    80007488:	00813483          	ld	s1,8(sp)
    8000748c:	00f72023          	sw	a5,0(a4)
    80007490:	02010113          	addi	sp,sp,32
    80007494:	00001317          	auipc	t1,0x1
    80007498:	4c430067          	jr	1220(t1) # 80008958 <release>

000000008000749c <devintr>:
    8000749c:	142027f3          	csrr	a5,scause
    800074a0:	00000513          	li	a0,0
    800074a4:	0007c463          	bltz	a5,800074ac <devintr+0x10>
    800074a8:	00008067          	ret
    800074ac:	fe010113          	addi	sp,sp,-32
    800074b0:	00813823          	sd	s0,16(sp)
    800074b4:	00113c23          	sd	ra,24(sp)
    800074b8:	00913423          	sd	s1,8(sp)
    800074bc:	02010413          	addi	s0,sp,32
    800074c0:	0ff7f713          	andi	a4,a5,255
    800074c4:	00900693          	li	a3,9
    800074c8:	04d70c63          	beq	a4,a3,80007520 <devintr+0x84>
    800074cc:	fff00713          	li	a4,-1
    800074d0:	03f71713          	slli	a4,a4,0x3f
    800074d4:	00170713          	addi	a4,a4,1
    800074d8:	00e78c63          	beq	a5,a4,800074f0 <devintr+0x54>
    800074dc:	01813083          	ld	ra,24(sp)
    800074e0:	01013403          	ld	s0,16(sp)
    800074e4:	00813483          	ld	s1,8(sp)
    800074e8:	02010113          	addi	sp,sp,32
    800074ec:	00008067          	ret
    800074f0:	00000097          	auipc	ra,0x0
    800074f4:	c8c080e7          	jalr	-884(ra) # 8000717c <cpuid>
    800074f8:	06050663          	beqz	a0,80007564 <devintr+0xc8>
    800074fc:	144027f3          	csrr	a5,sip
    80007500:	ffd7f793          	andi	a5,a5,-3
    80007504:	14479073          	csrw	sip,a5
    80007508:	01813083          	ld	ra,24(sp)
    8000750c:	01013403          	ld	s0,16(sp)
    80007510:	00813483          	ld	s1,8(sp)
    80007514:	00200513          	li	a0,2
    80007518:	02010113          	addi	sp,sp,32
    8000751c:	00008067          	ret
    80007520:	00000097          	auipc	ra,0x0
    80007524:	254080e7          	jalr	596(ra) # 80007774 <plic_claim>
    80007528:	00a00793          	li	a5,10
    8000752c:	00050493          	mv	s1,a0
    80007530:	06f50663          	beq	a0,a5,8000759c <devintr+0x100>
    80007534:	00100513          	li	a0,1
    80007538:	fa0482e3          	beqz	s1,800074dc <devintr+0x40>
    8000753c:	00048593          	mv	a1,s1
    80007540:	00002517          	auipc	a0,0x2
    80007544:	ee050513          	addi	a0,a0,-288 # 80009420 <CONSOLE_STATUS+0x410>
    80007548:	00000097          	auipc	ra,0x0
    8000754c:	670080e7          	jalr	1648(ra) # 80007bb8 <__printf>
    80007550:	00048513          	mv	a0,s1
    80007554:	00000097          	auipc	ra,0x0
    80007558:	258080e7          	jalr	600(ra) # 800077ac <plic_complete>
    8000755c:	00100513          	li	a0,1
    80007560:	f7dff06f          	j	800074dc <devintr+0x40>
    80007564:	00006517          	auipc	a0,0x6
    80007568:	bac50513          	addi	a0,a0,-1108 # 8000d110 <tickslock>
    8000756c:	00001097          	auipc	ra,0x1
    80007570:	320080e7          	jalr	800(ra) # 8000888c <acquire>
    80007574:	00004717          	auipc	a4,0x4
    80007578:	76070713          	addi	a4,a4,1888 # 8000bcd4 <ticks>
    8000757c:	00072783          	lw	a5,0(a4)
    80007580:	00006517          	auipc	a0,0x6
    80007584:	b9050513          	addi	a0,a0,-1136 # 8000d110 <tickslock>
    80007588:	0017879b          	addiw	a5,a5,1
    8000758c:	00f72023          	sw	a5,0(a4)
    80007590:	00001097          	auipc	ra,0x1
    80007594:	3c8080e7          	jalr	968(ra) # 80008958 <release>
    80007598:	f65ff06f          	j	800074fc <devintr+0x60>
    8000759c:	00001097          	auipc	ra,0x1
    800075a0:	f24080e7          	jalr	-220(ra) # 800084c0 <uartintr>
    800075a4:	fadff06f          	j	80007550 <devintr+0xb4>
	...

00000000800075b0 <kernelvec>:
    800075b0:	f0010113          	addi	sp,sp,-256
    800075b4:	00113023          	sd	ra,0(sp)
    800075b8:	00213423          	sd	sp,8(sp)
    800075bc:	00313823          	sd	gp,16(sp)
    800075c0:	00413c23          	sd	tp,24(sp)
    800075c4:	02513023          	sd	t0,32(sp)
    800075c8:	02613423          	sd	t1,40(sp)
    800075cc:	02713823          	sd	t2,48(sp)
    800075d0:	02813c23          	sd	s0,56(sp)
    800075d4:	04913023          	sd	s1,64(sp)
    800075d8:	04a13423          	sd	a0,72(sp)
    800075dc:	04b13823          	sd	a1,80(sp)
    800075e0:	04c13c23          	sd	a2,88(sp)
    800075e4:	06d13023          	sd	a3,96(sp)
    800075e8:	06e13423          	sd	a4,104(sp)
    800075ec:	06f13823          	sd	a5,112(sp)
    800075f0:	07013c23          	sd	a6,120(sp)
    800075f4:	09113023          	sd	a7,128(sp)
    800075f8:	09213423          	sd	s2,136(sp)
    800075fc:	09313823          	sd	s3,144(sp)
    80007600:	09413c23          	sd	s4,152(sp)
    80007604:	0b513023          	sd	s5,160(sp)
    80007608:	0b613423          	sd	s6,168(sp)
    8000760c:	0b713823          	sd	s7,176(sp)
    80007610:	0b813c23          	sd	s8,184(sp)
    80007614:	0d913023          	sd	s9,192(sp)
    80007618:	0da13423          	sd	s10,200(sp)
    8000761c:	0db13823          	sd	s11,208(sp)
    80007620:	0dc13c23          	sd	t3,216(sp)
    80007624:	0fd13023          	sd	t4,224(sp)
    80007628:	0fe13423          	sd	t5,232(sp)
    8000762c:	0ff13823          	sd	t6,240(sp)
    80007630:	ccdff0ef          	jal	ra,800072fc <kerneltrap>
    80007634:	00013083          	ld	ra,0(sp)
    80007638:	00813103          	ld	sp,8(sp)
    8000763c:	01013183          	ld	gp,16(sp)
    80007640:	02013283          	ld	t0,32(sp)
    80007644:	02813303          	ld	t1,40(sp)
    80007648:	03013383          	ld	t2,48(sp)
    8000764c:	03813403          	ld	s0,56(sp)
    80007650:	04013483          	ld	s1,64(sp)
    80007654:	04813503          	ld	a0,72(sp)
    80007658:	05013583          	ld	a1,80(sp)
    8000765c:	05813603          	ld	a2,88(sp)
    80007660:	06013683          	ld	a3,96(sp)
    80007664:	06813703          	ld	a4,104(sp)
    80007668:	07013783          	ld	a5,112(sp)
    8000766c:	07813803          	ld	a6,120(sp)
    80007670:	08013883          	ld	a7,128(sp)
    80007674:	08813903          	ld	s2,136(sp)
    80007678:	09013983          	ld	s3,144(sp)
    8000767c:	09813a03          	ld	s4,152(sp)
    80007680:	0a013a83          	ld	s5,160(sp)
    80007684:	0a813b03          	ld	s6,168(sp)
    80007688:	0b013b83          	ld	s7,176(sp)
    8000768c:	0b813c03          	ld	s8,184(sp)
    80007690:	0c013c83          	ld	s9,192(sp)
    80007694:	0c813d03          	ld	s10,200(sp)
    80007698:	0d013d83          	ld	s11,208(sp)
    8000769c:	0d813e03          	ld	t3,216(sp)
    800076a0:	0e013e83          	ld	t4,224(sp)
    800076a4:	0e813f03          	ld	t5,232(sp)
    800076a8:	0f013f83          	ld	t6,240(sp)
    800076ac:	10010113          	addi	sp,sp,256
    800076b0:	10200073          	sret
    800076b4:	00000013          	nop
    800076b8:	00000013          	nop
    800076bc:	00000013          	nop

00000000800076c0 <timervec>:
    800076c0:	34051573          	csrrw	a0,mscratch,a0
    800076c4:	00b53023          	sd	a1,0(a0)
    800076c8:	00c53423          	sd	a2,8(a0)
    800076cc:	00d53823          	sd	a3,16(a0)
    800076d0:	01853583          	ld	a1,24(a0)
    800076d4:	02053603          	ld	a2,32(a0)
    800076d8:	0005b683          	ld	a3,0(a1)
    800076dc:	00c686b3          	add	a3,a3,a2
    800076e0:	00d5b023          	sd	a3,0(a1)
    800076e4:	00200593          	li	a1,2
    800076e8:	14459073          	csrw	sip,a1
    800076ec:	01053683          	ld	a3,16(a0)
    800076f0:	00853603          	ld	a2,8(a0)
    800076f4:	00053583          	ld	a1,0(a0)
    800076f8:	34051573          	csrrw	a0,mscratch,a0
    800076fc:	30200073          	mret

0000000080007700 <plicinit>:
    80007700:	ff010113          	addi	sp,sp,-16
    80007704:	00813423          	sd	s0,8(sp)
    80007708:	01010413          	addi	s0,sp,16
    8000770c:	00813403          	ld	s0,8(sp)
    80007710:	0c0007b7          	lui	a5,0xc000
    80007714:	00100713          	li	a4,1
    80007718:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    8000771c:	00e7a223          	sw	a4,4(a5)
    80007720:	01010113          	addi	sp,sp,16
    80007724:	00008067          	ret

0000000080007728 <plicinithart>:
    80007728:	ff010113          	addi	sp,sp,-16
    8000772c:	00813023          	sd	s0,0(sp)
    80007730:	00113423          	sd	ra,8(sp)
    80007734:	01010413          	addi	s0,sp,16
    80007738:	00000097          	auipc	ra,0x0
    8000773c:	a44080e7          	jalr	-1468(ra) # 8000717c <cpuid>
    80007740:	0085171b          	slliw	a4,a0,0x8
    80007744:	0c0027b7          	lui	a5,0xc002
    80007748:	00e787b3          	add	a5,a5,a4
    8000774c:	40200713          	li	a4,1026
    80007750:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80007754:	00813083          	ld	ra,8(sp)
    80007758:	00013403          	ld	s0,0(sp)
    8000775c:	00d5151b          	slliw	a0,a0,0xd
    80007760:	0c2017b7          	lui	a5,0xc201
    80007764:	00a78533          	add	a0,a5,a0
    80007768:	00052023          	sw	zero,0(a0)
    8000776c:	01010113          	addi	sp,sp,16
    80007770:	00008067          	ret

0000000080007774 <plic_claim>:
    80007774:	ff010113          	addi	sp,sp,-16
    80007778:	00813023          	sd	s0,0(sp)
    8000777c:	00113423          	sd	ra,8(sp)
    80007780:	01010413          	addi	s0,sp,16
    80007784:	00000097          	auipc	ra,0x0
    80007788:	9f8080e7          	jalr	-1544(ra) # 8000717c <cpuid>
    8000778c:	00813083          	ld	ra,8(sp)
    80007790:	00013403          	ld	s0,0(sp)
    80007794:	00d5151b          	slliw	a0,a0,0xd
    80007798:	0c2017b7          	lui	a5,0xc201
    8000779c:	00a78533          	add	a0,a5,a0
    800077a0:	00452503          	lw	a0,4(a0)
    800077a4:	01010113          	addi	sp,sp,16
    800077a8:	00008067          	ret

00000000800077ac <plic_complete>:
    800077ac:	fe010113          	addi	sp,sp,-32
    800077b0:	00813823          	sd	s0,16(sp)
    800077b4:	00913423          	sd	s1,8(sp)
    800077b8:	00113c23          	sd	ra,24(sp)
    800077bc:	02010413          	addi	s0,sp,32
    800077c0:	00050493          	mv	s1,a0
    800077c4:	00000097          	auipc	ra,0x0
    800077c8:	9b8080e7          	jalr	-1608(ra) # 8000717c <cpuid>
    800077cc:	01813083          	ld	ra,24(sp)
    800077d0:	01013403          	ld	s0,16(sp)
    800077d4:	00d5179b          	slliw	a5,a0,0xd
    800077d8:	0c201737          	lui	a4,0xc201
    800077dc:	00f707b3          	add	a5,a4,a5
    800077e0:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    800077e4:	00813483          	ld	s1,8(sp)
    800077e8:	02010113          	addi	sp,sp,32
    800077ec:	00008067          	ret

00000000800077f0 <consolewrite>:
    800077f0:	fb010113          	addi	sp,sp,-80
    800077f4:	04813023          	sd	s0,64(sp)
    800077f8:	04113423          	sd	ra,72(sp)
    800077fc:	02913c23          	sd	s1,56(sp)
    80007800:	03213823          	sd	s2,48(sp)
    80007804:	03313423          	sd	s3,40(sp)
    80007808:	03413023          	sd	s4,32(sp)
    8000780c:	01513c23          	sd	s5,24(sp)
    80007810:	05010413          	addi	s0,sp,80
    80007814:	06c05c63          	blez	a2,8000788c <consolewrite+0x9c>
    80007818:	00060993          	mv	s3,a2
    8000781c:	00050a13          	mv	s4,a0
    80007820:	00058493          	mv	s1,a1
    80007824:	00000913          	li	s2,0
    80007828:	fff00a93          	li	s5,-1
    8000782c:	01c0006f          	j	80007848 <consolewrite+0x58>
    80007830:	fbf44503          	lbu	a0,-65(s0)
    80007834:	0019091b          	addiw	s2,s2,1
    80007838:	00148493          	addi	s1,s1,1
    8000783c:	00001097          	auipc	ra,0x1
    80007840:	a9c080e7          	jalr	-1380(ra) # 800082d8 <uartputc>
    80007844:	03298063          	beq	s3,s2,80007864 <consolewrite+0x74>
    80007848:	00048613          	mv	a2,s1
    8000784c:	00100693          	li	a3,1
    80007850:	000a0593          	mv	a1,s4
    80007854:	fbf40513          	addi	a0,s0,-65
    80007858:	00000097          	auipc	ra,0x0
    8000785c:	9dc080e7          	jalr	-1572(ra) # 80007234 <either_copyin>
    80007860:	fd5518e3          	bne	a0,s5,80007830 <consolewrite+0x40>
    80007864:	04813083          	ld	ra,72(sp)
    80007868:	04013403          	ld	s0,64(sp)
    8000786c:	03813483          	ld	s1,56(sp)
    80007870:	02813983          	ld	s3,40(sp)
    80007874:	02013a03          	ld	s4,32(sp)
    80007878:	01813a83          	ld	s5,24(sp)
    8000787c:	00090513          	mv	a0,s2
    80007880:	03013903          	ld	s2,48(sp)
    80007884:	05010113          	addi	sp,sp,80
    80007888:	00008067          	ret
    8000788c:	00000913          	li	s2,0
    80007890:	fd5ff06f          	j	80007864 <consolewrite+0x74>

0000000080007894 <consoleread>:
    80007894:	f9010113          	addi	sp,sp,-112
    80007898:	06813023          	sd	s0,96(sp)
    8000789c:	04913c23          	sd	s1,88(sp)
    800078a0:	05213823          	sd	s2,80(sp)
    800078a4:	05313423          	sd	s3,72(sp)
    800078a8:	05413023          	sd	s4,64(sp)
    800078ac:	03513c23          	sd	s5,56(sp)
    800078b0:	03613823          	sd	s6,48(sp)
    800078b4:	03713423          	sd	s7,40(sp)
    800078b8:	03813023          	sd	s8,32(sp)
    800078bc:	06113423          	sd	ra,104(sp)
    800078c0:	01913c23          	sd	s9,24(sp)
    800078c4:	07010413          	addi	s0,sp,112
    800078c8:	00060b93          	mv	s7,a2
    800078cc:	00050913          	mv	s2,a0
    800078d0:	00058c13          	mv	s8,a1
    800078d4:	00060b1b          	sext.w	s6,a2
    800078d8:	00006497          	auipc	s1,0x6
    800078dc:	86048493          	addi	s1,s1,-1952 # 8000d138 <cons>
    800078e0:	00400993          	li	s3,4
    800078e4:	fff00a13          	li	s4,-1
    800078e8:	00a00a93          	li	s5,10
    800078ec:	05705e63          	blez	s7,80007948 <consoleread+0xb4>
    800078f0:	09c4a703          	lw	a4,156(s1)
    800078f4:	0984a783          	lw	a5,152(s1)
    800078f8:	0007071b          	sext.w	a4,a4
    800078fc:	08e78463          	beq	a5,a4,80007984 <consoleread+0xf0>
    80007900:	07f7f713          	andi	a4,a5,127
    80007904:	00e48733          	add	a4,s1,a4
    80007908:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    8000790c:	0017869b          	addiw	a3,a5,1
    80007910:	08d4ac23          	sw	a3,152(s1)
    80007914:	00070c9b          	sext.w	s9,a4
    80007918:	0b370663          	beq	a4,s3,800079c4 <consoleread+0x130>
    8000791c:	00100693          	li	a3,1
    80007920:	f9f40613          	addi	a2,s0,-97
    80007924:	000c0593          	mv	a1,s8
    80007928:	00090513          	mv	a0,s2
    8000792c:	f8e40fa3          	sb	a4,-97(s0)
    80007930:	00000097          	auipc	ra,0x0
    80007934:	8b8080e7          	jalr	-1864(ra) # 800071e8 <either_copyout>
    80007938:	01450863          	beq	a0,s4,80007948 <consoleread+0xb4>
    8000793c:	001c0c13          	addi	s8,s8,1
    80007940:	fffb8b9b          	addiw	s7,s7,-1
    80007944:	fb5c94e3          	bne	s9,s5,800078ec <consoleread+0x58>
    80007948:	000b851b          	sext.w	a0,s7
    8000794c:	06813083          	ld	ra,104(sp)
    80007950:	06013403          	ld	s0,96(sp)
    80007954:	05813483          	ld	s1,88(sp)
    80007958:	05013903          	ld	s2,80(sp)
    8000795c:	04813983          	ld	s3,72(sp)
    80007960:	04013a03          	ld	s4,64(sp)
    80007964:	03813a83          	ld	s5,56(sp)
    80007968:	02813b83          	ld	s7,40(sp)
    8000796c:	02013c03          	ld	s8,32(sp)
    80007970:	01813c83          	ld	s9,24(sp)
    80007974:	40ab053b          	subw	a0,s6,a0
    80007978:	03013b03          	ld	s6,48(sp)
    8000797c:	07010113          	addi	sp,sp,112
    80007980:	00008067          	ret
    80007984:	00001097          	auipc	ra,0x1
    80007988:	1d8080e7          	jalr	472(ra) # 80008b5c <push_on>
    8000798c:	0984a703          	lw	a4,152(s1)
    80007990:	09c4a783          	lw	a5,156(s1)
    80007994:	0007879b          	sext.w	a5,a5
    80007998:	fef70ce3          	beq	a4,a5,80007990 <consoleread+0xfc>
    8000799c:	00001097          	auipc	ra,0x1
    800079a0:	234080e7          	jalr	564(ra) # 80008bd0 <pop_on>
    800079a4:	0984a783          	lw	a5,152(s1)
    800079a8:	07f7f713          	andi	a4,a5,127
    800079ac:	00e48733          	add	a4,s1,a4
    800079b0:	01874703          	lbu	a4,24(a4)
    800079b4:	0017869b          	addiw	a3,a5,1
    800079b8:	08d4ac23          	sw	a3,152(s1)
    800079bc:	00070c9b          	sext.w	s9,a4
    800079c0:	f5371ee3          	bne	a4,s3,8000791c <consoleread+0x88>
    800079c4:	000b851b          	sext.w	a0,s7
    800079c8:	f96bf2e3          	bgeu	s7,s6,8000794c <consoleread+0xb8>
    800079cc:	08f4ac23          	sw	a5,152(s1)
    800079d0:	f7dff06f          	j	8000794c <consoleread+0xb8>

00000000800079d4 <consputc>:
    800079d4:	10000793          	li	a5,256
    800079d8:	00f50663          	beq	a0,a5,800079e4 <consputc+0x10>
    800079dc:	00001317          	auipc	t1,0x1
    800079e0:	9f430067          	jr	-1548(t1) # 800083d0 <uartputc_sync>
    800079e4:	ff010113          	addi	sp,sp,-16
    800079e8:	00113423          	sd	ra,8(sp)
    800079ec:	00813023          	sd	s0,0(sp)
    800079f0:	01010413          	addi	s0,sp,16
    800079f4:	00800513          	li	a0,8
    800079f8:	00001097          	auipc	ra,0x1
    800079fc:	9d8080e7          	jalr	-1576(ra) # 800083d0 <uartputc_sync>
    80007a00:	02000513          	li	a0,32
    80007a04:	00001097          	auipc	ra,0x1
    80007a08:	9cc080e7          	jalr	-1588(ra) # 800083d0 <uartputc_sync>
    80007a0c:	00013403          	ld	s0,0(sp)
    80007a10:	00813083          	ld	ra,8(sp)
    80007a14:	00800513          	li	a0,8
    80007a18:	01010113          	addi	sp,sp,16
    80007a1c:	00001317          	auipc	t1,0x1
    80007a20:	9b430067          	jr	-1612(t1) # 800083d0 <uartputc_sync>

0000000080007a24 <consoleintr>:
    80007a24:	fe010113          	addi	sp,sp,-32
    80007a28:	00813823          	sd	s0,16(sp)
    80007a2c:	00913423          	sd	s1,8(sp)
    80007a30:	01213023          	sd	s2,0(sp)
    80007a34:	00113c23          	sd	ra,24(sp)
    80007a38:	02010413          	addi	s0,sp,32
    80007a3c:	00005917          	auipc	s2,0x5
    80007a40:	6fc90913          	addi	s2,s2,1788 # 8000d138 <cons>
    80007a44:	00050493          	mv	s1,a0
    80007a48:	00090513          	mv	a0,s2
    80007a4c:	00001097          	auipc	ra,0x1
    80007a50:	e40080e7          	jalr	-448(ra) # 8000888c <acquire>
    80007a54:	02048c63          	beqz	s1,80007a8c <consoleintr+0x68>
    80007a58:	0a092783          	lw	a5,160(s2)
    80007a5c:	09892703          	lw	a4,152(s2)
    80007a60:	07f00693          	li	a3,127
    80007a64:	40e7873b          	subw	a4,a5,a4
    80007a68:	02e6e263          	bltu	a3,a4,80007a8c <consoleintr+0x68>
    80007a6c:	00d00713          	li	a4,13
    80007a70:	04e48063          	beq	s1,a4,80007ab0 <consoleintr+0x8c>
    80007a74:	07f7f713          	andi	a4,a5,127
    80007a78:	00e90733          	add	a4,s2,a4
    80007a7c:	0017879b          	addiw	a5,a5,1
    80007a80:	0af92023          	sw	a5,160(s2)
    80007a84:	00970c23          	sb	s1,24(a4)
    80007a88:	08f92e23          	sw	a5,156(s2)
    80007a8c:	01013403          	ld	s0,16(sp)
    80007a90:	01813083          	ld	ra,24(sp)
    80007a94:	00813483          	ld	s1,8(sp)
    80007a98:	00013903          	ld	s2,0(sp)
    80007a9c:	00005517          	auipc	a0,0x5
    80007aa0:	69c50513          	addi	a0,a0,1692 # 8000d138 <cons>
    80007aa4:	02010113          	addi	sp,sp,32
    80007aa8:	00001317          	auipc	t1,0x1
    80007aac:	eb030067          	jr	-336(t1) # 80008958 <release>
    80007ab0:	00a00493          	li	s1,10
    80007ab4:	fc1ff06f          	j	80007a74 <consoleintr+0x50>

0000000080007ab8 <consoleinit>:
    80007ab8:	fe010113          	addi	sp,sp,-32
    80007abc:	00113c23          	sd	ra,24(sp)
    80007ac0:	00813823          	sd	s0,16(sp)
    80007ac4:	00913423          	sd	s1,8(sp)
    80007ac8:	02010413          	addi	s0,sp,32
    80007acc:	00005497          	auipc	s1,0x5
    80007ad0:	66c48493          	addi	s1,s1,1644 # 8000d138 <cons>
    80007ad4:	00048513          	mv	a0,s1
    80007ad8:	00002597          	auipc	a1,0x2
    80007adc:	9a058593          	addi	a1,a1,-1632 # 80009478 <CONSOLE_STATUS+0x468>
    80007ae0:	00001097          	auipc	ra,0x1
    80007ae4:	d88080e7          	jalr	-632(ra) # 80008868 <initlock>
    80007ae8:	00000097          	auipc	ra,0x0
    80007aec:	7ac080e7          	jalr	1964(ra) # 80008294 <uartinit>
    80007af0:	01813083          	ld	ra,24(sp)
    80007af4:	01013403          	ld	s0,16(sp)
    80007af8:	00000797          	auipc	a5,0x0
    80007afc:	d9c78793          	addi	a5,a5,-612 # 80007894 <consoleread>
    80007b00:	0af4bc23          	sd	a5,184(s1)
    80007b04:	00000797          	auipc	a5,0x0
    80007b08:	cec78793          	addi	a5,a5,-788 # 800077f0 <consolewrite>
    80007b0c:	0cf4b023          	sd	a5,192(s1)
    80007b10:	00813483          	ld	s1,8(sp)
    80007b14:	02010113          	addi	sp,sp,32
    80007b18:	00008067          	ret

0000000080007b1c <console_read>:
    80007b1c:	ff010113          	addi	sp,sp,-16
    80007b20:	00813423          	sd	s0,8(sp)
    80007b24:	01010413          	addi	s0,sp,16
    80007b28:	00813403          	ld	s0,8(sp)
    80007b2c:	00005317          	auipc	t1,0x5
    80007b30:	6c433303          	ld	t1,1732(t1) # 8000d1f0 <devsw+0x10>
    80007b34:	01010113          	addi	sp,sp,16
    80007b38:	00030067          	jr	t1

0000000080007b3c <console_write>:
    80007b3c:	ff010113          	addi	sp,sp,-16
    80007b40:	00813423          	sd	s0,8(sp)
    80007b44:	01010413          	addi	s0,sp,16
    80007b48:	00813403          	ld	s0,8(sp)
    80007b4c:	00005317          	auipc	t1,0x5
    80007b50:	6ac33303          	ld	t1,1708(t1) # 8000d1f8 <devsw+0x18>
    80007b54:	01010113          	addi	sp,sp,16
    80007b58:	00030067          	jr	t1

0000000080007b5c <panic>:
    80007b5c:	fe010113          	addi	sp,sp,-32
    80007b60:	00113c23          	sd	ra,24(sp)
    80007b64:	00813823          	sd	s0,16(sp)
    80007b68:	00913423          	sd	s1,8(sp)
    80007b6c:	02010413          	addi	s0,sp,32
    80007b70:	00050493          	mv	s1,a0
    80007b74:	00002517          	auipc	a0,0x2
    80007b78:	90c50513          	addi	a0,a0,-1780 # 80009480 <CONSOLE_STATUS+0x470>
    80007b7c:	00005797          	auipc	a5,0x5
    80007b80:	7007ae23          	sw	zero,1820(a5) # 8000d298 <pr+0x18>
    80007b84:	00000097          	auipc	ra,0x0
    80007b88:	034080e7          	jalr	52(ra) # 80007bb8 <__printf>
    80007b8c:	00048513          	mv	a0,s1
    80007b90:	00000097          	auipc	ra,0x0
    80007b94:	028080e7          	jalr	40(ra) # 80007bb8 <__printf>
    80007b98:	00001517          	auipc	a0,0x1
    80007b9c:	5f050513          	addi	a0,a0,1520 # 80009188 <CONSOLE_STATUS+0x178>
    80007ba0:	00000097          	auipc	ra,0x0
    80007ba4:	018080e7          	jalr	24(ra) # 80007bb8 <__printf>
    80007ba8:	00100793          	li	a5,1
    80007bac:	00004717          	auipc	a4,0x4
    80007bb0:	12f72623          	sw	a5,300(a4) # 8000bcd8 <panicked>
    80007bb4:	0000006f          	j	80007bb4 <panic+0x58>

0000000080007bb8 <__printf>:
    80007bb8:	f3010113          	addi	sp,sp,-208
    80007bbc:	08813023          	sd	s0,128(sp)
    80007bc0:	07313423          	sd	s3,104(sp)
    80007bc4:	09010413          	addi	s0,sp,144
    80007bc8:	05813023          	sd	s8,64(sp)
    80007bcc:	08113423          	sd	ra,136(sp)
    80007bd0:	06913c23          	sd	s1,120(sp)
    80007bd4:	07213823          	sd	s2,112(sp)
    80007bd8:	07413023          	sd	s4,96(sp)
    80007bdc:	05513c23          	sd	s5,88(sp)
    80007be0:	05613823          	sd	s6,80(sp)
    80007be4:	05713423          	sd	s7,72(sp)
    80007be8:	03913c23          	sd	s9,56(sp)
    80007bec:	03a13823          	sd	s10,48(sp)
    80007bf0:	03b13423          	sd	s11,40(sp)
    80007bf4:	00005317          	auipc	t1,0x5
    80007bf8:	68c30313          	addi	t1,t1,1676 # 8000d280 <pr>
    80007bfc:	01832c03          	lw	s8,24(t1)
    80007c00:	00b43423          	sd	a1,8(s0)
    80007c04:	00c43823          	sd	a2,16(s0)
    80007c08:	00d43c23          	sd	a3,24(s0)
    80007c0c:	02e43023          	sd	a4,32(s0)
    80007c10:	02f43423          	sd	a5,40(s0)
    80007c14:	03043823          	sd	a6,48(s0)
    80007c18:	03143c23          	sd	a7,56(s0)
    80007c1c:	00050993          	mv	s3,a0
    80007c20:	4a0c1663          	bnez	s8,800080cc <__printf+0x514>
    80007c24:	60098c63          	beqz	s3,8000823c <__printf+0x684>
    80007c28:	0009c503          	lbu	a0,0(s3)
    80007c2c:	00840793          	addi	a5,s0,8
    80007c30:	f6f43c23          	sd	a5,-136(s0)
    80007c34:	00000493          	li	s1,0
    80007c38:	22050063          	beqz	a0,80007e58 <__printf+0x2a0>
    80007c3c:	00002a37          	lui	s4,0x2
    80007c40:	00018ab7          	lui	s5,0x18
    80007c44:	000f4b37          	lui	s6,0xf4
    80007c48:	00989bb7          	lui	s7,0x989
    80007c4c:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    80007c50:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    80007c54:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    80007c58:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    80007c5c:	00148c9b          	addiw	s9,s1,1
    80007c60:	02500793          	li	a5,37
    80007c64:	01998933          	add	s2,s3,s9
    80007c68:	38f51263          	bne	a0,a5,80007fec <__printf+0x434>
    80007c6c:	00094783          	lbu	a5,0(s2)
    80007c70:	00078c9b          	sext.w	s9,a5
    80007c74:	1e078263          	beqz	a5,80007e58 <__printf+0x2a0>
    80007c78:	0024849b          	addiw	s1,s1,2
    80007c7c:	07000713          	li	a4,112
    80007c80:	00998933          	add	s2,s3,s1
    80007c84:	38e78a63          	beq	a5,a4,80008018 <__printf+0x460>
    80007c88:	20f76863          	bltu	a4,a5,80007e98 <__printf+0x2e0>
    80007c8c:	42a78863          	beq	a5,a0,800080bc <__printf+0x504>
    80007c90:	06400713          	li	a4,100
    80007c94:	40e79663          	bne	a5,a4,800080a0 <__printf+0x4e8>
    80007c98:	f7843783          	ld	a5,-136(s0)
    80007c9c:	0007a603          	lw	a2,0(a5)
    80007ca0:	00878793          	addi	a5,a5,8
    80007ca4:	f6f43c23          	sd	a5,-136(s0)
    80007ca8:	42064a63          	bltz	a2,800080dc <__printf+0x524>
    80007cac:	00a00713          	li	a4,10
    80007cb0:	02e677bb          	remuw	a5,a2,a4
    80007cb4:	00001d97          	auipc	s11,0x1
    80007cb8:	7f4d8d93          	addi	s11,s11,2036 # 800094a8 <digits>
    80007cbc:	00900593          	li	a1,9
    80007cc0:	0006051b          	sext.w	a0,a2
    80007cc4:	00000c93          	li	s9,0
    80007cc8:	02079793          	slli	a5,a5,0x20
    80007ccc:	0207d793          	srli	a5,a5,0x20
    80007cd0:	00fd87b3          	add	a5,s11,a5
    80007cd4:	0007c783          	lbu	a5,0(a5)
    80007cd8:	02e656bb          	divuw	a3,a2,a4
    80007cdc:	f8f40023          	sb	a5,-128(s0)
    80007ce0:	14c5d863          	bge	a1,a2,80007e30 <__printf+0x278>
    80007ce4:	06300593          	li	a1,99
    80007ce8:	00100c93          	li	s9,1
    80007cec:	02e6f7bb          	remuw	a5,a3,a4
    80007cf0:	02079793          	slli	a5,a5,0x20
    80007cf4:	0207d793          	srli	a5,a5,0x20
    80007cf8:	00fd87b3          	add	a5,s11,a5
    80007cfc:	0007c783          	lbu	a5,0(a5)
    80007d00:	02e6d73b          	divuw	a4,a3,a4
    80007d04:	f8f400a3          	sb	a5,-127(s0)
    80007d08:	12a5f463          	bgeu	a1,a0,80007e30 <__printf+0x278>
    80007d0c:	00a00693          	li	a3,10
    80007d10:	00900593          	li	a1,9
    80007d14:	02d777bb          	remuw	a5,a4,a3
    80007d18:	02079793          	slli	a5,a5,0x20
    80007d1c:	0207d793          	srli	a5,a5,0x20
    80007d20:	00fd87b3          	add	a5,s11,a5
    80007d24:	0007c503          	lbu	a0,0(a5)
    80007d28:	02d757bb          	divuw	a5,a4,a3
    80007d2c:	f8a40123          	sb	a0,-126(s0)
    80007d30:	48e5f263          	bgeu	a1,a4,800081b4 <__printf+0x5fc>
    80007d34:	06300513          	li	a0,99
    80007d38:	02d7f5bb          	remuw	a1,a5,a3
    80007d3c:	02059593          	slli	a1,a1,0x20
    80007d40:	0205d593          	srli	a1,a1,0x20
    80007d44:	00bd85b3          	add	a1,s11,a1
    80007d48:	0005c583          	lbu	a1,0(a1)
    80007d4c:	02d7d7bb          	divuw	a5,a5,a3
    80007d50:	f8b401a3          	sb	a1,-125(s0)
    80007d54:	48e57263          	bgeu	a0,a4,800081d8 <__printf+0x620>
    80007d58:	3e700513          	li	a0,999
    80007d5c:	02d7f5bb          	remuw	a1,a5,a3
    80007d60:	02059593          	slli	a1,a1,0x20
    80007d64:	0205d593          	srli	a1,a1,0x20
    80007d68:	00bd85b3          	add	a1,s11,a1
    80007d6c:	0005c583          	lbu	a1,0(a1)
    80007d70:	02d7d7bb          	divuw	a5,a5,a3
    80007d74:	f8b40223          	sb	a1,-124(s0)
    80007d78:	46e57663          	bgeu	a0,a4,800081e4 <__printf+0x62c>
    80007d7c:	02d7f5bb          	remuw	a1,a5,a3
    80007d80:	02059593          	slli	a1,a1,0x20
    80007d84:	0205d593          	srli	a1,a1,0x20
    80007d88:	00bd85b3          	add	a1,s11,a1
    80007d8c:	0005c583          	lbu	a1,0(a1)
    80007d90:	02d7d7bb          	divuw	a5,a5,a3
    80007d94:	f8b402a3          	sb	a1,-123(s0)
    80007d98:	46ea7863          	bgeu	s4,a4,80008208 <__printf+0x650>
    80007d9c:	02d7f5bb          	remuw	a1,a5,a3
    80007da0:	02059593          	slli	a1,a1,0x20
    80007da4:	0205d593          	srli	a1,a1,0x20
    80007da8:	00bd85b3          	add	a1,s11,a1
    80007dac:	0005c583          	lbu	a1,0(a1)
    80007db0:	02d7d7bb          	divuw	a5,a5,a3
    80007db4:	f8b40323          	sb	a1,-122(s0)
    80007db8:	3eeaf863          	bgeu	s5,a4,800081a8 <__printf+0x5f0>
    80007dbc:	02d7f5bb          	remuw	a1,a5,a3
    80007dc0:	02059593          	slli	a1,a1,0x20
    80007dc4:	0205d593          	srli	a1,a1,0x20
    80007dc8:	00bd85b3          	add	a1,s11,a1
    80007dcc:	0005c583          	lbu	a1,0(a1)
    80007dd0:	02d7d7bb          	divuw	a5,a5,a3
    80007dd4:	f8b403a3          	sb	a1,-121(s0)
    80007dd8:	42eb7e63          	bgeu	s6,a4,80008214 <__printf+0x65c>
    80007ddc:	02d7f5bb          	remuw	a1,a5,a3
    80007de0:	02059593          	slli	a1,a1,0x20
    80007de4:	0205d593          	srli	a1,a1,0x20
    80007de8:	00bd85b3          	add	a1,s11,a1
    80007dec:	0005c583          	lbu	a1,0(a1)
    80007df0:	02d7d7bb          	divuw	a5,a5,a3
    80007df4:	f8b40423          	sb	a1,-120(s0)
    80007df8:	42ebfc63          	bgeu	s7,a4,80008230 <__printf+0x678>
    80007dfc:	02079793          	slli	a5,a5,0x20
    80007e00:	0207d793          	srli	a5,a5,0x20
    80007e04:	00fd8db3          	add	s11,s11,a5
    80007e08:	000dc703          	lbu	a4,0(s11)
    80007e0c:	00a00793          	li	a5,10
    80007e10:	00900c93          	li	s9,9
    80007e14:	f8e404a3          	sb	a4,-119(s0)
    80007e18:	00065c63          	bgez	a2,80007e30 <__printf+0x278>
    80007e1c:	f9040713          	addi	a4,s0,-112
    80007e20:	00f70733          	add	a4,a4,a5
    80007e24:	02d00693          	li	a3,45
    80007e28:	fed70823          	sb	a3,-16(a4)
    80007e2c:	00078c93          	mv	s9,a5
    80007e30:	f8040793          	addi	a5,s0,-128
    80007e34:	01978cb3          	add	s9,a5,s9
    80007e38:	f7f40d13          	addi	s10,s0,-129
    80007e3c:	000cc503          	lbu	a0,0(s9)
    80007e40:	fffc8c93          	addi	s9,s9,-1
    80007e44:	00000097          	auipc	ra,0x0
    80007e48:	b90080e7          	jalr	-1136(ra) # 800079d4 <consputc>
    80007e4c:	ffac98e3          	bne	s9,s10,80007e3c <__printf+0x284>
    80007e50:	00094503          	lbu	a0,0(s2)
    80007e54:	e00514e3          	bnez	a0,80007c5c <__printf+0xa4>
    80007e58:	1a0c1663          	bnez	s8,80008004 <__printf+0x44c>
    80007e5c:	08813083          	ld	ra,136(sp)
    80007e60:	08013403          	ld	s0,128(sp)
    80007e64:	07813483          	ld	s1,120(sp)
    80007e68:	07013903          	ld	s2,112(sp)
    80007e6c:	06813983          	ld	s3,104(sp)
    80007e70:	06013a03          	ld	s4,96(sp)
    80007e74:	05813a83          	ld	s5,88(sp)
    80007e78:	05013b03          	ld	s6,80(sp)
    80007e7c:	04813b83          	ld	s7,72(sp)
    80007e80:	04013c03          	ld	s8,64(sp)
    80007e84:	03813c83          	ld	s9,56(sp)
    80007e88:	03013d03          	ld	s10,48(sp)
    80007e8c:	02813d83          	ld	s11,40(sp)
    80007e90:	0d010113          	addi	sp,sp,208
    80007e94:	00008067          	ret
    80007e98:	07300713          	li	a4,115
    80007e9c:	1ce78a63          	beq	a5,a4,80008070 <__printf+0x4b8>
    80007ea0:	07800713          	li	a4,120
    80007ea4:	1ee79e63          	bne	a5,a4,800080a0 <__printf+0x4e8>
    80007ea8:	f7843783          	ld	a5,-136(s0)
    80007eac:	0007a703          	lw	a4,0(a5)
    80007eb0:	00878793          	addi	a5,a5,8
    80007eb4:	f6f43c23          	sd	a5,-136(s0)
    80007eb8:	28074263          	bltz	a4,8000813c <__printf+0x584>
    80007ebc:	00001d97          	auipc	s11,0x1
    80007ec0:	5ecd8d93          	addi	s11,s11,1516 # 800094a8 <digits>
    80007ec4:	00f77793          	andi	a5,a4,15
    80007ec8:	00fd87b3          	add	a5,s11,a5
    80007ecc:	0007c683          	lbu	a3,0(a5)
    80007ed0:	00f00613          	li	a2,15
    80007ed4:	0007079b          	sext.w	a5,a4
    80007ed8:	f8d40023          	sb	a3,-128(s0)
    80007edc:	0047559b          	srliw	a1,a4,0x4
    80007ee0:	0047569b          	srliw	a3,a4,0x4
    80007ee4:	00000c93          	li	s9,0
    80007ee8:	0ee65063          	bge	a2,a4,80007fc8 <__printf+0x410>
    80007eec:	00f6f693          	andi	a3,a3,15
    80007ef0:	00dd86b3          	add	a3,s11,a3
    80007ef4:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    80007ef8:	0087d79b          	srliw	a5,a5,0x8
    80007efc:	00100c93          	li	s9,1
    80007f00:	f8d400a3          	sb	a3,-127(s0)
    80007f04:	0cb67263          	bgeu	a2,a1,80007fc8 <__printf+0x410>
    80007f08:	00f7f693          	andi	a3,a5,15
    80007f0c:	00dd86b3          	add	a3,s11,a3
    80007f10:	0006c583          	lbu	a1,0(a3)
    80007f14:	00f00613          	li	a2,15
    80007f18:	0047d69b          	srliw	a3,a5,0x4
    80007f1c:	f8b40123          	sb	a1,-126(s0)
    80007f20:	0047d593          	srli	a1,a5,0x4
    80007f24:	28f67e63          	bgeu	a2,a5,800081c0 <__printf+0x608>
    80007f28:	00f6f693          	andi	a3,a3,15
    80007f2c:	00dd86b3          	add	a3,s11,a3
    80007f30:	0006c503          	lbu	a0,0(a3)
    80007f34:	0087d813          	srli	a6,a5,0x8
    80007f38:	0087d69b          	srliw	a3,a5,0x8
    80007f3c:	f8a401a3          	sb	a0,-125(s0)
    80007f40:	28b67663          	bgeu	a2,a1,800081cc <__printf+0x614>
    80007f44:	00f6f693          	andi	a3,a3,15
    80007f48:	00dd86b3          	add	a3,s11,a3
    80007f4c:	0006c583          	lbu	a1,0(a3)
    80007f50:	00c7d513          	srli	a0,a5,0xc
    80007f54:	00c7d69b          	srliw	a3,a5,0xc
    80007f58:	f8b40223          	sb	a1,-124(s0)
    80007f5c:	29067a63          	bgeu	a2,a6,800081f0 <__printf+0x638>
    80007f60:	00f6f693          	andi	a3,a3,15
    80007f64:	00dd86b3          	add	a3,s11,a3
    80007f68:	0006c583          	lbu	a1,0(a3)
    80007f6c:	0107d813          	srli	a6,a5,0x10
    80007f70:	0107d69b          	srliw	a3,a5,0x10
    80007f74:	f8b402a3          	sb	a1,-123(s0)
    80007f78:	28a67263          	bgeu	a2,a0,800081fc <__printf+0x644>
    80007f7c:	00f6f693          	andi	a3,a3,15
    80007f80:	00dd86b3          	add	a3,s11,a3
    80007f84:	0006c683          	lbu	a3,0(a3)
    80007f88:	0147d79b          	srliw	a5,a5,0x14
    80007f8c:	f8d40323          	sb	a3,-122(s0)
    80007f90:	21067663          	bgeu	a2,a6,8000819c <__printf+0x5e4>
    80007f94:	02079793          	slli	a5,a5,0x20
    80007f98:	0207d793          	srli	a5,a5,0x20
    80007f9c:	00fd8db3          	add	s11,s11,a5
    80007fa0:	000dc683          	lbu	a3,0(s11)
    80007fa4:	00800793          	li	a5,8
    80007fa8:	00700c93          	li	s9,7
    80007fac:	f8d403a3          	sb	a3,-121(s0)
    80007fb0:	00075c63          	bgez	a4,80007fc8 <__printf+0x410>
    80007fb4:	f9040713          	addi	a4,s0,-112
    80007fb8:	00f70733          	add	a4,a4,a5
    80007fbc:	02d00693          	li	a3,45
    80007fc0:	fed70823          	sb	a3,-16(a4)
    80007fc4:	00078c93          	mv	s9,a5
    80007fc8:	f8040793          	addi	a5,s0,-128
    80007fcc:	01978cb3          	add	s9,a5,s9
    80007fd0:	f7f40d13          	addi	s10,s0,-129
    80007fd4:	000cc503          	lbu	a0,0(s9)
    80007fd8:	fffc8c93          	addi	s9,s9,-1
    80007fdc:	00000097          	auipc	ra,0x0
    80007fe0:	9f8080e7          	jalr	-1544(ra) # 800079d4 <consputc>
    80007fe4:	ff9d18e3          	bne	s10,s9,80007fd4 <__printf+0x41c>
    80007fe8:	0100006f          	j	80007ff8 <__printf+0x440>
    80007fec:	00000097          	auipc	ra,0x0
    80007ff0:	9e8080e7          	jalr	-1560(ra) # 800079d4 <consputc>
    80007ff4:	000c8493          	mv	s1,s9
    80007ff8:	00094503          	lbu	a0,0(s2)
    80007ffc:	c60510e3          	bnez	a0,80007c5c <__printf+0xa4>
    80008000:	e40c0ee3          	beqz	s8,80007e5c <__printf+0x2a4>
    80008004:	00005517          	auipc	a0,0x5
    80008008:	27c50513          	addi	a0,a0,636 # 8000d280 <pr>
    8000800c:	00001097          	auipc	ra,0x1
    80008010:	94c080e7          	jalr	-1716(ra) # 80008958 <release>
    80008014:	e49ff06f          	j	80007e5c <__printf+0x2a4>
    80008018:	f7843783          	ld	a5,-136(s0)
    8000801c:	03000513          	li	a0,48
    80008020:	01000d13          	li	s10,16
    80008024:	00878713          	addi	a4,a5,8
    80008028:	0007bc83          	ld	s9,0(a5)
    8000802c:	f6e43c23          	sd	a4,-136(s0)
    80008030:	00000097          	auipc	ra,0x0
    80008034:	9a4080e7          	jalr	-1628(ra) # 800079d4 <consputc>
    80008038:	07800513          	li	a0,120
    8000803c:	00000097          	auipc	ra,0x0
    80008040:	998080e7          	jalr	-1640(ra) # 800079d4 <consputc>
    80008044:	00001d97          	auipc	s11,0x1
    80008048:	464d8d93          	addi	s11,s11,1124 # 800094a8 <digits>
    8000804c:	03ccd793          	srli	a5,s9,0x3c
    80008050:	00fd87b3          	add	a5,s11,a5
    80008054:	0007c503          	lbu	a0,0(a5)
    80008058:	fffd0d1b          	addiw	s10,s10,-1
    8000805c:	004c9c93          	slli	s9,s9,0x4
    80008060:	00000097          	auipc	ra,0x0
    80008064:	974080e7          	jalr	-1676(ra) # 800079d4 <consputc>
    80008068:	fe0d12e3          	bnez	s10,8000804c <__printf+0x494>
    8000806c:	f8dff06f          	j	80007ff8 <__printf+0x440>
    80008070:	f7843783          	ld	a5,-136(s0)
    80008074:	0007bc83          	ld	s9,0(a5)
    80008078:	00878793          	addi	a5,a5,8
    8000807c:	f6f43c23          	sd	a5,-136(s0)
    80008080:	000c9a63          	bnez	s9,80008094 <__printf+0x4dc>
    80008084:	1080006f          	j	8000818c <__printf+0x5d4>
    80008088:	001c8c93          	addi	s9,s9,1
    8000808c:	00000097          	auipc	ra,0x0
    80008090:	948080e7          	jalr	-1720(ra) # 800079d4 <consputc>
    80008094:	000cc503          	lbu	a0,0(s9)
    80008098:	fe0518e3          	bnez	a0,80008088 <__printf+0x4d0>
    8000809c:	f5dff06f          	j	80007ff8 <__printf+0x440>
    800080a0:	02500513          	li	a0,37
    800080a4:	00000097          	auipc	ra,0x0
    800080a8:	930080e7          	jalr	-1744(ra) # 800079d4 <consputc>
    800080ac:	000c8513          	mv	a0,s9
    800080b0:	00000097          	auipc	ra,0x0
    800080b4:	924080e7          	jalr	-1756(ra) # 800079d4 <consputc>
    800080b8:	f41ff06f          	j	80007ff8 <__printf+0x440>
    800080bc:	02500513          	li	a0,37
    800080c0:	00000097          	auipc	ra,0x0
    800080c4:	914080e7          	jalr	-1772(ra) # 800079d4 <consputc>
    800080c8:	f31ff06f          	j	80007ff8 <__printf+0x440>
    800080cc:	00030513          	mv	a0,t1
    800080d0:	00000097          	auipc	ra,0x0
    800080d4:	7bc080e7          	jalr	1980(ra) # 8000888c <acquire>
    800080d8:	b4dff06f          	j	80007c24 <__printf+0x6c>
    800080dc:	40c0053b          	negw	a0,a2
    800080e0:	00a00713          	li	a4,10
    800080e4:	02e576bb          	remuw	a3,a0,a4
    800080e8:	00001d97          	auipc	s11,0x1
    800080ec:	3c0d8d93          	addi	s11,s11,960 # 800094a8 <digits>
    800080f0:	ff700593          	li	a1,-9
    800080f4:	02069693          	slli	a3,a3,0x20
    800080f8:	0206d693          	srli	a3,a3,0x20
    800080fc:	00dd86b3          	add	a3,s11,a3
    80008100:	0006c683          	lbu	a3,0(a3)
    80008104:	02e557bb          	divuw	a5,a0,a4
    80008108:	f8d40023          	sb	a3,-128(s0)
    8000810c:	10b65e63          	bge	a2,a1,80008228 <__printf+0x670>
    80008110:	06300593          	li	a1,99
    80008114:	02e7f6bb          	remuw	a3,a5,a4
    80008118:	02069693          	slli	a3,a3,0x20
    8000811c:	0206d693          	srli	a3,a3,0x20
    80008120:	00dd86b3          	add	a3,s11,a3
    80008124:	0006c683          	lbu	a3,0(a3)
    80008128:	02e7d73b          	divuw	a4,a5,a4
    8000812c:	00200793          	li	a5,2
    80008130:	f8d400a3          	sb	a3,-127(s0)
    80008134:	bca5ece3          	bltu	a1,a0,80007d0c <__printf+0x154>
    80008138:	ce5ff06f          	j	80007e1c <__printf+0x264>
    8000813c:	40e007bb          	negw	a5,a4
    80008140:	00001d97          	auipc	s11,0x1
    80008144:	368d8d93          	addi	s11,s11,872 # 800094a8 <digits>
    80008148:	00f7f693          	andi	a3,a5,15
    8000814c:	00dd86b3          	add	a3,s11,a3
    80008150:	0006c583          	lbu	a1,0(a3)
    80008154:	ff100613          	li	a2,-15
    80008158:	0047d69b          	srliw	a3,a5,0x4
    8000815c:	f8b40023          	sb	a1,-128(s0)
    80008160:	0047d59b          	srliw	a1,a5,0x4
    80008164:	0ac75e63          	bge	a4,a2,80008220 <__printf+0x668>
    80008168:	00f6f693          	andi	a3,a3,15
    8000816c:	00dd86b3          	add	a3,s11,a3
    80008170:	0006c603          	lbu	a2,0(a3)
    80008174:	00f00693          	li	a3,15
    80008178:	0087d79b          	srliw	a5,a5,0x8
    8000817c:	f8c400a3          	sb	a2,-127(s0)
    80008180:	d8b6e4e3          	bltu	a3,a1,80007f08 <__printf+0x350>
    80008184:	00200793          	li	a5,2
    80008188:	e2dff06f          	j	80007fb4 <__printf+0x3fc>
    8000818c:	00001c97          	auipc	s9,0x1
    80008190:	2fcc8c93          	addi	s9,s9,764 # 80009488 <CONSOLE_STATUS+0x478>
    80008194:	02800513          	li	a0,40
    80008198:	ef1ff06f          	j	80008088 <__printf+0x4d0>
    8000819c:	00700793          	li	a5,7
    800081a0:	00600c93          	li	s9,6
    800081a4:	e0dff06f          	j	80007fb0 <__printf+0x3f8>
    800081a8:	00700793          	li	a5,7
    800081ac:	00600c93          	li	s9,6
    800081b0:	c69ff06f          	j	80007e18 <__printf+0x260>
    800081b4:	00300793          	li	a5,3
    800081b8:	00200c93          	li	s9,2
    800081bc:	c5dff06f          	j	80007e18 <__printf+0x260>
    800081c0:	00300793          	li	a5,3
    800081c4:	00200c93          	li	s9,2
    800081c8:	de9ff06f          	j	80007fb0 <__printf+0x3f8>
    800081cc:	00400793          	li	a5,4
    800081d0:	00300c93          	li	s9,3
    800081d4:	dddff06f          	j	80007fb0 <__printf+0x3f8>
    800081d8:	00400793          	li	a5,4
    800081dc:	00300c93          	li	s9,3
    800081e0:	c39ff06f          	j	80007e18 <__printf+0x260>
    800081e4:	00500793          	li	a5,5
    800081e8:	00400c93          	li	s9,4
    800081ec:	c2dff06f          	j	80007e18 <__printf+0x260>
    800081f0:	00500793          	li	a5,5
    800081f4:	00400c93          	li	s9,4
    800081f8:	db9ff06f          	j	80007fb0 <__printf+0x3f8>
    800081fc:	00600793          	li	a5,6
    80008200:	00500c93          	li	s9,5
    80008204:	dadff06f          	j	80007fb0 <__printf+0x3f8>
    80008208:	00600793          	li	a5,6
    8000820c:	00500c93          	li	s9,5
    80008210:	c09ff06f          	j	80007e18 <__printf+0x260>
    80008214:	00800793          	li	a5,8
    80008218:	00700c93          	li	s9,7
    8000821c:	bfdff06f          	j	80007e18 <__printf+0x260>
    80008220:	00100793          	li	a5,1
    80008224:	d91ff06f          	j	80007fb4 <__printf+0x3fc>
    80008228:	00100793          	li	a5,1
    8000822c:	bf1ff06f          	j	80007e1c <__printf+0x264>
    80008230:	00900793          	li	a5,9
    80008234:	00800c93          	li	s9,8
    80008238:	be1ff06f          	j	80007e18 <__printf+0x260>
    8000823c:	00001517          	auipc	a0,0x1
    80008240:	25450513          	addi	a0,a0,596 # 80009490 <CONSOLE_STATUS+0x480>
    80008244:	00000097          	auipc	ra,0x0
    80008248:	918080e7          	jalr	-1768(ra) # 80007b5c <panic>

000000008000824c <printfinit>:
    8000824c:	fe010113          	addi	sp,sp,-32
    80008250:	00813823          	sd	s0,16(sp)
    80008254:	00913423          	sd	s1,8(sp)
    80008258:	00113c23          	sd	ra,24(sp)
    8000825c:	02010413          	addi	s0,sp,32
    80008260:	00005497          	auipc	s1,0x5
    80008264:	02048493          	addi	s1,s1,32 # 8000d280 <pr>
    80008268:	00048513          	mv	a0,s1
    8000826c:	00001597          	auipc	a1,0x1
    80008270:	23458593          	addi	a1,a1,564 # 800094a0 <CONSOLE_STATUS+0x490>
    80008274:	00000097          	auipc	ra,0x0
    80008278:	5f4080e7          	jalr	1524(ra) # 80008868 <initlock>
    8000827c:	01813083          	ld	ra,24(sp)
    80008280:	01013403          	ld	s0,16(sp)
    80008284:	0004ac23          	sw	zero,24(s1)
    80008288:	00813483          	ld	s1,8(sp)
    8000828c:	02010113          	addi	sp,sp,32
    80008290:	00008067          	ret

0000000080008294 <uartinit>:
    80008294:	ff010113          	addi	sp,sp,-16
    80008298:	00813423          	sd	s0,8(sp)
    8000829c:	01010413          	addi	s0,sp,16
    800082a0:	100007b7          	lui	a5,0x10000
    800082a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    800082a8:	f8000713          	li	a4,-128
    800082ac:	00e781a3          	sb	a4,3(a5)
    800082b0:	00300713          	li	a4,3
    800082b4:	00e78023          	sb	a4,0(a5)
    800082b8:	000780a3          	sb	zero,1(a5)
    800082bc:	00e781a3          	sb	a4,3(a5)
    800082c0:	00700693          	li	a3,7
    800082c4:	00d78123          	sb	a3,2(a5)
    800082c8:	00e780a3          	sb	a4,1(a5)
    800082cc:	00813403          	ld	s0,8(sp)
    800082d0:	01010113          	addi	sp,sp,16
    800082d4:	00008067          	ret

00000000800082d8 <uartputc>:
    800082d8:	00004797          	auipc	a5,0x4
    800082dc:	a007a783          	lw	a5,-1536(a5) # 8000bcd8 <panicked>
    800082e0:	00078463          	beqz	a5,800082e8 <uartputc+0x10>
    800082e4:	0000006f          	j	800082e4 <uartputc+0xc>
    800082e8:	fd010113          	addi	sp,sp,-48
    800082ec:	02813023          	sd	s0,32(sp)
    800082f0:	00913c23          	sd	s1,24(sp)
    800082f4:	01213823          	sd	s2,16(sp)
    800082f8:	01313423          	sd	s3,8(sp)
    800082fc:	02113423          	sd	ra,40(sp)
    80008300:	03010413          	addi	s0,sp,48
    80008304:	00004917          	auipc	s2,0x4
    80008308:	9dc90913          	addi	s2,s2,-1572 # 8000bce0 <uart_tx_r>
    8000830c:	00093783          	ld	a5,0(s2)
    80008310:	00004497          	auipc	s1,0x4
    80008314:	9d848493          	addi	s1,s1,-1576 # 8000bce8 <uart_tx_w>
    80008318:	0004b703          	ld	a4,0(s1)
    8000831c:	02078693          	addi	a3,a5,32
    80008320:	00050993          	mv	s3,a0
    80008324:	02e69c63          	bne	a3,a4,8000835c <uartputc+0x84>
    80008328:	00001097          	auipc	ra,0x1
    8000832c:	834080e7          	jalr	-1996(ra) # 80008b5c <push_on>
    80008330:	00093783          	ld	a5,0(s2)
    80008334:	0004b703          	ld	a4,0(s1)
    80008338:	02078793          	addi	a5,a5,32
    8000833c:	00e79463          	bne	a5,a4,80008344 <uartputc+0x6c>
    80008340:	0000006f          	j	80008340 <uartputc+0x68>
    80008344:	00001097          	auipc	ra,0x1
    80008348:	88c080e7          	jalr	-1908(ra) # 80008bd0 <pop_on>
    8000834c:	00093783          	ld	a5,0(s2)
    80008350:	0004b703          	ld	a4,0(s1)
    80008354:	02078693          	addi	a3,a5,32
    80008358:	fce688e3          	beq	a3,a4,80008328 <uartputc+0x50>
    8000835c:	01f77693          	andi	a3,a4,31
    80008360:	00005597          	auipc	a1,0x5
    80008364:	f4058593          	addi	a1,a1,-192 # 8000d2a0 <uart_tx_buf>
    80008368:	00d586b3          	add	a3,a1,a3
    8000836c:	00170713          	addi	a4,a4,1
    80008370:	01368023          	sb	s3,0(a3)
    80008374:	00e4b023          	sd	a4,0(s1)
    80008378:	10000637          	lui	a2,0x10000
    8000837c:	02f71063          	bne	a4,a5,8000839c <uartputc+0xc4>
    80008380:	0340006f          	j	800083b4 <uartputc+0xdc>
    80008384:	00074703          	lbu	a4,0(a4)
    80008388:	00f93023          	sd	a5,0(s2)
    8000838c:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    80008390:	00093783          	ld	a5,0(s2)
    80008394:	0004b703          	ld	a4,0(s1)
    80008398:	00f70e63          	beq	a4,a5,800083b4 <uartputc+0xdc>
    8000839c:	00564683          	lbu	a3,5(a2)
    800083a0:	01f7f713          	andi	a4,a5,31
    800083a4:	00e58733          	add	a4,a1,a4
    800083a8:	0206f693          	andi	a3,a3,32
    800083ac:	00178793          	addi	a5,a5,1
    800083b0:	fc069ae3          	bnez	a3,80008384 <uartputc+0xac>
    800083b4:	02813083          	ld	ra,40(sp)
    800083b8:	02013403          	ld	s0,32(sp)
    800083bc:	01813483          	ld	s1,24(sp)
    800083c0:	01013903          	ld	s2,16(sp)
    800083c4:	00813983          	ld	s3,8(sp)
    800083c8:	03010113          	addi	sp,sp,48
    800083cc:	00008067          	ret

00000000800083d0 <uartputc_sync>:
    800083d0:	ff010113          	addi	sp,sp,-16
    800083d4:	00813423          	sd	s0,8(sp)
    800083d8:	01010413          	addi	s0,sp,16
    800083dc:	00004717          	auipc	a4,0x4
    800083e0:	8fc72703          	lw	a4,-1796(a4) # 8000bcd8 <panicked>
    800083e4:	02071663          	bnez	a4,80008410 <uartputc_sync+0x40>
    800083e8:	00050793          	mv	a5,a0
    800083ec:	100006b7          	lui	a3,0x10000
    800083f0:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    800083f4:	02077713          	andi	a4,a4,32
    800083f8:	fe070ce3          	beqz	a4,800083f0 <uartputc_sync+0x20>
    800083fc:	0ff7f793          	andi	a5,a5,255
    80008400:	00f68023          	sb	a5,0(a3)
    80008404:	00813403          	ld	s0,8(sp)
    80008408:	01010113          	addi	sp,sp,16
    8000840c:	00008067          	ret
    80008410:	0000006f          	j	80008410 <uartputc_sync+0x40>

0000000080008414 <uartstart>:
    80008414:	ff010113          	addi	sp,sp,-16
    80008418:	00813423          	sd	s0,8(sp)
    8000841c:	01010413          	addi	s0,sp,16
    80008420:	00004617          	auipc	a2,0x4
    80008424:	8c060613          	addi	a2,a2,-1856 # 8000bce0 <uart_tx_r>
    80008428:	00004517          	auipc	a0,0x4
    8000842c:	8c050513          	addi	a0,a0,-1856 # 8000bce8 <uart_tx_w>
    80008430:	00063783          	ld	a5,0(a2)
    80008434:	00053703          	ld	a4,0(a0)
    80008438:	04f70263          	beq	a4,a5,8000847c <uartstart+0x68>
    8000843c:	100005b7          	lui	a1,0x10000
    80008440:	00005817          	auipc	a6,0x5
    80008444:	e6080813          	addi	a6,a6,-416 # 8000d2a0 <uart_tx_buf>
    80008448:	01c0006f          	j	80008464 <uartstart+0x50>
    8000844c:	0006c703          	lbu	a4,0(a3)
    80008450:	00f63023          	sd	a5,0(a2)
    80008454:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80008458:	00063783          	ld	a5,0(a2)
    8000845c:	00053703          	ld	a4,0(a0)
    80008460:	00f70e63          	beq	a4,a5,8000847c <uartstart+0x68>
    80008464:	01f7f713          	andi	a4,a5,31
    80008468:	00e806b3          	add	a3,a6,a4
    8000846c:	0055c703          	lbu	a4,5(a1)
    80008470:	00178793          	addi	a5,a5,1
    80008474:	02077713          	andi	a4,a4,32
    80008478:	fc071ae3          	bnez	a4,8000844c <uartstart+0x38>
    8000847c:	00813403          	ld	s0,8(sp)
    80008480:	01010113          	addi	sp,sp,16
    80008484:	00008067          	ret

0000000080008488 <uartgetc>:
    80008488:	ff010113          	addi	sp,sp,-16
    8000848c:	00813423          	sd	s0,8(sp)
    80008490:	01010413          	addi	s0,sp,16
    80008494:	10000737          	lui	a4,0x10000
    80008498:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000849c:	0017f793          	andi	a5,a5,1
    800084a0:	00078c63          	beqz	a5,800084b8 <uartgetc+0x30>
    800084a4:	00074503          	lbu	a0,0(a4)
    800084a8:	0ff57513          	andi	a0,a0,255
    800084ac:	00813403          	ld	s0,8(sp)
    800084b0:	01010113          	addi	sp,sp,16
    800084b4:	00008067          	ret
    800084b8:	fff00513          	li	a0,-1
    800084bc:	ff1ff06f          	j	800084ac <uartgetc+0x24>

00000000800084c0 <uartintr>:
    800084c0:	100007b7          	lui	a5,0x10000
    800084c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800084c8:	0017f793          	andi	a5,a5,1
    800084cc:	0a078463          	beqz	a5,80008574 <uartintr+0xb4>
    800084d0:	fe010113          	addi	sp,sp,-32
    800084d4:	00813823          	sd	s0,16(sp)
    800084d8:	00913423          	sd	s1,8(sp)
    800084dc:	00113c23          	sd	ra,24(sp)
    800084e0:	02010413          	addi	s0,sp,32
    800084e4:	100004b7          	lui	s1,0x10000
    800084e8:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    800084ec:	0ff57513          	andi	a0,a0,255
    800084f0:	fffff097          	auipc	ra,0xfffff
    800084f4:	534080e7          	jalr	1332(ra) # 80007a24 <consoleintr>
    800084f8:	0054c783          	lbu	a5,5(s1)
    800084fc:	0017f793          	andi	a5,a5,1
    80008500:	fe0794e3          	bnez	a5,800084e8 <uartintr+0x28>
    80008504:	00003617          	auipc	a2,0x3
    80008508:	7dc60613          	addi	a2,a2,2012 # 8000bce0 <uart_tx_r>
    8000850c:	00003517          	auipc	a0,0x3
    80008510:	7dc50513          	addi	a0,a0,2012 # 8000bce8 <uart_tx_w>
    80008514:	00063783          	ld	a5,0(a2)
    80008518:	00053703          	ld	a4,0(a0)
    8000851c:	04f70263          	beq	a4,a5,80008560 <uartintr+0xa0>
    80008520:	100005b7          	lui	a1,0x10000
    80008524:	00005817          	auipc	a6,0x5
    80008528:	d7c80813          	addi	a6,a6,-644 # 8000d2a0 <uart_tx_buf>
    8000852c:	01c0006f          	j	80008548 <uartintr+0x88>
    80008530:	0006c703          	lbu	a4,0(a3)
    80008534:	00f63023          	sd	a5,0(a2)
    80008538:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000853c:	00063783          	ld	a5,0(a2)
    80008540:	00053703          	ld	a4,0(a0)
    80008544:	00f70e63          	beq	a4,a5,80008560 <uartintr+0xa0>
    80008548:	01f7f713          	andi	a4,a5,31
    8000854c:	00e806b3          	add	a3,a6,a4
    80008550:	0055c703          	lbu	a4,5(a1)
    80008554:	00178793          	addi	a5,a5,1
    80008558:	02077713          	andi	a4,a4,32
    8000855c:	fc071ae3          	bnez	a4,80008530 <uartintr+0x70>
    80008560:	01813083          	ld	ra,24(sp)
    80008564:	01013403          	ld	s0,16(sp)
    80008568:	00813483          	ld	s1,8(sp)
    8000856c:	02010113          	addi	sp,sp,32
    80008570:	00008067          	ret
    80008574:	00003617          	auipc	a2,0x3
    80008578:	76c60613          	addi	a2,a2,1900 # 8000bce0 <uart_tx_r>
    8000857c:	00003517          	auipc	a0,0x3
    80008580:	76c50513          	addi	a0,a0,1900 # 8000bce8 <uart_tx_w>
    80008584:	00063783          	ld	a5,0(a2)
    80008588:	00053703          	ld	a4,0(a0)
    8000858c:	04f70263          	beq	a4,a5,800085d0 <uartintr+0x110>
    80008590:	100005b7          	lui	a1,0x10000
    80008594:	00005817          	auipc	a6,0x5
    80008598:	d0c80813          	addi	a6,a6,-756 # 8000d2a0 <uart_tx_buf>
    8000859c:	01c0006f          	j	800085b8 <uartintr+0xf8>
    800085a0:	0006c703          	lbu	a4,0(a3)
    800085a4:	00f63023          	sd	a5,0(a2)
    800085a8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800085ac:	00063783          	ld	a5,0(a2)
    800085b0:	00053703          	ld	a4,0(a0)
    800085b4:	02f70063          	beq	a4,a5,800085d4 <uartintr+0x114>
    800085b8:	01f7f713          	andi	a4,a5,31
    800085bc:	00e806b3          	add	a3,a6,a4
    800085c0:	0055c703          	lbu	a4,5(a1)
    800085c4:	00178793          	addi	a5,a5,1
    800085c8:	02077713          	andi	a4,a4,32
    800085cc:	fc071ae3          	bnez	a4,800085a0 <uartintr+0xe0>
    800085d0:	00008067          	ret
    800085d4:	00008067          	ret

00000000800085d8 <kinit>:
    800085d8:	fc010113          	addi	sp,sp,-64
    800085dc:	02913423          	sd	s1,40(sp)
    800085e0:	fffff7b7          	lui	a5,0xfffff
    800085e4:	00006497          	auipc	s1,0x6
    800085e8:	cdb48493          	addi	s1,s1,-805 # 8000e2bf <end+0xfff>
    800085ec:	02813823          	sd	s0,48(sp)
    800085f0:	01313c23          	sd	s3,24(sp)
    800085f4:	00f4f4b3          	and	s1,s1,a5
    800085f8:	02113c23          	sd	ra,56(sp)
    800085fc:	03213023          	sd	s2,32(sp)
    80008600:	01413823          	sd	s4,16(sp)
    80008604:	01513423          	sd	s5,8(sp)
    80008608:	04010413          	addi	s0,sp,64
    8000860c:	000017b7          	lui	a5,0x1
    80008610:	01100993          	li	s3,17
    80008614:	00f487b3          	add	a5,s1,a5
    80008618:	01b99993          	slli	s3,s3,0x1b
    8000861c:	06f9e063          	bltu	s3,a5,8000867c <kinit+0xa4>
    80008620:	00005a97          	auipc	s5,0x5
    80008624:	ca0a8a93          	addi	s5,s5,-864 # 8000d2c0 <end>
    80008628:	0754ec63          	bltu	s1,s5,800086a0 <kinit+0xc8>
    8000862c:	0734fa63          	bgeu	s1,s3,800086a0 <kinit+0xc8>
    80008630:	00088a37          	lui	s4,0x88
    80008634:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    80008638:	00003917          	auipc	s2,0x3
    8000863c:	6b890913          	addi	s2,s2,1720 # 8000bcf0 <kmem>
    80008640:	00ca1a13          	slli	s4,s4,0xc
    80008644:	0140006f          	j	80008658 <kinit+0x80>
    80008648:	000017b7          	lui	a5,0x1
    8000864c:	00f484b3          	add	s1,s1,a5
    80008650:	0554e863          	bltu	s1,s5,800086a0 <kinit+0xc8>
    80008654:	0534f663          	bgeu	s1,s3,800086a0 <kinit+0xc8>
    80008658:	00001637          	lui	a2,0x1
    8000865c:	00100593          	li	a1,1
    80008660:	00048513          	mv	a0,s1
    80008664:	00000097          	auipc	ra,0x0
    80008668:	5e4080e7          	jalr	1508(ra) # 80008c48 <__memset>
    8000866c:	00093783          	ld	a5,0(s2)
    80008670:	00f4b023          	sd	a5,0(s1)
    80008674:	00993023          	sd	s1,0(s2)
    80008678:	fd4498e3          	bne	s1,s4,80008648 <kinit+0x70>
    8000867c:	03813083          	ld	ra,56(sp)
    80008680:	03013403          	ld	s0,48(sp)
    80008684:	02813483          	ld	s1,40(sp)
    80008688:	02013903          	ld	s2,32(sp)
    8000868c:	01813983          	ld	s3,24(sp)
    80008690:	01013a03          	ld	s4,16(sp)
    80008694:	00813a83          	ld	s5,8(sp)
    80008698:	04010113          	addi	sp,sp,64
    8000869c:	00008067          	ret
    800086a0:	00001517          	auipc	a0,0x1
    800086a4:	e2050513          	addi	a0,a0,-480 # 800094c0 <digits+0x18>
    800086a8:	fffff097          	auipc	ra,0xfffff
    800086ac:	4b4080e7          	jalr	1204(ra) # 80007b5c <panic>

00000000800086b0 <freerange>:
    800086b0:	fc010113          	addi	sp,sp,-64
    800086b4:	000017b7          	lui	a5,0x1
    800086b8:	02913423          	sd	s1,40(sp)
    800086bc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800086c0:	009504b3          	add	s1,a0,s1
    800086c4:	fffff537          	lui	a0,0xfffff
    800086c8:	02813823          	sd	s0,48(sp)
    800086cc:	02113c23          	sd	ra,56(sp)
    800086d0:	03213023          	sd	s2,32(sp)
    800086d4:	01313c23          	sd	s3,24(sp)
    800086d8:	01413823          	sd	s4,16(sp)
    800086dc:	01513423          	sd	s5,8(sp)
    800086e0:	01613023          	sd	s6,0(sp)
    800086e4:	04010413          	addi	s0,sp,64
    800086e8:	00a4f4b3          	and	s1,s1,a0
    800086ec:	00f487b3          	add	a5,s1,a5
    800086f0:	06f5e463          	bltu	a1,a5,80008758 <freerange+0xa8>
    800086f4:	00005a97          	auipc	s5,0x5
    800086f8:	bcca8a93          	addi	s5,s5,-1076 # 8000d2c0 <end>
    800086fc:	0954e263          	bltu	s1,s5,80008780 <freerange+0xd0>
    80008700:	01100993          	li	s3,17
    80008704:	01b99993          	slli	s3,s3,0x1b
    80008708:	0734fc63          	bgeu	s1,s3,80008780 <freerange+0xd0>
    8000870c:	00058a13          	mv	s4,a1
    80008710:	00003917          	auipc	s2,0x3
    80008714:	5e090913          	addi	s2,s2,1504 # 8000bcf0 <kmem>
    80008718:	00002b37          	lui	s6,0x2
    8000871c:	0140006f          	j	80008730 <freerange+0x80>
    80008720:	000017b7          	lui	a5,0x1
    80008724:	00f484b3          	add	s1,s1,a5
    80008728:	0554ec63          	bltu	s1,s5,80008780 <freerange+0xd0>
    8000872c:	0534fa63          	bgeu	s1,s3,80008780 <freerange+0xd0>
    80008730:	00001637          	lui	a2,0x1
    80008734:	00100593          	li	a1,1
    80008738:	00048513          	mv	a0,s1
    8000873c:	00000097          	auipc	ra,0x0
    80008740:	50c080e7          	jalr	1292(ra) # 80008c48 <__memset>
    80008744:	00093703          	ld	a4,0(s2)
    80008748:	016487b3          	add	a5,s1,s6
    8000874c:	00e4b023          	sd	a4,0(s1)
    80008750:	00993023          	sd	s1,0(s2)
    80008754:	fcfa76e3          	bgeu	s4,a5,80008720 <freerange+0x70>
    80008758:	03813083          	ld	ra,56(sp)
    8000875c:	03013403          	ld	s0,48(sp)
    80008760:	02813483          	ld	s1,40(sp)
    80008764:	02013903          	ld	s2,32(sp)
    80008768:	01813983          	ld	s3,24(sp)
    8000876c:	01013a03          	ld	s4,16(sp)
    80008770:	00813a83          	ld	s5,8(sp)
    80008774:	00013b03          	ld	s6,0(sp)
    80008778:	04010113          	addi	sp,sp,64
    8000877c:	00008067          	ret
    80008780:	00001517          	auipc	a0,0x1
    80008784:	d4050513          	addi	a0,a0,-704 # 800094c0 <digits+0x18>
    80008788:	fffff097          	auipc	ra,0xfffff
    8000878c:	3d4080e7          	jalr	980(ra) # 80007b5c <panic>

0000000080008790 <kfree>:
    80008790:	fe010113          	addi	sp,sp,-32
    80008794:	00813823          	sd	s0,16(sp)
    80008798:	00113c23          	sd	ra,24(sp)
    8000879c:	00913423          	sd	s1,8(sp)
    800087a0:	02010413          	addi	s0,sp,32
    800087a4:	03451793          	slli	a5,a0,0x34
    800087a8:	04079c63          	bnez	a5,80008800 <kfree+0x70>
    800087ac:	00005797          	auipc	a5,0x5
    800087b0:	b1478793          	addi	a5,a5,-1260 # 8000d2c0 <end>
    800087b4:	00050493          	mv	s1,a0
    800087b8:	04f56463          	bltu	a0,a5,80008800 <kfree+0x70>
    800087bc:	01100793          	li	a5,17
    800087c0:	01b79793          	slli	a5,a5,0x1b
    800087c4:	02f57e63          	bgeu	a0,a5,80008800 <kfree+0x70>
    800087c8:	00001637          	lui	a2,0x1
    800087cc:	00100593          	li	a1,1
    800087d0:	00000097          	auipc	ra,0x0
    800087d4:	478080e7          	jalr	1144(ra) # 80008c48 <__memset>
    800087d8:	00003797          	auipc	a5,0x3
    800087dc:	51878793          	addi	a5,a5,1304 # 8000bcf0 <kmem>
    800087e0:	0007b703          	ld	a4,0(a5)
    800087e4:	01813083          	ld	ra,24(sp)
    800087e8:	01013403          	ld	s0,16(sp)
    800087ec:	00e4b023          	sd	a4,0(s1)
    800087f0:	0097b023          	sd	s1,0(a5)
    800087f4:	00813483          	ld	s1,8(sp)
    800087f8:	02010113          	addi	sp,sp,32
    800087fc:	00008067          	ret
    80008800:	00001517          	auipc	a0,0x1
    80008804:	cc050513          	addi	a0,a0,-832 # 800094c0 <digits+0x18>
    80008808:	fffff097          	auipc	ra,0xfffff
    8000880c:	354080e7          	jalr	852(ra) # 80007b5c <panic>

0000000080008810 <kalloc>:
    80008810:	fe010113          	addi	sp,sp,-32
    80008814:	00813823          	sd	s0,16(sp)
    80008818:	00913423          	sd	s1,8(sp)
    8000881c:	00113c23          	sd	ra,24(sp)
    80008820:	02010413          	addi	s0,sp,32
    80008824:	00003797          	auipc	a5,0x3
    80008828:	4cc78793          	addi	a5,a5,1228 # 8000bcf0 <kmem>
    8000882c:	0007b483          	ld	s1,0(a5)
    80008830:	02048063          	beqz	s1,80008850 <kalloc+0x40>
    80008834:	0004b703          	ld	a4,0(s1)
    80008838:	00001637          	lui	a2,0x1
    8000883c:	00500593          	li	a1,5
    80008840:	00048513          	mv	a0,s1
    80008844:	00e7b023          	sd	a4,0(a5)
    80008848:	00000097          	auipc	ra,0x0
    8000884c:	400080e7          	jalr	1024(ra) # 80008c48 <__memset>
    80008850:	01813083          	ld	ra,24(sp)
    80008854:	01013403          	ld	s0,16(sp)
    80008858:	00048513          	mv	a0,s1
    8000885c:	00813483          	ld	s1,8(sp)
    80008860:	02010113          	addi	sp,sp,32
    80008864:	00008067          	ret

0000000080008868 <initlock>:
    80008868:	ff010113          	addi	sp,sp,-16
    8000886c:	00813423          	sd	s0,8(sp)
    80008870:	01010413          	addi	s0,sp,16
    80008874:	00813403          	ld	s0,8(sp)
    80008878:	00b53423          	sd	a1,8(a0)
    8000887c:	00052023          	sw	zero,0(a0)
    80008880:	00053823          	sd	zero,16(a0)
    80008884:	01010113          	addi	sp,sp,16
    80008888:	00008067          	ret

000000008000888c <acquire>:
    8000888c:	fe010113          	addi	sp,sp,-32
    80008890:	00813823          	sd	s0,16(sp)
    80008894:	00913423          	sd	s1,8(sp)
    80008898:	00113c23          	sd	ra,24(sp)
    8000889c:	01213023          	sd	s2,0(sp)
    800088a0:	02010413          	addi	s0,sp,32
    800088a4:	00050493          	mv	s1,a0
    800088a8:	10002973          	csrr	s2,sstatus
    800088ac:	100027f3          	csrr	a5,sstatus
    800088b0:	ffd7f793          	andi	a5,a5,-3
    800088b4:	10079073          	csrw	sstatus,a5
    800088b8:	fffff097          	auipc	ra,0xfffff
    800088bc:	8e4080e7          	jalr	-1820(ra) # 8000719c <mycpu>
    800088c0:	07852783          	lw	a5,120(a0)
    800088c4:	06078e63          	beqz	a5,80008940 <acquire+0xb4>
    800088c8:	fffff097          	auipc	ra,0xfffff
    800088cc:	8d4080e7          	jalr	-1836(ra) # 8000719c <mycpu>
    800088d0:	07852783          	lw	a5,120(a0)
    800088d4:	0004a703          	lw	a4,0(s1)
    800088d8:	0017879b          	addiw	a5,a5,1
    800088dc:	06f52c23          	sw	a5,120(a0)
    800088e0:	04071063          	bnez	a4,80008920 <acquire+0x94>
    800088e4:	00100713          	li	a4,1
    800088e8:	00070793          	mv	a5,a4
    800088ec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800088f0:	0007879b          	sext.w	a5,a5
    800088f4:	fe079ae3          	bnez	a5,800088e8 <acquire+0x5c>
    800088f8:	0ff0000f          	fence
    800088fc:	fffff097          	auipc	ra,0xfffff
    80008900:	8a0080e7          	jalr	-1888(ra) # 8000719c <mycpu>
    80008904:	01813083          	ld	ra,24(sp)
    80008908:	01013403          	ld	s0,16(sp)
    8000890c:	00a4b823          	sd	a0,16(s1)
    80008910:	00013903          	ld	s2,0(sp)
    80008914:	00813483          	ld	s1,8(sp)
    80008918:	02010113          	addi	sp,sp,32
    8000891c:	00008067          	ret
    80008920:	0104b903          	ld	s2,16(s1)
    80008924:	fffff097          	auipc	ra,0xfffff
    80008928:	878080e7          	jalr	-1928(ra) # 8000719c <mycpu>
    8000892c:	faa91ce3          	bne	s2,a0,800088e4 <acquire+0x58>
    80008930:	00001517          	auipc	a0,0x1
    80008934:	b9850513          	addi	a0,a0,-1128 # 800094c8 <digits+0x20>
    80008938:	fffff097          	auipc	ra,0xfffff
    8000893c:	224080e7          	jalr	548(ra) # 80007b5c <panic>
    80008940:	00195913          	srli	s2,s2,0x1
    80008944:	fffff097          	auipc	ra,0xfffff
    80008948:	858080e7          	jalr	-1960(ra) # 8000719c <mycpu>
    8000894c:	00197913          	andi	s2,s2,1
    80008950:	07252e23          	sw	s2,124(a0)
    80008954:	f75ff06f          	j	800088c8 <acquire+0x3c>

0000000080008958 <release>:
    80008958:	fe010113          	addi	sp,sp,-32
    8000895c:	00813823          	sd	s0,16(sp)
    80008960:	00113c23          	sd	ra,24(sp)
    80008964:	00913423          	sd	s1,8(sp)
    80008968:	01213023          	sd	s2,0(sp)
    8000896c:	02010413          	addi	s0,sp,32
    80008970:	00052783          	lw	a5,0(a0)
    80008974:	00079a63          	bnez	a5,80008988 <release+0x30>
    80008978:	00001517          	auipc	a0,0x1
    8000897c:	b5850513          	addi	a0,a0,-1192 # 800094d0 <digits+0x28>
    80008980:	fffff097          	auipc	ra,0xfffff
    80008984:	1dc080e7          	jalr	476(ra) # 80007b5c <panic>
    80008988:	01053903          	ld	s2,16(a0)
    8000898c:	00050493          	mv	s1,a0
    80008990:	fffff097          	auipc	ra,0xfffff
    80008994:	80c080e7          	jalr	-2036(ra) # 8000719c <mycpu>
    80008998:	fea910e3          	bne	s2,a0,80008978 <release+0x20>
    8000899c:	0004b823          	sd	zero,16(s1)
    800089a0:	0ff0000f          	fence
    800089a4:	0f50000f          	fence	iorw,ow
    800089a8:	0804a02f          	amoswap.w	zero,zero,(s1)
    800089ac:	ffffe097          	auipc	ra,0xffffe
    800089b0:	7f0080e7          	jalr	2032(ra) # 8000719c <mycpu>
    800089b4:	100027f3          	csrr	a5,sstatus
    800089b8:	0027f793          	andi	a5,a5,2
    800089bc:	04079a63          	bnez	a5,80008a10 <release+0xb8>
    800089c0:	07852783          	lw	a5,120(a0)
    800089c4:	02f05e63          	blez	a5,80008a00 <release+0xa8>
    800089c8:	fff7871b          	addiw	a4,a5,-1
    800089cc:	06e52c23          	sw	a4,120(a0)
    800089d0:	00071c63          	bnez	a4,800089e8 <release+0x90>
    800089d4:	07c52783          	lw	a5,124(a0)
    800089d8:	00078863          	beqz	a5,800089e8 <release+0x90>
    800089dc:	100027f3          	csrr	a5,sstatus
    800089e0:	0027e793          	ori	a5,a5,2
    800089e4:	10079073          	csrw	sstatus,a5
    800089e8:	01813083          	ld	ra,24(sp)
    800089ec:	01013403          	ld	s0,16(sp)
    800089f0:	00813483          	ld	s1,8(sp)
    800089f4:	00013903          	ld	s2,0(sp)
    800089f8:	02010113          	addi	sp,sp,32
    800089fc:	00008067          	ret
    80008a00:	00001517          	auipc	a0,0x1
    80008a04:	af050513          	addi	a0,a0,-1296 # 800094f0 <digits+0x48>
    80008a08:	fffff097          	auipc	ra,0xfffff
    80008a0c:	154080e7          	jalr	340(ra) # 80007b5c <panic>
    80008a10:	00001517          	auipc	a0,0x1
    80008a14:	ac850513          	addi	a0,a0,-1336 # 800094d8 <digits+0x30>
    80008a18:	fffff097          	auipc	ra,0xfffff
    80008a1c:	144080e7          	jalr	324(ra) # 80007b5c <panic>

0000000080008a20 <holding>:
    80008a20:	00052783          	lw	a5,0(a0)
    80008a24:	00079663          	bnez	a5,80008a30 <holding+0x10>
    80008a28:	00000513          	li	a0,0
    80008a2c:	00008067          	ret
    80008a30:	fe010113          	addi	sp,sp,-32
    80008a34:	00813823          	sd	s0,16(sp)
    80008a38:	00913423          	sd	s1,8(sp)
    80008a3c:	00113c23          	sd	ra,24(sp)
    80008a40:	02010413          	addi	s0,sp,32
    80008a44:	01053483          	ld	s1,16(a0)
    80008a48:	ffffe097          	auipc	ra,0xffffe
    80008a4c:	754080e7          	jalr	1876(ra) # 8000719c <mycpu>
    80008a50:	01813083          	ld	ra,24(sp)
    80008a54:	01013403          	ld	s0,16(sp)
    80008a58:	40a48533          	sub	a0,s1,a0
    80008a5c:	00153513          	seqz	a0,a0
    80008a60:	00813483          	ld	s1,8(sp)
    80008a64:	02010113          	addi	sp,sp,32
    80008a68:	00008067          	ret

0000000080008a6c <push_off>:
    80008a6c:	fe010113          	addi	sp,sp,-32
    80008a70:	00813823          	sd	s0,16(sp)
    80008a74:	00113c23          	sd	ra,24(sp)
    80008a78:	00913423          	sd	s1,8(sp)
    80008a7c:	02010413          	addi	s0,sp,32
    80008a80:	100024f3          	csrr	s1,sstatus
    80008a84:	100027f3          	csrr	a5,sstatus
    80008a88:	ffd7f793          	andi	a5,a5,-3
    80008a8c:	10079073          	csrw	sstatus,a5
    80008a90:	ffffe097          	auipc	ra,0xffffe
    80008a94:	70c080e7          	jalr	1804(ra) # 8000719c <mycpu>
    80008a98:	07852783          	lw	a5,120(a0)
    80008a9c:	02078663          	beqz	a5,80008ac8 <push_off+0x5c>
    80008aa0:	ffffe097          	auipc	ra,0xffffe
    80008aa4:	6fc080e7          	jalr	1788(ra) # 8000719c <mycpu>
    80008aa8:	07852783          	lw	a5,120(a0)
    80008aac:	01813083          	ld	ra,24(sp)
    80008ab0:	01013403          	ld	s0,16(sp)
    80008ab4:	0017879b          	addiw	a5,a5,1
    80008ab8:	06f52c23          	sw	a5,120(a0)
    80008abc:	00813483          	ld	s1,8(sp)
    80008ac0:	02010113          	addi	sp,sp,32
    80008ac4:	00008067          	ret
    80008ac8:	0014d493          	srli	s1,s1,0x1
    80008acc:	ffffe097          	auipc	ra,0xffffe
    80008ad0:	6d0080e7          	jalr	1744(ra) # 8000719c <mycpu>
    80008ad4:	0014f493          	andi	s1,s1,1
    80008ad8:	06952e23          	sw	s1,124(a0)
    80008adc:	fc5ff06f          	j	80008aa0 <push_off+0x34>

0000000080008ae0 <pop_off>:
    80008ae0:	ff010113          	addi	sp,sp,-16
    80008ae4:	00813023          	sd	s0,0(sp)
    80008ae8:	00113423          	sd	ra,8(sp)
    80008aec:	01010413          	addi	s0,sp,16
    80008af0:	ffffe097          	auipc	ra,0xffffe
    80008af4:	6ac080e7          	jalr	1708(ra) # 8000719c <mycpu>
    80008af8:	100027f3          	csrr	a5,sstatus
    80008afc:	0027f793          	andi	a5,a5,2
    80008b00:	04079663          	bnez	a5,80008b4c <pop_off+0x6c>
    80008b04:	07852783          	lw	a5,120(a0)
    80008b08:	02f05a63          	blez	a5,80008b3c <pop_off+0x5c>
    80008b0c:	fff7871b          	addiw	a4,a5,-1
    80008b10:	06e52c23          	sw	a4,120(a0)
    80008b14:	00071c63          	bnez	a4,80008b2c <pop_off+0x4c>
    80008b18:	07c52783          	lw	a5,124(a0)
    80008b1c:	00078863          	beqz	a5,80008b2c <pop_off+0x4c>
    80008b20:	100027f3          	csrr	a5,sstatus
    80008b24:	0027e793          	ori	a5,a5,2
    80008b28:	10079073          	csrw	sstatus,a5
    80008b2c:	00813083          	ld	ra,8(sp)
    80008b30:	00013403          	ld	s0,0(sp)
    80008b34:	01010113          	addi	sp,sp,16
    80008b38:	00008067          	ret
    80008b3c:	00001517          	auipc	a0,0x1
    80008b40:	9b450513          	addi	a0,a0,-1612 # 800094f0 <digits+0x48>
    80008b44:	fffff097          	auipc	ra,0xfffff
    80008b48:	018080e7          	jalr	24(ra) # 80007b5c <panic>
    80008b4c:	00001517          	auipc	a0,0x1
    80008b50:	98c50513          	addi	a0,a0,-1652 # 800094d8 <digits+0x30>
    80008b54:	fffff097          	auipc	ra,0xfffff
    80008b58:	008080e7          	jalr	8(ra) # 80007b5c <panic>

0000000080008b5c <push_on>:
    80008b5c:	fe010113          	addi	sp,sp,-32
    80008b60:	00813823          	sd	s0,16(sp)
    80008b64:	00113c23          	sd	ra,24(sp)
    80008b68:	00913423          	sd	s1,8(sp)
    80008b6c:	02010413          	addi	s0,sp,32
    80008b70:	100024f3          	csrr	s1,sstatus
    80008b74:	100027f3          	csrr	a5,sstatus
    80008b78:	0027e793          	ori	a5,a5,2
    80008b7c:	10079073          	csrw	sstatus,a5
    80008b80:	ffffe097          	auipc	ra,0xffffe
    80008b84:	61c080e7          	jalr	1564(ra) # 8000719c <mycpu>
    80008b88:	07852783          	lw	a5,120(a0)
    80008b8c:	02078663          	beqz	a5,80008bb8 <push_on+0x5c>
    80008b90:	ffffe097          	auipc	ra,0xffffe
    80008b94:	60c080e7          	jalr	1548(ra) # 8000719c <mycpu>
    80008b98:	07852783          	lw	a5,120(a0)
    80008b9c:	01813083          	ld	ra,24(sp)
    80008ba0:	01013403          	ld	s0,16(sp)
    80008ba4:	0017879b          	addiw	a5,a5,1
    80008ba8:	06f52c23          	sw	a5,120(a0)
    80008bac:	00813483          	ld	s1,8(sp)
    80008bb0:	02010113          	addi	sp,sp,32
    80008bb4:	00008067          	ret
    80008bb8:	0014d493          	srli	s1,s1,0x1
    80008bbc:	ffffe097          	auipc	ra,0xffffe
    80008bc0:	5e0080e7          	jalr	1504(ra) # 8000719c <mycpu>
    80008bc4:	0014f493          	andi	s1,s1,1
    80008bc8:	06952e23          	sw	s1,124(a0)
    80008bcc:	fc5ff06f          	j	80008b90 <push_on+0x34>

0000000080008bd0 <pop_on>:
    80008bd0:	ff010113          	addi	sp,sp,-16
    80008bd4:	00813023          	sd	s0,0(sp)
    80008bd8:	00113423          	sd	ra,8(sp)
    80008bdc:	01010413          	addi	s0,sp,16
    80008be0:	ffffe097          	auipc	ra,0xffffe
    80008be4:	5bc080e7          	jalr	1468(ra) # 8000719c <mycpu>
    80008be8:	100027f3          	csrr	a5,sstatus
    80008bec:	0027f793          	andi	a5,a5,2
    80008bf0:	04078463          	beqz	a5,80008c38 <pop_on+0x68>
    80008bf4:	07852783          	lw	a5,120(a0)
    80008bf8:	02f05863          	blez	a5,80008c28 <pop_on+0x58>
    80008bfc:	fff7879b          	addiw	a5,a5,-1
    80008c00:	06f52c23          	sw	a5,120(a0)
    80008c04:	07853783          	ld	a5,120(a0)
    80008c08:	00079863          	bnez	a5,80008c18 <pop_on+0x48>
    80008c0c:	100027f3          	csrr	a5,sstatus
    80008c10:	ffd7f793          	andi	a5,a5,-3
    80008c14:	10079073          	csrw	sstatus,a5
    80008c18:	00813083          	ld	ra,8(sp)
    80008c1c:	00013403          	ld	s0,0(sp)
    80008c20:	01010113          	addi	sp,sp,16
    80008c24:	00008067          	ret
    80008c28:	00001517          	auipc	a0,0x1
    80008c2c:	8f050513          	addi	a0,a0,-1808 # 80009518 <digits+0x70>
    80008c30:	fffff097          	auipc	ra,0xfffff
    80008c34:	f2c080e7          	jalr	-212(ra) # 80007b5c <panic>
    80008c38:	00001517          	auipc	a0,0x1
    80008c3c:	8c050513          	addi	a0,a0,-1856 # 800094f8 <digits+0x50>
    80008c40:	fffff097          	auipc	ra,0xfffff
    80008c44:	f1c080e7          	jalr	-228(ra) # 80007b5c <panic>

0000000080008c48 <__memset>:
    80008c48:	ff010113          	addi	sp,sp,-16
    80008c4c:	00813423          	sd	s0,8(sp)
    80008c50:	01010413          	addi	s0,sp,16
    80008c54:	1a060e63          	beqz	a2,80008e10 <__memset+0x1c8>
    80008c58:	40a007b3          	neg	a5,a0
    80008c5c:	0077f793          	andi	a5,a5,7
    80008c60:	00778693          	addi	a3,a5,7
    80008c64:	00b00813          	li	a6,11
    80008c68:	0ff5f593          	andi	a1,a1,255
    80008c6c:	fff6071b          	addiw	a4,a2,-1
    80008c70:	1b06e663          	bltu	a3,a6,80008e1c <__memset+0x1d4>
    80008c74:	1cd76463          	bltu	a4,a3,80008e3c <__memset+0x1f4>
    80008c78:	1a078e63          	beqz	a5,80008e34 <__memset+0x1ec>
    80008c7c:	00b50023          	sb	a1,0(a0)
    80008c80:	00100713          	li	a4,1
    80008c84:	1ae78463          	beq	a5,a4,80008e2c <__memset+0x1e4>
    80008c88:	00b500a3          	sb	a1,1(a0)
    80008c8c:	00200713          	li	a4,2
    80008c90:	1ae78a63          	beq	a5,a4,80008e44 <__memset+0x1fc>
    80008c94:	00b50123          	sb	a1,2(a0)
    80008c98:	00300713          	li	a4,3
    80008c9c:	18e78463          	beq	a5,a4,80008e24 <__memset+0x1dc>
    80008ca0:	00b501a3          	sb	a1,3(a0)
    80008ca4:	00400713          	li	a4,4
    80008ca8:	1ae78263          	beq	a5,a4,80008e4c <__memset+0x204>
    80008cac:	00b50223          	sb	a1,4(a0)
    80008cb0:	00500713          	li	a4,5
    80008cb4:	1ae78063          	beq	a5,a4,80008e54 <__memset+0x20c>
    80008cb8:	00b502a3          	sb	a1,5(a0)
    80008cbc:	00700713          	li	a4,7
    80008cc0:	18e79e63          	bne	a5,a4,80008e5c <__memset+0x214>
    80008cc4:	00b50323          	sb	a1,6(a0)
    80008cc8:	00700e93          	li	t4,7
    80008ccc:	00859713          	slli	a4,a1,0x8
    80008cd0:	00e5e733          	or	a4,a1,a4
    80008cd4:	01059e13          	slli	t3,a1,0x10
    80008cd8:	01c76e33          	or	t3,a4,t3
    80008cdc:	01859313          	slli	t1,a1,0x18
    80008ce0:	006e6333          	or	t1,t3,t1
    80008ce4:	02059893          	slli	a7,a1,0x20
    80008ce8:	40f60e3b          	subw	t3,a2,a5
    80008cec:	011368b3          	or	a7,t1,a7
    80008cf0:	02859813          	slli	a6,a1,0x28
    80008cf4:	0108e833          	or	a6,a7,a6
    80008cf8:	03059693          	slli	a3,a1,0x30
    80008cfc:	003e589b          	srliw	a7,t3,0x3
    80008d00:	00d866b3          	or	a3,a6,a3
    80008d04:	03859713          	slli	a4,a1,0x38
    80008d08:	00389813          	slli	a6,a7,0x3
    80008d0c:	00f507b3          	add	a5,a0,a5
    80008d10:	00e6e733          	or	a4,a3,a4
    80008d14:	000e089b          	sext.w	a7,t3
    80008d18:	00f806b3          	add	a3,a6,a5
    80008d1c:	00e7b023          	sd	a4,0(a5)
    80008d20:	00878793          	addi	a5,a5,8
    80008d24:	fed79ce3          	bne	a5,a3,80008d1c <__memset+0xd4>
    80008d28:	ff8e7793          	andi	a5,t3,-8
    80008d2c:	0007871b          	sext.w	a4,a5
    80008d30:	01d787bb          	addw	a5,a5,t4
    80008d34:	0ce88e63          	beq	a7,a4,80008e10 <__memset+0x1c8>
    80008d38:	00f50733          	add	a4,a0,a5
    80008d3c:	00b70023          	sb	a1,0(a4)
    80008d40:	0017871b          	addiw	a4,a5,1
    80008d44:	0cc77663          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008d48:	00e50733          	add	a4,a0,a4
    80008d4c:	00b70023          	sb	a1,0(a4)
    80008d50:	0027871b          	addiw	a4,a5,2
    80008d54:	0ac77e63          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008d58:	00e50733          	add	a4,a0,a4
    80008d5c:	00b70023          	sb	a1,0(a4)
    80008d60:	0037871b          	addiw	a4,a5,3
    80008d64:	0ac77663          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008d68:	00e50733          	add	a4,a0,a4
    80008d6c:	00b70023          	sb	a1,0(a4)
    80008d70:	0047871b          	addiw	a4,a5,4
    80008d74:	08c77e63          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008d78:	00e50733          	add	a4,a0,a4
    80008d7c:	00b70023          	sb	a1,0(a4)
    80008d80:	0057871b          	addiw	a4,a5,5
    80008d84:	08c77663          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008d88:	00e50733          	add	a4,a0,a4
    80008d8c:	00b70023          	sb	a1,0(a4)
    80008d90:	0067871b          	addiw	a4,a5,6
    80008d94:	06c77e63          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008d98:	00e50733          	add	a4,a0,a4
    80008d9c:	00b70023          	sb	a1,0(a4)
    80008da0:	0077871b          	addiw	a4,a5,7
    80008da4:	06c77663          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008da8:	00e50733          	add	a4,a0,a4
    80008dac:	00b70023          	sb	a1,0(a4)
    80008db0:	0087871b          	addiw	a4,a5,8
    80008db4:	04c77e63          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008db8:	00e50733          	add	a4,a0,a4
    80008dbc:	00b70023          	sb	a1,0(a4)
    80008dc0:	0097871b          	addiw	a4,a5,9
    80008dc4:	04c77663          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008dc8:	00e50733          	add	a4,a0,a4
    80008dcc:	00b70023          	sb	a1,0(a4)
    80008dd0:	00a7871b          	addiw	a4,a5,10
    80008dd4:	02c77e63          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008dd8:	00e50733          	add	a4,a0,a4
    80008ddc:	00b70023          	sb	a1,0(a4)
    80008de0:	00b7871b          	addiw	a4,a5,11
    80008de4:	02c77663          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008de8:	00e50733          	add	a4,a0,a4
    80008dec:	00b70023          	sb	a1,0(a4)
    80008df0:	00c7871b          	addiw	a4,a5,12
    80008df4:	00c77e63          	bgeu	a4,a2,80008e10 <__memset+0x1c8>
    80008df8:	00e50733          	add	a4,a0,a4
    80008dfc:	00b70023          	sb	a1,0(a4)
    80008e00:	00d7879b          	addiw	a5,a5,13
    80008e04:	00c7f663          	bgeu	a5,a2,80008e10 <__memset+0x1c8>
    80008e08:	00f507b3          	add	a5,a0,a5
    80008e0c:	00b78023          	sb	a1,0(a5)
    80008e10:	00813403          	ld	s0,8(sp)
    80008e14:	01010113          	addi	sp,sp,16
    80008e18:	00008067          	ret
    80008e1c:	00b00693          	li	a3,11
    80008e20:	e55ff06f          	j	80008c74 <__memset+0x2c>
    80008e24:	00300e93          	li	t4,3
    80008e28:	ea5ff06f          	j	80008ccc <__memset+0x84>
    80008e2c:	00100e93          	li	t4,1
    80008e30:	e9dff06f          	j	80008ccc <__memset+0x84>
    80008e34:	00000e93          	li	t4,0
    80008e38:	e95ff06f          	j	80008ccc <__memset+0x84>
    80008e3c:	00000793          	li	a5,0
    80008e40:	ef9ff06f          	j	80008d38 <__memset+0xf0>
    80008e44:	00200e93          	li	t4,2
    80008e48:	e85ff06f          	j	80008ccc <__memset+0x84>
    80008e4c:	00400e93          	li	t4,4
    80008e50:	e7dff06f          	j	80008ccc <__memset+0x84>
    80008e54:	00500e93          	li	t4,5
    80008e58:	e75ff06f          	j	80008ccc <__memset+0x84>
    80008e5c:	00600e93          	li	t4,6
    80008e60:	e6dff06f          	j	80008ccc <__memset+0x84>

0000000080008e64 <__memmove>:
    80008e64:	ff010113          	addi	sp,sp,-16
    80008e68:	00813423          	sd	s0,8(sp)
    80008e6c:	01010413          	addi	s0,sp,16
    80008e70:	0e060863          	beqz	a2,80008f60 <__memmove+0xfc>
    80008e74:	fff6069b          	addiw	a3,a2,-1
    80008e78:	0006881b          	sext.w	a6,a3
    80008e7c:	0ea5e863          	bltu	a1,a0,80008f6c <__memmove+0x108>
    80008e80:	00758713          	addi	a4,a1,7
    80008e84:	00a5e7b3          	or	a5,a1,a0
    80008e88:	40a70733          	sub	a4,a4,a0
    80008e8c:	0077f793          	andi	a5,a5,7
    80008e90:	00f73713          	sltiu	a4,a4,15
    80008e94:	00174713          	xori	a4,a4,1
    80008e98:	0017b793          	seqz	a5,a5
    80008e9c:	00e7f7b3          	and	a5,a5,a4
    80008ea0:	10078863          	beqz	a5,80008fb0 <__memmove+0x14c>
    80008ea4:	00900793          	li	a5,9
    80008ea8:	1107f463          	bgeu	a5,a6,80008fb0 <__memmove+0x14c>
    80008eac:	0036581b          	srliw	a6,a2,0x3
    80008eb0:	fff8081b          	addiw	a6,a6,-1
    80008eb4:	02081813          	slli	a6,a6,0x20
    80008eb8:	01d85893          	srli	a7,a6,0x1d
    80008ebc:	00858813          	addi	a6,a1,8
    80008ec0:	00058793          	mv	a5,a1
    80008ec4:	00050713          	mv	a4,a0
    80008ec8:	01088833          	add	a6,a7,a6
    80008ecc:	0007b883          	ld	a7,0(a5)
    80008ed0:	00878793          	addi	a5,a5,8
    80008ed4:	00870713          	addi	a4,a4,8
    80008ed8:	ff173c23          	sd	a7,-8(a4)
    80008edc:	ff0798e3          	bne	a5,a6,80008ecc <__memmove+0x68>
    80008ee0:	ff867713          	andi	a4,a2,-8
    80008ee4:	02071793          	slli	a5,a4,0x20
    80008ee8:	0207d793          	srli	a5,a5,0x20
    80008eec:	00f585b3          	add	a1,a1,a5
    80008ef0:	40e686bb          	subw	a3,a3,a4
    80008ef4:	00f507b3          	add	a5,a0,a5
    80008ef8:	06e60463          	beq	a2,a4,80008f60 <__memmove+0xfc>
    80008efc:	0005c703          	lbu	a4,0(a1)
    80008f00:	00e78023          	sb	a4,0(a5)
    80008f04:	04068e63          	beqz	a3,80008f60 <__memmove+0xfc>
    80008f08:	0015c603          	lbu	a2,1(a1)
    80008f0c:	00100713          	li	a4,1
    80008f10:	00c780a3          	sb	a2,1(a5)
    80008f14:	04e68663          	beq	a3,a4,80008f60 <__memmove+0xfc>
    80008f18:	0025c603          	lbu	a2,2(a1)
    80008f1c:	00200713          	li	a4,2
    80008f20:	00c78123          	sb	a2,2(a5)
    80008f24:	02e68e63          	beq	a3,a4,80008f60 <__memmove+0xfc>
    80008f28:	0035c603          	lbu	a2,3(a1)
    80008f2c:	00300713          	li	a4,3
    80008f30:	00c781a3          	sb	a2,3(a5)
    80008f34:	02e68663          	beq	a3,a4,80008f60 <__memmove+0xfc>
    80008f38:	0045c603          	lbu	a2,4(a1)
    80008f3c:	00400713          	li	a4,4
    80008f40:	00c78223          	sb	a2,4(a5)
    80008f44:	00e68e63          	beq	a3,a4,80008f60 <__memmove+0xfc>
    80008f48:	0055c603          	lbu	a2,5(a1)
    80008f4c:	00500713          	li	a4,5
    80008f50:	00c782a3          	sb	a2,5(a5)
    80008f54:	00e68663          	beq	a3,a4,80008f60 <__memmove+0xfc>
    80008f58:	0065c703          	lbu	a4,6(a1)
    80008f5c:	00e78323          	sb	a4,6(a5)
    80008f60:	00813403          	ld	s0,8(sp)
    80008f64:	01010113          	addi	sp,sp,16
    80008f68:	00008067          	ret
    80008f6c:	02061713          	slli	a4,a2,0x20
    80008f70:	02075713          	srli	a4,a4,0x20
    80008f74:	00e587b3          	add	a5,a1,a4
    80008f78:	f0f574e3          	bgeu	a0,a5,80008e80 <__memmove+0x1c>
    80008f7c:	02069613          	slli	a2,a3,0x20
    80008f80:	02065613          	srli	a2,a2,0x20
    80008f84:	fff64613          	not	a2,a2
    80008f88:	00e50733          	add	a4,a0,a4
    80008f8c:	00c78633          	add	a2,a5,a2
    80008f90:	fff7c683          	lbu	a3,-1(a5)
    80008f94:	fff78793          	addi	a5,a5,-1
    80008f98:	fff70713          	addi	a4,a4,-1
    80008f9c:	00d70023          	sb	a3,0(a4)
    80008fa0:	fec798e3          	bne	a5,a2,80008f90 <__memmove+0x12c>
    80008fa4:	00813403          	ld	s0,8(sp)
    80008fa8:	01010113          	addi	sp,sp,16
    80008fac:	00008067          	ret
    80008fb0:	02069713          	slli	a4,a3,0x20
    80008fb4:	02075713          	srli	a4,a4,0x20
    80008fb8:	00170713          	addi	a4,a4,1
    80008fbc:	00e50733          	add	a4,a0,a4
    80008fc0:	00050793          	mv	a5,a0
    80008fc4:	0005c683          	lbu	a3,0(a1)
    80008fc8:	00178793          	addi	a5,a5,1
    80008fcc:	00158593          	addi	a1,a1,1
    80008fd0:	fed78fa3          	sb	a3,-1(a5)
    80008fd4:	fee798e3          	bne	a5,a4,80008fc4 <__memmove+0x160>
    80008fd8:	f89ff06f          	j	80008f60 <__memmove+0xfc>
	...
