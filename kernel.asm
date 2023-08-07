
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	62813103          	ld	sp,1576(sp) # 8000a628 <_GLOBAL_OFFSET_TABLE_+0x48>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	36d050ef          	jal	ra,80005b88 <start>

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
    800011c4:	044040ef          	jal	ra,80005208 <_ZN5Riscv20handleSupervisorTrapEv>

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

0000000080001250 <_Z12idleFunctionPv>:
#include "../h/TCB.hpp"
#include "../h/Z_Njihovo_Printing.hpp"

// ovo je telo funkcije koje ce izvrsavati idle nit (besposlena, vrti se u beskonacnoj petlji)
// ona se daje procesoru samo onda kada nema drugih spremnih niti u scheduleru
[[noreturn]] void idleFunction(void* arg) { while (true) { } }
    80001250:	ff010113          	addi	sp,sp,-16
    80001254:	00813423          	sd	s0,8(sp)
    80001258:	01010413          	addi	s0,sp,16
    8000125c:	0000006f          	j	8000125c <_Z12idleFunctionPv+0xc>

0000000080001260 <_Z19removeFromSchedulerRP3TCBS1_>:

// uzimamo element sa pocetka ulancane liste
TCB* removeFromScheduler(TCB*& head, TCB*& tail) {
    80001260:	ff010113          	addi	sp,sp,-16
    80001264:	00813423          	sd	s0,8(sp)
    80001268:	01010413          	addi	s0,sp,16
    8000126c:	00050793          	mv	a5,a0
    if (!head || !tail) return nullptr; // ovaj slucaj moze da se dogodi samo ako idle nit jos nije ubacena, a trazena je nit iz schedulera
    80001270:	00053503          	ld	a0,0(a0) # 1000 <_entry-0x7ffff000>
    80001274:	02050263          	beqz	a0,80001298 <_Z19removeFromSchedulerRP3TCBS1_+0x38>
    80001278:	0005b703          	ld	a4,0(a1)
    8000127c:	02070463          	beqz	a4,800012a4 <_Z19removeFromSchedulerRP3TCBS1_+0x44>
    if (head == tail) return head; // slucaj kada je u scheduleru samo idle nit - nju vracamo i ne izbacujemo nikad iz schedulera
    80001280:	00e50c63          	beq	a0,a4,80001298 <_Z19removeFromSchedulerRP3TCBS1_+0x38>

    // privatne atribute schedulerPrevThread i schedulerNextThread sam ispravno enkapsulirao jer su oni upravo privatni
    // i mogu se modifikovati samo kroz setter metode, a mogu da se procitaju samo preko getter metoda
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    TCB* getNextThreadScheduler() const { return schedulerNextThread; }
    80001284:	03853703          	ld	a4,56(a0)
    TCB* thread = head;
    head = head->getNextThreadScheduler();
    80001288:	00e7b023          	sd	a4,0(a5)
    8000128c:	03853783          	ld	a5,56(a0)
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    80001290:	0407b023          	sd	zero,64(a5)
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }
    80001294:	02053c23          	sd	zero,56(a0)
    thread->getNextThreadScheduler()->setPrevThreadScheduler(nullptr);
    thread->setNextThreadScheduler(nullptr);
    return thread;
}
    80001298:	00813403          	ld	s0,8(sp)
    8000129c:	01010113          	addi	sp,sp,16
    800012a0:	00008067          	ret
    if (!head || !tail) return nullptr; // ovaj slucaj moze da se dogodi samo ako idle nit jos nije ubacena, a trazena je nit iz schedulera
    800012a4:	00070513          	mv	a0,a4
    800012a8:	ff1ff06f          	j	80001298 <_Z19removeFromSchedulerRP3TCBS1_+0x38>

00000000800012ac <_Z19insertIntoSchedulerRP3TCBS1_S0_>:

// umecemo u ulancanu listu; ukoliko prvi put umecemo, to je slucaj kada se umece idle nit;
// kada budemo umetali sve naredne niti, umecemo ih tako da idle nit uvek bude poslednja;
// idle nit se nikada ne izbacuje iz scheduler-a nakon sto se ubaci u scheduler;
void insertIntoScheduler(TCB*& head, TCB*& tail, TCB* tcb) {
    800012ac:	ff010113          	addi	sp,sp,-16
    800012b0:	00813423          	sd	s0,8(sp)
    800012b4:	01010413          	addi	s0,sp,16
    if (!tcb) return;
    800012b8:	04060463          	beqz	a2,80001300 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x54>
    if (!head || !tail) { head = tail = tcb; return; } // ubacivanje idle niti na pocetku dok je jos nismo prvi put ubacili
    800012bc:	00053783          	ld	a5,0(a0)
    800012c0:	04078663          	beqz	a5,8000130c <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x60>
    800012c4:	0005b783          	ld	a5,0(a1)
    800012c8:	04078263          	beqz	a5,8000130c <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x60>
    Body getBody() const { return body; }
    800012cc:	00063683          	ld	a3,0(a2)
    if (tcb->getBody() == &idleFunction) return; // pokusaj ubacivanja idle niti kada je ona vec u scheduleru - bez efekta
    800012d0:	00000717          	auipc	a4,0x0
    800012d4:	f8070713          	addi	a4,a4,-128 # 80001250 <_Z12idleFunctionPv>
    800012d8:	02e68463          	beq	a3,a4,80001300 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x54>
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }
    800012dc:	02f63c23          	sd	a5,56(a2)
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    800012e0:	0407b783          	ld	a5,64(a5)
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    800012e4:	04f63023          	sd	a5,64(a2)
    tcb->setNextThreadScheduler(tail);
    tcb->setPrevThreadScheduler(tail->getPrevThreadScheduler());
    if (tail->getPrevThreadScheduler()) tail->getPrevThreadScheduler()->setNextThreadScheduler(tcb);
    800012e8:	0005b783          	ld	a5,0(a1)
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    800012ec:	0407b783          	ld	a5,64(a5)
    800012f0:	02078463          	beqz	a5,80001318 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x6c>
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }
    800012f4:	02c7bc23          	sd	a2,56(a5)
    else head = tcb;
    tail->setPrevThreadScheduler(tcb);
    800012f8:	0005b783          	ld	a5,0(a1)
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    800012fc:	04c7b023          	sd	a2,64(a5)
}
    80001300:	00813403          	ld	s0,8(sp)
    80001304:	01010113          	addi	sp,sp,16
    80001308:	00008067          	ret
    if (!head || !tail) { head = tail = tcb; return; } // ubacivanje idle niti na pocetku dok je jos nismo prvi put ubacili
    8000130c:	00c5b023          	sd	a2,0(a1)
    80001310:	00c53023          	sd	a2,0(a0)
    80001314:	fedff06f          	j	80001300 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x54>
    else head = tcb;
    80001318:	00c53023          	sd	a2,0(a0)
    8000131c:	fddff06f          	j	800012f8 <_Z19insertIntoSchedulerRP3TCBS1_S0_+0x4c>

0000000080001320 <_Z9mem_allocm>:
#include "../h/syscall_c.h"

void* mem_alloc(size_t size) { // size je broj bajtova koje je korisnik trazio - to cu zaokruziti na ceo broj blokova tako da korisnik dobije tacno toliko ili cak i vise memorije
    80001320:	ff010113          	addi	sp,sp,-16
    80001324:	00113423          	sd	ra,8(sp)
    80001328:	00813023          	sd	s0,0(sp)
    8000132c:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x01; // kod ovog sistemskog poziva
    size_t numberOfBlocks = size % MEM_BLOCK_SIZE ? size / MEM_BLOCK_SIZE + 1 : size / MEM_BLOCK_SIZE; // bajtovi zaokruzeni na blokove velicine MEM_BLOCK_SIZE
    80001330:	03f57793          	andi	a5,a0,63
    80001334:	04078463          	beqz	a5,8000137c <_Z9mem_allocm+0x5c>
    80001338:	00655513          	srli	a0,a0,0x6
    8000133c:	00150793          	addi	a5,a0,1

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001340:	00009517          	auipc	a0,0x9
    80001344:	35050513          	addi	a0,a0,848 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001348:	00100713          	li	a4,1
    8000134c:	00e53023          	sd	a4,0(a0)
    arguments.arg1 = numberOfBlocks;
    80001350:	00f53423          	sd	a5,8(a0)
    arguments.arg2 = 0;
    80001354:	00053823          	sd	zero,16(a0)
    arguments.arg3 = 0;
    80001358:	00053c23          	sd	zero,24(a0)
    arguments.arg4 = 0;
    8000135c:	02053023          	sd	zero,32(a0)
    prepareArgsAndEcall(&arguments);
    80001360:	00001097          	auipc	ra,0x1
    80001364:	ab8080e7          	jalr	-1352(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde adresa alocirane memorije, to upisujem u ptr i vracam korisniku
    void* ptr;
    __asm__ volatile ("mv a0,%[ptr]" : [ptr] "=r"(ptr));
    80001368:	00050513          	mv	a0,a0
    return ptr;
}
    8000136c:	00813083          	ld	ra,8(sp)
    80001370:	00013403          	ld	s0,0(sp)
    80001374:	01010113          	addi	sp,sp,16
    80001378:	00008067          	ret
    size_t numberOfBlocks = size % MEM_BLOCK_SIZE ? size / MEM_BLOCK_SIZE + 1 : size / MEM_BLOCK_SIZE; // bajtovi zaokruzeni na blokove velicine MEM_BLOCK_SIZE
    8000137c:	00655793          	srli	a5,a0,0x6
    80001380:	fc1ff06f          	j	80001340 <_Z9mem_allocm+0x20>

0000000080001384 <_Z8mem_freePv>:

int mem_free(void* ptr) {
    80001384:	ff010113          	addi	sp,sp,-16
    80001388:	00113423          	sd	ra,8(sp)
    8000138c:	00813023          	sd	s0,0(sp)
    80001390:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x02; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001394:	00009797          	auipc	a5,0x9
    80001398:	2fc78793          	addi	a5,a5,764 # 8000a690 <_ZZ9mem_allocmE9arguments>
    8000139c:	00200713          	li	a4,2
    800013a0:	02e7b423          	sd	a4,40(a5)
    arguments.arg1 = reinterpret_cast<uint64>(ptr);
    800013a4:	02a7b823          	sd	a0,48(a5)
    arguments.arg2 = 0;
    800013a8:	0207bc23          	sd	zero,56(a5)
    arguments.arg3 = 0;
    800013ac:	0407b023          	sd	zero,64(a5)
    arguments.arg4 = 0;
    800013b0:	0407b423          	sd	zero,72(a5)
    prepareArgsAndEcall(&arguments);
    800013b4:	00009517          	auipc	a0,0x9
    800013b8:	30450513          	addi	a0,a0,772 # 8000a6b8 <_ZZ8mem_freePvE9arguments>
    800013bc:	00001097          	auipc	ra,0x1
    800013c0:	a5c080e7          	jalr	-1444(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    800013c4:	00050513          	mv	a0,a0
    return successInfo;
}
    800013c8:	0005051b          	sext.w	a0,a0
    800013cc:	00813083          	ld	ra,8(sp)
    800013d0:	00013403          	ld	s0,0(sp)
    800013d4:	01010113          	addi	sp,sp,16
    800013d8:	00008067          	ret

00000000800013dc <_Z13thread_createPP7_threadPFvPvES2_>:

int thread_create(thread_t* handle, void(*start_routine)(void*), void* arg) { // handle je dvostruki pokazivac u koji treba upisati adresu kreirane niti
    800013dc:	fd010113          	addi	sp,sp,-48
    800013e0:	02113423          	sd	ra,40(sp)
    800013e4:	02813023          	sd	s0,32(sp)
    800013e8:	00913c23          	sd	s1,24(sp)
    800013ec:	01213823          	sd	s2,16(sp)
    800013f0:	01313423          	sd	s3,8(sp)
    800013f4:	03010413          	addi	s0,sp,48
    800013f8:	00050913          	mv	s2,a0
    800013fc:	00058493          	mv	s1,a1
    80001400:	00060993          	mv	s3,a2
    uint64 sysCallCode = 0x11; // kod ovog sistemskog poziva
    void* stack;
    if (!start_routine) { // ako je start_routine nullptr, znaci treba pokrenuti nit nad main-om, a za to ne treba da alociramo stek jer ga vec main ima
    80001404:	06058663          	beqz	a1,80001470 <_Z13thread_createPP7_threadPFvPvES2_+0x94>
        stack = nullptr;
    } else {
        // hocemo da na steku ima mesta za DEFAULT_STACK_SIZE (4096) bajtova - ima mesta za 512 vrednosti velicine uint64 (8 bajtova)
        stack = mem_alloc(DEFAULT_STACK_SIZE);
    80001408:	00001537          	lui	a0,0x1
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	f14080e7          	jalr	-236(ra) # 80001320 <_Z9mem_allocm>
        if (!stack) return -1;
    80001414:	06050263          	beqz	a0,80001478 <_Z13thread_createPP7_threadPFvPvES2_+0x9c>
    }

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001418:	00009797          	auipc	a5,0x9
    8000141c:	27878793          	addi	a5,a5,632 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001420:	01100713          	li	a4,17
    80001424:	04e7b823          	sd	a4,80(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreirane niti
    80001428:	0527bc23          	sd	s2,88(a5)
    arguments.arg2 = reinterpret_cast<uint64>(start_routine); // adresa funkcije koju treba da izvrsava novokreirana nit
    8000142c:	0697b023          	sd	s1,96(a5)
    arguments.arg3 = reinterpret_cast<uint64>(arg); // adresa argumenta koji treba proslediti funkciji start_routine
    80001430:	0737b423          	sd	s3,104(a5)
    arguments.arg4 = reinterpret_cast<uint64>(stack); // adresa na kojoj je alociran stek za ovu nit koju treba napraviti
    80001434:	06a7b823          	sd	a0,112(a5)
    prepareArgsAndEcall(&arguments);
    80001438:	00009517          	auipc	a0,0x9
    8000143c:	2a850513          	addi	a0,a0,680 # 8000a6e0 <_ZZ13thread_createPP7_threadPFvPvES2_E9arguments>
    80001440:	00001097          	auipc	ra,0x1
    80001444:	9d8080e7          	jalr	-1576(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // slucaj kada je neuspesno alociran prostor za novu nit (u prekidnoj rutini se poziva TCB::createThread)
    if (*handle == nullptr) return -1;
    80001448:	00093783          	ld	a5,0(s2)
    8000144c:	02078a63          	beqz	a5,80001480 <_Z13thread_createPP7_threadPFvPvES2_+0xa4>

    return 0;
    80001450:	00000513          	li	a0,0
}
    80001454:	02813083          	ld	ra,40(sp)
    80001458:	02013403          	ld	s0,32(sp)
    8000145c:	01813483          	ld	s1,24(sp)
    80001460:	01013903          	ld	s2,16(sp)
    80001464:	00813983          	ld	s3,8(sp)
    80001468:	03010113          	addi	sp,sp,48
    8000146c:	00008067          	ret
        stack = nullptr;
    80001470:	00000513          	li	a0,0
    80001474:	fa5ff06f          	j	80001418 <_Z13thread_createPP7_threadPFvPvES2_+0x3c>
        if (!stack) return -1;
    80001478:	fff00513          	li	a0,-1
    8000147c:	fd9ff06f          	j	80001454 <_Z13thread_createPP7_threadPFvPvES2_+0x78>
    if (*handle == nullptr) return -1;
    80001480:	fff00513          	li	a0,-1
    80001484:	fd1ff06f          	j	80001454 <_Z13thread_createPP7_threadPFvPvES2_+0x78>

0000000080001488 <_Z11thread_exitv>:

int thread_exit() {
    80001488:	ff010113          	addi	sp,sp,-16
    8000148c:	00113423          	sd	ra,8(sp)
    80001490:	00813023          	sd	s0,0(sp)
    80001494:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x12; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001498:	00009797          	auipc	a5,0x9
    8000149c:	1f878793          	addi	a5,a5,504 # 8000a690 <_ZZ9mem_allocmE9arguments>
    800014a0:	01200713          	li	a4,18
    800014a4:	06e7bc23          	sd	a4,120(a5)
    arguments.arg1 = 0;
    800014a8:	0807b023          	sd	zero,128(a5)
    arguments.arg2 = 0;
    800014ac:	0807b423          	sd	zero,136(a5)
    arguments.arg3 = 0;
    800014b0:	0807b823          	sd	zero,144(a5)
    arguments.arg4 = 0;
    800014b4:	0807bc23          	sd	zero,152(a5)
    prepareArgsAndEcall(&arguments);
    800014b8:	00009517          	auipc	a0,0x9
    800014bc:	25050513          	addi	a0,a0,592 # 8000a708 <_ZZ11thread_exitvE9arguments>
    800014c0:	00001097          	auipc	ra,0x1
    800014c4:	958080e7          	jalr	-1704(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // ukoliko se sistemski poziv thread_exit vrati ovde, to znaci da nit nije uspesno ugasena i da se nije promenio kontekst, zato
    // se vraca definitivno kod greske u tom slucaju
    return -1;
}
    800014c8:	fff00513          	li	a0,-1
    800014cc:	00813083          	ld	ra,8(sp)
    800014d0:	00013403          	ld	s0,0(sp)
    800014d4:	01010113          	addi	sp,sp,16
    800014d8:	00008067          	ret

00000000800014dc <_Z15thread_dispatchv>:

void thread_dispatch() {
    800014dc:	ff010113          	addi	sp,sp,-16
    800014e0:	00113423          	sd	ra,8(sp)
    800014e4:	00813023          	sd	s0,0(sp)
    800014e8:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x13; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800014ec:	00009797          	auipc	a5,0x9
    800014f0:	1a478793          	addi	a5,a5,420 # 8000a690 <_ZZ9mem_allocmE9arguments>
    800014f4:	01300713          	li	a4,19
    800014f8:	0ae7b023          	sd	a4,160(a5)
    arguments.arg1 = 0;
    800014fc:	0a07b423          	sd	zero,168(a5)
    arguments.arg2 = 0;
    80001500:	0a07b823          	sd	zero,176(a5)
    arguments.arg3 = 0;
    80001504:	0a07bc23          	sd	zero,184(a5)
    arguments.arg4 = 0;
    80001508:	0c07b023          	sd	zero,192(a5)
    prepareArgsAndEcall(&arguments);
    8000150c:	00009517          	auipc	a0,0x9
    80001510:	22450513          	addi	a0,a0,548 # 8000a730 <_ZZ15thread_dispatchvE9arguments>
    80001514:	00001097          	auipc	ra,0x1
    80001518:	904080e7          	jalr	-1788(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>
}
    8000151c:	00813083          	ld	ra,8(sp)
    80001520:	00013403          	ld	s0,0(sp)
    80001524:	01010113          	addi	sp,sp,16
    80001528:	00008067          	ret

000000008000152c <_Z17thread_create_cppPP7_threadPFvPvES2_>:

int thread_create_cpp(thread_t* handle, void(*start_routine)(void*), void* arg) {
    8000152c:	fd010113          	addi	sp,sp,-48
    80001530:	02113423          	sd	ra,40(sp)
    80001534:	02813023          	sd	s0,32(sp)
    80001538:	00913c23          	sd	s1,24(sp)
    8000153c:	01213823          	sd	s2,16(sp)
    80001540:	01313423          	sd	s3,8(sp)
    80001544:	03010413          	addi	s0,sp,48
    80001548:	00050913          	mv	s2,a0
    8000154c:	00058493          	mv	s1,a1
    80001550:	00060993          	mv	s3,a2
    uint64 sysCallCode = 0x14; // kod ovog sistemskog poziva
    void* stack;
    if (!start_routine) { // ako je start_routine nullptr, znaci treba pokrenuti nit nad main-om, a za to ne treba da alociramo stek jer ga vec main ima
    80001554:	06058663          	beqz	a1,800015c0 <_Z17thread_create_cppPP7_threadPFvPvES2_+0x94>
        stack = nullptr;
    } else {
        // hocemo da na steku ima mesta za DEFAULT_STACK_SIZE (4096) bajtova - ima mesta za 512 vrednosti velicine uint64 (8 bajtova)
        stack = mem_alloc(DEFAULT_STACK_SIZE);
    80001558:	00001537          	lui	a0,0x1
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	dc4080e7          	jalr	-572(ra) # 80001320 <_Z9mem_allocm>
        if (!stack) return -1;
    80001564:	06050263          	beqz	a0,800015c8 <_Z17thread_create_cppPP7_threadPFvPvES2_+0x9c>
    }

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001568:	00009797          	auipc	a5,0x9
    8000156c:	12878793          	addi	a5,a5,296 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001570:	01400713          	li	a4,20
    80001574:	0ce7b423          	sd	a4,200(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreirane niti
    80001578:	0d27b823          	sd	s2,208(a5)
    arguments.arg2 = reinterpret_cast<uint64>(start_routine); // adresa funkcije koju treba da izvrsava novokreirana nit
    8000157c:	0c97bc23          	sd	s1,216(a5)
    arguments.arg3 = reinterpret_cast<uint64>(arg); // adresa argumenta koji treba proslediti funkciji start_routine
    80001580:	0f37b023          	sd	s3,224(a5)
    arguments.arg4 = reinterpret_cast<uint64>(stack); // adresa na kojoj je alociran stek za ovu nit koju treba napraviti
    80001584:	0ea7b423          	sd	a0,232(a5)
    prepareArgsAndEcall(&arguments);
    80001588:	00009517          	auipc	a0,0x9
    8000158c:	1d050513          	addi	a0,a0,464 # 8000a758 <_ZZ17thread_create_cppPP7_threadPFvPvES2_E9arguments>
    80001590:	00001097          	auipc	ra,0x1
    80001594:	888080e7          	jalr	-1912(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // slucaj kada je neuspesno alociran prostor za novu nit (u prekidnoj rutini se poziva TCB::createThread)
    if (*handle == nullptr) return -1;
    80001598:	00093783          	ld	a5,0(s2)
    8000159c:	02078a63          	beqz	a5,800015d0 <_Z17thread_create_cppPP7_threadPFvPvES2_+0xa4>

    return 0;
    800015a0:	00000513          	li	a0,0
}
    800015a4:	02813083          	ld	ra,40(sp)
    800015a8:	02013403          	ld	s0,32(sp)
    800015ac:	01813483          	ld	s1,24(sp)
    800015b0:	01013903          	ld	s2,16(sp)
    800015b4:	00813983          	ld	s3,8(sp)
    800015b8:	03010113          	addi	sp,sp,48
    800015bc:	00008067          	ret
        stack = nullptr;
    800015c0:	00000513          	li	a0,0
    800015c4:	fa5ff06f          	j	80001568 <_Z17thread_create_cppPP7_threadPFvPvES2_+0x3c>
        if (!stack) return -1;
    800015c8:	fff00513          	li	a0,-1
    800015cc:	fd9ff06f          	j	800015a4 <_Z17thread_create_cppPP7_threadPFvPvES2_+0x78>
    if (*handle == nullptr) return -1;
    800015d0:	fff00513          	li	a0,-1
    800015d4:	fd1ff06f          	j	800015a4 <_Z17thread_create_cppPP7_threadPFvPvES2_+0x78>

00000000800015d8 <_Z13scheduler_putP7_thread>:

int scheduler_put(thread_t thread) {
    uint64 sysCallCode = 0x15; // kod ovog sistemskog poziva
    if (!thread) return -1;
    800015d8:	04050c63          	beqz	a0,80001630 <_Z13scheduler_putP7_thread+0x58>
int scheduler_put(thread_t thread) {
    800015dc:	ff010113          	addi	sp,sp,-16
    800015e0:	00113423          	sd	ra,8(sp)
    800015e4:	00813023          	sd	s0,0(sp)
    800015e8:	01010413          	addi	s0,sp,16

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800015ec:	00009797          	auipc	a5,0x9
    800015f0:	0a478793          	addi	a5,a5,164 # 8000a690 <_ZZ9mem_allocmE9arguments>
    800015f4:	01500713          	li	a4,21
    800015f8:	0ee7b823          	sd	a4,240(a5)
    arguments.arg1 = reinterpret_cast<uint64>(thread);
    800015fc:	0ea7bc23          	sd	a0,248(a5)
    arguments.arg2 = 0;
    80001600:	1007b023          	sd	zero,256(a5)
    arguments.arg3 = 0;
    80001604:	1007b423          	sd	zero,264(a5)
    arguments.arg4 = 0;
    80001608:	1007b823          	sd	zero,272(a5)
    prepareArgsAndEcall(&arguments);
    8000160c:	00009517          	auipc	a0,0x9
    80001610:	17450513          	addi	a0,a0,372 # 8000a780 <_ZZ13scheduler_putP7_threadE9arguments>
    80001614:	00001097          	auipc	ra,0x1
    80001618:	804080e7          	jalr	-2044(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // ovaj sistemski poziv uvek uspeva jer je ovo jednostavno uvezivanje u listu schedulera bez dinamicke alokacije memorije
    return 0;
    8000161c:	00000513          	li	a0,0
}
    80001620:	00813083          	ld	ra,8(sp)
    80001624:	00013403          	ld	s0,0(sp)
    80001628:	01010113          	addi	sp,sp,16
    8000162c:	00008067          	ret
    if (!thread) return -1;
    80001630:	fff00513          	li	a0,-1
}
    80001634:	00008067          	ret

0000000080001638 <_Z11getThreadIdv>:

int getThreadId() {
    80001638:	ff010113          	addi	sp,sp,-16
    8000163c:	00113423          	sd	ra,8(sp)
    80001640:	00813023          	sd	s0,0(sp)
    80001644:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x16; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001648:	00009797          	auipc	a5,0x9
    8000164c:	04878793          	addi	a5,a5,72 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001650:	01600713          	li	a4,22
    80001654:	10e7bc23          	sd	a4,280(a5)
    arguments.arg1 = 0;
    80001658:	1207b023          	sd	zero,288(a5)
    arguments.arg2 = 0;
    8000165c:	1207b423          	sd	zero,296(a5)
    arguments.arg3 = 0;
    80001660:	1207b823          	sd	zero,304(a5)
    arguments.arg4 = 0;
    80001664:	1207bc23          	sd	zero,312(a5)
    prepareArgsAndEcall(&arguments);
    80001668:	00009517          	auipc	a0,0x9
    8000166c:	14050513          	addi	a0,a0,320 # 8000a7a8 <_ZZ11getThreadIdvE9arguments>
    80001670:	00000097          	auipc	ra,0x0
    80001674:	7a8080e7          	jalr	1960(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    80001678:	00050513          	mv	a0,a0
    return successInfo;
}
    8000167c:	0005051b          	sext.w	a0,a0
    80001680:	00813083          	ld	ra,8(sp)
    80001684:	00013403          	ld	s0,0(sp)
    80001688:	01010113          	addi	sp,sp,16
    8000168c:	00008067          	ret

0000000080001690 <_Z8sem_openPP4_semj>:

int sem_open(sem_t* handle, unsigned init) {
    80001690:	fe010113          	addi	sp,sp,-32
    80001694:	00113c23          	sd	ra,24(sp)
    80001698:	00813823          	sd	s0,16(sp)
    8000169c:	00913423          	sd	s1,8(sp)
    800016a0:	02010413          	addi	s0,sp,32
    800016a4:	00050493          	mv	s1,a0
    uint64 sysCallCode = 0x21; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800016a8:	00009797          	auipc	a5,0x9
    800016ac:	fe878793          	addi	a5,a5,-24 # 8000a690 <_ZZ9mem_allocmE9arguments>
    800016b0:	02100713          	li	a4,33
    800016b4:	14e7b023          	sd	a4,320(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa na koju treba upisati adresu novokreiranog semafora
    800016b8:	14a7b423          	sd	a0,328(a5)
    arguments.arg2 = init;
    800016bc:	02059593          	slli	a1,a1,0x20
    800016c0:	0205d593          	srli	a1,a1,0x20
    800016c4:	14b7b823          	sd	a1,336(a5)
    arguments.arg3 = 0;
    800016c8:	1407bc23          	sd	zero,344(a5)
    arguments.arg4 = 0;
    800016cc:	1607b023          	sd	zero,352(a5)
    prepareArgsAndEcall(&arguments);
    800016d0:	00009517          	auipc	a0,0x9
    800016d4:	10050513          	addi	a0,a0,256 # 8000a7d0 <_ZZ8sem_openPP4_semjE9arguments>
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	740080e7          	jalr	1856(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // slucaj kada je neuspesno alociran prostor za nov semafor (u prekidnoj rutini se poziva KernelSemaphore::createSemaphore)
    if (*handle == nullptr) return -1;
    800016e0:	0004b783          	ld	a5,0(s1)
    800016e4:	00078e63          	beqz	a5,80001700 <_Z8sem_openPP4_semj+0x70>

    return 0;
    800016e8:	00000513          	li	a0,0
}
    800016ec:	01813083          	ld	ra,24(sp)
    800016f0:	01013403          	ld	s0,16(sp)
    800016f4:	00813483          	ld	s1,8(sp)
    800016f8:	02010113          	addi	sp,sp,32
    800016fc:	00008067          	ret
    if (*handle == nullptr) return -1;
    80001700:	fff00513          	li	a0,-1
    80001704:	fe9ff06f          	j	800016ec <_Z8sem_openPP4_semj+0x5c>

0000000080001708 <_Z9sem_closeP4_sem>:

int sem_close(sem_t handle) {
    80001708:	ff010113          	addi	sp,sp,-16
    8000170c:	00113423          	sd	ra,8(sp)
    80001710:	00813023          	sd	s0,0(sp)
    80001714:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x22; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001718:	00009797          	auipc	a5,0x9
    8000171c:	f7878793          	addi	a5,a5,-136 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001720:	02200713          	li	a4,34
    80001724:	16e7b423          	sd	a4,360(a5)
    arguments.arg1 = reinterpret_cast<uint64>(handle); // adresa semafora kojeg treba osloboditi
    80001728:	16a7b823          	sd	a0,368(a5)
    arguments.arg2 = 0;
    8000172c:	1607bc23          	sd	zero,376(a5)
    arguments.arg3 = 0;
    80001730:	1807b023          	sd	zero,384(a5)
    arguments.arg4 = 0;
    80001734:	1807b423          	sd	zero,392(a5)
    prepareArgsAndEcall(&arguments);
    80001738:	00009517          	auipc	a0,0x9
    8000173c:	0c050513          	addi	a0,a0,192 # 8000a7f8 <_ZZ9sem_closeP4_semE9arguments>
    80001740:	00000097          	auipc	ra,0x0
    80001744:	6d8080e7          	jalr	1752(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    80001748:	00050513          	mv	a0,a0
    return successInfo;
}
    8000174c:	0005051b          	sext.w	a0,a0
    80001750:	00813083          	ld	ra,8(sp)
    80001754:	00013403          	ld	s0,0(sp)
    80001758:	01010113          	addi	sp,sp,16
    8000175c:	00008067          	ret

0000000080001760 <_Z8sem_waitP4_sem>:

int sem_wait(sem_t id) {
    80001760:	ff010113          	addi	sp,sp,-16
    80001764:	00113423          	sd	ra,8(sp)
    80001768:	00813023          	sd	s0,0(sp)
    8000176c:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x23; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001770:	00009797          	auipc	a5,0x9
    80001774:	f2078793          	addi	a5,a5,-224 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001778:	02300713          	li	a4,35
    8000177c:	18e7b823          	sd	a4,400(a5)
    arguments.arg1 = reinterpret_cast<uint64>(id); // adresa semafora za koji treba da se pozove metod wait
    80001780:	18a7bc23          	sd	a0,408(a5)
    arguments.arg2 = 0;
    80001784:	1a07b023          	sd	zero,416(a5)
    arguments.arg3 = 0;
    80001788:	1a07b423          	sd	zero,424(a5)
    arguments.arg4 = 0;
    8000178c:	1a07b823          	sd	zero,432(a5)
    prepareArgsAndEcall(&arguments);
    80001790:	00009517          	auipc	a0,0x9
    80001794:	09050513          	addi	a0,a0,144 # 8000a820 <_ZZ8sem_waitP4_semE9arguments>
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	680080e7          	jalr	1664(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    800017a0:	00050513          	mv	a0,a0
    return successInfo;
}
    800017a4:	0005051b          	sext.w	a0,a0
    800017a8:	00813083          	ld	ra,8(sp)
    800017ac:	00013403          	ld	s0,0(sp)
    800017b0:	01010113          	addi	sp,sp,16
    800017b4:	00008067          	ret

00000000800017b8 <_Z10sem_signalP4_sem>:

int sem_signal(sem_t id) {
    800017b8:	ff010113          	addi	sp,sp,-16
    800017bc:	00113423          	sd	ra,8(sp)
    800017c0:	00813023          	sd	s0,0(sp)
    800017c4:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x24; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800017c8:	00009797          	auipc	a5,0x9
    800017cc:	ec878793          	addi	a5,a5,-312 # 8000a690 <_ZZ9mem_allocmE9arguments>
    800017d0:	02400713          	li	a4,36
    800017d4:	1ae7bc23          	sd	a4,440(a5)
    arguments.arg1 = reinterpret_cast<uint64>(id); // adresa semafora za koji treba da se pozove metod signal
    800017d8:	1ca7b023          	sd	a0,448(a5)
    arguments.arg2 = 0;
    800017dc:	1c07b423          	sd	zero,456(a5)
    arguments.arg3 = 0;
    800017e0:	1c07b823          	sd	zero,464(a5)
    arguments.arg4 = 0;
    800017e4:	1c07bc23          	sd	zero,472(a5)
    prepareArgsAndEcall(&arguments);
    800017e8:	00009517          	auipc	a0,0x9
    800017ec:	06050513          	addi	a0,a0,96 # 8000a848 <_ZZ10sem_signalP4_semE9arguments>
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	628080e7          	jalr	1576(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    // sem_signal se uvek uspesno obavi - nema ni rizika od eventualnog loseg rada alokatora memorije jer uopste ne alociram
    // i dealociram dinamicki elemente ulancane liste blokiranih niti na semaforu, vec pomocu pokazivaca kao nestatickih atributa
    // klase TCB formiram ulancanu listu
    return 0;
}
    800017f8:	00000513          	li	a0,0
    800017fc:	00813083          	ld	ra,8(sp)
    80001800:	00013403          	ld	s0,0(sp)
    80001804:	01010113          	addi	sp,sp,16
    80001808:	00008067          	ret

000000008000180c <_Z10time_sleepm>:

int time_sleep(time_t time) { // time_t je zapravo uint64
    uint64 sysCallCode = 0x31; // kod ovog sistemskog poziva

    if (time == 0) return 0;
    8000180c:	00051663          	bnez	a0,80001818 <_Z10time_sleepm+0xc>
    80001810:	00000513          	li	a0,0
    // u registru a0 se nalazi povratna vrednost sistemskog poziva - to ce biti ovde informacija
    // o uspesnosti trazene operacije, to upisujem u successInfo i vracam korisniku
    int successInfo;
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    return successInfo;
}
    80001814:	00008067          	ret
int time_sleep(time_t time) { // time_t je zapravo uint64
    80001818:	ff010113          	addi	sp,sp,-16
    8000181c:	00113423          	sd	ra,8(sp)
    80001820:	00813023          	sd	s0,0(sp)
    80001824:	01010413          	addi	s0,sp,16
    arguments.arg0 = sysCallCode;
    80001828:	00009797          	auipc	a5,0x9
    8000182c:	e6878793          	addi	a5,a5,-408 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001830:	03100713          	li	a4,49
    80001834:	1ee7b023          	sd	a4,480(a5)
    arguments.arg1 = time;
    80001838:	1ea7b423          	sd	a0,488(a5)
    arguments.arg2 = 0;
    8000183c:	1e07b823          	sd	zero,496(a5)
    arguments.arg3 = 0;
    80001840:	1e07bc23          	sd	zero,504(a5)
    arguments.arg4 = 0;
    80001844:	2007b023          	sd	zero,512(a5)
    prepareArgsAndEcall(&arguments);
    80001848:	00009517          	auipc	a0,0x9
    8000184c:	02850513          	addi	a0,a0,40 # 8000a870 <_ZZ10time_sleepmE9arguments>
    80001850:	00000097          	auipc	ra,0x0
    80001854:	5c8080e7          	jalr	1480(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>
    __asm__ volatile ("mv a0,%[successInfo]" : [successInfo] "=r"(successInfo));
    80001858:	00050513          	mv	a0,a0
    8000185c:	0005051b          	sext.w	a0,a0
}
    80001860:	00813083          	ld	ra,8(sp)
    80001864:	00013403          	ld	s0,0(sp)
    80001868:	01010113          	addi	sp,sp,16
    8000186c:	00008067          	ret

0000000080001870 <_Z4getcv>:

char getc() {
    80001870:	ff010113          	addi	sp,sp,-16
    80001874:	00113423          	sd	ra,8(sp)
    80001878:	00813023          	sd	s0,0(sp)
    8000187c:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x41; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001880:	00009797          	auipc	a5,0x9
    80001884:	e1078793          	addi	a5,a5,-496 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001888:	04100713          	li	a4,65
    8000188c:	20e7b423          	sd	a4,520(a5)
    arguments.arg1 = 0;
    80001890:	2007b823          	sd	zero,528(a5)
    arguments.arg2 = 0;
    80001894:	2007bc23          	sd	zero,536(a5)
    arguments.arg3 = 0;
    80001898:	2207b023          	sd	zero,544(a5)
    arguments.arg4 = 0;
    8000189c:	2207b423          	sd	zero,552(a5)
    prepareArgsAndEcall(&arguments);
    800018a0:	00009517          	auipc	a0,0x9
    800018a4:	ff850513          	addi	a0,a0,-8 # 8000a898 <_ZZ4getcvE9arguments>
    800018a8:	00000097          	auipc	ra,0x0
    800018ac:	570080e7          	jalr	1392(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>

    char inputCharacter;
    __asm__ volatile ("mv a0,%[inputCharacter]" : [inputCharacter] "=r"(inputCharacter));
    800018b0:	00050513          	mv	a0,a0
    return inputCharacter;
}
    800018b4:	0ff57513          	andi	a0,a0,255
    800018b8:	00813083          	ld	ra,8(sp)
    800018bc:	00013403          	ld	s0,0(sp)
    800018c0:	01010113          	addi	sp,sp,16
    800018c4:	00008067          	ret

00000000800018c8 <_Z4putcc>:

void putc(char c) {
    800018c8:	ff010113          	addi	sp,sp,-16
    800018cc:	00113423          	sd	ra,8(sp)
    800018d0:	00813023          	sd	s0,0(sp)
    800018d4:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x42; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    800018d8:	00009797          	auipc	a5,0x9
    800018dc:	db878793          	addi	a5,a5,-584 # 8000a690 <_ZZ9mem_allocmE9arguments>
    800018e0:	04200713          	li	a4,66
    800018e4:	22e7b823          	sd	a4,560(a5)
    arguments.arg1 = c;
    800018e8:	22a7bc23          	sd	a0,568(a5)
    arguments.arg2 = 0;
    800018ec:	2407b023          	sd	zero,576(a5)
    arguments.arg3 = 0;
    800018f0:	2407b423          	sd	zero,584(a5)
    arguments.arg4 = 0;
    800018f4:	2407b823          	sd	zero,592(a5)
    prepareArgsAndEcall(&arguments);
    800018f8:	00009517          	auipc	a0,0x9
    800018fc:	fc850513          	addi	a0,a0,-56 # 8000a8c0 <_ZZ4putccE9arguments>
    80001900:	00000097          	auipc	ra,0x0
    80001904:	518080e7          	jalr	1304(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>
}
    80001908:	00813083          	ld	ra,8(sp)
    8000190c:	00013403          	ld	s0,0(sp)
    80001910:	01010113          	addi	sp,sp,16
    80001914:	00008067          	ret

0000000080001918 <_Z22switchSupervisorToUserv>:

void switchSupervisorToUser() {
    80001918:	ff010113          	addi	sp,sp,-16
    8000191c:	00113423          	sd	ra,8(sp)
    80001920:	00813023          	sd	s0,0(sp)
    80001924:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x50; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001928:	00009797          	auipc	a5,0x9
    8000192c:	d6878793          	addi	a5,a5,-664 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001930:	05000713          	li	a4,80
    80001934:	24e7bc23          	sd	a4,600(a5)
    arguments.arg1 = 0;
    80001938:	2607b023          	sd	zero,608(a5)
    arguments.arg2 = 0;
    8000193c:	2607b423          	sd	zero,616(a5)
    arguments.arg3 = 0;
    80001940:	2607b823          	sd	zero,624(a5)
    arguments.arg4 = 0;
    80001944:	2607bc23          	sd	zero,632(a5)
    prepareArgsAndEcall(&arguments);
    80001948:	00009517          	auipc	a0,0x9
    8000194c:	fa050513          	addi	a0,a0,-96 # 8000a8e8 <_ZZ22switchSupervisorToUservE9arguments>
    80001950:	00000097          	auipc	ra,0x0
    80001954:	4c8080e7          	jalr	1224(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>
}
    80001958:	00813083          	ld	ra,8(sp)
    8000195c:	00013403          	ld	s0,0(sp)
    80001960:	01010113          	addi	sp,sp,16
    80001964:	00008067          	ret

0000000080001968 <_Z22switchUserToSupervisorv>:

void switchUserToSupervisor() {
    80001968:	ff010113          	addi	sp,sp,-16
    8000196c:	00113423          	sd	ra,8(sp)
    80001970:	00813023          	sd	s0,0(sp)
    80001974:	01010413          	addi	s0,sp,16
    uint64 sysCallCode = 0x51; // kod ovog sistemskog poziva

    // pakovanje argumenata za ovaj sistemski poziv u strukturu i pozivanje funkcije koja ce ih upisati u registre i izvrsiti ecall (softverski prekid)
    static sysCallArgs arguments;
    arguments.arg0 = sysCallCode;
    80001978:	00009797          	auipc	a5,0x9
    8000197c:	d1878793          	addi	a5,a5,-744 # 8000a690 <_ZZ9mem_allocmE9arguments>
    80001980:	05100713          	li	a4,81
    80001984:	28e7b023          	sd	a4,640(a5)
    arguments.arg1 = 0;
    80001988:	2807b423          	sd	zero,648(a5)
    arguments.arg2 = 0;
    8000198c:	2807b823          	sd	zero,656(a5)
    arguments.arg3 = 0;
    80001990:	2807bc23          	sd	zero,664(a5)
    arguments.arg4 = 0;
    80001994:	2a07b023          	sd	zero,672(a5)
    prepareArgsAndEcall(&arguments);
    80001998:	00009517          	auipc	a0,0x9
    8000199c:	f7850513          	addi	a0,a0,-136 # 8000a910 <_ZZ22switchUserToSupervisorvE9arguments>
    800019a0:	00000097          	auipc	ra,0x0
    800019a4:	478080e7          	jalr	1144(ra) # 80001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>
    800019a8:	00813083          	ld	ra,8(sp)
    800019ac:	00013403          	ld	s0,0(sp)
    800019b0:	01010113          	addi	sp,sp,16
    800019b4:	00008067          	ret

00000000800019b8 <_ZN9BufferCPPC1Ei>:
#include "../h/Z_Njihovo_Buffer_CPP_API.hpp"

BufferCPP::BufferCPP(int _cap) : cap(_cap + 1), head(0), tail(0) {
    800019b8:	fd010113          	addi	sp,sp,-48
    800019bc:	02113423          	sd	ra,40(sp)
    800019c0:	02813023          	sd	s0,32(sp)
    800019c4:	00913c23          	sd	s1,24(sp)
    800019c8:	01213823          	sd	s2,16(sp)
    800019cc:	01313423          	sd	s3,8(sp)
    800019d0:	03010413          	addi	s0,sp,48
    800019d4:	00050493          	mv	s1,a0
    800019d8:	00058913          	mv	s2,a1
    800019dc:	0015879b          	addiw	a5,a1,1
    800019e0:	0007851b          	sext.w	a0,a5
    800019e4:	00f4a023          	sw	a5,0(s1)
    800019e8:	0004a823          	sw	zero,16(s1)
    800019ec:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    800019f0:	00251513          	slli	a0,a0,0x2
    800019f4:	00000097          	auipc	ra,0x0
    800019f8:	92c080e7          	jalr	-1748(ra) # 80001320 <_Z9mem_allocm>
    800019fc:	00a4b423          	sd	a0,8(s1)
    itemAvailable = new Semaphore(0);
    80001a00:	01000513          	li	a0,16
    80001a04:	00002097          	auipc	ra,0x2
    80001a08:	6cc080e7          	jalr	1740(ra) # 800040d0 <_Znwm>
    80001a0c:	00050993          	mv	s3,a0
    80001a10:	00000593          	li	a1,0
    80001a14:	00003097          	auipc	ra,0x3
    80001a18:	954080e7          	jalr	-1708(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80001a1c:	0334b023          	sd	s3,32(s1)
    spaceAvailable = new Semaphore(_cap);
    80001a20:	01000513          	li	a0,16
    80001a24:	00002097          	auipc	ra,0x2
    80001a28:	6ac080e7          	jalr	1708(ra) # 800040d0 <_Znwm>
    80001a2c:	00050993          	mv	s3,a0
    80001a30:	00090593          	mv	a1,s2
    80001a34:	00003097          	auipc	ra,0x3
    80001a38:	934080e7          	jalr	-1740(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80001a3c:	0134bc23          	sd	s3,24(s1)
    mutexHead = new Semaphore(1);
    80001a40:	01000513          	li	a0,16
    80001a44:	00002097          	auipc	ra,0x2
    80001a48:	68c080e7          	jalr	1676(ra) # 800040d0 <_Znwm>
    80001a4c:	00050913          	mv	s2,a0
    80001a50:	00100593          	li	a1,1
    80001a54:	00003097          	auipc	ra,0x3
    80001a58:	914080e7          	jalr	-1772(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80001a5c:	0324b423          	sd	s2,40(s1)
    mutexTail = new Semaphore(1);
    80001a60:	01000513          	li	a0,16
    80001a64:	00002097          	auipc	ra,0x2
    80001a68:	66c080e7          	jalr	1644(ra) # 800040d0 <_Znwm>
    80001a6c:	00050913          	mv	s2,a0
    80001a70:	00100593          	li	a1,1
    80001a74:	00003097          	auipc	ra,0x3
    80001a78:	8f4080e7          	jalr	-1804(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80001a7c:	0324b823          	sd	s2,48(s1)
}
    80001a80:	02813083          	ld	ra,40(sp)
    80001a84:	02013403          	ld	s0,32(sp)
    80001a88:	01813483          	ld	s1,24(sp)
    80001a8c:	01013903          	ld	s2,16(sp)
    80001a90:	00813983          	ld	s3,8(sp)
    80001a94:	03010113          	addi	sp,sp,48
    80001a98:	00008067          	ret
    80001a9c:	00050493          	mv	s1,a0
    itemAvailable = new Semaphore(0);
    80001aa0:	00098513          	mv	a0,s3
    80001aa4:	00002097          	auipc	ra,0x2
    80001aa8:	67c080e7          	jalr	1660(ra) # 80004120 <_ZdlPv>
    80001aac:	00048513          	mv	a0,s1
    80001ab0:	0000a097          	auipc	ra,0xa
    80001ab4:	fe8080e7          	jalr	-24(ra) # 8000ba98 <_Unwind_Resume>
    80001ab8:	00050493          	mv	s1,a0
    spaceAvailable = new Semaphore(_cap);
    80001abc:	00098513          	mv	a0,s3
    80001ac0:	00002097          	auipc	ra,0x2
    80001ac4:	660080e7          	jalr	1632(ra) # 80004120 <_ZdlPv>
    80001ac8:	00048513          	mv	a0,s1
    80001acc:	0000a097          	auipc	ra,0xa
    80001ad0:	fcc080e7          	jalr	-52(ra) # 8000ba98 <_Unwind_Resume>
    80001ad4:	00050493          	mv	s1,a0
    mutexHead = new Semaphore(1);
    80001ad8:	00090513          	mv	a0,s2
    80001adc:	00002097          	auipc	ra,0x2
    80001ae0:	644080e7          	jalr	1604(ra) # 80004120 <_ZdlPv>
    80001ae4:	00048513          	mv	a0,s1
    80001ae8:	0000a097          	auipc	ra,0xa
    80001aec:	fb0080e7          	jalr	-80(ra) # 8000ba98 <_Unwind_Resume>
    80001af0:	00050493          	mv	s1,a0
    mutexTail = new Semaphore(1);
    80001af4:	00090513          	mv	a0,s2
    80001af8:	00002097          	auipc	ra,0x2
    80001afc:	628080e7          	jalr	1576(ra) # 80004120 <_ZdlPv>
    80001b00:	00048513          	mv	a0,s1
    80001b04:	0000a097          	auipc	ra,0xa
    80001b08:	f94080e7          	jalr	-108(ra) # 8000ba98 <_Unwind_Resume>

0000000080001b0c <_ZN9BufferCPP3putEi>:
    delete spaceAvailable;
    delete mutexTail;
    delete mutexHead;
}

void BufferCPP::put(int val) {
    80001b0c:	fe010113          	addi	sp,sp,-32
    80001b10:	00113c23          	sd	ra,24(sp)
    80001b14:	00813823          	sd	s0,16(sp)
    80001b18:	00913423          	sd	s1,8(sp)
    80001b1c:	01213023          	sd	s2,0(sp)
    80001b20:	02010413          	addi	s0,sp,32
    80001b24:	00050493          	mv	s1,a0
    80001b28:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    80001b2c:	01853503          	ld	a0,24(a0)
    80001b30:	00003097          	auipc	ra,0x3
    80001b34:	870080e7          	jalr	-1936(ra) # 800043a0 <_ZN9Semaphore4waitEv>

    mutexTail->wait();
    80001b38:	0304b503          	ld	a0,48(s1)
    80001b3c:	00003097          	auipc	ra,0x3
    80001b40:	864080e7          	jalr	-1948(ra) # 800043a0 <_ZN9Semaphore4waitEv>
    buffer[tail] = val;
    80001b44:	0084b783          	ld	a5,8(s1)
    80001b48:	0144a703          	lw	a4,20(s1)
    80001b4c:	00271713          	slli	a4,a4,0x2
    80001b50:	00e787b3          	add	a5,a5,a4
    80001b54:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    80001b58:	0144a783          	lw	a5,20(s1)
    80001b5c:	0017879b          	addiw	a5,a5,1
    80001b60:	0004a703          	lw	a4,0(s1)
    80001b64:	02e7e7bb          	remw	a5,a5,a4
    80001b68:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    80001b6c:	0304b503          	ld	a0,48(s1)
    80001b70:	00003097          	auipc	ra,0x3
    80001b74:	85c080e7          	jalr	-1956(ra) # 800043cc <_ZN9Semaphore6signalEv>

    itemAvailable->signal();
    80001b78:	0204b503          	ld	a0,32(s1)
    80001b7c:	00003097          	auipc	ra,0x3
    80001b80:	850080e7          	jalr	-1968(ra) # 800043cc <_ZN9Semaphore6signalEv>

}
    80001b84:	01813083          	ld	ra,24(sp)
    80001b88:	01013403          	ld	s0,16(sp)
    80001b8c:	00813483          	ld	s1,8(sp)
    80001b90:	00013903          	ld	s2,0(sp)
    80001b94:	02010113          	addi	sp,sp,32
    80001b98:	00008067          	ret

0000000080001b9c <_ZN9BufferCPP3getEv>:

int BufferCPP::get() {
    80001b9c:	fe010113          	addi	sp,sp,-32
    80001ba0:	00113c23          	sd	ra,24(sp)
    80001ba4:	00813823          	sd	s0,16(sp)
    80001ba8:	00913423          	sd	s1,8(sp)
    80001bac:	01213023          	sd	s2,0(sp)
    80001bb0:	02010413          	addi	s0,sp,32
    80001bb4:	00050493          	mv	s1,a0
    itemAvailable->wait();
    80001bb8:	02053503          	ld	a0,32(a0)
    80001bbc:	00002097          	auipc	ra,0x2
    80001bc0:	7e4080e7          	jalr	2020(ra) # 800043a0 <_ZN9Semaphore4waitEv>

    mutexHead->wait();
    80001bc4:	0284b503          	ld	a0,40(s1)
    80001bc8:	00002097          	auipc	ra,0x2
    80001bcc:	7d8080e7          	jalr	2008(ra) # 800043a0 <_ZN9Semaphore4waitEv>

    int ret = buffer[head];
    80001bd0:	0084b703          	ld	a4,8(s1)
    80001bd4:	0104a783          	lw	a5,16(s1)
    80001bd8:	00279693          	slli	a3,a5,0x2
    80001bdc:	00d70733          	add	a4,a4,a3
    80001be0:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    80001be4:	0017879b          	addiw	a5,a5,1
    80001be8:	0004a703          	lw	a4,0(s1)
    80001bec:	02e7e7bb          	remw	a5,a5,a4
    80001bf0:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    80001bf4:	0284b503          	ld	a0,40(s1)
    80001bf8:	00002097          	auipc	ra,0x2
    80001bfc:	7d4080e7          	jalr	2004(ra) # 800043cc <_ZN9Semaphore6signalEv>

    spaceAvailable->signal();
    80001c00:	0184b503          	ld	a0,24(s1)
    80001c04:	00002097          	auipc	ra,0x2
    80001c08:	7c8080e7          	jalr	1992(ra) # 800043cc <_ZN9Semaphore6signalEv>

    return ret;
}
    80001c0c:	00090513          	mv	a0,s2
    80001c10:	01813083          	ld	ra,24(sp)
    80001c14:	01013403          	ld	s0,16(sp)
    80001c18:	00813483          	ld	s1,8(sp)
    80001c1c:	00013903          	ld	s2,0(sp)
    80001c20:	02010113          	addi	sp,sp,32
    80001c24:	00008067          	ret

0000000080001c28 <_ZN9BufferCPP6getCntEv>:

int BufferCPP::getCnt() {
    80001c28:	fe010113          	addi	sp,sp,-32
    80001c2c:	00113c23          	sd	ra,24(sp)
    80001c30:	00813823          	sd	s0,16(sp)
    80001c34:	00913423          	sd	s1,8(sp)
    80001c38:	01213023          	sd	s2,0(sp)
    80001c3c:	02010413          	addi	s0,sp,32
    80001c40:	00050493          	mv	s1,a0
    int ret;

    mutexHead->wait();
    80001c44:	02853503          	ld	a0,40(a0)
    80001c48:	00002097          	auipc	ra,0x2
    80001c4c:	758080e7          	jalr	1880(ra) # 800043a0 <_ZN9Semaphore4waitEv>
    mutexTail->wait();
    80001c50:	0304b503          	ld	a0,48(s1)
    80001c54:	00002097          	auipc	ra,0x2
    80001c58:	74c080e7          	jalr	1868(ra) # 800043a0 <_ZN9Semaphore4waitEv>

    if (tail >= head) {
    80001c5c:	0144a783          	lw	a5,20(s1)
    80001c60:	0104a903          	lw	s2,16(s1)
    80001c64:	0327ce63          	blt	a5,s2,80001ca0 <_ZN9BufferCPP6getCntEv+0x78>
        ret = tail - head;
    80001c68:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    mutexTail->signal();
    80001c6c:	0304b503          	ld	a0,48(s1)
    80001c70:	00002097          	auipc	ra,0x2
    80001c74:	75c080e7          	jalr	1884(ra) # 800043cc <_ZN9Semaphore6signalEv>
    mutexHead->signal();
    80001c78:	0284b503          	ld	a0,40(s1)
    80001c7c:	00002097          	auipc	ra,0x2
    80001c80:	750080e7          	jalr	1872(ra) # 800043cc <_ZN9Semaphore6signalEv>

    return ret;
}
    80001c84:	00090513          	mv	a0,s2
    80001c88:	01813083          	ld	ra,24(sp)
    80001c8c:	01013403          	ld	s0,16(sp)
    80001c90:	00813483          	ld	s1,8(sp)
    80001c94:	00013903          	ld	s2,0(sp)
    80001c98:	02010113          	addi	sp,sp,32
    80001c9c:	00008067          	ret
        ret = cap - head + tail;
    80001ca0:	0004a703          	lw	a4,0(s1)
    80001ca4:	4127093b          	subw	s2,a4,s2
    80001ca8:	00f9093b          	addw	s2,s2,a5
    80001cac:	fc1ff06f          	j	80001c6c <_ZN9BufferCPP6getCntEv+0x44>

0000000080001cb0 <_ZN9BufferCPPD1Ev>:
BufferCPP::~BufferCPP() {
    80001cb0:	fe010113          	addi	sp,sp,-32
    80001cb4:	00113c23          	sd	ra,24(sp)
    80001cb8:	00813823          	sd	s0,16(sp)
    80001cbc:	00913423          	sd	s1,8(sp)
    80001cc0:	02010413          	addi	s0,sp,32
    80001cc4:	00050493          	mv	s1,a0
    Console::putc('\n');
    80001cc8:	00a00513          	li	a0,10
    80001ccc:	00002097          	auipc	ra,0x2
    80001cd0:	7c8080e7          	jalr	1992(ra) # 80004494 <_ZN7Console4putcEc>
    printString("Buffer deleted!\n");
    80001cd4:	00006517          	auipc	a0,0x6
    80001cd8:	34c50513          	addi	a0,a0,844 # 80008020 <CONSOLE_STATUS+0x10>
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	670080e7          	jalr	1648(ra) # 8000234c <_Z11printStringPKc>
    while (getCnt()) {
    80001ce4:	00048513          	mv	a0,s1
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	f40080e7          	jalr	-192(ra) # 80001c28 <_ZN9BufferCPP6getCntEv>
    80001cf0:	02050c63          	beqz	a0,80001d28 <_ZN9BufferCPPD1Ev+0x78>
        char ch = buffer[head];
    80001cf4:	0084b783          	ld	a5,8(s1)
    80001cf8:	0104a703          	lw	a4,16(s1)
    80001cfc:	00271713          	slli	a4,a4,0x2
    80001d00:	00e787b3          	add	a5,a5,a4
        Console::putc(ch);
    80001d04:	0007c503          	lbu	a0,0(a5)
    80001d08:	00002097          	auipc	ra,0x2
    80001d0c:	78c080e7          	jalr	1932(ra) # 80004494 <_ZN7Console4putcEc>
        head = (head + 1) % cap;
    80001d10:	0104a783          	lw	a5,16(s1)
    80001d14:	0017879b          	addiw	a5,a5,1
    80001d18:	0004a703          	lw	a4,0(s1)
    80001d1c:	02e7e7bb          	remw	a5,a5,a4
    80001d20:	00f4a823          	sw	a5,16(s1)
    while (getCnt()) {
    80001d24:	fc1ff06f          	j	80001ce4 <_ZN9BufferCPPD1Ev+0x34>
    Console::putc('!');
    80001d28:	02100513          	li	a0,33
    80001d2c:	00002097          	auipc	ra,0x2
    80001d30:	768080e7          	jalr	1896(ra) # 80004494 <_ZN7Console4putcEc>
    Console::putc('\n');
    80001d34:	00a00513          	li	a0,10
    80001d38:	00002097          	auipc	ra,0x2
    80001d3c:	75c080e7          	jalr	1884(ra) # 80004494 <_ZN7Console4putcEc>
    mem_free(buffer);
    80001d40:	0084b503          	ld	a0,8(s1)
    80001d44:	fffff097          	auipc	ra,0xfffff
    80001d48:	640080e7          	jalr	1600(ra) # 80001384 <_Z8mem_freePv>
    delete itemAvailable;
    80001d4c:	0204b503          	ld	a0,32(s1)
    80001d50:	00050863          	beqz	a0,80001d60 <_ZN9BufferCPPD1Ev+0xb0>
    80001d54:	00053783          	ld	a5,0(a0)
    80001d58:	0087b783          	ld	a5,8(a5)
    80001d5c:	000780e7          	jalr	a5
    delete spaceAvailable;
    80001d60:	0184b503          	ld	a0,24(s1)
    80001d64:	00050863          	beqz	a0,80001d74 <_ZN9BufferCPPD1Ev+0xc4>
    80001d68:	00053783          	ld	a5,0(a0)
    80001d6c:	0087b783          	ld	a5,8(a5)
    80001d70:	000780e7          	jalr	a5
    delete mutexTail;
    80001d74:	0304b503          	ld	a0,48(s1)
    80001d78:	00050863          	beqz	a0,80001d88 <_ZN9BufferCPPD1Ev+0xd8>
    80001d7c:	00053783          	ld	a5,0(a0)
    80001d80:	0087b783          	ld	a5,8(a5)
    80001d84:	000780e7          	jalr	a5
    delete mutexHead;
    80001d88:	0284b503          	ld	a0,40(s1)
    80001d8c:	00050863          	beqz	a0,80001d9c <_ZN9BufferCPPD1Ev+0xec>
    80001d90:	00053783          	ld	a5,0(a0)
    80001d94:	0087b783          	ld	a5,8(a5)
    80001d98:	000780e7          	jalr	a5
}
    80001d9c:	01813083          	ld	ra,24(sp)
    80001da0:	01013403          	ld	s0,16(sp)
    80001da4:	00813483          	ld	s1,8(sp)
    80001da8:	02010113          	addi	sp,sp,32
    80001dac:	00008067          	ret

0000000080001db0 <_Z24putcKernelThreadFunctionPv>:
#include "../h/KernelThreadFunctions.hpp"
#include "../h/KernelBuffer.hpp"
#include "../lib/hw.h"

void putcKernelThreadFunction(void* arg) {
    80001db0:	fe010113          	addi	sp,sp,-32
    80001db4:	00113c23          	sd	ra,24(sp)
    80001db8:	00813823          	sd	s0,16(sp)
    80001dbc:	00913423          	sd	s1,8(sp)
    80001dc0:	02010413          	addi	s0,sp,32
    switchUserToSupervisor();
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	ba4080e7          	jalr	-1116(ra) # 80001968 <_Z22switchUserToSupervisorv>
    while (true) {
        while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
    80001dcc:	00009797          	auipc	a5,0x9
    80001dd0:	8247b783          	ld	a5,-2012(a5) # 8000a5f0 <_GLOBAL_OFFSET_TABLE_+0x10>
    80001dd4:	0007b483          	ld	s1,0(a5)
    80001dd8:	0004c783          	lbu	a5,0(s1)
    80001ddc:	0207f793          	andi	a5,a5,32
    80001de0:	fe0786e3          	beqz	a5,80001dcc <_Z24putcKernelThreadFunctionPv+0x1c>
            // sve dok je konzola spremna da primi podatak saljemo joj
            char newCharacter = KernelBuffer::putcGetInstance()->removeFromBuffer();
    80001de4:	00000097          	auipc	ra,0x0
    80001de8:	204080e7          	jalr	516(ra) # 80001fe8 <_ZN12KernelBuffer15putcGetInstanceEv>
    80001dec:	00000097          	auipc	ra,0x0
    80001df0:	44c080e7          	jalr	1100(ra) # 80002238 <_ZN12KernelBuffer16removeFromBufferEv>
    80001df4:	0ff57513          	andi	a0,a0,255
            if (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
    80001df8:	0004c783          	lbu	a5,0(s1)
    80001dfc:	0207f793          	andi	a5,a5,32
    80001e00:	fc0786e3          	beqz	a5,80001dcc <_Z24putcKernelThreadFunctionPv+0x1c>
                *reinterpret_cast<char*>(CONSOLE_TX_DATA) = newCharacter;
    80001e04:	00009797          	auipc	a5,0x9
    80001e08:	81c7b783          	ld	a5,-2020(a5) # 8000a620 <_GLOBAL_OFFSET_TABLE_+0x40>
    80001e0c:	0007b783          	ld	a5,0(a5)
    80001e10:	00a78023          	sb	a0,0(a5)
    80001e14:	fb9ff06f          	j	80001dcc <_Z24putcKernelThreadFunctionPv+0x1c>

0000000080001e18 <_Z19prepareArgsAndEcallP11sysCallArgs>:

// ova funkcija predstavlja ABI (Application Binary Interface) - binarni INTERFEJS sistemskih poziva koji se vrse pomocu softverskog prekida (ecall)
// ciljnog procesora; ABI interfejs obezbedjuje prenos argumenata sistemskog poziva preko registara procesora, prelazak u privilegovani rezim rada
// procesora i prelazak na kod jezgra;
// implementacija prekidne rutine (supervisorTrap) predstavlja IMPLEMENTACIJU ABI sloja interfejsa jezgra
void prepareArgsAndEcall(sysCallArgs* ptr) {
    80001e18:	ff010113          	addi	sp,sp,-16
    80001e1c:	00813423          	sd	s0,8(sp)
    80001e20:	01010413          	addi	s0,sp,16
    __asm__ volatile ("mv a1,%[arg1]" : : [arg1] "r"(ptr->arg1)); // upis parametra ovog sistemskog poziva u registar a1
    80001e24:	00853783          	ld	a5,8(a0)
    80001e28:	00078593          	mv	a1,a5
    __asm__ volatile ("mv a2,%[arg2]" : : [arg2] "r"(ptr->arg2)); // upis parametra ovog sistemskog poziva u registar a2
    80001e2c:	01053783          	ld	a5,16(a0)
    80001e30:	00078613          	mv	a2,a5
    __asm__ volatile ("mv a3,%[arg3]" : : [arg3] "r"(ptr->arg3)); // upis parametra ovog sistemskog poziva u registar a3
    80001e34:	01853783          	ld	a5,24(a0)
    80001e38:	00078693          	mv	a3,a5
    __asm__ volatile ("mv a4,%[arg4]" : : [arg4] "r"(ptr->arg4)); // upis parametra ovog sistemskog poziva u registar a4
    80001e3c:	02053783          	ld	a5,32(a0)
    80001e40:	00078713          	mv	a4,a5
    __asm__ volatile ("mv a0,%[arg0]" : : [arg0] "r"(ptr->arg0)); // upis koda sistemskog poziva u registar a0
    80001e44:	00053783          	ld	a5,0(a0)
    80001e48:	00078513          	mv	a0,a5
    __asm__ volatile ("ecall"); // instrukcija softverskog prekida
    80001e4c:	00000073          	ecall
    80001e50:	00813403          	ld	s0,8(sp)
    80001e54:	01010113          	addi	sp,sp,16
    80001e58:	00008067          	ret

0000000080001e5c <_ZN12KernelBuffernwEm>:
    } else {
        return getcKernelBufferHandle;
    }
}

void* KernelBuffer::operator new(size_t n) {
    80001e5c:	fe010113          	addi	sp,sp,-32
    80001e60:	00113c23          	sd	ra,24(sp)
    80001e64:	00813823          	sd	s0,16(sp)
    80001e68:	00913423          	sd	s1,8(sp)
    80001e6c:	02010413          	addi	s0,sp,32
    80001e70:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	918080e7          	jalr	-1768(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80001e7c:	00048593          	mv	a1,s1
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	968080e7          	jalr	-1688(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    80001e88:	01813083          	ld	ra,24(sp)
    80001e8c:	01013403          	ld	s0,16(sp)
    80001e90:	00813483          	ld	s1,8(sp)
    80001e94:	02010113          	addi	sp,sp,32
    80001e98:	00008067          	ret

0000000080001e9c <_ZN12KernelBuffernaEm>:

void* KernelBuffer::operator new[](size_t n) {
    80001e9c:	fe010113          	addi	sp,sp,-32
    80001ea0:	00113c23          	sd	ra,24(sp)
    80001ea4:	00813823          	sd	s0,16(sp)
    80001ea8:	00913423          	sd	s1,8(sp)
    80001eac:	02010413          	addi	s0,sp,32
    80001eb0:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	8d8080e7          	jalr	-1832(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80001ebc:	00048593          	mv	a1,s1
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	928080e7          	jalr	-1752(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    80001ec8:	01813083          	ld	ra,24(sp)
    80001ecc:	01013403          	ld	s0,16(sp)
    80001ed0:	00813483          	ld	s1,8(sp)
    80001ed4:	02010113          	addi	sp,sp,32
    80001ed8:	00008067          	ret

0000000080001edc <_ZN12KernelBufferdlEPv>:

void KernelBuffer::operator delete(void *ptr) {
    80001edc:	fe010113          	addi	sp,sp,-32
    80001ee0:	00113c23          	sd	ra,24(sp)
    80001ee4:	00813823          	sd	s0,16(sp)
    80001ee8:	00913423          	sd	s1,8(sp)
    80001eec:	02010413          	addi	s0,sp,32
    80001ef0:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80001ef4:	00004097          	auipc	ra,0x4
    80001ef8:	898080e7          	jalr	-1896(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80001efc:	00048593          	mv	a1,s1
    80001f00:	00004097          	auipc	ra,0x4
    80001f04:	9cc080e7          	jalr	-1588(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80001f08:	01813083          	ld	ra,24(sp)
    80001f0c:	01013403          	ld	s0,16(sp)
    80001f10:	00813483          	ld	s1,8(sp)
    80001f14:	02010113          	addi	sp,sp,32
    80001f18:	00008067          	ret

0000000080001f1c <_ZN12KernelBufferdaEPv>:

void KernelBuffer::operator delete[](void *ptr) {
    80001f1c:	fe010113          	addi	sp,sp,-32
    80001f20:	00113c23          	sd	ra,24(sp)
    80001f24:	00813823          	sd	s0,16(sp)
    80001f28:	00913423          	sd	s1,8(sp)
    80001f2c:	02010413          	addi	s0,sp,32
    80001f30:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	858080e7          	jalr	-1960(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80001f3c:	00048593          	mv	a1,s1
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	98c080e7          	jalr	-1652(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80001f48:	01813083          	ld	ra,24(sp)
    80001f4c:	01013403          	ld	s0,16(sp)
    80001f50:	00813483          	ld	s1,8(sp)
    80001f54:	02010113          	addi	sp,sp,32
    80001f58:	00008067          	ret

0000000080001f5c <_ZN12KernelBufferC1Ev>:

KernelBuffer::KernelBuffer() {
    80001f5c:	fe010113          	addi	sp,sp,-32
    80001f60:	00113c23          	sd	ra,24(sp)
    80001f64:	00813823          	sd	s0,16(sp)
    80001f68:	00913423          	sd	s1,8(sp)
    80001f6c:	02010413          	addi	s0,sp,32
    80001f70:	00050493          	mv	s1,a0
    capacity = 8192; // 8 KB
    80001f74:	000027b7          	lui	a5,0x2
    80001f78:	00f52023          	sw	a5,0(a0)
    head = tail = 0;
    80001f7c:	00052a23          	sw	zero,20(a0)
    80001f80:	00052823          	sw	zero,16(a0)
    buffer = static_cast<int*>(KernelBuffer::operator new(capacity * sizeof(int)));
    80001f84:	00008537          	lui	a0,0x8
    80001f88:	00000097          	auipc	ra,0x0
    80001f8c:	ed4080e7          	jalr	-300(ra) # 80001e5c <_ZN12KernelBuffernwEm>
    80001f90:	00a4b423          	sd	a0,8(s1)
    spaceAvailable = KernelSemaphore::createSemaphore(capacity);
    80001f94:	0004d503          	lhu	a0,0(s1)
    80001f98:	00002097          	auipc	ra,0x2
    80001f9c:	614080e7          	jalr	1556(ra) # 800045ac <_ZN15KernelSemaphore15createSemaphoreEt>
    80001fa0:	00a4bc23          	sd	a0,24(s1)
    itemAvailable = KernelSemaphore::createSemaphore(0);
    80001fa4:	00000513          	li	a0,0
    80001fa8:	00002097          	auipc	ra,0x2
    80001fac:	604080e7          	jalr	1540(ra) # 800045ac <_ZN15KernelSemaphore15createSemaphoreEt>
    80001fb0:	02a4b023          	sd	a0,32(s1)
    mutexHead = KernelSemaphore::createSemaphore(1);
    80001fb4:	00100513          	li	a0,1
    80001fb8:	00002097          	auipc	ra,0x2
    80001fbc:	5f4080e7          	jalr	1524(ra) # 800045ac <_ZN15KernelSemaphore15createSemaphoreEt>
    80001fc0:	02a4b423          	sd	a0,40(s1)
    mutexTail = KernelSemaphore::createSemaphore(1);
    80001fc4:	00100513          	li	a0,1
    80001fc8:	00002097          	auipc	ra,0x2
    80001fcc:	5e4080e7          	jalr	1508(ra) # 800045ac <_ZN15KernelSemaphore15createSemaphoreEt>
    80001fd0:	02a4b823          	sd	a0,48(s1)
}
    80001fd4:	01813083          	ld	ra,24(sp)
    80001fd8:	01013403          	ld	s0,16(sp)
    80001fdc:	00813483          	ld	s1,8(sp)
    80001fe0:	02010113          	addi	sp,sp,32
    80001fe4:	00008067          	ret

0000000080001fe8 <_ZN12KernelBuffer15putcGetInstanceEv>:
KernelBuffer* KernelBuffer::putcGetInstance() {
    80001fe8:	fe010113          	addi	sp,sp,-32
    80001fec:	00113c23          	sd	ra,24(sp)
    80001ff0:	00813823          	sd	s0,16(sp)
    80001ff4:	00913423          	sd	s1,8(sp)
    80001ff8:	01213023          	sd	s2,0(sp)
    80001ffc:	02010413          	addi	s0,sp,32
    if (!putcKernelBufferHandle) {
    80002000:	00009497          	auipc	s1,0x9
    80002004:	9384b483          	ld	s1,-1736(s1) # 8000a938 <_ZN12KernelBuffer22putcKernelBufferHandleE>
    80002008:	02048063          	beqz	s1,80002028 <_ZN12KernelBuffer15putcGetInstanceEv+0x40>
}
    8000200c:	00048513          	mv	a0,s1
    80002010:	01813083          	ld	ra,24(sp)
    80002014:	01013403          	ld	s0,16(sp)
    80002018:	00813483          	ld	s1,8(sp)
    8000201c:	00013903          	ld	s2,0(sp)
    80002020:	02010113          	addi	sp,sp,32
    80002024:	00008067          	ret
        putcKernelBufferHandle = new KernelBuffer;
    80002028:	03800513          	li	a0,56
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	e30080e7          	jalr	-464(ra) # 80001e5c <_ZN12KernelBuffernwEm>
    80002034:	00050493          	mv	s1,a0
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	f24080e7          	jalr	-220(ra) # 80001f5c <_ZN12KernelBufferC1Ev>
    80002040:	00009797          	auipc	a5,0x9
    80002044:	8e97bc23          	sd	s1,-1800(a5) # 8000a938 <_ZN12KernelBuffer22putcKernelBufferHandleE>
        return putcKernelBufferHandle;
    80002048:	fc5ff06f          	j	8000200c <_ZN12KernelBuffer15putcGetInstanceEv+0x24>
    8000204c:	00050913          	mv	s2,a0
        putcKernelBufferHandle = new KernelBuffer;
    80002050:	00048513          	mv	a0,s1
    80002054:	00000097          	auipc	ra,0x0
    80002058:	e88080e7          	jalr	-376(ra) # 80001edc <_ZN12KernelBufferdlEPv>
    8000205c:	00090513          	mv	a0,s2
    80002060:	0000a097          	auipc	ra,0xa
    80002064:	a38080e7          	jalr	-1480(ra) # 8000ba98 <_Unwind_Resume>

0000000080002068 <_ZN12KernelBuffer15getcGetInstanceEv>:
KernelBuffer* KernelBuffer::getcGetInstance() {
    80002068:	fe010113          	addi	sp,sp,-32
    8000206c:	00113c23          	sd	ra,24(sp)
    80002070:	00813823          	sd	s0,16(sp)
    80002074:	00913423          	sd	s1,8(sp)
    80002078:	01213023          	sd	s2,0(sp)
    8000207c:	02010413          	addi	s0,sp,32
    if (!getcKernelBufferHandle) {
    80002080:	00009497          	auipc	s1,0x9
    80002084:	8c04b483          	ld	s1,-1856(s1) # 8000a940 <_ZN12KernelBuffer22getcKernelBufferHandleE>
    80002088:	02048063          	beqz	s1,800020a8 <_ZN12KernelBuffer15getcGetInstanceEv+0x40>
}
    8000208c:	00048513          	mv	a0,s1
    80002090:	01813083          	ld	ra,24(sp)
    80002094:	01013403          	ld	s0,16(sp)
    80002098:	00813483          	ld	s1,8(sp)
    8000209c:	00013903          	ld	s2,0(sp)
    800020a0:	02010113          	addi	sp,sp,32
    800020a4:	00008067          	ret
        getcKernelBufferHandle = new KernelBuffer;
    800020a8:	03800513          	li	a0,56
    800020ac:	00000097          	auipc	ra,0x0
    800020b0:	db0080e7          	jalr	-592(ra) # 80001e5c <_ZN12KernelBuffernwEm>
    800020b4:	00050493          	mv	s1,a0
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	ea4080e7          	jalr	-348(ra) # 80001f5c <_ZN12KernelBufferC1Ev>
    800020c0:	00009797          	auipc	a5,0x9
    800020c4:	8897b023          	sd	s1,-1920(a5) # 8000a940 <_ZN12KernelBuffer22getcKernelBufferHandleE>
        return getcKernelBufferHandle;
    800020c8:	fc5ff06f          	j	8000208c <_ZN12KernelBuffer15getcGetInstanceEv+0x24>
    800020cc:	00050913          	mv	s2,a0
        getcKernelBufferHandle = new KernelBuffer;
    800020d0:	00048513          	mv	a0,s1
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	e08080e7          	jalr	-504(ra) # 80001edc <_ZN12KernelBufferdlEPv>
    800020dc:	00090513          	mv	a0,s2
    800020e0:	0000a097          	auipc	ra,0xa
    800020e4:	9b8080e7          	jalr	-1608(ra) # 8000ba98 <_Unwind_Resume>

00000000800020e8 <_ZN12KernelBufferD1Ev>:

KernelBuffer::~KernelBuffer() {
    800020e8:	fe010113          	addi	sp,sp,-32
    800020ec:	00113c23          	sd	ra,24(sp)
    800020f0:	00813823          	sd	s0,16(sp)
    800020f4:	00913423          	sd	s1,8(sp)
    800020f8:	01213023          	sd	s2,0(sp)
    800020fc:	02010413          	addi	s0,sp,32
    80002100:	00050493          	mv	s1,a0
    KernelBuffer::operator delete[](buffer);
    80002104:	00853503          	ld	a0,8(a0) # 8008 <_entry-0x7fff7ff8>
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	e14080e7          	jalr	-492(ra) # 80001f1c <_ZN12KernelBufferdaEPv>
    delete spaceAvailable;
    80002110:	0184b903          	ld	s2,24(s1)
    80002114:	00090e63          	beqz	s2,80002130 <_ZN12KernelBufferD1Ev+0x48>
    80002118:	00090513          	mv	a0,s2
    8000211c:	00002097          	auipc	ra,0x2
    80002120:	750080e7          	jalr	1872(ra) # 8000486c <_ZN15KernelSemaphoreD1Ev>
    80002124:	00090513          	mv	a0,s2
    80002128:	00002097          	auipc	ra,0x2
    8000212c:	508080e7          	jalr	1288(ra) # 80004630 <_ZN15KernelSemaphoredlEPv>
    delete itemAvailable;
    80002130:	0204b903          	ld	s2,32(s1)
    80002134:	00090e63          	beqz	s2,80002150 <_ZN12KernelBufferD1Ev+0x68>
    80002138:	00090513          	mv	a0,s2
    8000213c:	00002097          	auipc	ra,0x2
    80002140:	730080e7          	jalr	1840(ra) # 8000486c <_ZN15KernelSemaphoreD1Ev>
    80002144:	00090513          	mv	a0,s2
    80002148:	00002097          	auipc	ra,0x2
    8000214c:	4e8080e7          	jalr	1256(ra) # 80004630 <_ZN15KernelSemaphoredlEPv>
    delete mutexHead;
    80002150:	0284b903          	ld	s2,40(s1)
    80002154:	00090e63          	beqz	s2,80002170 <_ZN12KernelBufferD1Ev+0x88>
    80002158:	00090513          	mv	a0,s2
    8000215c:	00002097          	auipc	ra,0x2
    80002160:	710080e7          	jalr	1808(ra) # 8000486c <_ZN15KernelSemaphoreD1Ev>
    80002164:	00090513          	mv	a0,s2
    80002168:	00002097          	auipc	ra,0x2
    8000216c:	4c8080e7          	jalr	1224(ra) # 80004630 <_ZN15KernelSemaphoredlEPv>
    delete mutexTail;
    80002170:	0304b483          	ld	s1,48(s1)
    80002174:	00048e63          	beqz	s1,80002190 <_ZN12KernelBufferD1Ev+0xa8>
    80002178:	00048513          	mv	a0,s1
    8000217c:	00002097          	auipc	ra,0x2
    80002180:	6f0080e7          	jalr	1776(ra) # 8000486c <_ZN15KernelSemaphoreD1Ev>
    80002184:	00048513          	mv	a0,s1
    80002188:	00002097          	auipc	ra,0x2
    8000218c:	4a8080e7          	jalr	1192(ra) # 80004630 <_ZN15KernelSemaphoredlEPv>
}
    80002190:	01813083          	ld	ra,24(sp)
    80002194:	01013403          	ld	s0,16(sp)
    80002198:	00813483          	ld	s1,8(sp)
    8000219c:	00013903          	ld	s2,0(sp)
    800021a0:	02010113          	addi	sp,sp,32
    800021a4:	00008067          	ret

00000000800021a8 <_ZN12KernelBuffer16insertIntoBufferEi>:

void KernelBuffer::insertIntoBuffer(int value) {
    800021a8:	fe010113          	addi	sp,sp,-32
    800021ac:	00113c23          	sd	ra,24(sp)
    800021b0:	00813823          	sd	s0,16(sp)
    800021b4:	00913423          	sd	s1,8(sp)
    800021b8:	01213023          	sd	s2,0(sp)
    800021bc:	02010413          	addi	s0,sp,32
    800021c0:	00050493          	mv	s1,a0
    800021c4:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    800021c8:	01853503          	ld	a0,24(a0)
    800021cc:	00002097          	auipc	ra,0x2
    800021d0:	564080e7          	jalr	1380(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>

    mutexTail->wait();
    800021d4:	0304b503          	ld	a0,48(s1)
    800021d8:	00002097          	auipc	ra,0x2
    800021dc:	558080e7          	jalr	1368(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>
    buffer[tail] = value;
    800021e0:	0084b783          	ld	a5,8(s1)
    800021e4:	0144a703          	lw	a4,20(s1)
    800021e8:	00271713          	slli	a4,a4,0x2
    800021ec:	00e787b3          	add	a5,a5,a4
    800021f0:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % capacity;
    800021f4:	0144a783          	lw	a5,20(s1)
    800021f8:	0017879b          	addiw	a5,a5,1
    800021fc:	0004a703          	lw	a4,0(s1)
    80002200:	02e7e7bb          	remw	a5,a5,a4
    80002204:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    80002208:	0304b503          	ld	a0,48(s1)
    8000220c:	00002097          	auipc	ra,0x2
    80002210:	688080e7          	jalr	1672(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>

    itemAvailable->signal();
    80002214:	0204b503          	ld	a0,32(s1)
    80002218:	00002097          	auipc	ra,0x2
    8000221c:	67c080e7          	jalr	1660(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>
}
    80002220:	01813083          	ld	ra,24(sp)
    80002224:	01013403          	ld	s0,16(sp)
    80002228:	00813483          	ld	s1,8(sp)
    8000222c:	00013903          	ld	s2,0(sp)
    80002230:	02010113          	addi	sp,sp,32
    80002234:	00008067          	ret

0000000080002238 <_ZN12KernelBuffer16removeFromBufferEv>:

int KernelBuffer::removeFromBuffer() {
    80002238:	fe010113          	addi	sp,sp,-32
    8000223c:	00113c23          	sd	ra,24(sp)
    80002240:	00813823          	sd	s0,16(sp)
    80002244:	00913423          	sd	s1,8(sp)
    80002248:	01213023          	sd	s2,0(sp)
    8000224c:	02010413          	addi	s0,sp,32
    80002250:	00050493          	mv	s1,a0
    itemAvailable->wait();
    80002254:	02053503          	ld	a0,32(a0)
    80002258:	00002097          	auipc	ra,0x2
    8000225c:	4d8080e7          	jalr	1240(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>

    mutexHead->wait();
    80002260:	0284b503          	ld	a0,40(s1)
    80002264:	00002097          	auipc	ra,0x2
    80002268:	4cc080e7          	jalr	1228(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>
    int value = buffer[head];
    8000226c:	0084b703          	ld	a4,8(s1)
    80002270:	0104a783          	lw	a5,16(s1)
    80002274:	00279693          	slli	a3,a5,0x2
    80002278:	00d70733          	add	a4,a4,a3
    8000227c:	00072903          	lw	s2,0(a4)
    head = (head + 1) % capacity;
    80002280:	0017879b          	addiw	a5,a5,1
    80002284:	0004a703          	lw	a4,0(s1)
    80002288:	02e7e7bb          	remw	a5,a5,a4
    8000228c:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    80002290:	0284b503          	ld	a0,40(s1)
    80002294:	00002097          	auipc	ra,0x2
    80002298:	600080e7          	jalr	1536(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>

    spaceAvailable->signal();
    8000229c:	0184b503          	ld	a0,24(s1)
    800022a0:	00002097          	auipc	ra,0x2
    800022a4:	5f4080e7          	jalr	1524(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>

    return value;
}
    800022a8:	00090513          	mv	a0,s2
    800022ac:	01813083          	ld	ra,24(sp)
    800022b0:	01013403          	ld	s0,16(sp)
    800022b4:	00813483          	ld	s1,8(sp)
    800022b8:	00013903          	ld	s2,0(sp)
    800022bc:	02010113          	addi	sp,sp,32
    800022c0:	00008067          	ret

00000000800022c4 <_ZN12KernelBuffer19getNumberOfElementsEv>:

int KernelBuffer::getNumberOfElements() {
    800022c4:	fe010113          	addi	sp,sp,-32
    800022c8:	00113c23          	sd	ra,24(sp)
    800022cc:	00813823          	sd	s0,16(sp)
    800022d0:	00913423          	sd	s1,8(sp)
    800022d4:	01213023          	sd	s2,0(sp)
    800022d8:	02010413          	addi	s0,sp,32
    800022dc:	00050493          	mv	s1,a0
    int value;

    mutexHead->wait();
    800022e0:	02853503          	ld	a0,40(a0)
    800022e4:	00002097          	auipc	ra,0x2
    800022e8:	44c080e7          	jalr	1100(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>
    mutexTail->wait();
    800022ec:	0304b503          	ld	a0,48(s1)
    800022f0:	00002097          	auipc	ra,0x2
    800022f4:	440080e7          	jalr	1088(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>

    if (tail >= head) {
    800022f8:	0144a783          	lw	a5,20(s1)
    800022fc:	0104a903          	lw	s2,16(s1)
    80002300:	0327ce63          	blt	a5,s2,8000233c <_ZN12KernelBuffer19getNumberOfElementsEv+0x78>
        value = tail - head;
    80002304:	4127893b          	subw	s2,a5,s2
    } else {
        value = capacity - head + tail;
    }

    mutexHead->signal();
    80002308:	0284b503          	ld	a0,40(s1)
    8000230c:	00002097          	auipc	ra,0x2
    80002310:	588080e7          	jalr	1416(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>
    mutexTail->signal();
    80002314:	0304b503          	ld	a0,48(s1)
    80002318:	00002097          	auipc	ra,0x2
    8000231c:	57c080e7          	jalr	1404(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>

    return value;
    80002320:	00090513          	mv	a0,s2
    80002324:	01813083          	ld	ra,24(sp)
    80002328:	01013403          	ld	s0,16(sp)
    8000232c:	00813483          	ld	s1,8(sp)
    80002330:	00013903          	ld	s2,0(sp)
    80002334:	02010113          	addi	sp,sp,32
    80002338:	00008067          	ret
        value = capacity - head + tail;
    8000233c:	0004a703          	lw	a4,0(s1)
    80002340:	4127093b          	subw	s2,a4,s2
    80002344:	00f9093b          	addw	s2,s2,a5
    80002348:	fc1ff06f          	j	80002308 <_ZN12KernelBuffer19getNumberOfElementsEv+0x44>

000000008000234c <_Z11printStringPKc>:

#define LOCK() while(copy_and_swap(lockPrint, 0, 1))
#define UNLOCK() while(copy_and_swap(lockPrint, 1, 0))

void printString(char const *string)
{
    8000234c:	fe010113          	addi	sp,sp,-32
    80002350:	00113c23          	sd	ra,24(sp)
    80002354:	00813823          	sd	s0,16(sp)
    80002358:	00913423          	sd	s1,8(sp)
    8000235c:	02010413          	addi	s0,sp,32
    80002360:	00050493          	mv	s1,a0
    LOCK();
    80002364:	00100613          	li	a2,1
    80002368:	00000593          	li	a1,0
    8000236c:	00008517          	auipc	a0,0x8
    80002370:	5dc50513          	addi	a0,a0,1500 # 8000a948 <lockPrint>
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	c8c080e7          	jalr	-884(ra) # 80001000 <copy_and_swap>
    8000237c:	fe0514e3          	bnez	a0,80002364 <_Z11printStringPKc+0x18>
    while (*string != '\0')
    80002380:	0004c503          	lbu	a0,0(s1)
    80002384:	00050a63          	beqz	a0,80002398 <_Z11printStringPKc+0x4c>
    {
        putc(*string);
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	540080e7          	jalr	1344(ra) # 800018c8 <_Z4putcc>
        string++;
    80002390:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    80002394:	fedff06f          	j	80002380 <_Z11printStringPKc+0x34>
    }
    UNLOCK();
    80002398:	00000613          	li	a2,0
    8000239c:	00100593          	li	a1,1
    800023a0:	00008517          	auipc	a0,0x8
    800023a4:	5a850513          	addi	a0,a0,1448 # 8000a948 <lockPrint>
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	c58080e7          	jalr	-936(ra) # 80001000 <copy_and_swap>
    800023b0:	fe0514e3          	bnez	a0,80002398 <_Z11printStringPKc+0x4c>
}
    800023b4:	01813083          	ld	ra,24(sp)
    800023b8:	01013403          	ld	s0,16(sp)
    800023bc:	00813483          	ld	s1,8(sp)
    800023c0:	02010113          	addi	sp,sp,32
    800023c4:	00008067          	ret

00000000800023c8 <_Z9getStringPci>:

char* getString(char *buf, int max) {
    800023c8:	fd010113          	addi	sp,sp,-48
    800023cc:	02113423          	sd	ra,40(sp)
    800023d0:	02813023          	sd	s0,32(sp)
    800023d4:	00913c23          	sd	s1,24(sp)
    800023d8:	01213823          	sd	s2,16(sp)
    800023dc:	01313423          	sd	s3,8(sp)
    800023e0:	01413023          	sd	s4,0(sp)
    800023e4:	03010413          	addi	s0,sp,48
    800023e8:	00050993          	mv	s3,a0
    800023ec:	00058a13          	mv	s4,a1
    LOCK();
    800023f0:	00100613          	li	a2,1
    800023f4:	00000593          	li	a1,0
    800023f8:	00008517          	auipc	a0,0x8
    800023fc:	55050513          	addi	a0,a0,1360 # 8000a948 <lockPrint>
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	c00080e7          	jalr	-1024(ra) # 80001000 <copy_and_swap>
    80002408:	fe0514e3          	bnez	a0,800023f0 <_Z9getStringPci+0x28>
    int i, cc;
    char c;

    for(i=0; i+1 < max; ){
    8000240c:	00000913          	li	s2,0
    80002410:	00090493          	mv	s1,s2
    80002414:	0019091b          	addiw	s2,s2,1
    80002418:	03495a63          	bge	s2,s4,8000244c <_Z9getStringPci+0x84>
        cc = getc();
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	454080e7          	jalr	1108(ra) # 80001870 <_Z4getcv>
        if(cc < 1)
    80002424:	02050463          	beqz	a0,8000244c <_Z9getStringPci+0x84>
            break;
        c = cc;
        buf[i++] = c;
    80002428:	009984b3          	add	s1,s3,s1
    8000242c:	00a48023          	sb	a0,0(s1)
        if(c == '\n' || c == '\r')
    80002430:	00a00793          	li	a5,10
    80002434:	00f50a63          	beq	a0,a5,80002448 <_Z9getStringPci+0x80>
    80002438:	00d00793          	li	a5,13
    8000243c:	fcf51ae3          	bne	a0,a5,80002410 <_Z9getStringPci+0x48>
        buf[i++] = c;
    80002440:	00090493          	mv	s1,s2
    80002444:	0080006f          	j	8000244c <_Z9getStringPci+0x84>
    80002448:	00090493          	mv	s1,s2
            break;
    }
    buf[i] = '\0';
    8000244c:	009984b3          	add	s1,s3,s1
    80002450:	00048023          	sb	zero,0(s1)

    UNLOCK();
    80002454:	00000613          	li	a2,0
    80002458:	00100593          	li	a1,1
    8000245c:	00008517          	auipc	a0,0x8
    80002460:	4ec50513          	addi	a0,a0,1260 # 8000a948 <lockPrint>
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	b9c080e7          	jalr	-1124(ra) # 80001000 <copy_and_swap>
    8000246c:	fe0514e3          	bnez	a0,80002454 <_Z9getStringPci+0x8c>
    return buf;
}
    80002470:	00098513          	mv	a0,s3
    80002474:	02813083          	ld	ra,40(sp)
    80002478:	02013403          	ld	s0,32(sp)
    8000247c:	01813483          	ld	s1,24(sp)
    80002480:	01013903          	ld	s2,16(sp)
    80002484:	00813983          	ld	s3,8(sp)
    80002488:	00013a03          	ld	s4,0(sp)
    8000248c:	03010113          	addi	sp,sp,48
    80002490:	00008067          	ret

0000000080002494 <_Z11stringToIntPKc>:

int stringToInt(const char *s) {
    80002494:	ff010113          	addi	sp,sp,-16
    80002498:	00813423          	sd	s0,8(sp)
    8000249c:	01010413          	addi	s0,sp,16
    800024a0:	00050693          	mv	a3,a0
    int n;

    n = 0;
    800024a4:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    800024a8:	0006c603          	lbu	a2,0(a3)
    800024ac:	fd06071b          	addiw	a4,a2,-48
    800024b0:	0ff77713          	andi	a4,a4,255
    800024b4:	00900793          	li	a5,9
    800024b8:	02e7e063          	bltu	a5,a4,800024d8 <_Z11stringToIntPKc+0x44>
        n = n * 10 + *s++ - '0';
    800024bc:	0025179b          	slliw	a5,a0,0x2
    800024c0:	00a787bb          	addw	a5,a5,a0
    800024c4:	0017979b          	slliw	a5,a5,0x1
    800024c8:	00168693          	addi	a3,a3,1
    800024cc:	00c787bb          	addw	a5,a5,a2
    800024d0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    800024d4:	fd5ff06f          	j	800024a8 <_Z11stringToIntPKc+0x14>
    return n;
}
    800024d8:	00813403          	ld	s0,8(sp)
    800024dc:	01010113          	addi	sp,sp,16
    800024e0:	00008067          	ret

00000000800024e4 <_Z8printIntiii>:

char digits[] = "0123456789ABCDEF";

void printInt(int xx, int base, int sgn)
{
    800024e4:	fc010113          	addi	sp,sp,-64
    800024e8:	02113c23          	sd	ra,56(sp)
    800024ec:	02813823          	sd	s0,48(sp)
    800024f0:	02913423          	sd	s1,40(sp)
    800024f4:	03213023          	sd	s2,32(sp)
    800024f8:	01313c23          	sd	s3,24(sp)
    800024fc:	04010413          	addi	s0,sp,64
    80002500:	00050493          	mv	s1,a0
    80002504:	00058913          	mv	s2,a1
    80002508:	00060993          	mv	s3,a2
    LOCK();
    8000250c:	00100613          	li	a2,1
    80002510:	00000593          	li	a1,0
    80002514:	00008517          	auipc	a0,0x8
    80002518:	43450513          	addi	a0,a0,1076 # 8000a948 <lockPrint>
    8000251c:	fffff097          	auipc	ra,0xfffff
    80002520:	ae4080e7          	jalr	-1308(ra) # 80001000 <copy_and_swap>
    80002524:	fe0514e3          	bnez	a0,8000250c <_Z8printIntiii+0x28>
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    80002528:	00098463          	beqz	s3,80002530 <_Z8printIntiii+0x4c>
    8000252c:	0804c463          	bltz	s1,800025b4 <_Z8printIntiii+0xd0>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80002530:	0004851b          	sext.w	a0,s1
    neg = 0;
    80002534:	00000593          	li	a1,0
    }

    i = 0;
    80002538:	00000493          	li	s1,0
    do{
        buf[i++] = digits[x % base];
    8000253c:	0009079b          	sext.w	a5,s2
    80002540:	0325773b          	remuw	a4,a0,s2
    80002544:	00048613          	mv	a2,s1
    80002548:	0014849b          	addiw	s1,s1,1
    8000254c:	02071693          	slli	a3,a4,0x20
    80002550:	0206d693          	srli	a3,a3,0x20
    80002554:	00008717          	auipc	a4,0x8
    80002558:	e5470713          	addi	a4,a4,-428 # 8000a3a8 <digits>
    8000255c:	00d70733          	add	a4,a4,a3
    80002560:	00074683          	lbu	a3,0(a4)
    80002564:	fd040713          	addi	a4,s0,-48
    80002568:	00c70733          	add	a4,a4,a2
    8000256c:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    80002570:	0005071b          	sext.w	a4,a0
    80002574:	0325553b          	divuw	a0,a0,s2
    80002578:	fcf772e3          	bgeu	a4,a5,8000253c <_Z8printIntiii+0x58>
    if(neg)
    8000257c:	00058c63          	beqz	a1,80002594 <_Z8printIntiii+0xb0>
        buf[i++] = '-';
    80002580:	fd040793          	addi	a5,s0,-48
    80002584:	009784b3          	add	s1,a5,s1
    80002588:	02d00793          	li	a5,45
    8000258c:	fef48823          	sb	a5,-16(s1)
    80002590:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    80002594:	fff4849b          	addiw	s1,s1,-1
    80002598:	0204c463          	bltz	s1,800025c0 <_Z8printIntiii+0xdc>
        putc(buf[i]);
    8000259c:	fd040793          	addi	a5,s0,-48
    800025a0:	009787b3          	add	a5,a5,s1
    800025a4:	ff07c503          	lbu	a0,-16(a5)
    800025a8:	fffff097          	auipc	ra,0xfffff
    800025ac:	320080e7          	jalr	800(ra) # 800018c8 <_Z4putcc>
    800025b0:	fe5ff06f          	j	80002594 <_Z8printIntiii+0xb0>
        x = -xx;
    800025b4:	4090053b          	negw	a0,s1
        neg = 1;
    800025b8:	00100593          	li	a1,1
        x = -xx;
    800025bc:	f7dff06f          	j	80002538 <_Z8printIntiii+0x54>

    UNLOCK();
    800025c0:	00000613          	li	a2,0
    800025c4:	00100593          	li	a1,1
    800025c8:	00008517          	auipc	a0,0x8
    800025cc:	38050513          	addi	a0,a0,896 # 8000a948 <lockPrint>
    800025d0:	fffff097          	auipc	ra,0xfffff
    800025d4:	a30080e7          	jalr	-1488(ra) # 80001000 <copy_and_swap>
    800025d8:	fe0514e3          	bnez	a0,800025c0 <_Z8printIntiii+0xdc>
    800025dc:	03813083          	ld	ra,56(sp)
    800025e0:	03013403          	ld	s0,48(sp)
    800025e4:	02813483          	ld	s1,40(sp)
    800025e8:	02013903          	ld	s2,32(sp)
    800025ec:	01813983          	ld	s3,24(sp)
    800025f0:	04010113          	addi	sp,sp,64
    800025f4:	00008067          	ret

00000000800025f8 <_ZN9Scheduler11getInstanceEv>:
#include "../h/Scheduler.hpp"

Scheduler& Scheduler::getInstance() {
    800025f8:	ff010113          	addi	sp,sp,-16
    800025fc:	00813423          	sd	s0,8(sp)
    80002600:	01010413          	addi	s0,sp,16
    static Scheduler scheduler;
    return scheduler;
}
    80002604:	00008517          	auipc	a0,0x8
    80002608:	34c50513          	addi	a0,a0,844 # 8000a950 <_ZZN9Scheduler11getInstanceEvE9scheduler>
    8000260c:	00813403          	ld	s0,8(sp)
    80002610:	01010113          	addi	sp,sp,16
    80002614:	00008067          	ret

0000000080002618 <_ZN9Scheduler3getEv>:

// uzima se nit sa pocetka ulancane liste schedulera i daje se procesoru
// u slucaju da takve niti nema, onda se procesoru daje nit koja izvrsava funkciju idleFunction (beskonacno se vrti u praznoj petlji)
TCB* Scheduler::get() {
    80002618:	ff010113          	addi	sp,sp,-16
    8000261c:	00113423          	sd	ra,8(sp)
    80002620:	00813023          	sd	s0,0(sp)
    80002624:	01010413          	addi	s0,sp,16
    return removeFromScheduler(schedulerHead, scheduletTail);
    80002628:	00850593          	addi	a1,a0,8
    8000262c:	fffff097          	auipc	ra,0xfffff
    80002630:	c34080e7          	jalr	-972(ra) # 80001260 <_Z19removeFromSchedulerRP3TCBS1_>
}
    80002634:	00813083          	ld	ra,8(sp)
    80002638:	00013403          	ld	s0,0(sp)
    8000263c:	01010113          	addi	sp,sp,16
    80002640:	00008067          	ret

0000000080002644 <_ZN9Scheduler3putEP3TCB>:

// nova nit se smesta na kraj ulancane liste schedulera
void Scheduler::put(TCB* tcb) {
    80002644:	ff010113          	addi	sp,sp,-16
    80002648:	00113423          	sd	ra,8(sp)
    8000264c:	00813023          	sd	s0,0(sp)
    80002650:	01010413          	addi	s0,sp,16
    80002654:	00058613          	mv	a2,a1
    insertIntoScheduler(schedulerHead, scheduletTail, tcb);
    80002658:	00850593          	addi	a1,a0,8
    8000265c:	fffff097          	auipc	ra,0xfffff
    80002660:	c50080e7          	jalr	-944(ra) # 800012ac <_Z19insertIntoSchedulerRP3TCBS1_S0_>
    80002664:	00813083          	ld	ra,8(sp)
    80002668:	00013403          	ld	s0,0(sp)
    8000266c:	01010113          	addi	sp,sp,16
    80002670:	00008067          	ret

0000000080002674 <_Z9sleepyRunPv>:
#include "../h/syscall_c.h"
#include "Z_Njihovo_Printing.hpp"

bool finished[2];

void sleepyRun(void *arg) {
    80002674:	fe010113          	addi	sp,sp,-32
    80002678:	00113c23          	sd	ra,24(sp)
    8000267c:	00813823          	sd	s0,16(sp)
    80002680:	00913423          	sd	s1,8(sp)
    80002684:	01213023          	sd	s2,0(sp)
    80002688:	02010413          	addi	s0,sp,32
    time_t sleep_time = *((time_t *) arg);
    8000268c:	00053903          	ld	s2,0(a0)
    int i = 6;
    80002690:	00600493          	li	s1,6
    while (--i > 0) {
    80002694:	fff4849b          	addiw	s1,s1,-1
    80002698:	04905463          	blez	s1,800026e0 <_Z9sleepyRunPv+0x6c>

        printString("Hello ");
    8000269c:	00006517          	auipc	a0,0x6
    800026a0:	99c50513          	addi	a0,a0,-1636 # 80008038 <CONSOLE_STATUS+0x28>
    800026a4:	00000097          	auipc	ra,0x0
    800026a8:	ca8080e7          	jalr	-856(ra) # 8000234c <_Z11printStringPKc>
        printInt(sleep_time);
    800026ac:	00000613          	li	a2,0
    800026b0:	00a00593          	li	a1,10
    800026b4:	0009051b          	sext.w	a0,s2
    800026b8:	00000097          	auipc	ra,0x0
    800026bc:	e2c080e7          	jalr	-468(ra) # 800024e4 <_Z8printIntiii>
        printString(" !\n");
    800026c0:	00006517          	auipc	a0,0x6
    800026c4:	98050513          	addi	a0,a0,-1664 # 80008040 <CONSOLE_STATUS+0x30>
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	c84080e7          	jalr	-892(ra) # 8000234c <_Z11printStringPKc>
        time_sleep(sleep_time);
    800026d0:	00090513          	mv	a0,s2
    800026d4:	fffff097          	auipc	ra,0xfffff
    800026d8:	138080e7          	jalr	312(ra) # 8000180c <_Z10time_sleepm>
    while (--i > 0) {
    800026dc:	fb9ff06f          	j	80002694 <_Z9sleepyRunPv+0x20>
    }
    finished[sleep_time/10-1] = true;
    800026e0:	00a00793          	li	a5,10
    800026e4:	02f95933          	divu	s2,s2,a5
    800026e8:	fff90913          	addi	s2,s2,-1
    800026ec:	00008797          	auipc	a5,0x8
    800026f0:	27478793          	addi	a5,a5,628 # 8000a960 <finished>
    800026f4:	01278933          	add	s2,a5,s2
    800026f8:	00100793          	li	a5,1
    800026fc:	00f90023          	sb	a5,0(s2)
}
    80002700:	01813083          	ld	ra,24(sp)
    80002704:	01013403          	ld	s0,16(sp)
    80002708:	00813483          	ld	s1,8(sp)
    8000270c:	00013903          	ld	s2,0(sp)
    80002710:	02010113          	addi	sp,sp,32
    80002714:	00008067          	ret

0000000080002718 <_Z8userMainPv>:
        putc('\n');
        myOwnMutex->signal();
    }
};

void userMain(void* arg) {
    80002718:	fb010113          	addi	sp,sp,-80
    8000271c:	04113423          	sd	ra,72(sp)
    80002720:	04813023          	sd	s0,64(sp)
    80002724:	02913c23          	sd	s1,56(sp)
    80002728:	03213823          	sd	s2,48(sp)
    8000272c:	03313423          	sd	s3,40(sp)
    80002730:	05010413          	addi	s0,sp,80
    //producerConsumer_CPP_Sync_API(); // kompletan CPP API sa semaforima, sinhrona promena konteksta (prosao)

    //testSleeping(); // uspavljivanje i budjenje niti, C API test (prosao)
    //ConsumerProducerCPP::testConsumerProducer(); // CPP API i asinhrona promena konteksta, kompletan test svega (prosao)

    myOwnMutex = new Semaphore();
    80002734:	01000513          	li	a0,16
    80002738:	00002097          	auipc	ra,0x2
    8000273c:	998080e7          	jalr	-1640(ra) # 800040d0 <_Znwm>
    80002740:	00050493          	mv	s1,a0
    80002744:	00100593          	li	a1,1
    80002748:	00002097          	auipc	ra,0x2
    8000274c:	c20080e7          	jalr	-992(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80002750:	00008797          	auipc	a5,0x8
    80002754:	2297b023          	sd	s1,544(a5) # 8000a970 <myOwnMutex>
    myOwnWaitForAll = new Semaphore(0);
    80002758:	01000513          	li	a0,16
    8000275c:	00002097          	auipc	ra,0x2
    80002760:	974080e7          	jalr	-1676(ra) # 800040d0 <_Znwm>
    80002764:	00050493          	mv	s1,a0
    80002768:	00000593          	li	a1,0
    8000276c:	00002097          	auipc	ra,0x2
    80002770:	bfc080e7          	jalr	-1028(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80002774:	00008797          	auipc	a5,0x8
    80002778:	1e97ba23          	sd	s1,500(a5) # 8000a968 <myOwnWaitForAll>

    A* a = new A(5);
    8000277c:	02000513          	li	a0,32
    80002780:	00002097          	auipc	ra,0x2
    80002784:	950080e7          	jalr	-1712(ra) # 800040d0 <_Znwm>
    80002788:	00050993          	mv	s3,a0
    explicit A(time_t period) : PeriodicThread(period) {}
    8000278c:	00500593          	li	a1,5
    80002790:	00002097          	auipc	ra,0x2
    80002794:	c88080e7          	jalr	-888(ra) # 80004418 <_ZN14PeriodicThreadC1Em>
    80002798:	00008797          	auipc	a5,0x8
    8000279c:	d5078793          	addi	a5,a5,-688 # 8000a4e8 <_ZTV1A+0x10>
    800027a0:	00f9b023          	sd	a5,0(s3)
    B* b = new B(5);
    800027a4:	02000513          	li	a0,32
    800027a8:	00002097          	auipc	ra,0x2
    800027ac:	928080e7          	jalr	-1752(ra) # 800040d0 <_Znwm>
    800027b0:	00050913          	mv	s2,a0
    explicit B(time_t period) : PeriodicThread(period) {}
    800027b4:	00500593          	li	a1,5
    800027b8:	00002097          	auipc	ra,0x2
    800027bc:	c60080e7          	jalr	-928(ra) # 80004418 <_ZN14PeriodicThreadC1Em>
    800027c0:	00008797          	auipc	a5,0x8
    800027c4:	d5878793          	addi	a5,a5,-680 # 8000a518 <_ZTV1B+0x10>
    800027c8:	00f93023          	sd	a5,0(s2)
    C* c = new C(5);
    800027cc:	02000513          	li	a0,32
    800027d0:	00002097          	auipc	ra,0x2
    800027d4:	900080e7          	jalr	-1792(ra) # 800040d0 <_Znwm>
    800027d8:	00050493          	mv	s1,a0
    explicit C(time_t period) : PeriodicThread(period) {}
    800027dc:	00500593          	li	a1,5
    800027e0:	00002097          	auipc	ra,0x2
    800027e4:	c38080e7          	jalr	-968(ra) # 80004418 <_ZN14PeriodicThreadC1Em>
    800027e8:	00008797          	auipc	a5,0x8
    800027ec:	d6078793          	addi	a5,a5,-672 # 8000a548 <_ZTV1C+0x10>
    800027f0:	00f4b023          	sd	a5,0(s1)

    PeriodicThread* threads[3];
    threads[0] = a;
    800027f4:	fb343c23          	sd	s3,-72(s0)
    threads[1] = b;
    800027f8:	fd243023          	sd	s2,-64(s0)
    threads[2] = c;
    800027fc:	fc943423          	sd	s1,-56(s0)

    threads[0]->start();
    80002800:	00098513          	mv	a0,s3
    80002804:	00002097          	auipc	ra,0x2
    80002808:	a7c080e7          	jalr	-1412(ra) # 80004280 <_ZN6Thread5startEv>
    threads[1]->start();
    8000280c:	00090513          	mv	a0,s2
    80002810:	00002097          	auipc	ra,0x2
    80002814:	a70080e7          	jalr	-1424(ra) # 80004280 <_ZN6Thread5startEv>
    threads[2]->start();
    80002818:	00048513          	mv	a0,s1
    8000281c:	00002097          	auipc	ra,0x2
    80002820:	a64080e7          	jalr	-1436(ra) # 80004280 <_ZN6Thread5startEv>

    int endThis = 0;
    for (int i = 0; i < 3; i++) {
    80002824:	00000493          	li	s1,0
    int endThis = 0;
    80002828:	00000913          	li	s2,0
    8000282c:	0280006f          	j	80002854 <_Z8userMainPv+0x13c>
        char chr = getc();
        if (chr == 'k') {
            threads[endThis++]->endPeriodicThread();
    80002830:	0019099b          	addiw	s3,s2,1
    80002834:	00391913          	slli	s2,s2,0x3
    80002838:	fd040793          	addi	a5,s0,-48
    8000283c:	01278933          	add	s2,a5,s2
    80002840:	fe893503          	ld	a0,-24(s2)
    80002844:	00002097          	auipc	ra,0x2
    80002848:	bb4080e7          	jalr	-1100(ra) # 800043f8 <_ZN14PeriodicThread17endPeriodicThreadEv>
    8000284c:	00098913          	mv	s2,s3
    for (int i = 0; i < 3; i++) {
    80002850:	0014849b          	addiw	s1,s1,1
    80002854:	00200793          	li	a5,2
    80002858:	0097ce63          	blt	a5,s1,80002874 <_Z8userMainPv+0x15c>
        char chr = getc();
    8000285c:	fffff097          	auipc	ra,0xfffff
    80002860:	014080e7          	jalr	20(ra) # 80001870 <_Z4getcv>
        if (chr == 'k') {
    80002864:	06b00793          	li	a5,107
    80002868:	fcf504e3          	beq	a0,a5,80002830 <_Z8userMainPv+0x118>
        } else {
            i--;
    8000286c:	fff4849b          	addiw	s1,s1,-1
    80002870:	fe1ff06f          	j	80002850 <_Z8userMainPv+0x138>
        }
    }

    for (int i = 0; i < 3; i++) {
    80002874:	00000493          	li	s1,0
    80002878:	00200793          	li	a5,2
    8000287c:	0097ce63          	blt	a5,s1,80002898 <_Z8userMainPv+0x180>
        myOwnWaitForAll->wait();
    80002880:	00008517          	auipc	a0,0x8
    80002884:	0e853503          	ld	a0,232(a0) # 8000a968 <myOwnWaitForAll>
    80002888:	00002097          	auipc	ra,0x2
    8000288c:	b18080e7          	jalr	-1256(ra) # 800043a0 <_ZN9Semaphore4waitEv>
    for (int i = 0; i < 3; i++) {
    80002890:	0014849b          	addiw	s1,s1,1
    80002894:	fe5ff06f          	j	80002878 <_Z8userMainPv+0x160>
    }

    delete myOwnMutex;
    80002898:	00008517          	auipc	a0,0x8
    8000289c:	0d853503          	ld	a0,216(a0) # 8000a970 <myOwnMutex>
    800028a0:	00050863          	beqz	a0,800028b0 <_Z8userMainPv+0x198>
    800028a4:	00053783          	ld	a5,0(a0)
    800028a8:	0087b783          	ld	a5,8(a5)
    800028ac:	000780e7          	jalr	a5
    delete myOwnWaitForAll;
    800028b0:	00008517          	auipc	a0,0x8
    800028b4:	0b853503          	ld	a0,184(a0) # 8000a968 <myOwnWaitForAll>
    800028b8:	00050863          	beqz	a0,800028c8 <_Z8userMainPv+0x1b0>
    800028bc:	00053783          	ld	a5,0(a0)
    800028c0:	0087b783          	ld	a5,8(a5)
    800028c4:	000780e7          	jalr	a5
}
    800028c8:	04813083          	ld	ra,72(sp)
    800028cc:	04013403          	ld	s0,64(sp)
    800028d0:	03813483          	ld	s1,56(sp)
    800028d4:	03013903          	ld	s2,48(sp)
    800028d8:	02813983          	ld	s3,40(sp)
    800028dc:	05010113          	addi	sp,sp,80
    800028e0:	00008067          	ret
    800028e4:	00050913          	mv	s2,a0
    myOwnMutex = new Semaphore();
    800028e8:	00048513          	mv	a0,s1
    800028ec:	00002097          	auipc	ra,0x2
    800028f0:	834080e7          	jalr	-1996(ra) # 80004120 <_ZdlPv>
    800028f4:	00090513          	mv	a0,s2
    800028f8:	00009097          	auipc	ra,0x9
    800028fc:	1a0080e7          	jalr	416(ra) # 8000ba98 <_Unwind_Resume>
    80002900:	00050913          	mv	s2,a0
    myOwnWaitForAll = new Semaphore(0);
    80002904:	00048513          	mv	a0,s1
    80002908:	00002097          	auipc	ra,0x2
    8000290c:	818080e7          	jalr	-2024(ra) # 80004120 <_ZdlPv>
    80002910:	00090513          	mv	a0,s2
    80002914:	00009097          	auipc	ra,0x9
    80002918:	184080e7          	jalr	388(ra) # 8000ba98 <_Unwind_Resume>
    8000291c:	00050493          	mv	s1,a0
    A* a = new A(5);
    80002920:	00098513          	mv	a0,s3
    80002924:	00001097          	auipc	ra,0x1
    80002928:	7fc080e7          	jalr	2044(ra) # 80004120 <_ZdlPv>
    8000292c:	00048513          	mv	a0,s1
    80002930:	00009097          	auipc	ra,0x9
    80002934:	168080e7          	jalr	360(ra) # 8000ba98 <_Unwind_Resume>
    80002938:	00050493          	mv	s1,a0
    B* b = new B(5);
    8000293c:	00090513          	mv	a0,s2
    80002940:	00001097          	auipc	ra,0x1
    80002944:	7e0080e7          	jalr	2016(ra) # 80004120 <_ZdlPv>
    80002948:	00048513          	mv	a0,s1
    8000294c:	00009097          	auipc	ra,0x9
    80002950:	14c080e7          	jalr	332(ra) # 8000ba98 <_Unwind_Resume>
    80002954:	00050913          	mv	s2,a0
    C* c = new C(5);
    80002958:	00048513          	mv	a0,s1
    8000295c:	00001097          	auipc	ra,0x1
    80002960:	7c4080e7          	jalr	1988(ra) # 80004120 <_ZdlPv>
    80002964:	00090513          	mv	a0,s2
    80002968:	00009097          	auipc	ra,0x9
    8000296c:	130080e7          	jalr	304(ra) # 8000ba98 <_Unwind_Resume>

0000000080002970 <_Z9fibonaccim>:
bool finishedA = false;
bool finishedB = false;
bool finishedC = false;
bool finishedD = false;

uint64 fibonacci(uint64 n) {
    80002970:	fe010113          	addi	sp,sp,-32
    80002974:	00113c23          	sd	ra,24(sp)
    80002978:	00813823          	sd	s0,16(sp)
    8000297c:	00913423          	sd	s1,8(sp)
    80002980:	01213023          	sd	s2,0(sp)
    80002984:	02010413          	addi	s0,sp,32
    80002988:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    8000298c:	00100793          	li	a5,1
    80002990:	02a7f863          	bgeu	a5,a0,800029c0 <_Z9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80002994:	00a00793          	li	a5,10
    80002998:	02f577b3          	remu	a5,a0,a5
    8000299c:	02078e63          	beqz	a5,800029d8 <_Z9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    800029a0:	fff48513          	addi	a0,s1,-1
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	fcc080e7          	jalr	-52(ra) # 80002970 <_Z9fibonaccim>
    800029ac:	00050913          	mv	s2,a0
    800029b0:	ffe48513          	addi	a0,s1,-2
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	fbc080e7          	jalr	-68(ra) # 80002970 <_Z9fibonaccim>
    800029bc:	00a90533          	add	a0,s2,a0
}
    800029c0:	01813083          	ld	ra,24(sp)
    800029c4:	01013403          	ld	s0,16(sp)
    800029c8:	00813483          	ld	s1,8(sp)
    800029cc:	00013903          	ld	s2,0(sp)
    800029d0:	02010113          	addi	sp,sp,32
    800029d4:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    800029d8:	fffff097          	auipc	ra,0xfffff
    800029dc:	b04080e7          	jalr	-1276(ra) # 800014dc <_Z15thread_dispatchv>
    800029e0:	fc1ff06f          	j	800029a0 <_Z9fibonaccim+0x30>

00000000800029e4 <_ZN7WorkerA11workerBodyAEPv>:

    void run() override {
        workerBodyD(nullptr);
    }
};
void WorkerA::workerBodyA(void *arg) {
    800029e4:	fe010113          	addi	sp,sp,-32
    800029e8:	00113c23          	sd	ra,24(sp)
    800029ec:	00813823          	sd	s0,16(sp)
    800029f0:	00913423          	sd	s1,8(sp)
    800029f4:	01213023          	sd	s2,0(sp)
    800029f8:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    800029fc:	00000913          	li	s2,0
    80002a00:	0380006f          	j	80002a38 <_ZN7WorkerA11workerBodyAEPv+0x54>
        printString("A: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { }
            thread_dispatch();
    80002a04:	fffff097          	auipc	ra,0xfffff
    80002a08:	ad8080e7          	jalr	-1320(ra) # 800014dc <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80002a0c:	00148493          	addi	s1,s1,1
    80002a10:	000027b7          	lui	a5,0x2
    80002a14:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80002a18:	0097ee63          	bltu	a5,s1,80002a34 <_ZN7WorkerA11workerBodyAEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { }
    80002a1c:	00000713          	li	a4,0
    80002a20:	000077b7          	lui	a5,0x7
    80002a24:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80002a28:	fce7eee3          	bltu	a5,a4,80002a04 <_ZN7WorkerA11workerBodyAEPv+0x20>
    80002a2c:	00170713          	addi	a4,a4,1
    80002a30:	ff1ff06f          	j	80002a20 <_ZN7WorkerA11workerBodyAEPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80002a34:	00190913          	addi	s2,s2,1
    80002a38:	00900793          	li	a5,9
    80002a3c:	0527e063          	bltu	a5,s2,80002a7c <_ZN7WorkerA11workerBodyAEPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    80002a40:	00005517          	auipc	a0,0x5
    80002a44:	60850513          	addi	a0,a0,1544 # 80008048 <CONSOLE_STATUS+0x38>
    80002a48:	00000097          	auipc	ra,0x0
    80002a4c:	904080e7          	jalr	-1788(ra) # 8000234c <_Z11printStringPKc>
    80002a50:	00000613          	li	a2,0
    80002a54:	00a00593          	li	a1,10
    80002a58:	0009051b          	sext.w	a0,s2
    80002a5c:	00000097          	auipc	ra,0x0
    80002a60:	a88080e7          	jalr	-1400(ra) # 800024e4 <_Z8printIntiii>
    80002a64:	00005517          	auipc	a0,0x5
    80002a68:	72450513          	addi	a0,a0,1828 # 80008188 <CONSOLE_STATUS+0x178>
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	8e0080e7          	jalr	-1824(ra) # 8000234c <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80002a74:	00000493          	li	s1,0
    80002a78:	f99ff06f          	j	80002a10 <_ZN7WorkerA11workerBodyAEPv+0x2c>
        }
    }
    printString("A finished!\n");
    80002a7c:	00005517          	auipc	a0,0x5
    80002a80:	5d450513          	addi	a0,a0,1492 # 80008050 <CONSOLE_STATUS+0x40>
    80002a84:	00000097          	auipc	ra,0x0
    80002a88:	8c8080e7          	jalr	-1848(ra) # 8000234c <_Z11printStringPKc>
    finishedA = true;
    80002a8c:	00100793          	li	a5,1
    80002a90:	00008717          	auipc	a4,0x8
    80002a94:	eef70423          	sb	a5,-280(a4) # 8000a978 <finishedA>
}
    80002a98:	01813083          	ld	ra,24(sp)
    80002a9c:	01013403          	ld	s0,16(sp)
    80002aa0:	00813483          	ld	s1,8(sp)
    80002aa4:	00013903          	ld	s2,0(sp)
    80002aa8:	02010113          	addi	sp,sp,32
    80002aac:	00008067          	ret

0000000080002ab0 <_ZN7WorkerB11workerBodyBEPv>:

void WorkerB::workerBodyB(void *arg) {
    80002ab0:	fe010113          	addi	sp,sp,-32
    80002ab4:	00113c23          	sd	ra,24(sp)
    80002ab8:	00813823          	sd	s0,16(sp)
    80002abc:	00913423          	sd	s1,8(sp)
    80002ac0:	01213023          	sd	s2,0(sp)
    80002ac4:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    80002ac8:	00000913          	li	s2,0
    80002acc:	0380006f          	j	80002b04 <_ZN7WorkerB11workerBodyBEPv+0x54>
        printString("B: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) {  }
            thread_dispatch();
    80002ad0:	fffff097          	auipc	ra,0xfffff
    80002ad4:	a0c080e7          	jalr	-1524(ra) # 800014dc <_Z15thread_dispatchv>
        for (uint64 j = 0; j < 10000; j++) {
    80002ad8:	00148493          	addi	s1,s1,1
    80002adc:	000027b7          	lui	a5,0x2
    80002ae0:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80002ae4:	0097ee63          	bltu	a5,s1,80002b00 <_ZN7WorkerB11workerBodyBEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) {  }
    80002ae8:	00000713          	li	a4,0
    80002aec:	000077b7          	lui	a5,0x7
    80002af0:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80002af4:	fce7eee3          	bltu	a5,a4,80002ad0 <_ZN7WorkerB11workerBodyBEPv+0x20>
    80002af8:	00170713          	addi	a4,a4,1
    80002afc:	ff1ff06f          	j	80002aec <_ZN7WorkerB11workerBodyBEPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    80002b00:	00190913          	addi	s2,s2,1
    80002b04:	00f00793          	li	a5,15
    80002b08:	0527e063          	bltu	a5,s2,80002b48 <_ZN7WorkerB11workerBodyBEPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    80002b0c:	00005517          	auipc	a0,0x5
    80002b10:	55450513          	addi	a0,a0,1364 # 80008060 <CONSOLE_STATUS+0x50>
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	838080e7          	jalr	-1992(ra) # 8000234c <_Z11printStringPKc>
    80002b1c:	00000613          	li	a2,0
    80002b20:	00a00593          	li	a1,10
    80002b24:	0009051b          	sext.w	a0,s2
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	9bc080e7          	jalr	-1604(ra) # 800024e4 <_Z8printIntiii>
    80002b30:	00005517          	auipc	a0,0x5
    80002b34:	65850513          	addi	a0,a0,1624 # 80008188 <CONSOLE_STATUS+0x178>
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	814080e7          	jalr	-2028(ra) # 8000234c <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80002b40:	00000493          	li	s1,0
    80002b44:	f99ff06f          	j	80002adc <_ZN7WorkerB11workerBodyBEPv+0x2c>
        }
    }
    printString("B finished!\n");
    80002b48:	00005517          	auipc	a0,0x5
    80002b4c:	52050513          	addi	a0,a0,1312 # 80008068 <CONSOLE_STATUS+0x58>
    80002b50:	fffff097          	auipc	ra,0xfffff
    80002b54:	7fc080e7          	jalr	2044(ra) # 8000234c <_Z11printStringPKc>
    finishedB = true;
    80002b58:	00100793          	li	a5,1
    80002b5c:	00008717          	auipc	a4,0x8
    80002b60:	e0f70ea3          	sb	a5,-483(a4) # 8000a979 <finishedB>
    thread_dispatch();
    80002b64:	fffff097          	auipc	ra,0xfffff
    80002b68:	978080e7          	jalr	-1672(ra) # 800014dc <_Z15thread_dispatchv>
}
    80002b6c:	01813083          	ld	ra,24(sp)
    80002b70:	01013403          	ld	s0,16(sp)
    80002b74:	00813483          	ld	s1,8(sp)
    80002b78:	00013903          	ld	s2,0(sp)
    80002b7c:	02010113          	addi	sp,sp,32
    80002b80:	00008067          	ret

0000000080002b84 <_ZN7WorkerC11workerBodyCEPv>:

void WorkerC::workerBodyC(void *arg) {
    80002b84:	fe010113          	addi	sp,sp,-32
    80002b88:	00113c23          	sd	ra,24(sp)
    80002b8c:	00813823          	sd	s0,16(sp)
    80002b90:	00913423          	sd	s1,8(sp)
    80002b94:	01213023          	sd	s2,0(sp)
    80002b98:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80002b9c:	00000493          	li	s1,0
    80002ba0:	0400006f          	j	80002be0 <_ZN7WorkerC11workerBodyCEPv+0x5c>
    for (; i < 3; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80002ba4:	00005517          	auipc	a0,0x5
    80002ba8:	4d450513          	addi	a0,a0,1236 # 80008078 <CONSOLE_STATUS+0x68>
    80002bac:	fffff097          	auipc	ra,0xfffff
    80002bb0:	7a0080e7          	jalr	1952(ra) # 8000234c <_Z11printStringPKc>
    80002bb4:	00000613          	li	a2,0
    80002bb8:	00a00593          	li	a1,10
    80002bbc:	00048513          	mv	a0,s1
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	924080e7          	jalr	-1756(ra) # 800024e4 <_Z8printIntiii>
    80002bc8:	00005517          	auipc	a0,0x5
    80002bcc:	5c050513          	addi	a0,a0,1472 # 80008188 <CONSOLE_STATUS+0x178>
    80002bd0:	fffff097          	auipc	ra,0xfffff
    80002bd4:	77c080e7          	jalr	1916(ra) # 8000234c <_Z11printStringPKc>
    for (; i < 3; i++) {
    80002bd8:	0014849b          	addiw	s1,s1,1
    80002bdc:	0ff4f493          	andi	s1,s1,255
    80002be0:	00200793          	li	a5,2
    80002be4:	fc97f0e3          	bgeu	a5,s1,80002ba4 <_ZN7WorkerC11workerBodyCEPv+0x20>
    }

    printString("C: dispatch\n");
    80002be8:	00005517          	auipc	a0,0x5
    80002bec:	49850513          	addi	a0,a0,1176 # 80008080 <CONSOLE_STATUS+0x70>
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	75c080e7          	jalr	1884(ra) # 8000234c <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80002bf8:	00700313          	li	t1,7
    thread_dispatch();
    80002bfc:	fffff097          	auipc	ra,0xfffff
    80002c00:	8e0080e7          	jalr	-1824(ra) # 800014dc <_Z15thread_dispatchv>

    uint64 t1 = 0;
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80002c04:	00030913          	mv	s2,t1

    printString("C: t1="); printInt(t1); printString("\n");
    80002c08:	00005517          	auipc	a0,0x5
    80002c0c:	48850513          	addi	a0,a0,1160 # 80008090 <CONSOLE_STATUS+0x80>
    80002c10:	fffff097          	auipc	ra,0xfffff
    80002c14:	73c080e7          	jalr	1852(ra) # 8000234c <_Z11printStringPKc>
    80002c18:	00000613          	li	a2,0
    80002c1c:	00a00593          	li	a1,10
    80002c20:	0009051b          	sext.w	a0,s2
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	8c0080e7          	jalr	-1856(ra) # 800024e4 <_Z8printIntiii>
    80002c2c:	00005517          	auipc	a0,0x5
    80002c30:	55c50513          	addi	a0,a0,1372 # 80008188 <CONSOLE_STATUS+0x178>
    80002c34:	fffff097          	auipc	ra,0xfffff
    80002c38:	718080e7          	jalr	1816(ra) # 8000234c <_Z11printStringPKc>

    uint64 result = fibonacci(12);
    80002c3c:	00c00513          	li	a0,12
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	d30080e7          	jalr	-720(ra) # 80002970 <_Z9fibonaccim>
    80002c48:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80002c4c:	00005517          	auipc	a0,0x5
    80002c50:	44c50513          	addi	a0,a0,1100 # 80008098 <CONSOLE_STATUS+0x88>
    80002c54:	fffff097          	auipc	ra,0xfffff
    80002c58:	6f8080e7          	jalr	1784(ra) # 8000234c <_Z11printStringPKc>
    80002c5c:	00000613          	li	a2,0
    80002c60:	00a00593          	li	a1,10
    80002c64:	0009051b          	sext.w	a0,s2
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	87c080e7          	jalr	-1924(ra) # 800024e4 <_Z8printIntiii>
    80002c70:	00005517          	auipc	a0,0x5
    80002c74:	51850513          	addi	a0,a0,1304 # 80008188 <CONSOLE_STATUS+0x178>
    80002c78:	fffff097          	auipc	ra,0xfffff
    80002c7c:	6d4080e7          	jalr	1748(ra) # 8000234c <_Z11printStringPKc>
    80002c80:	0400006f          	j	80002cc0 <_ZN7WorkerC11workerBodyCEPv+0x13c>

    for (; i < 6; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80002c84:	00005517          	auipc	a0,0x5
    80002c88:	3f450513          	addi	a0,a0,1012 # 80008078 <CONSOLE_STATUS+0x68>
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	6c0080e7          	jalr	1728(ra) # 8000234c <_Z11printStringPKc>
    80002c94:	00000613          	li	a2,0
    80002c98:	00a00593          	li	a1,10
    80002c9c:	00048513          	mv	a0,s1
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	844080e7          	jalr	-1980(ra) # 800024e4 <_Z8printIntiii>
    80002ca8:	00005517          	auipc	a0,0x5
    80002cac:	4e050513          	addi	a0,a0,1248 # 80008188 <CONSOLE_STATUS+0x178>
    80002cb0:	fffff097          	auipc	ra,0xfffff
    80002cb4:	69c080e7          	jalr	1692(ra) # 8000234c <_Z11printStringPKc>
    for (; i < 6; i++) {
    80002cb8:	0014849b          	addiw	s1,s1,1
    80002cbc:	0ff4f493          	andi	s1,s1,255
    80002cc0:	00500793          	li	a5,5
    80002cc4:	fc97f0e3          	bgeu	a5,s1,80002c84 <_ZN7WorkerC11workerBodyCEPv+0x100>
    }

    printString("C finished!\n");
    80002cc8:	00005517          	auipc	a0,0x5
    80002ccc:	3e050513          	addi	a0,a0,992 # 800080a8 <CONSOLE_STATUS+0x98>
    80002cd0:	fffff097          	auipc	ra,0xfffff
    80002cd4:	67c080e7          	jalr	1660(ra) # 8000234c <_Z11printStringPKc>
    finishedC = true;
    80002cd8:	00100793          	li	a5,1
    80002cdc:	00008717          	auipc	a4,0x8
    80002ce0:	c8f70f23          	sb	a5,-866(a4) # 8000a97a <finishedC>
    thread_dispatch();
    80002ce4:	ffffe097          	auipc	ra,0xffffe
    80002ce8:	7f8080e7          	jalr	2040(ra) # 800014dc <_Z15thread_dispatchv>
}
    80002cec:	01813083          	ld	ra,24(sp)
    80002cf0:	01013403          	ld	s0,16(sp)
    80002cf4:	00813483          	ld	s1,8(sp)
    80002cf8:	00013903          	ld	s2,0(sp)
    80002cfc:	02010113          	addi	sp,sp,32
    80002d00:	00008067          	ret

0000000080002d04 <_ZN7WorkerD11workerBodyDEPv>:

void WorkerD::workerBodyD(void* arg) {
    80002d04:	fe010113          	addi	sp,sp,-32
    80002d08:	00113c23          	sd	ra,24(sp)
    80002d0c:	00813823          	sd	s0,16(sp)
    80002d10:	00913423          	sd	s1,8(sp)
    80002d14:	01213023          	sd	s2,0(sp)
    80002d18:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    80002d1c:	00a00493          	li	s1,10
    80002d20:	0400006f          	j	80002d60 <_ZN7WorkerD11workerBodyDEPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80002d24:	00005517          	auipc	a0,0x5
    80002d28:	39450513          	addi	a0,a0,916 # 800080b8 <CONSOLE_STATUS+0xa8>
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	620080e7          	jalr	1568(ra) # 8000234c <_Z11printStringPKc>
    80002d34:	00000613          	li	a2,0
    80002d38:	00a00593          	li	a1,10
    80002d3c:	00048513          	mv	a0,s1
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	7a4080e7          	jalr	1956(ra) # 800024e4 <_Z8printIntiii>
    80002d48:	00005517          	auipc	a0,0x5
    80002d4c:	44050513          	addi	a0,a0,1088 # 80008188 <CONSOLE_STATUS+0x178>
    80002d50:	fffff097          	auipc	ra,0xfffff
    80002d54:	5fc080e7          	jalr	1532(ra) # 8000234c <_Z11printStringPKc>
    for (; i < 13; i++) {
    80002d58:	0014849b          	addiw	s1,s1,1
    80002d5c:	0ff4f493          	andi	s1,s1,255
    80002d60:	00c00793          	li	a5,12
    80002d64:	fc97f0e3          	bgeu	a5,s1,80002d24 <_ZN7WorkerD11workerBodyDEPv+0x20>
    }

    printString("D: dispatch\n");
    80002d68:	00005517          	auipc	a0,0x5
    80002d6c:	35850513          	addi	a0,a0,856 # 800080c0 <CONSOLE_STATUS+0xb0>
    80002d70:	fffff097          	auipc	ra,0xfffff
    80002d74:	5dc080e7          	jalr	1500(ra) # 8000234c <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    80002d78:	00500313          	li	t1,5
    thread_dispatch();
    80002d7c:	ffffe097          	auipc	ra,0xffffe
    80002d80:	760080e7          	jalr	1888(ra) # 800014dc <_Z15thread_dispatchv>

    uint64 result = fibonacci(16);
    80002d84:	01000513          	li	a0,16
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	be8080e7          	jalr	-1048(ra) # 80002970 <_Z9fibonaccim>
    80002d90:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80002d94:	00005517          	auipc	a0,0x5
    80002d98:	33c50513          	addi	a0,a0,828 # 800080d0 <CONSOLE_STATUS+0xc0>
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	5b0080e7          	jalr	1456(ra) # 8000234c <_Z11printStringPKc>
    80002da4:	00000613          	li	a2,0
    80002da8:	00a00593          	li	a1,10
    80002dac:	0009051b          	sext.w	a0,s2
    80002db0:	fffff097          	auipc	ra,0xfffff
    80002db4:	734080e7          	jalr	1844(ra) # 800024e4 <_Z8printIntiii>
    80002db8:	00005517          	auipc	a0,0x5
    80002dbc:	3d050513          	addi	a0,a0,976 # 80008188 <CONSOLE_STATUS+0x178>
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	58c080e7          	jalr	1420(ra) # 8000234c <_Z11printStringPKc>
    80002dc8:	0400006f          	j	80002e08 <_ZN7WorkerD11workerBodyDEPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80002dcc:	00005517          	auipc	a0,0x5
    80002dd0:	2ec50513          	addi	a0,a0,748 # 800080b8 <CONSOLE_STATUS+0xa8>
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	578080e7          	jalr	1400(ra) # 8000234c <_Z11printStringPKc>
    80002ddc:	00000613          	li	a2,0
    80002de0:	00a00593          	li	a1,10
    80002de4:	00048513          	mv	a0,s1
    80002de8:	fffff097          	auipc	ra,0xfffff
    80002dec:	6fc080e7          	jalr	1788(ra) # 800024e4 <_Z8printIntiii>
    80002df0:	00005517          	auipc	a0,0x5
    80002df4:	39850513          	addi	a0,a0,920 # 80008188 <CONSOLE_STATUS+0x178>
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	554080e7          	jalr	1364(ra) # 8000234c <_Z11printStringPKc>
    for (; i < 16; i++) {
    80002e00:	0014849b          	addiw	s1,s1,1
    80002e04:	0ff4f493          	andi	s1,s1,255
    80002e08:	00f00793          	li	a5,15
    80002e0c:	fc97f0e3          	bgeu	a5,s1,80002dcc <_ZN7WorkerD11workerBodyDEPv+0xc8>
    }

    printString("D finished!\n");
    80002e10:	00005517          	auipc	a0,0x5
    80002e14:	2d050513          	addi	a0,a0,720 # 800080e0 <CONSOLE_STATUS+0xd0>
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	534080e7          	jalr	1332(ra) # 8000234c <_Z11printStringPKc>
    finishedD = true;
    80002e20:	00100793          	li	a5,1
    80002e24:	00008717          	auipc	a4,0x8
    80002e28:	b4f70ba3          	sb	a5,-1193(a4) # 8000a97b <finishedD>
    thread_dispatch();
    80002e2c:	ffffe097          	auipc	ra,0xffffe
    80002e30:	6b0080e7          	jalr	1712(ra) # 800014dc <_Z15thread_dispatchv>
}
    80002e34:	01813083          	ld	ra,24(sp)
    80002e38:	01013403          	ld	s0,16(sp)
    80002e3c:	00813483          	ld	s1,8(sp)
    80002e40:	00013903          	ld	s2,0(sp)
    80002e44:	02010113          	addi	sp,sp,32
    80002e48:	00008067          	ret

0000000080002e4c <_Z20Threads_CPP_API_testv>:


void Threads_CPP_API_test() {
    80002e4c:	fc010113          	addi	sp,sp,-64
    80002e50:	02113c23          	sd	ra,56(sp)
    80002e54:	02813823          	sd	s0,48(sp)
    80002e58:	02913423          	sd	s1,40(sp)
    80002e5c:	03213023          	sd	s2,32(sp)
    80002e60:	04010413          	addi	s0,sp,64
    Thread* threads[4];

    threads[0] = new WorkerA();
    80002e64:	01000513          	li	a0,16
    80002e68:	00001097          	auipc	ra,0x1
    80002e6c:	268080e7          	jalr	616(ra) # 800040d0 <_Znwm>
    80002e70:	00050493          	mv	s1,a0
    WorkerA():Thread() {}
    80002e74:	00001097          	auipc	ra,0x1
    80002e78:	4b0080e7          	jalr	1200(ra) # 80004324 <_ZN6ThreadC1Ev>
    80002e7c:	00007797          	auipc	a5,0x7
    80002e80:	55478793          	addi	a5,a5,1364 # 8000a3d0 <_ZTV7WorkerA+0x10>
    80002e84:	00f4b023          	sd	a5,0(s1)
    threads[0] = new WorkerA();
    80002e88:	fc943023          	sd	s1,-64(s0)
    printString("ThreadA created\n");
    80002e8c:	00005517          	auipc	a0,0x5
    80002e90:	26450513          	addi	a0,a0,612 # 800080f0 <CONSOLE_STATUS+0xe0>
    80002e94:	fffff097          	auipc	ra,0xfffff
    80002e98:	4b8080e7          	jalr	1208(ra) # 8000234c <_Z11printStringPKc>

    threads[1] = new WorkerB();
    80002e9c:	01000513          	li	a0,16
    80002ea0:	00001097          	auipc	ra,0x1
    80002ea4:	230080e7          	jalr	560(ra) # 800040d0 <_Znwm>
    80002ea8:	00050493          	mv	s1,a0
    WorkerB():Thread() {}
    80002eac:	00001097          	auipc	ra,0x1
    80002eb0:	478080e7          	jalr	1144(ra) # 80004324 <_ZN6ThreadC1Ev>
    80002eb4:	00007797          	auipc	a5,0x7
    80002eb8:	54478793          	addi	a5,a5,1348 # 8000a3f8 <_ZTV7WorkerB+0x10>
    80002ebc:	00f4b023          	sd	a5,0(s1)
    threads[1] = new WorkerB();
    80002ec0:	fc943423          	sd	s1,-56(s0)
    printString("ThreadB created\n");
    80002ec4:	00005517          	auipc	a0,0x5
    80002ec8:	24450513          	addi	a0,a0,580 # 80008108 <CONSOLE_STATUS+0xf8>
    80002ecc:	fffff097          	auipc	ra,0xfffff
    80002ed0:	480080e7          	jalr	1152(ra) # 8000234c <_Z11printStringPKc>

    threads[2] = new WorkerC();
    80002ed4:	01000513          	li	a0,16
    80002ed8:	00001097          	auipc	ra,0x1
    80002edc:	1f8080e7          	jalr	504(ra) # 800040d0 <_Znwm>
    80002ee0:	00050493          	mv	s1,a0
    WorkerC():Thread() {}
    80002ee4:	00001097          	auipc	ra,0x1
    80002ee8:	440080e7          	jalr	1088(ra) # 80004324 <_ZN6ThreadC1Ev>
    80002eec:	00007797          	auipc	a5,0x7
    80002ef0:	53478793          	addi	a5,a5,1332 # 8000a420 <_ZTV7WorkerC+0x10>
    80002ef4:	00f4b023          	sd	a5,0(s1)
    threads[2] = new WorkerC();
    80002ef8:	fc943823          	sd	s1,-48(s0)
    printString("ThreadC created\n");
    80002efc:	00005517          	auipc	a0,0x5
    80002f00:	22450513          	addi	a0,a0,548 # 80008120 <CONSOLE_STATUS+0x110>
    80002f04:	fffff097          	auipc	ra,0xfffff
    80002f08:	448080e7          	jalr	1096(ra) # 8000234c <_Z11printStringPKc>

    threads[3] = new WorkerD();
    80002f0c:	01000513          	li	a0,16
    80002f10:	00001097          	auipc	ra,0x1
    80002f14:	1c0080e7          	jalr	448(ra) # 800040d0 <_Znwm>
    80002f18:	00050493          	mv	s1,a0
    WorkerD():Thread() {}
    80002f1c:	00001097          	auipc	ra,0x1
    80002f20:	408080e7          	jalr	1032(ra) # 80004324 <_ZN6ThreadC1Ev>
    80002f24:	00007797          	auipc	a5,0x7
    80002f28:	52478793          	addi	a5,a5,1316 # 8000a448 <_ZTV7WorkerD+0x10>
    80002f2c:	00f4b023          	sd	a5,0(s1)
    threads[3] = new WorkerD();
    80002f30:	fc943c23          	sd	s1,-40(s0)
    printString("ThreadD created\n");
    80002f34:	00005517          	auipc	a0,0x5
    80002f38:	20450513          	addi	a0,a0,516 # 80008138 <CONSOLE_STATUS+0x128>
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	410080e7          	jalr	1040(ra) # 8000234c <_Z11printStringPKc>

    for(int i=0; i<4; i++) {
    80002f44:	00000493          	li	s1,0
    80002f48:	00300793          	li	a5,3
    80002f4c:	0297c663          	blt	a5,s1,80002f78 <_Z20Threads_CPP_API_testv+0x12c>
        threads[i]->start();
    80002f50:	00349793          	slli	a5,s1,0x3
    80002f54:	fe040713          	addi	a4,s0,-32
    80002f58:	00f707b3          	add	a5,a4,a5
    80002f5c:	fe07b503          	ld	a0,-32(a5)
    80002f60:	00001097          	auipc	ra,0x1
    80002f64:	320080e7          	jalr	800(ra) # 80004280 <_ZN6Thread5startEv>
    for(int i=0; i<4; i++) {
    80002f68:	0014849b          	addiw	s1,s1,1
    80002f6c:	fddff06f          	j	80002f48 <_Z20Threads_CPP_API_testv+0xfc>
    }

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        Thread::dispatch();
    80002f70:	00001097          	auipc	ra,0x1
    80002f74:	33c080e7          	jalr	828(ra) # 800042ac <_ZN6Thread8dispatchEv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80002f78:	00008797          	auipc	a5,0x8
    80002f7c:	a007c783          	lbu	a5,-1536(a5) # 8000a978 <finishedA>
    80002f80:	fe0788e3          	beqz	a5,80002f70 <_Z20Threads_CPP_API_testv+0x124>
    80002f84:	00008797          	auipc	a5,0x8
    80002f88:	9f57c783          	lbu	a5,-1547(a5) # 8000a979 <finishedB>
    80002f8c:	fe0782e3          	beqz	a5,80002f70 <_Z20Threads_CPP_API_testv+0x124>
    80002f90:	00008797          	auipc	a5,0x8
    80002f94:	9ea7c783          	lbu	a5,-1558(a5) # 8000a97a <finishedC>
    80002f98:	fc078ce3          	beqz	a5,80002f70 <_Z20Threads_CPP_API_testv+0x124>
    80002f9c:	00008797          	auipc	a5,0x8
    80002fa0:	9df7c783          	lbu	a5,-1569(a5) # 8000a97b <finishedD>
    80002fa4:	fc0786e3          	beqz	a5,80002f70 <_Z20Threads_CPP_API_testv+0x124>
    }

    for (auto thread: threads) { delete thread; }
    80002fa8:	fc040493          	addi	s1,s0,-64
    80002fac:	0080006f          	j	80002fb4 <_Z20Threads_CPP_API_testv+0x168>
    80002fb0:	00848493          	addi	s1,s1,8
    80002fb4:	fe040793          	addi	a5,s0,-32
    80002fb8:	08f48663          	beq	s1,a5,80003044 <_Z20Threads_CPP_API_testv+0x1f8>
    80002fbc:	0004b503          	ld	a0,0(s1)
    80002fc0:	fe0508e3          	beqz	a0,80002fb0 <_Z20Threads_CPP_API_testv+0x164>
    80002fc4:	00053783          	ld	a5,0(a0)
    80002fc8:	0087b783          	ld	a5,8(a5)
    80002fcc:	000780e7          	jalr	a5
    80002fd0:	fe1ff06f          	j	80002fb0 <_Z20Threads_CPP_API_testv+0x164>
    80002fd4:	00050913          	mv	s2,a0
    threads[0] = new WorkerA();
    80002fd8:	00048513          	mv	a0,s1
    80002fdc:	00001097          	auipc	ra,0x1
    80002fe0:	144080e7          	jalr	324(ra) # 80004120 <_ZdlPv>
    80002fe4:	00090513          	mv	a0,s2
    80002fe8:	00009097          	auipc	ra,0x9
    80002fec:	ab0080e7          	jalr	-1360(ra) # 8000ba98 <_Unwind_Resume>
    80002ff0:	00050913          	mv	s2,a0
    threads[1] = new WorkerB();
    80002ff4:	00048513          	mv	a0,s1
    80002ff8:	00001097          	auipc	ra,0x1
    80002ffc:	128080e7          	jalr	296(ra) # 80004120 <_ZdlPv>
    80003000:	00090513          	mv	a0,s2
    80003004:	00009097          	auipc	ra,0x9
    80003008:	a94080e7          	jalr	-1388(ra) # 8000ba98 <_Unwind_Resume>
    8000300c:	00050913          	mv	s2,a0
    threads[2] = new WorkerC();
    80003010:	00048513          	mv	a0,s1
    80003014:	00001097          	auipc	ra,0x1
    80003018:	10c080e7          	jalr	268(ra) # 80004120 <_ZdlPv>
    8000301c:	00090513          	mv	a0,s2
    80003020:	00009097          	auipc	ra,0x9
    80003024:	a78080e7          	jalr	-1416(ra) # 8000ba98 <_Unwind_Resume>
    80003028:	00050913          	mv	s2,a0
    threads[3] = new WorkerD();
    8000302c:	00048513          	mv	a0,s1
    80003030:	00001097          	auipc	ra,0x1
    80003034:	0f0080e7          	jalr	240(ra) # 80004120 <_ZdlPv>
    80003038:	00090513          	mv	a0,s2
    8000303c:	00009097          	auipc	ra,0x9
    80003040:	a5c080e7          	jalr	-1444(ra) # 8000ba98 <_Unwind_Resume>
}
    80003044:	03813083          	ld	ra,56(sp)
    80003048:	03013403          	ld	s0,48(sp)
    8000304c:	02813483          	ld	s1,40(sp)
    80003050:	02013903          	ld	s2,32(sp)
    80003054:	04010113          	addi	sp,sp,64
    80003058:	00008067          	ret

000000008000305c <_Z12testSleepingv>:

void testSleeping() {
    8000305c:	fc010113          	addi	sp,sp,-64
    80003060:	02113c23          	sd	ra,56(sp)
    80003064:	02813823          	sd	s0,48(sp)
    80003068:	02913423          	sd	s1,40(sp)
    8000306c:	04010413          	addi	s0,sp,64
    const int sleepy_thread_count = 2;
    time_t sleep_times[sleepy_thread_count] = {10, 20};
    80003070:	00a00793          	li	a5,10
    80003074:	fcf43823          	sd	a5,-48(s0)
    80003078:	01400793          	li	a5,20
    8000307c:	fcf43c23          	sd	a5,-40(s0)
    thread_t sleepyThread[sleepy_thread_count];

    for (int i = 0; i < sleepy_thread_count; i++) {
    80003080:	00000493          	li	s1,0
    80003084:	02c0006f          	j	800030b0 <_Z12testSleepingv+0x54>
        thread_create(&sleepyThread[i], sleepyRun, sleep_times + i);
    80003088:	00349793          	slli	a5,s1,0x3
    8000308c:	fd040613          	addi	a2,s0,-48
    80003090:	00f60633          	add	a2,a2,a5
    80003094:	fffff597          	auipc	a1,0xfffff
    80003098:	5e058593          	addi	a1,a1,1504 # 80002674 <_Z9sleepyRunPv>
    8000309c:	fc040513          	addi	a0,s0,-64
    800030a0:	00f50533          	add	a0,a0,a5
    800030a4:	ffffe097          	auipc	ra,0xffffe
    800030a8:	338080e7          	jalr	824(ra) # 800013dc <_Z13thread_createPP7_threadPFvPvES2_>
    for (int i = 0; i < sleepy_thread_count; i++) {
    800030ac:	0014849b          	addiw	s1,s1,1
    800030b0:	00100793          	li	a5,1
    800030b4:	fc97dae3          	bge	a5,s1,80003088 <_Z12testSleepingv+0x2c>
    }

    while (!(finished[0] && finished[1])) {}
    800030b8:	00008797          	auipc	a5,0x8
    800030bc:	8a87c783          	lbu	a5,-1880(a5) # 8000a960 <finished>
    800030c0:	fe078ce3          	beqz	a5,800030b8 <_Z12testSleepingv+0x5c>
    800030c4:	00008797          	auipc	a5,0x8
    800030c8:	89d7c783          	lbu	a5,-1891(a5) # 8000a961 <finished+0x1>
    800030cc:	fe0786e3          	beqz	a5,800030b8 <_Z12testSleepingv+0x5c>
}
    800030d0:	03813083          	ld	ra,56(sp)
    800030d4:	03013403          	ld	s0,48(sp)
    800030d8:	02813483          	ld	s1,40(sp)
    800030dc:	04010113          	addi	sp,sp,64
    800030e0:	00008067          	ret

00000000800030e4 <_ZN19ConsumerProducerCPP20testConsumerProducerEv>:

            td->sem->signal();
        }
    };

    void testConsumerProducer() {
    800030e4:	f8010113          	addi	sp,sp,-128
    800030e8:	06113c23          	sd	ra,120(sp)
    800030ec:	06813823          	sd	s0,112(sp)
    800030f0:	06913423          	sd	s1,104(sp)
    800030f4:	07213023          	sd	s2,96(sp)
    800030f8:	05313c23          	sd	s3,88(sp)
    800030fc:	05413823          	sd	s4,80(sp)
    80003100:	05513423          	sd	s5,72(sp)
    80003104:	05613023          	sd	s6,64(sp)
    80003108:	03713c23          	sd	s7,56(sp)
    8000310c:	03813823          	sd	s8,48(sp)
    80003110:	03913423          	sd	s9,40(sp)
    80003114:	08010413          	addi	s0,sp,128
        delete waitForAll;
        for (int i = 0; i < threadNum; i++) {
            delete producers[i];
        }
        delete consumer;
        delete buffer;
    80003118:	00010c13          	mv	s8,sp
        printString("Unesite broj proizvodjaca?\n");
    8000311c:	00005517          	auipc	a0,0x5
    80003120:	03450513          	addi	a0,a0,52 # 80008150 <CONSOLE_STATUS+0x140>
    80003124:	fffff097          	auipc	ra,0xfffff
    80003128:	228080e7          	jalr	552(ra) # 8000234c <_Z11printStringPKc>
        getString(input, 30);
    8000312c:	01e00593          	li	a1,30
    80003130:	f8040493          	addi	s1,s0,-128
    80003134:	00048513          	mv	a0,s1
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	290080e7          	jalr	656(ra) # 800023c8 <_Z9getStringPci>
        threadNum = stringToInt(input);
    80003140:	00048513          	mv	a0,s1
    80003144:	fffff097          	auipc	ra,0xfffff
    80003148:	350080e7          	jalr	848(ra) # 80002494 <_Z11stringToIntPKc>
    8000314c:	00050993          	mv	s3,a0
        printString("Unesite velicinu bafera?\n");
    80003150:	00005517          	auipc	a0,0x5
    80003154:	02050513          	addi	a0,a0,32 # 80008170 <CONSOLE_STATUS+0x160>
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	1f4080e7          	jalr	500(ra) # 8000234c <_Z11printStringPKc>
        getString(input, 30);
    80003160:	01e00593          	li	a1,30
    80003164:	00048513          	mv	a0,s1
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	260080e7          	jalr	608(ra) # 800023c8 <_Z9getStringPci>
        n = stringToInt(input);
    80003170:	00048513          	mv	a0,s1
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	320080e7          	jalr	800(ra) # 80002494 <_Z11stringToIntPKc>
    8000317c:	00050493          	mv	s1,a0
        printString("Broj proizvodjaca "); printInt(threadNum);
    80003180:	00005517          	auipc	a0,0x5
    80003184:	01050513          	addi	a0,a0,16 # 80008190 <CONSOLE_STATUS+0x180>
    80003188:	fffff097          	auipc	ra,0xfffff
    8000318c:	1c4080e7          	jalr	452(ra) # 8000234c <_Z11printStringPKc>
    80003190:	00000613          	li	a2,0
    80003194:	00a00593          	li	a1,10
    80003198:	00098513          	mv	a0,s3
    8000319c:	fffff097          	auipc	ra,0xfffff
    800031a0:	348080e7          	jalr	840(ra) # 800024e4 <_Z8printIntiii>
        printString(" i velicina bafera "); printInt(n);
    800031a4:	00005517          	auipc	a0,0x5
    800031a8:	00450513          	addi	a0,a0,4 # 800081a8 <CONSOLE_STATUS+0x198>
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	1a0080e7          	jalr	416(ra) # 8000234c <_Z11printStringPKc>
    800031b4:	00000613          	li	a2,0
    800031b8:	00a00593          	li	a1,10
    800031bc:	00048513          	mv	a0,s1
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	324080e7          	jalr	804(ra) # 800024e4 <_Z8printIntiii>
        printString(".\n");
    800031c8:	00005517          	auipc	a0,0x5
    800031cc:	ff850513          	addi	a0,a0,-8 # 800081c0 <CONSOLE_STATUS+0x1b0>
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	17c080e7          	jalr	380(ra) # 8000234c <_Z11printStringPKc>
        if(threadNum > n) {
    800031d8:	0334c463          	blt	s1,s3,80003200 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x11c>
        } else if (threadNum < 1) {
    800031dc:	03305c63          	blez	s3,80003214 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x130>
        BufferCPP *buffer = new BufferCPP(n);
    800031e0:	03800513          	li	a0,56
    800031e4:	00001097          	auipc	ra,0x1
    800031e8:	eec080e7          	jalr	-276(ra) # 800040d0 <_Znwm>
    800031ec:	00050a93          	mv	s5,a0
    800031f0:	00048593          	mv	a1,s1
    800031f4:	ffffe097          	auipc	ra,0xffffe
    800031f8:	7c4080e7          	jalr	1988(ra) # 800019b8 <_ZN9BufferCPPC1Ei>
    800031fc:	0300006f          	j	8000322c <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x148>
            printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    80003200:	00005517          	auipc	a0,0x5
    80003204:	fc850513          	addi	a0,a0,-56 # 800081c8 <CONSOLE_STATUS+0x1b8>
    80003208:	fffff097          	auipc	ra,0xfffff
    8000320c:	144080e7          	jalr	324(ra) # 8000234c <_Z11printStringPKc>
            return;
    80003210:	0140006f          	j	80003224 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x140>
            printString("Broj proizvodjaca mora biti veci od nula!\n");
    80003214:	00005517          	auipc	a0,0x5
    80003218:	ff450513          	addi	a0,a0,-12 # 80008208 <CONSOLE_STATUS+0x1f8>
    8000321c:	fffff097          	auipc	ra,0xfffff
    80003220:	130080e7          	jalr	304(ra) # 8000234c <_Z11printStringPKc>
            return;
    80003224:	000c0113          	mv	sp,s8
    80003228:	21c0006f          	j	80003444 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x360>
        waitForAll = new Semaphore(0);
    8000322c:	01000513          	li	a0,16
    80003230:	00001097          	auipc	ra,0x1
    80003234:	ea0080e7          	jalr	-352(ra) # 800040d0 <_Znwm>
    80003238:	00050493          	mv	s1,a0
    8000323c:	00000593          	li	a1,0
    80003240:	00001097          	auipc	ra,0x1
    80003244:	128080e7          	jalr	296(ra) # 80004368 <_ZN9SemaphoreC1Ej>
    80003248:	00007717          	auipc	a4,0x7
    8000324c:	71870713          	addi	a4,a4,1816 # 8000a960 <finished>
    80003250:	02973023          	sd	s1,32(a4)
        Thread *producers[threadNum];
    80003254:	00399793          	slli	a5,s3,0x3
    80003258:	00f78793          	addi	a5,a5,15
    8000325c:	ff07f793          	andi	a5,a5,-16
    80003260:	40f10133          	sub	sp,sp,a5
    80003264:	00010a13          	mv	s4,sp
        thread_data threadData[threadNum + 1];
    80003268:	0019869b          	addiw	a3,s3,1
    8000326c:	00169793          	slli	a5,a3,0x1
    80003270:	00d787b3          	add	a5,a5,a3
    80003274:	00379793          	slli	a5,a5,0x3
    80003278:	00f78793          	addi	a5,a5,15
    8000327c:	ff07f793          	andi	a5,a5,-16
    80003280:	40f10133          	sub	sp,sp,a5
    80003284:	00010b13          	mv	s6,sp
        threadData[threadNum].id = threadNum;
    80003288:	00199493          	slli	s1,s3,0x1
    8000328c:	013484b3          	add	s1,s1,s3
    80003290:	00349493          	slli	s1,s1,0x3
    80003294:	009b04b3          	add	s1,s6,s1
    80003298:	0134a023          	sw	s3,0(s1)
        threadData[threadNum].buffer = buffer;
    8000329c:	0154b423          	sd	s5,8(s1)
        threadData[threadNum].sem = waitForAll;
    800032a0:	02073783          	ld	a5,32(a4)
    800032a4:	00f4b823          	sd	a5,16(s1)
        Thread *consumer = new Consumer(&threadData[threadNum]);
    800032a8:	01800513          	li	a0,24
    800032ac:	00001097          	auipc	ra,0x1
    800032b0:	e24080e7          	jalr	-476(ra) # 800040d0 <_Znwm>
    800032b4:	00050b93          	mv	s7,a0
        Consumer(thread_data *_td) : Thread(), td(_td) {}
    800032b8:	00001097          	auipc	ra,0x1
    800032bc:	06c080e7          	jalr	108(ra) # 80004324 <_ZN6ThreadC1Ev>
    800032c0:	00007797          	auipc	a5,0x7
    800032c4:	20078793          	addi	a5,a5,512 # 8000a4c0 <_ZTVN19ConsumerProducerCPP8ConsumerE+0x10>
    800032c8:	00fbb023          	sd	a5,0(s7)
    800032cc:	009bb823          	sd	s1,16(s7)
        consumer->start();
    800032d0:	000b8513          	mv	a0,s7
    800032d4:	00001097          	auipc	ra,0x1
    800032d8:	fac080e7          	jalr	-84(ra) # 80004280 <_ZN6Thread5startEv>
        threadData[0].id = 0;
    800032dc:	000b2023          	sw	zero,0(s6)
        threadData[0].buffer = buffer;
    800032e0:	015b3423          	sd	s5,8(s6)
        threadData[0].sem = waitForAll;
    800032e4:	00007797          	auipc	a5,0x7
    800032e8:	69c7b783          	ld	a5,1692(a5) # 8000a980 <_ZN19ConsumerProducerCPP10waitForAllE>
    800032ec:	00fb3823          	sd	a5,16(s6)
        producers[0] = new ProducerKeyborad(&threadData[0]);
    800032f0:	01800513          	li	a0,24
    800032f4:	00001097          	auipc	ra,0x1
    800032f8:	ddc080e7          	jalr	-548(ra) # 800040d0 <_Znwm>
    800032fc:	00050493          	mv	s1,a0
        ProducerKeyborad(thread_data *_td) : Thread(), td(_td) {}
    80003300:	00001097          	auipc	ra,0x1
    80003304:	024080e7          	jalr	36(ra) # 80004324 <_ZN6ThreadC1Ev>
    80003308:	00007797          	auipc	a5,0x7
    8000330c:	16878793          	addi	a5,a5,360 # 8000a470 <_ZTVN19ConsumerProducerCPP16ProducerKeyboradE+0x10>
    80003310:	00f4b023          	sd	a5,0(s1)
    80003314:	0164b823          	sd	s6,16(s1)
        producers[0] = new ProducerKeyborad(&threadData[0]);
    80003318:	009a3023          	sd	s1,0(s4)
        producers[0]->start();
    8000331c:	00048513          	mv	a0,s1
    80003320:	00001097          	auipc	ra,0x1
    80003324:	f60080e7          	jalr	-160(ra) # 80004280 <_ZN6Thread5startEv>
        for (int i = 1; i < threadNum; i++) {
    80003328:	00100913          	li	s2,1
    8000332c:	0300006f          	j	8000335c <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x278>
        Producer(thread_data *_td) : Thread(), td(_td) {}
    80003330:	00007797          	auipc	a5,0x7
    80003334:	16878793          	addi	a5,a5,360 # 8000a498 <_ZTVN19ConsumerProducerCPP8ProducerE+0x10>
    80003338:	00fcb023          	sd	a5,0(s9)
    8000333c:	009cb823          	sd	s1,16(s9)
            producers[i] = new Producer(&threadData[i]);
    80003340:	00391793          	slli	a5,s2,0x3
    80003344:	00fa07b3          	add	a5,s4,a5
    80003348:	0197b023          	sd	s9,0(a5)
            producers[i]->start();
    8000334c:	000c8513          	mv	a0,s9
    80003350:	00001097          	auipc	ra,0x1
    80003354:	f30080e7          	jalr	-208(ra) # 80004280 <_ZN6Thread5startEv>
        for (int i = 1; i < threadNum; i++) {
    80003358:	0019091b          	addiw	s2,s2,1
    8000335c:	05395263          	bge	s2,s3,800033a0 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x2bc>
            threadData[i].id = i;
    80003360:	00191493          	slli	s1,s2,0x1
    80003364:	012484b3          	add	s1,s1,s2
    80003368:	00349493          	slli	s1,s1,0x3
    8000336c:	009b04b3          	add	s1,s6,s1
    80003370:	0124a023          	sw	s2,0(s1)
            threadData[i].buffer = buffer;
    80003374:	0154b423          	sd	s5,8(s1)
            threadData[i].sem = waitForAll;
    80003378:	00007797          	auipc	a5,0x7
    8000337c:	6087b783          	ld	a5,1544(a5) # 8000a980 <_ZN19ConsumerProducerCPP10waitForAllE>
    80003380:	00f4b823          	sd	a5,16(s1)
            producers[i] = new Producer(&threadData[i]);
    80003384:	01800513          	li	a0,24
    80003388:	00001097          	auipc	ra,0x1
    8000338c:	d48080e7          	jalr	-696(ra) # 800040d0 <_Znwm>
    80003390:	00050c93          	mv	s9,a0
        Producer(thread_data *_td) : Thread(), td(_td) {}
    80003394:	00001097          	auipc	ra,0x1
    80003398:	f90080e7          	jalr	-112(ra) # 80004324 <_ZN6ThreadC1Ev>
    8000339c:	f95ff06f          	j	80003330 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x24c>
        Thread::dispatch();
    800033a0:	00001097          	auipc	ra,0x1
    800033a4:	f0c080e7          	jalr	-244(ra) # 800042ac <_ZN6Thread8dispatchEv>
        for (int i = 0; i <= threadNum; i++) {
    800033a8:	00000493          	li	s1,0
    800033ac:	0099ce63          	blt	s3,s1,800033c8 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x2e4>
            waitForAll->wait();
    800033b0:	00007517          	auipc	a0,0x7
    800033b4:	5d053503          	ld	a0,1488(a0) # 8000a980 <_ZN19ConsumerProducerCPP10waitForAllE>
    800033b8:	00001097          	auipc	ra,0x1
    800033bc:	fe8080e7          	jalr	-24(ra) # 800043a0 <_ZN9Semaphore4waitEv>
        for (int i = 0; i <= threadNum; i++) {
    800033c0:	0014849b          	addiw	s1,s1,1
    800033c4:	fe9ff06f          	j	800033ac <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x2c8>
        delete waitForAll;
    800033c8:	00007517          	auipc	a0,0x7
    800033cc:	5b853503          	ld	a0,1464(a0) # 8000a980 <_ZN19ConsumerProducerCPP10waitForAllE>
    800033d0:	00050863          	beqz	a0,800033e0 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x2fc>
    800033d4:	00053783          	ld	a5,0(a0)
    800033d8:	0087b783          	ld	a5,8(a5)
    800033dc:	000780e7          	jalr	a5
        for (int i = 0; i <= threadNum; i++) {
    800033e0:	00000493          	li	s1,0
    800033e4:	0080006f          	j	800033ec <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x308>
        for (int i = 0; i < threadNum; i++) {
    800033e8:	0014849b          	addiw	s1,s1,1
    800033ec:	0334d263          	bge	s1,s3,80003410 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x32c>
            delete producers[i];
    800033f0:	00349793          	slli	a5,s1,0x3
    800033f4:	00fa07b3          	add	a5,s4,a5
    800033f8:	0007b503          	ld	a0,0(a5)
    800033fc:	fe0506e3          	beqz	a0,800033e8 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x304>
    80003400:	00053783          	ld	a5,0(a0)
    80003404:	0087b783          	ld	a5,8(a5)
    80003408:	000780e7          	jalr	a5
    8000340c:	fddff06f          	j	800033e8 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x304>
        delete consumer;
    80003410:	000b8a63          	beqz	s7,80003424 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x340>
    80003414:	000bb783          	ld	a5,0(s7)
    80003418:	0087b783          	ld	a5,8(a5)
    8000341c:	000b8513          	mv	a0,s7
    80003420:	000780e7          	jalr	a5
        delete buffer;
    80003424:	000a8e63          	beqz	s5,80003440 <_ZN19ConsumerProducerCPP20testConsumerProducerEv+0x35c>
    80003428:	000a8513          	mv	a0,s5
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	884080e7          	jalr	-1916(ra) # 80001cb0 <_ZN9BufferCPPD1Ev>
    80003434:	000a8513          	mv	a0,s5
    80003438:	00001097          	auipc	ra,0x1
    8000343c:	ce8080e7          	jalr	-792(ra) # 80004120 <_ZdlPv>
    80003440:	000c0113          	mv	sp,s8
    }
    80003444:	f8040113          	addi	sp,s0,-128
    80003448:	07813083          	ld	ra,120(sp)
    8000344c:	07013403          	ld	s0,112(sp)
    80003450:	06813483          	ld	s1,104(sp)
    80003454:	06013903          	ld	s2,96(sp)
    80003458:	05813983          	ld	s3,88(sp)
    8000345c:	05013a03          	ld	s4,80(sp)
    80003460:	04813a83          	ld	s5,72(sp)
    80003464:	04013b03          	ld	s6,64(sp)
    80003468:	03813b83          	ld	s7,56(sp)
    8000346c:	03013c03          	ld	s8,48(sp)
    80003470:	02813c83          	ld	s9,40(sp)
    80003474:	08010113          	addi	sp,sp,128
    80003478:	00008067          	ret
    8000347c:	00050493          	mv	s1,a0
        BufferCPP *buffer = new BufferCPP(n);
    80003480:	000a8513          	mv	a0,s5
    80003484:	00001097          	auipc	ra,0x1
    80003488:	c9c080e7          	jalr	-868(ra) # 80004120 <_ZdlPv>
    8000348c:	00048513          	mv	a0,s1
    80003490:	00008097          	auipc	ra,0x8
    80003494:	608080e7          	jalr	1544(ra) # 8000ba98 <_Unwind_Resume>
    80003498:	00050913          	mv	s2,a0
        waitForAll = new Semaphore(0);
    8000349c:	00048513          	mv	a0,s1
    800034a0:	00001097          	auipc	ra,0x1
    800034a4:	c80080e7          	jalr	-896(ra) # 80004120 <_ZdlPv>
    800034a8:	00090513          	mv	a0,s2
    800034ac:	00008097          	auipc	ra,0x8
    800034b0:	5ec080e7          	jalr	1516(ra) # 8000ba98 <_Unwind_Resume>
    800034b4:	00050493          	mv	s1,a0
        Thread *consumer = new Consumer(&threadData[threadNum]);
    800034b8:	000b8513          	mv	a0,s7
    800034bc:	00001097          	auipc	ra,0x1
    800034c0:	c64080e7          	jalr	-924(ra) # 80004120 <_ZdlPv>
    800034c4:	00048513          	mv	a0,s1
    800034c8:	00008097          	auipc	ra,0x8
    800034cc:	5d0080e7          	jalr	1488(ra) # 8000ba98 <_Unwind_Resume>
    800034d0:	00050913          	mv	s2,a0
        producers[0] = new ProducerKeyborad(&threadData[0]);
    800034d4:	00048513          	mv	a0,s1
    800034d8:	00001097          	auipc	ra,0x1
    800034dc:	c48080e7          	jalr	-952(ra) # 80004120 <_ZdlPv>
    800034e0:	00090513          	mv	a0,s2
    800034e4:	00008097          	auipc	ra,0x8
    800034e8:	5b4080e7          	jalr	1460(ra) # 8000ba98 <_Unwind_Resume>
    800034ec:	00050493          	mv	s1,a0
            producers[i] = new Producer(&threadData[i]);
    800034f0:	000c8513          	mv	a0,s9
    800034f4:	00001097          	auipc	ra,0x1
    800034f8:	c2c080e7          	jalr	-980(ra) # 80004120 <_ZdlPv>
    800034fc:	00048513          	mv	a0,s1
    80003500:	00008097          	auipc	ra,0x8
    80003504:	598080e7          	jalr	1432(ra) # 8000ba98 <_Unwind_Resume>

0000000080003508 <main>:

// funkcija main je u nadleznosti jezgra - jezgro ima kontrolu onda nad radnjama koje ce se izvrsiti pri pokretanju programa
// nakon toga, funkcija main treba da pokrene nit nad funkcijom userMain
void main() {
    80003508:	fc010113          	addi	sp,sp,-64
    8000350c:	02113c23          	sd	ra,56(sp)
    80003510:	02813823          	sd	s0,48(sp)
    80003514:	02913423          	sd	s1,40(sp)
    80003518:	04010413          	addi	s0,sp,64

    // upisivanje adrese prekidne rutine u registar stvec
    Riscv::writeStvec(reinterpret_cast<uint64>(&Riscv::supervisorTrap));
    8000351c:	00007797          	auipc	a5,0x7
    80003520:	0ec7b783          	ld	a5,236(a5) # 8000a608 <_GLOBAL_OFFSET_TABLE_+0x28>
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    return stvec;
}

inline void Riscv::writeStvec(uint64 stvec) {
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
    80003524:	10579073          	csrw	stvec,a5

    // kreiranje niti za main funkciju da bismo postavili pokazivac TCB::runningThread na nit main-a - tako ce moci da radi promena konteksta
    thread_t mainThreadHandle;
    thread_create(&mainThreadHandle, nullptr, nullptr);
    80003528:	00000613          	li	a2,0
    8000352c:	00000593          	li	a1,0
    80003530:	fd840513          	addi	a0,s0,-40
    80003534:	ffffe097          	auipc	ra,0xffffe
    80003538:	ea8080e7          	jalr	-344(ra) # 800013dc <_Z13thread_createPP7_threadPFvPvES2_>
    TCB::runningThread = (TCB*)(mainThreadHandle);
    8000353c:	00007797          	auipc	a5,0x7
    80003540:	0dc7b783          	ld	a5,220(a5) # 8000a618 <_GLOBAL_OFFSET_TABLE_+0x38>
    80003544:	fd843703          	ld	a4,-40(s0)
    80003548:	00e7b023          	sd	a4,0(a5)

    // kreiranje idle niti i ubacivanje nje u scheduler (ubacivanje niti u scheduler se radi u konstruktoru klase TCB (klase koja apstrahuje nit))
    // idle nit se nikada ne izbacuje iz schedulera i uvek ce biti na kraju schedulera
    thread_t idleThreadHandle;
    thread_create(&idleThreadHandle, &idleFunction, nullptr);
    8000354c:	00000613          	li	a2,0
    80003550:	00007597          	auipc	a1,0x7
    80003554:	0e85b583          	ld	a1,232(a1) # 8000a638 <_GLOBAL_OFFSET_TABLE_+0x58>
    80003558:	fd040513          	addi	a0,s0,-48
    8000355c:	ffffe097          	auipc	ra,0xffffe
    80003560:	e80080e7          	jalr	-384(ra) # 800013dc <_Z13thread_createPP7_threadPFvPvES2_>

    // kreiranje niti nad funkcijom userMain i ubacivanje nje u scheduler (ubacivanje niti u scheduler se radi u konstruktoru klase TCB)
    thread_t userMainThreadHandle;
    thread_create(&userMainThreadHandle, &userMain, nullptr);
    80003564:	00000613          	li	a2,0
    80003568:	fffff597          	auipc	a1,0xfffff
    8000356c:	1b058593          	addi	a1,a1,432 # 80002718 <_Z8userMainPv>
    80003570:	fc840513          	addi	a0,s0,-56
    80003574:	ffffe097          	auipc	ra,0xffffe
    80003578:	e68080e7          	jalr	-408(ra) # 800013dc <_Z13thread_createPP7_threadPFvPvES2_>

    thread_t putcKernelThread;
    thread_create(&putcKernelThread, &putcKernelThreadFunction, nullptr);
    8000357c:	00000613          	li	a2,0
    80003580:	00007597          	auipc	a1,0x7
    80003584:	0c05b583          	ld	a1,192(a1) # 8000a640 <_GLOBAL_OFFSET_TABLE_+0x60>
    80003588:	fc040513          	addi	a0,s0,-64
    8000358c:	ffffe097          	auipc	ra,0xffffe
    80003590:	e50080e7          	jalr	-432(ra) # 800013dc <_Z13thread_createPP7_threadPFvPvES2_>
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    80003594:	00200793          	li	a5,2
    80003598:	1007a073          	csrs	sstatus,a5
}
    8000359c:	00c0006f          	j	800035a8 <main+0xa0>
    // omogucujem spoljasnje prekide jer trenutno radimo sve u sistemskom rezimu, a tu su oni podrazumevano onemoguceni;
    // radicu u sistemskom rezimu sve dok ne dodjem do kraja projekta kad cu imati i semafore i ispis;
    Riscv::maskSetBitsSstatus(Riscv::SSTATUS_SIE);

    while (!((TCB*)userMainThreadHandle)->getFinished() || KernelBuffer::putcGetInstance()->getNumberOfElements() > 0) {
        thread_dispatch();
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	f3c080e7          	jalr	-196(ra) # 800014dc <_Z15thread_dispatchv>
    while (!((TCB*)userMainThreadHandle)->getFinished() || KernelBuffer::putcGetInstance()->getNumberOfElements() > 0) {
    800035a8:	fc843783          	ld	a5,-56(s0)
    bool getFinished() const { return finished; }
    800035ac:	0307c783          	lbu	a5,48(a5)
    800035b0:	fe0788e3          	beqz	a5,800035a0 <main+0x98>
    800035b4:	fffff097          	auipc	ra,0xfffff
    800035b8:	a34080e7          	jalr	-1484(ra) # 80001fe8 <_ZN12KernelBuffer15putcGetInstanceEv>
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	d08080e7          	jalr	-760(ra) # 800022c4 <_ZN12KernelBuffer19getNumberOfElementsEv>
    800035c4:	fca04ee3          	bgtz	a0,800035a0 <main+0x98>
    }

    // moram da dealociram bafer eksplicitno jer KernelBuffer::getInstance unutar sebe ne pravi staticki objekat klase, vec
    // dinamicki alocira na heap-u, sto znaci da se nece unistiti sam taj objekat kada se zavrsi main (upravo posto nije rec o
    // statickom objektu) i zato moramo mi ovde eksplicitno da ga unistimo
    delete KernelBuffer::getcGetInstance();
    800035c8:	fffff097          	auipc	ra,0xfffff
    800035cc:	aa0080e7          	jalr	-1376(ra) # 80002068 <_ZN12KernelBuffer15getcGetInstanceEv>
    800035d0:	00050493          	mv	s1,a0
    800035d4:	00050c63          	beqz	a0,800035ec <main+0xe4>
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	b10080e7          	jalr	-1264(ra) # 800020e8 <_ZN12KernelBufferD1Ev>
    800035e0:	00048513          	mv	a0,s1
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	8f8080e7          	jalr	-1800(ra) # 80001edc <_ZN12KernelBufferdlEPv>
    // ne brisem bafer za putc jer treba da se ispise Kernel Finished za sta treba taj bafer
    800035ec:	03813083          	ld	ra,56(sp)
    800035f0:	03013403          	ld	s0,48(sp)
    800035f4:	02813483          	ld	s1,40(sp)
    800035f8:	04010113          	addi	sp,sp,64
    800035fc:	00008067          	ret

0000000080003600 <_ZN7WorkerAD1Ev>:
class WorkerA: public Thread {
    80003600:	ff010113          	addi	sp,sp,-16
    80003604:	00113423          	sd	ra,8(sp)
    80003608:	00813023          	sd	s0,0(sp)
    8000360c:	01010413          	addi	s0,sp,16
    80003610:	00007797          	auipc	a5,0x7
    80003614:	dc078793          	addi	a5,a5,-576 # 8000a3d0 <_ZTV7WorkerA+0x10>
    80003618:	00f53023          	sd	a5,0(a0)
    8000361c:	00001097          	auipc	ra,0x1
    80003620:	b94080e7          	jalr	-1132(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003624:	00813083          	ld	ra,8(sp)
    80003628:	00013403          	ld	s0,0(sp)
    8000362c:	01010113          	addi	sp,sp,16
    80003630:	00008067          	ret

0000000080003634 <_ZN7WorkerAD0Ev>:
    80003634:	fe010113          	addi	sp,sp,-32
    80003638:	00113c23          	sd	ra,24(sp)
    8000363c:	00813823          	sd	s0,16(sp)
    80003640:	00913423          	sd	s1,8(sp)
    80003644:	02010413          	addi	s0,sp,32
    80003648:	00050493          	mv	s1,a0
    8000364c:	00007797          	auipc	a5,0x7
    80003650:	d8478793          	addi	a5,a5,-636 # 8000a3d0 <_ZTV7WorkerA+0x10>
    80003654:	00f53023          	sd	a5,0(a0)
    80003658:	00001097          	auipc	ra,0x1
    8000365c:	b58080e7          	jalr	-1192(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003660:	00048513          	mv	a0,s1
    80003664:	00001097          	auipc	ra,0x1
    80003668:	abc080e7          	jalr	-1348(ra) # 80004120 <_ZdlPv>
    8000366c:	01813083          	ld	ra,24(sp)
    80003670:	01013403          	ld	s0,16(sp)
    80003674:	00813483          	ld	s1,8(sp)
    80003678:	02010113          	addi	sp,sp,32
    8000367c:	00008067          	ret

0000000080003680 <_ZN7WorkerBD1Ev>:
class WorkerB: public Thread {
    80003680:	ff010113          	addi	sp,sp,-16
    80003684:	00113423          	sd	ra,8(sp)
    80003688:	00813023          	sd	s0,0(sp)
    8000368c:	01010413          	addi	s0,sp,16
    80003690:	00007797          	auipc	a5,0x7
    80003694:	d6878793          	addi	a5,a5,-664 # 8000a3f8 <_ZTV7WorkerB+0x10>
    80003698:	00f53023          	sd	a5,0(a0)
    8000369c:	00001097          	auipc	ra,0x1
    800036a0:	b14080e7          	jalr	-1260(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800036a4:	00813083          	ld	ra,8(sp)
    800036a8:	00013403          	ld	s0,0(sp)
    800036ac:	01010113          	addi	sp,sp,16
    800036b0:	00008067          	ret

00000000800036b4 <_ZN7WorkerBD0Ev>:
    800036b4:	fe010113          	addi	sp,sp,-32
    800036b8:	00113c23          	sd	ra,24(sp)
    800036bc:	00813823          	sd	s0,16(sp)
    800036c0:	00913423          	sd	s1,8(sp)
    800036c4:	02010413          	addi	s0,sp,32
    800036c8:	00050493          	mv	s1,a0
    800036cc:	00007797          	auipc	a5,0x7
    800036d0:	d2c78793          	addi	a5,a5,-724 # 8000a3f8 <_ZTV7WorkerB+0x10>
    800036d4:	00f53023          	sd	a5,0(a0)
    800036d8:	00001097          	auipc	ra,0x1
    800036dc:	ad8080e7          	jalr	-1320(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800036e0:	00048513          	mv	a0,s1
    800036e4:	00001097          	auipc	ra,0x1
    800036e8:	a3c080e7          	jalr	-1476(ra) # 80004120 <_ZdlPv>
    800036ec:	01813083          	ld	ra,24(sp)
    800036f0:	01013403          	ld	s0,16(sp)
    800036f4:	00813483          	ld	s1,8(sp)
    800036f8:	02010113          	addi	sp,sp,32
    800036fc:	00008067          	ret

0000000080003700 <_ZN7WorkerCD1Ev>:
class WorkerC: public Thread {
    80003700:	ff010113          	addi	sp,sp,-16
    80003704:	00113423          	sd	ra,8(sp)
    80003708:	00813023          	sd	s0,0(sp)
    8000370c:	01010413          	addi	s0,sp,16
    80003710:	00007797          	auipc	a5,0x7
    80003714:	d1078793          	addi	a5,a5,-752 # 8000a420 <_ZTV7WorkerC+0x10>
    80003718:	00f53023          	sd	a5,0(a0)
    8000371c:	00001097          	auipc	ra,0x1
    80003720:	a94080e7          	jalr	-1388(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003724:	00813083          	ld	ra,8(sp)
    80003728:	00013403          	ld	s0,0(sp)
    8000372c:	01010113          	addi	sp,sp,16
    80003730:	00008067          	ret

0000000080003734 <_ZN7WorkerCD0Ev>:
    80003734:	fe010113          	addi	sp,sp,-32
    80003738:	00113c23          	sd	ra,24(sp)
    8000373c:	00813823          	sd	s0,16(sp)
    80003740:	00913423          	sd	s1,8(sp)
    80003744:	02010413          	addi	s0,sp,32
    80003748:	00050493          	mv	s1,a0
    8000374c:	00007797          	auipc	a5,0x7
    80003750:	cd478793          	addi	a5,a5,-812 # 8000a420 <_ZTV7WorkerC+0x10>
    80003754:	00f53023          	sd	a5,0(a0)
    80003758:	00001097          	auipc	ra,0x1
    8000375c:	a58080e7          	jalr	-1448(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003760:	00048513          	mv	a0,s1
    80003764:	00001097          	auipc	ra,0x1
    80003768:	9bc080e7          	jalr	-1604(ra) # 80004120 <_ZdlPv>
    8000376c:	01813083          	ld	ra,24(sp)
    80003770:	01013403          	ld	s0,16(sp)
    80003774:	00813483          	ld	s1,8(sp)
    80003778:	02010113          	addi	sp,sp,32
    8000377c:	00008067          	ret

0000000080003780 <_ZN7WorkerDD1Ev>:
class WorkerD: public Thread {
    80003780:	ff010113          	addi	sp,sp,-16
    80003784:	00113423          	sd	ra,8(sp)
    80003788:	00813023          	sd	s0,0(sp)
    8000378c:	01010413          	addi	s0,sp,16
    80003790:	00007797          	auipc	a5,0x7
    80003794:	cb878793          	addi	a5,a5,-840 # 8000a448 <_ZTV7WorkerD+0x10>
    80003798:	00f53023          	sd	a5,0(a0)
    8000379c:	00001097          	auipc	ra,0x1
    800037a0:	a14080e7          	jalr	-1516(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800037a4:	00813083          	ld	ra,8(sp)
    800037a8:	00013403          	ld	s0,0(sp)
    800037ac:	01010113          	addi	sp,sp,16
    800037b0:	00008067          	ret

00000000800037b4 <_ZN7WorkerDD0Ev>:
    800037b4:	fe010113          	addi	sp,sp,-32
    800037b8:	00113c23          	sd	ra,24(sp)
    800037bc:	00813823          	sd	s0,16(sp)
    800037c0:	00913423          	sd	s1,8(sp)
    800037c4:	02010413          	addi	s0,sp,32
    800037c8:	00050493          	mv	s1,a0
    800037cc:	00007797          	auipc	a5,0x7
    800037d0:	c7c78793          	addi	a5,a5,-900 # 8000a448 <_ZTV7WorkerD+0x10>
    800037d4:	00f53023          	sd	a5,0(a0)
    800037d8:	00001097          	auipc	ra,0x1
    800037dc:	9d8080e7          	jalr	-1576(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800037e0:	00048513          	mv	a0,s1
    800037e4:	00001097          	auipc	ra,0x1
    800037e8:	93c080e7          	jalr	-1732(ra) # 80004120 <_ZdlPv>
    800037ec:	01813083          	ld	ra,24(sp)
    800037f0:	01013403          	ld	s0,16(sp)
    800037f4:	00813483          	ld	s1,8(sp)
    800037f8:	02010113          	addi	sp,sp,32
    800037fc:	00008067          	ret

0000000080003800 <_ZN19ConsumerProducerCPP8ConsumerD1Ev>:
    class Consumer : public Thread {
    80003800:	ff010113          	addi	sp,sp,-16
    80003804:	00113423          	sd	ra,8(sp)
    80003808:	00813023          	sd	s0,0(sp)
    8000380c:	01010413          	addi	s0,sp,16
    80003810:	00007797          	auipc	a5,0x7
    80003814:	cb078793          	addi	a5,a5,-848 # 8000a4c0 <_ZTVN19ConsumerProducerCPP8ConsumerE+0x10>
    80003818:	00f53023          	sd	a5,0(a0)
    8000381c:	00001097          	auipc	ra,0x1
    80003820:	994080e7          	jalr	-1644(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003824:	00813083          	ld	ra,8(sp)
    80003828:	00013403          	ld	s0,0(sp)
    8000382c:	01010113          	addi	sp,sp,16
    80003830:	00008067          	ret

0000000080003834 <_ZN19ConsumerProducerCPP8ConsumerD0Ev>:
    80003834:	fe010113          	addi	sp,sp,-32
    80003838:	00113c23          	sd	ra,24(sp)
    8000383c:	00813823          	sd	s0,16(sp)
    80003840:	00913423          	sd	s1,8(sp)
    80003844:	02010413          	addi	s0,sp,32
    80003848:	00050493          	mv	s1,a0
    8000384c:	00007797          	auipc	a5,0x7
    80003850:	c7478793          	addi	a5,a5,-908 # 8000a4c0 <_ZTVN19ConsumerProducerCPP8ConsumerE+0x10>
    80003854:	00f53023          	sd	a5,0(a0)
    80003858:	00001097          	auipc	ra,0x1
    8000385c:	958080e7          	jalr	-1704(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003860:	00048513          	mv	a0,s1
    80003864:	00001097          	auipc	ra,0x1
    80003868:	8bc080e7          	jalr	-1860(ra) # 80004120 <_ZdlPv>
    8000386c:	01813083          	ld	ra,24(sp)
    80003870:	01013403          	ld	s0,16(sp)
    80003874:	00813483          	ld	s1,8(sp)
    80003878:	02010113          	addi	sp,sp,32
    8000387c:	00008067          	ret

0000000080003880 <_ZN19ConsumerProducerCPP16ProducerKeyboradD1Ev>:
    class ProducerKeyborad : public Thread {
    80003880:	ff010113          	addi	sp,sp,-16
    80003884:	00113423          	sd	ra,8(sp)
    80003888:	00813023          	sd	s0,0(sp)
    8000388c:	01010413          	addi	s0,sp,16
    80003890:	00007797          	auipc	a5,0x7
    80003894:	be078793          	addi	a5,a5,-1056 # 8000a470 <_ZTVN19ConsumerProducerCPP16ProducerKeyboradE+0x10>
    80003898:	00f53023          	sd	a5,0(a0)
    8000389c:	00001097          	auipc	ra,0x1
    800038a0:	914080e7          	jalr	-1772(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800038a4:	00813083          	ld	ra,8(sp)
    800038a8:	00013403          	ld	s0,0(sp)
    800038ac:	01010113          	addi	sp,sp,16
    800038b0:	00008067          	ret

00000000800038b4 <_ZN19ConsumerProducerCPP16ProducerKeyboradD0Ev>:
    800038b4:	fe010113          	addi	sp,sp,-32
    800038b8:	00113c23          	sd	ra,24(sp)
    800038bc:	00813823          	sd	s0,16(sp)
    800038c0:	00913423          	sd	s1,8(sp)
    800038c4:	02010413          	addi	s0,sp,32
    800038c8:	00050493          	mv	s1,a0
    800038cc:	00007797          	auipc	a5,0x7
    800038d0:	ba478793          	addi	a5,a5,-1116 # 8000a470 <_ZTVN19ConsumerProducerCPP16ProducerKeyboradE+0x10>
    800038d4:	00f53023          	sd	a5,0(a0)
    800038d8:	00001097          	auipc	ra,0x1
    800038dc:	8d8080e7          	jalr	-1832(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800038e0:	00048513          	mv	a0,s1
    800038e4:	00001097          	auipc	ra,0x1
    800038e8:	83c080e7          	jalr	-1988(ra) # 80004120 <_ZdlPv>
    800038ec:	01813083          	ld	ra,24(sp)
    800038f0:	01013403          	ld	s0,16(sp)
    800038f4:	00813483          	ld	s1,8(sp)
    800038f8:	02010113          	addi	sp,sp,32
    800038fc:	00008067          	ret

0000000080003900 <_ZN19ConsumerProducerCPP8ProducerD1Ev>:
    class Producer : public Thread {
    80003900:	ff010113          	addi	sp,sp,-16
    80003904:	00113423          	sd	ra,8(sp)
    80003908:	00813023          	sd	s0,0(sp)
    8000390c:	01010413          	addi	s0,sp,16
    80003910:	00007797          	auipc	a5,0x7
    80003914:	b8878793          	addi	a5,a5,-1144 # 8000a498 <_ZTVN19ConsumerProducerCPP8ProducerE+0x10>
    80003918:	00f53023          	sd	a5,0(a0)
    8000391c:	00001097          	auipc	ra,0x1
    80003920:	894080e7          	jalr	-1900(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003924:	00813083          	ld	ra,8(sp)
    80003928:	00013403          	ld	s0,0(sp)
    8000392c:	01010113          	addi	sp,sp,16
    80003930:	00008067          	ret

0000000080003934 <_ZN19ConsumerProducerCPP8ProducerD0Ev>:
    80003934:	fe010113          	addi	sp,sp,-32
    80003938:	00113c23          	sd	ra,24(sp)
    8000393c:	00813823          	sd	s0,16(sp)
    80003940:	00913423          	sd	s1,8(sp)
    80003944:	02010413          	addi	s0,sp,32
    80003948:	00050493          	mv	s1,a0
    8000394c:	00007797          	auipc	a5,0x7
    80003950:	b4c78793          	addi	a5,a5,-1204 # 8000a498 <_ZTVN19ConsumerProducerCPP8ProducerE+0x10>
    80003954:	00f53023          	sd	a5,0(a0)
    80003958:	00001097          	auipc	ra,0x1
    8000395c:	858080e7          	jalr	-1960(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003960:	00048513          	mv	a0,s1
    80003964:	00000097          	auipc	ra,0x0
    80003968:	7bc080e7          	jalr	1980(ra) # 80004120 <_ZdlPv>
    8000396c:	01813083          	ld	ra,24(sp)
    80003970:	01013403          	ld	s0,16(sp)
    80003974:	00813483          	ld	s1,8(sp)
    80003978:	02010113          	addi	sp,sp,32
    8000397c:	00008067          	ret

0000000080003980 <_ZN1AD1Ev>:
class A : public PeriodicThread {
    80003980:	ff010113          	addi	sp,sp,-16
    80003984:	00113423          	sd	ra,8(sp)
    80003988:	00813023          	sd	s0,0(sp)
    8000398c:	01010413          	addi	s0,sp,16

private:
    sem_t myHandle;
};

class PeriodicThread : public Thread {
    80003990:	00007797          	auipc	a5,0x7
    80003994:	c707b783          	ld	a5,-912(a5) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x20>
    80003998:	01078793          	addi	a5,a5,16
    8000399c:	00f53023          	sd	a5,0(a0)
    800039a0:	00001097          	auipc	ra,0x1
    800039a4:	810080e7          	jalr	-2032(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800039a8:	00813083          	ld	ra,8(sp)
    800039ac:	00013403          	ld	s0,0(sp)
    800039b0:	01010113          	addi	sp,sp,16
    800039b4:	00008067          	ret

00000000800039b8 <_ZN1AD0Ev>:
    800039b8:	fe010113          	addi	sp,sp,-32
    800039bc:	00113c23          	sd	ra,24(sp)
    800039c0:	00813823          	sd	s0,16(sp)
    800039c4:	00913423          	sd	s1,8(sp)
    800039c8:	02010413          	addi	s0,sp,32
    800039cc:	00050493          	mv	s1,a0
    800039d0:	00007797          	auipc	a5,0x7
    800039d4:	c307b783          	ld	a5,-976(a5) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x20>
    800039d8:	01078793          	addi	a5,a5,16
    800039dc:	00f53023          	sd	a5,0(a0)
    800039e0:	00000097          	auipc	ra,0x0
    800039e4:	7d0080e7          	jalr	2000(ra) # 800041b0 <_ZN6ThreadD1Ev>
    800039e8:	00048513          	mv	a0,s1
    800039ec:	00000097          	auipc	ra,0x0
    800039f0:	734080e7          	jalr	1844(ra) # 80004120 <_ZdlPv>
    800039f4:	01813083          	ld	ra,24(sp)
    800039f8:	01013403          	ld	s0,16(sp)
    800039fc:	00813483          	ld	s1,8(sp)
    80003a00:	02010113          	addi	sp,sp,32
    80003a04:	00008067          	ret

0000000080003a08 <_ZN1BD1Ev>:
class B : public PeriodicThread {
    80003a08:	ff010113          	addi	sp,sp,-16
    80003a0c:	00113423          	sd	ra,8(sp)
    80003a10:	00813023          	sd	s0,0(sp)
    80003a14:	01010413          	addi	s0,sp,16
    80003a18:	00007797          	auipc	a5,0x7
    80003a1c:	be87b783          	ld	a5,-1048(a5) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x20>
    80003a20:	01078793          	addi	a5,a5,16
    80003a24:	00f53023          	sd	a5,0(a0)
    80003a28:	00000097          	auipc	ra,0x0
    80003a2c:	788080e7          	jalr	1928(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003a30:	00813083          	ld	ra,8(sp)
    80003a34:	00013403          	ld	s0,0(sp)
    80003a38:	01010113          	addi	sp,sp,16
    80003a3c:	00008067          	ret

0000000080003a40 <_ZN1BD0Ev>:
    80003a40:	fe010113          	addi	sp,sp,-32
    80003a44:	00113c23          	sd	ra,24(sp)
    80003a48:	00813823          	sd	s0,16(sp)
    80003a4c:	00913423          	sd	s1,8(sp)
    80003a50:	02010413          	addi	s0,sp,32
    80003a54:	00050493          	mv	s1,a0
    80003a58:	00007797          	auipc	a5,0x7
    80003a5c:	ba87b783          	ld	a5,-1112(a5) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x20>
    80003a60:	01078793          	addi	a5,a5,16
    80003a64:	00f53023          	sd	a5,0(a0)
    80003a68:	00000097          	auipc	ra,0x0
    80003a6c:	748080e7          	jalr	1864(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003a70:	00048513          	mv	a0,s1
    80003a74:	00000097          	auipc	ra,0x0
    80003a78:	6ac080e7          	jalr	1708(ra) # 80004120 <_ZdlPv>
    80003a7c:	01813083          	ld	ra,24(sp)
    80003a80:	01013403          	ld	s0,16(sp)
    80003a84:	00813483          	ld	s1,8(sp)
    80003a88:	02010113          	addi	sp,sp,32
    80003a8c:	00008067          	ret

0000000080003a90 <_ZN1CD1Ev>:
class C : public PeriodicThread {
    80003a90:	ff010113          	addi	sp,sp,-16
    80003a94:	00113423          	sd	ra,8(sp)
    80003a98:	00813023          	sd	s0,0(sp)
    80003a9c:	01010413          	addi	s0,sp,16
    80003aa0:	00007797          	auipc	a5,0x7
    80003aa4:	b607b783          	ld	a5,-1184(a5) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x20>
    80003aa8:	01078793          	addi	a5,a5,16
    80003aac:	00f53023          	sd	a5,0(a0)
    80003ab0:	00000097          	auipc	ra,0x0
    80003ab4:	700080e7          	jalr	1792(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003ab8:	00813083          	ld	ra,8(sp)
    80003abc:	00013403          	ld	s0,0(sp)
    80003ac0:	01010113          	addi	sp,sp,16
    80003ac4:	00008067          	ret

0000000080003ac8 <_ZN1CD0Ev>:
    80003ac8:	fe010113          	addi	sp,sp,-32
    80003acc:	00113c23          	sd	ra,24(sp)
    80003ad0:	00813823          	sd	s0,16(sp)
    80003ad4:	00913423          	sd	s1,8(sp)
    80003ad8:	02010413          	addi	s0,sp,32
    80003adc:	00050493          	mv	s1,a0
    80003ae0:	00007797          	auipc	a5,0x7
    80003ae4:	b207b783          	ld	a5,-1248(a5) # 8000a600 <_GLOBAL_OFFSET_TABLE_+0x20>
    80003ae8:	01078793          	addi	a5,a5,16
    80003aec:	00f53023          	sd	a5,0(a0)
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	6c0080e7          	jalr	1728(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80003af8:	00048513          	mv	a0,s1
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	624080e7          	jalr	1572(ra) # 80004120 <_ZdlPv>
    80003b04:	01813083          	ld	ra,24(sp)
    80003b08:	01013403          	ld	s0,16(sp)
    80003b0c:	00813483          	ld	s1,8(sp)
    80003b10:	02010113          	addi	sp,sp,32
    80003b14:	00008067          	ret

0000000080003b18 <_ZN19ConsumerProducerCPP8Consumer3runEv>:
        void run() override {
    80003b18:	fd010113          	addi	sp,sp,-48
    80003b1c:	02113423          	sd	ra,40(sp)
    80003b20:	02813023          	sd	s0,32(sp)
    80003b24:	00913c23          	sd	s1,24(sp)
    80003b28:	01213823          	sd	s2,16(sp)
    80003b2c:	01313423          	sd	s3,8(sp)
    80003b30:	03010413          	addi	s0,sp,48
    80003b34:	00050913          	mv	s2,a0
            int i = 0;
    80003b38:	00000993          	li	s3,0
    80003b3c:	0100006f          	j	80003b4c <_ZN19ConsumerProducerCPP8Consumer3runEv+0x34>
                    Console::putc('\n');
    80003b40:	00a00513          	li	a0,10
    80003b44:	00001097          	auipc	ra,0x1
    80003b48:	950080e7          	jalr	-1712(ra) # 80004494 <_ZN7Console4putcEc>
            while (!threadEnd) {
    80003b4c:	00007797          	auipc	a5,0x7
    80003b50:	e187a783          	lw	a5,-488(a5) # 8000a964 <_ZN19ConsumerProducerCPP9threadEndE>
    80003b54:	04079a63          	bnez	a5,80003ba8 <_ZN19ConsumerProducerCPP8Consumer3runEv+0x90>
                int key = td->buffer->get();
    80003b58:	01093783          	ld	a5,16(s2)
    80003b5c:	0087b503          	ld	a0,8(a5)
    80003b60:	ffffe097          	auipc	ra,0xffffe
    80003b64:	03c080e7          	jalr	60(ra) # 80001b9c <_ZN9BufferCPP3getEv>
                i++;
    80003b68:	0019849b          	addiw	s1,s3,1
    80003b6c:	0004899b          	sext.w	s3,s1
                Console::putc(key);
    80003b70:	0ff57513          	andi	a0,a0,255
    80003b74:	00001097          	auipc	ra,0x1
    80003b78:	920080e7          	jalr	-1760(ra) # 80004494 <_ZN7Console4putcEc>
                if (i % 80 == 0) {
    80003b7c:	05000793          	li	a5,80
    80003b80:	02f4e4bb          	remw	s1,s1,a5
    80003b84:	fc0494e3          	bnez	s1,80003b4c <_ZN19ConsumerProducerCPP8Consumer3runEv+0x34>
    80003b88:	fb9ff06f          	j	80003b40 <_ZN19ConsumerProducerCPP8Consumer3runEv+0x28>
                int key = td->buffer->get();
    80003b8c:	01093783          	ld	a5,16(s2)
    80003b90:	0087b503          	ld	a0,8(a5)
    80003b94:	ffffe097          	auipc	ra,0xffffe
    80003b98:	008080e7          	jalr	8(ra) # 80001b9c <_ZN9BufferCPP3getEv>
                Console::putc(key);
    80003b9c:	0ff57513          	andi	a0,a0,255
    80003ba0:	00001097          	auipc	ra,0x1
    80003ba4:	8f4080e7          	jalr	-1804(ra) # 80004494 <_ZN7Console4putcEc>
            while (td->buffer->getCnt() > 0) {
    80003ba8:	01093783          	ld	a5,16(s2)
    80003bac:	0087b503          	ld	a0,8(a5)
    80003bb0:	ffffe097          	auipc	ra,0xffffe
    80003bb4:	078080e7          	jalr	120(ra) # 80001c28 <_ZN9BufferCPP6getCntEv>
    80003bb8:	fca04ae3          	bgtz	a0,80003b8c <_ZN19ConsumerProducerCPP8Consumer3runEv+0x74>
            td->sem->signal();
    80003bbc:	01093783          	ld	a5,16(s2)
    80003bc0:	0107b503          	ld	a0,16(a5)
    80003bc4:	00001097          	auipc	ra,0x1
    80003bc8:	808080e7          	jalr	-2040(ra) # 800043cc <_ZN9Semaphore6signalEv>
        }
    80003bcc:	02813083          	ld	ra,40(sp)
    80003bd0:	02013403          	ld	s0,32(sp)
    80003bd4:	01813483          	ld	s1,24(sp)
    80003bd8:	01013903          	ld	s2,16(sp)
    80003bdc:	00813983          	ld	s3,8(sp)
    80003be0:	03010113          	addi	sp,sp,48
    80003be4:	00008067          	ret

0000000080003be8 <_ZN1A3runEv>:
    void run() override {
    80003be8:	fe010113          	addi	sp,sp,-32
    80003bec:	00113c23          	sd	ra,24(sp)
    80003bf0:	00813823          	sd	s0,16(sp)
    80003bf4:	00913423          	sd	s1,8(sp)
    80003bf8:	02010413          	addi	s0,sp,32
    80003bfc:	00050493          	mv	s1,a0
        while (true && !shouldThisThreadEnd) {
    80003c00:	0184c783          	lbu	a5,24(s1)
    80003c04:	02079263          	bnez	a5,80003c28 <_ZN1A3runEv+0x40>
            periodicActivation();
    80003c08:	0004b783          	ld	a5,0(s1)
    80003c0c:	0187b783          	ld	a5,24(a5)
    80003c10:	00048513          	mv	a0,s1
    80003c14:	000780e7          	jalr	a5
            time_sleep(sleepTime);
    80003c18:	0104b503          	ld	a0,16(s1)
    80003c1c:	ffffe097          	auipc	ra,0xffffe
    80003c20:	bf0080e7          	jalr	-1040(ra) # 8000180c <_Z10time_sleepm>
        while (true && !shouldThisThreadEnd) {
    80003c24:	fddff06f          	j	80003c00 <_ZN1A3runEv+0x18>
        myOwnWaitForAll->signal();
    80003c28:	00007517          	auipc	a0,0x7
    80003c2c:	d4053503          	ld	a0,-704(a0) # 8000a968 <myOwnWaitForAll>
    80003c30:	00000097          	auipc	ra,0x0
    80003c34:	79c080e7          	jalr	1948(ra) # 800043cc <_ZN9Semaphore6signalEv>
    }
    80003c38:	01813083          	ld	ra,24(sp)
    80003c3c:	01013403          	ld	s0,16(sp)
    80003c40:	00813483          	ld	s1,8(sp)
    80003c44:	02010113          	addi	sp,sp,32
    80003c48:	00008067          	ret

0000000080003c4c <_ZN1B3runEv>:
    void run() override {
    80003c4c:	fe010113          	addi	sp,sp,-32
    80003c50:	00113c23          	sd	ra,24(sp)
    80003c54:	00813823          	sd	s0,16(sp)
    80003c58:	00913423          	sd	s1,8(sp)
    80003c5c:	02010413          	addi	s0,sp,32
    80003c60:	00050493          	mv	s1,a0
        while (true && !shouldThisThreadEnd) {
    80003c64:	0184c783          	lbu	a5,24(s1)
    80003c68:	02079263          	bnez	a5,80003c8c <_ZN1B3runEv+0x40>
            periodicActivation();
    80003c6c:	0004b783          	ld	a5,0(s1)
    80003c70:	0187b783          	ld	a5,24(a5)
    80003c74:	00048513          	mv	a0,s1
    80003c78:	000780e7          	jalr	a5
            time_sleep(sleepTime);
    80003c7c:	0104b503          	ld	a0,16(s1)
    80003c80:	ffffe097          	auipc	ra,0xffffe
    80003c84:	b8c080e7          	jalr	-1140(ra) # 8000180c <_Z10time_sleepm>
        while (true && !shouldThisThreadEnd) {
    80003c88:	fddff06f          	j	80003c64 <_ZN1B3runEv+0x18>
        myOwnWaitForAll->signal();
    80003c8c:	00007517          	auipc	a0,0x7
    80003c90:	cdc53503          	ld	a0,-804(a0) # 8000a968 <myOwnWaitForAll>
    80003c94:	00000097          	auipc	ra,0x0
    80003c98:	738080e7          	jalr	1848(ra) # 800043cc <_ZN9Semaphore6signalEv>
    }
    80003c9c:	01813083          	ld	ra,24(sp)
    80003ca0:	01013403          	ld	s0,16(sp)
    80003ca4:	00813483          	ld	s1,8(sp)
    80003ca8:	02010113          	addi	sp,sp,32
    80003cac:	00008067          	ret

0000000080003cb0 <_ZN1C3runEv>:
    void run() override {
    80003cb0:	fe010113          	addi	sp,sp,-32
    80003cb4:	00113c23          	sd	ra,24(sp)
    80003cb8:	00813823          	sd	s0,16(sp)
    80003cbc:	00913423          	sd	s1,8(sp)
    80003cc0:	02010413          	addi	s0,sp,32
    80003cc4:	00050493          	mv	s1,a0
        while (true && !shouldThisThreadEnd) {
    80003cc8:	0184c783          	lbu	a5,24(s1)
    80003ccc:	02079263          	bnez	a5,80003cf0 <_ZN1C3runEv+0x40>
            periodicActivation();
    80003cd0:	0004b783          	ld	a5,0(s1)
    80003cd4:	0187b783          	ld	a5,24(a5)
    80003cd8:	00048513          	mv	a0,s1
    80003cdc:	000780e7          	jalr	a5
            time_sleep(sleepTime);
    80003ce0:	0104b503          	ld	a0,16(s1)
    80003ce4:	ffffe097          	auipc	ra,0xffffe
    80003ce8:	b28080e7          	jalr	-1240(ra) # 8000180c <_Z10time_sleepm>
        while (true && !shouldThisThreadEnd) {
    80003cec:	fddff06f          	j	80003cc8 <_ZN1C3runEv+0x18>
        myOwnWaitForAll->signal();
    80003cf0:	00007517          	auipc	a0,0x7
    80003cf4:	c7853503          	ld	a0,-904(a0) # 8000a968 <myOwnWaitForAll>
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	6d4080e7          	jalr	1748(ra) # 800043cc <_ZN9Semaphore6signalEv>
    }
    80003d00:	01813083          	ld	ra,24(sp)
    80003d04:	01013403          	ld	s0,16(sp)
    80003d08:	00813483          	ld	s1,8(sp)
    80003d0c:	02010113          	addi	sp,sp,32
    80003d10:	00008067          	ret

0000000080003d14 <_ZN19ConsumerProducerCPP16ProducerKeyborad3runEv>:
        void run() override {
    80003d14:	fe010113          	addi	sp,sp,-32
    80003d18:	00113c23          	sd	ra,24(sp)
    80003d1c:	00813823          	sd	s0,16(sp)
    80003d20:	00913423          	sd	s1,8(sp)
    80003d24:	02010413          	addi	s0,sp,32
    80003d28:	00050493          	mv	s1,a0
            while ((key = getc()) != 0x1b) {
    80003d2c:	ffffe097          	auipc	ra,0xffffe
    80003d30:	b44080e7          	jalr	-1212(ra) # 80001870 <_Z4getcv>
    80003d34:	0005059b          	sext.w	a1,a0
    80003d38:	01b00793          	li	a5,27
    80003d3c:	00f58c63          	beq	a1,a5,80003d54 <_ZN19ConsumerProducerCPP16ProducerKeyborad3runEv+0x40>
                td->buffer->put(key);
    80003d40:	0104b783          	ld	a5,16(s1)
    80003d44:	0087b503          	ld	a0,8(a5)
    80003d48:	ffffe097          	auipc	ra,0xffffe
    80003d4c:	dc4080e7          	jalr	-572(ra) # 80001b0c <_ZN9BufferCPP3putEi>
            while ((key = getc()) != 0x1b) {
    80003d50:	fddff06f          	j	80003d2c <_ZN19ConsumerProducerCPP16ProducerKeyborad3runEv+0x18>
            threadEnd = 1;
    80003d54:	00100793          	li	a5,1
    80003d58:	00007717          	auipc	a4,0x7
    80003d5c:	c0f72623          	sw	a5,-1012(a4) # 8000a964 <_ZN19ConsumerProducerCPP9threadEndE>
            td->buffer->put('!');
    80003d60:	0104b783          	ld	a5,16(s1)
    80003d64:	02100593          	li	a1,33
    80003d68:	0087b503          	ld	a0,8(a5)
    80003d6c:	ffffe097          	auipc	ra,0xffffe
    80003d70:	da0080e7          	jalr	-608(ra) # 80001b0c <_ZN9BufferCPP3putEi>
            td->sem->signal();
    80003d74:	0104b783          	ld	a5,16(s1)
    80003d78:	0107b503          	ld	a0,16(a5)
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	650080e7          	jalr	1616(ra) # 800043cc <_ZN9Semaphore6signalEv>
        }
    80003d84:	01813083          	ld	ra,24(sp)
    80003d88:	01013403          	ld	s0,16(sp)
    80003d8c:	00813483          	ld	s1,8(sp)
    80003d90:	02010113          	addi	sp,sp,32
    80003d94:	00008067          	ret

0000000080003d98 <_ZN19ConsumerProducerCPP8Producer3runEv>:
        void run() override {
    80003d98:	fe010113          	addi	sp,sp,-32
    80003d9c:	00113c23          	sd	ra,24(sp)
    80003da0:	00813823          	sd	s0,16(sp)
    80003da4:	00913423          	sd	s1,8(sp)
    80003da8:	01213023          	sd	s2,0(sp)
    80003dac:	02010413          	addi	s0,sp,32
    80003db0:	00050493          	mv	s1,a0
            int i = 0;
    80003db4:	00000913          	li	s2,0
            while (!threadEnd) {
    80003db8:	00007797          	auipc	a5,0x7
    80003dbc:	bac7a783          	lw	a5,-1108(a5) # 8000a964 <_ZN19ConsumerProducerCPP9threadEndE>
    80003dc0:	04079263          	bnez	a5,80003e04 <_ZN19ConsumerProducerCPP8Producer3runEv+0x6c>
                td->buffer->put(td->id + '0');
    80003dc4:	0104b783          	ld	a5,16(s1)
    80003dc8:	0007a583          	lw	a1,0(a5)
    80003dcc:	0305859b          	addiw	a1,a1,48
    80003dd0:	0087b503          	ld	a0,8(a5)
    80003dd4:	ffffe097          	auipc	ra,0xffffe
    80003dd8:	d38080e7          	jalr	-712(ra) # 80001b0c <_ZN9BufferCPP3putEi>
                i++;
    80003ddc:	0019071b          	addiw	a4,s2,1
    80003de0:	0007091b          	sext.w	s2,a4
                Thread::sleep((i+td->id)%5);
    80003de4:	0104b783          	ld	a5,16(s1)
    80003de8:	0007a783          	lw	a5,0(a5)
    80003dec:	00e787bb          	addw	a5,a5,a4
    80003df0:	00500513          	li	a0,5
    80003df4:	02a7e53b          	remw	a0,a5,a0
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	4dc080e7          	jalr	1244(ra) # 800042d4 <_ZN6Thread5sleepEm>
            while (!threadEnd) {
    80003e00:	fb9ff06f          	j	80003db8 <_ZN19ConsumerProducerCPP8Producer3runEv+0x20>
            td->sem->signal();
    80003e04:	0104b783          	ld	a5,16(s1)
    80003e08:	0107b503          	ld	a0,16(a5)
    80003e0c:	00000097          	auipc	ra,0x0
    80003e10:	5c0080e7          	jalr	1472(ra) # 800043cc <_ZN9Semaphore6signalEv>
        }
    80003e14:	01813083          	ld	ra,24(sp)
    80003e18:	01013403          	ld	s0,16(sp)
    80003e1c:	00813483          	ld	s1,8(sp)
    80003e20:	00013903          	ld	s2,0(sp)
    80003e24:	02010113          	addi	sp,sp,32
    80003e28:	00008067          	ret

0000000080003e2c <_ZN1A18periodicActivationEv>:
    void periodicActivation() override {
    80003e2c:	fe010113          	addi	sp,sp,-32
    80003e30:	00113c23          	sd	ra,24(sp)
    80003e34:	00813823          	sd	s0,16(sp)
    80003e38:	00913423          	sd	s1,8(sp)
    80003e3c:	02010413          	addi	s0,sp,32
        myOwnMutex->wait();
    80003e40:	00007497          	auipc	s1,0x7
    80003e44:	b2048493          	addi	s1,s1,-1248 # 8000a960 <finished>
    80003e48:	0104b503          	ld	a0,16(s1)
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	554080e7          	jalr	1364(ra) # 800043a0 <_ZN9Semaphore4waitEv>
        putc('A');
    80003e54:	04100513          	li	a0,65
    80003e58:	ffffe097          	auipc	ra,0xffffe
    80003e5c:	a70080e7          	jalr	-1424(ra) # 800018c8 <_Z4putcc>
        putc('\n');
    80003e60:	00a00513          	li	a0,10
    80003e64:	ffffe097          	auipc	ra,0xffffe
    80003e68:	a64080e7          	jalr	-1436(ra) # 800018c8 <_Z4putcc>
        myOwnMutex->signal();
    80003e6c:	0104b503          	ld	a0,16(s1)
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	55c080e7          	jalr	1372(ra) # 800043cc <_ZN9Semaphore6signalEv>
    }
    80003e78:	01813083          	ld	ra,24(sp)
    80003e7c:	01013403          	ld	s0,16(sp)
    80003e80:	00813483          	ld	s1,8(sp)
    80003e84:	02010113          	addi	sp,sp,32
    80003e88:	00008067          	ret

0000000080003e8c <_ZN1B18periodicActivationEv>:
    void periodicActivation() override {
    80003e8c:	fe010113          	addi	sp,sp,-32
    80003e90:	00113c23          	sd	ra,24(sp)
    80003e94:	00813823          	sd	s0,16(sp)
    80003e98:	00913423          	sd	s1,8(sp)
    80003e9c:	02010413          	addi	s0,sp,32
        myOwnMutex->wait();
    80003ea0:	00007497          	auipc	s1,0x7
    80003ea4:	ac048493          	addi	s1,s1,-1344 # 8000a960 <finished>
    80003ea8:	0104b503          	ld	a0,16(s1)
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	4f4080e7          	jalr	1268(ra) # 800043a0 <_ZN9Semaphore4waitEv>
        putc('B');
    80003eb4:	04200513          	li	a0,66
    80003eb8:	ffffe097          	auipc	ra,0xffffe
    80003ebc:	a10080e7          	jalr	-1520(ra) # 800018c8 <_Z4putcc>
        putc('\n');
    80003ec0:	00a00513          	li	a0,10
    80003ec4:	ffffe097          	auipc	ra,0xffffe
    80003ec8:	a04080e7          	jalr	-1532(ra) # 800018c8 <_Z4putcc>
        myOwnMutex->signal();
    80003ecc:	0104b503          	ld	a0,16(s1)
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	4fc080e7          	jalr	1276(ra) # 800043cc <_ZN9Semaphore6signalEv>
    }
    80003ed8:	01813083          	ld	ra,24(sp)
    80003edc:	01013403          	ld	s0,16(sp)
    80003ee0:	00813483          	ld	s1,8(sp)
    80003ee4:	02010113          	addi	sp,sp,32
    80003ee8:	00008067          	ret

0000000080003eec <_ZN1C18periodicActivationEv>:
    void periodicActivation() override {
    80003eec:	fe010113          	addi	sp,sp,-32
    80003ef0:	00113c23          	sd	ra,24(sp)
    80003ef4:	00813823          	sd	s0,16(sp)
    80003ef8:	00913423          	sd	s1,8(sp)
    80003efc:	02010413          	addi	s0,sp,32
        myOwnMutex->wait();
    80003f00:	00007497          	auipc	s1,0x7
    80003f04:	a6048493          	addi	s1,s1,-1440 # 8000a960 <finished>
    80003f08:	0104b503          	ld	a0,16(s1)
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	494080e7          	jalr	1172(ra) # 800043a0 <_ZN9Semaphore4waitEv>
        putc('C');
    80003f14:	04300513          	li	a0,67
    80003f18:	ffffe097          	auipc	ra,0xffffe
    80003f1c:	9b0080e7          	jalr	-1616(ra) # 800018c8 <_Z4putcc>
        putc('\n');
    80003f20:	00a00513          	li	a0,10
    80003f24:	ffffe097          	auipc	ra,0xffffe
    80003f28:	9a4080e7          	jalr	-1628(ra) # 800018c8 <_Z4putcc>
        myOwnMutex->signal();
    80003f2c:	0104b503          	ld	a0,16(s1)
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	49c080e7          	jalr	1180(ra) # 800043cc <_ZN9Semaphore6signalEv>
    }
    80003f38:	01813083          	ld	ra,24(sp)
    80003f3c:	01013403          	ld	s0,16(sp)
    80003f40:	00813483          	ld	s1,8(sp)
    80003f44:	02010113          	addi	sp,sp,32
    80003f48:	00008067          	ret

0000000080003f4c <_ZN7WorkerA3runEv>:
    void run() override {
    80003f4c:	ff010113          	addi	sp,sp,-16
    80003f50:	00113423          	sd	ra,8(sp)
    80003f54:	00813023          	sd	s0,0(sp)
    80003f58:	01010413          	addi	s0,sp,16
        workerBodyA(nullptr);
    80003f5c:	00000593          	li	a1,0
    80003f60:	fffff097          	auipc	ra,0xfffff
    80003f64:	a84080e7          	jalr	-1404(ra) # 800029e4 <_ZN7WorkerA11workerBodyAEPv>
    }
    80003f68:	00813083          	ld	ra,8(sp)
    80003f6c:	00013403          	ld	s0,0(sp)
    80003f70:	01010113          	addi	sp,sp,16
    80003f74:	00008067          	ret

0000000080003f78 <_ZN7WorkerB3runEv>:
    void run() override {
    80003f78:	ff010113          	addi	sp,sp,-16
    80003f7c:	00113423          	sd	ra,8(sp)
    80003f80:	00813023          	sd	s0,0(sp)
    80003f84:	01010413          	addi	s0,sp,16
        workerBodyB(nullptr);
    80003f88:	00000593          	li	a1,0
    80003f8c:	fffff097          	auipc	ra,0xfffff
    80003f90:	b24080e7          	jalr	-1244(ra) # 80002ab0 <_ZN7WorkerB11workerBodyBEPv>
    }
    80003f94:	00813083          	ld	ra,8(sp)
    80003f98:	00013403          	ld	s0,0(sp)
    80003f9c:	01010113          	addi	sp,sp,16
    80003fa0:	00008067          	ret

0000000080003fa4 <_ZN7WorkerC3runEv>:
    void run() override {
    80003fa4:	ff010113          	addi	sp,sp,-16
    80003fa8:	00113423          	sd	ra,8(sp)
    80003fac:	00813023          	sd	s0,0(sp)
    80003fb0:	01010413          	addi	s0,sp,16
        workerBodyC(nullptr);
    80003fb4:	00000593          	li	a1,0
    80003fb8:	fffff097          	auipc	ra,0xfffff
    80003fbc:	bcc080e7          	jalr	-1076(ra) # 80002b84 <_ZN7WorkerC11workerBodyCEPv>
    }
    80003fc0:	00813083          	ld	ra,8(sp)
    80003fc4:	00013403          	ld	s0,0(sp)
    80003fc8:	01010113          	addi	sp,sp,16
    80003fcc:	00008067          	ret

0000000080003fd0 <_ZN7WorkerD3runEv>:
    void run() override {
    80003fd0:	ff010113          	addi	sp,sp,-16
    80003fd4:	00113423          	sd	ra,8(sp)
    80003fd8:	00813023          	sd	s0,0(sp)
    80003fdc:	01010413          	addi	s0,sp,16
        workerBodyD(nullptr);
    80003fe0:	00000593          	li	a1,0
    80003fe4:	fffff097          	auipc	ra,0xfffff
    80003fe8:	d20080e7          	jalr	-736(ra) # 80002d04 <_ZN7WorkerD11workerBodyDEPv>
    }
    80003fec:	00813083          	ld	ra,8(sp)
    80003ff0:	00013403          	ld	s0,0(sp)
    80003ff4:	01010113          	addi	sp,sp,16
    80003ff8:	00008067          	ret

0000000080003ffc <_ZN6Thread20callRunForThisThreadEPv>:

Thread::Thread() {
    thread_create_cpp(&myHandle, &callRunForThisThread, this);
}

void Thread::callRunForThisThread(void* thisPointer) {
    80003ffc:	ff010113          	addi	sp,sp,-16
    80004000:	00113423          	sd	ra,8(sp)
    80004004:	00813023          	sd	s0,0(sp)
    80004008:	01010413          	addi	s0,sp,16
    static_cast<Thread*>(thisPointer)->run();
    8000400c:	00053783          	ld	a5,0(a0)
    80004010:	0107b783          	ld	a5,16(a5)
    80004014:	000780e7          	jalr	a5
}
    80004018:	00813083          	ld	ra,8(sp)
    8000401c:	00013403          	ld	s0,0(sp)
    80004020:	01010113          	addi	sp,sp,16
    80004024:	00008067          	ret

0000000080004028 <_ZN14PeriodicThread3runEv>:

int Semaphore::signal() {
    return sem_signal(myHandle);
}

void PeriodicThread::run() {
    80004028:	fe010113          	addi	sp,sp,-32
    8000402c:	00113c23          	sd	ra,24(sp)
    80004030:	00813823          	sd	s0,16(sp)
    80004034:	00913423          	sd	s1,8(sp)
    80004038:	02010413          	addi	s0,sp,32
    8000403c:	00050493          	mv	s1,a0
    while (true && !shouldThisThreadEnd) {
    80004040:	0184c783          	lbu	a5,24(s1)
    80004044:	02079263          	bnez	a5,80004068 <_ZN14PeriodicThread3runEv+0x40>
        periodicActivation();
    80004048:	0004b783          	ld	a5,0(s1)
    8000404c:	0187b783          	ld	a5,24(a5)
    80004050:	00048513          	mv	a0,s1
    80004054:	000780e7          	jalr	a5
        time_sleep(sleepTime);
    80004058:	0104b503          	ld	a0,16(s1)
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	7b0080e7          	jalr	1968(ra) # 8000180c <_Z10time_sleepm>
    while (true && !shouldThisThreadEnd) {
    80004064:	fddff06f          	j	80004040 <_ZN14PeriodicThread3runEv+0x18>
    }
}
    80004068:	01813083          	ld	ra,24(sp)
    8000406c:	01013403          	ld	s0,16(sp)
    80004070:	00813483          	ld	s1,8(sp)
    80004074:	02010113          	addi	sp,sp,32
    80004078:	00008067          	ret

000000008000407c <_ZN9SemaphoreD1Ev>:
Semaphore::~Semaphore() {
    8000407c:	fe010113          	addi	sp,sp,-32
    80004080:	00113c23          	sd	ra,24(sp)
    80004084:	00813823          	sd	s0,16(sp)
    80004088:	00913423          	sd	s1,8(sp)
    8000408c:	02010413          	addi	s0,sp,32
    80004090:	00006797          	auipc	a5,0x6
    80004094:	51078793          	addi	a5,a5,1296 # 8000a5a0 <_ZTV9Semaphore+0x10>
    80004098:	00f53023          	sd	a5,0(a0)
    delete (KernelSemaphore*)myHandle;
    8000409c:	00853483          	ld	s1,8(a0)
    800040a0:	00048e63          	beqz	s1,800040bc <_ZN9SemaphoreD1Ev+0x40>
    800040a4:	00048513          	mv	a0,s1
    800040a8:	00000097          	auipc	ra,0x0
    800040ac:	7c4080e7          	jalr	1988(ra) # 8000486c <_ZN15KernelSemaphoreD1Ev>
    800040b0:	00048513          	mv	a0,s1
    800040b4:	00000097          	auipc	ra,0x0
    800040b8:	57c080e7          	jalr	1404(ra) # 80004630 <_ZN15KernelSemaphoredlEPv>
}
    800040bc:	01813083          	ld	ra,24(sp)
    800040c0:	01013403          	ld	s0,16(sp)
    800040c4:	00813483          	ld	s1,8(sp)
    800040c8:	02010113          	addi	sp,sp,32
    800040cc:	00008067          	ret

00000000800040d0 <_Znwm>:
void* operator new(size_t n) {
    800040d0:	ff010113          	addi	sp,sp,-16
    800040d4:	00113423          	sd	ra,8(sp)
    800040d8:	00813023          	sd	s0,0(sp)
    800040dc:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	240080e7          	jalr	576(ra) # 80001320 <_Z9mem_allocm>
}
    800040e8:	00813083          	ld	ra,8(sp)
    800040ec:	00013403          	ld	s0,0(sp)
    800040f0:	01010113          	addi	sp,sp,16
    800040f4:	00008067          	ret

00000000800040f8 <_Znam>:
void* operator new[](size_t n) {
    800040f8:	ff010113          	addi	sp,sp,-16
    800040fc:	00113423          	sd	ra,8(sp)
    80004100:	00813023          	sd	s0,0(sp)
    80004104:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	218080e7          	jalr	536(ra) # 80001320 <_Z9mem_allocm>
}
    80004110:	00813083          	ld	ra,8(sp)
    80004114:	00013403          	ld	s0,0(sp)
    80004118:	01010113          	addi	sp,sp,16
    8000411c:	00008067          	ret

0000000080004120 <_ZdlPv>:
void operator delete(void* ptr) {
    80004120:	ff010113          	addi	sp,sp,-16
    80004124:	00113423          	sd	ra,8(sp)
    80004128:	00813023          	sd	s0,0(sp)
    8000412c:	01010413          	addi	s0,sp,16
    mem_free(ptr);
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	254080e7          	jalr	596(ra) # 80001384 <_Z8mem_freePv>
}
    80004138:	00813083          	ld	ra,8(sp)
    8000413c:	00013403          	ld	s0,0(sp)
    80004140:	01010113          	addi	sp,sp,16
    80004144:	00008067          	ret

0000000080004148 <_ZN9SemaphoreD0Ev>:
Semaphore::~Semaphore() {
    80004148:	fe010113          	addi	sp,sp,-32
    8000414c:	00113c23          	sd	ra,24(sp)
    80004150:	00813823          	sd	s0,16(sp)
    80004154:	00913423          	sd	s1,8(sp)
    80004158:	02010413          	addi	s0,sp,32
    8000415c:	00050493          	mv	s1,a0
}
    80004160:	00000097          	auipc	ra,0x0
    80004164:	f1c080e7          	jalr	-228(ra) # 8000407c <_ZN9SemaphoreD1Ev>
    80004168:	00048513          	mv	a0,s1
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	fb4080e7          	jalr	-76(ra) # 80004120 <_ZdlPv>
    80004174:	01813083          	ld	ra,24(sp)
    80004178:	01013403          	ld	s0,16(sp)
    8000417c:	00813483          	ld	s1,8(sp)
    80004180:	02010113          	addi	sp,sp,32
    80004184:	00008067          	ret

0000000080004188 <_ZdaPv>:
void operator delete[](void* ptr) {
    80004188:	ff010113          	addi	sp,sp,-16
    8000418c:	00113423          	sd	ra,8(sp)
    80004190:	00813023          	sd	s0,0(sp)
    80004194:	01010413          	addi	s0,sp,16
    mem_free(ptr);
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	1ec080e7          	jalr	492(ra) # 80001384 <_Z8mem_freePv>
}
    800041a0:	00813083          	ld	ra,8(sp)
    800041a4:	00013403          	ld	s0,0(sp)
    800041a8:	01010113          	addi	sp,sp,16
    800041ac:	00008067          	ret

00000000800041b0 <_ZN6ThreadD1Ev>:
Thread::~Thread() {
    800041b0:	fe010113          	addi	sp,sp,-32
    800041b4:	00113c23          	sd	ra,24(sp)
    800041b8:	00813823          	sd	s0,16(sp)
    800041bc:	00913423          	sd	s1,8(sp)
    800041c0:	02010413          	addi	s0,sp,32
    800041c4:	00006797          	auipc	a5,0x6
    800041c8:	3b478793          	addi	a5,a5,948 # 8000a578 <_ZTV6Thread+0x10>
    800041cc:	00f53023          	sd	a5,0(a0)
    delete (TCB*)(myHandle);
    800041d0:	00853483          	ld	s1,8(a0)
    800041d4:	02048063          	beqz	s1,800041f4 <_ZN6ThreadD1Ev+0x44>
    static void* operator new(size_t n);
    static void* operator new[](size_t n);
    static void operator delete(void* ptr);
    static void operator delete[](void* ptr);

    ~TCB() { delete[] stack; }
    800041d8:	0184b503          	ld	a0,24(s1)
    800041dc:	00050663          	beqz	a0,800041e8 <_ZN6ThreadD1Ev+0x38>
    800041e0:	00000097          	auipc	ra,0x0
    800041e4:	fa8080e7          	jalr	-88(ra) # 80004188 <_ZdaPv>
    800041e8:	00048513          	mv	a0,s1
    800041ec:	00001097          	auipc	ra,0x1
    800041f0:	c74080e7          	jalr	-908(ra) # 80004e60 <_ZN3TCBdlEPv>
}
    800041f4:	01813083          	ld	ra,24(sp)
    800041f8:	01013403          	ld	s0,16(sp)
    800041fc:	00813483          	ld	s1,8(sp)
    80004200:	02010113          	addi	sp,sp,32
    80004204:	00008067          	ret

0000000080004208 <_ZN6ThreadD0Ev>:
Thread::~Thread() {
    80004208:	fe010113          	addi	sp,sp,-32
    8000420c:	00113c23          	sd	ra,24(sp)
    80004210:	00813823          	sd	s0,16(sp)
    80004214:	00913423          	sd	s1,8(sp)
    80004218:	02010413          	addi	s0,sp,32
    8000421c:	00050493          	mv	s1,a0
}
    80004220:	00000097          	auipc	ra,0x0
    80004224:	f90080e7          	jalr	-112(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80004228:	00048513          	mv	a0,s1
    8000422c:	00000097          	auipc	ra,0x0
    80004230:	ef4080e7          	jalr	-268(ra) # 80004120 <_ZdlPv>
    80004234:	01813083          	ld	ra,24(sp)
    80004238:	01013403          	ld	s0,16(sp)
    8000423c:	00813483          	ld	s1,8(sp)
    80004240:	02010113          	addi	sp,sp,32
    80004244:	00008067          	ret

0000000080004248 <_ZN6ThreadC1EPFvPvES0_>:
Thread::Thread(void (*body)(void*), void *arg) {
    80004248:	ff010113          	addi	sp,sp,-16
    8000424c:	00113423          	sd	ra,8(sp)
    80004250:	00813023          	sd	s0,0(sp)
    80004254:	01010413          	addi	s0,sp,16
    80004258:	00006797          	auipc	a5,0x6
    8000425c:	32078793          	addi	a5,a5,800 # 8000a578 <_ZTV6Thread+0x10>
    80004260:	00f53023          	sd	a5,0(a0)
    thread_create_cpp(&myHandle, body, arg);
    80004264:	00850513          	addi	a0,a0,8
    80004268:	ffffd097          	auipc	ra,0xffffd
    8000426c:	2c4080e7          	jalr	708(ra) # 8000152c <_Z17thread_create_cppPP7_threadPFvPvES2_>
}
    80004270:	00813083          	ld	ra,8(sp)
    80004274:	00013403          	ld	s0,0(sp)
    80004278:	01010113          	addi	sp,sp,16
    8000427c:	00008067          	ret

0000000080004280 <_ZN6Thread5startEv>:
int Thread::start() {
    80004280:	ff010113          	addi	sp,sp,-16
    80004284:	00113423          	sd	ra,8(sp)
    80004288:	00813023          	sd	s0,0(sp)
    8000428c:	01010413          	addi	s0,sp,16
    return scheduler_put(myHandle);
    80004290:	00853503          	ld	a0,8(a0)
    80004294:	ffffd097          	auipc	ra,0xffffd
    80004298:	344080e7          	jalr	836(ra) # 800015d8 <_Z13scheduler_putP7_thread>
}
    8000429c:	00813083          	ld	ra,8(sp)
    800042a0:	00013403          	ld	s0,0(sp)
    800042a4:	01010113          	addi	sp,sp,16
    800042a8:	00008067          	ret

00000000800042ac <_ZN6Thread8dispatchEv>:
void Thread::dispatch() {
    800042ac:	ff010113          	addi	sp,sp,-16
    800042b0:	00113423          	sd	ra,8(sp)
    800042b4:	00813023          	sd	s0,0(sp)
    800042b8:	01010413          	addi	s0,sp,16
    thread_dispatch();
    800042bc:	ffffd097          	auipc	ra,0xffffd
    800042c0:	220080e7          	jalr	544(ra) # 800014dc <_Z15thread_dispatchv>
}
    800042c4:	00813083          	ld	ra,8(sp)
    800042c8:	00013403          	ld	s0,0(sp)
    800042cc:	01010113          	addi	sp,sp,16
    800042d0:	00008067          	ret

00000000800042d4 <_ZN6Thread5sleepEm>:
int Thread::sleep(time_t time) {
    800042d4:	ff010113          	addi	sp,sp,-16
    800042d8:	00113423          	sd	ra,8(sp)
    800042dc:	00813023          	sd	s0,0(sp)
    800042e0:	01010413          	addi	s0,sp,16
    return time_sleep(time);
    800042e4:	ffffd097          	auipc	ra,0xffffd
    800042e8:	528080e7          	jalr	1320(ra) # 8000180c <_Z10time_sleepm>
}
    800042ec:	00813083          	ld	ra,8(sp)
    800042f0:	00013403          	ld	s0,0(sp)
    800042f4:	01010113          	addi	sp,sp,16
    800042f8:	00008067          	ret

00000000800042fc <_ZN6Thread11getThreadIdEv>:
int Thread::getThreadId() {
    800042fc:	ff010113          	addi	sp,sp,-16
    80004300:	00113423          	sd	ra,8(sp)
    80004304:	00813023          	sd	s0,0(sp)
    80004308:	01010413          	addi	s0,sp,16
    return ::getThreadId();
    8000430c:	ffffd097          	auipc	ra,0xffffd
    80004310:	32c080e7          	jalr	812(ra) # 80001638 <_Z11getThreadIdv>
}
    80004314:	00813083          	ld	ra,8(sp)
    80004318:	00013403          	ld	s0,0(sp)
    8000431c:	01010113          	addi	sp,sp,16
    80004320:	00008067          	ret

0000000080004324 <_ZN6ThreadC1Ev>:
Thread::Thread() {
    80004324:	ff010113          	addi	sp,sp,-16
    80004328:	00113423          	sd	ra,8(sp)
    8000432c:	00813023          	sd	s0,0(sp)
    80004330:	01010413          	addi	s0,sp,16
    80004334:	00006797          	auipc	a5,0x6
    80004338:	24478793          	addi	a5,a5,580 # 8000a578 <_ZTV6Thread+0x10>
    8000433c:	00f53023          	sd	a5,0(a0)
    thread_create_cpp(&myHandle, &callRunForThisThread, this);
    80004340:	00050613          	mv	a2,a0
    80004344:	00000597          	auipc	a1,0x0
    80004348:	cb858593          	addi	a1,a1,-840 # 80003ffc <_ZN6Thread20callRunForThisThreadEPv>
    8000434c:	00850513          	addi	a0,a0,8
    80004350:	ffffd097          	auipc	ra,0xffffd
    80004354:	1dc080e7          	jalr	476(ra) # 8000152c <_Z17thread_create_cppPP7_threadPFvPvES2_>
}
    80004358:	00813083          	ld	ra,8(sp)
    8000435c:	00013403          	ld	s0,0(sp)
    80004360:	01010113          	addi	sp,sp,16
    80004364:	00008067          	ret

0000000080004368 <_ZN9SemaphoreC1Ej>:
Semaphore::Semaphore(unsigned int init) {
    80004368:	ff010113          	addi	sp,sp,-16
    8000436c:	00113423          	sd	ra,8(sp)
    80004370:	00813023          	sd	s0,0(sp)
    80004374:	01010413          	addi	s0,sp,16
    80004378:	00006797          	auipc	a5,0x6
    8000437c:	22878793          	addi	a5,a5,552 # 8000a5a0 <_ZTV9Semaphore+0x10>
    80004380:	00f53023          	sd	a5,0(a0)
    sem_open(&myHandle, init);
    80004384:	00850513          	addi	a0,a0,8
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	308080e7          	jalr	776(ra) # 80001690 <_Z8sem_openPP4_semj>
}
    80004390:	00813083          	ld	ra,8(sp)
    80004394:	00013403          	ld	s0,0(sp)
    80004398:	01010113          	addi	sp,sp,16
    8000439c:	00008067          	ret

00000000800043a0 <_ZN9Semaphore4waitEv>:
int Semaphore::wait() {
    800043a0:	ff010113          	addi	sp,sp,-16
    800043a4:	00113423          	sd	ra,8(sp)
    800043a8:	00813023          	sd	s0,0(sp)
    800043ac:	01010413          	addi	s0,sp,16
    return sem_wait(myHandle);
    800043b0:	00853503          	ld	a0,8(a0)
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	3ac080e7          	jalr	940(ra) # 80001760 <_Z8sem_waitP4_sem>
}
    800043bc:	00813083          	ld	ra,8(sp)
    800043c0:	00013403          	ld	s0,0(sp)
    800043c4:	01010113          	addi	sp,sp,16
    800043c8:	00008067          	ret

00000000800043cc <_ZN9Semaphore6signalEv>:
int Semaphore::signal() {
    800043cc:	ff010113          	addi	sp,sp,-16
    800043d0:	00113423          	sd	ra,8(sp)
    800043d4:	00813023          	sd	s0,0(sp)
    800043d8:	01010413          	addi	s0,sp,16
    return sem_signal(myHandle);
    800043dc:	00853503          	ld	a0,8(a0)
    800043e0:	ffffd097          	auipc	ra,0xffffd
    800043e4:	3d8080e7          	jalr	984(ra) # 800017b8 <_Z10sem_signalP4_sem>
}
    800043e8:	00813083          	ld	ra,8(sp)
    800043ec:	00013403          	ld	s0,0(sp)
    800043f0:	01010113          	addi	sp,sp,16
    800043f4:	00008067          	ret

00000000800043f8 <_ZN14PeriodicThread17endPeriodicThreadEv>:

void PeriodicThread::endPeriodicThread() {
    800043f8:	ff010113          	addi	sp,sp,-16
    800043fc:	00813423          	sd	s0,8(sp)
    80004400:	01010413          	addi	s0,sp,16
    shouldThisThreadEnd = true;
    80004404:	00100793          	li	a5,1
    80004408:	00f50c23          	sb	a5,24(a0)
}
    8000440c:	00813403          	ld	s0,8(sp)
    80004410:	01010113          	addi	sp,sp,16
    80004414:	00008067          	ret

0000000080004418 <_ZN14PeriodicThreadC1Em>:

PeriodicThread::PeriodicThread(time_t period) {
    80004418:	fe010113          	addi	sp,sp,-32
    8000441c:	00113c23          	sd	ra,24(sp)
    80004420:	00813823          	sd	s0,16(sp)
    80004424:	00913423          	sd	s1,8(sp)
    80004428:	01213023          	sd	s2,0(sp)
    8000442c:	02010413          	addi	s0,sp,32
    80004430:	00050493          	mv	s1,a0
    80004434:	00058913          	mv	s2,a1
    80004438:	00000097          	auipc	ra,0x0
    8000443c:	eec080e7          	jalr	-276(ra) # 80004324 <_ZN6ThreadC1Ev>
    80004440:	00006797          	auipc	a5,0x6
    80004444:	18078793          	addi	a5,a5,384 # 8000a5c0 <_ZTV14PeriodicThread+0x10>
    80004448:	00f4b023          	sd	a5,0(s1)
    sleepTime = period;
    8000444c:	0124b823          	sd	s2,16(s1)
    shouldThisThreadEnd = false;
    80004450:	00048c23          	sb	zero,24(s1)
}
    80004454:	01813083          	ld	ra,24(sp)
    80004458:	01013403          	ld	s0,16(sp)
    8000445c:	00813483          	ld	s1,8(sp)
    80004460:	00013903          	ld	s2,0(sp)
    80004464:	02010113          	addi	sp,sp,32
    80004468:	00008067          	ret

000000008000446c <_ZN7Console4getcEv>:


char Console::getc() {
    8000446c:	ff010113          	addi	sp,sp,-16
    80004470:	00113423          	sd	ra,8(sp)
    80004474:	00813023          	sd	s0,0(sp)
    80004478:	01010413          	addi	s0,sp,16
    return ::getc();
    8000447c:	ffffd097          	auipc	ra,0xffffd
    80004480:	3f4080e7          	jalr	1012(ra) # 80001870 <_Z4getcv>
}
    80004484:	00813083          	ld	ra,8(sp)
    80004488:	00013403          	ld	s0,0(sp)
    8000448c:	01010113          	addi	sp,sp,16
    80004490:	00008067          	ret

0000000080004494 <_ZN7Console4putcEc>:

void Console::putc(char c) {
    80004494:	ff010113          	addi	sp,sp,-16
    80004498:	00113423          	sd	ra,8(sp)
    8000449c:	00813023          	sd	s0,0(sp)
    800044a0:	01010413          	addi	s0,sp,16
    ::putc(c);
    800044a4:	ffffd097          	auipc	ra,0xffffd
    800044a8:	424080e7          	jalr	1060(ra) # 800018c8 <_Z4putcc>
    800044ac:	00813083          	ld	ra,8(sp)
    800044b0:	00013403          	ld	s0,0(sp)
    800044b4:	01010113          	addi	sp,sp,16
    800044b8:	00008067          	ret

00000000800044bc <_ZN6Thread3runEv>:

    int getThreadId();

protected:
    Thread();
    virtual void run() {}
    800044bc:	ff010113          	addi	sp,sp,-16
    800044c0:	00813423          	sd	s0,8(sp)
    800044c4:	01010413          	addi	s0,sp,16
    800044c8:	00813403          	ld	s0,8(sp)
    800044cc:	01010113          	addi	sp,sp,16
    800044d0:	00008067          	ret

00000000800044d4 <_ZN14PeriodicThread18periodicActivationEv>:
public:
    void endPeriodicThread();
protected:
    explicit PeriodicThread(time_t period);
    void run() override;
    virtual void periodicActivation() {}
    800044d4:	ff010113          	addi	sp,sp,-16
    800044d8:	00813423          	sd	s0,8(sp)
    800044dc:	01010413          	addi	s0,sp,16
    800044e0:	00813403          	ld	s0,8(sp)
    800044e4:	01010113          	addi	sp,sp,16
    800044e8:	00008067          	ret

00000000800044ec <_ZN14PeriodicThreadD1Ev>:
class PeriodicThread : public Thread {
    800044ec:	ff010113          	addi	sp,sp,-16
    800044f0:	00113423          	sd	ra,8(sp)
    800044f4:	00813023          	sd	s0,0(sp)
    800044f8:	01010413          	addi	s0,sp,16
    800044fc:	00006797          	auipc	a5,0x6
    80004500:	0c478793          	addi	a5,a5,196 # 8000a5c0 <_ZTV14PeriodicThread+0x10>
    80004504:	00f53023          	sd	a5,0(a0)
    80004508:	00000097          	auipc	ra,0x0
    8000450c:	ca8080e7          	jalr	-856(ra) # 800041b0 <_ZN6ThreadD1Ev>
    80004510:	00813083          	ld	ra,8(sp)
    80004514:	00013403          	ld	s0,0(sp)
    80004518:	01010113          	addi	sp,sp,16
    8000451c:	00008067          	ret

0000000080004520 <_ZN14PeriodicThreadD0Ev>:
    80004520:	fe010113          	addi	sp,sp,-32
    80004524:	00113c23          	sd	ra,24(sp)
    80004528:	00813823          	sd	s0,16(sp)
    8000452c:	00913423          	sd	s1,8(sp)
    80004530:	02010413          	addi	s0,sp,32
    80004534:	00050493          	mv	s1,a0
    80004538:	00006797          	auipc	a5,0x6
    8000453c:	08878793          	addi	a5,a5,136 # 8000a5c0 <_ZTV14PeriodicThread+0x10>
    80004540:	00f53023          	sd	a5,0(a0)
    80004544:	00000097          	auipc	ra,0x0
    80004548:	c6c080e7          	jalr	-916(ra) # 800041b0 <_ZN6ThreadD1Ev>
    8000454c:	00048513          	mv	a0,s1
    80004550:	00000097          	auipc	ra,0x0
    80004554:	bd0080e7          	jalr	-1072(ra) # 80004120 <_ZdlPv>
    80004558:	01813083          	ld	ra,24(sp)
    8000455c:	01013403          	ld	s0,16(sp)
    80004560:	00813483          	ld	s1,8(sp)
    80004564:	02010113          	addi	sp,sp,32
    80004568:	00008067          	ret

000000008000456c <_ZN15KernelSemaphorenwEm>:
    if (++semaphoreValue <= 0) {
        unblockFirstThreadInList();
    }
}

void* KernelSemaphore::operator new(size_t n) {
    8000456c:	fe010113          	addi	sp,sp,-32
    80004570:	00113c23          	sd	ra,24(sp)
    80004574:	00813823          	sd	s0,16(sp)
    80004578:	00913423          	sd	s1,8(sp)
    8000457c:	02010413          	addi	s0,sp,32
    80004580:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80004584:	00001097          	auipc	ra,0x1
    80004588:	208080e7          	jalr	520(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    8000458c:	00048593          	mv	a1,s1
    80004590:	00001097          	auipc	ra,0x1
    80004594:	258080e7          	jalr	600(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    80004598:	01813083          	ld	ra,24(sp)
    8000459c:	01013403          	ld	s0,16(sp)
    800045a0:	00813483          	ld	s1,8(sp)
    800045a4:	02010113          	addi	sp,sp,32
    800045a8:	00008067          	ret

00000000800045ac <_ZN15KernelSemaphore15createSemaphoreEt>:
KernelSemaphore* KernelSemaphore::createSemaphore(unsigned short initialSemaphoreValue) {
    800045ac:	fe010113          	addi	sp,sp,-32
    800045b0:	00113c23          	sd	ra,24(sp)
    800045b4:	00813823          	sd	s0,16(sp)
    800045b8:	00913423          	sd	s1,8(sp)
    800045bc:	02010413          	addi	s0,sp,32
    800045c0:	00050493          	mv	s1,a0
    return new KernelSemaphore(initialSemaphoreValue);
    800045c4:	01800513          	li	a0,24
    800045c8:	00000097          	auipc	ra,0x0
    800045cc:	fa4080e7          	jalr	-92(ra) # 8000456c <_ZN15KernelSemaphorenwEm>
protected:
    void blockCurrentThread();
    TCB* unblockFirstThreadInList();

private:
    explicit KernelSemaphore(unsigned short initialSemaphoreValue = 1) : semaphoreValue(initialSemaphoreValue) {}
    800045d0:	00952023          	sw	s1,0(a0)
    800045d4:	00053423          	sd	zero,8(a0)
    800045d8:	00053823          	sd	zero,16(a0)
}
    800045dc:	01813083          	ld	ra,24(sp)
    800045e0:	01013403          	ld	s0,16(sp)
    800045e4:	00813483          	ld	s1,8(sp)
    800045e8:	02010113          	addi	sp,sp,32
    800045ec:	00008067          	ret

00000000800045f0 <_ZN15KernelSemaphorenaEm>:

void* KernelSemaphore::operator new[](size_t n) {
    800045f0:	fe010113          	addi	sp,sp,-32
    800045f4:	00113c23          	sd	ra,24(sp)
    800045f8:	00813823          	sd	s0,16(sp)
    800045fc:	00913423          	sd	s1,8(sp)
    80004600:	02010413          	addi	s0,sp,32
    80004604:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80004608:	00001097          	auipc	ra,0x1
    8000460c:	184080e7          	jalr	388(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004610:	00048593          	mv	a1,s1
    80004614:	00001097          	auipc	ra,0x1
    80004618:	1d4080e7          	jalr	468(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
    return ptr;
}
    8000461c:	01813083          	ld	ra,24(sp)
    80004620:	01013403          	ld	s0,16(sp)
    80004624:	00813483          	ld	s1,8(sp)
    80004628:	02010113          	addi	sp,sp,32
    8000462c:	00008067          	ret

0000000080004630 <_ZN15KernelSemaphoredlEPv>:

void KernelSemaphore::operator delete(void *ptr) {
    80004630:	fe010113          	addi	sp,sp,-32
    80004634:	00113c23          	sd	ra,24(sp)
    80004638:	00813823          	sd	s0,16(sp)
    8000463c:	00913423          	sd	s1,8(sp)
    80004640:	02010413          	addi	s0,sp,32
    80004644:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80004648:	00001097          	auipc	ra,0x1
    8000464c:	144080e7          	jalr	324(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004650:	00048593          	mv	a1,s1
    80004654:	00001097          	auipc	ra,0x1
    80004658:	278080e7          	jalr	632(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    8000465c:	01813083          	ld	ra,24(sp)
    80004660:	01013403          	ld	s0,16(sp)
    80004664:	00813483          	ld	s1,8(sp)
    80004668:	02010113          	addi	sp,sp,32
    8000466c:	00008067          	ret

0000000080004670 <_ZN15KernelSemaphoredaEPv>:

void KernelSemaphore::operator delete[](void *ptr) {
    80004670:	fe010113          	addi	sp,sp,-32
    80004674:	00113c23          	sd	ra,24(sp)
    80004678:	00813823          	sd	s0,16(sp)
    8000467c:	00913423          	sd	s1,8(sp)
    80004680:	02010413          	addi	s0,sp,32
    80004684:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80004688:	00001097          	auipc	ra,0x1
    8000468c:	104080e7          	jalr	260(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004690:	00048593          	mv	a1,s1
    80004694:	00001097          	auipc	ra,0x1
    80004698:	238080e7          	jalr	568(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    8000469c:	01813083          	ld	ra,24(sp)
    800046a0:	01013403          	ld	s0,16(sp)
    800046a4:	00813483          	ld	s1,8(sp)
    800046a8:	02010113          	addi	sp,sp,32
    800046ac:	00008067          	ret

00000000800046b0 <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB>:
    TCB* tcb = removeThreadFromBlockedList();
    if (tcb) Scheduler::getInstance().put(tcb);
    return tcb;
}

void KernelSemaphore::insertThreadIntoBlockedList(TCB *tcb) {
    800046b0:	ff010113          	addi	sp,sp,-16
    800046b4:	00813423          	sd	s0,8(sp)
    800046b8:	01010413          	addi	s0,sp,16
    if (!blockedThreadsHead || !blockedThreadsTail) {
    800046bc:	00853783          	ld	a5,8(a0)
    800046c0:	00078e63          	beqz	a5,800046dc <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB+0x2c>
    800046c4:	01053783          	ld	a5,16(a0)
    800046c8:	00078a63          	beqz	a5,800046dc <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB+0x2c>
    void setNextSemaphoreThread(TCB* next) { semaphoreNextThread = next; }
    800046cc:	06b7b023          	sd	a1,96(a5)
        blockedThreadsHead = blockedThreadsTail = tcb;
        blockedThreadsHead->setNextSemaphoreThread(nullptr);
    } else {
        blockedThreadsTail->setNextSemaphoreThread(tcb);
        blockedThreadsTail = tcb;
    800046d0:	00b53823          	sd	a1,16(a0)
    800046d4:	0605b023          	sd	zero,96(a1)
        blockedThreadsTail->setNextSemaphoreThread(nullptr);
    }
}
    800046d8:	0100006f          	j	800046e8 <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB+0x38>
        blockedThreadsHead = blockedThreadsTail = tcb;
    800046dc:	00b53823          	sd	a1,16(a0)
    800046e0:	00b53423          	sd	a1,8(a0)
    800046e4:	0605b023          	sd	zero,96(a1)
}
    800046e8:	00813403          	ld	s0,8(sp)
    800046ec:	01010113          	addi	sp,sp,16
    800046f0:	00008067          	ret

00000000800046f4 <_ZN15KernelSemaphore18blockCurrentThreadEv>:
void KernelSemaphore::blockCurrentThread() {
    800046f4:	ff010113          	addi	sp,sp,-16
    800046f8:	00113423          	sd	ra,8(sp)
    800046fc:	00813023          	sd	s0,0(sp)
    80004700:	01010413          	addi	s0,sp,16
    insertThreadIntoBlockedList(TCB::runningThread);
    80004704:	00006797          	auipc	a5,0x6
    80004708:	f147b783          	ld	a5,-236(a5) # 8000a618 <_GLOBAL_OFFSET_TABLE_+0x38>
    8000470c:	0007b583          	ld	a1,0(a5)
    80004710:	00000097          	auipc	ra,0x0
    80004714:	fa0080e7          	jalr	-96(ra) # 800046b0 <_ZN15KernelSemaphore27insertThreadIntoBlockedListEP3TCB>
    TCB::suspendCurrentThread();
    80004718:	00001097          	auipc	ra,0x1
    8000471c:	a70080e7          	jalr	-1424(ra) # 80005188 <_ZN3TCB20suspendCurrentThreadEv>
}
    80004720:	00813083          	ld	ra,8(sp)
    80004724:	00013403          	ld	s0,0(sp)
    80004728:	01010113          	addi	sp,sp,16
    8000472c:	00008067          	ret

0000000080004730 <_ZN15KernelSemaphore4waitEv>:
    if (--semaphoreValue < 0) {
    80004730:	00052783          	lw	a5,0(a0)
    80004734:	fff7879b          	addiw	a5,a5,-1
    80004738:	00f52023          	sw	a5,0(a0)
    8000473c:	02079713          	slli	a4,a5,0x20
    80004740:	00074463          	bltz	a4,80004748 <_ZN15KernelSemaphore4waitEv+0x18>
    80004744:	00008067          	ret
void KernelSemaphore::wait() {
    80004748:	ff010113          	addi	sp,sp,-16
    8000474c:	00113423          	sd	ra,8(sp)
    80004750:	00813023          	sd	s0,0(sp)
    80004754:	01010413          	addi	s0,sp,16
       blockCurrentThread();
    80004758:	00000097          	auipc	ra,0x0
    8000475c:	f9c080e7          	jalr	-100(ra) # 800046f4 <_ZN15KernelSemaphore18blockCurrentThreadEv>
}
    80004760:	00813083          	ld	ra,8(sp)
    80004764:	00013403          	ld	s0,0(sp)
    80004768:	01010113          	addi	sp,sp,16
    8000476c:	00008067          	ret

0000000080004770 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv>:

TCB* KernelSemaphore::removeThreadFromBlockedList() {
    80004770:	ff010113          	addi	sp,sp,-16
    80004774:	00813423          	sd	s0,8(sp)
    80004778:	01010413          	addi	s0,sp,16
    8000477c:	00050793          	mv	a5,a0
    if (!blockedThreadsHead || !blockedThreadsTail) return nullptr;
    80004780:	00853503          	ld	a0,8(a0)
    80004784:	00050e63          	beqz	a0,800047a0 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x30>
    80004788:	0107b703          	ld	a4,16(a5)
    8000478c:	02070463          	beqz	a4,800047b4 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x44>
    TCB* getNextSemaphoreThread() const { return semaphoreNextThread; }
    80004790:	06053703          	ld	a4,96(a0)
    TCB* oldThread = blockedThreadsHead;
    blockedThreadsHead = blockedThreadsHead->getNextSemaphoreThread();
    80004794:	00e7b423          	sd	a4,8(a5)
    if (!blockedThreadsHead) blockedThreadsTail = nullptr;
    80004798:	00070a63          	beqz	a4,800047ac <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x3c>
    void setNextSemaphoreThread(TCB* next) { semaphoreNextThread = next; }
    8000479c:	06053023          	sd	zero,96(a0)
    oldThread->setNextSemaphoreThread(nullptr);
    return oldThread;
    800047a0:	00813403          	ld	s0,8(sp)
    800047a4:	01010113          	addi	sp,sp,16
    800047a8:	00008067          	ret
    if (!blockedThreadsHead) blockedThreadsTail = nullptr;
    800047ac:	0007b823          	sd	zero,16(a5)
    800047b0:	fedff06f          	j	8000479c <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x2c>
    if (!blockedThreadsHead || !blockedThreadsTail) return nullptr;
    800047b4:	00070513          	mv	a0,a4
    800047b8:	fe9ff06f          	j	800047a0 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv+0x30>

00000000800047bc <_ZN15KernelSemaphore24unblockFirstThreadInListEv>:
TCB* KernelSemaphore::unblockFirstThreadInList() {
    800047bc:	fe010113          	addi	sp,sp,-32
    800047c0:	00113c23          	sd	ra,24(sp)
    800047c4:	00813823          	sd	s0,16(sp)
    800047c8:	00913423          	sd	s1,8(sp)
    800047cc:	02010413          	addi	s0,sp,32
    TCB* tcb = removeThreadFromBlockedList();
    800047d0:	00000097          	auipc	ra,0x0
    800047d4:	fa0080e7          	jalr	-96(ra) # 80004770 <_ZN15KernelSemaphore27removeThreadFromBlockedListEv>
    800047d8:	00050493          	mv	s1,a0
    if (tcb) Scheduler::getInstance().put(tcb);
    800047dc:	00050c63          	beqz	a0,800047f4 <_ZN15KernelSemaphore24unblockFirstThreadInListEv+0x38>
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	e18080e7          	jalr	-488(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    800047e8:	00048593          	mv	a1,s1
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	e58080e7          	jalr	-424(ra) # 80002644 <_ZN9Scheduler3putEP3TCB>
}
    800047f4:	00048513          	mv	a0,s1
    800047f8:	01813083          	ld	ra,24(sp)
    800047fc:	01013403          	ld	s0,16(sp)
    80004800:	00813483          	ld	s1,8(sp)
    80004804:	02010113          	addi	sp,sp,32
    80004808:	00008067          	ret

000000008000480c <_ZN15KernelSemaphore14closeSemaphoreEPS_>:
int KernelSemaphore::closeSemaphore(KernelSemaphore *semaphore) {
    8000480c:	fe010113          	addi	sp,sp,-32
    80004810:	00113c23          	sd	ra,24(sp)
    80004814:	00813823          	sd	s0,16(sp)
    80004818:	00913423          	sd	s1,8(sp)
    8000481c:	02010413          	addi	s0,sp,32
    80004820:	00050493          	mv	s1,a0
    if (!semaphore) return -1;
    80004824:	02050463          	beqz	a0,8000484c <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x40>
    while (semaphore->blockedThreadsHead) {
    80004828:	0084b783          	ld	a5,8(s1)
    8000482c:	02078463          	beqz	a5,80004854 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x48>
        TCB* unblockedThread = semaphore->unblockFirstThreadInList(); // odblokiranje svih niti koje cekaju na tekucem semaforu
    80004830:	00048513          	mv	a0,s1
    80004834:	00000097          	auipc	ra,0x0
    80004838:	f88080e7          	jalr	-120(ra) # 800047bc <_ZN15KernelSemaphore24unblockFirstThreadInListEv>
        if (unblockedThread) unblockedThread->setWaitSemaphoreFailed(true); // sem_wait sistemski poziv pozvan za sve ove niti treba da vrati gresku
    8000483c:	fe0506e3          	beqz	a0,80004828 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x1c>
    void setWaitSemaphoreFailed(bool value) { waitSemaphoreFailed = value; }
    80004840:	00100793          	li	a5,1
    80004844:	06f50423          	sb	a5,104(a0)
    80004848:	fe1ff06f          	j	80004828 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x1c>
    if (!semaphore) return -1;
    8000484c:	fff00513          	li	a0,-1
    80004850:	0080006f          	j	80004858 <_ZN15KernelSemaphore14closeSemaphoreEPS_+0x4c>
    return 0;
    80004854:	00000513          	li	a0,0
}
    80004858:	01813083          	ld	ra,24(sp)
    8000485c:	01013403          	ld	s0,16(sp)
    80004860:	00813483          	ld	s1,8(sp)
    80004864:	02010113          	addi	sp,sp,32
    80004868:	00008067          	ret

000000008000486c <_ZN15KernelSemaphoreD1Ev>:
KernelSemaphore::~KernelSemaphore() {
    8000486c:	ff010113          	addi	sp,sp,-16
    80004870:	00113423          	sd	ra,8(sp)
    80004874:	00813023          	sd	s0,0(sp)
    80004878:	01010413          	addi	s0,sp,16
    KernelSemaphore::closeSemaphore(this);
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	f90080e7          	jalr	-112(ra) # 8000480c <_ZN15KernelSemaphore14closeSemaphoreEPS_>
}
    80004884:	00813083          	ld	ra,8(sp)
    80004888:	00013403          	ld	s0,0(sp)
    8000488c:	01010113          	addi	sp,sp,16
    80004890:	00008067          	ret

0000000080004894 <_ZN15KernelSemaphore6signalEv>:
    if (++semaphoreValue <= 0) {
    80004894:	00052783          	lw	a5,0(a0)
    80004898:	0017879b          	addiw	a5,a5,1
    8000489c:	0007871b          	sext.w	a4,a5
    800048a0:	00f52023          	sw	a5,0(a0)
    800048a4:	00e05463          	blez	a4,800048ac <_ZN15KernelSemaphore6signalEv+0x18>
    800048a8:	00008067          	ret
void KernelSemaphore::signal() {
    800048ac:	ff010113          	addi	sp,sp,-16
    800048b0:	00113423          	sd	ra,8(sp)
    800048b4:	00813023          	sd	s0,0(sp)
    800048b8:	01010413          	addi	s0,sp,16
        unblockFirstThreadInList();
    800048bc:	00000097          	auipc	ra,0x0
    800048c0:	f00080e7          	jalr	-256(ra) # 800047bc <_ZN15KernelSemaphore24unblockFirstThreadInListEv>
}
    800048c4:	00813083          	ld	ra,8(sp)
    800048c8:	00013403          	ld	s0,0(sp)
    800048cc:	01010113          	addi	sp,sp,16
    800048d0:	00008067          	ret

00000000800048d4 <_ZN6BufferC1Ei>:
#include "../h/Z_Njihovo_Buffer.hpp"

Buffer::Buffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    800048d4:	fe010113          	addi	sp,sp,-32
    800048d8:	00113c23          	sd	ra,24(sp)
    800048dc:	00813823          	sd	s0,16(sp)
    800048e0:	00913423          	sd	s1,8(sp)
    800048e4:	01213023          	sd	s2,0(sp)
    800048e8:	02010413          	addi	s0,sp,32
    800048ec:	00050493          	mv	s1,a0
    800048f0:	00058913          	mv	s2,a1
    800048f4:	0015879b          	addiw	a5,a1,1
    800048f8:	0007851b          	sext.w	a0,a5
    800048fc:	00f4a023          	sw	a5,0(s1)
    80004900:	0004a823          	sw	zero,16(s1)
    80004904:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    80004908:	00251513          	slli	a0,a0,0x2
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	a14080e7          	jalr	-1516(ra) # 80001320 <_Z9mem_allocm>
    80004914:	00a4b423          	sd	a0,8(s1)
    sem_open(&itemAvailable, 0);
    80004918:	00000593          	li	a1,0
    8000491c:	02048513          	addi	a0,s1,32
    80004920:	ffffd097          	auipc	ra,0xffffd
    80004924:	d70080e7          	jalr	-656(ra) # 80001690 <_Z8sem_openPP4_semj>
    sem_open(&spaceAvailable, _cap);
    80004928:	00090593          	mv	a1,s2
    8000492c:	01848513          	addi	a0,s1,24
    80004930:	ffffd097          	auipc	ra,0xffffd
    80004934:	d60080e7          	jalr	-672(ra) # 80001690 <_Z8sem_openPP4_semj>
    sem_open(&mutexHead, 1);
    80004938:	00100593          	li	a1,1
    8000493c:	02848513          	addi	a0,s1,40
    80004940:	ffffd097          	auipc	ra,0xffffd
    80004944:	d50080e7          	jalr	-688(ra) # 80001690 <_Z8sem_openPP4_semj>
    sem_open(&mutexTail, 1);
    80004948:	00100593          	li	a1,1
    8000494c:	03048513          	addi	a0,s1,48
    80004950:	ffffd097          	auipc	ra,0xffffd
    80004954:	d40080e7          	jalr	-704(ra) # 80001690 <_Z8sem_openPP4_semj>
}
    80004958:	01813083          	ld	ra,24(sp)
    8000495c:	01013403          	ld	s0,16(sp)
    80004960:	00813483          	ld	s1,8(sp)
    80004964:	00013903          	ld	s2,0(sp)
    80004968:	02010113          	addi	sp,sp,32
    8000496c:	00008067          	ret

0000000080004970 <_ZN6Buffer3putEi>:
    sem_close(spaceAvailable);
    sem_close(mutexTail);
    sem_close(mutexHead);
}

void Buffer::put(int val) {
    80004970:	fe010113          	addi	sp,sp,-32
    80004974:	00113c23          	sd	ra,24(sp)
    80004978:	00813823          	sd	s0,16(sp)
    8000497c:	00913423          	sd	s1,8(sp)
    80004980:	01213023          	sd	s2,0(sp)
    80004984:	02010413          	addi	s0,sp,32
    80004988:	00050493          	mv	s1,a0
    8000498c:	00058913          	mv	s2,a1
    sem_wait(spaceAvailable);
    80004990:	01853503          	ld	a0,24(a0)
    80004994:	ffffd097          	auipc	ra,0xffffd
    80004998:	dcc080e7          	jalr	-564(ra) # 80001760 <_Z8sem_waitP4_sem>

    sem_wait(mutexTail);
    8000499c:	0304b503          	ld	a0,48(s1)
    800049a0:	ffffd097          	auipc	ra,0xffffd
    800049a4:	dc0080e7          	jalr	-576(ra) # 80001760 <_Z8sem_waitP4_sem>
    buffer[tail] = val;
    800049a8:	0084b783          	ld	a5,8(s1)
    800049ac:	0144a703          	lw	a4,20(s1)
    800049b0:	00271713          	slli	a4,a4,0x2
    800049b4:	00e787b3          	add	a5,a5,a4
    800049b8:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    800049bc:	0144a783          	lw	a5,20(s1)
    800049c0:	0017879b          	addiw	a5,a5,1
    800049c4:	0004a703          	lw	a4,0(s1)
    800049c8:	02e7e7bb          	remw	a5,a5,a4
    800049cc:	00f4aa23          	sw	a5,20(s1)
    sem_signal(mutexTail);
    800049d0:	0304b503          	ld	a0,48(s1)
    800049d4:	ffffd097          	auipc	ra,0xffffd
    800049d8:	de4080e7          	jalr	-540(ra) # 800017b8 <_Z10sem_signalP4_sem>

    sem_signal(itemAvailable);
    800049dc:	0204b503          	ld	a0,32(s1)
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	dd8080e7          	jalr	-552(ra) # 800017b8 <_Z10sem_signalP4_sem>

}
    800049e8:	01813083          	ld	ra,24(sp)
    800049ec:	01013403          	ld	s0,16(sp)
    800049f0:	00813483          	ld	s1,8(sp)
    800049f4:	00013903          	ld	s2,0(sp)
    800049f8:	02010113          	addi	sp,sp,32
    800049fc:	00008067          	ret

0000000080004a00 <_ZN6Buffer3getEv>:

int Buffer::get() {
    80004a00:	fe010113          	addi	sp,sp,-32
    80004a04:	00113c23          	sd	ra,24(sp)
    80004a08:	00813823          	sd	s0,16(sp)
    80004a0c:	00913423          	sd	s1,8(sp)
    80004a10:	01213023          	sd	s2,0(sp)
    80004a14:	02010413          	addi	s0,sp,32
    80004a18:	00050493          	mv	s1,a0
    sem_wait(itemAvailable);
    80004a1c:	02053503          	ld	a0,32(a0)
    80004a20:	ffffd097          	auipc	ra,0xffffd
    80004a24:	d40080e7          	jalr	-704(ra) # 80001760 <_Z8sem_waitP4_sem>

    sem_wait(mutexHead);
    80004a28:	0284b503          	ld	a0,40(s1)
    80004a2c:	ffffd097          	auipc	ra,0xffffd
    80004a30:	d34080e7          	jalr	-716(ra) # 80001760 <_Z8sem_waitP4_sem>

    int ret = buffer[head];
    80004a34:	0084b703          	ld	a4,8(s1)
    80004a38:	0104a783          	lw	a5,16(s1)
    80004a3c:	00279693          	slli	a3,a5,0x2
    80004a40:	00d70733          	add	a4,a4,a3
    80004a44:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    80004a48:	0017879b          	addiw	a5,a5,1
    80004a4c:	0004a703          	lw	a4,0(s1)
    80004a50:	02e7e7bb          	remw	a5,a5,a4
    80004a54:	00f4a823          	sw	a5,16(s1)
    sem_signal(mutexHead);
    80004a58:	0284b503          	ld	a0,40(s1)
    80004a5c:	ffffd097          	auipc	ra,0xffffd
    80004a60:	d5c080e7          	jalr	-676(ra) # 800017b8 <_Z10sem_signalP4_sem>

    sem_signal(spaceAvailable);
    80004a64:	0184b503          	ld	a0,24(s1)
    80004a68:	ffffd097          	auipc	ra,0xffffd
    80004a6c:	d50080e7          	jalr	-688(ra) # 800017b8 <_Z10sem_signalP4_sem>

    return ret;
}
    80004a70:	00090513          	mv	a0,s2
    80004a74:	01813083          	ld	ra,24(sp)
    80004a78:	01013403          	ld	s0,16(sp)
    80004a7c:	00813483          	ld	s1,8(sp)
    80004a80:	00013903          	ld	s2,0(sp)
    80004a84:	02010113          	addi	sp,sp,32
    80004a88:	00008067          	ret

0000000080004a8c <_ZN6Buffer6getCntEv>:

int Buffer::getCnt() {
    80004a8c:	fe010113          	addi	sp,sp,-32
    80004a90:	00113c23          	sd	ra,24(sp)
    80004a94:	00813823          	sd	s0,16(sp)
    80004a98:	00913423          	sd	s1,8(sp)
    80004a9c:	01213023          	sd	s2,0(sp)
    80004aa0:	02010413          	addi	s0,sp,32
    80004aa4:	00050493          	mv	s1,a0
    int ret;

    sem_wait(mutexHead);
    80004aa8:	02853503          	ld	a0,40(a0)
    80004aac:	ffffd097          	auipc	ra,0xffffd
    80004ab0:	cb4080e7          	jalr	-844(ra) # 80001760 <_Z8sem_waitP4_sem>
    sem_wait(mutexTail);
    80004ab4:	0304b503          	ld	a0,48(s1)
    80004ab8:	ffffd097          	auipc	ra,0xffffd
    80004abc:	ca8080e7          	jalr	-856(ra) # 80001760 <_Z8sem_waitP4_sem>

    if (tail >= head) {
    80004ac0:	0144a783          	lw	a5,20(s1)
    80004ac4:	0104a903          	lw	s2,16(s1)
    80004ac8:	0327ce63          	blt	a5,s2,80004b04 <_ZN6Buffer6getCntEv+0x78>
        ret = tail - head;
    80004acc:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    sem_signal(mutexTail);
    80004ad0:	0304b503          	ld	a0,48(s1)
    80004ad4:	ffffd097          	auipc	ra,0xffffd
    80004ad8:	ce4080e7          	jalr	-796(ra) # 800017b8 <_Z10sem_signalP4_sem>
    sem_signal(mutexHead);
    80004adc:	0284b503          	ld	a0,40(s1)
    80004ae0:	ffffd097          	auipc	ra,0xffffd
    80004ae4:	cd8080e7          	jalr	-808(ra) # 800017b8 <_Z10sem_signalP4_sem>

    return ret;
}
    80004ae8:	00090513          	mv	a0,s2
    80004aec:	01813083          	ld	ra,24(sp)
    80004af0:	01013403          	ld	s0,16(sp)
    80004af4:	00813483          	ld	s1,8(sp)
    80004af8:	00013903          	ld	s2,0(sp)
    80004afc:	02010113          	addi	sp,sp,32
    80004b00:	00008067          	ret
        ret = cap - head + tail;
    80004b04:	0004a703          	lw	a4,0(s1)
    80004b08:	4127093b          	subw	s2,a4,s2
    80004b0c:	00f9093b          	addw	s2,s2,a5
    80004b10:	fc1ff06f          	j	80004ad0 <_ZN6Buffer6getCntEv+0x44>

0000000080004b14 <_ZN6BufferD1Ev>:
Buffer::~Buffer() {
    80004b14:	fe010113          	addi	sp,sp,-32
    80004b18:	00113c23          	sd	ra,24(sp)
    80004b1c:	00813823          	sd	s0,16(sp)
    80004b20:	00913423          	sd	s1,8(sp)
    80004b24:	02010413          	addi	s0,sp,32
    80004b28:	00050493          	mv	s1,a0
    putc('\n');
    80004b2c:	00a00513          	li	a0,10
    80004b30:	ffffd097          	auipc	ra,0xffffd
    80004b34:	d98080e7          	jalr	-616(ra) # 800018c8 <_Z4putcc>
    printString("Buffer deleted!\n");
    80004b38:	00003517          	auipc	a0,0x3
    80004b3c:	4e850513          	addi	a0,a0,1256 # 80008020 <CONSOLE_STATUS+0x10>
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	80c080e7          	jalr	-2036(ra) # 8000234c <_Z11printStringPKc>
    while (getCnt() > 0) {
    80004b48:	00048513          	mv	a0,s1
    80004b4c:	00000097          	auipc	ra,0x0
    80004b50:	f40080e7          	jalr	-192(ra) # 80004a8c <_ZN6Buffer6getCntEv>
    80004b54:	02a05c63          	blez	a0,80004b8c <_ZN6BufferD1Ev+0x78>
        char ch = buffer[head];
    80004b58:	0084b783          	ld	a5,8(s1)
    80004b5c:	0104a703          	lw	a4,16(s1)
    80004b60:	00271713          	slli	a4,a4,0x2
    80004b64:	00e787b3          	add	a5,a5,a4
        putc(ch);
    80004b68:	0007c503          	lbu	a0,0(a5)
    80004b6c:	ffffd097          	auipc	ra,0xffffd
    80004b70:	d5c080e7          	jalr	-676(ra) # 800018c8 <_Z4putcc>
        head = (head + 1) % cap;
    80004b74:	0104a783          	lw	a5,16(s1)
    80004b78:	0017879b          	addiw	a5,a5,1
    80004b7c:	0004a703          	lw	a4,0(s1)
    80004b80:	02e7e7bb          	remw	a5,a5,a4
    80004b84:	00f4a823          	sw	a5,16(s1)
    while (getCnt() > 0) {
    80004b88:	fc1ff06f          	j	80004b48 <_ZN6BufferD1Ev+0x34>
    putc('!');
    80004b8c:	02100513          	li	a0,33
    80004b90:	ffffd097          	auipc	ra,0xffffd
    80004b94:	d38080e7          	jalr	-712(ra) # 800018c8 <_Z4putcc>
    putc('\n');
    80004b98:	00a00513          	li	a0,10
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	d2c080e7          	jalr	-724(ra) # 800018c8 <_Z4putcc>
    mem_free(buffer);
    80004ba4:	0084b503          	ld	a0,8(s1)
    80004ba8:	ffffc097          	auipc	ra,0xffffc
    80004bac:	7dc080e7          	jalr	2012(ra) # 80001384 <_Z8mem_freePv>
    sem_close(itemAvailable);
    80004bb0:	0204b503          	ld	a0,32(s1)
    80004bb4:	ffffd097          	auipc	ra,0xffffd
    80004bb8:	b54080e7          	jalr	-1196(ra) # 80001708 <_Z9sem_closeP4_sem>
    sem_close(spaceAvailable);
    80004bbc:	0184b503          	ld	a0,24(s1)
    80004bc0:	ffffd097          	auipc	ra,0xffffd
    80004bc4:	b48080e7          	jalr	-1208(ra) # 80001708 <_Z9sem_closeP4_sem>
    sem_close(mutexTail);
    80004bc8:	0304b503          	ld	a0,48(s1)
    80004bcc:	ffffd097          	auipc	ra,0xffffd
    80004bd0:	b3c080e7          	jalr	-1220(ra) # 80001708 <_Z9sem_closeP4_sem>
    sem_close(mutexHead);
    80004bd4:	0284b503          	ld	a0,40(s1)
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	b30080e7          	jalr	-1232(ra) # 80001708 <_Z9sem_closeP4_sem>
}
    80004be0:	01813083          	ld	ra,24(sp)
    80004be4:	01013403          	ld	s0,16(sp)
    80004be8:	00813483          	ld	s1,8(sp)
    80004bec:	02010113          	addi	sp,sp,32
    80004bf0:	00008067          	ret

0000000080004bf4 <_ZN3TCB13threadWrapperEv>:
    TCB* oldThread = TCB::runningThread;
    TCB::runningThread = Scheduler::getInstance().get();
    TCB::contextSwitch(&oldThread->context, &TCB::runningThread->context);
}

void TCB::threadWrapper() {
    80004bf4:	fe010113          	addi	sp,sp,-32
    80004bf8:	00113c23          	sd	ra,24(sp)
    80004bfc:	00813823          	sd	s0,16(sp)
    80004c00:	00913423          	sd	s1,8(sp)
    80004c04:	02010413          	addi	s0,sp,32
    Riscv::exitSupervisorTrap();
    80004c08:	00000097          	auipc	ra,0x0
    80004c0c:	5e0080e7          	jalr	1504(ra) # 800051e8 <_ZN5Riscv18exitSupervisorTrapEv>
    switchSupervisorToUser();
    80004c10:	ffffd097          	auipc	ra,0xffffd
    80004c14:	d08080e7          	jalr	-760(ra) # 80001918 <_Z22switchSupervisorToUserv>
    runningThread->body(runningThread->arg);
    80004c18:	00006497          	auipc	s1,0x6
    80004c1c:	d7048493          	addi	s1,s1,-656 # 8000a988 <_ZN3TCB13runningThreadE>
    80004c20:	0004b783          	ld	a5,0(s1)
    80004c24:	0007b703          	ld	a4,0(a5)
    80004c28:	0087b503          	ld	a0,8(a5)
    80004c2c:	000700e7          	jalr	a4
    if (!runningThread->getFinished()) {
    80004c30:	0004b783          	ld	a5,0(s1)
    bool getFinished() const { return finished; }
    80004c34:	0307c783          	lbu	a5,48(a5)
    80004c38:	00078c63          	beqz	a5,80004c50 <_ZN3TCB13threadWrapperEv+0x5c>
        thread_exit(); // sistemski poziv thread_exit za gasenje tekuce niti - unutar ovog poziva ce se promeniti i kontekst
    }
}
    80004c3c:	01813083          	ld	ra,24(sp)
    80004c40:	01013403          	ld	s0,16(sp)
    80004c44:	00813483          	ld	s1,8(sp)
    80004c48:	02010113          	addi	sp,sp,32
    80004c4c:	00008067          	ret
        thread_exit(); // sistemski poziv thread_exit za gasenje tekuce niti - unutar ovog poziva ce se promeniti i kontekst
    80004c50:	ffffd097          	auipc	ra,0xffffd
    80004c54:	838080e7          	jalr	-1992(ra) # 80001488 <_Z11thread_exitv>
}
    80004c58:	fe5ff06f          	j	80004c3c <_ZN3TCB13threadWrapperEv+0x48>

0000000080004c5c <_ZN3TCB17insertSleepThreadEm>:
void TCB::insertSleepThread(uint64 time) {
    80004c5c:	ff010113          	addi	sp,sp,-16
    80004c60:	00813423          	sd	s0,8(sp)
    80004c64:	01010413          	addi	s0,sp,16
    if (!sleepHead || !sleepTail) {
    80004c68:	00006797          	auipc	a5,0x6
    80004c6c:	d287b783          	ld	a5,-728(a5) # 8000a990 <_ZN3TCB9sleepHeadE>
    80004c70:	02078663          	beqz	a5,80004c9c <_ZN3TCB17insertSleepThreadEm+0x40>
    80004c74:	00006617          	auipc	a2,0x6
    80004c78:	d2463603          	ld	a2,-732(a2) # 8000a998 <_ZN3TCB9sleepTailE>
    80004c7c:	02060063          	beqz	a2,80004c9c <_ZN3TCB17insertSleepThreadEm+0x40>
    uint64 currSumOfSleepTimes = 0;
    80004c80:	00000713          	li	a4,0
    for (TCB* curr = sleepHead; curr; curr = curr->getNextSleepThread()) {
    80004c84:	08078063          	beqz	a5,80004d04 <_ZN3TCB17insertSleepThreadEm+0xa8>
    uint64 getSleepTime() const { return sleepTime; }
    80004c88:	0487b683          	ld	a3,72(a5)
        currSumOfSleepTimes += curr->getSleepTime();
    80004c8c:	00d70733          	add	a4,a4,a3
        if (time < currSumOfSleepTimes) {
    80004c90:	02e56463          	bltu	a0,a4,80004cb8 <_ZN3TCB17insertSleepThreadEm+0x5c>
    TCB* getNextSleepThread() const { return sleepNextThread; }
    80004c94:	0507b783          	ld	a5,80(a5)
    for (TCB* curr = sleepHead; curr; curr = curr->getNextSleepThread()) {
    80004c98:	fedff06f          	j	80004c84 <_ZN3TCB17insertSleepThreadEm+0x28>
        sleepHead = sleepTail = runningThread;
    80004c9c:	00006717          	auipc	a4,0x6
    80004ca0:	cec70713          	addi	a4,a4,-788 # 8000a988 <_ZN3TCB13runningThreadE>
    80004ca4:	00073783          	ld	a5,0(a4)
    80004ca8:	00f73823          	sd	a5,16(a4)
    80004cac:	00f73423          	sd	a5,8(a4)
    void setSleepTime(uint64 time) { sleepTime = time; }
    80004cb0:	04a7b423          	sd	a0,72(a5)
        return;
    80004cb4:	0700006f          	j	80004d24 <_ZN3TCB17insertSleepThreadEm+0xc8>
            runningThread->setNextSleepThread(curr);
    80004cb8:	00006697          	auipc	a3,0x6
    80004cbc:	cd06b683          	ld	a3,-816(a3) # 8000a988 <_ZN3TCB13runningThreadE>
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80004cc0:	04f6b823          	sd	a5,80(a3)
    TCB* getPrevSleepThread() const { return sleepPrevThread; }
    80004cc4:	0587b603          	ld	a2,88(a5)
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80004cc8:	04c6bc23          	sd	a2,88(a3)
            if (!curr->getPrevSleepThread()) {
    80004ccc:	02060063          	beqz	a2,80004cec <_ZN3TCB17insertSleepThreadEm+0x90>
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80004cd0:	04d63823          	sd	a3,80(a2)
    uint64 getSleepTime() const { return sleepTime; }
    80004cd4:	0487b603          	ld	a2,72(a5)
                runningThread->setSleepTime(time - (currSumOfSleepTimes - curr->getSleepTime()));
    80004cd8:	40e60733          	sub	a4,a2,a4
    80004cdc:	00a70733          	add	a4,a4,a0
    void setSleepTime(uint64 time) { sleepTime = time; }
    80004ce0:	04e6b423          	sd	a4,72(a3)
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80004ce4:	04d7bc23          	sd	a3,88(a5)
            return;
    80004ce8:	03c0006f          	j	80004d24 <_ZN3TCB17insertSleepThreadEm+0xc8>
    void setSleepTime(uint64 time) { sleepTime = time; }
    80004cec:	04a6b423          	sd	a0,72(a3)
                curr->setSleepTime(currSumOfSleepTimes - time);
    80004cf0:	40a70733          	sub	a4,a4,a0
    80004cf4:	04e7b423          	sd	a4,72(a5)
                sleepHead = runningThread;
    80004cf8:	00006717          	auipc	a4,0x6
    80004cfc:	c8d73c23          	sd	a3,-872(a4) # 8000a990 <_ZN3TCB9sleepHeadE>
    80004d00:	fe5ff06f          	j	80004ce4 <_ZN3TCB17insertSleepThreadEm+0x88>
    runningThread->setPrevSleepThread(sleepTail);
    80004d04:	00006697          	auipc	a3,0x6
    80004d08:	c8468693          	addi	a3,a3,-892 # 8000a988 <_ZN3TCB13runningThreadE>
    80004d0c:	0006b783          	ld	a5,0(a3)
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80004d10:	04c7bc23          	sd	a2,88(a5)
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80004d14:	04f63823          	sd	a5,80(a2)
    runningThread->setSleepTime(time - currSumOfSleepTimes);
    80004d18:	40e50733          	sub	a4,a0,a4
    void setSleepTime(uint64 time) { sleepTime = time; }
    80004d1c:	04e7b423          	sd	a4,72(a5)
    sleepTail = runningThread;
    80004d20:	00f6b823          	sd	a5,16(a3)
}
    80004d24:	00813403          	ld	s0,8(sp)
    80004d28:	01010113          	addi	sp,sp,16
    80004d2c:	00008067          	ret

0000000080004d30 <_ZN3TCB21updateSleepThreadListEv>:
void TCB::updateSleepThreadList() {
    80004d30:	fe010113          	addi	sp,sp,-32
    80004d34:	00113c23          	sd	ra,24(sp)
    80004d38:	00813823          	sd	s0,16(sp)
    80004d3c:	00913423          	sd	s1,8(sp)
    80004d40:	01213023          	sd	s2,0(sp)
    80004d44:	02010413          	addi	s0,sp,32
    if (!sleepHead || !sleepTail) return;
    80004d48:	00006497          	auipc	s1,0x6
    80004d4c:	c484b483          	ld	s1,-952(s1) # 8000a990 <_ZN3TCB9sleepHeadE>
    80004d50:	02048263          	beqz	s1,80004d74 <_ZN3TCB21updateSleepThreadListEv+0x44>
    80004d54:	00006797          	auipc	a5,0x6
    80004d58:	c447b783          	ld	a5,-956(a5) # 8000a998 <_ZN3TCB9sleepTailE>
    80004d5c:	00078c63          	beqz	a5,80004d74 <_ZN3TCB21updateSleepThreadListEv+0x44>
    uint64 getSleepTime() const { return sleepTime; }
    80004d60:	0484b783          	ld	a5,72(s1)
    sleepHead->setSleepTime(sleepHead->getSleepTime() - 1);
    80004d64:	fff78793          	addi	a5,a5,-1
    void setSleepTime(uint64 time) { sleepTime = time; }
    80004d68:	04f4b423          	sd	a5,72(s1)
    TCB* curr = sleepHead;
    80004d6c:	03c0006f          	j	80004da8 <_ZN3TCB21updateSleepThreadListEv+0x78>
    if (!curr) sleepHead = sleepTail = nullptr;
    80004d70:	04048e63          	beqz	s1,80004dcc <_ZN3TCB21updateSleepThreadListEv+0x9c>
}
    80004d74:	01813083          	ld	ra,24(sp)
    80004d78:	01013403          	ld	s0,16(sp)
    80004d7c:	00813483          	ld	s1,8(sp)
    80004d80:	00013903          	ld	s2,0(sp)
    80004d84:	02010113          	addi	sp,sp,32
    80004d88:	00008067          	ret
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    80004d8c:	0404b823          	sd	zero,80(s1)
        Scheduler::getInstance().put(oldCurr);
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	868080e7          	jalr	-1944(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    80004d98:	00048593          	mv	a1,s1
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	8a8080e7          	jalr	-1880(ra) # 80002644 <_ZN9Scheduler3putEP3TCB>
        curr = curr->getNextSleepThread();
    80004da4:	00090493          	mv	s1,s2
    while (curr && curr->getSleepTime() == 0) {
    80004da8:	fc0484e3          	beqz	s1,80004d70 <_ZN3TCB21updateSleepThreadListEv+0x40>
    uint64 getSleepTime() const { return sleepTime; }
    80004dac:	0484b783          	ld	a5,72(s1)
    80004db0:	fc0790e3          	bnez	a5,80004d70 <_ZN3TCB21updateSleepThreadListEv+0x40>
    TCB* getNextSleepThread() const { return sleepNextThread; }
    80004db4:	0504b903          	ld	s2,80(s1)
        sleepHead = curr;
    80004db8:	00006797          	auipc	a5,0x6
    80004dbc:	bd27bc23          	sd	s2,-1064(a5) # 8000a990 <_ZN3TCB9sleepHeadE>
        if (curr) curr->setPrevSleepThread(nullptr);
    80004dc0:	fc0906e3          	beqz	s2,80004d8c <_ZN3TCB21updateSleepThreadListEv+0x5c>
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    80004dc4:	04093c23          	sd	zero,88(s2)
    80004dc8:	fc5ff06f          	j	80004d8c <_ZN3TCB21updateSleepThreadListEv+0x5c>
    if (!curr) sleepHead = sleepTail = nullptr;
    80004dcc:	00006797          	auipc	a5,0x6
    80004dd0:	bbc78793          	addi	a5,a5,-1092 # 8000a988 <_ZN3TCB13runningThreadE>
    80004dd4:	0007b823          	sd	zero,16(a5)
    80004dd8:	0007b423          	sd	zero,8(a5)
    80004ddc:	f99ff06f          	j	80004d74 <_ZN3TCB21updateSleepThreadListEv+0x44>

0000000080004de0 <_ZN3TCBnwEm>:
void* TCB::operator new(size_t n) {
    80004de0:	fe010113          	addi	sp,sp,-32
    80004de4:	00113c23          	sd	ra,24(sp)
    80004de8:	00813823          	sd	s0,16(sp)
    80004dec:	00913423          	sd	s1,8(sp)
    80004df0:	02010413          	addi	s0,sp,32
    80004df4:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80004df8:	00001097          	auipc	ra,0x1
    80004dfc:	994080e7          	jalr	-1644(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004e00:	00048593          	mv	a1,s1
    80004e04:	00001097          	auipc	ra,0x1
    80004e08:	9e4080e7          	jalr	-1564(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
}
    80004e0c:	01813083          	ld	ra,24(sp)
    80004e10:	01013403          	ld	s0,16(sp)
    80004e14:	00813483          	ld	s1,8(sp)
    80004e18:	02010113          	addi	sp,sp,32
    80004e1c:	00008067          	ret

0000000080004e20 <_ZN3TCBnaEm>:
void* TCB::operator new[](size_t n) {
    80004e20:	fe010113          	addi	sp,sp,-32
    80004e24:	00113c23          	sd	ra,24(sp)
    80004e28:	00813823          	sd	s0,16(sp)
    80004e2c:	00913423          	sd	s1,8(sp)
    80004e30:	02010413          	addi	s0,sp,32
    80004e34:	00050493          	mv	s1,a0
    void* ptr = MemoryAllocator::getInstance().allocateSegment(n);
    80004e38:	00001097          	auipc	ra,0x1
    80004e3c:	954080e7          	jalr	-1708(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004e40:	00048593          	mv	a1,s1
    80004e44:	00001097          	auipc	ra,0x1
    80004e48:	9a4080e7          	jalr	-1628(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
}
    80004e4c:	01813083          	ld	ra,24(sp)
    80004e50:	01013403          	ld	s0,16(sp)
    80004e54:	00813483          	ld	s1,8(sp)
    80004e58:	02010113          	addi	sp,sp,32
    80004e5c:	00008067          	ret

0000000080004e60 <_ZN3TCBdlEPv>:
void TCB::operator delete(void *ptr) {
    80004e60:	fe010113          	addi	sp,sp,-32
    80004e64:	00113c23          	sd	ra,24(sp)
    80004e68:	00813823          	sd	s0,16(sp)
    80004e6c:	00913423          	sd	s1,8(sp)
    80004e70:	02010413          	addi	s0,sp,32
    80004e74:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80004e78:	00001097          	auipc	ra,0x1
    80004e7c:	914080e7          	jalr	-1772(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004e80:	00048593          	mv	a1,s1
    80004e84:	00001097          	auipc	ra,0x1
    80004e88:	a48080e7          	jalr	-1464(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80004e8c:	01813083          	ld	ra,24(sp)
    80004e90:	01013403          	ld	s0,16(sp)
    80004e94:	00813483          	ld	s1,8(sp)
    80004e98:	02010113          	addi	sp,sp,32
    80004e9c:	00008067          	ret

0000000080004ea0 <_ZN3TCBdaEPv>:
void TCB::operator delete[](void *ptr) {
    80004ea0:	fe010113          	addi	sp,sp,-32
    80004ea4:	00113c23          	sd	ra,24(sp)
    80004ea8:	00813823          	sd	s0,16(sp)
    80004eac:	00913423          	sd	s1,8(sp)
    80004eb0:	02010413          	addi	s0,sp,32
    80004eb4:	00050493          	mv	s1,a0
    MemoryAllocator::getInstance().deallocateSegment(ptr);
    80004eb8:	00001097          	auipc	ra,0x1
    80004ebc:	8d4080e7          	jalr	-1836(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80004ec0:	00048593          	mv	a1,s1
    80004ec4:	00001097          	auipc	ra,0x1
    80004ec8:	a08080e7          	jalr	-1528(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
}
    80004ecc:	01813083          	ld	ra,24(sp)
    80004ed0:	01013403          	ld	s0,16(sp)
    80004ed4:	00813483          	ld	s1,8(sp)
    80004ed8:	02010113          	addi	sp,sp,32
    80004edc:	00008067          	ret

0000000080004ee0 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_>:
void TCB::initializeClassAttributes(TCB* thisPointer, Body body, void* arg, void* stack) {
    80004ee0:	ff010113          	addi	sp,sp,-16
    80004ee4:	00813423          	sd	s0,8(sp)
    80004ee8:	01010413          	addi	s0,sp,16
    thisPointer->body = body;
    80004eec:	00b53023          	sd	a1,0(a0)
    thisPointer->arg = arg;
    80004ef0:	00c53423          	sd	a2,8(a0)
    thisPointer->stack = static_cast<uint64*>(stack);
    80004ef4:	00d53c23          	sd	a3,24(a0)
    thisPointer->context.ra = reinterpret_cast<uint64>(&threadWrapper);
    80004ef8:	00000797          	auipc	a5,0x0
    80004efc:	cfc78793          	addi	a5,a5,-772 # 80004bf4 <_ZN3TCB13threadWrapperEv>
    80004f00:	02f53023          	sd	a5,32(a0)
    thisPointer->context.sp = stack ? reinterpret_cast<uint64>(&static_cast<uint64*>(stack)[DEFAULT_STACK_SIZE / sizeof(uint64)]) : 0;
    80004f04:	02068c63          	beqz	a3,80004f3c <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_+0x5c>
    80004f08:	000017b7          	lui	a5,0x1
    80004f0c:	00f686b3          	add	a3,a3,a5
    80004f10:	02d53423          	sd	a3,40(a0)
    thisPointer->finished = false;
    80004f14:	02050823          	sb	zero,48(a0)
    thisPointer->threadId = TCB::staticThreadId++;
    80004f18:	00006717          	auipc	a4,0x6
    80004f1c:	a7070713          	addi	a4,a4,-1424 # 8000a988 <_ZN3TCB13runningThreadE>
    80004f20:	01872783          	lw	a5,24(a4)
    80004f24:	0017869b          	addiw	a3,a5,1
    80004f28:	00d72c23          	sw	a3,24(a4)
    80004f2c:	06f52623          	sw	a5,108(a0)
}
    80004f30:	00813403          	ld	s0,8(sp)
    80004f34:	01010113          	addi	sp,sp,16
    80004f38:	00008067          	ret
    thisPointer->context.sp = stack ? reinterpret_cast<uint64>(&static_cast<uint64*>(stack)[DEFAULT_STACK_SIZE / sizeof(uint64)]) : 0;
    80004f3c:	00000693          	li	a3,0
    80004f40:	fd1ff06f          	j	80004f10 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_+0x30>

0000000080004f44 <_ZN3TCBC1EPFvPvES0_S0_>:
TCB::TCB(Body body, void* arg, void* stack) {
    80004f44:	fe010113          	addi	sp,sp,-32
    80004f48:	00113c23          	sd	ra,24(sp)
    80004f4c:	00813823          	sd	s0,16(sp)
    80004f50:	00913423          	sd	s1,8(sp)
    80004f54:	01213023          	sd	s2,0(sp)
    80004f58:	02010413          	addi	s0,sp,32
    80004f5c:	00050493          	mv	s1,a0
    80004f60:	00058913          	mv	s2,a1
    80004f64:	00200793          	li	a5,2
    80004f68:	00f53823          	sd	a5,16(a0)
    80004f6c:	02053023          	sd	zero,32(a0)
    80004f70:	02053423          	sd	zero,40(a0)
    80004f74:	02053c23          	sd	zero,56(a0)
    80004f78:	04053023          	sd	zero,64(a0)
    80004f7c:	04053423          	sd	zero,72(a0)
    80004f80:	04053823          	sd	zero,80(a0)
    80004f84:	04053c23          	sd	zero,88(a0)
    80004f88:	06053023          	sd	zero,96(a0)
    80004f8c:	06050423          	sb	zero,104(a0)
    initializeClassAttributes(this, body, arg, stack);
    80004f90:	00000097          	auipc	ra,0x0
    80004f94:	f50080e7          	jalr	-176(ra) # 80004ee0 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_>
    if (body) Scheduler::getInstance().put(this);
    80004f98:	00090c63          	beqz	s2,80004fb0 <_ZN3TCBC1EPFvPvES0_S0_+0x6c>
    80004f9c:	ffffd097          	auipc	ra,0xffffd
    80004fa0:	65c080e7          	jalr	1628(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    80004fa4:	00048593          	mv	a1,s1
    80004fa8:	ffffd097          	auipc	ra,0xffffd
    80004fac:	69c080e7          	jalr	1692(ra) # 80002644 <_ZN9Scheduler3putEP3TCB>
}
    80004fb0:	01813083          	ld	ra,24(sp)
    80004fb4:	01013403          	ld	s0,16(sp)
    80004fb8:	00813483          	ld	s1,8(sp)
    80004fbc:	00013903          	ld	s2,0(sp)
    80004fc0:	02010113          	addi	sp,sp,32
    80004fc4:	00008067          	ret

0000000080004fc8 <_ZN3TCBC1EPFvPvES0_S0_b>:
TCB::TCB(Body body, void* arg, void* stack, bool cppApi) {
    80004fc8:	ff010113          	addi	sp,sp,-16
    80004fcc:	00113423          	sd	ra,8(sp)
    80004fd0:	00813023          	sd	s0,0(sp)
    80004fd4:	01010413          	addi	s0,sp,16
    80004fd8:	00200713          	li	a4,2
    80004fdc:	00e53823          	sd	a4,16(a0)
    80004fe0:	02053023          	sd	zero,32(a0)
    80004fe4:	02053423          	sd	zero,40(a0)
    80004fe8:	02053c23          	sd	zero,56(a0)
    80004fec:	04053023          	sd	zero,64(a0)
    80004ff0:	04053423          	sd	zero,72(a0)
    80004ff4:	04053823          	sd	zero,80(a0)
    80004ff8:	04053c23          	sd	zero,88(a0)
    80004ffc:	06053023          	sd	zero,96(a0)
    80005000:	06050423          	sb	zero,104(a0)
    initializeClassAttributes(this, body, arg, stack);
    80005004:	00000097          	auipc	ra,0x0
    80005008:	edc080e7          	jalr	-292(ra) # 80004ee0 <_ZN3TCB25initializeClassAttributesEPS_PFvPvES1_S1_>
}
    8000500c:	00813083          	ld	ra,8(sp)
    80005010:	00013403          	ld	s0,0(sp)
    80005014:	01010113          	addi	sp,sp,16
    80005018:	00008067          	ret

000000008000501c <_ZN3TCB12createThreadEPFvPvES0_S0_b>:
TCB* TCB::createThread(Body body, void* arg, void* stack, bool cppApi) {
    8000501c:	fc010113          	addi	sp,sp,-64
    80005020:	02113c23          	sd	ra,56(sp)
    80005024:	02813823          	sd	s0,48(sp)
    80005028:	02913423          	sd	s1,40(sp)
    8000502c:	03213023          	sd	s2,32(sp)
    80005030:	01313c23          	sd	s3,24(sp)
    80005034:	01413823          	sd	s4,16(sp)
    80005038:	01513423          	sd	s5,8(sp)
    8000503c:	04010413          	addi	s0,sp,64
    80005040:	00050993          	mv	s3,a0
    80005044:	00058a13          	mv	s4,a1
    80005048:	00060a93          	mv	s5,a2
    if (cppApi) {
    8000504c:	04068c63          	beqz	a3,800050a4 <_ZN3TCB12createThreadEPFvPvES0_S0_b+0x88>
    80005050:	00068493          	mv	s1,a3
        return new TCB(body, arg, stack, cppApi);
    80005054:	07000513          	li	a0,112
    80005058:	00000097          	auipc	ra,0x0
    8000505c:	d88080e7          	jalr	-632(ra) # 80004de0 <_ZN3TCBnwEm>
    80005060:	00050913          	mv	s2,a0
    80005064:	00048713          	mv	a4,s1
    80005068:	000a8693          	mv	a3,s5
    8000506c:	000a0613          	mv	a2,s4
    80005070:	00098593          	mv	a1,s3
    80005074:	00000097          	auipc	ra,0x0
    80005078:	f54080e7          	jalr	-172(ra) # 80004fc8 <_ZN3TCBC1EPFvPvES0_S0_b>
}
    8000507c:	00090513          	mv	a0,s2
    80005080:	03813083          	ld	ra,56(sp)
    80005084:	03013403          	ld	s0,48(sp)
    80005088:	02813483          	ld	s1,40(sp)
    8000508c:	02013903          	ld	s2,32(sp)
    80005090:	01813983          	ld	s3,24(sp)
    80005094:	01013a03          	ld	s4,16(sp)
    80005098:	00813a83          	ld	s5,8(sp)
    8000509c:	04010113          	addi	sp,sp,64
    800050a0:	00008067          	ret
        return new TCB(body, arg, stack);
    800050a4:	07000513          	li	a0,112
    800050a8:	00000097          	auipc	ra,0x0
    800050ac:	d38080e7          	jalr	-712(ra) # 80004de0 <_ZN3TCBnwEm>
    800050b0:	00050913          	mv	s2,a0
    800050b4:	000a8693          	mv	a3,s5
    800050b8:	000a0613          	mv	a2,s4
    800050bc:	00098593          	mv	a1,s3
    800050c0:	00000097          	auipc	ra,0x0
    800050c4:	e84080e7          	jalr	-380(ra) # 80004f44 <_ZN3TCBC1EPFvPvES0_S0_>
    800050c8:	fb5ff06f          	j	8000507c <_ZN3TCB12createThreadEPFvPvES0_S0_b+0x60>
    800050cc:	00050493          	mv	s1,a0
    800050d0:	00090513          	mv	a0,s2
    800050d4:	00000097          	auipc	ra,0x0
    800050d8:	d8c080e7          	jalr	-628(ra) # 80004e60 <_ZN3TCBdlEPv>
    800050dc:	00048513          	mv	a0,s1
    800050e0:	00007097          	auipc	ra,0x7
    800050e4:	9b8080e7          	jalr	-1608(ra) # 8000ba98 <_Unwind_Resume>

00000000800050e8 <_ZN3TCB13contextSwitchEPNS_7ContextES1_>:

void TCB::contextSwitch(TCB::Context *oldContext, TCB::Context *runningContext) {
    800050e8:	ff010113          	addi	sp,sp,-16
    800050ec:	00813423          	sd	s0,8(sp)
    800050f0:	01010413          	addi	s0,sp,16
    // prvi parametar funkcije (pokazivac na strukturu stare niti - oldContext) se prosledjuje kroz registar a0
    // cuvanje registara ra i sp tekuce niti u njenoj strukturi
    __asm__ volatile ("sd ra, 0*8(a0)");
    800050f4:	00153023          	sd	ra,0(a0)
    __asm__ volatile ("sd sp, 1*8(a0)");
    800050f8:	00253423          	sd	sp,8(a0)

    // drugi parametar funkcije (pokazivac na strukturu nove niti - runningContext) se prosledjuje kroz registar a1
    // restauracija registara ra i sp nove niti iz njene strukture
    __asm__ volatile ("ld ra, 0*8(a1)");
    800050fc:	0005b083          	ld	ra,0(a1)
    __asm__ volatile ("ld sp, 1*8(a1)");
    80005100:	0085b103          	ld	sp,8(a1)
    80005104:	00813403          	ld	s0,8(sp)
    80005108:	01010113          	addi	sp,sp,16
    8000510c:	00008067          	ret

0000000080005110 <_ZN3TCB8dispatchEv>:
void TCB::dispatch() {
    80005110:	fe010113          	addi	sp,sp,-32
    80005114:	00113c23          	sd	ra,24(sp)
    80005118:	00813823          	sd	s0,16(sp)
    8000511c:	00913423          	sd	s1,8(sp)
    80005120:	02010413          	addi	s0,sp,32
    TCB* oldThread = runningThread;
    80005124:	00006497          	auipc	s1,0x6
    80005128:	8644b483          	ld	s1,-1948(s1) # 8000a988 <_ZN3TCB13runningThreadE>
    bool getFinished() const { return finished; }
    8000512c:	0304c783          	lbu	a5,48(s1)
    if (!oldThread->getFinished()) Scheduler::getInstance().put(oldThread);
    80005130:	04078063          	beqz	a5,80005170 <_ZN3TCB8dispatchEv+0x60>
    runningThread = Scheduler::getInstance().get();
    80005134:	ffffd097          	auipc	ra,0xffffd
    80005138:	4c4080e7          	jalr	1220(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	4dc080e7          	jalr	1244(ra) # 80002618 <_ZN9Scheduler3getEv>
    80005144:	00006797          	auipc	a5,0x6
    80005148:	84a7b223          	sd	a0,-1980(a5) # 8000a988 <_ZN3TCB13runningThreadE>
    TCB::contextSwitch(&oldThread->context, &runningThread->context);
    8000514c:	02050593          	addi	a1,a0,32
    80005150:	02048513          	addi	a0,s1,32
    80005154:	00000097          	auipc	ra,0x0
    80005158:	f94080e7          	jalr	-108(ra) # 800050e8 <_ZN3TCB13contextSwitchEPNS_7ContextES1_>
}
    8000515c:	01813083          	ld	ra,24(sp)
    80005160:	01013403          	ld	s0,16(sp)
    80005164:	00813483          	ld	s1,8(sp)
    80005168:	02010113          	addi	sp,sp,32
    8000516c:	00008067          	ret
    if (!oldThread->getFinished()) Scheduler::getInstance().put(oldThread);
    80005170:	ffffd097          	auipc	ra,0xffffd
    80005174:	488080e7          	jalr	1160(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    80005178:	00048593          	mv	a1,s1
    8000517c:	ffffd097          	auipc	ra,0xffffd
    80005180:	4c8080e7          	jalr	1224(ra) # 80002644 <_ZN9Scheduler3putEP3TCB>
    80005184:	fb1ff06f          	j	80005134 <_ZN3TCB8dispatchEv+0x24>

0000000080005188 <_ZN3TCB20suspendCurrentThreadEv>:
void TCB::suspendCurrentThread() {
    80005188:	fe010113          	addi	sp,sp,-32
    8000518c:	00113c23          	sd	ra,24(sp)
    80005190:	00813823          	sd	s0,16(sp)
    80005194:	00913423          	sd	s1,8(sp)
    80005198:	01213023          	sd	s2,0(sp)
    8000519c:	02010413          	addi	s0,sp,32
    TCB* oldThread = TCB::runningThread;
    800051a0:	00005497          	auipc	s1,0x5
    800051a4:	7e848493          	addi	s1,s1,2024 # 8000a988 <_ZN3TCB13runningThreadE>
    800051a8:	0004b903          	ld	s2,0(s1)
    TCB::runningThread = Scheduler::getInstance().get();
    800051ac:	ffffd097          	auipc	ra,0xffffd
    800051b0:	44c080e7          	jalr	1100(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    800051b4:	ffffd097          	auipc	ra,0xffffd
    800051b8:	464080e7          	jalr	1124(ra) # 80002618 <_ZN9Scheduler3getEv>
    800051bc:	00a4b023          	sd	a0,0(s1)
    TCB::contextSwitch(&oldThread->context, &TCB::runningThread->context);
    800051c0:	02050593          	addi	a1,a0,32
    800051c4:	02090513          	addi	a0,s2,32
    800051c8:	00000097          	auipc	ra,0x0
    800051cc:	f20080e7          	jalr	-224(ra) # 800050e8 <_ZN3TCB13contextSwitchEPNS_7ContextES1_>
}
    800051d0:	01813083          	ld	ra,24(sp)
    800051d4:	01013403          	ld	s0,16(sp)
    800051d8:	00813483          	ld	s1,8(sp)
    800051dc:	00013903          	ld	s2,0(sp)
    800051e0:	02010113          	addi	sp,sp,32
    800051e4:	00008067          	ret

00000000800051e8 <_ZN5Riscv18exitSupervisorTrapEv>:
#include "../lib/console.h"
#include "../h/TCB.hpp"
#include "../h/KernelSemaphore.hpp"
#include "../h/KernelBuffer.hpp"

void Riscv::exitSupervisorTrap() {
    800051e8:	ff010113          	addi	sp,sp,-16
    800051ec:	00813423          	sd	s0,8(sp)
    800051f0:	01010413          	addi	s0,sp,16
    __asm__ volatile ("csrw sepc, ra"); // u sepc postavljamo vrednost ra jer hocemo da se tu vratimo nakon sret koji cemo pozvati
    800051f4:	14109073          	csrw	sepc,ra
    __asm__ volatile ("sret");
    800051f8:	10200073          	sret
    // sret instrukcija radi sledece:
    // prelazi se u rezim koji pise u SPP, u pc se upisuje vrednost iz sepc i u bit SIE sstatus registra se upisuje vrednost bita SPIE
}
    800051fc:	00813403          	ld	s0,8(sp)
    80005200:	01010113          	addi	sp,sp,16
    80005204:	00008067          	ret

0000000080005208 <_ZN5Riscv20handleSupervisorTrapEv>:

void Riscv::handleSupervisorTrap() {
    80005208:	f4010113          	addi	sp,sp,-192
    8000520c:	0a113c23          	sd	ra,184(sp)
    80005210:	0a813823          	sd	s0,176(sp)
    80005214:	0a913423          	sd	s1,168(sp)
    80005218:	0b213023          	sd	s2,160(sp)
    8000521c:	0c010413          	addi	s0,sp,192

    // alokacija prostora na steku za registre a0-a7; hocemo na steku da ih sacuvamo jer su to parametri sistemskih poziva a kompajler moze da ih uprlja
    __asm__ volatile ("addi sp,sp,-64");
    80005220:	fc010113          	addi	sp,sp,-64
    // cuvanje registara a0-a7 na steku
    pushSysCallParameters();
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	dfc080e7          	jalr	-516(ra) # 80001020 <_ZN5Riscv21pushSysCallParametersEv>
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    8000522c:	142027f3          	csrr	a5,scause
    80005230:	f8f43023          	sd	a5,-128(s0)
    return scause;
    80005234:	f8043783          	ld	a5,-128(s0)

    // citanje razloga ulaska u prekidnu rutinu i smestanje u promenljivu scause
    uint64 volatile scause = readScause();
    80005238:	fcf43c23          	sd	a5,-40(s0)

    if (scause == 0x0000000000000008UL || scause == 0x0000000000000009UL) {
    8000523c:	fd843703          	ld	a4,-40(s0)
    80005240:	00800793          	li	a5,8
    80005244:	08f70463          	beq	a4,a5,800052cc <_ZN5Riscv20handleSupervisorTrapEv+0xc4>
    80005248:	fd843703          	ld	a4,-40(s0)
    8000524c:	00900793          	li	a5,9
    80005250:	06f70e63          	beq	a4,a5,800052cc <_ZN5Riscv20handleSupervisorTrapEv+0xc4>
        writeSepc(sepc);
        if (sysCallCode != 0x50 && sysCallCode != 0x51) {
            writeSstatus(sstatus);
        }

    } else if (scause == 0x0000000000000002UL) {
    80005254:	fd843703          	ld	a4,-40(s0)
    80005258:	00200793          	li	a5,2
    8000525c:	38f70663          	beq	a4,a5,800055e8 <_ZN5Riscv20handleSupervisorTrapEv+0x3e0>
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: ilegalna instrukcija

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x0000000000000005UL) {
    80005260:	fd843703          	ld	a4,-40(s0)
    80005264:	00500793          	li	a5,5
    80005268:	3af70463          	beq	a4,a5,80005610 <_ZN5Riscv20handleSupervisorTrapEv+0x408>
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: nedozvoljena adresa citanja

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x0000000000000007UL) {
    8000526c:	fd843703          	ld	a4,-40(s0)
    80005270:	00700793          	li	a5,7
    80005274:	3cf70263          	beq	a4,a5,80005638 <_ZN5Riscv20handleSupervisorTrapEv+0x430>
        // spoljasnji prekid (tajmer ili konzola): ne; razlog prekida: nedozvoljena adresa upisa

        printErrorMessage(scause, readStval(), readSepc());
    } else if (scause == 0x8000000000000001UL) {
    80005278:	fd843703          	ld	a4,-40(s0)
    8000527c:	fff00793          	li	a5,-1
    80005280:	03f79793          	slli	a5,a5,0x3f
    80005284:	00178793          	addi	a5,a5,1
    80005288:	3cf70c63          	beq	a4,a5,80005660 <_ZN5Riscv20handleSupervisorTrapEv+0x458>
            TCB::dispatch(); // promena konteksta
            writeSepc(sepc);
            writeSstatus(sstatus);
        }

    } else if (scause == 0x8000000000000009UL) {
    8000528c:	fd843703          	ld	a4,-40(s0)
    80005290:	fff00793          	li	a5,-1
    80005294:	03f79793          	slli	a5,a5,0x3f
    80005298:	00978793          	addi	a5,a5,9
    8000529c:	18f71063          	bne	a4,a5,8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
        // spoljasnji prekid (tajmer ili konzola): da; razlog prekida: spoljasnji hardverski prekid od konzole

        // od kontrolera prekida saznajemo koji uredjaj je generisao prekid pozivajuci funkciju plic_claim
        int externalInterruptCode = plic_claim();
    800052a0:	00001097          	auipc	ra,0x1
    800052a4:	144080e7          	jalr	324(ra) # 800063e4 <plic_claim>
    800052a8:	00050913          	mv	s2,a0

        if (externalInterruptCode == CONSOLE_IRQ) {
    800052ac:	00a00793          	li	a5,10
    800052b0:	42f50863          	beq	a0,a5,800056e0 <_ZN5Riscv20handleSupervisorTrapEv+0x4d8>
            }

        }

        // kontroler prekida se obavestava da je prekid obradjen
        plic_complete(externalInterruptCode);
    800052b4:	00090513          	mv	a0,s2
    800052b8:	00001097          	auipc	ra,0x1
    800052bc:	164080e7          	jalr	356(ra) # 8000641c <plic_complete>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    800052c0:	20000793          	li	a5,512
    800052c4:	1447b073          	csrc	sip,a5
}
    800052c8:	1540006f          	j	8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800052cc:	141027f3          	csrr	a5,sepc
    800052d0:	f8f43823          	sd	a5,-112(s0)
    return sepc;
    800052d4:	f9043783          	ld	a5,-112(s0)
        uint64 volatile sepc = readSepc() + 4;
    800052d8:	00478793          	addi	a5,a5,4
    800052dc:	f4f43423          	sd	a5,-184(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    800052e0:	100027f3          	csrr	a5,sstatus
    800052e4:	f8f43423          	sd	a5,-120(s0)
    return sstatus;
    800052e8:	f8843783          	ld	a5,-120(s0)
        uint64 volatile sstatus = readSstatus();
    800052ec:	f4f43823          	sd	a5,-176(s0)
        __asm__ volatile ("ld %[sysCallCode],0(sp)" : [sysCallCode] "=r"(sysCallCode));
    800052f0:	00013783          	ld	a5,0(sp)
    800052f4:	f4f43c23          	sd	a5,-168(s0)
        if (sysCallCode == 0x01) {
    800052f8:	f5843703          	ld	a4,-168(s0)
    800052fc:	00100793          	li	a5,1
    80005300:	0cf70863          	beq	a4,a5,800053d0 <_ZN5Riscv20handleSupervisorTrapEv+0x1c8>
        } else if (sysCallCode == 0x02) {
    80005304:	f5843703          	ld	a4,-168(s0)
    80005308:	00200793          	li	a5,2
    8000530c:	12f70663          	beq	a4,a5,80005438 <_ZN5Riscv20handleSupervisorTrapEv+0x230>
        } else if (sysCallCode == 0x11) {
    80005310:	f5843703          	ld	a4,-168(s0)
    80005314:	01100793          	li	a5,17
    80005318:	14f70263          	beq	a4,a5,8000545c <_ZN5Riscv20handleSupervisorTrapEv+0x254>
        } else if (sysCallCode == 0x12) {
    8000531c:	f5843703          	ld	a4,-168(s0)
    80005320:	01200793          	li	a5,18
    80005324:	14f70e63          	beq	a4,a5,80005480 <_ZN5Riscv20handleSupervisorTrapEv+0x278>
        } else if (sysCallCode == 0x13) {
    80005328:	f5843703          	ld	a4,-168(s0)
    8000532c:	01300793          	li	a5,19
    80005330:	16f70863          	beq	a4,a5,800054a0 <_ZN5Riscv20handleSupervisorTrapEv+0x298>
        } else if (sysCallCode == 0x14) {
    80005334:	f5843703          	ld	a4,-168(s0)
    80005338:	01400793          	li	a5,20
    8000533c:	16f70863          	beq	a4,a5,800054ac <_ZN5Riscv20handleSupervisorTrapEv+0x2a4>
        } else if (sysCallCode == 0x15) {
    80005340:	f5843703          	ld	a4,-168(s0)
    80005344:	01500793          	li	a5,21
    80005348:	18f70463          	beq	a4,a5,800054d0 <_ZN5Riscv20handleSupervisorTrapEv+0x2c8>
        } else if (sysCallCode == 0x16) {
    8000534c:	f5843703          	ld	a4,-168(s0)
    80005350:	01600793          	li	a5,22
    80005354:	18f70c63          	beq	a4,a5,800054ec <_ZN5Riscv20handleSupervisorTrapEv+0x2e4>
        else if (sysCallCode == 0x21) {
    80005358:	f5843703          	ld	a4,-168(s0)
    8000535c:	02100793          	li	a5,33
    80005360:	1af70a63          	beq	a4,a5,80005514 <_ZN5Riscv20handleSupervisorTrapEv+0x30c>
        } else if (sysCallCode == 0x22) {
    80005364:	f5843703          	ld	a4,-168(s0)
    80005368:	02200793          	li	a5,34
    8000536c:	1cf70463          	beq	a4,a5,80005534 <_ZN5Riscv20handleSupervisorTrapEv+0x32c>
        } else if (sysCallCode == 0x23) {
    80005370:	f5843703          	ld	a4,-168(s0)
    80005374:	02300793          	li	a5,35
    80005378:	1cf70863          	beq	a4,a5,80005548 <_ZN5Riscv20handleSupervisorTrapEv+0x340>
        } else if (sysCallCode == 0x24) {
    8000537c:	f5843703          	ld	a4,-168(s0)
    80005380:	02400793          	li	a5,36
    80005384:	1ef70a63          	beq	a4,a5,80005578 <_ZN5Riscv20handleSupervisorTrapEv+0x370>
        } else if (sysCallCode == 0x31) {
    80005388:	f5843703          	ld	a4,-168(s0)
    8000538c:	03100793          	li	a5,49
    80005390:	1ef70c63          	beq	a4,a5,80005588 <_ZN5Riscv20handleSupervisorTrapEv+0x380>
        } else if (sysCallCode == 0x41) {
    80005394:	f5843703          	ld	a4,-168(s0)
    80005398:	04100793          	li	a5,65
    8000539c:	20f70463          	beq	a4,a5,800055a4 <_ZN5Riscv20handleSupervisorTrapEv+0x39c>
        } else if (sysCallCode == 0x42) {
    800053a0:	f5843703          	ld	a4,-168(s0)
    800053a4:	04200793          	li	a5,66
    800053a8:	20f70a63          	beq	a4,a5,800055bc <_ZN5Riscv20handleSupervisorTrapEv+0x3b4>
        } else if (sysCallCode == 0x50) {
    800053ac:	f5843703          	ld	a4,-168(s0)
    800053b0:	05000793          	li	a5,80
    800053b4:	22f70463          	beq	a4,a5,800055dc <_ZN5Riscv20handleSupervisorTrapEv+0x3d4>
        } else if (sysCallCode == 0x51) {
    800053b8:	f5843703          	ld	a4,-168(s0)
    800053bc:	05100793          	li	a5,81
    800053c0:	02f71863          	bne	a4,a5,800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    800053c4:	10000793          	li	a5,256
    800053c8:	1007a073          	csrs	sstatus,a5
}
    800053cc:	0240006f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[numberOfBlocks],8(sp)" : [numberOfBlocks] "=r"(numberOfBlocks));
    800053d0:	00813783          	ld	a5,8(sp)
    800053d4:	f6f43023          	sd	a5,-160(s0)
            void* allocatedMemory = MemoryAllocator::getInstance().allocateSegment(numberOfBlocks);
    800053d8:	00000097          	auipc	ra,0x0
    800053dc:	3b4080e7          	jalr	948(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    800053e0:	f6043583          	ld	a1,-160(s0)
    800053e4:	00000097          	auipc	ra,0x0
    800053e8:	404080e7          	jalr	1028(ra) # 800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>
            __asm__ volatile ("mv a0,%[allocatedMemory]" : : [allocatedMemory] "r"(allocatedMemory));
    800053ec:	00050513          	mv	a0,a0
        __asm__ volatile ("sd a0,10*8(s0)"); // a0 je zapravo registar x10 - pise u dokumentaciji
    800053f0:	04a43823          	sd	a0,80(s0)
        writeSepc(sepc);
    800053f4:	f4843783          	ld	a5,-184(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    800053f8:	14179073          	csrw	sepc,a5
        if (sysCallCode != 0x50 && sysCallCode != 0x51) {
    800053fc:	f5843703          	ld	a4,-168(s0)
    80005400:	05000793          	li	a5,80
    80005404:	00f70c63          	beq	a4,a5,8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    80005408:	f5843703          	ld	a4,-168(s0)
    8000540c:	05100793          	li	a5,81
    80005410:	00f70663          	beq	a4,a5,8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
            writeSstatus(sstatus);
    80005414:	f5043783          	ld	a5,-176(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    80005418:	10079073          	csrw	sstatus,a5
        maskClearBitsSip(SIP_SEIP); // brise se zahtev za spoljasnjim hardverskim prekidom
    }

    // ciscenje steka - vise nisu potrebni parametri sistemskog poziva/prekida/izuzetka na steku posto je sad to obradjeno
    __asm__ volatile ("addi sp,sp,64");
    8000541c:	04010113          	addi	sp,sp,64

    80005420:	0b813083          	ld	ra,184(sp)
    80005424:	0b013403          	ld	s0,176(sp)
    80005428:	0a813483          	ld	s1,168(sp)
    8000542c:	0a013903          	ld	s2,160(sp)
    80005430:	0c010113          	addi	sp,sp,192
    80005434:	00008067          	ret
            __asm__ volatile ("ld %[freeThisMemory],8(sp)" : [freeThisMemory] "=r"(freeThisMemory));
    80005438:	00813783          	ld	a5,8(sp)
    8000543c:	f6f43423          	sd	a5,-152(s0)
            int successInfo = MemoryAllocator::getInstance().deallocateSegment(freeThisMemory);
    80005440:	00000097          	auipc	ra,0x0
    80005444:	34c080e7          	jalr	844(ra) # 8000578c <_ZN15MemoryAllocator11getInstanceEv>
    80005448:	f6843583          	ld	a1,-152(s0)
    8000544c:	00000097          	auipc	ra,0x0
    80005450:	480080e7          	jalr	1152(ra) # 800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>
            __asm__ volatile ("mv a0,%[successInfo]" : : [successInfo] "r"(successInfo));
    80005454:	00050513          	mv	a0,a0
    80005458:	f99ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    8000545c:	00813483          	ld	s1,8(sp)
            __asm__ volatile ("ld %[startRoutine],16(sp)" : [startRoutine] "=r"(startRoutine));
    80005460:	01013503          	ld	a0,16(sp)
            __asm__ volatile ("ld %[arg],24(sp)" : [arg] "=r"(arg));
    80005464:	01813583          	ld	a1,24(sp)
            __asm__ volatile ("ld %[stack],32(sp)" : [stack] "=r"(stack));
    80005468:	02013603          	ld	a2,32(sp)
            *handle = TCB::createThread(startRoutine, arg, stack, false);
    8000546c:	00000693          	li	a3,0
    80005470:	00000097          	auipc	ra,0x0
    80005474:	bac080e7          	jalr	-1108(ra) # 8000501c <_ZN3TCB12createThreadEPFvPvES0_S0_b>
    80005478:	00a4b023          	sd	a0,0(s1)
    8000547c:	f75ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            TCB::runningThread->setFinished(true);
    80005480:	00005797          	auipc	a5,0x5
    80005484:	1987b783          	ld	a5,408(a5) # 8000a618 <_GLOBAL_OFFSET_TABLE_+0x38>
    80005488:	0007b783          	ld	a5,0(a5)
    void setFinished(bool value) { finished = value; }
    8000548c:	00100713          	li	a4,1
    80005490:	02e78823          	sb	a4,48(a5)
            TCB::dispatch();
    80005494:	00000097          	auipc	ra,0x0
    80005498:	c7c080e7          	jalr	-900(ra) # 80005110 <_ZN3TCB8dispatchEv>
    8000549c:	f55ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            TCB::dispatch();
    800054a0:	00000097          	auipc	ra,0x0
    800054a4:	c70080e7          	jalr	-912(ra) # 80005110 <_ZN3TCB8dispatchEv>
    800054a8:	f49ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    800054ac:	00813483          	ld	s1,8(sp)
            __asm__ volatile ("ld %[startRoutine],16(sp)" : [startRoutine] "=r"(startRoutine));
    800054b0:	01013503          	ld	a0,16(sp)
            __asm__ volatile ("ld %[arg],24(sp)" : [arg] "=r"(arg));
    800054b4:	01813583          	ld	a1,24(sp)
            __asm__ volatile ("ld %[stack],32(sp)" : [stack] "=r"(stack));
    800054b8:	02013603          	ld	a2,32(sp)
            *handle = TCB::createThread(startRoutine, arg, stack, true);
    800054bc:	00100693          	li	a3,1
    800054c0:	00000097          	auipc	ra,0x0
    800054c4:	b5c080e7          	jalr	-1188(ra) # 8000501c <_ZN3TCB12createThreadEPFvPvES0_S0_b>
    800054c8:	00a4b023          	sd	a0,0(s1)
    800054cc:	f25ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[thread],8(sp)" : [thread] "=r"(thread)); // citanje iz registra a1
    800054d0:	00813483          	ld	s1,8(sp)
            Scheduler::getInstance().put(thread);
    800054d4:	ffffd097          	auipc	ra,0xffffd
    800054d8:	124080e7          	jalr	292(ra) # 800025f8 <_ZN9Scheduler11getInstanceEv>
    800054dc:	00048593          	mv	a1,s1
    800054e0:	ffffd097          	auipc	ra,0xffffd
    800054e4:	164080e7          	jalr	356(ra) # 80002644 <_ZN9Scheduler3putEP3TCB>
    800054e8:	f09ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            int volatile threadId = TCB::runningThread->getThreadId();
    800054ec:	00005797          	auipc	a5,0x5
    800054f0:	12c7b783          	ld	a5,300(a5) # 8000a618 <_GLOBAL_OFFSET_TABLE_+0x38>
    800054f4:	0007b783          	ld	a5,0(a5)
    int getThreadId() const { return threadId; }
    800054f8:	06c7a783          	lw	a5,108(a5)
    800054fc:	f4f42223          	sw	a5,-188(s0)
            TCB::dispatch();
    80005500:	00000097          	auipc	ra,0x0
    80005504:	c10080e7          	jalr	-1008(ra) # 80005110 <_ZN3TCB8dispatchEv>
            __asm__ volatile ("mv a0,%[threadId]" : : [threadId] "r"(threadId));
    80005508:	f4442783          	lw	a5,-188(s0)
    8000550c:	00078513          	mv	a0,a5
    80005510:	ee1ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    80005514:	00813483          	ld	s1,8(sp)
            __asm__ volatile ("ld %[initialSemaphoreValue],16(sp)" : [initialSemaphoreValue] "=r"(initialSemaphoreValue)); // citanje iz registra a2
    80005518:	01013503          	ld	a0,16(sp)
            *handle = KernelSemaphore::createSemaphore(initialSemaphoreValue);
    8000551c:	03051513          	slli	a0,a0,0x30
    80005520:	03055513          	srli	a0,a0,0x30
    80005524:	fffff097          	auipc	ra,0xfffff
    80005528:	088080e7          	jalr	136(ra) # 800045ac <_ZN15KernelSemaphore15createSemaphoreEt>
    8000552c:	00a4b023          	sd	a0,0(s1)
    80005530:	ec1ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[handle],8(sp)" : [handle] "=r"(handle)); // citanje iz registra a1
    80005534:	00813503          	ld	a0,8(sp)
            int successInfo = KernelSemaphore::closeSemaphore(handle);
    80005538:	fffff097          	auipc	ra,0xfffff
    8000553c:	2d4080e7          	jalr	724(ra) # 8000480c <_ZN15KernelSemaphore14closeSemaphoreEPS_>
            __asm__ volatile ("mv a0,%[successInfo]" : : [successInfo] "r"(successInfo));
    80005540:	00050513          	mv	a0,a0
    80005544:	eadff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[semaphoreId],8(sp)" : [semaphoreId] "=r"(semaphoreId)); // citanje iz registra a1
    80005548:	00813503          	ld	a0,8(sp)
            semaphoreId->wait();
    8000554c:	fffff097          	auipc	ra,0xfffff
    80005550:	1e4080e7          	jalr	484(ra) # 80004730 <_ZN15KernelSemaphore4waitEv>
            if (TCB::runningThread->getWaitSemaphoreFailed()) __asm__ volatile ("li a0,-1"); // slucaj kada je nit odblokirana sa sem_close umesto sem_signal
    80005554:	00005797          	auipc	a5,0x5
    80005558:	0c47b783          	ld	a5,196(a5) # 8000a618 <_GLOBAL_OFFSET_TABLE_+0x38>
    8000555c:	0007b783          	ld	a5,0(a5)
    bool getWaitSemaphoreFailed() const { return waitSemaphoreFailed; }
    80005560:	0687c783          	lbu	a5,104(a5)
    80005564:	00078663          	beqz	a5,80005570 <_ZN5Riscv20handleSupervisorTrapEv+0x368>
    80005568:	fff00513          	li	a0,-1
    8000556c:	e85ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            else __asm__ volatile ("li a0,1"); // slucaj kada je nit odblokirana normalno pomocu sistemskog poziva sem_signal
    80005570:	00100513          	li	a0,1
    80005574:	e7dff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[semaphoreId],8(sp)" : [semaphoreId] "=r"(semaphoreId)); // citanje iz registra a1
    80005578:	00813503          	ld	a0,8(sp)
            semaphoreId->signal();
    8000557c:	fffff097          	auipc	ra,0xfffff
    80005580:	318080e7          	jalr	792(ra) # 80004894 <_ZN15KernelSemaphore6signalEv>
    80005584:	e6dff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[time], 8(sp)" : [time] "=r"(time)); // citanje iz registra a1
    80005588:	00813503          	ld	a0,8(sp)
            TCB::insertSleepThread(time);
    8000558c:	fffff097          	auipc	ra,0xfffff
    80005590:	6d0080e7          	jalr	1744(ra) # 80004c5c <_ZN3TCB17insertSleepThreadEm>
            TCB::suspendCurrentThread();
    80005594:	00000097          	auipc	ra,0x0
    80005598:	bf4080e7          	jalr	-1036(ra) # 80005188 <_ZN3TCB20suspendCurrentThreadEv>
            __asm__ volatile ("li a0,1");
    8000559c:	00100513          	li	a0,1
    800055a0:	e51ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            char inputCharacter = KernelBuffer::getcGetInstance()->removeFromBuffer();
    800055a4:	ffffd097          	auipc	ra,0xffffd
    800055a8:	ac4080e7          	jalr	-1340(ra) # 80002068 <_ZN12KernelBuffer15getcGetInstanceEv>
    800055ac:	ffffd097          	auipc	ra,0xffffd
    800055b0:	c8c080e7          	jalr	-884(ra) # 80002238 <_ZN12KernelBuffer16removeFromBufferEv>
            __asm__ volatile ("mv a0,%[inputCharacter]" : : [inputCharacter] "r"(inputCharacter));
    800055b4:	00050513          	mv	a0,a0
    800055b8:	e39ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
            __asm__ volatile ("ld %[outputCharacter], 8(sp)" : [outputCharacter] "=r"(outputCharacter)); // citanje iz registra a1
    800055bc:	00813483          	ld	s1,8(sp)
    800055c0:	0ff4f493          	andi	s1,s1,255
            KernelBuffer::putcGetInstance()->insertIntoBuffer(outputCharacter);
    800055c4:	ffffd097          	auipc	ra,0xffffd
    800055c8:	a24080e7          	jalr	-1500(ra) # 80001fe8 <_ZN12KernelBuffer15putcGetInstanceEv>
    800055cc:	00048593          	mv	a1,s1
    800055d0:	ffffd097          	auipc	ra,0xffffd
    800055d4:	bd8080e7          	jalr	-1064(ra) # 800021a8 <_ZN12KernelBuffer16insertIntoBufferEi>
    800055d8:	e19ff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    800055dc:	10000793          	li	a5,256
    800055e0:	1007b073          	csrc	sstatus,a5
}
    800055e4:	e0dff06f          	j	800053f0 <_ZN5Riscv20handleSupervisorTrapEv+0x1e8>
        printErrorMessage(scause, readStval(), readSepc());
    800055e8:	fd843503          	ld	a0,-40(s0)
}

inline uint64 Riscv::readStval() {
    uint64 volatile stval;
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    800055ec:	143027f3          	csrr	a5,stval
    800055f0:	faf43023          	sd	a5,-96(s0)
    return stval;
    800055f4:	fa043583          	ld	a1,-96(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800055f8:	141027f3          	csrr	a5,sepc
    800055fc:	f8f43c23          	sd	a5,-104(s0)
    return sepc;
    80005600:	f9843603          	ld	a2,-104(s0)
    80005604:	00000097          	auipc	ra,0x0
    80005608:	440080e7          	jalr	1088(ra) # 80005a44 <_Z17printErrorMessagemmm>
    8000560c:	e11ff06f          	j	8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
        printErrorMessage(scause, readStval(), readSepc());
    80005610:	fd843503          	ld	a0,-40(s0)
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    80005614:	143027f3          	csrr	a5,stval
    80005618:	faf43823          	sd	a5,-80(s0)
    return stval;
    8000561c:	fb043583          	ld	a1,-80(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80005620:	141027f3          	csrr	a5,sepc
    80005624:	faf43423          	sd	a5,-88(s0)
    return sepc;
    80005628:	fa843603          	ld	a2,-88(s0)
    8000562c:	00000097          	auipc	ra,0x0
    80005630:	418080e7          	jalr	1048(ra) # 80005a44 <_Z17printErrorMessagemmm>
    80005634:	de9ff06f          	j	8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
        printErrorMessage(scause, readStval(), readSepc());
    80005638:	fd843503          	ld	a0,-40(s0)
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    8000563c:	143027f3          	csrr	a5,stval
    80005640:	fcf43023          	sd	a5,-64(s0)
    return stval;
    80005644:	fc043583          	ld	a1,-64(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80005648:	141027f3          	csrr	a5,sepc
    8000564c:	faf43c23          	sd	a5,-72(s0)
    return sepc;
    80005650:	fb843603          	ld	a2,-72(s0)
    80005654:	00000097          	auipc	ra,0x0
    80005658:	3f0080e7          	jalr	1008(ra) # 80005a44 <_Z17printErrorMessagemmm>
    8000565c:	dc1ff06f          	j	8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    80005660:	00200793          	li	a5,2
    80005664:	1447b073          	csrc	sip,a5
        TCB::updateSleepThreadList(); // azuriranje liste uspavanih niti
    80005668:	fffff097          	auipc	ra,0xfffff
    8000566c:	6c8080e7          	jalr	1736(ra) # 80004d30 <_ZN3TCB21updateSleepThreadListEv>
        TCB::timeSliceCounter++; // povecava se brojac perioda tajmera za tekucu nit (runningThread)
    80005670:	00005717          	auipc	a4,0x5
    80005674:	fa073703          	ld	a4,-96(a4) # 8000a610 <_GLOBAL_OFFSET_TABLE_+0x30>
    80005678:	00073783          	ld	a5,0(a4)
    8000567c:	00178793          	addi	a5,a5,1
    80005680:	00f73023          	sd	a5,0(a4)
        if (TCB::timeSliceCounter >= TCB::runningThread->getTimeSlice()) {
    80005684:	00005717          	auipc	a4,0x5
    80005688:	f9473703          	ld	a4,-108(a4) # 8000a618 <_GLOBAL_OFFSET_TABLE_+0x38>
    8000568c:	00073703          	ld	a4,0(a4)
    uint64 getTimeSlice() const { return timeSlice; }
    80005690:	01073703          	ld	a4,16(a4)
    80005694:	d8e7e4e3          	bltu	a5,a4,8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80005698:	141027f3          	csrr	a5,sepc
    8000569c:	fcf43823          	sd	a5,-48(s0)
    return sepc;
    800056a0:	fd043783          	ld	a5,-48(s0)
            uint64 volatile sepc = readSepc();
    800056a4:	f6f43823          	sd	a5,-144(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    800056a8:	100027f3          	csrr	a5,sstatus
    800056ac:	fcf43423          	sd	a5,-56(s0)
    return sstatus;
    800056b0:	fc843783          	ld	a5,-56(s0)
            uint64 volatile sstatus = readSstatus();
    800056b4:	f6f43c23          	sd	a5,-136(s0)
            TCB::timeSliceCounter = 0;
    800056b8:	00005797          	auipc	a5,0x5
    800056bc:	f587b783          	ld	a5,-168(a5) # 8000a610 <_GLOBAL_OFFSET_TABLE_+0x30>
    800056c0:	0007b023          	sd	zero,0(a5)
            TCB::dispatch(); // promena konteksta
    800056c4:	00000097          	auipc	ra,0x0
    800056c8:	a4c080e7          	jalr	-1460(ra) # 80005110 <_ZN3TCB8dispatchEv>
            writeSepc(sepc);
    800056cc:	f7043783          	ld	a5,-144(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    800056d0:	14179073          	csrw	sepc,a5
            writeSstatus(sstatus);
    800056d4:	f7843783          	ld	a5,-136(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    800056d8:	10079073          	csrw	sstatus,a5
}
    800056dc:	d41ff06f          	j	8000541c <_ZN5Riscv20handleSupervisorTrapEv+0x214>
            while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {
    800056e0:	00005797          	auipc	a5,0x5
    800056e4:	f107b783          	ld	a5,-240(a5) # 8000a5f0 <_GLOBAL_OFFSET_TABLE_+0x10>
    800056e8:	0007b783          	ld	a5,0(a5)
    800056ec:	0007c783          	lbu	a5,0(a5)
    800056f0:	0017f793          	andi	a5,a5,1
    800056f4:	bc0780e3          	beqz	a5,800052b4 <_ZN5Riscv20handleSupervisorTrapEv+0xac>
                int consoleInput = *reinterpret_cast<char*>(CONSOLE_RX_DATA);
    800056f8:	00005797          	auipc	a5,0x5
    800056fc:	ef07b783          	ld	a5,-272(a5) # 8000a5e8 <_GLOBAL_OFFSET_TABLE_+0x8>
    80005700:	0007b783          	ld	a5,0(a5)
    80005704:	0007c483          	lbu	s1,0(a5)
                KernelBuffer::getcGetInstance()->insertIntoBuffer(consoleInput);
    80005708:	ffffd097          	auipc	ra,0xffffd
    8000570c:	960080e7          	jalr	-1696(ra) # 80002068 <_ZN12KernelBuffer15getcGetInstanceEv>
    80005710:	00048593          	mv	a1,s1
    80005714:	ffffd097          	auipc	ra,0xffffd
    80005718:	a94080e7          	jalr	-1388(ra) # 800021a8 <_ZN12KernelBuffer16insertIntoBufferEi>
            while (*reinterpret_cast<char*>(CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {
    8000571c:	fc5ff06f          	j	800056e0 <_ZN5Riscv20handleSupervisorTrapEv+0x4d8>

0000000080005720 <_ZN15MemoryAllocatorC1Ev>:
MemoryAllocator& MemoryAllocator::getInstance() {
    static MemoryAllocator memoryAllocator;
    return memoryAllocator;
}

MemoryAllocator::MemoryAllocator() {
    80005720:	ff010113          	addi	sp,sp,-16
    80005724:	00813423          	sd	s0,8(sp)
    80005728:	01010413          	addi	s0,sp,16
    // pre tog bloka mora postojati struktura za ulancavanje slobodnih segmenata (FreeSegment) i ona ce, iako je velicine 24 bajta
    // a MEM_BLOCK_SIZE je 64 bajta, zauzeti ceo jedan blok velicine MEM_BLOCK_SIZE, posto se korisniku mora vratiti poravnata adresa,
    // a to je onda adresa prvog narednog bloka velicine MEM_BLOCK_SIZE
    size_t firstAlignedAddress =
            reinterpret_cast<size_t>(HEAP_START_ADDR) +
            ((reinterpret_cast<size_t>(HEAP_START_ADDR) % MEM_BLOCK_SIZE) ?
    8000572c:	00005797          	auipc	a5,0x5
    80005730:	ecc7b783          	ld	a5,-308(a5) # 8000a5f8 <_GLOBAL_OFFSET_TABLE_+0x18>
    80005734:	0007b783          	ld	a5,0(a5)
    80005738:	03f7f713          	andi	a4,a5,63
    8000573c:	00070663          	beqz	a4,80005748 <_ZN15MemoryAllocatorC1Ev+0x28>
    80005740:	04000693          	li	a3,64
    80005744:	40e68733          	sub	a4,a3,a4
    size_t firstAlignedAddress =
    80005748:	00e78733          	add	a4,a5,a4
             (MEM_BLOCK_SIZE - (reinterpret_cast<size_t>(HEAP_START_ADDR)) % MEM_BLOCK_SIZE): 0);
    // koristio sam iznad reinterpret_cast jer sam konvertovao pokazivac u ceo broj, a ispod jer sam konvertovao ceo broj u pokazivac
    freeListHead = reinterpret_cast<FreeSegment*>(firstAlignedAddress);
    8000574c:	00e53023          	sd	a4,0(a0)
    freeListHead->next = nullptr;
    80005750:	00073423          	sd	zero,8(a4)
    freeListHead->prev = nullptr;
    80005754:	00053783          	ld	a5,0(a0)
    80005758:	0007b823          	sd	zero,16(a5)
    // na pocetku taj jedan veliki slobodan segment ima freeListHead->size blokova velicine MEM_BLOCK_SIZE
    totalNumberOfBlocks = (reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 - firstAlignedAddress) / MEM_BLOCK_SIZE;
    8000575c:	00005797          	auipc	a5,0x5
    80005760:	ed47b783          	ld	a5,-300(a5) # 8000a630 <_GLOBAL_OFFSET_TABLE_+0x50>
    80005764:	0007b783          	ld	a5,0(a5)
    80005768:	40e787b3          	sub	a5,a5,a4
    8000576c:	fff78793          	addi	a5,a5,-1
    80005770:	0067d793          	srli	a5,a5,0x6
    80005774:	00f53423          	sd	a5,8(a0)
    freeListHead->size = totalNumberOfBlocks;
    80005778:	00053703          	ld	a4,0(a0)
    8000577c:	00f73023          	sd	a5,0(a4)
}
    80005780:	00813403          	ld	s0,8(sp)
    80005784:	01010113          	addi	sp,sp,16
    80005788:	00008067          	ret

000000008000578c <_ZN15MemoryAllocator11getInstanceEv>:
    static MemoryAllocator memoryAllocator;
    8000578c:	00005797          	auipc	a5,0x5
    80005790:	2247c783          	lbu	a5,548(a5) # 8000a9b0 <_ZGVZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    80005794:	00078863          	beqz	a5,800057a4 <_ZN15MemoryAllocator11getInstanceEv+0x18>
}
    80005798:	00005517          	auipc	a0,0x5
    8000579c:	22050513          	addi	a0,a0,544 # 8000a9b8 <_ZZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    800057a0:	00008067          	ret
MemoryAllocator& MemoryAllocator::getInstance() {
    800057a4:	ff010113          	addi	sp,sp,-16
    800057a8:	00113423          	sd	ra,8(sp)
    800057ac:	00813023          	sd	s0,0(sp)
    800057b0:	01010413          	addi	s0,sp,16
    static MemoryAllocator memoryAllocator;
    800057b4:	00005517          	auipc	a0,0x5
    800057b8:	20450513          	addi	a0,a0,516 # 8000a9b8 <_ZZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    800057bc:	00000097          	auipc	ra,0x0
    800057c0:	f64080e7          	jalr	-156(ra) # 80005720 <_ZN15MemoryAllocatorC1Ev>
    800057c4:	00100793          	li	a5,1
    800057c8:	00005717          	auipc	a4,0x5
    800057cc:	1ef70423          	sb	a5,488(a4) # 8000a9b0 <_ZGVZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
}
    800057d0:	00005517          	auipc	a0,0x5
    800057d4:	1e850513          	addi	a0,a0,488 # 8000a9b8 <_ZZN15MemoryAllocator11getInstanceEvE15memoryAllocator>
    800057d8:	00813083          	ld	ra,8(sp)
    800057dc:	00013403          	ld	s0,0(sp)
    800057e0:	01010113          	addi	sp,sp,16
    800057e4:	00008067          	ret

00000000800057e8 <_ZN15MemoryAllocator15allocateSegmentEm>:

void* MemoryAllocator::allocateSegment(size_t size) { // parametar size je broj blokova velicine MEM_BLOCK_SIZE koje je korisnik trazio
    800057e8:	ff010113          	addi	sp,sp,-16
    800057ec:	00813423          	sd	s0,8(sp)
    800057f0:	01010413          	addi	s0,sp,16
    if (size >= totalNumberOfBlocks) return nullptr; // ako je zatrazeno vise blokova memorije nego sto ukupno ima na raspolaganju
    800057f4:	00853783          	ld	a5,8(a0)
    800057f8:	0cf5f663          	bgeu	a1,a5,800058c4 <_ZN15MemoryAllocator15allocateSegmentEm+0xdc>
    800057fc:	00050613          	mv	a2,a0
    for (FreeSegment* curr = freeListHead; curr; curr = curr->next) {
    80005800:	00053503          	ld	a0,0(a0)
    80005804:	0540006f          	j	80005858 <_ZN15MemoryAllocator15allocateSegmentEm+0x70>
            // memorije koju je korisnik alocirao
        if ((curr->size - 1) - size <= 1) {
            // slucaj kada je preostali fragment suvise mali (1 blok velicine MEM_BLOCK_SIZE) da bi se evidentirao kao slobodan (tada ga
            // ne umecemo u listu slodobnih segmenata); fragment mora imati najmanje dva bloka velicine MEM_BLOCK_SIZE jer je potreban
            // jedan ceo blok samo za strukturu za ulancavanje, pa ce onda u tom slucaju korisnik na raspolaganju imati jedan blok
            if (curr->prev) curr->prev->next = curr->next;
    80005808:	01053783          	ld	a5,16(a0)
    8000580c:	02078a63          	beqz	a5,80005840 <_ZN15MemoryAllocator15allocateSegmentEm+0x58>
    80005810:	00853703          	ld	a4,8(a0)
    80005814:	00e7b423          	sd	a4,8(a5)
            else freeListHead = curr->next;
            if (curr->next) curr->next->prev = curr->prev;
    80005818:	00853783          	ld	a5,8(a0)
    8000581c:	00078663          	beqz	a5,80005828 <_ZN15MemoryAllocator15allocateSegmentEm+0x40>
    80005820:	01053703          	ld	a4,16(a0)
    80005824:	00e7b823          	sd	a4,16(a5)
            // velicina bloka memorije koju je korisnik trazio (size + 1 jer racunam i blok za strukturu za ulancavanje)
            curr->size = size + 1;
    80005828:	00158593          	addi	a1,a1,1
    8000582c:	00b53023          	sd	a1,0(a0)
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
    80005830:	04050513          	addi	a0,a0,64
            curr->size = size + 1;
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
        }
    }
    return nullptr;
}
    80005834:	00813403          	ld	s0,8(sp)
    80005838:	01010113          	addi	sp,sp,16
    8000583c:	00008067          	ret
            else freeListHead = curr->next;
    80005840:	00853783          	ld	a5,8(a0)
    80005844:	00f63023          	sd	a5,0(a2)
    80005848:	fd1ff06f          	j	80005818 <_ZN15MemoryAllocator15allocateSegmentEm+0x30>
            else freeListHead = newFreeFragment;
    8000584c:	00f63023          	sd	a5,0(a2)
    80005850:	03c0006f          	j	8000588c <_ZN15MemoryAllocator15allocateSegmentEm+0xa4>
    for (FreeSegment* curr = freeListHead; curr; curr = curr->next) {
    80005854:	00853503          	ld	a0,8(a0)
    80005858:	fc050ee3          	beqz	a0,80005834 <_ZN15MemoryAllocator15allocateSegmentEm+0x4c>
        if ((curr->size - 1) - size <= 1) {
    8000585c:	00053703          	ld	a4,0(a0)
    80005860:	40b707b3          	sub	a5,a4,a1
    80005864:	fff78793          	addi	a5,a5,-1
    80005868:	00100693          	li	a3,1
    8000586c:	f8f6fee3          	bgeu	a3,a5,80005808 <_ZN15MemoryAllocator15allocateSegmentEm+0x20>
        } else if (curr->size > size && (curr->size - 1) - size >= 2) {
    80005870:	fee5f2e3          	bgeu	a1,a4,80005854 <_ZN15MemoryAllocator15allocateSegmentEm+0x6c>
            auto newFreeFragment = (FreeSegment*)(reinterpret_cast<char*>(curr) + (size + 1) * MEM_BLOCK_SIZE);
    80005874:	00158693          	addi	a3,a1,1
    80005878:	00669793          	slli	a5,a3,0x6
    8000587c:	00f507b3          	add	a5,a0,a5
            if (curr->prev) curr->prev->next = newFreeFragment;
    80005880:	01053703          	ld	a4,16(a0)
    80005884:	fc0704e3          	beqz	a4,8000584c <_ZN15MemoryAllocator15allocateSegmentEm+0x64>
    80005888:	00f73423          	sd	a5,8(a4)
            if (curr->next) curr->next->prev = newFreeFragment;
    8000588c:	00853703          	ld	a4,8(a0)
    80005890:	00070463          	beqz	a4,80005898 <_ZN15MemoryAllocator15allocateSegmentEm+0xb0>
    80005894:	00f73823          	sd	a5,16(a4)
            newFreeFragment->prev = curr->prev;
    80005898:	01053703          	ld	a4,16(a0)
    8000589c:	00e7b823          	sd	a4,16(a5)
            newFreeFragment->next = curr->next;
    800058a0:	00853703          	ld	a4,8(a0)
    800058a4:	00e7b423          	sd	a4,8(a5)
            newFreeFragment->size = curr->size - (size + 1);
    800058a8:	00053703          	ld	a4,0(a0)
    800058ac:	40b705b3          	sub	a1,a4,a1
    800058b0:	fff58593          	addi	a1,a1,-1
    800058b4:	00b7b023          	sd	a1,0(a5)
            curr->size = size + 1;
    800058b8:	00d53023          	sd	a3,0(a0)
            return reinterpret_cast<char*>(curr) + MEM_BLOCK_SIZE; // preskacem strukturu za ulancavanje i vracam korisniku trazeni blok memorije
    800058bc:	04050513          	addi	a0,a0,64
    800058c0:	f75ff06f          	j	80005834 <_ZN15MemoryAllocator15allocateSegmentEm+0x4c>
    if (size >= totalNumberOfBlocks) return nullptr; // ako je zatrazeno vise blokova memorije nego sto ukupno ima na raspolaganju
    800058c4:	00000513          	li	a0,0
    800058c8:	f6dff06f          	j	80005834 <_ZN15MemoryAllocator15allocateSegmentEm+0x4c>

00000000800058cc <_ZN15MemoryAllocator17deallocateSegmentEPv>:

// parametar ptr je pokazivac na memoriju koju korisnik zeli da oslobodi; static_cast<char*>(ptr) - MEM_BLOCK_SIZE je adresa pocetka
// strukture za ulancavanje od segmenta memorije koju korisnik zeli da oslobodi
int MemoryAllocator::deallocateSegment(void *ptr) {
    800058cc:	ff010113          	addi	sp,sp,-16
    800058d0:	00813423          	sd	s0,8(sp)
    800058d4:	01010413          	addi	s0,sp,16
    if (!ptr || !(
    800058d8:	14058a63          	beqz	a1,80005a2c <_ZN15MemoryAllocator17deallocateSegmentEPv+0x160>
        reinterpret_cast<size_t>(HEAP_START_ADDR) <= reinterpret_cast<size_t>(ptr) &&
    800058dc:	00005797          	auipc	a5,0x5
    800058e0:	d1c7b783          	ld	a5,-740(a5) # 8000a5f8 <_GLOBAL_OFFSET_TABLE_+0x18>
    800058e4:	0007b783          	ld	a5,0(a5)
    if (!ptr || !(
    800058e8:	14f5e663          	bltu	a1,a5,80005a34 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x168>
        reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 >= reinterpret_cast<size_t>(ptr))) return -1;
    800058ec:	00005797          	auipc	a5,0x5
    800058f0:	d447b783          	ld	a5,-700(a5) # 8000a630 <_GLOBAL_OFFSET_TABLE_+0x50>
    800058f4:	0007b783          	ld	a5,0(a5)
    800058f8:	fff78793          	addi	a5,a5,-1
    if (!ptr || !(
    800058fc:	14b7e063          	bltu	a5,a1,80005a3c <_ZN15MemoryAllocator17deallocateSegmentEPv+0x170>
    // postavljam ptr da pokazuje na pocetak strukture za ulancavanje segmenta memorije koji treba osloboditi
    ptr = static_cast<char*>(ptr) - MEM_BLOCK_SIZE;
    80005900:	fc058693          	addi	a3,a1,-64
    // nalazenje mesta gde treba umetnuti novi slobodan segment (to je segment na koji pokazuje pokazivac ptr)
    FreeSegment* curr;
    if (!freeListHead || static_cast<FreeSegment*>(ptr) < freeListHead) {
    80005904:	00053603          	ld	a2,0(a0)
    80005908:	06060a63          	beqz	a2,8000597c <_ZN15MemoryAllocator17deallocateSegmentEPv+0xb0>
    8000590c:	06c6ec63          	bltu	a3,a2,80005984 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xb8>
        // novi slobodan segment treba umetnuti na pocetak liste slobodnih segmenata
        curr = nullptr;
    } else {
        // nalazenje mesta (to ce biti odmah nakon curr) gde treba umetnuti novi slobodan segment
        for (curr = freeListHead; curr->next && static_cast<FreeSegment*>(ptr) > curr->next; curr = curr->next);
    80005910:	00060793          	mv	a5,a2
    80005914:	00078713          	mv	a4,a5
    80005918:	0087b783          	ld	a5,8(a5)
    8000591c:	00078463          	beqz	a5,80005924 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x58>
    80005920:	fed7eae3          	bltu	a5,a3,80005914 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x48>
    }
    // pokusaj spajanja novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (curr)
    if (curr && reinterpret_cast<char*>(curr) + curr->size * MEM_BLOCK_SIZE == static_cast<char*>(ptr)) {
    80005924:	06070263          	beqz	a4,80005988 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xbc>
    80005928:	00073883          	ld	a7,0(a4)
    8000592c:	00689813          	slli	a6,a7,0x6
    80005930:	01070833          	add	a6,a4,a6
    80005934:	04d81a63          	bne	a6,a3,80005988 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xbc>
        // spajanje novog slobodnog segmenta (ptr) sa prethodnim slobodnim segmentom (curr)
        curr->size += (static_cast<FreeSegment*>(ptr))->size;
    80005938:	fc05b683          	ld	a3,-64(a1)
    8000593c:	00d888b3          	add	a7,a7,a3
    80005940:	01173023          	sd	a7,0(a4)
        // pokusaj spajanja slobodnog segmenta (curr) sa narednim slobodnim segmentom (curr->next)
        if (curr->next && reinterpret_cast<char*>(curr) + curr->size * MEM_BLOCK_SIZE == reinterpret_cast<char*>(curr->next)) {
    80005944:	00078863          	beqz	a5,80005954 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x88>
    80005948:	00689693          	slli	a3,a7,0x6
    8000594c:	00d706b3          	add	a3,a4,a3
    80005950:	00d78663          	beq	a5,a3,8000595c <_ZN15MemoryAllocator17deallocateSegmentEPv+0x90>
            curr->size += curr->next->size;
            // uklanjanje segmenta curr->next iz liste slobodnih segmenata
            curr->next = curr->next->next;
            if (curr->next) curr->next->prev = curr;
        }
        return 0;
    80005954:	00000513          	li	a0,0
    80005958:	0740006f          	j	800059cc <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
            curr->size += curr->next->size;
    8000595c:	0007b683          	ld	a3,0(a5)
    80005960:	00d888b3          	add	a7,a7,a3
    80005964:	01173023          	sd	a7,0(a4)
            curr->next = curr->next->next;
    80005968:	0087b783          	ld	a5,8(a5)
    8000596c:	00f73423          	sd	a5,8(a4)
            if (curr->next) curr->next->prev = curr;
    80005970:	fe0782e3          	beqz	a5,80005954 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x88>
    80005974:	00e7b823          	sd	a4,16(a5)
    80005978:	fddff06f          	j	80005954 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x88>
        curr = nullptr;
    8000597c:	00060713          	mv	a4,a2
    80005980:	0080006f          	j	80005988 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xbc>
    80005984:	00000713          	li	a4,0
    } else {
        // pokusaj spajanja novog slobodnog segmenta (ptr) sa sledecim slobodnim segmentom (nextFreeSegment)
        FreeSegment* nextFreeSegment = curr ? curr->next : freeListHead;
    80005988:	00070463          	beqz	a4,80005990 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xc4>
    8000598c:	00873603          	ld	a2,8(a4)
        if (nextFreeSegment &&
    80005990:	00060a63          	beqz	a2,800059a4 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xd8>
        static_cast<char*>(ptr) + (static_cast<FreeSegment*>(ptr))->size * MEM_BLOCK_SIZE == reinterpret_cast<char*>(nextFreeSegment)) {
    80005994:	fc05b803          	ld	a6,-64(a1)
    80005998:	00681793          	slli	a5,a6,0x6
    8000599c:	00f687b3          	add	a5,a3,a5
        if (nextFreeSegment &&
    800059a0:	02c78c63          	beq	a5,a2,800059d8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x10c>
            return 0;
        } else {
            // ova grana se izvrsava ako nema potrebe za bilo kakvim spajanjem slobodnih segmenata - jednostavno se
            // umece novi slobodni segment (ptr) nakon prethodnog slobodnog segmenta (curr)
            auto newFreeSegment = static_cast<FreeSegment*>(ptr);
            newFreeSegment->prev = curr;
    800059a4:	fce5b823          	sd	a4,-48(a1)
            if (curr) newFreeSegment->next = curr->next;
    800059a8:	06070863          	beqz	a4,80005a18 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x14c>
    800059ac:	00873783          	ld	a5,8(a4)
    800059b0:	fcf5b423          	sd	a5,-56(a1)
            else newFreeSegment->next = freeListHead;
            if (newFreeSegment->next) newFreeSegment->next->prev = newFreeSegment;
    800059b4:	fc85b783          	ld	a5,-56(a1)
    800059b8:	00078463          	beqz	a5,800059c0 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xf4>
    800059bc:	00d7b823          	sd	a3,16(a5)
            if (curr) curr->next = newFreeSegment;
    800059c0:	06070263          	beqz	a4,80005a24 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x158>
    800059c4:	00d73423          	sd	a3,8(a4)
            else freeListHead = newFreeSegment;
            return 0;
    800059c8:	00000513          	li	a0,0
        }
    }
}
    800059cc:	00813403          	ld	s0,8(sp)
    800059d0:	01010113          	addi	sp,sp,16
    800059d4:	00008067          	ret
            newFreeSegment->size += nextFreeSegment->size;
    800059d8:	00063783          	ld	a5,0(a2)
    800059dc:	00f80833          	add	a6,a6,a5
    800059e0:	fd05b023          	sd	a6,-64(a1)
            newFreeSegment->prev = nextFreeSegment->prev;
    800059e4:	01063783          	ld	a5,16(a2)
    800059e8:	fcf5b823          	sd	a5,-48(a1)
            newFreeSegment->next = nextFreeSegment->next;
    800059ec:	00863783          	ld	a5,8(a2)
    800059f0:	fcf5b423          	sd	a5,-56(a1)
            if (nextFreeSegment->next) nextFreeSegment->next->prev = newFreeSegment;
    800059f4:	00078463          	beqz	a5,800059fc <_ZN15MemoryAllocator17deallocateSegmentEPv+0x130>
    800059f8:	00d7b823          	sd	a3,16(a5)
            if (nextFreeSegment->prev) nextFreeSegment->prev->next = newFreeSegment;
    800059fc:	01063783          	ld	a5,16(a2)
    80005a00:	00078863          	beqz	a5,80005a10 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x144>
    80005a04:	00d7b423          	sd	a3,8(a5)
            return 0;
    80005a08:	00000513          	li	a0,0
    80005a0c:	fc1ff06f          	j	800059cc <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
            else freeListHead = newFreeSegment;
    80005a10:	00d53023          	sd	a3,0(a0)
    80005a14:	ff5ff06f          	j	80005a08 <_ZN15MemoryAllocator17deallocateSegmentEPv+0x13c>
            else newFreeSegment->next = freeListHead;
    80005a18:	00053783          	ld	a5,0(a0)
    80005a1c:	fcf5b423          	sd	a5,-56(a1)
    80005a20:	f95ff06f          	j	800059b4 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xe8>
            else freeListHead = newFreeSegment;
    80005a24:	00d53023          	sd	a3,0(a0)
    80005a28:	fa1ff06f          	j	800059c8 <_ZN15MemoryAllocator17deallocateSegmentEPv+0xfc>
        reinterpret_cast<size_t>(HEAP_END_ADDR) - 1 >= reinterpret_cast<size_t>(ptr))) return -1;
    80005a2c:	fff00513          	li	a0,-1
    80005a30:	f9dff06f          	j	800059cc <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
    80005a34:	fff00513          	li	a0,-1
    80005a38:	f95ff06f          	j	800059cc <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>
    80005a3c:	fff00513          	li	a0,-1
    80005a40:	f8dff06f          	j	800059cc <_ZN15MemoryAllocator17deallocateSegmentEPv+0x100>

0000000080005a44 <_Z17printErrorMessagemmm>:
#include "../h/print.hpp"
#include "../h/Riscv.hpp"
#include "../h/Z_Njihovo_Printing.hpp"

void printErrorMessage(uint64 scause, uint64 stval, uint64 sepc) {
    80005a44:	fc010113          	addi	sp,sp,-64
    80005a48:	02113c23          	sd	ra,56(sp)
    80005a4c:	02813823          	sd	s0,48(sp)
    80005a50:	02913423          	sd	s1,40(sp)
    80005a54:	03213023          	sd	s2,32(sp)
    80005a58:	01313c23          	sd	s3,24(sp)
    80005a5c:	01413823          	sd	s4,16(sp)
    80005a60:	04010413          	addi	s0,sp,64
    80005a64:	00050493          	mv	s1,a0
    80005a68:	00058913          	mv	s2,a1
    80005a6c:	00060993          	mv	s3,a2
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80005a70:	100027f3          	csrr	a5,sstatus
    80005a74:	fcf43423          	sd	a5,-56(s0)
    return sstatus;
    80005a78:	fc843a03          	ld	s4,-56(s0)
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    80005a7c:	00200793          	li	a5,2
    80005a80:	1007b073          	csrc	sstatus,a5
    uint64 sstatus = Riscv::readSstatus();
    Riscv::maskClearBitsSstatus(Riscv::SSTATUS_SIE); // zabrana spoljasnjih prekida (softverskih prekida od tajmera i spoljasnjih hardverskih prekida)
    printString("unutrasnji prekid ");
    80005a84:	00002517          	auipc	a0,0x2
    80005a88:	7b450513          	addi	a0,a0,1972 # 80008238 <CONSOLE_STATUS+0x228>
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	8c0080e7          	jalr	-1856(ra) # 8000234c <_Z11printStringPKc>
    switch (scause) {
    80005a94:	00500793          	li	a5,5
    80005a98:	0cf48463          	beq	s1,a5,80005b60 <_Z17printErrorMessagemmm+0x11c>
    80005a9c:	00700793          	li	a5,7
    80005aa0:	0cf48a63          	beq	s1,a5,80005b74 <_Z17printErrorMessagemmm+0x130>
    80005aa4:	00200793          	li	a5,2
    80005aa8:	0af48263          	beq	s1,a5,80005b4c <_Z17printErrorMessagemmm+0x108>
            break;
        case 0x0000000000000007UL:
            printString("(nedozvoljena adresa upisa)\n");
            break;
    }
    printString("scause (opis prekida): "); printInt(scause);
    80005aac:	00002517          	auipc	a0,0x2
    80005ab0:	7fc50513          	addi	a0,a0,2044 # 800082a8 <CONSOLE_STATUS+0x298>
    80005ab4:	ffffd097          	auipc	ra,0xffffd
    80005ab8:	898080e7          	jalr	-1896(ra) # 8000234c <_Z11printStringPKc>
    80005abc:	00000613          	li	a2,0
    80005ac0:	00a00593          	li	a1,10
    80005ac4:	0004851b          	sext.w	a0,s1
    80005ac8:	ffffd097          	auipc	ra,0xffffd
    80005acc:	a1c080e7          	jalr	-1508(ra) # 800024e4 <_Z8printIntiii>
    printString("; sepc (adresa prekinute instrukcije): "); printInt(sepc);
    80005ad0:	00002517          	auipc	a0,0x2
    80005ad4:	7f050513          	addi	a0,a0,2032 # 800082c0 <CONSOLE_STATUS+0x2b0>
    80005ad8:	ffffd097          	auipc	ra,0xffffd
    80005adc:	874080e7          	jalr	-1932(ra) # 8000234c <_Z11printStringPKc>
    80005ae0:	00000613          	li	a2,0
    80005ae4:	00a00593          	li	a1,10
    80005ae8:	0009851b          	sext.w	a0,s3
    80005aec:	ffffd097          	auipc	ra,0xffffd
    80005af0:	9f8080e7          	jalr	-1544(ra) # 800024e4 <_Z8printIntiii>
    printString("; stval (dodatan opis izuzetka): "); printInt(stval);
    80005af4:	00002517          	auipc	a0,0x2
    80005af8:	7f450513          	addi	a0,a0,2036 # 800082e8 <CONSOLE_STATUS+0x2d8>
    80005afc:	ffffd097          	auipc	ra,0xffffd
    80005b00:	850080e7          	jalr	-1968(ra) # 8000234c <_Z11printStringPKc>
    80005b04:	00000613          	li	a2,0
    80005b08:	00a00593          	li	a1,10
    80005b0c:	0009051b          	sext.w	a0,s2
    80005b10:	ffffd097          	auipc	ra,0xffffd
    80005b14:	9d4080e7          	jalr	-1580(ra) # 800024e4 <_Z8printIntiii>
    printString("\n\n");
    80005b18:	00002517          	auipc	a0,0x2
    80005b1c:	7f850513          	addi	a0,a0,2040 # 80008310 <CONSOLE_STATUS+0x300>
    80005b20:	ffffd097          	auipc	ra,0xffffd
    80005b24:	82c080e7          	jalr	-2004(ra) # 8000234c <_Z11printStringPKc>
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    80005b28:	100a1073          	csrw	sstatus,s4
    Riscv::writeSstatus(sstatus); // restauracija inicijalnog sstatus registra
    80005b2c:	03813083          	ld	ra,56(sp)
    80005b30:	03013403          	ld	s0,48(sp)
    80005b34:	02813483          	ld	s1,40(sp)
    80005b38:	02013903          	ld	s2,32(sp)
    80005b3c:	01813983          	ld	s3,24(sp)
    80005b40:	01013a03          	ld	s4,16(sp)
    80005b44:	04010113          	addi	sp,sp,64
    80005b48:	00008067          	ret
            printString("(ilegalna instrukcija)\n");
    80005b4c:	00002517          	auipc	a0,0x2
    80005b50:	70450513          	addi	a0,a0,1796 # 80008250 <CONSOLE_STATUS+0x240>
    80005b54:	ffffc097          	auipc	ra,0xffffc
    80005b58:	7f8080e7          	jalr	2040(ra) # 8000234c <_Z11printStringPKc>
            break;
    80005b5c:	f51ff06f          	j	80005aac <_Z17printErrorMessagemmm+0x68>
            printString("(nedozvoljena adresa citanja)\n");
    80005b60:	00002517          	auipc	a0,0x2
    80005b64:	70850513          	addi	a0,a0,1800 # 80008268 <CONSOLE_STATUS+0x258>
    80005b68:	ffffc097          	auipc	ra,0xffffc
    80005b6c:	7e4080e7          	jalr	2020(ra) # 8000234c <_Z11printStringPKc>
            break;
    80005b70:	f3dff06f          	j	80005aac <_Z17printErrorMessagemmm+0x68>
            printString("(nedozvoljena adresa upisa)\n");
    80005b74:	00002517          	auipc	a0,0x2
    80005b78:	71450513          	addi	a0,a0,1812 # 80008288 <CONSOLE_STATUS+0x278>
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	7d0080e7          	jalr	2000(ra) # 8000234c <_Z11printStringPKc>
            break;
    80005b84:	f29ff06f          	j	80005aac <_Z17printErrorMessagemmm+0x68>

0000000080005b88 <start>:
    80005b88:	ff010113          	addi	sp,sp,-16
    80005b8c:	00813423          	sd	s0,8(sp)
    80005b90:	01010413          	addi	s0,sp,16
    80005b94:	300027f3          	csrr	a5,mstatus
    80005b98:	ffffe737          	lui	a4,0xffffe
    80005b9c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff2bcf>
    80005ba0:	00e7f7b3          	and	a5,a5,a4
    80005ba4:	00001737          	lui	a4,0x1
    80005ba8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005bac:	00e7e7b3          	or	a5,a5,a4
    80005bb0:	30079073          	csrw	mstatus,a5
    80005bb4:	00000797          	auipc	a5,0x0
    80005bb8:	16078793          	addi	a5,a5,352 # 80005d14 <system_main>
    80005bbc:	34179073          	csrw	mepc,a5
    80005bc0:	00000793          	li	a5,0
    80005bc4:	18079073          	csrw	satp,a5
    80005bc8:	000107b7          	lui	a5,0x10
    80005bcc:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005bd0:	30279073          	csrw	medeleg,a5
    80005bd4:	30379073          	csrw	mideleg,a5
    80005bd8:	104027f3          	csrr	a5,sie
    80005bdc:	2227e793          	ori	a5,a5,546
    80005be0:	10479073          	csrw	sie,a5
    80005be4:	fff00793          	li	a5,-1
    80005be8:	00a7d793          	srli	a5,a5,0xa
    80005bec:	3b079073          	csrw	pmpaddr0,a5
    80005bf0:	00f00793          	li	a5,15
    80005bf4:	3a079073          	csrw	pmpcfg0,a5
    80005bf8:	f14027f3          	csrr	a5,mhartid
    80005bfc:	0200c737          	lui	a4,0x200c
    80005c00:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c04:	0007869b          	sext.w	a3,a5
    80005c08:	00269713          	slli	a4,a3,0x2
    80005c0c:	000f4637          	lui	a2,0xf4
    80005c10:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c14:	00d70733          	add	a4,a4,a3
    80005c18:	0037979b          	slliw	a5,a5,0x3
    80005c1c:	020046b7          	lui	a3,0x2004
    80005c20:	00d787b3          	add	a5,a5,a3
    80005c24:	00c585b3          	add	a1,a1,a2
    80005c28:	00371693          	slli	a3,a4,0x3
    80005c2c:	00005717          	auipc	a4,0x5
    80005c30:	da470713          	addi	a4,a4,-604 # 8000a9d0 <timer_scratch>
    80005c34:	00b7b023          	sd	a1,0(a5)
    80005c38:	00d70733          	add	a4,a4,a3
    80005c3c:	00f73c23          	sd	a5,24(a4)
    80005c40:	02c73023          	sd	a2,32(a4)
    80005c44:	34071073          	csrw	mscratch,a4
    80005c48:	00000797          	auipc	a5,0x0
    80005c4c:	6e878793          	addi	a5,a5,1768 # 80006330 <timervec>
    80005c50:	30579073          	csrw	mtvec,a5
    80005c54:	300027f3          	csrr	a5,mstatus
    80005c58:	0087e793          	ori	a5,a5,8
    80005c5c:	30079073          	csrw	mstatus,a5
    80005c60:	304027f3          	csrr	a5,mie
    80005c64:	0807e793          	ori	a5,a5,128
    80005c68:	30479073          	csrw	mie,a5
    80005c6c:	f14027f3          	csrr	a5,mhartid
    80005c70:	0007879b          	sext.w	a5,a5
    80005c74:	00078213          	mv	tp,a5
    80005c78:	30200073          	mret
    80005c7c:	00813403          	ld	s0,8(sp)
    80005c80:	01010113          	addi	sp,sp,16
    80005c84:	00008067          	ret

0000000080005c88 <timerinit>:
    80005c88:	ff010113          	addi	sp,sp,-16
    80005c8c:	00813423          	sd	s0,8(sp)
    80005c90:	01010413          	addi	s0,sp,16
    80005c94:	f14027f3          	csrr	a5,mhartid
    80005c98:	0200c737          	lui	a4,0x200c
    80005c9c:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005ca0:	0007869b          	sext.w	a3,a5
    80005ca4:	00269713          	slli	a4,a3,0x2
    80005ca8:	000f4637          	lui	a2,0xf4
    80005cac:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005cb0:	00d70733          	add	a4,a4,a3
    80005cb4:	0037979b          	slliw	a5,a5,0x3
    80005cb8:	020046b7          	lui	a3,0x2004
    80005cbc:	00d787b3          	add	a5,a5,a3
    80005cc0:	00c585b3          	add	a1,a1,a2
    80005cc4:	00371693          	slli	a3,a4,0x3
    80005cc8:	00005717          	auipc	a4,0x5
    80005ccc:	d0870713          	addi	a4,a4,-760 # 8000a9d0 <timer_scratch>
    80005cd0:	00b7b023          	sd	a1,0(a5)
    80005cd4:	00d70733          	add	a4,a4,a3
    80005cd8:	00f73c23          	sd	a5,24(a4)
    80005cdc:	02c73023          	sd	a2,32(a4)
    80005ce0:	34071073          	csrw	mscratch,a4
    80005ce4:	00000797          	auipc	a5,0x0
    80005ce8:	64c78793          	addi	a5,a5,1612 # 80006330 <timervec>
    80005cec:	30579073          	csrw	mtvec,a5
    80005cf0:	300027f3          	csrr	a5,mstatus
    80005cf4:	0087e793          	ori	a5,a5,8
    80005cf8:	30079073          	csrw	mstatus,a5
    80005cfc:	304027f3          	csrr	a5,mie
    80005d00:	0807e793          	ori	a5,a5,128
    80005d04:	30479073          	csrw	mie,a5
    80005d08:	00813403          	ld	s0,8(sp)
    80005d0c:	01010113          	addi	sp,sp,16
    80005d10:	00008067          	ret

0000000080005d14 <system_main>:
    80005d14:	fe010113          	addi	sp,sp,-32
    80005d18:	00813823          	sd	s0,16(sp)
    80005d1c:	00913423          	sd	s1,8(sp)
    80005d20:	00113c23          	sd	ra,24(sp)
    80005d24:	02010413          	addi	s0,sp,32
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	0c4080e7          	jalr	196(ra) # 80005dec <cpuid>
    80005d30:	00005497          	auipc	s1,0x5
    80005d34:	93048493          	addi	s1,s1,-1744 # 8000a660 <started>
    80005d38:	02050263          	beqz	a0,80005d5c <system_main+0x48>
    80005d3c:	0004a783          	lw	a5,0(s1)
    80005d40:	0007879b          	sext.w	a5,a5
    80005d44:	fe078ce3          	beqz	a5,80005d3c <system_main+0x28>
    80005d48:	0ff0000f          	fence
    80005d4c:	00002517          	auipc	a0,0x2
    80005d50:	5fc50513          	addi	a0,a0,1532 # 80008348 <CONSOLE_STATUS+0x338>
    80005d54:	00001097          	auipc	ra,0x1
    80005d58:	a78080e7          	jalr	-1416(ra) # 800067cc <panic>
    80005d5c:	00001097          	auipc	ra,0x1
    80005d60:	9cc080e7          	jalr	-1588(ra) # 80006728 <consoleinit>
    80005d64:	00001097          	auipc	ra,0x1
    80005d68:	158080e7          	jalr	344(ra) # 80006ebc <printfinit>
    80005d6c:	00002517          	auipc	a0,0x2
    80005d70:	41c50513          	addi	a0,a0,1052 # 80008188 <CONSOLE_STATUS+0x178>
    80005d74:	00001097          	auipc	ra,0x1
    80005d78:	ab4080e7          	jalr	-1356(ra) # 80006828 <__printf>
    80005d7c:	00002517          	auipc	a0,0x2
    80005d80:	59c50513          	addi	a0,a0,1436 # 80008318 <CONSOLE_STATUS+0x308>
    80005d84:	00001097          	auipc	ra,0x1
    80005d88:	aa4080e7          	jalr	-1372(ra) # 80006828 <__printf>
    80005d8c:	00002517          	auipc	a0,0x2
    80005d90:	3fc50513          	addi	a0,a0,1020 # 80008188 <CONSOLE_STATUS+0x178>
    80005d94:	00001097          	auipc	ra,0x1
    80005d98:	a94080e7          	jalr	-1388(ra) # 80006828 <__printf>
    80005d9c:	00001097          	auipc	ra,0x1
    80005da0:	4ac080e7          	jalr	1196(ra) # 80007248 <kinit>
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	148080e7          	jalr	328(ra) # 80005eec <trapinit>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	16c080e7          	jalr	364(ra) # 80005f18 <trapinithart>
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	5bc080e7          	jalr	1468(ra) # 80006370 <plicinit>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	5dc080e7          	jalr	1500(ra) # 80006398 <plicinithart>
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	078080e7          	jalr	120(ra) # 80005e3c <userinit>
    80005dcc:	0ff0000f          	fence
    80005dd0:	00100793          	li	a5,1
    80005dd4:	00002517          	auipc	a0,0x2
    80005dd8:	55c50513          	addi	a0,a0,1372 # 80008330 <CONSOLE_STATUS+0x320>
    80005ddc:	00f4a023          	sw	a5,0(s1)
    80005de0:	00001097          	auipc	ra,0x1
    80005de4:	a48080e7          	jalr	-1464(ra) # 80006828 <__printf>
    80005de8:	0000006f          	j	80005de8 <system_main+0xd4>

0000000080005dec <cpuid>:
    80005dec:	ff010113          	addi	sp,sp,-16
    80005df0:	00813423          	sd	s0,8(sp)
    80005df4:	01010413          	addi	s0,sp,16
    80005df8:	00020513          	mv	a0,tp
    80005dfc:	00813403          	ld	s0,8(sp)
    80005e00:	0005051b          	sext.w	a0,a0
    80005e04:	01010113          	addi	sp,sp,16
    80005e08:	00008067          	ret

0000000080005e0c <mycpu>:
    80005e0c:	ff010113          	addi	sp,sp,-16
    80005e10:	00813423          	sd	s0,8(sp)
    80005e14:	01010413          	addi	s0,sp,16
    80005e18:	00020793          	mv	a5,tp
    80005e1c:	00813403          	ld	s0,8(sp)
    80005e20:	0007879b          	sext.w	a5,a5
    80005e24:	00779793          	slli	a5,a5,0x7
    80005e28:	00006517          	auipc	a0,0x6
    80005e2c:	bd850513          	addi	a0,a0,-1064 # 8000ba00 <cpus>
    80005e30:	00f50533          	add	a0,a0,a5
    80005e34:	01010113          	addi	sp,sp,16
    80005e38:	00008067          	ret

0000000080005e3c <userinit>:
    80005e3c:	ff010113          	addi	sp,sp,-16
    80005e40:	00813423          	sd	s0,8(sp)
    80005e44:	01010413          	addi	s0,sp,16
    80005e48:	00813403          	ld	s0,8(sp)
    80005e4c:	01010113          	addi	sp,sp,16
    80005e50:	ffffd317          	auipc	t1,0xffffd
    80005e54:	6b830067          	jr	1720(t1) # 80003508 <main>

0000000080005e58 <either_copyout>:
    80005e58:	ff010113          	addi	sp,sp,-16
    80005e5c:	00813023          	sd	s0,0(sp)
    80005e60:	00113423          	sd	ra,8(sp)
    80005e64:	01010413          	addi	s0,sp,16
    80005e68:	02051663          	bnez	a0,80005e94 <either_copyout+0x3c>
    80005e6c:	00058513          	mv	a0,a1
    80005e70:	00060593          	mv	a1,a2
    80005e74:	0006861b          	sext.w	a2,a3
    80005e78:	00002097          	auipc	ra,0x2
    80005e7c:	c5c080e7          	jalr	-932(ra) # 80007ad4 <__memmove>
    80005e80:	00813083          	ld	ra,8(sp)
    80005e84:	00013403          	ld	s0,0(sp)
    80005e88:	00000513          	li	a0,0
    80005e8c:	01010113          	addi	sp,sp,16
    80005e90:	00008067          	ret
    80005e94:	00002517          	auipc	a0,0x2
    80005e98:	4dc50513          	addi	a0,a0,1244 # 80008370 <CONSOLE_STATUS+0x360>
    80005e9c:	00001097          	auipc	ra,0x1
    80005ea0:	930080e7          	jalr	-1744(ra) # 800067cc <panic>

0000000080005ea4 <either_copyin>:
    80005ea4:	ff010113          	addi	sp,sp,-16
    80005ea8:	00813023          	sd	s0,0(sp)
    80005eac:	00113423          	sd	ra,8(sp)
    80005eb0:	01010413          	addi	s0,sp,16
    80005eb4:	02059463          	bnez	a1,80005edc <either_copyin+0x38>
    80005eb8:	00060593          	mv	a1,a2
    80005ebc:	0006861b          	sext.w	a2,a3
    80005ec0:	00002097          	auipc	ra,0x2
    80005ec4:	c14080e7          	jalr	-1004(ra) # 80007ad4 <__memmove>
    80005ec8:	00813083          	ld	ra,8(sp)
    80005ecc:	00013403          	ld	s0,0(sp)
    80005ed0:	00000513          	li	a0,0
    80005ed4:	01010113          	addi	sp,sp,16
    80005ed8:	00008067          	ret
    80005edc:	00002517          	auipc	a0,0x2
    80005ee0:	4bc50513          	addi	a0,a0,1212 # 80008398 <CONSOLE_STATUS+0x388>
    80005ee4:	00001097          	auipc	ra,0x1
    80005ee8:	8e8080e7          	jalr	-1816(ra) # 800067cc <panic>

0000000080005eec <trapinit>:
    80005eec:	ff010113          	addi	sp,sp,-16
    80005ef0:	00813423          	sd	s0,8(sp)
    80005ef4:	01010413          	addi	s0,sp,16
    80005ef8:	00813403          	ld	s0,8(sp)
    80005efc:	00002597          	auipc	a1,0x2
    80005f00:	4c458593          	addi	a1,a1,1220 # 800083c0 <CONSOLE_STATUS+0x3b0>
    80005f04:	00006517          	auipc	a0,0x6
    80005f08:	b7c50513          	addi	a0,a0,-1156 # 8000ba80 <tickslock>
    80005f0c:	01010113          	addi	sp,sp,16
    80005f10:	00001317          	auipc	t1,0x1
    80005f14:	5c830067          	jr	1480(t1) # 800074d8 <initlock>

0000000080005f18 <trapinithart>:
    80005f18:	ff010113          	addi	sp,sp,-16
    80005f1c:	00813423          	sd	s0,8(sp)
    80005f20:	01010413          	addi	s0,sp,16
    80005f24:	00000797          	auipc	a5,0x0
    80005f28:	2fc78793          	addi	a5,a5,764 # 80006220 <kernelvec>
    80005f2c:	10579073          	csrw	stvec,a5
    80005f30:	00813403          	ld	s0,8(sp)
    80005f34:	01010113          	addi	sp,sp,16
    80005f38:	00008067          	ret

0000000080005f3c <usertrap>:
    80005f3c:	ff010113          	addi	sp,sp,-16
    80005f40:	00813423          	sd	s0,8(sp)
    80005f44:	01010413          	addi	s0,sp,16
    80005f48:	00813403          	ld	s0,8(sp)
    80005f4c:	01010113          	addi	sp,sp,16
    80005f50:	00008067          	ret

0000000080005f54 <usertrapret>:
    80005f54:	ff010113          	addi	sp,sp,-16
    80005f58:	00813423          	sd	s0,8(sp)
    80005f5c:	01010413          	addi	s0,sp,16
    80005f60:	00813403          	ld	s0,8(sp)
    80005f64:	01010113          	addi	sp,sp,16
    80005f68:	00008067          	ret

0000000080005f6c <kerneltrap>:
    80005f6c:	fe010113          	addi	sp,sp,-32
    80005f70:	00813823          	sd	s0,16(sp)
    80005f74:	00113c23          	sd	ra,24(sp)
    80005f78:	00913423          	sd	s1,8(sp)
    80005f7c:	02010413          	addi	s0,sp,32
    80005f80:	142025f3          	csrr	a1,scause
    80005f84:	100027f3          	csrr	a5,sstatus
    80005f88:	0027f793          	andi	a5,a5,2
    80005f8c:	10079c63          	bnez	a5,800060a4 <kerneltrap+0x138>
    80005f90:	142027f3          	csrr	a5,scause
    80005f94:	0207ce63          	bltz	a5,80005fd0 <kerneltrap+0x64>
    80005f98:	00002517          	auipc	a0,0x2
    80005f9c:	47050513          	addi	a0,a0,1136 # 80008408 <CONSOLE_STATUS+0x3f8>
    80005fa0:	00001097          	auipc	ra,0x1
    80005fa4:	888080e7          	jalr	-1912(ra) # 80006828 <__printf>
    80005fa8:	141025f3          	csrr	a1,sepc
    80005fac:	14302673          	csrr	a2,stval
    80005fb0:	00002517          	auipc	a0,0x2
    80005fb4:	46850513          	addi	a0,a0,1128 # 80008418 <CONSOLE_STATUS+0x408>
    80005fb8:	00001097          	auipc	ra,0x1
    80005fbc:	870080e7          	jalr	-1936(ra) # 80006828 <__printf>
    80005fc0:	00002517          	auipc	a0,0x2
    80005fc4:	47050513          	addi	a0,a0,1136 # 80008430 <CONSOLE_STATUS+0x420>
    80005fc8:	00001097          	auipc	ra,0x1
    80005fcc:	804080e7          	jalr	-2044(ra) # 800067cc <panic>
    80005fd0:	0ff7f713          	andi	a4,a5,255
    80005fd4:	00900693          	li	a3,9
    80005fd8:	04d70063          	beq	a4,a3,80006018 <kerneltrap+0xac>
    80005fdc:	fff00713          	li	a4,-1
    80005fe0:	03f71713          	slli	a4,a4,0x3f
    80005fe4:	00170713          	addi	a4,a4,1
    80005fe8:	fae798e3          	bne	a5,a4,80005f98 <kerneltrap+0x2c>
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	e00080e7          	jalr	-512(ra) # 80005dec <cpuid>
    80005ff4:	06050663          	beqz	a0,80006060 <kerneltrap+0xf4>
    80005ff8:	144027f3          	csrr	a5,sip
    80005ffc:	ffd7f793          	andi	a5,a5,-3
    80006000:	14479073          	csrw	sip,a5
    80006004:	01813083          	ld	ra,24(sp)
    80006008:	01013403          	ld	s0,16(sp)
    8000600c:	00813483          	ld	s1,8(sp)
    80006010:	02010113          	addi	sp,sp,32
    80006014:	00008067          	ret
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	3cc080e7          	jalr	972(ra) # 800063e4 <plic_claim>
    80006020:	00a00793          	li	a5,10
    80006024:	00050493          	mv	s1,a0
    80006028:	06f50863          	beq	a0,a5,80006098 <kerneltrap+0x12c>
    8000602c:	fc050ce3          	beqz	a0,80006004 <kerneltrap+0x98>
    80006030:	00050593          	mv	a1,a0
    80006034:	00002517          	auipc	a0,0x2
    80006038:	3b450513          	addi	a0,a0,948 # 800083e8 <CONSOLE_STATUS+0x3d8>
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	7ec080e7          	jalr	2028(ra) # 80006828 <__printf>
    80006044:	01013403          	ld	s0,16(sp)
    80006048:	01813083          	ld	ra,24(sp)
    8000604c:	00048513          	mv	a0,s1
    80006050:	00813483          	ld	s1,8(sp)
    80006054:	02010113          	addi	sp,sp,32
    80006058:	00000317          	auipc	t1,0x0
    8000605c:	3c430067          	jr	964(t1) # 8000641c <plic_complete>
    80006060:	00006517          	auipc	a0,0x6
    80006064:	a2050513          	addi	a0,a0,-1504 # 8000ba80 <tickslock>
    80006068:	00001097          	auipc	ra,0x1
    8000606c:	494080e7          	jalr	1172(ra) # 800074fc <acquire>
    80006070:	00004717          	auipc	a4,0x4
    80006074:	5f470713          	addi	a4,a4,1524 # 8000a664 <ticks>
    80006078:	00072783          	lw	a5,0(a4)
    8000607c:	00006517          	auipc	a0,0x6
    80006080:	a0450513          	addi	a0,a0,-1532 # 8000ba80 <tickslock>
    80006084:	0017879b          	addiw	a5,a5,1
    80006088:	00f72023          	sw	a5,0(a4)
    8000608c:	00001097          	auipc	ra,0x1
    80006090:	53c080e7          	jalr	1340(ra) # 800075c8 <release>
    80006094:	f65ff06f          	j	80005ff8 <kerneltrap+0x8c>
    80006098:	00001097          	auipc	ra,0x1
    8000609c:	098080e7          	jalr	152(ra) # 80007130 <uartintr>
    800060a0:	fa5ff06f          	j	80006044 <kerneltrap+0xd8>
    800060a4:	00002517          	auipc	a0,0x2
    800060a8:	32450513          	addi	a0,a0,804 # 800083c8 <CONSOLE_STATUS+0x3b8>
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	720080e7          	jalr	1824(ra) # 800067cc <panic>

00000000800060b4 <clockintr>:
    800060b4:	fe010113          	addi	sp,sp,-32
    800060b8:	00813823          	sd	s0,16(sp)
    800060bc:	00913423          	sd	s1,8(sp)
    800060c0:	00113c23          	sd	ra,24(sp)
    800060c4:	02010413          	addi	s0,sp,32
    800060c8:	00006497          	auipc	s1,0x6
    800060cc:	9b848493          	addi	s1,s1,-1608 # 8000ba80 <tickslock>
    800060d0:	00048513          	mv	a0,s1
    800060d4:	00001097          	auipc	ra,0x1
    800060d8:	428080e7          	jalr	1064(ra) # 800074fc <acquire>
    800060dc:	00004717          	auipc	a4,0x4
    800060e0:	58870713          	addi	a4,a4,1416 # 8000a664 <ticks>
    800060e4:	00072783          	lw	a5,0(a4)
    800060e8:	01013403          	ld	s0,16(sp)
    800060ec:	01813083          	ld	ra,24(sp)
    800060f0:	00048513          	mv	a0,s1
    800060f4:	0017879b          	addiw	a5,a5,1
    800060f8:	00813483          	ld	s1,8(sp)
    800060fc:	00f72023          	sw	a5,0(a4)
    80006100:	02010113          	addi	sp,sp,32
    80006104:	00001317          	auipc	t1,0x1
    80006108:	4c430067          	jr	1220(t1) # 800075c8 <release>

000000008000610c <devintr>:
    8000610c:	142027f3          	csrr	a5,scause
    80006110:	00000513          	li	a0,0
    80006114:	0007c463          	bltz	a5,8000611c <devintr+0x10>
    80006118:	00008067          	ret
    8000611c:	fe010113          	addi	sp,sp,-32
    80006120:	00813823          	sd	s0,16(sp)
    80006124:	00113c23          	sd	ra,24(sp)
    80006128:	00913423          	sd	s1,8(sp)
    8000612c:	02010413          	addi	s0,sp,32
    80006130:	0ff7f713          	andi	a4,a5,255
    80006134:	00900693          	li	a3,9
    80006138:	04d70c63          	beq	a4,a3,80006190 <devintr+0x84>
    8000613c:	fff00713          	li	a4,-1
    80006140:	03f71713          	slli	a4,a4,0x3f
    80006144:	00170713          	addi	a4,a4,1
    80006148:	00e78c63          	beq	a5,a4,80006160 <devintr+0x54>
    8000614c:	01813083          	ld	ra,24(sp)
    80006150:	01013403          	ld	s0,16(sp)
    80006154:	00813483          	ld	s1,8(sp)
    80006158:	02010113          	addi	sp,sp,32
    8000615c:	00008067          	ret
    80006160:	00000097          	auipc	ra,0x0
    80006164:	c8c080e7          	jalr	-884(ra) # 80005dec <cpuid>
    80006168:	06050663          	beqz	a0,800061d4 <devintr+0xc8>
    8000616c:	144027f3          	csrr	a5,sip
    80006170:	ffd7f793          	andi	a5,a5,-3
    80006174:	14479073          	csrw	sip,a5
    80006178:	01813083          	ld	ra,24(sp)
    8000617c:	01013403          	ld	s0,16(sp)
    80006180:	00813483          	ld	s1,8(sp)
    80006184:	00200513          	li	a0,2
    80006188:	02010113          	addi	sp,sp,32
    8000618c:	00008067          	ret
    80006190:	00000097          	auipc	ra,0x0
    80006194:	254080e7          	jalr	596(ra) # 800063e4 <plic_claim>
    80006198:	00a00793          	li	a5,10
    8000619c:	00050493          	mv	s1,a0
    800061a0:	06f50663          	beq	a0,a5,8000620c <devintr+0x100>
    800061a4:	00100513          	li	a0,1
    800061a8:	fa0482e3          	beqz	s1,8000614c <devintr+0x40>
    800061ac:	00048593          	mv	a1,s1
    800061b0:	00002517          	auipc	a0,0x2
    800061b4:	23850513          	addi	a0,a0,568 # 800083e8 <CONSOLE_STATUS+0x3d8>
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	670080e7          	jalr	1648(ra) # 80006828 <__printf>
    800061c0:	00048513          	mv	a0,s1
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	258080e7          	jalr	600(ra) # 8000641c <plic_complete>
    800061cc:	00100513          	li	a0,1
    800061d0:	f7dff06f          	j	8000614c <devintr+0x40>
    800061d4:	00006517          	auipc	a0,0x6
    800061d8:	8ac50513          	addi	a0,a0,-1876 # 8000ba80 <tickslock>
    800061dc:	00001097          	auipc	ra,0x1
    800061e0:	320080e7          	jalr	800(ra) # 800074fc <acquire>
    800061e4:	00004717          	auipc	a4,0x4
    800061e8:	48070713          	addi	a4,a4,1152 # 8000a664 <ticks>
    800061ec:	00072783          	lw	a5,0(a4)
    800061f0:	00006517          	auipc	a0,0x6
    800061f4:	89050513          	addi	a0,a0,-1904 # 8000ba80 <tickslock>
    800061f8:	0017879b          	addiw	a5,a5,1
    800061fc:	00f72023          	sw	a5,0(a4)
    80006200:	00001097          	auipc	ra,0x1
    80006204:	3c8080e7          	jalr	968(ra) # 800075c8 <release>
    80006208:	f65ff06f          	j	8000616c <devintr+0x60>
    8000620c:	00001097          	auipc	ra,0x1
    80006210:	f24080e7          	jalr	-220(ra) # 80007130 <uartintr>
    80006214:	fadff06f          	j	800061c0 <devintr+0xb4>
	...

0000000080006220 <kernelvec>:
    80006220:	f0010113          	addi	sp,sp,-256
    80006224:	00113023          	sd	ra,0(sp)
    80006228:	00213423          	sd	sp,8(sp)
    8000622c:	00313823          	sd	gp,16(sp)
    80006230:	00413c23          	sd	tp,24(sp)
    80006234:	02513023          	sd	t0,32(sp)
    80006238:	02613423          	sd	t1,40(sp)
    8000623c:	02713823          	sd	t2,48(sp)
    80006240:	02813c23          	sd	s0,56(sp)
    80006244:	04913023          	sd	s1,64(sp)
    80006248:	04a13423          	sd	a0,72(sp)
    8000624c:	04b13823          	sd	a1,80(sp)
    80006250:	04c13c23          	sd	a2,88(sp)
    80006254:	06d13023          	sd	a3,96(sp)
    80006258:	06e13423          	sd	a4,104(sp)
    8000625c:	06f13823          	sd	a5,112(sp)
    80006260:	07013c23          	sd	a6,120(sp)
    80006264:	09113023          	sd	a7,128(sp)
    80006268:	09213423          	sd	s2,136(sp)
    8000626c:	09313823          	sd	s3,144(sp)
    80006270:	09413c23          	sd	s4,152(sp)
    80006274:	0b513023          	sd	s5,160(sp)
    80006278:	0b613423          	sd	s6,168(sp)
    8000627c:	0b713823          	sd	s7,176(sp)
    80006280:	0b813c23          	sd	s8,184(sp)
    80006284:	0d913023          	sd	s9,192(sp)
    80006288:	0da13423          	sd	s10,200(sp)
    8000628c:	0db13823          	sd	s11,208(sp)
    80006290:	0dc13c23          	sd	t3,216(sp)
    80006294:	0fd13023          	sd	t4,224(sp)
    80006298:	0fe13423          	sd	t5,232(sp)
    8000629c:	0ff13823          	sd	t6,240(sp)
    800062a0:	ccdff0ef          	jal	ra,80005f6c <kerneltrap>
    800062a4:	00013083          	ld	ra,0(sp)
    800062a8:	00813103          	ld	sp,8(sp)
    800062ac:	01013183          	ld	gp,16(sp)
    800062b0:	02013283          	ld	t0,32(sp)
    800062b4:	02813303          	ld	t1,40(sp)
    800062b8:	03013383          	ld	t2,48(sp)
    800062bc:	03813403          	ld	s0,56(sp)
    800062c0:	04013483          	ld	s1,64(sp)
    800062c4:	04813503          	ld	a0,72(sp)
    800062c8:	05013583          	ld	a1,80(sp)
    800062cc:	05813603          	ld	a2,88(sp)
    800062d0:	06013683          	ld	a3,96(sp)
    800062d4:	06813703          	ld	a4,104(sp)
    800062d8:	07013783          	ld	a5,112(sp)
    800062dc:	07813803          	ld	a6,120(sp)
    800062e0:	08013883          	ld	a7,128(sp)
    800062e4:	08813903          	ld	s2,136(sp)
    800062e8:	09013983          	ld	s3,144(sp)
    800062ec:	09813a03          	ld	s4,152(sp)
    800062f0:	0a013a83          	ld	s5,160(sp)
    800062f4:	0a813b03          	ld	s6,168(sp)
    800062f8:	0b013b83          	ld	s7,176(sp)
    800062fc:	0b813c03          	ld	s8,184(sp)
    80006300:	0c013c83          	ld	s9,192(sp)
    80006304:	0c813d03          	ld	s10,200(sp)
    80006308:	0d013d83          	ld	s11,208(sp)
    8000630c:	0d813e03          	ld	t3,216(sp)
    80006310:	0e013e83          	ld	t4,224(sp)
    80006314:	0e813f03          	ld	t5,232(sp)
    80006318:	0f013f83          	ld	t6,240(sp)
    8000631c:	10010113          	addi	sp,sp,256
    80006320:	10200073          	sret
    80006324:	00000013          	nop
    80006328:	00000013          	nop
    8000632c:	00000013          	nop

0000000080006330 <timervec>:
    80006330:	34051573          	csrrw	a0,mscratch,a0
    80006334:	00b53023          	sd	a1,0(a0)
    80006338:	00c53423          	sd	a2,8(a0)
    8000633c:	00d53823          	sd	a3,16(a0)
    80006340:	01853583          	ld	a1,24(a0)
    80006344:	02053603          	ld	a2,32(a0)
    80006348:	0005b683          	ld	a3,0(a1)
    8000634c:	00c686b3          	add	a3,a3,a2
    80006350:	00d5b023          	sd	a3,0(a1)
    80006354:	00200593          	li	a1,2
    80006358:	14459073          	csrw	sip,a1
    8000635c:	01053683          	ld	a3,16(a0)
    80006360:	00853603          	ld	a2,8(a0)
    80006364:	00053583          	ld	a1,0(a0)
    80006368:	34051573          	csrrw	a0,mscratch,a0
    8000636c:	30200073          	mret

0000000080006370 <plicinit>:
    80006370:	ff010113          	addi	sp,sp,-16
    80006374:	00813423          	sd	s0,8(sp)
    80006378:	01010413          	addi	s0,sp,16
    8000637c:	00813403          	ld	s0,8(sp)
    80006380:	0c0007b7          	lui	a5,0xc000
    80006384:	00100713          	li	a4,1
    80006388:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    8000638c:	00e7a223          	sw	a4,4(a5)
    80006390:	01010113          	addi	sp,sp,16
    80006394:	00008067          	ret

0000000080006398 <plicinithart>:
    80006398:	ff010113          	addi	sp,sp,-16
    8000639c:	00813023          	sd	s0,0(sp)
    800063a0:	00113423          	sd	ra,8(sp)
    800063a4:	01010413          	addi	s0,sp,16
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	a44080e7          	jalr	-1468(ra) # 80005dec <cpuid>
    800063b0:	0085171b          	slliw	a4,a0,0x8
    800063b4:	0c0027b7          	lui	a5,0xc002
    800063b8:	00e787b3          	add	a5,a5,a4
    800063bc:	40200713          	li	a4,1026
    800063c0:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    800063c4:	00813083          	ld	ra,8(sp)
    800063c8:	00013403          	ld	s0,0(sp)
    800063cc:	00d5151b          	slliw	a0,a0,0xd
    800063d0:	0c2017b7          	lui	a5,0xc201
    800063d4:	00a78533          	add	a0,a5,a0
    800063d8:	00052023          	sw	zero,0(a0)
    800063dc:	01010113          	addi	sp,sp,16
    800063e0:	00008067          	ret

00000000800063e4 <plic_claim>:
    800063e4:	ff010113          	addi	sp,sp,-16
    800063e8:	00813023          	sd	s0,0(sp)
    800063ec:	00113423          	sd	ra,8(sp)
    800063f0:	01010413          	addi	s0,sp,16
    800063f4:	00000097          	auipc	ra,0x0
    800063f8:	9f8080e7          	jalr	-1544(ra) # 80005dec <cpuid>
    800063fc:	00813083          	ld	ra,8(sp)
    80006400:	00013403          	ld	s0,0(sp)
    80006404:	00d5151b          	slliw	a0,a0,0xd
    80006408:	0c2017b7          	lui	a5,0xc201
    8000640c:	00a78533          	add	a0,a5,a0
    80006410:	00452503          	lw	a0,4(a0)
    80006414:	01010113          	addi	sp,sp,16
    80006418:	00008067          	ret

000000008000641c <plic_complete>:
    8000641c:	fe010113          	addi	sp,sp,-32
    80006420:	00813823          	sd	s0,16(sp)
    80006424:	00913423          	sd	s1,8(sp)
    80006428:	00113c23          	sd	ra,24(sp)
    8000642c:	02010413          	addi	s0,sp,32
    80006430:	00050493          	mv	s1,a0
    80006434:	00000097          	auipc	ra,0x0
    80006438:	9b8080e7          	jalr	-1608(ra) # 80005dec <cpuid>
    8000643c:	01813083          	ld	ra,24(sp)
    80006440:	01013403          	ld	s0,16(sp)
    80006444:	00d5179b          	slliw	a5,a0,0xd
    80006448:	0c201737          	lui	a4,0xc201
    8000644c:	00f707b3          	add	a5,a4,a5
    80006450:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    80006454:	00813483          	ld	s1,8(sp)
    80006458:	02010113          	addi	sp,sp,32
    8000645c:	00008067          	ret

0000000080006460 <consolewrite>:
    80006460:	fb010113          	addi	sp,sp,-80
    80006464:	04813023          	sd	s0,64(sp)
    80006468:	04113423          	sd	ra,72(sp)
    8000646c:	02913c23          	sd	s1,56(sp)
    80006470:	03213823          	sd	s2,48(sp)
    80006474:	03313423          	sd	s3,40(sp)
    80006478:	03413023          	sd	s4,32(sp)
    8000647c:	01513c23          	sd	s5,24(sp)
    80006480:	05010413          	addi	s0,sp,80
    80006484:	06c05c63          	blez	a2,800064fc <consolewrite+0x9c>
    80006488:	00060993          	mv	s3,a2
    8000648c:	00050a13          	mv	s4,a0
    80006490:	00058493          	mv	s1,a1
    80006494:	00000913          	li	s2,0
    80006498:	fff00a93          	li	s5,-1
    8000649c:	01c0006f          	j	800064b8 <consolewrite+0x58>
    800064a0:	fbf44503          	lbu	a0,-65(s0)
    800064a4:	0019091b          	addiw	s2,s2,1
    800064a8:	00148493          	addi	s1,s1,1
    800064ac:	00001097          	auipc	ra,0x1
    800064b0:	a9c080e7          	jalr	-1380(ra) # 80006f48 <uartputc>
    800064b4:	03298063          	beq	s3,s2,800064d4 <consolewrite+0x74>
    800064b8:	00048613          	mv	a2,s1
    800064bc:	00100693          	li	a3,1
    800064c0:	000a0593          	mv	a1,s4
    800064c4:	fbf40513          	addi	a0,s0,-65
    800064c8:	00000097          	auipc	ra,0x0
    800064cc:	9dc080e7          	jalr	-1572(ra) # 80005ea4 <either_copyin>
    800064d0:	fd5518e3          	bne	a0,s5,800064a0 <consolewrite+0x40>
    800064d4:	04813083          	ld	ra,72(sp)
    800064d8:	04013403          	ld	s0,64(sp)
    800064dc:	03813483          	ld	s1,56(sp)
    800064e0:	02813983          	ld	s3,40(sp)
    800064e4:	02013a03          	ld	s4,32(sp)
    800064e8:	01813a83          	ld	s5,24(sp)
    800064ec:	00090513          	mv	a0,s2
    800064f0:	03013903          	ld	s2,48(sp)
    800064f4:	05010113          	addi	sp,sp,80
    800064f8:	00008067          	ret
    800064fc:	00000913          	li	s2,0
    80006500:	fd5ff06f          	j	800064d4 <consolewrite+0x74>

0000000080006504 <consoleread>:
    80006504:	f9010113          	addi	sp,sp,-112
    80006508:	06813023          	sd	s0,96(sp)
    8000650c:	04913c23          	sd	s1,88(sp)
    80006510:	05213823          	sd	s2,80(sp)
    80006514:	05313423          	sd	s3,72(sp)
    80006518:	05413023          	sd	s4,64(sp)
    8000651c:	03513c23          	sd	s5,56(sp)
    80006520:	03613823          	sd	s6,48(sp)
    80006524:	03713423          	sd	s7,40(sp)
    80006528:	03813023          	sd	s8,32(sp)
    8000652c:	06113423          	sd	ra,104(sp)
    80006530:	01913c23          	sd	s9,24(sp)
    80006534:	07010413          	addi	s0,sp,112
    80006538:	00060b93          	mv	s7,a2
    8000653c:	00050913          	mv	s2,a0
    80006540:	00058c13          	mv	s8,a1
    80006544:	00060b1b          	sext.w	s6,a2
    80006548:	00005497          	auipc	s1,0x5
    8000654c:	56048493          	addi	s1,s1,1376 # 8000baa8 <cons>
    80006550:	00400993          	li	s3,4
    80006554:	fff00a13          	li	s4,-1
    80006558:	00a00a93          	li	s5,10
    8000655c:	05705e63          	blez	s7,800065b8 <consoleread+0xb4>
    80006560:	09c4a703          	lw	a4,156(s1)
    80006564:	0984a783          	lw	a5,152(s1)
    80006568:	0007071b          	sext.w	a4,a4
    8000656c:	08e78463          	beq	a5,a4,800065f4 <consoleread+0xf0>
    80006570:	07f7f713          	andi	a4,a5,127
    80006574:	00e48733          	add	a4,s1,a4
    80006578:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    8000657c:	0017869b          	addiw	a3,a5,1
    80006580:	08d4ac23          	sw	a3,152(s1)
    80006584:	00070c9b          	sext.w	s9,a4
    80006588:	0b370663          	beq	a4,s3,80006634 <consoleread+0x130>
    8000658c:	00100693          	li	a3,1
    80006590:	f9f40613          	addi	a2,s0,-97
    80006594:	000c0593          	mv	a1,s8
    80006598:	00090513          	mv	a0,s2
    8000659c:	f8e40fa3          	sb	a4,-97(s0)
    800065a0:	00000097          	auipc	ra,0x0
    800065a4:	8b8080e7          	jalr	-1864(ra) # 80005e58 <either_copyout>
    800065a8:	01450863          	beq	a0,s4,800065b8 <consoleread+0xb4>
    800065ac:	001c0c13          	addi	s8,s8,1
    800065b0:	fffb8b9b          	addiw	s7,s7,-1
    800065b4:	fb5c94e3          	bne	s9,s5,8000655c <consoleread+0x58>
    800065b8:	000b851b          	sext.w	a0,s7
    800065bc:	06813083          	ld	ra,104(sp)
    800065c0:	06013403          	ld	s0,96(sp)
    800065c4:	05813483          	ld	s1,88(sp)
    800065c8:	05013903          	ld	s2,80(sp)
    800065cc:	04813983          	ld	s3,72(sp)
    800065d0:	04013a03          	ld	s4,64(sp)
    800065d4:	03813a83          	ld	s5,56(sp)
    800065d8:	02813b83          	ld	s7,40(sp)
    800065dc:	02013c03          	ld	s8,32(sp)
    800065e0:	01813c83          	ld	s9,24(sp)
    800065e4:	40ab053b          	subw	a0,s6,a0
    800065e8:	03013b03          	ld	s6,48(sp)
    800065ec:	07010113          	addi	sp,sp,112
    800065f0:	00008067          	ret
    800065f4:	00001097          	auipc	ra,0x1
    800065f8:	1d8080e7          	jalr	472(ra) # 800077cc <push_on>
    800065fc:	0984a703          	lw	a4,152(s1)
    80006600:	09c4a783          	lw	a5,156(s1)
    80006604:	0007879b          	sext.w	a5,a5
    80006608:	fef70ce3          	beq	a4,a5,80006600 <consoleread+0xfc>
    8000660c:	00001097          	auipc	ra,0x1
    80006610:	234080e7          	jalr	564(ra) # 80007840 <pop_on>
    80006614:	0984a783          	lw	a5,152(s1)
    80006618:	07f7f713          	andi	a4,a5,127
    8000661c:	00e48733          	add	a4,s1,a4
    80006620:	01874703          	lbu	a4,24(a4)
    80006624:	0017869b          	addiw	a3,a5,1
    80006628:	08d4ac23          	sw	a3,152(s1)
    8000662c:	00070c9b          	sext.w	s9,a4
    80006630:	f5371ee3          	bne	a4,s3,8000658c <consoleread+0x88>
    80006634:	000b851b          	sext.w	a0,s7
    80006638:	f96bf2e3          	bgeu	s7,s6,800065bc <consoleread+0xb8>
    8000663c:	08f4ac23          	sw	a5,152(s1)
    80006640:	f7dff06f          	j	800065bc <consoleread+0xb8>

0000000080006644 <consputc>:
    80006644:	10000793          	li	a5,256
    80006648:	00f50663          	beq	a0,a5,80006654 <consputc+0x10>
    8000664c:	00001317          	auipc	t1,0x1
    80006650:	9f430067          	jr	-1548(t1) # 80007040 <uartputc_sync>
    80006654:	ff010113          	addi	sp,sp,-16
    80006658:	00113423          	sd	ra,8(sp)
    8000665c:	00813023          	sd	s0,0(sp)
    80006660:	01010413          	addi	s0,sp,16
    80006664:	00800513          	li	a0,8
    80006668:	00001097          	auipc	ra,0x1
    8000666c:	9d8080e7          	jalr	-1576(ra) # 80007040 <uartputc_sync>
    80006670:	02000513          	li	a0,32
    80006674:	00001097          	auipc	ra,0x1
    80006678:	9cc080e7          	jalr	-1588(ra) # 80007040 <uartputc_sync>
    8000667c:	00013403          	ld	s0,0(sp)
    80006680:	00813083          	ld	ra,8(sp)
    80006684:	00800513          	li	a0,8
    80006688:	01010113          	addi	sp,sp,16
    8000668c:	00001317          	auipc	t1,0x1
    80006690:	9b430067          	jr	-1612(t1) # 80007040 <uartputc_sync>

0000000080006694 <consoleintr>:
    80006694:	fe010113          	addi	sp,sp,-32
    80006698:	00813823          	sd	s0,16(sp)
    8000669c:	00913423          	sd	s1,8(sp)
    800066a0:	01213023          	sd	s2,0(sp)
    800066a4:	00113c23          	sd	ra,24(sp)
    800066a8:	02010413          	addi	s0,sp,32
    800066ac:	00005917          	auipc	s2,0x5
    800066b0:	3fc90913          	addi	s2,s2,1020 # 8000baa8 <cons>
    800066b4:	00050493          	mv	s1,a0
    800066b8:	00090513          	mv	a0,s2
    800066bc:	00001097          	auipc	ra,0x1
    800066c0:	e40080e7          	jalr	-448(ra) # 800074fc <acquire>
    800066c4:	02048c63          	beqz	s1,800066fc <consoleintr+0x68>
    800066c8:	0a092783          	lw	a5,160(s2)
    800066cc:	09892703          	lw	a4,152(s2)
    800066d0:	07f00693          	li	a3,127
    800066d4:	40e7873b          	subw	a4,a5,a4
    800066d8:	02e6e263          	bltu	a3,a4,800066fc <consoleintr+0x68>
    800066dc:	00d00713          	li	a4,13
    800066e0:	04e48063          	beq	s1,a4,80006720 <consoleintr+0x8c>
    800066e4:	07f7f713          	andi	a4,a5,127
    800066e8:	00e90733          	add	a4,s2,a4
    800066ec:	0017879b          	addiw	a5,a5,1
    800066f0:	0af92023          	sw	a5,160(s2)
    800066f4:	00970c23          	sb	s1,24(a4)
    800066f8:	08f92e23          	sw	a5,156(s2)
    800066fc:	01013403          	ld	s0,16(sp)
    80006700:	01813083          	ld	ra,24(sp)
    80006704:	00813483          	ld	s1,8(sp)
    80006708:	00013903          	ld	s2,0(sp)
    8000670c:	00005517          	auipc	a0,0x5
    80006710:	39c50513          	addi	a0,a0,924 # 8000baa8 <cons>
    80006714:	02010113          	addi	sp,sp,32
    80006718:	00001317          	auipc	t1,0x1
    8000671c:	eb030067          	jr	-336(t1) # 800075c8 <release>
    80006720:	00a00493          	li	s1,10
    80006724:	fc1ff06f          	j	800066e4 <consoleintr+0x50>

0000000080006728 <consoleinit>:
    80006728:	fe010113          	addi	sp,sp,-32
    8000672c:	00113c23          	sd	ra,24(sp)
    80006730:	00813823          	sd	s0,16(sp)
    80006734:	00913423          	sd	s1,8(sp)
    80006738:	02010413          	addi	s0,sp,32
    8000673c:	00005497          	auipc	s1,0x5
    80006740:	36c48493          	addi	s1,s1,876 # 8000baa8 <cons>
    80006744:	00048513          	mv	a0,s1
    80006748:	00002597          	auipc	a1,0x2
    8000674c:	cf858593          	addi	a1,a1,-776 # 80008440 <CONSOLE_STATUS+0x430>
    80006750:	00001097          	auipc	ra,0x1
    80006754:	d88080e7          	jalr	-632(ra) # 800074d8 <initlock>
    80006758:	00000097          	auipc	ra,0x0
    8000675c:	7ac080e7          	jalr	1964(ra) # 80006f04 <uartinit>
    80006760:	01813083          	ld	ra,24(sp)
    80006764:	01013403          	ld	s0,16(sp)
    80006768:	00000797          	auipc	a5,0x0
    8000676c:	d9c78793          	addi	a5,a5,-612 # 80006504 <consoleread>
    80006770:	0af4bc23          	sd	a5,184(s1)
    80006774:	00000797          	auipc	a5,0x0
    80006778:	cec78793          	addi	a5,a5,-788 # 80006460 <consolewrite>
    8000677c:	0cf4b023          	sd	a5,192(s1)
    80006780:	00813483          	ld	s1,8(sp)
    80006784:	02010113          	addi	sp,sp,32
    80006788:	00008067          	ret

000000008000678c <console_read>:
    8000678c:	ff010113          	addi	sp,sp,-16
    80006790:	00813423          	sd	s0,8(sp)
    80006794:	01010413          	addi	s0,sp,16
    80006798:	00813403          	ld	s0,8(sp)
    8000679c:	00005317          	auipc	t1,0x5
    800067a0:	3c433303          	ld	t1,964(t1) # 8000bb60 <devsw+0x10>
    800067a4:	01010113          	addi	sp,sp,16
    800067a8:	00030067          	jr	t1

00000000800067ac <console_write>:
    800067ac:	ff010113          	addi	sp,sp,-16
    800067b0:	00813423          	sd	s0,8(sp)
    800067b4:	01010413          	addi	s0,sp,16
    800067b8:	00813403          	ld	s0,8(sp)
    800067bc:	00005317          	auipc	t1,0x5
    800067c0:	3ac33303          	ld	t1,940(t1) # 8000bb68 <devsw+0x18>
    800067c4:	01010113          	addi	sp,sp,16
    800067c8:	00030067          	jr	t1

00000000800067cc <panic>:
    800067cc:	fe010113          	addi	sp,sp,-32
    800067d0:	00113c23          	sd	ra,24(sp)
    800067d4:	00813823          	sd	s0,16(sp)
    800067d8:	00913423          	sd	s1,8(sp)
    800067dc:	02010413          	addi	s0,sp,32
    800067e0:	00050493          	mv	s1,a0
    800067e4:	00002517          	auipc	a0,0x2
    800067e8:	c6450513          	addi	a0,a0,-924 # 80008448 <CONSOLE_STATUS+0x438>
    800067ec:	00005797          	auipc	a5,0x5
    800067f0:	4007ae23          	sw	zero,1052(a5) # 8000bc08 <pr+0x18>
    800067f4:	00000097          	auipc	ra,0x0
    800067f8:	034080e7          	jalr	52(ra) # 80006828 <__printf>
    800067fc:	00048513          	mv	a0,s1
    80006800:	00000097          	auipc	ra,0x0
    80006804:	028080e7          	jalr	40(ra) # 80006828 <__printf>
    80006808:	00002517          	auipc	a0,0x2
    8000680c:	98050513          	addi	a0,a0,-1664 # 80008188 <CONSOLE_STATUS+0x178>
    80006810:	00000097          	auipc	ra,0x0
    80006814:	018080e7          	jalr	24(ra) # 80006828 <__printf>
    80006818:	00100793          	li	a5,1
    8000681c:	00004717          	auipc	a4,0x4
    80006820:	e4f72623          	sw	a5,-436(a4) # 8000a668 <panicked>
    80006824:	0000006f          	j	80006824 <panic+0x58>

0000000080006828 <__printf>:
    80006828:	f3010113          	addi	sp,sp,-208
    8000682c:	08813023          	sd	s0,128(sp)
    80006830:	07313423          	sd	s3,104(sp)
    80006834:	09010413          	addi	s0,sp,144
    80006838:	05813023          	sd	s8,64(sp)
    8000683c:	08113423          	sd	ra,136(sp)
    80006840:	06913c23          	sd	s1,120(sp)
    80006844:	07213823          	sd	s2,112(sp)
    80006848:	07413023          	sd	s4,96(sp)
    8000684c:	05513c23          	sd	s5,88(sp)
    80006850:	05613823          	sd	s6,80(sp)
    80006854:	05713423          	sd	s7,72(sp)
    80006858:	03913c23          	sd	s9,56(sp)
    8000685c:	03a13823          	sd	s10,48(sp)
    80006860:	03b13423          	sd	s11,40(sp)
    80006864:	00005317          	auipc	t1,0x5
    80006868:	38c30313          	addi	t1,t1,908 # 8000bbf0 <pr>
    8000686c:	01832c03          	lw	s8,24(t1)
    80006870:	00b43423          	sd	a1,8(s0)
    80006874:	00c43823          	sd	a2,16(s0)
    80006878:	00d43c23          	sd	a3,24(s0)
    8000687c:	02e43023          	sd	a4,32(s0)
    80006880:	02f43423          	sd	a5,40(s0)
    80006884:	03043823          	sd	a6,48(s0)
    80006888:	03143c23          	sd	a7,56(s0)
    8000688c:	00050993          	mv	s3,a0
    80006890:	4a0c1663          	bnez	s8,80006d3c <__printf+0x514>
    80006894:	60098c63          	beqz	s3,80006eac <__printf+0x684>
    80006898:	0009c503          	lbu	a0,0(s3)
    8000689c:	00840793          	addi	a5,s0,8
    800068a0:	f6f43c23          	sd	a5,-136(s0)
    800068a4:	00000493          	li	s1,0
    800068a8:	22050063          	beqz	a0,80006ac8 <__printf+0x2a0>
    800068ac:	00002a37          	lui	s4,0x2
    800068b0:	00018ab7          	lui	s5,0x18
    800068b4:	000f4b37          	lui	s6,0xf4
    800068b8:	00989bb7          	lui	s7,0x989
    800068bc:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    800068c0:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    800068c4:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    800068c8:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    800068cc:	00148c9b          	addiw	s9,s1,1
    800068d0:	02500793          	li	a5,37
    800068d4:	01998933          	add	s2,s3,s9
    800068d8:	38f51263          	bne	a0,a5,80006c5c <__printf+0x434>
    800068dc:	00094783          	lbu	a5,0(s2)
    800068e0:	00078c9b          	sext.w	s9,a5
    800068e4:	1e078263          	beqz	a5,80006ac8 <__printf+0x2a0>
    800068e8:	0024849b          	addiw	s1,s1,2
    800068ec:	07000713          	li	a4,112
    800068f0:	00998933          	add	s2,s3,s1
    800068f4:	38e78a63          	beq	a5,a4,80006c88 <__printf+0x460>
    800068f8:	20f76863          	bltu	a4,a5,80006b08 <__printf+0x2e0>
    800068fc:	42a78863          	beq	a5,a0,80006d2c <__printf+0x504>
    80006900:	06400713          	li	a4,100
    80006904:	40e79663          	bne	a5,a4,80006d10 <__printf+0x4e8>
    80006908:	f7843783          	ld	a5,-136(s0)
    8000690c:	0007a603          	lw	a2,0(a5)
    80006910:	00878793          	addi	a5,a5,8
    80006914:	f6f43c23          	sd	a5,-136(s0)
    80006918:	42064a63          	bltz	a2,80006d4c <__printf+0x524>
    8000691c:	00a00713          	li	a4,10
    80006920:	02e677bb          	remuw	a5,a2,a4
    80006924:	00002d97          	auipc	s11,0x2
    80006928:	b4cd8d93          	addi	s11,s11,-1204 # 80008470 <digits>
    8000692c:	00900593          	li	a1,9
    80006930:	0006051b          	sext.w	a0,a2
    80006934:	00000c93          	li	s9,0
    80006938:	02079793          	slli	a5,a5,0x20
    8000693c:	0207d793          	srli	a5,a5,0x20
    80006940:	00fd87b3          	add	a5,s11,a5
    80006944:	0007c783          	lbu	a5,0(a5)
    80006948:	02e656bb          	divuw	a3,a2,a4
    8000694c:	f8f40023          	sb	a5,-128(s0)
    80006950:	14c5d863          	bge	a1,a2,80006aa0 <__printf+0x278>
    80006954:	06300593          	li	a1,99
    80006958:	00100c93          	li	s9,1
    8000695c:	02e6f7bb          	remuw	a5,a3,a4
    80006960:	02079793          	slli	a5,a5,0x20
    80006964:	0207d793          	srli	a5,a5,0x20
    80006968:	00fd87b3          	add	a5,s11,a5
    8000696c:	0007c783          	lbu	a5,0(a5)
    80006970:	02e6d73b          	divuw	a4,a3,a4
    80006974:	f8f400a3          	sb	a5,-127(s0)
    80006978:	12a5f463          	bgeu	a1,a0,80006aa0 <__printf+0x278>
    8000697c:	00a00693          	li	a3,10
    80006980:	00900593          	li	a1,9
    80006984:	02d777bb          	remuw	a5,a4,a3
    80006988:	02079793          	slli	a5,a5,0x20
    8000698c:	0207d793          	srli	a5,a5,0x20
    80006990:	00fd87b3          	add	a5,s11,a5
    80006994:	0007c503          	lbu	a0,0(a5)
    80006998:	02d757bb          	divuw	a5,a4,a3
    8000699c:	f8a40123          	sb	a0,-126(s0)
    800069a0:	48e5f263          	bgeu	a1,a4,80006e24 <__printf+0x5fc>
    800069a4:	06300513          	li	a0,99
    800069a8:	02d7f5bb          	remuw	a1,a5,a3
    800069ac:	02059593          	slli	a1,a1,0x20
    800069b0:	0205d593          	srli	a1,a1,0x20
    800069b4:	00bd85b3          	add	a1,s11,a1
    800069b8:	0005c583          	lbu	a1,0(a1)
    800069bc:	02d7d7bb          	divuw	a5,a5,a3
    800069c0:	f8b401a3          	sb	a1,-125(s0)
    800069c4:	48e57263          	bgeu	a0,a4,80006e48 <__printf+0x620>
    800069c8:	3e700513          	li	a0,999
    800069cc:	02d7f5bb          	remuw	a1,a5,a3
    800069d0:	02059593          	slli	a1,a1,0x20
    800069d4:	0205d593          	srli	a1,a1,0x20
    800069d8:	00bd85b3          	add	a1,s11,a1
    800069dc:	0005c583          	lbu	a1,0(a1)
    800069e0:	02d7d7bb          	divuw	a5,a5,a3
    800069e4:	f8b40223          	sb	a1,-124(s0)
    800069e8:	46e57663          	bgeu	a0,a4,80006e54 <__printf+0x62c>
    800069ec:	02d7f5bb          	remuw	a1,a5,a3
    800069f0:	02059593          	slli	a1,a1,0x20
    800069f4:	0205d593          	srli	a1,a1,0x20
    800069f8:	00bd85b3          	add	a1,s11,a1
    800069fc:	0005c583          	lbu	a1,0(a1)
    80006a00:	02d7d7bb          	divuw	a5,a5,a3
    80006a04:	f8b402a3          	sb	a1,-123(s0)
    80006a08:	46ea7863          	bgeu	s4,a4,80006e78 <__printf+0x650>
    80006a0c:	02d7f5bb          	remuw	a1,a5,a3
    80006a10:	02059593          	slli	a1,a1,0x20
    80006a14:	0205d593          	srli	a1,a1,0x20
    80006a18:	00bd85b3          	add	a1,s11,a1
    80006a1c:	0005c583          	lbu	a1,0(a1)
    80006a20:	02d7d7bb          	divuw	a5,a5,a3
    80006a24:	f8b40323          	sb	a1,-122(s0)
    80006a28:	3eeaf863          	bgeu	s5,a4,80006e18 <__printf+0x5f0>
    80006a2c:	02d7f5bb          	remuw	a1,a5,a3
    80006a30:	02059593          	slli	a1,a1,0x20
    80006a34:	0205d593          	srli	a1,a1,0x20
    80006a38:	00bd85b3          	add	a1,s11,a1
    80006a3c:	0005c583          	lbu	a1,0(a1)
    80006a40:	02d7d7bb          	divuw	a5,a5,a3
    80006a44:	f8b403a3          	sb	a1,-121(s0)
    80006a48:	42eb7e63          	bgeu	s6,a4,80006e84 <__printf+0x65c>
    80006a4c:	02d7f5bb          	remuw	a1,a5,a3
    80006a50:	02059593          	slli	a1,a1,0x20
    80006a54:	0205d593          	srli	a1,a1,0x20
    80006a58:	00bd85b3          	add	a1,s11,a1
    80006a5c:	0005c583          	lbu	a1,0(a1)
    80006a60:	02d7d7bb          	divuw	a5,a5,a3
    80006a64:	f8b40423          	sb	a1,-120(s0)
    80006a68:	42ebfc63          	bgeu	s7,a4,80006ea0 <__printf+0x678>
    80006a6c:	02079793          	slli	a5,a5,0x20
    80006a70:	0207d793          	srli	a5,a5,0x20
    80006a74:	00fd8db3          	add	s11,s11,a5
    80006a78:	000dc703          	lbu	a4,0(s11)
    80006a7c:	00a00793          	li	a5,10
    80006a80:	00900c93          	li	s9,9
    80006a84:	f8e404a3          	sb	a4,-119(s0)
    80006a88:	00065c63          	bgez	a2,80006aa0 <__printf+0x278>
    80006a8c:	f9040713          	addi	a4,s0,-112
    80006a90:	00f70733          	add	a4,a4,a5
    80006a94:	02d00693          	li	a3,45
    80006a98:	fed70823          	sb	a3,-16(a4)
    80006a9c:	00078c93          	mv	s9,a5
    80006aa0:	f8040793          	addi	a5,s0,-128
    80006aa4:	01978cb3          	add	s9,a5,s9
    80006aa8:	f7f40d13          	addi	s10,s0,-129
    80006aac:	000cc503          	lbu	a0,0(s9)
    80006ab0:	fffc8c93          	addi	s9,s9,-1
    80006ab4:	00000097          	auipc	ra,0x0
    80006ab8:	b90080e7          	jalr	-1136(ra) # 80006644 <consputc>
    80006abc:	ffac98e3          	bne	s9,s10,80006aac <__printf+0x284>
    80006ac0:	00094503          	lbu	a0,0(s2)
    80006ac4:	e00514e3          	bnez	a0,800068cc <__printf+0xa4>
    80006ac8:	1a0c1663          	bnez	s8,80006c74 <__printf+0x44c>
    80006acc:	08813083          	ld	ra,136(sp)
    80006ad0:	08013403          	ld	s0,128(sp)
    80006ad4:	07813483          	ld	s1,120(sp)
    80006ad8:	07013903          	ld	s2,112(sp)
    80006adc:	06813983          	ld	s3,104(sp)
    80006ae0:	06013a03          	ld	s4,96(sp)
    80006ae4:	05813a83          	ld	s5,88(sp)
    80006ae8:	05013b03          	ld	s6,80(sp)
    80006aec:	04813b83          	ld	s7,72(sp)
    80006af0:	04013c03          	ld	s8,64(sp)
    80006af4:	03813c83          	ld	s9,56(sp)
    80006af8:	03013d03          	ld	s10,48(sp)
    80006afc:	02813d83          	ld	s11,40(sp)
    80006b00:	0d010113          	addi	sp,sp,208
    80006b04:	00008067          	ret
    80006b08:	07300713          	li	a4,115
    80006b0c:	1ce78a63          	beq	a5,a4,80006ce0 <__printf+0x4b8>
    80006b10:	07800713          	li	a4,120
    80006b14:	1ee79e63          	bne	a5,a4,80006d10 <__printf+0x4e8>
    80006b18:	f7843783          	ld	a5,-136(s0)
    80006b1c:	0007a703          	lw	a4,0(a5)
    80006b20:	00878793          	addi	a5,a5,8
    80006b24:	f6f43c23          	sd	a5,-136(s0)
    80006b28:	28074263          	bltz	a4,80006dac <__printf+0x584>
    80006b2c:	00002d97          	auipc	s11,0x2
    80006b30:	944d8d93          	addi	s11,s11,-1724 # 80008470 <digits>
    80006b34:	00f77793          	andi	a5,a4,15
    80006b38:	00fd87b3          	add	a5,s11,a5
    80006b3c:	0007c683          	lbu	a3,0(a5)
    80006b40:	00f00613          	li	a2,15
    80006b44:	0007079b          	sext.w	a5,a4
    80006b48:	f8d40023          	sb	a3,-128(s0)
    80006b4c:	0047559b          	srliw	a1,a4,0x4
    80006b50:	0047569b          	srliw	a3,a4,0x4
    80006b54:	00000c93          	li	s9,0
    80006b58:	0ee65063          	bge	a2,a4,80006c38 <__printf+0x410>
    80006b5c:	00f6f693          	andi	a3,a3,15
    80006b60:	00dd86b3          	add	a3,s11,a3
    80006b64:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    80006b68:	0087d79b          	srliw	a5,a5,0x8
    80006b6c:	00100c93          	li	s9,1
    80006b70:	f8d400a3          	sb	a3,-127(s0)
    80006b74:	0cb67263          	bgeu	a2,a1,80006c38 <__printf+0x410>
    80006b78:	00f7f693          	andi	a3,a5,15
    80006b7c:	00dd86b3          	add	a3,s11,a3
    80006b80:	0006c583          	lbu	a1,0(a3)
    80006b84:	00f00613          	li	a2,15
    80006b88:	0047d69b          	srliw	a3,a5,0x4
    80006b8c:	f8b40123          	sb	a1,-126(s0)
    80006b90:	0047d593          	srli	a1,a5,0x4
    80006b94:	28f67e63          	bgeu	a2,a5,80006e30 <__printf+0x608>
    80006b98:	00f6f693          	andi	a3,a3,15
    80006b9c:	00dd86b3          	add	a3,s11,a3
    80006ba0:	0006c503          	lbu	a0,0(a3)
    80006ba4:	0087d813          	srli	a6,a5,0x8
    80006ba8:	0087d69b          	srliw	a3,a5,0x8
    80006bac:	f8a401a3          	sb	a0,-125(s0)
    80006bb0:	28b67663          	bgeu	a2,a1,80006e3c <__printf+0x614>
    80006bb4:	00f6f693          	andi	a3,a3,15
    80006bb8:	00dd86b3          	add	a3,s11,a3
    80006bbc:	0006c583          	lbu	a1,0(a3)
    80006bc0:	00c7d513          	srli	a0,a5,0xc
    80006bc4:	00c7d69b          	srliw	a3,a5,0xc
    80006bc8:	f8b40223          	sb	a1,-124(s0)
    80006bcc:	29067a63          	bgeu	a2,a6,80006e60 <__printf+0x638>
    80006bd0:	00f6f693          	andi	a3,a3,15
    80006bd4:	00dd86b3          	add	a3,s11,a3
    80006bd8:	0006c583          	lbu	a1,0(a3)
    80006bdc:	0107d813          	srli	a6,a5,0x10
    80006be0:	0107d69b          	srliw	a3,a5,0x10
    80006be4:	f8b402a3          	sb	a1,-123(s0)
    80006be8:	28a67263          	bgeu	a2,a0,80006e6c <__printf+0x644>
    80006bec:	00f6f693          	andi	a3,a3,15
    80006bf0:	00dd86b3          	add	a3,s11,a3
    80006bf4:	0006c683          	lbu	a3,0(a3)
    80006bf8:	0147d79b          	srliw	a5,a5,0x14
    80006bfc:	f8d40323          	sb	a3,-122(s0)
    80006c00:	21067663          	bgeu	a2,a6,80006e0c <__printf+0x5e4>
    80006c04:	02079793          	slli	a5,a5,0x20
    80006c08:	0207d793          	srli	a5,a5,0x20
    80006c0c:	00fd8db3          	add	s11,s11,a5
    80006c10:	000dc683          	lbu	a3,0(s11)
    80006c14:	00800793          	li	a5,8
    80006c18:	00700c93          	li	s9,7
    80006c1c:	f8d403a3          	sb	a3,-121(s0)
    80006c20:	00075c63          	bgez	a4,80006c38 <__printf+0x410>
    80006c24:	f9040713          	addi	a4,s0,-112
    80006c28:	00f70733          	add	a4,a4,a5
    80006c2c:	02d00693          	li	a3,45
    80006c30:	fed70823          	sb	a3,-16(a4)
    80006c34:	00078c93          	mv	s9,a5
    80006c38:	f8040793          	addi	a5,s0,-128
    80006c3c:	01978cb3          	add	s9,a5,s9
    80006c40:	f7f40d13          	addi	s10,s0,-129
    80006c44:	000cc503          	lbu	a0,0(s9)
    80006c48:	fffc8c93          	addi	s9,s9,-1
    80006c4c:	00000097          	auipc	ra,0x0
    80006c50:	9f8080e7          	jalr	-1544(ra) # 80006644 <consputc>
    80006c54:	ff9d18e3          	bne	s10,s9,80006c44 <__printf+0x41c>
    80006c58:	0100006f          	j	80006c68 <__printf+0x440>
    80006c5c:	00000097          	auipc	ra,0x0
    80006c60:	9e8080e7          	jalr	-1560(ra) # 80006644 <consputc>
    80006c64:	000c8493          	mv	s1,s9
    80006c68:	00094503          	lbu	a0,0(s2)
    80006c6c:	c60510e3          	bnez	a0,800068cc <__printf+0xa4>
    80006c70:	e40c0ee3          	beqz	s8,80006acc <__printf+0x2a4>
    80006c74:	00005517          	auipc	a0,0x5
    80006c78:	f7c50513          	addi	a0,a0,-132 # 8000bbf0 <pr>
    80006c7c:	00001097          	auipc	ra,0x1
    80006c80:	94c080e7          	jalr	-1716(ra) # 800075c8 <release>
    80006c84:	e49ff06f          	j	80006acc <__printf+0x2a4>
    80006c88:	f7843783          	ld	a5,-136(s0)
    80006c8c:	03000513          	li	a0,48
    80006c90:	01000d13          	li	s10,16
    80006c94:	00878713          	addi	a4,a5,8
    80006c98:	0007bc83          	ld	s9,0(a5)
    80006c9c:	f6e43c23          	sd	a4,-136(s0)
    80006ca0:	00000097          	auipc	ra,0x0
    80006ca4:	9a4080e7          	jalr	-1628(ra) # 80006644 <consputc>
    80006ca8:	07800513          	li	a0,120
    80006cac:	00000097          	auipc	ra,0x0
    80006cb0:	998080e7          	jalr	-1640(ra) # 80006644 <consputc>
    80006cb4:	00001d97          	auipc	s11,0x1
    80006cb8:	7bcd8d93          	addi	s11,s11,1980 # 80008470 <digits>
    80006cbc:	03ccd793          	srli	a5,s9,0x3c
    80006cc0:	00fd87b3          	add	a5,s11,a5
    80006cc4:	0007c503          	lbu	a0,0(a5)
    80006cc8:	fffd0d1b          	addiw	s10,s10,-1
    80006ccc:	004c9c93          	slli	s9,s9,0x4
    80006cd0:	00000097          	auipc	ra,0x0
    80006cd4:	974080e7          	jalr	-1676(ra) # 80006644 <consputc>
    80006cd8:	fe0d12e3          	bnez	s10,80006cbc <__printf+0x494>
    80006cdc:	f8dff06f          	j	80006c68 <__printf+0x440>
    80006ce0:	f7843783          	ld	a5,-136(s0)
    80006ce4:	0007bc83          	ld	s9,0(a5)
    80006ce8:	00878793          	addi	a5,a5,8
    80006cec:	f6f43c23          	sd	a5,-136(s0)
    80006cf0:	000c9a63          	bnez	s9,80006d04 <__printf+0x4dc>
    80006cf4:	1080006f          	j	80006dfc <__printf+0x5d4>
    80006cf8:	001c8c93          	addi	s9,s9,1
    80006cfc:	00000097          	auipc	ra,0x0
    80006d00:	948080e7          	jalr	-1720(ra) # 80006644 <consputc>
    80006d04:	000cc503          	lbu	a0,0(s9)
    80006d08:	fe0518e3          	bnez	a0,80006cf8 <__printf+0x4d0>
    80006d0c:	f5dff06f          	j	80006c68 <__printf+0x440>
    80006d10:	02500513          	li	a0,37
    80006d14:	00000097          	auipc	ra,0x0
    80006d18:	930080e7          	jalr	-1744(ra) # 80006644 <consputc>
    80006d1c:	000c8513          	mv	a0,s9
    80006d20:	00000097          	auipc	ra,0x0
    80006d24:	924080e7          	jalr	-1756(ra) # 80006644 <consputc>
    80006d28:	f41ff06f          	j	80006c68 <__printf+0x440>
    80006d2c:	02500513          	li	a0,37
    80006d30:	00000097          	auipc	ra,0x0
    80006d34:	914080e7          	jalr	-1772(ra) # 80006644 <consputc>
    80006d38:	f31ff06f          	j	80006c68 <__printf+0x440>
    80006d3c:	00030513          	mv	a0,t1
    80006d40:	00000097          	auipc	ra,0x0
    80006d44:	7bc080e7          	jalr	1980(ra) # 800074fc <acquire>
    80006d48:	b4dff06f          	j	80006894 <__printf+0x6c>
    80006d4c:	40c0053b          	negw	a0,a2
    80006d50:	00a00713          	li	a4,10
    80006d54:	02e576bb          	remuw	a3,a0,a4
    80006d58:	00001d97          	auipc	s11,0x1
    80006d5c:	718d8d93          	addi	s11,s11,1816 # 80008470 <digits>
    80006d60:	ff700593          	li	a1,-9
    80006d64:	02069693          	slli	a3,a3,0x20
    80006d68:	0206d693          	srli	a3,a3,0x20
    80006d6c:	00dd86b3          	add	a3,s11,a3
    80006d70:	0006c683          	lbu	a3,0(a3)
    80006d74:	02e557bb          	divuw	a5,a0,a4
    80006d78:	f8d40023          	sb	a3,-128(s0)
    80006d7c:	10b65e63          	bge	a2,a1,80006e98 <__printf+0x670>
    80006d80:	06300593          	li	a1,99
    80006d84:	02e7f6bb          	remuw	a3,a5,a4
    80006d88:	02069693          	slli	a3,a3,0x20
    80006d8c:	0206d693          	srli	a3,a3,0x20
    80006d90:	00dd86b3          	add	a3,s11,a3
    80006d94:	0006c683          	lbu	a3,0(a3)
    80006d98:	02e7d73b          	divuw	a4,a5,a4
    80006d9c:	00200793          	li	a5,2
    80006da0:	f8d400a3          	sb	a3,-127(s0)
    80006da4:	bca5ece3          	bltu	a1,a0,8000697c <__printf+0x154>
    80006da8:	ce5ff06f          	j	80006a8c <__printf+0x264>
    80006dac:	40e007bb          	negw	a5,a4
    80006db0:	00001d97          	auipc	s11,0x1
    80006db4:	6c0d8d93          	addi	s11,s11,1728 # 80008470 <digits>
    80006db8:	00f7f693          	andi	a3,a5,15
    80006dbc:	00dd86b3          	add	a3,s11,a3
    80006dc0:	0006c583          	lbu	a1,0(a3)
    80006dc4:	ff100613          	li	a2,-15
    80006dc8:	0047d69b          	srliw	a3,a5,0x4
    80006dcc:	f8b40023          	sb	a1,-128(s0)
    80006dd0:	0047d59b          	srliw	a1,a5,0x4
    80006dd4:	0ac75e63          	bge	a4,a2,80006e90 <__printf+0x668>
    80006dd8:	00f6f693          	andi	a3,a3,15
    80006ddc:	00dd86b3          	add	a3,s11,a3
    80006de0:	0006c603          	lbu	a2,0(a3)
    80006de4:	00f00693          	li	a3,15
    80006de8:	0087d79b          	srliw	a5,a5,0x8
    80006dec:	f8c400a3          	sb	a2,-127(s0)
    80006df0:	d8b6e4e3          	bltu	a3,a1,80006b78 <__printf+0x350>
    80006df4:	00200793          	li	a5,2
    80006df8:	e2dff06f          	j	80006c24 <__printf+0x3fc>
    80006dfc:	00001c97          	auipc	s9,0x1
    80006e00:	654c8c93          	addi	s9,s9,1620 # 80008450 <CONSOLE_STATUS+0x440>
    80006e04:	02800513          	li	a0,40
    80006e08:	ef1ff06f          	j	80006cf8 <__printf+0x4d0>
    80006e0c:	00700793          	li	a5,7
    80006e10:	00600c93          	li	s9,6
    80006e14:	e0dff06f          	j	80006c20 <__printf+0x3f8>
    80006e18:	00700793          	li	a5,7
    80006e1c:	00600c93          	li	s9,6
    80006e20:	c69ff06f          	j	80006a88 <__printf+0x260>
    80006e24:	00300793          	li	a5,3
    80006e28:	00200c93          	li	s9,2
    80006e2c:	c5dff06f          	j	80006a88 <__printf+0x260>
    80006e30:	00300793          	li	a5,3
    80006e34:	00200c93          	li	s9,2
    80006e38:	de9ff06f          	j	80006c20 <__printf+0x3f8>
    80006e3c:	00400793          	li	a5,4
    80006e40:	00300c93          	li	s9,3
    80006e44:	dddff06f          	j	80006c20 <__printf+0x3f8>
    80006e48:	00400793          	li	a5,4
    80006e4c:	00300c93          	li	s9,3
    80006e50:	c39ff06f          	j	80006a88 <__printf+0x260>
    80006e54:	00500793          	li	a5,5
    80006e58:	00400c93          	li	s9,4
    80006e5c:	c2dff06f          	j	80006a88 <__printf+0x260>
    80006e60:	00500793          	li	a5,5
    80006e64:	00400c93          	li	s9,4
    80006e68:	db9ff06f          	j	80006c20 <__printf+0x3f8>
    80006e6c:	00600793          	li	a5,6
    80006e70:	00500c93          	li	s9,5
    80006e74:	dadff06f          	j	80006c20 <__printf+0x3f8>
    80006e78:	00600793          	li	a5,6
    80006e7c:	00500c93          	li	s9,5
    80006e80:	c09ff06f          	j	80006a88 <__printf+0x260>
    80006e84:	00800793          	li	a5,8
    80006e88:	00700c93          	li	s9,7
    80006e8c:	bfdff06f          	j	80006a88 <__printf+0x260>
    80006e90:	00100793          	li	a5,1
    80006e94:	d91ff06f          	j	80006c24 <__printf+0x3fc>
    80006e98:	00100793          	li	a5,1
    80006e9c:	bf1ff06f          	j	80006a8c <__printf+0x264>
    80006ea0:	00900793          	li	a5,9
    80006ea4:	00800c93          	li	s9,8
    80006ea8:	be1ff06f          	j	80006a88 <__printf+0x260>
    80006eac:	00001517          	auipc	a0,0x1
    80006eb0:	5ac50513          	addi	a0,a0,1452 # 80008458 <CONSOLE_STATUS+0x448>
    80006eb4:	00000097          	auipc	ra,0x0
    80006eb8:	918080e7          	jalr	-1768(ra) # 800067cc <panic>

0000000080006ebc <printfinit>:
    80006ebc:	fe010113          	addi	sp,sp,-32
    80006ec0:	00813823          	sd	s0,16(sp)
    80006ec4:	00913423          	sd	s1,8(sp)
    80006ec8:	00113c23          	sd	ra,24(sp)
    80006ecc:	02010413          	addi	s0,sp,32
    80006ed0:	00005497          	auipc	s1,0x5
    80006ed4:	d2048493          	addi	s1,s1,-736 # 8000bbf0 <pr>
    80006ed8:	00048513          	mv	a0,s1
    80006edc:	00001597          	auipc	a1,0x1
    80006ee0:	58c58593          	addi	a1,a1,1420 # 80008468 <CONSOLE_STATUS+0x458>
    80006ee4:	00000097          	auipc	ra,0x0
    80006ee8:	5f4080e7          	jalr	1524(ra) # 800074d8 <initlock>
    80006eec:	01813083          	ld	ra,24(sp)
    80006ef0:	01013403          	ld	s0,16(sp)
    80006ef4:	0004ac23          	sw	zero,24(s1)
    80006ef8:	00813483          	ld	s1,8(sp)
    80006efc:	02010113          	addi	sp,sp,32
    80006f00:	00008067          	ret

0000000080006f04 <uartinit>:
    80006f04:	ff010113          	addi	sp,sp,-16
    80006f08:	00813423          	sd	s0,8(sp)
    80006f0c:	01010413          	addi	s0,sp,16
    80006f10:	100007b7          	lui	a5,0x10000
    80006f14:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    80006f18:	f8000713          	li	a4,-128
    80006f1c:	00e781a3          	sb	a4,3(a5)
    80006f20:	00300713          	li	a4,3
    80006f24:	00e78023          	sb	a4,0(a5)
    80006f28:	000780a3          	sb	zero,1(a5)
    80006f2c:	00e781a3          	sb	a4,3(a5)
    80006f30:	00700693          	li	a3,7
    80006f34:	00d78123          	sb	a3,2(a5)
    80006f38:	00e780a3          	sb	a4,1(a5)
    80006f3c:	00813403          	ld	s0,8(sp)
    80006f40:	01010113          	addi	sp,sp,16
    80006f44:	00008067          	ret

0000000080006f48 <uartputc>:
    80006f48:	00003797          	auipc	a5,0x3
    80006f4c:	7207a783          	lw	a5,1824(a5) # 8000a668 <panicked>
    80006f50:	00078463          	beqz	a5,80006f58 <uartputc+0x10>
    80006f54:	0000006f          	j	80006f54 <uartputc+0xc>
    80006f58:	fd010113          	addi	sp,sp,-48
    80006f5c:	02813023          	sd	s0,32(sp)
    80006f60:	00913c23          	sd	s1,24(sp)
    80006f64:	01213823          	sd	s2,16(sp)
    80006f68:	01313423          	sd	s3,8(sp)
    80006f6c:	02113423          	sd	ra,40(sp)
    80006f70:	03010413          	addi	s0,sp,48
    80006f74:	00003917          	auipc	s2,0x3
    80006f78:	6fc90913          	addi	s2,s2,1788 # 8000a670 <uart_tx_r>
    80006f7c:	00093783          	ld	a5,0(s2)
    80006f80:	00003497          	auipc	s1,0x3
    80006f84:	6f848493          	addi	s1,s1,1784 # 8000a678 <uart_tx_w>
    80006f88:	0004b703          	ld	a4,0(s1)
    80006f8c:	02078693          	addi	a3,a5,32
    80006f90:	00050993          	mv	s3,a0
    80006f94:	02e69c63          	bne	a3,a4,80006fcc <uartputc+0x84>
    80006f98:	00001097          	auipc	ra,0x1
    80006f9c:	834080e7          	jalr	-1996(ra) # 800077cc <push_on>
    80006fa0:	00093783          	ld	a5,0(s2)
    80006fa4:	0004b703          	ld	a4,0(s1)
    80006fa8:	02078793          	addi	a5,a5,32
    80006fac:	00e79463          	bne	a5,a4,80006fb4 <uartputc+0x6c>
    80006fb0:	0000006f          	j	80006fb0 <uartputc+0x68>
    80006fb4:	00001097          	auipc	ra,0x1
    80006fb8:	88c080e7          	jalr	-1908(ra) # 80007840 <pop_on>
    80006fbc:	00093783          	ld	a5,0(s2)
    80006fc0:	0004b703          	ld	a4,0(s1)
    80006fc4:	02078693          	addi	a3,a5,32
    80006fc8:	fce688e3          	beq	a3,a4,80006f98 <uartputc+0x50>
    80006fcc:	01f77693          	andi	a3,a4,31
    80006fd0:	00005597          	auipc	a1,0x5
    80006fd4:	c4058593          	addi	a1,a1,-960 # 8000bc10 <uart_tx_buf>
    80006fd8:	00d586b3          	add	a3,a1,a3
    80006fdc:	00170713          	addi	a4,a4,1
    80006fe0:	01368023          	sb	s3,0(a3)
    80006fe4:	00e4b023          	sd	a4,0(s1)
    80006fe8:	10000637          	lui	a2,0x10000
    80006fec:	02f71063          	bne	a4,a5,8000700c <uartputc+0xc4>
    80006ff0:	0340006f          	j	80007024 <uartputc+0xdc>
    80006ff4:	00074703          	lbu	a4,0(a4)
    80006ff8:	00f93023          	sd	a5,0(s2)
    80006ffc:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    80007000:	00093783          	ld	a5,0(s2)
    80007004:	0004b703          	ld	a4,0(s1)
    80007008:	00f70e63          	beq	a4,a5,80007024 <uartputc+0xdc>
    8000700c:	00564683          	lbu	a3,5(a2)
    80007010:	01f7f713          	andi	a4,a5,31
    80007014:	00e58733          	add	a4,a1,a4
    80007018:	0206f693          	andi	a3,a3,32
    8000701c:	00178793          	addi	a5,a5,1
    80007020:	fc069ae3          	bnez	a3,80006ff4 <uartputc+0xac>
    80007024:	02813083          	ld	ra,40(sp)
    80007028:	02013403          	ld	s0,32(sp)
    8000702c:	01813483          	ld	s1,24(sp)
    80007030:	01013903          	ld	s2,16(sp)
    80007034:	00813983          	ld	s3,8(sp)
    80007038:	03010113          	addi	sp,sp,48
    8000703c:	00008067          	ret

0000000080007040 <uartputc_sync>:
    80007040:	ff010113          	addi	sp,sp,-16
    80007044:	00813423          	sd	s0,8(sp)
    80007048:	01010413          	addi	s0,sp,16
    8000704c:	00003717          	auipc	a4,0x3
    80007050:	61c72703          	lw	a4,1564(a4) # 8000a668 <panicked>
    80007054:	02071663          	bnez	a4,80007080 <uartputc_sync+0x40>
    80007058:	00050793          	mv	a5,a0
    8000705c:	100006b7          	lui	a3,0x10000
    80007060:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    80007064:	02077713          	andi	a4,a4,32
    80007068:	fe070ce3          	beqz	a4,80007060 <uartputc_sync+0x20>
    8000706c:	0ff7f793          	andi	a5,a5,255
    80007070:	00f68023          	sb	a5,0(a3)
    80007074:	00813403          	ld	s0,8(sp)
    80007078:	01010113          	addi	sp,sp,16
    8000707c:	00008067          	ret
    80007080:	0000006f          	j	80007080 <uartputc_sync+0x40>

0000000080007084 <uartstart>:
    80007084:	ff010113          	addi	sp,sp,-16
    80007088:	00813423          	sd	s0,8(sp)
    8000708c:	01010413          	addi	s0,sp,16
    80007090:	00003617          	auipc	a2,0x3
    80007094:	5e060613          	addi	a2,a2,1504 # 8000a670 <uart_tx_r>
    80007098:	00003517          	auipc	a0,0x3
    8000709c:	5e050513          	addi	a0,a0,1504 # 8000a678 <uart_tx_w>
    800070a0:	00063783          	ld	a5,0(a2)
    800070a4:	00053703          	ld	a4,0(a0)
    800070a8:	04f70263          	beq	a4,a5,800070ec <uartstart+0x68>
    800070ac:	100005b7          	lui	a1,0x10000
    800070b0:	00005817          	auipc	a6,0x5
    800070b4:	b6080813          	addi	a6,a6,-1184 # 8000bc10 <uart_tx_buf>
    800070b8:	01c0006f          	j	800070d4 <uartstart+0x50>
    800070bc:	0006c703          	lbu	a4,0(a3)
    800070c0:	00f63023          	sd	a5,0(a2)
    800070c4:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800070c8:	00063783          	ld	a5,0(a2)
    800070cc:	00053703          	ld	a4,0(a0)
    800070d0:	00f70e63          	beq	a4,a5,800070ec <uartstart+0x68>
    800070d4:	01f7f713          	andi	a4,a5,31
    800070d8:	00e806b3          	add	a3,a6,a4
    800070dc:	0055c703          	lbu	a4,5(a1)
    800070e0:	00178793          	addi	a5,a5,1
    800070e4:	02077713          	andi	a4,a4,32
    800070e8:	fc071ae3          	bnez	a4,800070bc <uartstart+0x38>
    800070ec:	00813403          	ld	s0,8(sp)
    800070f0:	01010113          	addi	sp,sp,16
    800070f4:	00008067          	ret

00000000800070f8 <uartgetc>:
    800070f8:	ff010113          	addi	sp,sp,-16
    800070fc:	00813423          	sd	s0,8(sp)
    80007100:	01010413          	addi	s0,sp,16
    80007104:	10000737          	lui	a4,0x10000
    80007108:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000710c:	0017f793          	andi	a5,a5,1
    80007110:	00078c63          	beqz	a5,80007128 <uartgetc+0x30>
    80007114:	00074503          	lbu	a0,0(a4)
    80007118:	0ff57513          	andi	a0,a0,255
    8000711c:	00813403          	ld	s0,8(sp)
    80007120:	01010113          	addi	sp,sp,16
    80007124:	00008067          	ret
    80007128:	fff00513          	li	a0,-1
    8000712c:	ff1ff06f          	j	8000711c <uartgetc+0x24>

0000000080007130 <uartintr>:
    80007130:	100007b7          	lui	a5,0x10000
    80007134:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80007138:	0017f793          	andi	a5,a5,1
    8000713c:	0a078463          	beqz	a5,800071e4 <uartintr+0xb4>
    80007140:	fe010113          	addi	sp,sp,-32
    80007144:	00813823          	sd	s0,16(sp)
    80007148:	00913423          	sd	s1,8(sp)
    8000714c:	00113c23          	sd	ra,24(sp)
    80007150:	02010413          	addi	s0,sp,32
    80007154:	100004b7          	lui	s1,0x10000
    80007158:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    8000715c:	0ff57513          	andi	a0,a0,255
    80007160:	fffff097          	auipc	ra,0xfffff
    80007164:	534080e7          	jalr	1332(ra) # 80006694 <consoleintr>
    80007168:	0054c783          	lbu	a5,5(s1)
    8000716c:	0017f793          	andi	a5,a5,1
    80007170:	fe0794e3          	bnez	a5,80007158 <uartintr+0x28>
    80007174:	00003617          	auipc	a2,0x3
    80007178:	4fc60613          	addi	a2,a2,1276 # 8000a670 <uart_tx_r>
    8000717c:	00003517          	auipc	a0,0x3
    80007180:	4fc50513          	addi	a0,a0,1276 # 8000a678 <uart_tx_w>
    80007184:	00063783          	ld	a5,0(a2)
    80007188:	00053703          	ld	a4,0(a0)
    8000718c:	04f70263          	beq	a4,a5,800071d0 <uartintr+0xa0>
    80007190:	100005b7          	lui	a1,0x10000
    80007194:	00005817          	auipc	a6,0x5
    80007198:	a7c80813          	addi	a6,a6,-1412 # 8000bc10 <uart_tx_buf>
    8000719c:	01c0006f          	j	800071b8 <uartintr+0x88>
    800071a0:	0006c703          	lbu	a4,0(a3)
    800071a4:	00f63023          	sd	a5,0(a2)
    800071a8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800071ac:	00063783          	ld	a5,0(a2)
    800071b0:	00053703          	ld	a4,0(a0)
    800071b4:	00f70e63          	beq	a4,a5,800071d0 <uartintr+0xa0>
    800071b8:	01f7f713          	andi	a4,a5,31
    800071bc:	00e806b3          	add	a3,a6,a4
    800071c0:	0055c703          	lbu	a4,5(a1)
    800071c4:	00178793          	addi	a5,a5,1
    800071c8:	02077713          	andi	a4,a4,32
    800071cc:	fc071ae3          	bnez	a4,800071a0 <uartintr+0x70>
    800071d0:	01813083          	ld	ra,24(sp)
    800071d4:	01013403          	ld	s0,16(sp)
    800071d8:	00813483          	ld	s1,8(sp)
    800071dc:	02010113          	addi	sp,sp,32
    800071e0:	00008067          	ret
    800071e4:	00003617          	auipc	a2,0x3
    800071e8:	48c60613          	addi	a2,a2,1164 # 8000a670 <uart_tx_r>
    800071ec:	00003517          	auipc	a0,0x3
    800071f0:	48c50513          	addi	a0,a0,1164 # 8000a678 <uart_tx_w>
    800071f4:	00063783          	ld	a5,0(a2)
    800071f8:	00053703          	ld	a4,0(a0)
    800071fc:	04f70263          	beq	a4,a5,80007240 <uartintr+0x110>
    80007200:	100005b7          	lui	a1,0x10000
    80007204:	00005817          	auipc	a6,0x5
    80007208:	a0c80813          	addi	a6,a6,-1524 # 8000bc10 <uart_tx_buf>
    8000720c:	01c0006f          	j	80007228 <uartintr+0xf8>
    80007210:	0006c703          	lbu	a4,0(a3)
    80007214:	00f63023          	sd	a5,0(a2)
    80007218:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000721c:	00063783          	ld	a5,0(a2)
    80007220:	00053703          	ld	a4,0(a0)
    80007224:	02f70063          	beq	a4,a5,80007244 <uartintr+0x114>
    80007228:	01f7f713          	andi	a4,a5,31
    8000722c:	00e806b3          	add	a3,a6,a4
    80007230:	0055c703          	lbu	a4,5(a1)
    80007234:	00178793          	addi	a5,a5,1
    80007238:	02077713          	andi	a4,a4,32
    8000723c:	fc071ae3          	bnez	a4,80007210 <uartintr+0xe0>
    80007240:	00008067          	ret
    80007244:	00008067          	ret

0000000080007248 <kinit>:
    80007248:	fc010113          	addi	sp,sp,-64
    8000724c:	02913423          	sd	s1,40(sp)
    80007250:	fffff7b7          	lui	a5,0xfffff
    80007254:	00006497          	auipc	s1,0x6
    80007258:	9db48493          	addi	s1,s1,-1573 # 8000cc2f <end+0xfff>
    8000725c:	02813823          	sd	s0,48(sp)
    80007260:	01313c23          	sd	s3,24(sp)
    80007264:	00f4f4b3          	and	s1,s1,a5
    80007268:	02113c23          	sd	ra,56(sp)
    8000726c:	03213023          	sd	s2,32(sp)
    80007270:	01413823          	sd	s4,16(sp)
    80007274:	01513423          	sd	s5,8(sp)
    80007278:	04010413          	addi	s0,sp,64
    8000727c:	000017b7          	lui	a5,0x1
    80007280:	01100993          	li	s3,17
    80007284:	00f487b3          	add	a5,s1,a5
    80007288:	01b99993          	slli	s3,s3,0x1b
    8000728c:	06f9e063          	bltu	s3,a5,800072ec <kinit+0xa4>
    80007290:	00005a97          	auipc	s5,0x5
    80007294:	9a0a8a93          	addi	s5,s5,-1632 # 8000bc30 <end>
    80007298:	0754ec63          	bltu	s1,s5,80007310 <kinit+0xc8>
    8000729c:	0734fa63          	bgeu	s1,s3,80007310 <kinit+0xc8>
    800072a0:	00088a37          	lui	s4,0x88
    800072a4:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    800072a8:	00003917          	auipc	s2,0x3
    800072ac:	3d890913          	addi	s2,s2,984 # 8000a680 <kmem>
    800072b0:	00ca1a13          	slli	s4,s4,0xc
    800072b4:	0140006f          	j	800072c8 <kinit+0x80>
    800072b8:	000017b7          	lui	a5,0x1
    800072bc:	00f484b3          	add	s1,s1,a5
    800072c0:	0554e863          	bltu	s1,s5,80007310 <kinit+0xc8>
    800072c4:	0534f663          	bgeu	s1,s3,80007310 <kinit+0xc8>
    800072c8:	00001637          	lui	a2,0x1
    800072cc:	00100593          	li	a1,1
    800072d0:	00048513          	mv	a0,s1
    800072d4:	00000097          	auipc	ra,0x0
    800072d8:	5e4080e7          	jalr	1508(ra) # 800078b8 <__memset>
    800072dc:	00093783          	ld	a5,0(s2)
    800072e0:	00f4b023          	sd	a5,0(s1)
    800072e4:	00993023          	sd	s1,0(s2)
    800072e8:	fd4498e3          	bne	s1,s4,800072b8 <kinit+0x70>
    800072ec:	03813083          	ld	ra,56(sp)
    800072f0:	03013403          	ld	s0,48(sp)
    800072f4:	02813483          	ld	s1,40(sp)
    800072f8:	02013903          	ld	s2,32(sp)
    800072fc:	01813983          	ld	s3,24(sp)
    80007300:	01013a03          	ld	s4,16(sp)
    80007304:	00813a83          	ld	s5,8(sp)
    80007308:	04010113          	addi	sp,sp,64
    8000730c:	00008067          	ret
    80007310:	00001517          	auipc	a0,0x1
    80007314:	17850513          	addi	a0,a0,376 # 80008488 <digits+0x18>
    80007318:	fffff097          	auipc	ra,0xfffff
    8000731c:	4b4080e7          	jalr	1204(ra) # 800067cc <panic>

0000000080007320 <freerange>:
    80007320:	fc010113          	addi	sp,sp,-64
    80007324:	000017b7          	lui	a5,0x1
    80007328:	02913423          	sd	s1,40(sp)
    8000732c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80007330:	009504b3          	add	s1,a0,s1
    80007334:	fffff537          	lui	a0,0xfffff
    80007338:	02813823          	sd	s0,48(sp)
    8000733c:	02113c23          	sd	ra,56(sp)
    80007340:	03213023          	sd	s2,32(sp)
    80007344:	01313c23          	sd	s3,24(sp)
    80007348:	01413823          	sd	s4,16(sp)
    8000734c:	01513423          	sd	s5,8(sp)
    80007350:	01613023          	sd	s6,0(sp)
    80007354:	04010413          	addi	s0,sp,64
    80007358:	00a4f4b3          	and	s1,s1,a0
    8000735c:	00f487b3          	add	a5,s1,a5
    80007360:	06f5e463          	bltu	a1,a5,800073c8 <freerange+0xa8>
    80007364:	00005a97          	auipc	s5,0x5
    80007368:	8cca8a93          	addi	s5,s5,-1844 # 8000bc30 <end>
    8000736c:	0954e263          	bltu	s1,s5,800073f0 <freerange+0xd0>
    80007370:	01100993          	li	s3,17
    80007374:	01b99993          	slli	s3,s3,0x1b
    80007378:	0734fc63          	bgeu	s1,s3,800073f0 <freerange+0xd0>
    8000737c:	00058a13          	mv	s4,a1
    80007380:	00003917          	auipc	s2,0x3
    80007384:	30090913          	addi	s2,s2,768 # 8000a680 <kmem>
    80007388:	00002b37          	lui	s6,0x2
    8000738c:	0140006f          	j	800073a0 <freerange+0x80>
    80007390:	000017b7          	lui	a5,0x1
    80007394:	00f484b3          	add	s1,s1,a5
    80007398:	0554ec63          	bltu	s1,s5,800073f0 <freerange+0xd0>
    8000739c:	0534fa63          	bgeu	s1,s3,800073f0 <freerange+0xd0>
    800073a0:	00001637          	lui	a2,0x1
    800073a4:	00100593          	li	a1,1
    800073a8:	00048513          	mv	a0,s1
    800073ac:	00000097          	auipc	ra,0x0
    800073b0:	50c080e7          	jalr	1292(ra) # 800078b8 <__memset>
    800073b4:	00093703          	ld	a4,0(s2)
    800073b8:	016487b3          	add	a5,s1,s6
    800073bc:	00e4b023          	sd	a4,0(s1)
    800073c0:	00993023          	sd	s1,0(s2)
    800073c4:	fcfa76e3          	bgeu	s4,a5,80007390 <freerange+0x70>
    800073c8:	03813083          	ld	ra,56(sp)
    800073cc:	03013403          	ld	s0,48(sp)
    800073d0:	02813483          	ld	s1,40(sp)
    800073d4:	02013903          	ld	s2,32(sp)
    800073d8:	01813983          	ld	s3,24(sp)
    800073dc:	01013a03          	ld	s4,16(sp)
    800073e0:	00813a83          	ld	s5,8(sp)
    800073e4:	00013b03          	ld	s6,0(sp)
    800073e8:	04010113          	addi	sp,sp,64
    800073ec:	00008067          	ret
    800073f0:	00001517          	auipc	a0,0x1
    800073f4:	09850513          	addi	a0,a0,152 # 80008488 <digits+0x18>
    800073f8:	fffff097          	auipc	ra,0xfffff
    800073fc:	3d4080e7          	jalr	980(ra) # 800067cc <panic>

0000000080007400 <kfree>:
    80007400:	fe010113          	addi	sp,sp,-32
    80007404:	00813823          	sd	s0,16(sp)
    80007408:	00113c23          	sd	ra,24(sp)
    8000740c:	00913423          	sd	s1,8(sp)
    80007410:	02010413          	addi	s0,sp,32
    80007414:	03451793          	slli	a5,a0,0x34
    80007418:	04079c63          	bnez	a5,80007470 <kfree+0x70>
    8000741c:	00005797          	auipc	a5,0x5
    80007420:	81478793          	addi	a5,a5,-2028 # 8000bc30 <end>
    80007424:	00050493          	mv	s1,a0
    80007428:	04f56463          	bltu	a0,a5,80007470 <kfree+0x70>
    8000742c:	01100793          	li	a5,17
    80007430:	01b79793          	slli	a5,a5,0x1b
    80007434:	02f57e63          	bgeu	a0,a5,80007470 <kfree+0x70>
    80007438:	00001637          	lui	a2,0x1
    8000743c:	00100593          	li	a1,1
    80007440:	00000097          	auipc	ra,0x0
    80007444:	478080e7          	jalr	1144(ra) # 800078b8 <__memset>
    80007448:	00003797          	auipc	a5,0x3
    8000744c:	23878793          	addi	a5,a5,568 # 8000a680 <kmem>
    80007450:	0007b703          	ld	a4,0(a5)
    80007454:	01813083          	ld	ra,24(sp)
    80007458:	01013403          	ld	s0,16(sp)
    8000745c:	00e4b023          	sd	a4,0(s1)
    80007460:	0097b023          	sd	s1,0(a5)
    80007464:	00813483          	ld	s1,8(sp)
    80007468:	02010113          	addi	sp,sp,32
    8000746c:	00008067          	ret
    80007470:	00001517          	auipc	a0,0x1
    80007474:	01850513          	addi	a0,a0,24 # 80008488 <digits+0x18>
    80007478:	fffff097          	auipc	ra,0xfffff
    8000747c:	354080e7          	jalr	852(ra) # 800067cc <panic>

0000000080007480 <kalloc>:
    80007480:	fe010113          	addi	sp,sp,-32
    80007484:	00813823          	sd	s0,16(sp)
    80007488:	00913423          	sd	s1,8(sp)
    8000748c:	00113c23          	sd	ra,24(sp)
    80007490:	02010413          	addi	s0,sp,32
    80007494:	00003797          	auipc	a5,0x3
    80007498:	1ec78793          	addi	a5,a5,492 # 8000a680 <kmem>
    8000749c:	0007b483          	ld	s1,0(a5)
    800074a0:	02048063          	beqz	s1,800074c0 <kalloc+0x40>
    800074a4:	0004b703          	ld	a4,0(s1)
    800074a8:	00001637          	lui	a2,0x1
    800074ac:	00500593          	li	a1,5
    800074b0:	00048513          	mv	a0,s1
    800074b4:	00e7b023          	sd	a4,0(a5)
    800074b8:	00000097          	auipc	ra,0x0
    800074bc:	400080e7          	jalr	1024(ra) # 800078b8 <__memset>
    800074c0:	01813083          	ld	ra,24(sp)
    800074c4:	01013403          	ld	s0,16(sp)
    800074c8:	00048513          	mv	a0,s1
    800074cc:	00813483          	ld	s1,8(sp)
    800074d0:	02010113          	addi	sp,sp,32
    800074d4:	00008067          	ret

00000000800074d8 <initlock>:
    800074d8:	ff010113          	addi	sp,sp,-16
    800074dc:	00813423          	sd	s0,8(sp)
    800074e0:	01010413          	addi	s0,sp,16
    800074e4:	00813403          	ld	s0,8(sp)
    800074e8:	00b53423          	sd	a1,8(a0)
    800074ec:	00052023          	sw	zero,0(a0)
    800074f0:	00053823          	sd	zero,16(a0)
    800074f4:	01010113          	addi	sp,sp,16
    800074f8:	00008067          	ret

00000000800074fc <acquire>:
    800074fc:	fe010113          	addi	sp,sp,-32
    80007500:	00813823          	sd	s0,16(sp)
    80007504:	00913423          	sd	s1,8(sp)
    80007508:	00113c23          	sd	ra,24(sp)
    8000750c:	01213023          	sd	s2,0(sp)
    80007510:	02010413          	addi	s0,sp,32
    80007514:	00050493          	mv	s1,a0
    80007518:	10002973          	csrr	s2,sstatus
    8000751c:	100027f3          	csrr	a5,sstatus
    80007520:	ffd7f793          	andi	a5,a5,-3
    80007524:	10079073          	csrw	sstatus,a5
    80007528:	fffff097          	auipc	ra,0xfffff
    8000752c:	8e4080e7          	jalr	-1820(ra) # 80005e0c <mycpu>
    80007530:	07852783          	lw	a5,120(a0)
    80007534:	06078e63          	beqz	a5,800075b0 <acquire+0xb4>
    80007538:	fffff097          	auipc	ra,0xfffff
    8000753c:	8d4080e7          	jalr	-1836(ra) # 80005e0c <mycpu>
    80007540:	07852783          	lw	a5,120(a0)
    80007544:	0004a703          	lw	a4,0(s1)
    80007548:	0017879b          	addiw	a5,a5,1
    8000754c:	06f52c23          	sw	a5,120(a0)
    80007550:	04071063          	bnez	a4,80007590 <acquire+0x94>
    80007554:	00100713          	li	a4,1
    80007558:	00070793          	mv	a5,a4
    8000755c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80007560:	0007879b          	sext.w	a5,a5
    80007564:	fe079ae3          	bnez	a5,80007558 <acquire+0x5c>
    80007568:	0ff0000f          	fence
    8000756c:	fffff097          	auipc	ra,0xfffff
    80007570:	8a0080e7          	jalr	-1888(ra) # 80005e0c <mycpu>
    80007574:	01813083          	ld	ra,24(sp)
    80007578:	01013403          	ld	s0,16(sp)
    8000757c:	00a4b823          	sd	a0,16(s1)
    80007580:	00013903          	ld	s2,0(sp)
    80007584:	00813483          	ld	s1,8(sp)
    80007588:	02010113          	addi	sp,sp,32
    8000758c:	00008067          	ret
    80007590:	0104b903          	ld	s2,16(s1)
    80007594:	fffff097          	auipc	ra,0xfffff
    80007598:	878080e7          	jalr	-1928(ra) # 80005e0c <mycpu>
    8000759c:	faa91ce3          	bne	s2,a0,80007554 <acquire+0x58>
    800075a0:	00001517          	auipc	a0,0x1
    800075a4:	ef050513          	addi	a0,a0,-272 # 80008490 <digits+0x20>
    800075a8:	fffff097          	auipc	ra,0xfffff
    800075ac:	224080e7          	jalr	548(ra) # 800067cc <panic>
    800075b0:	00195913          	srli	s2,s2,0x1
    800075b4:	fffff097          	auipc	ra,0xfffff
    800075b8:	858080e7          	jalr	-1960(ra) # 80005e0c <mycpu>
    800075bc:	00197913          	andi	s2,s2,1
    800075c0:	07252e23          	sw	s2,124(a0)
    800075c4:	f75ff06f          	j	80007538 <acquire+0x3c>

00000000800075c8 <release>:
    800075c8:	fe010113          	addi	sp,sp,-32
    800075cc:	00813823          	sd	s0,16(sp)
    800075d0:	00113c23          	sd	ra,24(sp)
    800075d4:	00913423          	sd	s1,8(sp)
    800075d8:	01213023          	sd	s2,0(sp)
    800075dc:	02010413          	addi	s0,sp,32
    800075e0:	00052783          	lw	a5,0(a0)
    800075e4:	00079a63          	bnez	a5,800075f8 <release+0x30>
    800075e8:	00001517          	auipc	a0,0x1
    800075ec:	eb050513          	addi	a0,a0,-336 # 80008498 <digits+0x28>
    800075f0:	fffff097          	auipc	ra,0xfffff
    800075f4:	1dc080e7          	jalr	476(ra) # 800067cc <panic>
    800075f8:	01053903          	ld	s2,16(a0)
    800075fc:	00050493          	mv	s1,a0
    80007600:	fffff097          	auipc	ra,0xfffff
    80007604:	80c080e7          	jalr	-2036(ra) # 80005e0c <mycpu>
    80007608:	fea910e3          	bne	s2,a0,800075e8 <release+0x20>
    8000760c:	0004b823          	sd	zero,16(s1)
    80007610:	0ff0000f          	fence
    80007614:	0f50000f          	fence	iorw,ow
    80007618:	0804a02f          	amoswap.w	zero,zero,(s1)
    8000761c:	ffffe097          	auipc	ra,0xffffe
    80007620:	7f0080e7          	jalr	2032(ra) # 80005e0c <mycpu>
    80007624:	100027f3          	csrr	a5,sstatus
    80007628:	0027f793          	andi	a5,a5,2
    8000762c:	04079a63          	bnez	a5,80007680 <release+0xb8>
    80007630:	07852783          	lw	a5,120(a0)
    80007634:	02f05e63          	blez	a5,80007670 <release+0xa8>
    80007638:	fff7871b          	addiw	a4,a5,-1
    8000763c:	06e52c23          	sw	a4,120(a0)
    80007640:	00071c63          	bnez	a4,80007658 <release+0x90>
    80007644:	07c52783          	lw	a5,124(a0)
    80007648:	00078863          	beqz	a5,80007658 <release+0x90>
    8000764c:	100027f3          	csrr	a5,sstatus
    80007650:	0027e793          	ori	a5,a5,2
    80007654:	10079073          	csrw	sstatus,a5
    80007658:	01813083          	ld	ra,24(sp)
    8000765c:	01013403          	ld	s0,16(sp)
    80007660:	00813483          	ld	s1,8(sp)
    80007664:	00013903          	ld	s2,0(sp)
    80007668:	02010113          	addi	sp,sp,32
    8000766c:	00008067          	ret
    80007670:	00001517          	auipc	a0,0x1
    80007674:	e4850513          	addi	a0,a0,-440 # 800084b8 <digits+0x48>
    80007678:	fffff097          	auipc	ra,0xfffff
    8000767c:	154080e7          	jalr	340(ra) # 800067cc <panic>
    80007680:	00001517          	auipc	a0,0x1
    80007684:	e2050513          	addi	a0,a0,-480 # 800084a0 <digits+0x30>
    80007688:	fffff097          	auipc	ra,0xfffff
    8000768c:	144080e7          	jalr	324(ra) # 800067cc <panic>

0000000080007690 <holding>:
    80007690:	00052783          	lw	a5,0(a0)
    80007694:	00079663          	bnez	a5,800076a0 <holding+0x10>
    80007698:	00000513          	li	a0,0
    8000769c:	00008067          	ret
    800076a0:	fe010113          	addi	sp,sp,-32
    800076a4:	00813823          	sd	s0,16(sp)
    800076a8:	00913423          	sd	s1,8(sp)
    800076ac:	00113c23          	sd	ra,24(sp)
    800076b0:	02010413          	addi	s0,sp,32
    800076b4:	01053483          	ld	s1,16(a0)
    800076b8:	ffffe097          	auipc	ra,0xffffe
    800076bc:	754080e7          	jalr	1876(ra) # 80005e0c <mycpu>
    800076c0:	01813083          	ld	ra,24(sp)
    800076c4:	01013403          	ld	s0,16(sp)
    800076c8:	40a48533          	sub	a0,s1,a0
    800076cc:	00153513          	seqz	a0,a0
    800076d0:	00813483          	ld	s1,8(sp)
    800076d4:	02010113          	addi	sp,sp,32
    800076d8:	00008067          	ret

00000000800076dc <push_off>:
    800076dc:	fe010113          	addi	sp,sp,-32
    800076e0:	00813823          	sd	s0,16(sp)
    800076e4:	00113c23          	sd	ra,24(sp)
    800076e8:	00913423          	sd	s1,8(sp)
    800076ec:	02010413          	addi	s0,sp,32
    800076f0:	100024f3          	csrr	s1,sstatus
    800076f4:	100027f3          	csrr	a5,sstatus
    800076f8:	ffd7f793          	andi	a5,a5,-3
    800076fc:	10079073          	csrw	sstatus,a5
    80007700:	ffffe097          	auipc	ra,0xffffe
    80007704:	70c080e7          	jalr	1804(ra) # 80005e0c <mycpu>
    80007708:	07852783          	lw	a5,120(a0)
    8000770c:	02078663          	beqz	a5,80007738 <push_off+0x5c>
    80007710:	ffffe097          	auipc	ra,0xffffe
    80007714:	6fc080e7          	jalr	1788(ra) # 80005e0c <mycpu>
    80007718:	07852783          	lw	a5,120(a0)
    8000771c:	01813083          	ld	ra,24(sp)
    80007720:	01013403          	ld	s0,16(sp)
    80007724:	0017879b          	addiw	a5,a5,1
    80007728:	06f52c23          	sw	a5,120(a0)
    8000772c:	00813483          	ld	s1,8(sp)
    80007730:	02010113          	addi	sp,sp,32
    80007734:	00008067          	ret
    80007738:	0014d493          	srli	s1,s1,0x1
    8000773c:	ffffe097          	auipc	ra,0xffffe
    80007740:	6d0080e7          	jalr	1744(ra) # 80005e0c <mycpu>
    80007744:	0014f493          	andi	s1,s1,1
    80007748:	06952e23          	sw	s1,124(a0)
    8000774c:	fc5ff06f          	j	80007710 <push_off+0x34>

0000000080007750 <pop_off>:
    80007750:	ff010113          	addi	sp,sp,-16
    80007754:	00813023          	sd	s0,0(sp)
    80007758:	00113423          	sd	ra,8(sp)
    8000775c:	01010413          	addi	s0,sp,16
    80007760:	ffffe097          	auipc	ra,0xffffe
    80007764:	6ac080e7          	jalr	1708(ra) # 80005e0c <mycpu>
    80007768:	100027f3          	csrr	a5,sstatus
    8000776c:	0027f793          	andi	a5,a5,2
    80007770:	04079663          	bnez	a5,800077bc <pop_off+0x6c>
    80007774:	07852783          	lw	a5,120(a0)
    80007778:	02f05a63          	blez	a5,800077ac <pop_off+0x5c>
    8000777c:	fff7871b          	addiw	a4,a5,-1
    80007780:	06e52c23          	sw	a4,120(a0)
    80007784:	00071c63          	bnez	a4,8000779c <pop_off+0x4c>
    80007788:	07c52783          	lw	a5,124(a0)
    8000778c:	00078863          	beqz	a5,8000779c <pop_off+0x4c>
    80007790:	100027f3          	csrr	a5,sstatus
    80007794:	0027e793          	ori	a5,a5,2
    80007798:	10079073          	csrw	sstatus,a5
    8000779c:	00813083          	ld	ra,8(sp)
    800077a0:	00013403          	ld	s0,0(sp)
    800077a4:	01010113          	addi	sp,sp,16
    800077a8:	00008067          	ret
    800077ac:	00001517          	auipc	a0,0x1
    800077b0:	d0c50513          	addi	a0,a0,-756 # 800084b8 <digits+0x48>
    800077b4:	fffff097          	auipc	ra,0xfffff
    800077b8:	018080e7          	jalr	24(ra) # 800067cc <panic>
    800077bc:	00001517          	auipc	a0,0x1
    800077c0:	ce450513          	addi	a0,a0,-796 # 800084a0 <digits+0x30>
    800077c4:	fffff097          	auipc	ra,0xfffff
    800077c8:	008080e7          	jalr	8(ra) # 800067cc <panic>

00000000800077cc <push_on>:
    800077cc:	fe010113          	addi	sp,sp,-32
    800077d0:	00813823          	sd	s0,16(sp)
    800077d4:	00113c23          	sd	ra,24(sp)
    800077d8:	00913423          	sd	s1,8(sp)
    800077dc:	02010413          	addi	s0,sp,32
    800077e0:	100024f3          	csrr	s1,sstatus
    800077e4:	100027f3          	csrr	a5,sstatus
    800077e8:	0027e793          	ori	a5,a5,2
    800077ec:	10079073          	csrw	sstatus,a5
    800077f0:	ffffe097          	auipc	ra,0xffffe
    800077f4:	61c080e7          	jalr	1564(ra) # 80005e0c <mycpu>
    800077f8:	07852783          	lw	a5,120(a0)
    800077fc:	02078663          	beqz	a5,80007828 <push_on+0x5c>
    80007800:	ffffe097          	auipc	ra,0xffffe
    80007804:	60c080e7          	jalr	1548(ra) # 80005e0c <mycpu>
    80007808:	07852783          	lw	a5,120(a0)
    8000780c:	01813083          	ld	ra,24(sp)
    80007810:	01013403          	ld	s0,16(sp)
    80007814:	0017879b          	addiw	a5,a5,1
    80007818:	06f52c23          	sw	a5,120(a0)
    8000781c:	00813483          	ld	s1,8(sp)
    80007820:	02010113          	addi	sp,sp,32
    80007824:	00008067          	ret
    80007828:	0014d493          	srli	s1,s1,0x1
    8000782c:	ffffe097          	auipc	ra,0xffffe
    80007830:	5e0080e7          	jalr	1504(ra) # 80005e0c <mycpu>
    80007834:	0014f493          	andi	s1,s1,1
    80007838:	06952e23          	sw	s1,124(a0)
    8000783c:	fc5ff06f          	j	80007800 <push_on+0x34>

0000000080007840 <pop_on>:
    80007840:	ff010113          	addi	sp,sp,-16
    80007844:	00813023          	sd	s0,0(sp)
    80007848:	00113423          	sd	ra,8(sp)
    8000784c:	01010413          	addi	s0,sp,16
    80007850:	ffffe097          	auipc	ra,0xffffe
    80007854:	5bc080e7          	jalr	1468(ra) # 80005e0c <mycpu>
    80007858:	100027f3          	csrr	a5,sstatus
    8000785c:	0027f793          	andi	a5,a5,2
    80007860:	04078463          	beqz	a5,800078a8 <pop_on+0x68>
    80007864:	07852783          	lw	a5,120(a0)
    80007868:	02f05863          	blez	a5,80007898 <pop_on+0x58>
    8000786c:	fff7879b          	addiw	a5,a5,-1
    80007870:	06f52c23          	sw	a5,120(a0)
    80007874:	07853783          	ld	a5,120(a0)
    80007878:	00079863          	bnez	a5,80007888 <pop_on+0x48>
    8000787c:	100027f3          	csrr	a5,sstatus
    80007880:	ffd7f793          	andi	a5,a5,-3
    80007884:	10079073          	csrw	sstatus,a5
    80007888:	00813083          	ld	ra,8(sp)
    8000788c:	00013403          	ld	s0,0(sp)
    80007890:	01010113          	addi	sp,sp,16
    80007894:	00008067          	ret
    80007898:	00001517          	auipc	a0,0x1
    8000789c:	c4850513          	addi	a0,a0,-952 # 800084e0 <digits+0x70>
    800078a0:	fffff097          	auipc	ra,0xfffff
    800078a4:	f2c080e7          	jalr	-212(ra) # 800067cc <panic>
    800078a8:	00001517          	auipc	a0,0x1
    800078ac:	c1850513          	addi	a0,a0,-1000 # 800084c0 <digits+0x50>
    800078b0:	fffff097          	auipc	ra,0xfffff
    800078b4:	f1c080e7          	jalr	-228(ra) # 800067cc <panic>

00000000800078b8 <__memset>:
    800078b8:	ff010113          	addi	sp,sp,-16
    800078bc:	00813423          	sd	s0,8(sp)
    800078c0:	01010413          	addi	s0,sp,16
    800078c4:	1a060e63          	beqz	a2,80007a80 <__memset+0x1c8>
    800078c8:	40a007b3          	neg	a5,a0
    800078cc:	0077f793          	andi	a5,a5,7
    800078d0:	00778693          	addi	a3,a5,7
    800078d4:	00b00813          	li	a6,11
    800078d8:	0ff5f593          	andi	a1,a1,255
    800078dc:	fff6071b          	addiw	a4,a2,-1
    800078e0:	1b06e663          	bltu	a3,a6,80007a8c <__memset+0x1d4>
    800078e4:	1cd76463          	bltu	a4,a3,80007aac <__memset+0x1f4>
    800078e8:	1a078e63          	beqz	a5,80007aa4 <__memset+0x1ec>
    800078ec:	00b50023          	sb	a1,0(a0)
    800078f0:	00100713          	li	a4,1
    800078f4:	1ae78463          	beq	a5,a4,80007a9c <__memset+0x1e4>
    800078f8:	00b500a3          	sb	a1,1(a0)
    800078fc:	00200713          	li	a4,2
    80007900:	1ae78a63          	beq	a5,a4,80007ab4 <__memset+0x1fc>
    80007904:	00b50123          	sb	a1,2(a0)
    80007908:	00300713          	li	a4,3
    8000790c:	18e78463          	beq	a5,a4,80007a94 <__memset+0x1dc>
    80007910:	00b501a3          	sb	a1,3(a0)
    80007914:	00400713          	li	a4,4
    80007918:	1ae78263          	beq	a5,a4,80007abc <__memset+0x204>
    8000791c:	00b50223          	sb	a1,4(a0)
    80007920:	00500713          	li	a4,5
    80007924:	1ae78063          	beq	a5,a4,80007ac4 <__memset+0x20c>
    80007928:	00b502a3          	sb	a1,5(a0)
    8000792c:	00700713          	li	a4,7
    80007930:	18e79e63          	bne	a5,a4,80007acc <__memset+0x214>
    80007934:	00b50323          	sb	a1,6(a0)
    80007938:	00700e93          	li	t4,7
    8000793c:	00859713          	slli	a4,a1,0x8
    80007940:	00e5e733          	or	a4,a1,a4
    80007944:	01059e13          	slli	t3,a1,0x10
    80007948:	01c76e33          	or	t3,a4,t3
    8000794c:	01859313          	slli	t1,a1,0x18
    80007950:	006e6333          	or	t1,t3,t1
    80007954:	02059893          	slli	a7,a1,0x20
    80007958:	40f60e3b          	subw	t3,a2,a5
    8000795c:	011368b3          	or	a7,t1,a7
    80007960:	02859813          	slli	a6,a1,0x28
    80007964:	0108e833          	or	a6,a7,a6
    80007968:	03059693          	slli	a3,a1,0x30
    8000796c:	003e589b          	srliw	a7,t3,0x3
    80007970:	00d866b3          	or	a3,a6,a3
    80007974:	03859713          	slli	a4,a1,0x38
    80007978:	00389813          	slli	a6,a7,0x3
    8000797c:	00f507b3          	add	a5,a0,a5
    80007980:	00e6e733          	or	a4,a3,a4
    80007984:	000e089b          	sext.w	a7,t3
    80007988:	00f806b3          	add	a3,a6,a5
    8000798c:	00e7b023          	sd	a4,0(a5)
    80007990:	00878793          	addi	a5,a5,8
    80007994:	fed79ce3          	bne	a5,a3,8000798c <__memset+0xd4>
    80007998:	ff8e7793          	andi	a5,t3,-8
    8000799c:	0007871b          	sext.w	a4,a5
    800079a0:	01d787bb          	addw	a5,a5,t4
    800079a4:	0ce88e63          	beq	a7,a4,80007a80 <__memset+0x1c8>
    800079a8:	00f50733          	add	a4,a0,a5
    800079ac:	00b70023          	sb	a1,0(a4)
    800079b0:	0017871b          	addiw	a4,a5,1
    800079b4:	0cc77663          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    800079b8:	00e50733          	add	a4,a0,a4
    800079bc:	00b70023          	sb	a1,0(a4)
    800079c0:	0027871b          	addiw	a4,a5,2
    800079c4:	0ac77e63          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    800079c8:	00e50733          	add	a4,a0,a4
    800079cc:	00b70023          	sb	a1,0(a4)
    800079d0:	0037871b          	addiw	a4,a5,3
    800079d4:	0ac77663          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    800079d8:	00e50733          	add	a4,a0,a4
    800079dc:	00b70023          	sb	a1,0(a4)
    800079e0:	0047871b          	addiw	a4,a5,4
    800079e4:	08c77e63          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    800079e8:	00e50733          	add	a4,a0,a4
    800079ec:	00b70023          	sb	a1,0(a4)
    800079f0:	0057871b          	addiw	a4,a5,5
    800079f4:	08c77663          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    800079f8:	00e50733          	add	a4,a0,a4
    800079fc:	00b70023          	sb	a1,0(a4)
    80007a00:	0067871b          	addiw	a4,a5,6
    80007a04:	06c77e63          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a08:	00e50733          	add	a4,a0,a4
    80007a0c:	00b70023          	sb	a1,0(a4)
    80007a10:	0077871b          	addiw	a4,a5,7
    80007a14:	06c77663          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a18:	00e50733          	add	a4,a0,a4
    80007a1c:	00b70023          	sb	a1,0(a4)
    80007a20:	0087871b          	addiw	a4,a5,8
    80007a24:	04c77e63          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a28:	00e50733          	add	a4,a0,a4
    80007a2c:	00b70023          	sb	a1,0(a4)
    80007a30:	0097871b          	addiw	a4,a5,9
    80007a34:	04c77663          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a38:	00e50733          	add	a4,a0,a4
    80007a3c:	00b70023          	sb	a1,0(a4)
    80007a40:	00a7871b          	addiw	a4,a5,10
    80007a44:	02c77e63          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a48:	00e50733          	add	a4,a0,a4
    80007a4c:	00b70023          	sb	a1,0(a4)
    80007a50:	00b7871b          	addiw	a4,a5,11
    80007a54:	02c77663          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a58:	00e50733          	add	a4,a0,a4
    80007a5c:	00b70023          	sb	a1,0(a4)
    80007a60:	00c7871b          	addiw	a4,a5,12
    80007a64:	00c77e63          	bgeu	a4,a2,80007a80 <__memset+0x1c8>
    80007a68:	00e50733          	add	a4,a0,a4
    80007a6c:	00b70023          	sb	a1,0(a4)
    80007a70:	00d7879b          	addiw	a5,a5,13
    80007a74:	00c7f663          	bgeu	a5,a2,80007a80 <__memset+0x1c8>
    80007a78:	00f507b3          	add	a5,a0,a5
    80007a7c:	00b78023          	sb	a1,0(a5)
    80007a80:	00813403          	ld	s0,8(sp)
    80007a84:	01010113          	addi	sp,sp,16
    80007a88:	00008067          	ret
    80007a8c:	00b00693          	li	a3,11
    80007a90:	e55ff06f          	j	800078e4 <__memset+0x2c>
    80007a94:	00300e93          	li	t4,3
    80007a98:	ea5ff06f          	j	8000793c <__memset+0x84>
    80007a9c:	00100e93          	li	t4,1
    80007aa0:	e9dff06f          	j	8000793c <__memset+0x84>
    80007aa4:	00000e93          	li	t4,0
    80007aa8:	e95ff06f          	j	8000793c <__memset+0x84>
    80007aac:	00000793          	li	a5,0
    80007ab0:	ef9ff06f          	j	800079a8 <__memset+0xf0>
    80007ab4:	00200e93          	li	t4,2
    80007ab8:	e85ff06f          	j	8000793c <__memset+0x84>
    80007abc:	00400e93          	li	t4,4
    80007ac0:	e7dff06f          	j	8000793c <__memset+0x84>
    80007ac4:	00500e93          	li	t4,5
    80007ac8:	e75ff06f          	j	8000793c <__memset+0x84>
    80007acc:	00600e93          	li	t4,6
    80007ad0:	e6dff06f          	j	8000793c <__memset+0x84>

0000000080007ad4 <__memmove>:
    80007ad4:	ff010113          	addi	sp,sp,-16
    80007ad8:	00813423          	sd	s0,8(sp)
    80007adc:	01010413          	addi	s0,sp,16
    80007ae0:	0e060863          	beqz	a2,80007bd0 <__memmove+0xfc>
    80007ae4:	fff6069b          	addiw	a3,a2,-1
    80007ae8:	0006881b          	sext.w	a6,a3
    80007aec:	0ea5e863          	bltu	a1,a0,80007bdc <__memmove+0x108>
    80007af0:	00758713          	addi	a4,a1,7
    80007af4:	00a5e7b3          	or	a5,a1,a0
    80007af8:	40a70733          	sub	a4,a4,a0
    80007afc:	0077f793          	andi	a5,a5,7
    80007b00:	00f73713          	sltiu	a4,a4,15
    80007b04:	00174713          	xori	a4,a4,1
    80007b08:	0017b793          	seqz	a5,a5
    80007b0c:	00e7f7b3          	and	a5,a5,a4
    80007b10:	10078863          	beqz	a5,80007c20 <__memmove+0x14c>
    80007b14:	00900793          	li	a5,9
    80007b18:	1107f463          	bgeu	a5,a6,80007c20 <__memmove+0x14c>
    80007b1c:	0036581b          	srliw	a6,a2,0x3
    80007b20:	fff8081b          	addiw	a6,a6,-1
    80007b24:	02081813          	slli	a6,a6,0x20
    80007b28:	01d85893          	srli	a7,a6,0x1d
    80007b2c:	00858813          	addi	a6,a1,8
    80007b30:	00058793          	mv	a5,a1
    80007b34:	00050713          	mv	a4,a0
    80007b38:	01088833          	add	a6,a7,a6
    80007b3c:	0007b883          	ld	a7,0(a5)
    80007b40:	00878793          	addi	a5,a5,8
    80007b44:	00870713          	addi	a4,a4,8
    80007b48:	ff173c23          	sd	a7,-8(a4)
    80007b4c:	ff0798e3          	bne	a5,a6,80007b3c <__memmove+0x68>
    80007b50:	ff867713          	andi	a4,a2,-8
    80007b54:	02071793          	slli	a5,a4,0x20
    80007b58:	0207d793          	srli	a5,a5,0x20
    80007b5c:	00f585b3          	add	a1,a1,a5
    80007b60:	40e686bb          	subw	a3,a3,a4
    80007b64:	00f507b3          	add	a5,a0,a5
    80007b68:	06e60463          	beq	a2,a4,80007bd0 <__memmove+0xfc>
    80007b6c:	0005c703          	lbu	a4,0(a1)
    80007b70:	00e78023          	sb	a4,0(a5)
    80007b74:	04068e63          	beqz	a3,80007bd0 <__memmove+0xfc>
    80007b78:	0015c603          	lbu	a2,1(a1)
    80007b7c:	00100713          	li	a4,1
    80007b80:	00c780a3          	sb	a2,1(a5)
    80007b84:	04e68663          	beq	a3,a4,80007bd0 <__memmove+0xfc>
    80007b88:	0025c603          	lbu	a2,2(a1)
    80007b8c:	00200713          	li	a4,2
    80007b90:	00c78123          	sb	a2,2(a5)
    80007b94:	02e68e63          	beq	a3,a4,80007bd0 <__memmove+0xfc>
    80007b98:	0035c603          	lbu	a2,3(a1)
    80007b9c:	00300713          	li	a4,3
    80007ba0:	00c781a3          	sb	a2,3(a5)
    80007ba4:	02e68663          	beq	a3,a4,80007bd0 <__memmove+0xfc>
    80007ba8:	0045c603          	lbu	a2,4(a1)
    80007bac:	00400713          	li	a4,4
    80007bb0:	00c78223          	sb	a2,4(a5)
    80007bb4:	00e68e63          	beq	a3,a4,80007bd0 <__memmove+0xfc>
    80007bb8:	0055c603          	lbu	a2,5(a1)
    80007bbc:	00500713          	li	a4,5
    80007bc0:	00c782a3          	sb	a2,5(a5)
    80007bc4:	00e68663          	beq	a3,a4,80007bd0 <__memmove+0xfc>
    80007bc8:	0065c703          	lbu	a4,6(a1)
    80007bcc:	00e78323          	sb	a4,6(a5)
    80007bd0:	00813403          	ld	s0,8(sp)
    80007bd4:	01010113          	addi	sp,sp,16
    80007bd8:	00008067          	ret
    80007bdc:	02061713          	slli	a4,a2,0x20
    80007be0:	02075713          	srli	a4,a4,0x20
    80007be4:	00e587b3          	add	a5,a1,a4
    80007be8:	f0f574e3          	bgeu	a0,a5,80007af0 <__memmove+0x1c>
    80007bec:	02069613          	slli	a2,a3,0x20
    80007bf0:	02065613          	srli	a2,a2,0x20
    80007bf4:	fff64613          	not	a2,a2
    80007bf8:	00e50733          	add	a4,a0,a4
    80007bfc:	00c78633          	add	a2,a5,a2
    80007c00:	fff7c683          	lbu	a3,-1(a5)
    80007c04:	fff78793          	addi	a5,a5,-1
    80007c08:	fff70713          	addi	a4,a4,-1
    80007c0c:	00d70023          	sb	a3,0(a4)
    80007c10:	fec798e3          	bne	a5,a2,80007c00 <__memmove+0x12c>
    80007c14:	00813403          	ld	s0,8(sp)
    80007c18:	01010113          	addi	sp,sp,16
    80007c1c:	00008067          	ret
    80007c20:	02069713          	slli	a4,a3,0x20
    80007c24:	02075713          	srli	a4,a4,0x20
    80007c28:	00170713          	addi	a4,a4,1
    80007c2c:	00e50733          	add	a4,a0,a4
    80007c30:	00050793          	mv	a5,a0
    80007c34:	0005c683          	lbu	a3,0(a1)
    80007c38:	00178793          	addi	a5,a5,1
    80007c3c:	00158593          	addi	a1,a1,1
    80007c40:	fed78fa3          	sb	a3,-1(a5)
    80007c44:	fee798e3          	bne	a5,a4,80007c34 <__memmove+0x160>
    80007c48:	f89ff06f          	j	80007bd0 <__memmove+0xfc>
	...
