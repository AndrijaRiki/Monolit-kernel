
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00004117          	auipc	sp,0x4
    80000004:	46813103          	ld	sp,1128(sp) # 80004468 <_GLOBAL_OFFSET_TABLE_+0x18>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	604010ef          	jal	ra,80001620 <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <supervisorTrap>:
.align 4
.global supervisorTrap
.type supervisorTrap, @function
supervisorTrap:
    # Alociramo prostor za 32 registra
    addi sp, sp, -256
    80001000:	f0010113          	addi	sp,sp,-256

    # Čuvamo x1 (ra)
    sd x1, 1 * 8(sp)
    80001004:	00113423          	sd	ra,8(sp)

    # Čuvamo sve ostale osim x0 (nula) i x2 (sp)
    .irp index, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    sd x\index, \index * 8(sp)
    .endr
    80001008:	00313c23          	sd	gp,24(sp)
    8000100c:	02413023          	sd	tp,32(sp)
    80001010:	02513423          	sd	t0,40(sp)
    80001014:	02613823          	sd	t1,48(sp)
    80001018:	02713c23          	sd	t2,56(sp)
    8000101c:	04813023          	sd	s0,64(sp)
    80001020:	04913423          	sd	s1,72(sp)
    80001024:	04a13823          	sd	a0,80(sp)
    80001028:	04b13c23          	sd	a1,88(sp)
    8000102c:	06c13023          	sd	a2,96(sp)
    80001030:	06d13423          	sd	a3,104(sp)
    80001034:	06e13823          	sd	a4,112(sp)
    80001038:	06f13c23          	sd	a5,120(sp)
    8000103c:	09013023          	sd	a6,128(sp)
    80001040:	09113423          	sd	a7,136(sp)
    80001044:	09213823          	sd	s2,144(sp)
    80001048:	09313c23          	sd	s3,152(sp)
    8000104c:	0b413023          	sd	s4,160(sp)
    80001050:	0b513423          	sd	s5,168(sp)
    80001054:	0b613823          	sd	s6,176(sp)
    80001058:	0b713c23          	sd	s7,184(sp)
    8000105c:	0d813023          	sd	s8,192(sp)
    80001060:	0d913423          	sd	s9,200(sp)
    80001064:	0da13823          	sd	s10,208(sp)
    80001068:	0db13c23          	sd	s11,216(sp)
    8000106c:	0fc13023          	sd	t3,224(sp)
    80001070:	0fd13423          	sd	t4,232(sp)
    80001074:	0fe13823          	sd	t5,240(sp)
    80001078:	0ff13c23          	sd	t6,248(sp)

    # KLJUČNO OVO FALI: Šaljemo pokazivač na sačuvane registre kao prvi argument u C++
    mv a0, sp
    8000107c:	00010513          	mv	a0,sp

    call supervisorTrapHandler
    80001080:	14c000ef          	jal	ra,800011cc <supervisorTrapHandler>

    # Vraćamo registre nazad
    ld x1, 1 * 8(sp)
    80001084:	00813083          	ld	ra,8(sp)
    .irp index, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    ld x\index, \index * 8(sp)
    .endr
    80001088:	01813183          	ld	gp,24(sp)
    8000108c:	02013203          	ld	tp,32(sp)
    80001090:	02813283          	ld	t0,40(sp)
    80001094:	03013303          	ld	t1,48(sp)
    80001098:	03813383          	ld	t2,56(sp)
    8000109c:	04013403          	ld	s0,64(sp)
    800010a0:	04813483          	ld	s1,72(sp)
    800010a4:	05013503          	ld	a0,80(sp)
    800010a8:	05813583          	ld	a1,88(sp)
    800010ac:	06013603          	ld	a2,96(sp)
    800010b0:	06813683          	ld	a3,104(sp)
    800010b4:	07013703          	ld	a4,112(sp)
    800010b8:	07813783          	ld	a5,120(sp)
    800010bc:	08013803          	ld	a6,128(sp)
    800010c0:	08813883          	ld	a7,136(sp)
    800010c4:	09013903          	ld	s2,144(sp)
    800010c8:	09813983          	ld	s3,152(sp)
    800010cc:	0a013a03          	ld	s4,160(sp)
    800010d0:	0a813a83          	ld	s5,168(sp)
    800010d4:	0b013b03          	ld	s6,176(sp)
    800010d8:	0b813b83          	ld	s7,184(sp)
    800010dc:	0c013c03          	ld	s8,192(sp)
    800010e0:	0c813c83          	ld	s9,200(sp)
    800010e4:	0d013d03          	ld	s10,208(sp)
    800010e8:	0d813d83          	ld	s11,216(sp)
    800010ec:	0e013e03          	ld	t3,224(sp)
    800010f0:	0e813e83          	ld	t4,232(sp)
    800010f4:	0f013f03          	ld	t5,240(sp)
    800010f8:	0f813f83          	ld	t6,248(sp)

    addi sp, sp, 256
    800010fc:	10010113          	addi	sp,sp,256
    80001100:	10200073          	sret
	...

0000000080001110 <main>:
#include "../lib/console.h"
#include "../lib/hw.h"
#include  "../h/printing.hpp"
#include "../h/syscall_c.h"

void main() {
    80001110:	fe010113          	addi	sp,sp,-32
    80001114:	00113c23          	sd	ra,24(sp)
    80001118:	00813823          	sd	s0,16(sp)
    8000111c:	00913423          	sd	s1,8(sp)
    80001120:	02010413          	addi	s0,sp,32
    void* p1 = mem_alloc(10);
    80001124:	00a00513          	li	a0,10
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	054080e7          	jalr	84(ra) # 8000117c <mem_alloc>
    80001130:	00050493          	mv	s1,a0
    printInteger((uint64)p1);
    80001134:	00000097          	auipc	ra,0x0
    80001138:	194080e7          	jalr	404(ra) # 800012c8 <printInteger>
    __putc('1');
    8000113c:	03100513          	li	a0,49
    80001140:	00002097          	auipc	ra,0x2
    80001144:	59c080e7          	jalr	1436(ra) # 800036dc <__putc>
    uint64 status = mem_free(p1);
    80001148:	00048513          	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	058080e7          	jalr	88(ra) # 800011a4 <mem_free>
    printInteger(status);
    80001154:	00000097          	auipc	ra,0x0
    80001158:	174080e7          	jalr	372(ra) # 800012c8 <printInteger>
    __putc('2');
    8000115c:	03200513          	li	a0,50
    80001160:	00002097          	auipc	ra,0x2
    80001164:	57c080e7          	jalr	1404(ra) # 800036dc <__putc>
    80001168:	01813083          	ld	ra,24(sp)
    8000116c:	01013403          	ld	s0,16(sp)
    80001170:	00813483          	ld	s1,8(sp)
    80001174:	02010113          	addi	sp,sp,32
    80001178:	00008067          	ret

000000008000117c <mem_alloc>:
#ifdef __cplusplus
extern "C" {
#endif

void *mem_alloc(size_t size)
{
    8000117c:	ff010113          	addi	sp,sp,-16
    80001180:	00813423          	sd	s0,8(sp)
    80001184:	01010413          	addi	s0,sp,16
    size_t blocks  = (size + MEM_BLOCK_SIZE - 1) / MEM_BLOCK_SIZE;
    80001188:	03f50593          	addi	a1,a0,63 # 103f <_entry-0x7fffefc1>

    //with 1 argument
    template <typename T, typename Arg1>
    static inline T invoke(uint64 id, Arg1 arg1)
    {
        register uint64 r_id asm("a0") = id;
    8000118c:	00100513          	li	a0,1
        register uint64 r_arg1 asm("a1") = (uint64)arg1;
    80001190:	0065d593          	srli	a1,a1,0x6
        asm volatile(
            "ecall"
            : "=r" (ret)
            : "r" (r_id), "r" (r_arg1)
            : "memory"
        );
    80001194:	00000073          	ecall
    return SysCalls::invoke<void*>(MEM_ALLOC, blocks);
}
    80001198:	00813403          	ld	s0,8(sp)
    8000119c:	01010113          	addi	sp,sp,16
    800011a0:	00008067          	ret

00000000800011a4 <mem_free>:

int mem_free(void* ptr)
{
    800011a4:	ff010113          	addi	sp,sp,-16
    800011a8:	00813423          	sd	s0,8(sp)
    800011ac:	01010413          	addi	s0,sp,16
    800011b0:	00050593          	mv	a1,a0
        register uint64 r_id asm("a0") = id;
    800011b4:	00200513          	li	a0,2
        );
    800011b8:	00000073          	ecall
    return SysCalls::invoke<int>(MEM_FREE, ptr);
}
    800011bc:	0005051b          	sext.w	a0,a0
    800011c0:	00813403          	ld	s0,8(sp)
    800011c4:	01010113          	addi	sp,sp,16
    800011c8:	00008067          	ret

00000000800011cc <supervisorTrapHandler>:
#include "../lib/hw.h"
#include "../h/riscv.hpp"
#include "../h/syscall_c.h"

extern "C" void supervisorTrapHandler(uint64* regs)
{
    800011cc:	fc010113          	addi	sp,sp,-64
    800011d0:	02113c23          	sd	ra,56(sp)
    800011d4:	02813823          	sd	s0,48(sp)
    800011d8:	02913423          	sd	s1,40(sp)
    800011dc:	03213023          	sd	s2,32(sp)
    800011e0:	01313c23          	sd	s3,24(sp)
    800011e4:	04010413          	addi	s0,sp,64
};

inline uint64 Riscv::r_scause()
{
    uint64 volatile scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    800011e8:	142027f3          	csrr	a5,scause
    800011ec:	fcf43023          	sd	a5,-64(s0)
    return scause;
    800011f0:	fc043783          	ld	a5,-64(s0)
    uint64 scause = Riscv::r_scause();

    if (scause == 0x08 || scause == 0x09)
    800011f4:	ff878793          	addi	a5,a5,-8
    800011f8:	00100713          	li	a4,1
    800011fc:	02f77063          	bgeu	a4,a5,8000121c <supervisorTrapHandler+0x50>
        regs[10] = ret;

        // Pomeramo se za jednu instrukciju dalje da ne uđemo u beskonačnu ecall petlju
        Riscv::w_sepc(current_sepc + 4);
    }
    80001200:	03813083          	ld	ra,56(sp)
    80001204:	03013403          	ld	s0,48(sp)
    80001208:	02813483          	ld	s1,40(sp)
    8000120c:	02013903          	ld	s2,32(sp)
    80001210:	01813983          	ld	s3,24(sp)
    80001214:	04010113          	addi	sp,sp,64
    80001218:	00008067          	ret
    8000121c:	00050493          	mv	s1,a0
}

inline uint64 Riscv::r_sepc()
{
    uint64 volatile sepc;
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80001220:	141027f3          	csrr	a5,sepc
    80001224:	fcf43423          	sd	a5,-56(s0)
    return sepc;
    80001228:	fc843903          	ld	s2,-56(s0)
        uint64 syscall_id = regs[10];
    8000122c:	05053783          	ld	a5,80(a0)
        uint64 arg1       = regs[11];
    80001230:	05853983          	ld	s3,88(a0)
        switch(syscall_id)
    80001234:	02e78063          	beq	a5,a4,80001254 <supervisorTrapHandler+0x88>
    80001238:	00200713          	li	a4,2
    8000123c:	02e78863          	beq	a5,a4,8000126c <supervisorTrapHandler+0xa0>
    80001240:	00000513          	li	a0,0
        regs[10] = ret;
    80001244:	04a4b823          	sd	a0,80(s1)
        Riscv::w_sepc(current_sepc + 4);
    80001248:	00490913          	addi	s2,s2,4
}

inline void Riscv::w_sepc(uint64 sepc)
{
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    8000124c:	14191073          	csrw	sepc,s2
    80001250:	fb1ff06f          	j	80001200 <supervisorTrapHandler+0x34>
            ret = (uint64)MemoryAllocator::getInstance().alloc(arg1);
    80001254:	00000097          	auipc	ra,0x0
    80001258:	1e0080e7          	jalr	480(ra) # 80001434 <_ZN15MemoryAllocator11getInstanceEv>
    8000125c:	00098593          	mv	a1,s3
    80001260:	00000097          	auipc	ra,0x0
    80001264:	230080e7          	jalr	560(ra) # 80001490 <_ZN15MemoryAllocator5allocEm>
            break;
    80001268:	fddff06f          	j	80001244 <supervisorTrapHandler+0x78>
            ret = (uint64)MemoryAllocator::getInstance().free((void*)arg1);
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	1c8080e7          	jalr	456(ra) # 80001434 <_ZN15MemoryAllocator11getInstanceEv>
    80001274:	00098593          	mv	a1,s3
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	2b8080e7          	jalr	696(ra) # 80001530 <_ZN15MemoryAllocator4freeEPv>
            break;
    80001280:	fc5ff06f          	j	80001244 <supervisorTrapHandler+0x78>

0000000080001284 <_Z11printStringPKc>:
#include "../h/printing.hpp"
#include "../lib/console.h"
#include  "../lib/hw.h"

void printString(const char *str)
{
    80001284:	fe010113          	addi	sp,sp,-32
    80001288:	00113c23          	sd	ra,24(sp)
    8000128c:	00813823          	sd	s0,16(sp)
    80001290:	00913423          	sd	s1,8(sp)
    80001294:	02010413          	addi	s0,sp,32
    80001298:	00050493          	mv	s1,a0
    while (*str != '\0')
    8000129c:	0004c503          	lbu	a0,0(s1)
    800012a0:	00050a63          	beqz	a0,800012b4 <_Z11printStringPKc+0x30>
    {
        __putc(*str);
    800012a4:	00002097          	auipc	ra,0x2
    800012a8:	438080e7          	jalr	1080(ra) # 800036dc <__putc>
        str ++;
    800012ac:	00148493          	addi	s1,s1,1
    while (*str != '\0')
    800012b0:	fedff06f          	j	8000129c <_Z11printStringPKc+0x18>
    }
}
    800012b4:	01813083          	ld	ra,24(sp)
    800012b8:	01013403          	ld	s0,16(sp)
    800012bc:	00813483          	ld	s1,8(sp)
    800012c0:	02010113          	addi	sp,sp,32
    800012c4:	00008067          	ret

00000000800012c8 <printInteger>:

void printInteger(uint64 num)
{
    800012c8:	fd010113          	addi	sp,sp,-48
    800012cc:	02113423          	sd	ra,40(sp)
    800012d0:	02813023          	sd	s0,32(sp)
    800012d4:	00913c23          	sd	s1,24(sp)
    800012d8:	03010413          	addi	s0,sp,48
    static char digits[] = "0123456789abcdef";
    char buf[16];
    int i;
    uint64 x = num;

    i = 0;
    800012dc:	00000493          	li	s1,0
    do
    {
        buf[i++] = digits[x%base];
    800012e0:	00f57693          	andi	a3,a0,15
    800012e4:	00003717          	auipc	a4,0x3
    800012e8:	d3c70713          	addi	a4,a4,-708 # 80004020 <_ZZ12printIntegerE6digits>
    800012ec:	00d70733          	add	a4,a4,a3
    800012f0:	00074703          	lbu	a4,0(a4)
    800012f4:	fe040693          	addi	a3,s0,-32
    800012f8:	009687b3          	add	a5,a3,s1
    800012fc:	0014849b          	addiw	s1,s1,1
    80001300:	fee78823          	sb	a4,-16(a5)
    } while ((x /= base) != 0);
    80001304:	00050713          	mv	a4,a0
    80001308:	00455513          	srli	a0,a0,0x4
    8000130c:	00f00793          	li	a5,15
    80001310:	fce7e8e3          	bltu	a5,a4,800012e0 <printInteger+0x18>

    while (--i >= 0)
    80001314:	fff4849b          	addiw	s1,s1,-1
    80001318:	0004ce63          	bltz	s1,80001334 <printInteger+0x6c>
    {
        __putc(buf[i]);
    8000131c:	fe040793          	addi	a5,s0,-32
    80001320:	009787b3          	add	a5,a5,s1
    80001324:	ff07c503          	lbu	a0,-16(a5)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	3b4080e7          	jalr	948(ra) # 800036dc <__putc>
    80001330:	fe5ff06f          	j	80001314 <printInteger+0x4c>
    }
    80001334:	02813083          	ld	ra,40(sp)
    80001338:	02013403          	ld	s0,32(sp)
    8000133c:	01813483          	ld	s1,24(sp)
    80001340:	03010113          	addi	sp,sp,48
    80001344:	00008067          	ret

0000000080001348 <_Z41__static_initialization_and_destruction_0ii>:
        Riscv::w_stvec((uint64)&supervisorTrap);
    }
};

// Globalna instanca koja okida konstruktor automatski
    80001348:	ff010113          	addi	sp,sp,-16
    8000134c:	00813423          	sd	s0,8(sp)
    80001350:	01010413          	addi	s0,sp,16
    80001354:	00100793          	li	a5,1
    80001358:	00f50863          	beq	a0,a5,80001368 <_Z41__static_initialization_and_destruction_0ii+0x20>
    8000135c:	00813403          	ld	s0,8(sp)
    80001360:	01010113          	addi	sp,sp,16
    80001364:	00008067          	ret
    80001368:	000107b7          	lui	a5,0x10
    8000136c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80001370:	fef596e3          	bne	a1,a5,8000135c <_Z41__static_initialization_and_destruction_0ii+0x14>
        Riscv::w_stvec((uint64)&supervisorTrap);
    80001374:	00003797          	auipc	a5,0x3
    80001378:	0ec7b783          	ld	a5,236(a5) # 80004460 <_GLOBAL_OFFSET_TABLE_+0x10>
    return stvec;
}

inline void Riscv::w_stvec(uint64 stvec)
{
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
    8000137c:	10579073          	csrw	stvec,a5
    80001380:	fddff06f          	j	8000135c <_Z41__static_initialization_and_destruction_0ii+0x14>

0000000080001384 <_ZN5Riscv10popSppSpieEv>:
{
    80001384:	ff010113          	addi	sp,sp,-16
    80001388:	00813423          	sd	s0,8(sp)
    8000138c:	01010413          	addi	s0,sp,16
    __asm__ volatile("csrc sstatus, %0" :: "r"(Riscv::SSTATUS_SPP));
    80001390:	10000793          	li	a5,256
    80001394:	1007b073          	csrc	sstatus,a5
    __asm__ volatile("csrw sepc, ra");
    80001398:	14109073          	csrw	sepc,ra
    __asm__ volatile("sret");
    8000139c:	10200073          	sret
}
    800013a0:	00813403          	ld	s0,8(sp)
    800013a4:	01010113          	addi	sp,sp,16
    800013a8:	00008067          	ret

00000000800013ac <_GLOBAL__sub_I__ZN5Riscv10popSppSpieEv>:
    800013ac:	ff010113          	addi	sp,sp,-16
    800013b0:	00113423          	sd	ra,8(sp)
    800013b4:	00813023          	sd	s0,0(sp)
    800013b8:	01010413          	addi	s0,sp,16
    800013bc:	000105b7          	lui	a1,0x10
    800013c0:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    800013c4:	00100513          	li	a0,1
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	f80080e7          	jalr	-128(ra) # 80001348 <_Z41__static_initialization_and_destruction_0ii>
    800013d0:	00813083          	ld	ra,8(sp)
    800013d4:	00013403          	ld	s0,0(sp)
    800013d8:	01010113          	addi	sp,sp,16
    800013dc:	00008067          	ret

00000000800013e0 <_ZN15MemoryAllocatorC1Ev>:
{
    static MemoryAllocator allocator;
    return allocator;
}

MemoryAllocator::MemoryAllocator()
    800013e0:	ff010113          	addi	sp,sp,-16
    800013e4:	00813423          	sd	s0,8(sp)
    800013e8:	01010413          	addi	s0,sp,16
{
    size_t memStart = align_down((size_t)HEAP_START_ADDR, MEM_BLOCK_SIZE);
    800013ec:	00003797          	auipc	a5,0x3
    800013f0:	06c7b783          	ld	a5,108(a5) # 80004458 <_GLOBAL_OFFSET_TABLE_+0x8>
    800013f4:	0007b703          	ld	a4,0(a5)
                        prev->next = curr->next;
                }
        }
        static constexpr  size_t align_down(size_t size, size_t align)
        {
                return size * align / align;
    800013f8:	fff00793          	li	a5,-1
    800013fc:	0067d793          	srli	a5,a5,0x6
    80001400:	00f77733          	and	a4,a4,a5
    size_t memEnd = align_up((size_t)HEAP_END_ADDR, MEM_BLOCK_SIZE);
    80001404:	00003797          	auipc	a5,0x3
    80001408:	06c7b783          	ld	a5,108(a5) # 80004470 <_GLOBAL_OFFSET_TABLE_+0x20>
    8000140c:	0007b783          	ld	a5,0(a5)
        }

        static constexpr  size_t align_up(size_t size, size_t align)
        {
                return (size + align - 1)/align * align;
    80001410:	03f78793          	addi	a5,a5,63
    80001414:	fc07f793          	andi	a5,a5,-64

    MemDescr* mem = (MemDescr*)memStart;
    mem->size = memEnd - memStart;
    80001418:	40e787b3          	sub	a5,a5,a4
    8000141c:	00f73423          	sd	a5,8(a4)
    mem->next = nullptr;
    80001420:	00073023          	sd	zero,0(a4)

    head = mem;
    80001424:	00e53023          	sd	a4,0(a0)
}
    80001428:	00813403          	ld	s0,8(sp)
    8000142c:	01010113          	addi	sp,sp,16
    80001430:	00008067          	ret

0000000080001434 <_ZN15MemoryAllocator11getInstanceEv>:
    static MemoryAllocator allocator;
    80001434:	00003797          	auipc	a5,0x3
    80001438:	08c7c783          	lbu	a5,140(a5) # 800044c0 <_ZGVZN15MemoryAllocator11getInstanceEvE9allocator>
    8000143c:	00078863          	beqz	a5,8000144c <_ZN15MemoryAllocator11getInstanceEv+0x18>
}
    80001440:	00003517          	auipc	a0,0x3
    80001444:	08850513          	addi	a0,a0,136 # 800044c8 <_ZZN15MemoryAllocator11getInstanceEvE9allocator>
    80001448:	00008067          	ret
{
    8000144c:	ff010113          	addi	sp,sp,-16
    80001450:	00113423          	sd	ra,8(sp)
    80001454:	00813023          	sd	s0,0(sp)
    80001458:	01010413          	addi	s0,sp,16
    static MemoryAllocator allocator;
    8000145c:	00003517          	auipc	a0,0x3
    80001460:	06c50513          	addi	a0,a0,108 # 800044c8 <_ZZN15MemoryAllocator11getInstanceEvE9allocator>
    80001464:	00000097          	auipc	ra,0x0
    80001468:	f7c080e7          	jalr	-132(ra) # 800013e0 <_ZN15MemoryAllocatorC1Ev>
    8000146c:	00100793          	li	a5,1
    80001470:	00003717          	auipc	a4,0x3
    80001474:	04f70823          	sb	a5,80(a4) # 800044c0 <_ZGVZN15MemoryAllocator11getInstanceEvE9allocator>
}
    80001478:	00003517          	auipc	a0,0x3
    8000147c:	05050513          	addi	a0,a0,80 # 800044c8 <_ZZN15MemoryAllocator11getInstanceEvE9allocator>
    80001480:	00813083          	ld	ra,8(sp)
    80001484:	00013403          	ld	s0,0(sp)
    80001488:	01010113          	addi	sp,sp,16
    8000148c:	00008067          	ret

0000000080001490 <_ZN15MemoryAllocator5allocEm>:

void* MemoryAllocator::alloc(size_t size)
{
    80001490:	ff010113          	addi	sp,sp,-16
    80001494:	00813423          	sd	s0,8(sp)
    80001498:	01010413          	addi	s0,sp,16
    8000149c:	00050693          	mv	a3,a0
    // convert to bytes, and add one more block for the descriptor
    size = (size + 1)*MEM_BLOCK_SIZE;
    800014a0:	00158593          	addi	a1,a1,1
    800014a4:	00659593          	slli	a1,a1,0x6


    MemDescr* prev = nullptr;
    MemDescr* curr = head;
    800014a8:	00053503          	ld	a0,0(a0)
    MemDescr* prev = nullptr;
    800014ac:	00000713          	li	a4,0

    while(curr != nullptr)
    800014b0:	04050863          	beqz	a0,80001500 <_ZN15MemoryAllocator5allocEm+0x70>
    {
        if(curr->size >= size)
    800014b4:	00853783          	ld	a5,8(a0)
    800014b8:	00b7f863          	bgeu	a5,a1,800014c8 <_ZN15MemoryAllocator5allocEm+0x38>

            // return the start of the block that's available to the user
            return (void*)((size_t)curr + MEM_BLOCK_SIZE);
        }

        prev = curr;
    800014bc:	00050713          	mv	a4,a0
        curr = curr->next;
    800014c0:	00053503          	ld	a0,0(a0)
    while(curr != nullptr)
    800014c4:	fedff06f          	j	800014b0 <_ZN15MemoryAllocator5allocEm+0x20>
            if(curr->size - size >= MEM_BLOCK_SIZE)
    800014c8:	40b787b3          	sub	a5,a5,a1
    800014cc:	03f00613          	li	a2,63
    800014d0:	04f67263          	bgeu	a2,a5,80001514 <_ZN15MemoryAllocator5allocEm+0x84>
                MemDescr* newDesc = (MemDescr*)((size_t)curr + size);
    800014d4:	00b50633          	add	a2,a0,a1
                newDesc->next = curr->next;
    800014d8:	00053783          	ld	a5,0(a0)
    800014dc:	00f63023          	sd	a5,0(a2)
                newDesc->size = curr->size - size;
    800014e0:	00853783          	ld	a5,8(a0)
    800014e4:	40b787b3          	sub	a5,a5,a1
    800014e8:	00f63423          	sd	a5,8(a2)
                curr->size = size;
    800014ec:	00b53423          	sd	a1,8(a0)
                if(prev == nullptr)
    800014f0:	00070e63          	beqz	a4,8000150c <_ZN15MemoryAllocator5allocEm+0x7c>
                    prev->next = newDesc;
    800014f4:	00c73023          	sd	a2,0(a4)
            curr->next = nullptr;
    800014f8:	00053023          	sd	zero,0(a0)
            return (void*)((size_t)curr + MEM_BLOCK_SIZE);
    800014fc:	04050513          	addi	a0,a0,64
    }

    return nullptr;
}
    80001500:	00813403          	ld	s0,8(sp)
    80001504:	01010113          	addi	sp,sp,16
    80001508:	00008067          	ret
                    head = newDesc;
    8000150c:	00c6b023          	sd	a2,0(a3)
    80001510:	fe9ff06f          	j	800014f8 <_ZN15MemoryAllocator5allocEm+0x68>
                if(prev == nullptr)
    80001514:	00070863          	beqz	a4,80001524 <_ZN15MemoryAllocator5allocEm+0x94>
                    prev->next = curr->next;
    80001518:	00053783          	ld	a5,0(a0)
    8000151c:	00f73023          	sd	a5,0(a4)
    80001520:	fd9ff06f          	j	800014f8 <_ZN15MemoryAllocator5allocEm+0x68>
                    head = curr->next;
    80001524:	00053783          	ld	a5,0(a0)
    80001528:	00f6b023          	sd	a5,0(a3)
    8000152c:	fcdff06f          	j	800014f8 <_ZN15MemoryAllocator5allocEm+0x68>

0000000080001530 <_ZN15MemoryAllocator4freeEPv>:

int MemoryAllocator::free(void* ptr)
{
    80001530:	ff010113          	addi	sp,sp,-16
    80001534:	00813423          	sd	s0,8(sp)
    80001538:	01010413          	addi	s0,sp,16
    ptr = (void*)((size_t)ptr - MEM_BLOCK_SIZE); //-1 block = descriptor
    8000153c:	fc058613          	addi	a2,a1,-64

    if (ptr < HEAP_START_ADDR || ptr >= HEAP_END_ADDR)
    80001540:	00003797          	auipc	a5,0x3
    80001544:	f187b783          	ld	a5,-232(a5) # 80004458 <_GLOBAL_OFFSET_TABLE_+0x8>
    80001548:	0007b783          	ld	a5,0(a5)
    8000154c:	0af66663          	bltu	a2,a5,800015f8 <_ZN15MemoryAllocator4freeEPv+0xc8>
    80001550:	00060713          	mv	a4,a2
    80001554:	00003797          	auipc	a5,0x3
    80001558:	f1c7b783          	ld	a5,-228(a5) # 80004470 <_GLOBAL_OFFSET_TABLE_+0x20>
    8000155c:	0007b783          	ld	a5,0(a5)
    80001560:	0af67063          	bgeu	a2,a5,80001600 <_ZN15MemoryAllocator4freeEPv+0xd0>
        return -1;

    MemDescr* prev = nullptr;
    MemDescr* curr = head;
    80001564:	00053783          	ld	a5,0(a0)
    MemDescr* prev = nullptr;
    80001568:	00000693          	li	a3,0
    8000156c:	00c0006f          	j	80001578 <_ZN15MemoryAllocator4freeEPv+0x48>
        if (curr == ptr)
            return -1;
        if (curr > ptr)
            break;

        prev =curr;
    80001570:	00078693          	mv	a3,a5
        curr = curr->next;
    80001574:	0007b783          	ld	a5,0(a5)
    while (curr != nullptr)
    80001578:	00078663          	beqz	a5,80001584 <_ZN15MemoryAllocator4freeEPv+0x54>
        if (curr == ptr)
    8000157c:	08e78663          	beq	a5,a4,80001608 <_ZN15MemoryAllocator4freeEPv+0xd8>
        if (curr > ptr)
    80001580:	fef778e3          	bgeu	a4,a5,80001570 <_ZN15MemoryAllocator4freeEPv+0x40>
    }

    MemDescr* desc = (MemDescr*)ptr;
    if (prev == nullptr)
    80001584:	02068c63          	beqz	a3,800015bc <_ZN15MemoryAllocator4freeEPv+0x8c>
        head = desc;
    else
        head = prev->next;
    80001588:	0006b703          	ld	a4,0(a3)
    8000158c:	00e53023          	sd	a4,0(a0)

    desc->next = curr;
    80001590:	fcf5b023          	sd	a5,-64(a1)
                if (prev != nullptr && (size_t)prev + prev->size == (size_t)curr)
    80001594:	00060863          	beqz	a2,800015a4 <_ZN15MemoryAllocator4freeEPv+0x74>
    80001598:	00863703          	ld	a4,8(a2)
    8000159c:	00e60533          	add	a0,a2,a4
    800015a0:	02f50263          	beq	a0,a5,800015c4 <_ZN15MemoryAllocator4freeEPv+0x94>
    800015a4:	06068a63          	beqz	a3,80001618 <_ZN15MemoryAllocator4freeEPv+0xe8>
    800015a8:	0086b783          	ld	a5,8(a3)
    800015ac:	00f68733          	add	a4,a3,a5
    800015b0:	02e60663          	beq	a2,a4,800015dc <_ZN15MemoryAllocator4freeEPv+0xac>

    mergeBlocks(desc, curr);
    mergeBlocks(prev, desc);

    return 0;
    800015b4:	00000513          	li	a0,0
    800015b8:	0540006f          	j	8000160c <_ZN15MemoryAllocator4freeEPv+0xdc>
        head = desc;
    800015bc:	00c53023          	sd	a2,0(a0)
    800015c0:	fd1ff06f          	j	80001590 <_ZN15MemoryAllocator4freeEPv+0x60>
                        prev->size += curr->size;
    800015c4:	0087b503          	ld	a0,8(a5)
    800015c8:	00a70733          	add	a4,a4,a0
    800015cc:	00e63423          	sd	a4,8(a2)
                        prev->next = curr->next;
    800015d0:	0007b783          	ld	a5,0(a5)
    800015d4:	fcf5b023          	sd	a5,-64(a1)
    800015d8:	fcdff06f          	j	800015a4 <_ZN15MemoryAllocator4freeEPv+0x74>
                        prev->size += curr->size;
    800015dc:	00863703          	ld	a4,8(a2)
    800015e0:	00e787b3          	add	a5,a5,a4
    800015e4:	00f6b423          	sd	a5,8(a3)
                        prev->next = curr->next;
    800015e8:	fc05b783          	ld	a5,-64(a1)
    800015ec:	00f6b023          	sd	a5,0(a3)
    return 0;
    800015f0:	00000513          	li	a0,0
    800015f4:	0180006f          	j	8000160c <_ZN15MemoryAllocator4freeEPv+0xdc>
        return -1;
    800015f8:	fff00513          	li	a0,-1
    800015fc:	0100006f          	j	8000160c <_ZN15MemoryAllocator4freeEPv+0xdc>
    80001600:	fff00513          	li	a0,-1
    80001604:	0080006f          	j	8000160c <_ZN15MemoryAllocator4freeEPv+0xdc>
            return -1;
    80001608:	fff00513          	li	a0,-1
    8000160c:	00813403          	ld	s0,8(sp)
    80001610:	01010113          	addi	sp,sp,16
    80001614:	00008067          	ret
    return 0;
    80001618:	00000513          	li	a0,0
    8000161c:	ff1ff06f          	j	8000160c <_ZN15MemoryAllocator4freeEPv+0xdc>

0000000080001620 <start>:
    80001620:	ff010113          	addi	sp,sp,-16
    80001624:	00813423          	sd	s0,8(sp)
    80001628:	01010413          	addi	s0,sp,16
    8000162c:	300027f3          	csrr	a5,mstatus
    80001630:	ffffe737          	lui	a4,0xffffe
    80001634:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff90df>
    80001638:	00e7f7b3          	and	a5,a5,a4
    8000163c:	00001737          	lui	a4,0x1
    80001640:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80001644:	00e7e7b3          	or	a5,a5,a4
    80001648:	30079073          	csrw	mstatus,a5
    8000164c:	00000797          	auipc	a5,0x0
    80001650:	16078793          	addi	a5,a5,352 # 800017ac <system_main>
    80001654:	34179073          	csrw	mepc,a5
    80001658:	00000793          	li	a5,0
    8000165c:	18079073          	csrw	satp,a5
    80001660:	000107b7          	lui	a5,0x10
    80001664:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80001668:	30279073          	csrw	medeleg,a5
    8000166c:	30379073          	csrw	mideleg,a5
    80001670:	104027f3          	csrr	a5,sie
    80001674:	2227e793          	ori	a5,a5,546
    80001678:	10479073          	csrw	sie,a5
    8000167c:	fff00793          	li	a5,-1
    80001680:	00a7d793          	srli	a5,a5,0xa
    80001684:	3b079073          	csrw	pmpaddr0,a5
    80001688:	00f00793          	li	a5,15
    8000168c:	3a079073          	csrw	pmpcfg0,a5
    80001690:	f14027f3          	csrr	a5,mhartid
    80001694:	0200c737          	lui	a4,0x200c
    80001698:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000169c:	0007869b          	sext.w	a3,a5
    800016a0:	00269713          	slli	a4,a3,0x2
    800016a4:	000f4637          	lui	a2,0xf4
    800016a8:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800016ac:	00d70733          	add	a4,a4,a3
    800016b0:	0037979b          	slliw	a5,a5,0x3
    800016b4:	020046b7          	lui	a3,0x2004
    800016b8:	00d787b3          	add	a5,a5,a3
    800016bc:	00c585b3          	add	a1,a1,a2
    800016c0:	00371693          	slli	a3,a4,0x3
    800016c4:	00003717          	auipc	a4,0x3
    800016c8:	e0c70713          	addi	a4,a4,-500 # 800044d0 <timer_scratch>
    800016cc:	00b7b023          	sd	a1,0(a5)
    800016d0:	00d70733          	add	a4,a4,a3
    800016d4:	00f73c23          	sd	a5,24(a4)
    800016d8:	02c73023          	sd	a2,32(a4)
    800016dc:	34071073          	csrw	mscratch,a4
    800016e0:	00000797          	auipc	a5,0x0
    800016e4:	6e078793          	addi	a5,a5,1760 # 80001dc0 <timervec>
    800016e8:	30579073          	csrw	mtvec,a5
    800016ec:	300027f3          	csrr	a5,mstatus
    800016f0:	0087e793          	ori	a5,a5,8
    800016f4:	30079073          	csrw	mstatus,a5
    800016f8:	304027f3          	csrr	a5,mie
    800016fc:	0807e793          	ori	a5,a5,128
    80001700:	30479073          	csrw	mie,a5
    80001704:	f14027f3          	csrr	a5,mhartid
    80001708:	0007879b          	sext.w	a5,a5
    8000170c:	00078213          	mv	tp,a5
    80001710:	30200073          	mret
    80001714:	00813403          	ld	s0,8(sp)
    80001718:	01010113          	addi	sp,sp,16
    8000171c:	00008067          	ret

0000000080001720 <timerinit>:
    80001720:	ff010113          	addi	sp,sp,-16
    80001724:	00813423          	sd	s0,8(sp)
    80001728:	01010413          	addi	s0,sp,16
    8000172c:	f14027f3          	csrr	a5,mhartid
    80001730:	0200c737          	lui	a4,0x200c
    80001734:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80001738:	0007869b          	sext.w	a3,a5
    8000173c:	00269713          	slli	a4,a3,0x2
    80001740:	000f4637          	lui	a2,0xf4
    80001744:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80001748:	00d70733          	add	a4,a4,a3
    8000174c:	0037979b          	slliw	a5,a5,0x3
    80001750:	020046b7          	lui	a3,0x2004
    80001754:	00d787b3          	add	a5,a5,a3
    80001758:	00c585b3          	add	a1,a1,a2
    8000175c:	00371693          	slli	a3,a4,0x3
    80001760:	00003717          	auipc	a4,0x3
    80001764:	d7070713          	addi	a4,a4,-656 # 800044d0 <timer_scratch>
    80001768:	00b7b023          	sd	a1,0(a5)
    8000176c:	00d70733          	add	a4,a4,a3
    80001770:	00f73c23          	sd	a5,24(a4)
    80001774:	02c73023          	sd	a2,32(a4)
    80001778:	34071073          	csrw	mscratch,a4
    8000177c:	00000797          	auipc	a5,0x0
    80001780:	64478793          	addi	a5,a5,1604 # 80001dc0 <timervec>
    80001784:	30579073          	csrw	mtvec,a5
    80001788:	300027f3          	csrr	a5,mstatus
    8000178c:	0087e793          	ori	a5,a5,8
    80001790:	30079073          	csrw	mstatus,a5
    80001794:	304027f3          	csrr	a5,mie
    80001798:	0807e793          	ori	a5,a5,128
    8000179c:	30479073          	csrw	mie,a5
    800017a0:	00813403          	ld	s0,8(sp)
    800017a4:	01010113          	addi	sp,sp,16
    800017a8:	00008067          	ret

00000000800017ac <system_main>:
    800017ac:	fe010113          	addi	sp,sp,-32
    800017b0:	00813823          	sd	s0,16(sp)
    800017b4:	00913423          	sd	s1,8(sp)
    800017b8:	00113c23          	sd	ra,24(sp)
    800017bc:	02010413          	addi	s0,sp,32
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	0c4080e7          	jalr	196(ra) # 80001884 <cpuid>
    800017c8:	00003497          	auipc	s1,0x3
    800017cc:	cc848493          	addi	s1,s1,-824 # 80004490 <started>
    800017d0:	02050263          	beqz	a0,800017f4 <system_main+0x48>
    800017d4:	0004a783          	lw	a5,0(s1)
    800017d8:	0007879b          	sext.w	a5,a5
    800017dc:	fe078ce3          	beqz	a5,800017d4 <system_main+0x28>
    800017e0:	0ff0000f          	fence
    800017e4:	00003517          	auipc	a0,0x3
    800017e8:	88450513          	addi	a0,a0,-1916 # 80004068 <_ZZ12printIntegerE6digits+0x48>
    800017ec:	00001097          	auipc	ra,0x1
    800017f0:	a70080e7          	jalr	-1424(ra) # 8000225c <panic>
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	9c4080e7          	jalr	-1596(ra) # 800021b8 <consoleinit>
    800017fc:	00001097          	auipc	ra,0x1
    80001800:	150080e7          	jalr	336(ra) # 8000294c <printfinit>
    80001804:	00003517          	auipc	a0,0x3
    80001808:	94450513          	addi	a0,a0,-1724 # 80004148 <_ZZ12printIntegerE6digits+0x128>
    8000180c:	00001097          	auipc	ra,0x1
    80001810:	aac080e7          	jalr	-1364(ra) # 800022b8 <__printf>
    80001814:	00003517          	auipc	a0,0x3
    80001818:	82450513          	addi	a0,a0,-2012 # 80004038 <_ZZ12printIntegerE6digits+0x18>
    8000181c:	00001097          	auipc	ra,0x1
    80001820:	a9c080e7          	jalr	-1380(ra) # 800022b8 <__printf>
    80001824:	00003517          	auipc	a0,0x3
    80001828:	92450513          	addi	a0,a0,-1756 # 80004148 <_ZZ12printIntegerE6digits+0x128>
    8000182c:	00001097          	auipc	ra,0x1
    80001830:	a8c080e7          	jalr	-1396(ra) # 800022b8 <__printf>
    80001834:	00001097          	auipc	ra,0x1
    80001838:	4a4080e7          	jalr	1188(ra) # 80002cd8 <kinit>
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	148080e7          	jalr	328(ra) # 80001984 <trapinit>
    80001844:	00000097          	auipc	ra,0x0
    80001848:	16c080e7          	jalr	364(ra) # 800019b0 <trapinithart>
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	5b4080e7          	jalr	1460(ra) # 80001e00 <plicinit>
    80001854:	00000097          	auipc	ra,0x0
    80001858:	5d4080e7          	jalr	1492(ra) # 80001e28 <plicinithart>
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	078080e7          	jalr	120(ra) # 800018d4 <userinit>
    80001864:	0ff0000f          	fence
    80001868:	00100793          	li	a5,1
    8000186c:	00002517          	auipc	a0,0x2
    80001870:	7e450513          	addi	a0,a0,2020 # 80004050 <_ZZ12printIntegerE6digits+0x30>
    80001874:	00f4a023          	sw	a5,0(s1)
    80001878:	00001097          	auipc	ra,0x1
    8000187c:	a40080e7          	jalr	-1472(ra) # 800022b8 <__printf>
    80001880:	0000006f          	j	80001880 <system_main+0xd4>

0000000080001884 <cpuid>:
    80001884:	ff010113          	addi	sp,sp,-16
    80001888:	00813423          	sd	s0,8(sp)
    8000188c:	01010413          	addi	s0,sp,16
    80001890:	00020513          	mv	a0,tp
    80001894:	00813403          	ld	s0,8(sp)
    80001898:	0005051b          	sext.w	a0,a0
    8000189c:	01010113          	addi	sp,sp,16
    800018a0:	00008067          	ret

00000000800018a4 <mycpu>:
    800018a4:	ff010113          	addi	sp,sp,-16
    800018a8:	00813423          	sd	s0,8(sp)
    800018ac:	01010413          	addi	s0,sp,16
    800018b0:	00020793          	mv	a5,tp
    800018b4:	00813403          	ld	s0,8(sp)
    800018b8:	0007879b          	sext.w	a5,a5
    800018bc:	00779793          	slli	a5,a5,0x7
    800018c0:	00004517          	auipc	a0,0x4
    800018c4:	c4050513          	addi	a0,a0,-960 # 80005500 <cpus>
    800018c8:	00f50533          	add	a0,a0,a5
    800018cc:	01010113          	addi	sp,sp,16
    800018d0:	00008067          	ret

00000000800018d4 <userinit>:
    800018d4:	ff010113          	addi	sp,sp,-16
    800018d8:	00813423          	sd	s0,8(sp)
    800018dc:	01010413          	addi	s0,sp,16
    800018e0:	00813403          	ld	s0,8(sp)
    800018e4:	01010113          	addi	sp,sp,16
    800018e8:	00000317          	auipc	t1,0x0
    800018ec:	82830067          	jr	-2008(t1) # 80001110 <main>

00000000800018f0 <either_copyout>:
    800018f0:	ff010113          	addi	sp,sp,-16
    800018f4:	00813023          	sd	s0,0(sp)
    800018f8:	00113423          	sd	ra,8(sp)
    800018fc:	01010413          	addi	s0,sp,16
    80001900:	02051663          	bnez	a0,8000192c <either_copyout+0x3c>
    80001904:	00058513          	mv	a0,a1
    80001908:	00060593          	mv	a1,a2
    8000190c:	0006861b          	sext.w	a2,a3
    80001910:	00002097          	auipc	ra,0x2
    80001914:	c54080e7          	jalr	-940(ra) # 80003564 <__memmove>
    80001918:	00813083          	ld	ra,8(sp)
    8000191c:	00013403          	ld	s0,0(sp)
    80001920:	00000513          	li	a0,0
    80001924:	01010113          	addi	sp,sp,16
    80001928:	00008067          	ret
    8000192c:	00002517          	auipc	a0,0x2
    80001930:	76450513          	addi	a0,a0,1892 # 80004090 <_ZZ12printIntegerE6digits+0x70>
    80001934:	00001097          	auipc	ra,0x1
    80001938:	928080e7          	jalr	-1752(ra) # 8000225c <panic>

000000008000193c <either_copyin>:
    8000193c:	ff010113          	addi	sp,sp,-16
    80001940:	00813023          	sd	s0,0(sp)
    80001944:	00113423          	sd	ra,8(sp)
    80001948:	01010413          	addi	s0,sp,16
    8000194c:	02059463          	bnez	a1,80001974 <either_copyin+0x38>
    80001950:	00060593          	mv	a1,a2
    80001954:	0006861b          	sext.w	a2,a3
    80001958:	00002097          	auipc	ra,0x2
    8000195c:	c0c080e7          	jalr	-1012(ra) # 80003564 <__memmove>
    80001960:	00813083          	ld	ra,8(sp)
    80001964:	00013403          	ld	s0,0(sp)
    80001968:	00000513          	li	a0,0
    8000196c:	01010113          	addi	sp,sp,16
    80001970:	00008067          	ret
    80001974:	00002517          	auipc	a0,0x2
    80001978:	74450513          	addi	a0,a0,1860 # 800040b8 <_ZZ12printIntegerE6digits+0x98>
    8000197c:	00001097          	auipc	ra,0x1
    80001980:	8e0080e7          	jalr	-1824(ra) # 8000225c <panic>

0000000080001984 <trapinit>:
    80001984:	ff010113          	addi	sp,sp,-16
    80001988:	00813423          	sd	s0,8(sp)
    8000198c:	01010413          	addi	s0,sp,16
    80001990:	00813403          	ld	s0,8(sp)
    80001994:	00002597          	auipc	a1,0x2
    80001998:	74c58593          	addi	a1,a1,1868 # 800040e0 <_ZZ12printIntegerE6digits+0xc0>
    8000199c:	00004517          	auipc	a0,0x4
    800019a0:	be450513          	addi	a0,a0,-1052 # 80005580 <tickslock>
    800019a4:	01010113          	addi	sp,sp,16
    800019a8:	00001317          	auipc	t1,0x1
    800019ac:	5c030067          	jr	1472(t1) # 80002f68 <initlock>

00000000800019b0 <trapinithart>:
    800019b0:	ff010113          	addi	sp,sp,-16
    800019b4:	00813423          	sd	s0,8(sp)
    800019b8:	01010413          	addi	s0,sp,16
    800019bc:	00000797          	auipc	a5,0x0
    800019c0:	2f478793          	addi	a5,a5,756 # 80001cb0 <kernelvec>
    800019c4:	10579073          	csrw	stvec,a5
    800019c8:	00813403          	ld	s0,8(sp)
    800019cc:	01010113          	addi	sp,sp,16
    800019d0:	00008067          	ret

00000000800019d4 <usertrap>:
    800019d4:	ff010113          	addi	sp,sp,-16
    800019d8:	00813423          	sd	s0,8(sp)
    800019dc:	01010413          	addi	s0,sp,16
    800019e0:	00813403          	ld	s0,8(sp)
    800019e4:	01010113          	addi	sp,sp,16
    800019e8:	00008067          	ret

00000000800019ec <usertrapret>:
    800019ec:	ff010113          	addi	sp,sp,-16
    800019f0:	00813423          	sd	s0,8(sp)
    800019f4:	01010413          	addi	s0,sp,16
    800019f8:	00813403          	ld	s0,8(sp)
    800019fc:	01010113          	addi	sp,sp,16
    80001a00:	00008067          	ret

0000000080001a04 <kerneltrap>:
    80001a04:	fe010113          	addi	sp,sp,-32
    80001a08:	00813823          	sd	s0,16(sp)
    80001a0c:	00113c23          	sd	ra,24(sp)
    80001a10:	00913423          	sd	s1,8(sp)
    80001a14:	02010413          	addi	s0,sp,32
    80001a18:	142025f3          	csrr	a1,scause
    80001a1c:	100027f3          	csrr	a5,sstatus
    80001a20:	0027f793          	andi	a5,a5,2
    80001a24:	10079c63          	bnez	a5,80001b3c <kerneltrap+0x138>
    80001a28:	142027f3          	csrr	a5,scause
    80001a2c:	0207ce63          	bltz	a5,80001a68 <kerneltrap+0x64>
    80001a30:	00002517          	auipc	a0,0x2
    80001a34:	6f850513          	addi	a0,a0,1784 # 80004128 <_ZZ12printIntegerE6digits+0x108>
    80001a38:	00001097          	auipc	ra,0x1
    80001a3c:	880080e7          	jalr	-1920(ra) # 800022b8 <__printf>
    80001a40:	141025f3          	csrr	a1,sepc
    80001a44:	14302673          	csrr	a2,stval
    80001a48:	00002517          	auipc	a0,0x2
    80001a4c:	6f050513          	addi	a0,a0,1776 # 80004138 <_ZZ12printIntegerE6digits+0x118>
    80001a50:	00001097          	auipc	ra,0x1
    80001a54:	868080e7          	jalr	-1944(ra) # 800022b8 <__printf>
    80001a58:	00002517          	auipc	a0,0x2
    80001a5c:	6f850513          	addi	a0,a0,1784 # 80004150 <_ZZ12printIntegerE6digits+0x130>
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	7fc080e7          	jalr	2044(ra) # 8000225c <panic>
    80001a68:	0ff7f713          	andi	a4,a5,255
    80001a6c:	00900693          	li	a3,9
    80001a70:	04d70063          	beq	a4,a3,80001ab0 <kerneltrap+0xac>
    80001a74:	fff00713          	li	a4,-1
    80001a78:	03f71713          	slli	a4,a4,0x3f
    80001a7c:	00170713          	addi	a4,a4,1
    80001a80:	fae798e3          	bne	a5,a4,80001a30 <kerneltrap+0x2c>
    80001a84:	00000097          	auipc	ra,0x0
    80001a88:	e00080e7          	jalr	-512(ra) # 80001884 <cpuid>
    80001a8c:	06050663          	beqz	a0,80001af8 <kerneltrap+0xf4>
    80001a90:	144027f3          	csrr	a5,sip
    80001a94:	ffd7f793          	andi	a5,a5,-3
    80001a98:	14479073          	csrw	sip,a5
    80001a9c:	01813083          	ld	ra,24(sp)
    80001aa0:	01013403          	ld	s0,16(sp)
    80001aa4:	00813483          	ld	s1,8(sp)
    80001aa8:	02010113          	addi	sp,sp,32
    80001aac:	00008067          	ret
    80001ab0:	00000097          	auipc	ra,0x0
    80001ab4:	3c4080e7          	jalr	964(ra) # 80001e74 <plic_claim>
    80001ab8:	00a00793          	li	a5,10
    80001abc:	00050493          	mv	s1,a0
    80001ac0:	06f50863          	beq	a0,a5,80001b30 <kerneltrap+0x12c>
    80001ac4:	fc050ce3          	beqz	a0,80001a9c <kerneltrap+0x98>
    80001ac8:	00050593          	mv	a1,a0
    80001acc:	00002517          	auipc	a0,0x2
    80001ad0:	63c50513          	addi	a0,a0,1596 # 80004108 <_ZZ12printIntegerE6digits+0xe8>
    80001ad4:	00000097          	auipc	ra,0x0
    80001ad8:	7e4080e7          	jalr	2020(ra) # 800022b8 <__printf>
    80001adc:	01013403          	ld	s0,16(sp)
    80001ae0:	01813083          	ld	ra,24(sp)
    80001ae4:	00048513          	mv	a0,s1
    80001ae8:	00813483          	ld	s1,8(sp)
    80001aec:	02010113          	addi	sp,sp,32
    80001af0:	00000317          	auipc	t1,0x0
    80001af4:	3bc30067          	jr	956(t1) # 80001eac <plic_complete>
    80001af8:	00004517          	auipc	a0,0x4
    80001afc:	a8850513          	addi	a0,a0,-1400 # 80005580 <tickslock>
    80001b00:	00001097          	auipc	ra,0x1
    80001b04:	48c080e7          	jalr	1164(ra) # 80002f8c <acquire>
    80001b08:	00003717          	auipc	a4,0x3
    80001b0c:	98c70713          	addi	a4,a4,-1652 # 80004494 <ticks>
    80001b10:	00072783          	lw	a5,0(a4)
    80001b14:	00004517          	auipc	a0,0x4
    80001b18:	a6c50513          	addi	a0,a0,-1428 # 80005580 <tickslock>
    80001b1c:	0017879b          	addiw	a5,a5,1
    80001b20:	00f72023          	sw	a5,0(a4)
    80001b24:	00001097          	auipc	ra,0x1
    80001b28:	534080e7          	jalr	1332(ra) # 80003058 <release>
    80001b2c:	f65ff06f          	j	80001a90 <kerneltrap+0x8c>
    80001b30:	00001097          	auipc	ra,0x1
    80001b34:	090080e7          	jalr	144(ra) # 80002bc0 <uartintr>
    80001b38:	fa5ff06f          	j	80001adc <kerneltrap+0xd8>
    80001b3c:	00002517          	auipc	a0,0x2
    80001b40:	5ac50513          	addi	a0,a0,1452 # 800040e8 <_ZZ12printIntegerE6digits+0xc8>
    80001b44:	00000097          	auipc	ra,0x0
    80001b48:	718080e7          	jalr	1816(ra) # 8000225c <panic>

0000000080001b4c <clockintr>:
    80001b4c:	fe010113          	addi	sp,sp,-32
    80001b50:	00813823          	sd	s0,16(sp)
    80001b54:	00913423          	sd	s1,8(sp)
    80001b58:	00113c23          	sd	ra,24(sp)
    80001b5c:	02010413          	addi	s0,sp,32
    80001b60:	00004497          	auipc	s1,0x4
    80001b64:	a2048493          	addi	s1,s1,-1504 # 80005580 <tickslock>
    80001b68:	00048513          	mv	a0,s1
    80001b6c:	00001097          	auipc	ra,0x1
    80001b70:	420080e7          	jalr	1056(ra) # 80002f8c <acquire>
    80001b74:	00003717          	auipc	a4,0x3
    80001b78:	92070713          	addi	a4,a4,-1760 # 80004494 <ticks>
    80001b7c:	00072783          	lw	a5,0(a4)
    80001b80:	01013403          	ld	s0,16(sp)
    80001b84:	01813083          	ld	ra,24(sp)
    80001b88:	00048513          	mv	a0,s1
    80001b8c:	0017879b          	addiw	a5,a5,1
    80001b90:	00813483          	ld	s1,8(sp)
    80001b94:	00f72023          	sw	a5,0(a4)
    80001b98:	02010113          	addi	sp,sp,32
    80001b9c:	00001317          	auipc	t1,0x1
    80001ba0:	4bc30067          	jr	1212(t1) # 80003058 <release>

0000000080001ba4 <devintr>:
    80001ba4:	142027f3          	csrr	a5,scause
    80001ba8:	00000513          	li	a0,0
    80001bac:	0007c463          	bltz	a5,80001bb4 <devintr+0x10>
    80001bb0:	00008067          	ret
    80001bb4:	fe010113          	addi	sp,sp,-32
    80001bb8:	00813823          	sd	s0,16(sp)
    80001bbc:	00113c23          	sd	ra,24(sp)
    80001bc0:	00913423          	sd	s1,8(sp)
    80001bc4:	02010413          	addi	s0,sp,32
    80001bc8:	0ff7f713          	andi	a4,a5,255
    80001bcc:	00900693          	li	a3,9
    80001bd0:	04d70c63          	beq	a4,a3,80001c28 <devintr+0x84>
    80001bd4:	fff00713          	li	a4,-1
    80001bd8:	03f71713          	slli	a4,a4,0x3f
    80001bdc:	00170713          	addi	a4,a4,1
    80001be0:	00e78c63          	beq	a5,a4,80001bf8 <devintr+0x54>
    80001be4:	01813083          	ld	ra,24(sp)
    80001be8:	01013403          	ld	s0,16(sp)
    80001bec:	00813483          	ld	s1,8(sp)
    80001bf0:	02010113          	addi	sp,sp,32
    80001bf4:	00008067          	ret
    80001bf8:	00000097          	auipc	ra,0x0
    80001bfc:	c8c080e7          	jalr	-884(ra) # 80001884 <cpuid>
    80001c00:	06050663          	beqz	a0,80001c6c <devintr+0xc8>
    80001c04:	144027f3          	csrr	a5,sip
    80001c08:	ffd7f793          	andi	a5,a5,-3
    80001c0c:	14479073          	csrw	sip,a5
    80001c10:	01813083          	ld	ra,24(sp)
    80001c14:	01013403          	ld	s0,16(sp)
    80001c18:	00813483          	ld	s1,8(sp)
    80001c1c:	00200513          	li	a0,2
    80001c20:	02010113          	addi	sp,sp,32
    80001c24:	00008067          	ret
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	24c080e7          	jalr	588(ra) # 80001e74 <plic_claim>
    80001c30:	00a00793          	li	a5,10
    80001c34:	00050493          	mv	s1,a0
    80001c38:	06f50663          	beq	a0,a5,80001ca4 <devintr+0x100>
    80001c3c:	00100513          	li	a0,1
    80001c40:	fa0482e3          	beqz	s1,80001be4 <devintr+0x40>
    80001c44:	00048593          	mv	a1,s1
    80001c48:	00002517          	auipc	a0,0x2
    80001c4c:	4c050513          	addi	a0,a0,1216 # 80004108 <_ZZ12printIntegerE6digits+0xe8>
    80001c50:	00000097          	auipc	ra,0x0
    80001c54:	668080e7          	jalr	1640(ra) # 800022b8 <__printf>
    80001c58:	00048513          	mv	a0,s1
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	250080e7          	jalr	592(ra) # 80001eac <plic_complete>
    80001c64:	00100513          	li	a0,1
    80001c68:	f7dff06f          	j	80001be4 <devintr+0x40>
    80001c6c:	00004517          	auipc	a0,0x4
    80001c70:	91450513          	addi	a0,a0,-1772 # 80005580 <tickslock>
    80001c74:	00001097          	auipc	ra,0x1
    80001c78:	318080e7          	jalr	792(ra) # 80002f8c <acquire>
    80001c7c:	00003717          	auipc	a4,0x3
    80001c80:	81870713          	addi	a4,a4,-2024 # 80004494 <ticks>
    80001c84:	00072783          	lw	a5,0(a4)
    80001c88:	00004517          	auipc	a0,0x4
    80001c8c:	8f850513          	addi	a0,a0,-1800 # 80005580 <tickslock>
    80001c90:	0017879b          	addiw	a5,a5,1
    80001c94:	00f72023          	sw	a5,0(a4)
    80001c98:	00001097          	auipc	ra,0x1
    80001c9c:	3c0080e7          	jalr	960(ra) # 80003058 <release>
    80001ca0:	f65ff06f          	j	80001c04 <devintr+0x60>
    80001ca4:	00001097          	auipc	ra,0x1
    80001ca8:	f1c080e7          	jalr	-228(ra) # 80002bc0 <uartintr>
    80001cac:	fadff06f          	j	80001c58 <devintr+0xb4>

0000000080001cb0 <kernelvec>:
    80001cb0:	f0010113          	addi	sp,sp,-256
    80001cb4:	00113023          	sd	ra,0(sp)
    80001cb8:	00213423          	sd	sp,8(sp)
    80001cbc:	00313823          	sd	gp,16(sp)
    80001cc0:	00413c23          	sd	tp,24(sp)
    80001cc4:	02513023          	sd	t0,32(sp)
    80001cc8:	02613423          	sd	t1,40(sp)
    80001ccc:	02713823          	sd	t2,48(sp)
    80001cd0:	02813c23          	sd	s0,56(sp)
    80001cd4:	04913023          	sd	s1,64(sp)
    80001cd8:	04a13423          	sd	a0,72(sp)
    80001cdc:	04b13823          	sd	a1,80(sp)
    80001ce0:	04c13c23          	sd	a2,88(sp)
    80001ce4:	06d13023          	sd	a3,96(sp)
    80001ce8:	06e13423          	sd	a4,104(sp)
    80001cec:	06f13823          	sd	a5,112(sp)
    80001cf0:	07013c23          	sd	a6,120(sp)
    80001cf4:	09113023          	sd	a7,128(sp)
    80001cf8:	09213423          	sd	s2,136(sp)
    80001cfc:	09313823          	sd	s3,144(sp)
    80001d00:	09413c23          	sd	s4,152(sp)
    80001d04:	0b513023          	sd	s5,160(sp)
    80001d08:	0b613423          	sd	s6,168(sp)
    80001d0c:	0b713823          	sd	s7,176(sp)
    80001d10:	0b813c23          	sd	s8,184(sp)
    80001d14:	0d913023          	sd	s9,192(sp)
    80001d18:	0da13423          	sd	s10,200(sp)
    80001d1c:	0db13823          	sd	s11,208(sp)
    80001d20:	0dc13c23          	sd	t3,216(sp)
    80001d24:	0fd13023          	sd	t4,224(sp)
    80001d28:	0fe13423          	sd	t5,232(sp)
    80001d2c:	0ff13823          	sd	t6,240(sp)
    80001d30:	cd5ff0ef          	jal	ra,80001a04 <kerneltrap>
    80001d34:	00013083          	ld	ra,0(sp)
    80001d38:	00813103          	ld	sp,8(sp)
    80001d3c:	01013183          	ld	gp,16(sp)
    80001d40:	02013283          	ld	t0,32(sp)
    80001d44:	02813303          	ld	t1,40(sp)
    80001d48:	03013383          	ld	t2,48(sp)
    80001d4c:	03813403          	ld	s0,56(sp)
    80001d50:	04013483          	ld	s1,64(sp)
    80001d54:	04813503          	ld	a0,72(sp)
    80001d58:	05013583          	ld	a1,80(sp)
    80001d5c:	05813603          	ld	a2,88(sp)
    80001d60:	06013683          	ld	a3,96(sp)
    80001d64:	06813703          	ld	a4,104(sp)
    80001d68:	07013783          	ld	a5,112(sp)
    80001d6c:	07813803          	ld	a6,120(sp)
    80001d70:	08013883          	ld	a7,128(sp)
    80001d74:	08813903          	ld	s2,136(sp)
    80001d78:	09013983          	ld	s3,144(sp)
    80001d7c:	09813a03          	ld	s4,152(sp)
    80001d80:	0a013a83          	ld	s5,160(sp)
    80001d84:	0a813b03          	ld	s6,168(sp)
    80001d88:	0b013b83          	ld	s7,176(sp)
    80001d8c:	0b813c03          	ld	s8,184(sp)
    80001d90:	0c013c83          	ld	s9,192(sp)
    80001d94:	0c813d03          	ld	s10,200(sp)
    80001d98:	0d013d83          	ld	s11,208(sp)
    80001d9c:	0d813e03          	ld	t3,216(sp)
    80001da0:	0e013e83          	ld	t4,224(sp)
    80001da4:	0e813f03          	ld	t5,232(sp)
    80001da8:	0f013f83          	ld	t6,240(sp)
    80001dac:	10010113          	addi	sp,sp,256
    80001db0:	10200073          	sret
    80001db4:	00000013          	nop
    80001db8:	00000013          	nop
    80001dbc:	00000013          	nop

0000000080001dc0 <timervec>:
    80001dc0:	34051573          	csrrw	a0,mscratch,a0
    80001dc4:	00b53023          	sd	a1,0(a0)
    80001dc8:	00c53423          	sd	a2,8(a0)
    80001dcc:	00d53823          	sd	a3,16(a0)
    80001dd0:	01853583          	ld	a1,24(a0)
    80001dd4:	02053603          	ld	a2,32(a0)
    80001dd8:	0005b683          	ld	a3,0(a1)
    80001ddc:	00c686b3          	add	a3,a3,a2
    80001de0:	00d5b023          	sd	a3,0(a1)
    80001de4:	00200593          	li	a1,2
    80001de8:	14459073          	csrw	sip,a1
    80001dec:	01053683          	ld	a3,16(a0)
    80001df0:	00853603          	ld	a2,8(a0)
    80001df4:	00053583          	ld	a1,0(a0)
    80001df8:	34051573          	csrrw	a0,mscratch,a0
    80001dfc:	30200073          	mret

0000000080001e00 <plicinit>:
    80001e00:	ff010113          	addi	sp,sp,-16
    80001e04:	00813423          	sd	s0,8(sp)
    80001e08:	01010413          	addi	s0,sp,16
    80001e0c:	00813403          	ld	s0,8(sp)
    80001e10:	0c0007b7          	lui	a5,0xc000
    80001e14:	00100713          	li	a4,1
    80001e18:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    80001e1c:	00e7a223          	sw	a4,4(a5)
    80001e20:	01010113          	addi	sp,sp,16
    80001e24:	00008067          	ret

0000000080001e28 <plicinithart>:
    80001e28:	ff010113          	addi	sp,sp,-16
    80001e2c:	00813023          	sd	s0,0(sp)
    80001e30:	00113423          	sd	ra,8(sp)
    80001e34:	01010413          	addi	s0,sp,16
    80001e38:	00000097          	auipc	ra,0x0
    80001e3c:	a4c080e7          	jalr	-1460(ra) # 80001884 <cpuid>
    80001e40:	0085171b          	slliw	a4,a0,0x8
    80001e44:	0c0027b7          	lui	a5,0xc002
    80001e48:	00e787b3          	add	a5,a5,a4
    80001e4c:	40200713          	li	a4,1026
    80001e50:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80001e54:	00813083          	ld	ra,8(sp)
    80001e58:	00013403          	ld	s0,0(sp)
    80001e5c:	00d5151b          	slliw	a0,a0,0xd
    80001e60:	0c2017b7          	lui	a5,0xc201
    80001e64:	00a78533          	add	a0,a5,a0
    80001e68:	00052023          	sw	zero,0(a0)
    80001e6c:	01010113          	addi	sp,sp,16
    80001e70:	00008067          	ret

0000000080001e74 <plic_claim>:
    80001e74:	ff010113          	addi	sp,sp,-16
    80001e78:	00813023          	sd	s0,0(sp)
    80001e7c:	00113423          	sd	ra,8(sp)
    80001e80:	01010413          	addi	s0,sp,16
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	a00080e7          	jalr	-1536(ra) # 80001884 <cpuid>
    80001e8c:	00813083          	ld	ra,8(sp)
    80001e90:	00013403          	ld	s0,0(sp)
    80001e94:	00d5151b          	slliw	a0,a0,0xd
    80001e98:	0c2017b7          	lui	a5,0xc201
    80001e9c:	00a78533          	add	a0,a5,a0
    80001ea0:	00452503          	lw	a0,4(a0)
    80001ea4:	01010113          	addi	sp,sp,16
    80001ea8:	00008067          	ret

0000000080001eac <plic_complete>:
    80001eac:	fe010113          	addi	sp,sp,-32
    80001eb0:	00813823          	sd	s0,16(sp)
    80001eb4:	00913423          	sd	s1,8(sp)
    80001eb8:	00113c23          	sd	ra,24(sp)
    80001ebc:	02010413          	addi	s0,sp,32
    80001ec0:	00050493          	mv	s1,a0
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	9c0080e7          	jalr	-1600(ra) # 80001884 <cpuid>
    80001ecc:	01813083          	ld	ra,24(sp)
    80001ed0:	01013403          	ld	s0,16(sp)
    80001ed4:	00d5179b          	slliw	a5,a0,0xd
    80001ed8:	0c201737          	lui	a4,0xc201
    80001edc:	00f707b3          	add	a5,a4,a5
    80001ee0:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    80001ee4:	00813483          	ld	s1,8(sp)
    80001ee8:	02010113          	addi	sp,sp,32
    80001eec:	00008067          	ret

0000000080001ef0 <consolewrite>:
    80001ef0:	fb010113          	addi	sp,sp,-80
    80001ef4:	04813023          	sd	s0,64(sp)
    80001ef8:	04113423          	sd	ra,72(sp)
    80001efc:	02913c23          	sd	s1,56(sp)
    80001f00:	03213823          	sd	s2,48(sp)
    80001f04:	03313423          	sd	s3,40(sp)
    80001f08:	03413023          	sd	s4,32(sp)
    80001f0c:	01513c23          	sd	s5,24(sp)
    80001f10:	05010413          	addi	s0,sp,80
    80001f14:	06c05c63          	blez	a2,80001f8c <consolewrite+0x9c>
    80001f18:	00060993          	mv	s3,a2
    80001f1c:	00050a13          	mv	s4,a0
    80001f20:	00058493          	mv	s1,a1
    80001f24:	00000913          	li	s2,0
    80001f28:	fff00a93          	li	s5,-1
    80001f2c:	01c0006f          	j	80001f48 <consolewrite+0x58>
    80001f30:	fbf44503          	lbu	a0,-65(s0)
    80001f34:	0019091b          	addiw	s2,s2,1
    80001f38:	00148493          	addi	s1,s1,1
    80001f3c:	00001097          	auipc	ra,0x1
    80001f40:	a9c080e7          	jalr	-1380(ra) # 800029d8 <uartputc>
    80001f44:	03298063          	beq	s3,s2,80001f64 <consolewrite+0x74>
    80001f48:	00048613          	mv	a2,s1
    80001f4c:	00100693          	li	a3,1
    80001f50:	000a0593          	mv	a1,s4
    80001f54:	fbf40513          	addi	a0,s0,-65
    80001f58:	00000097          	auipc	ra,0x0
    80001f5c:	9e4080e7          	jalr	-1564(ra) # 8000193c <either_copyin>
    80001f60:	fd5518e3          	bne	a0,s5,80001f30 <consolewrite+0x40>
    80001f64:	04813083          	ld	ra,72(sp)
    80001f68:	04013403          	ld	s0,64(sp)
    80001f6c:	03813483          	ld	s1,56(sp)
    80001f70:	02813983          	ld	s3,40(sp)
    80001f74:	02013a03          	ld	s4,32(sp)
    80001f78:	01813a83          	ld	s5,24(sp)
    80001f7c:	00090513          	mv	a0,s2
    80001f80:	03013903          	ld	s2,48(sp)
    80001f84:	05010113          	addi	sp,sp,80
    80001f88:	00008067          	ret
    80001f8c:	00000913          	li	s2,0
    80001f90:	fd5ff06f          	j	80001f64 <consolewrite+0x74>

0000000080001f94 <consoleread>:
    80001f94:	f9010113          	addi	sp,sp,-112
    80001f98:	06813023          	sd	s0,96(sp)
    80001f9c:	04913c23          	sd	s1,88(sp)
    80001fa0:	05213823          	sd	s2,80(sp)
    80001fa4:	05313423          	sd	s3,72(sp)
    80001fa8:	05413023          	sd	s4,64(sp)
    80001fac:	03513c23          	sd	s5,56(sp)
    80001fb0:	03613823          	sd	s6,48(sp)
    80001fb4:	03713423          	sd	s7,40(sp)
    80001fb8:	03813023          	sd	s8,32(sp)
    80001fbc:	06113423          	sd	ra,104(sp)
    80001fc0:	01913c23          	sd	s9,24(sp)
    80001fc4:	07010413          	addi	s0,sp,112
    80001fc8:	00060b93          	mv	s7,a2
    80001fcc:	00050913          	mv	s2,a0
    80001fd0:	00058c13          	mv	s8,a1
    80001fd4:	00060b1b          	sext.w	s6,a2
    80001fd8:	00003497          	auipc	s1,0x3
    80001fdc:	5c048493          	addi	s1,s1,1472 # 80005598 <cons>
    80001fe0:	00400993          	li	s3,4
    80001fe4:	fff00a13          	li	s4,-1
    80001fe8:	00a00a93          	li	s5,10
    80001fec:	05705e63          	blez	s7,80002048 <consoleread+0xb4>
    80001ff0:	09c4a703          	lw	a4,156(s1)
    80001ff4:	0984a783          	lw	a5,152(s1)
    80001ff8:	0007071b          	sext.w	a4,a4
    80001ffc:	08e78463          	beq	a5,a4,80002084 <consoleread+0xf0>
    80002000:	07f7f713          	andi	a4,a5,127
    80002004:	00e48733          	add	a4,s1,a4
    80002008:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    8000200c:	0017869b          	addiw	a3,a5,1
    80002010:	08d4ac23          	sw	a3,152(s1)
    80002014:	00070c9b          	sext.w	s9,a4
    80002018:	0b370663          	beq	a4,s3,800020c4 <consoleread+0x130>
    8000201c:	00100693          	li	a3,1
    80002020:	f9f40613          	addi	a2,s0,-97
    80002024:	000c0593          	mv	a1,s8
    80002028:	00090513          	mv	a0,s2
    8000202c:	f8e40fa3          	sb	a4,-97(s0)
    80002030:	00000097          	auipc	ra,0x0
    80002034:	8c0080e7          	jalr	-1856(ra) # 800018f0 <either_copyout>
    80002038:	01450863          	beq	a0,s4,80002048 <consoleread+0xb4>
    8000203c:	001c0c13          	addi	s8,s8,1
    80002040:	fffb8b9b          	addiw	s7,s7,-1
    80002044:	fb5c94e3          	bne	s9,s5,80001fec <consoleread+0x58>
    80002048:	000b851b          	sext.w	a0,s7
    8000204c:	06813083          	ld	ra,104(sp)
    80002050:	06013403          	ld	s0,96(sp)
    80002054:	05813483          	ld	s1,88(sp)
    80002058:	05013903          	ld	s2,80(sp)
    8000205c:	04813983          	ld	s3,72(sp)
    80002060:	04013a03          	ld	s4,64(sp)
    80002064:	03813a83          	ld	s5,56(sp)
    80002068:	02813b83          	ld	s7,40(sp)
    8000206c:	02013c03          	ld	s8,32(sp)
    80002070:	01813c83          	ld	s9,24(sp)
    80002074:	40ab053b          	subw	a0,s6,a0
    80002078:	03013b03          	ld	s6,48(sp)
    8000207c:	07010113          	addi	sp,sp,112
    80002080:	00008067          	ret
    80002084:	00001097          	auipc	ra,0x1
    80002088:	1d8080e7          	jalr	472(ra) # 8000325c <push_on>
    8000208c:	0984a703          	lw	a4,152(s1)
    80002090:	09c4a783          	lw	a5,156(s1)
    80002094:	0007879b          	sext.w	a5,a5
    80002098:	fef70ce3          	beq	a4,a5,80002090 <consoleread+0xfc>
    8000209c:	00001097          	auipc	ra,0x1
    800020a0:	234080e7          	jalr	564(ra) # 800032d0 <pop_on>
    800020a4:	0984a783          	lw	a5,152(s1)
    800020a8:	07f7f713          	andi	a4,a5,127
    800020ac:	00e48733          	add	a4,s1,a4
    800020b0:	01874703          	lbu	a4,24(a4)
    800020b4:	0017869b          	addiw	a3,a5,1
    800020b8:	08d4ac23          	sw	a3,152(s1)
    800020bc:	00070c9b          	sext.w	s9,a4
    800020c0:	f5371ee3          	bne	a4,s3,8000201c <consoleread+0x88>
    800020c4:	000b851b          	sext.w	a0,s7
    800020c8:	f96bf2e3          	bgeu	s7,s6,8000204c <consoleread+0xb8>
    800020cc:	08f4ac23          	sw	a5,152(s1)
    800020d0:	f7dff06f          	j	8000204c <consoleread+0xb8>

00000000800020d4 <consputc>:
    800020d4:	10000793          	li	a5,256
    800020d8:	00f50663          	beq	a0,a5,800020e4 <consputc+0x10>
    800020dc:	00001317          	auipc	t1,0x1
    800020e0:	9f430067          	jr	-1548(t1) # 80002ad0 <uartputc_sync>
    800020e4:	ff010113          	addi	sp,sp,-16
    800020e8:	00113423          	sd	ra,8(sp)
    800020ec:	00813023          	sd	s0,0(sp)
    800020f0:	01010413          	addi	s0,sp,16
    800020f4:	00800513          	li	a0,8
    800020f8:	00001097          	auipc	ra,0x1
    800020fc:	9d8080e7          	jalr	-1576(ra) # 80002ad0 <uartputc_sync>
    80002100:	02000513          	li	a0,32
    80002104:	00001097          	auipc	ra,0x1
    80002108:	9cc080e7          	jalr	-1588(ra) # 80002ad0 <uartputc_sync>
    8000210c:	00013403          	ld	s0,0(sp)
    80002110:	00813083          	ld	ra,8(sp)
    80002114:	00800513          	li	a0,8
    80002118:	01010113          	addi	sp,sp,16
    8000211c:	00001317          	auipc	t1,0x1
    80002120:	9b430067          	jr	-1612(t1) # 80002ad0 <uartputc_sync>

0000000080002124 <consoleintr>:
    80002124:	fe010113          	addi	sp,sp,-32
    80002128:	00813823          	sd	s0,16(sp)
    8000212c:	00913423          	sd	s1,8(sp)
    80002130:	01213023          	sd	s2,0(sp)
    80002134:	00113c23          	sd	ra,24(sp)
    80002138:	02010413          	addi	s0,sp,32
    8000213c:	00003917          	auipc	s2,0x3
    80002140:	45c90913          	addi	s2,s2,1116 # 80005598 <cons>
    80002144:	00050493          	mv	s1,a0
    80002148:	00090513          	mv	a0,s2
    8000214c:	00001097          	auipc	ra,0x1
    80002150:	e40080e7          	jalr	-448(ra) # 80002f8c <acquire>
    80002154:	02048c63          	beqz	s1,8000218c <consoleintr+0x68>
    80002158:	0a092783          	lw	a5,160(s2)
    8000215c:	09892703          	lw	a4,152(s2)
    80002160:	07f00693          	li	a3,127
    80002164:	40e7873b          	subw	a4,a5,a4
    80002168:	02e6e263          	bltu	a3,a4,8000218c <consoleintr+0x68>
    8000216c:	00d00713          	li	a4,13
    80002170:	04e48063          	beq	s1,a4,800021b0 <consoleintr+0x8c>
    80002174:	07f7f713          	andi	a4,a5,127
    80002178:	00e90733          	add	a4,s2,a4
    8000217c:	0017879b          	addiw	a5,a5,1
    80002180:	0af92023          	sw	a5,160(s2)
    80002184:	00970c23          	sb	s1,24(a4)
    80002188:	08f92e23          	sw	a5,156(s2)
    8000218c:	01013403          	ld	s0,16(sp)
    80002190:	01813083          	ld	ra,24(sp)
    80002194:	00813483          	ld	s1,8(sp)
    80002198:	00013903          	ld	s2,0(sp)
    8000219c:	00003517          	auipc	a0,0x3
    800021a0:	3fc50513          	addi	a0,a0,1020 # 80005598 <cons>
    800021a4:	02010113          	addi	sp,sp,32
    800021a8:	00001317          	auipc	t1,0x1
    800021ac:	eb030067          	jr	-336(t1) # 80003058 <release>
    800021b0:	00a00493          	li	s1,10
    800021b4:	fc1ff06f          	j	80002174 <consoleintr+0x50>

00000000800021b8 <consoleinit>:
    800021b8:	fe010113          	addi	sp,sp,-32
    800021bc:	00113c23          	sd	ra,24(sp)
    800021c0:	00813823          	sd	s0,16(sp)
    800021c4:	00913423          	sd	s1,8(sp)
    800021c8:	02010413          	addi	s0,sp,32
    800021cc:	00003497          	auipc	s1,0x3
    800021d0:	3cc48493          	addi	s1,s1,972 # 80005598 <cons>
    800021d4:	00048513          	mv	a0,s1
    800021d8:	00002597          	auipc	a1,0x2
    800021dc:	f8858593          	addi	a1,a1,-120 # 80004160 <_ZZ12printIntegerE6digits+0x140>
    800021e0:	00001097          	auipc	ra,0x1
    800021e4:	d88080e7          	jalr	-632(ra) # 80002f68 <initlock>
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	7ac080e7          	jalr	1964(ra) # 80002994 <uartinit>
    800021f0:	01813083          	ld	ra,24(sp)
    800021f4:	01013403          	ld	s0,16(sp)
    800021f8:	00000797          	auipc	a5,0x0
    800021fc:	d9c78793          	addi	a5,a5,-612 # 80001f94 <consoleread>
    80002200:	0af4bc23          	sd	a5,184(s1)
    80002204:	00000797          	auipc	a5,0x0
    80002208:	cec78793          	addi	a5,a5,-788 # 80001ef0 <consolewrite>
    8000220c:	0cf4b023          	sd	a5,192(s1)
    80002210:	00813483          	ld	s1,8(sp)
    80002214:	02010113          	addi	sp,sp,32
    80002218:	00008067          	ret

000000008000221c <console_read>:
    8000221c:	ff010113          	addi	sp,sp,-16
    80002220:	00813423          	sd	s0,8(sp)
    80002224:	01010413          	addi	s0,sp,16
    80002228:	00813403          	ld	s0,8(sp)
    8000222c:	00003317          	auipc	t1,0x3
    80002230:	42433303          	ld	t1,1060(t1) # 80005650 <devsw+0x10>
    80002234:	01010113          	addi	sp,sp,16
    80002238:	00030067          	jr	t1

000000008000223c <console_write>:
    8000223c:	ff010113          	addi	sp,sp,-16
    80002240:	00813423          	sd	s0,8(sp)
    80002244:	01010413          	addi	s0,sp,16
    80002248:	00813403          	ld	s0,8(sp)
    8000224c:	00003317          	auipc	t1,0x3
    80002250:	40c33303          	ld	t1,1036(t1) # 80005658 <devsw+0x18>
    80002254:	01010113          	addi	sp,sp,16
    80002258:	00030067          	jr	t1

000000008000225c <panic>:
    8000225c:	fe010113          	addi	sp,sp,-32
    80002260:	00113c23          	sd	ra,24(sp)
    80002264:	00813823          	sd	s0,16(sp)
    80002268:	00913423          	sd	s1,8(sp)
    8000226c:	02010413          	addi	s0,sp,32
    80002270:	00050493          	mv	s1,a0
    80002274:	00002517          	auipc	a0,0x2
    80002278:	ef450513          	addi	a0,a0,-268 # 80004168 <_ZZ12printIntegerE6digits+0x148>
    8000227c:	00003797          	auipc	a5,0x3
    80002280:	4607ae23          	sw	zero,1148(a5) # 800056f8 <pr+0x18>
    80002284:	00000097          	auipc	ra,0x0
    80002288:	034080e7          	jalr	52(ra) # 800022b8 <__printf>
    8000228c:	00048513          	mv	a0,s1
    80002290:	00000097          	auipc	ra,0x0
    80002294:	028080e7          	jalr	40(ra) # 800022b8 <__printf>
    80002298:	00002517          	auipc	a0,0x2
    8000229c:	eb050513          	addi	a0,a0,-336 # 80004148 <_ZZ12printIntegerE6digits+0x128>
    800022a0:	00000097          	auipc	ra,0x0
    800022a4:	018080e7          	jalr	24(ra) # 800022b8 <__printf>
    800022a8:	00100793          	li	a5,1
    800022ac:	00002717          	auipc	a4,0x2
    800022b0:	1ef72623          	sw	a5,492(a4) # 80004498 <panicked>
    800022b4:	0000006f          	j	800022b4 <panic+0x58>

00000000800022b8 <__printf>:
    800022b8:	f3010113          	addi	sp,sp,-208
    800022bc:	08813023          	sd	s0,128(sp)
    800022c0:	07313423          	sd	s3,104(sp)
    800022c4:	09010413          	addi	s0,sp,144
    800022c8:	05813023          	sd	s8,64(sp)
    800022cc:	08113423          	sd	ra,136(sp)
    800022d0:	06913c23          	sd	s1,120(sp)
    800022d4:	07213823          	sd	s2,112(sp)
    800022d8:	07413023          	sd	s4,96(sp)
    800022dc:	05513c23          	sd	s5,88(sp)
    800022e0:	05613823          	sd	s6,80(sp)
    800022e4:	05713423          	sd	s7,72(sp)
    800022e8:	03913c23          	sd	s9,56(sp)
    800022ec:	03a13823          	sd	s10,48(sp)
    800022f0:	03b13423          	sd	s11,40(sp)
    800022f4:	00003317          	auipc	t1,0x3
    800022f8:	3ec30313          	addi	t1,t1,1004 # 800056e0 <pr>
    800022fc:	01832c03          	lw	s8,24(t1)
    80002300:	00b43423          	sd	a1,8(s0)
    80002304:	00c43823          	sd	a2,16(s0)
    80002308:	00d43c23          	sd	a3,24(s0)
    8000230c:	02e43023          	sd	a4,32(s0)
    80002310:	02f43423          	sd	a5,40(s0)
    80002314:	03043823          	sd	a6,48(s0)
    80002318:	03143c23          	sd	a7,56(s0)
    8000231c:	00050993          	mv	s3,a0
    80002320:	4a0c1663          	bnez	s8,800027cc <__printf+0x514>
    80002324:	60098c63          	beqz	s3,8000293c <__printf+0x684>
    80002328:	0009c503          	lbu	a0,0(s3)
    8000232c:	00840793          	addi	a5,s0,8
    80002330:	f6f43c23          	sd	a5,-136(s0)
    80002334:	00000493          	li	s1,0
    80002338:	22050063          	beqz	a0,80002558 <__printf+0x2a0>
    8000233c:	00002a37          	lui	s4,0x2
    80002340:	00018ab7          	lui	s5,0x18
    80002344:	000f4b37          	lui	s6,0xf4
    80002348:	00989bb7          	lui	s7,0x989
    8000234c:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    80002350:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    80002354:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    80002358:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    8000235c:	00148c9b          	addiw	s9,s1,1
    80002360:	02500793          	li	a5,37
    80002364:	01998933          	add	s2,s3,s9
    80002368:	38f51263          	bne	a0,a5,800026ec <__printf+0x434>
    8000236c:	00094783          	lbu	a5,0(s2)
    80002370:	00078c9b          	sext.w	s9,a5
    80002374:	1e078263          	beqz	a5,80002558 <__printf+0x2a0>
    80002378:	0024849b          	addiw	s1,s1,2
    8000237c:	07000713          	li	a4,112
    80002380:	00998933          	add	s2,s3,s1
    80002384:	38e78a63          	beq	a5,a4,80002718 <__printf+0x460>
    80002388:	20f76863          	bltu	a4,a5,80002598 <__printf+0x2e0>
    8000238c:	42a78863          	beq	a5,a0,800027bc <__printf+0x504>
    80002390:	06400713          	li	a4,100
    80002394:	40e79663          	bne	a5,a4,800027a0 <__printf+0x4e8>
    80002398:	f7843783          	ld	a5,-136(s0)
    8000239c:	0007a603          	lw	a2,0(a5)
    800023a0:	00878793          	addi	a5,a5,8
    800023a4:	f6f43c23          	sd	a5,-136(s0)
    800023a8:	42064a63          	bltz	a2,800027dc <__printf+0x524>
    800023ac:	00a00713          	li	a4,10
    800023b0:	02e677bb          	remuw	a5,a2,a4
    800023b4:	00002d97          	auipc	s11,0x2
    800023b8:	ddcd8d93          	addi	s11,s11,-548 # 80004190 <digits>
    800023bc:	00900593          	li	a1,9
    800023c0:	0006051b          	sext.w	a0,a2
    800023c4:	00000c93          	li	s9,0
    800023c8:	02079793          	slli	a5,a5,0x20
    800023cc:	0207d793          	srli	a5,a5,0x20
    800023d0:	00fd87b3          	add	a5,s11,a5
    800023d4:	0007c783          	lbu	a5,0(a5)
    800023d8:	02e656bb          	divuw	a3,a2,a4
    800023dc:	f8f40023          	sb	a5,-128(s0)
    800023e0:	14c5d863          	bge	a1,a2,80002530 <__printf+0x278>
    800023e4:	06300593          	li	a1,99
    800023e8:	00100c93          	li	s9,1
    800023ec:	02e6f7bb          	remuw	a5,a3,a4
    800023f0:	02079793          	slli	a5,a5,0x20
    800023f4:	0207d793          	srli	a5,a5,0x20
    800023f8:	00fd87b3          	add	a5,s11,a5
    800023fc:	0007c783          	lbu	a5,0(a5)
    80002400:	02e6d73b          	divuw	a4,a3,a4
    80002404:	f8f400a3          	sb	a5,-127(s0)
    80002408:	12a5f463          	bgeu	a1,a0,80002530 <__printf+0x278>
    8000240c:	00a00693          	li	a3,10
    80002410:	00900593          	li	a1,9
    80002414:	02d777bb          	remuw	a5,a4,a3
    80002418:	02079793          	slli	a5,a5,0x20
    8000241c:	0207d793          	srli	a5,a5,0x20
    80002420:	00fd87b3          	add	a5,s11,a5
    80002424:	0007c503          	lbu	a0,0(a5)
    80002428:	02d757bb          	divuw	a5,a4,a3
    8000242c:	f8a40123          	sb	a0,-126(s0)
    80002430:	48e5f263          	bgeu	a1,a4,800028b4 <__printf+0x5fc>
    80002434:	06300513          	li	a0,99
    80002438:	02d7f5bb          	remuw	a1,a5,a3
    8000243c:	02059593          	slli	a1,a1,0x20
    80002440:	0205d593          	srli	a1,a1,0x20
    80002444:	00bd85b3          	add	a1,s11,a1
    80002448:	0005c583          	lbu	a1,0(a1)
    8000244c:	02d7d7bb          	divuw	a5,a5,a3
    80002450:	f8b401a3          	sb	a1,-125(s0)
    80002454:	48e57263          	bgeu	a0,a4,800028d8 <__printf+0x620>
    80002458:	3e700513          	li	a0,999
    8000245c:	02d7f5bb          	remuw	a1,a5,a3
    80002460:	02059593          	slli	a1,a1,0x20
    80002464:	0205d593          	srli	a1,a1,0x20
    80002468:	00bd85b3          	add	a1,s11,a1
    8000246c:	0005c583          	lbu	a1,0(a1)
    80002470:	02d7d7bb          	divuw	a5,a5,a3
    80002474:	f8b40223          	sb	a1,-124(s0)
    80002478:	46e57663          	bgeu	a0,a4,800028e4 <__printf+0x62c>
    8000247c:	02d7f5bb          	remuw	a1,a5,a3
    80002480:	02059593          	slli	a1,a1,0x20
    80002484:	0205d593          	srli	a1,a1,0x20
    80002488:	00bd85b3          	add	a1,s11,a1
    8000248c:	0005c583          	lbu	a1,0(a1)
    80002490:	02d7d7bb          	divuw	a5,a5,a3
    80002494:	f8b402a3          	sb	a1,-123(s0)
    80002498:	46ea7863          	bgeu	s4,a4,80002908 <__printf+0x650>
    8000249c:	02d7f5bb          	remuw	a1,a5,a3
    800024a0:	02059593          	slli	a1,a1,0x20
    800024a4:	0205d593          	srli	a1,a1,0x20
    800024a8:	00bd85b3          	add	a1,s11,a1
    800024ac:	0005c583          	lbu	a1,0(a1)
    800024b0:	02d7d7bb          	divuw	a5,a5,a3
    800024b4:	f8b40323          	sb	a1,-122(s0)
    800024b8:	3eeaf863          	bgeu	s5,a4,800028a8 <__printf+0x5f0>
    800024bc:	02d7f5bb          	remuw	a1,a5,a3
    800024c0:	02059593          	slli	a1,a1,0x20
    800024c4:	0205d593          	srli	a1,a1,0x20
    800024c8:	00bd85b3          	add	a1,s11,a1
    800024cc:	0005c583          	lbu	a1,0(a1)
    800024d0:	02d7d7bb          	divuw	a5,a5,a3
    800024d4:	f8b403a3          	sb	a1,-121(s0)
    800024d8:	42eb7e63          	bgeu	s6,a4,80002914 <__printf+0x65c>
    800024dc:	02d7f5bb          	remuw	a1,a5,a3
    800024e0:	02059593          	slli	a1,a1,0x20
    800024e4:	0205d593          	srli	a1,a1,0x20
    800024e8:	00bd85b3          	add	a1,s11,a1
    800024ec:	0005c583          	lbu	a1,0(a1)
    800024f0:	02d7d7bb          	divuw	a5,a5,a3
    800024f4:	f8b40423          	sb	a1,-120(s0)
    800024f8:	42ebfc63          	bgeu	s7,a4,80002930 <__printf+0x678>
    800024fc:	02079793          	slli	a5,a5,0x20
    80002500:	0207d793          	srli	a5,a5,0x20
    80002504:	00fd8db3          	add	s11,s11,a5
    80002508:	000dc703          	lbu	a4,0(s11)
    8000250c:	00a00793          	li	a5,10
    80002510:	00900c93          	li	s9,9
    80002514:	f8e404a3          	sb	a4,-119(s0)
    80002518:	00065c63          	bgez	a2,80002530 <__printf+0x278>
    8000251c:	f9040713          	addi	a4,s0,-112
    80002520:	00f70733          	add	a4,a4,a5
    80002524:	02d00693          	li	a3,45
    80002528:	fed70823          	sb	a3,-16(a4)
    8000252c:	00078c93          	mv	s9,a5
    80002530:	f8040793          	addi	a5,s0,-128
    80002534:	01978cb3          	add	s9,a5,s9
    80002538:	f7f40d13          	addi	s10,s0,-129
    8000253c:	000cc503          	lbu	a0,0(s9)
    80002540:	fffc8c93          	addi	s9,s9,-1
    80002544:	00000097          	auipc	ra,0x0
    80002548:	b90080e7          	jalr	-1136(ra) # 800020d4 <consputc>
    8000254c:	ffac98e3          	bne	s9,s10,8000253c <__printf+0x284>
    80002550:	00094503          	lbu	a0,0(s2)
    80002554:	e00514e3          	bnez	a0,8000235c <__printf+0xa4>
    80002558:	1a0c1663          	bnez	s8,80002704 <__printf+0x44c>
    8000255c:	08813083          	ld	ra,136(sp)
    80002560:	08013403          	ld	s0,128(sp)
    80002564:	07813483          	ld	s1,120(sp)
    80002568:	07013903          	ld	s2,112(sp)
    8000256c:	06813983          	ld	s3,104(sp)
    80002570:	06013a03          	ld	s4,96(sp)
    80002574:	05813a83          	ld	s5,88(sp)
    80002578:	05013b03          	ld	s6,80(sp)
    8000257c:	04813b83          	ld	s7,72(sp)
    80002580:	04013c03          	ld	s8,64(sp)
    80002584:	03813c83          	ld	s9,56(sp)
    80002588:	03013d03          	ld	s10,48(sp)
    8000258c:	02813d83          	ld	s11,40(sp)
    80002590:	0d010113          	addi	sp,sp,208
    80002594:	00008067          	ret
    80002598:	07300713          	li	a4,115
    8000259c:	1ce78a63          	beq	a5,a4,80002770 <__printf+0x4b8>
    800025a0:	07800713          	li	a4,120
    800025a4:	1ee79e63          	bne	a5,a4,800027a0 <__printf+0x4e8>
    800025a8:	f7843783          	ld	a5,-136(s0)
    800025ac:	0007a703          	lw	a4,0(a5)
    800025b0:	00878793          	addi	a5,a5,8
    800025b4:	f6f43c23          	sd	a5,-136(s0)
    800025b8:	28074263          	bltz	a4,8000283c <__printf+0x584>
    800025bc:	00002d97          	auipc	s11,0x2
    800025c0:	bd4d8d93          	addi	s11,s11,-1068 # 80004190 <digits>
    800025c4:	00f77793          	andi	a5,a4,15
    800025c8:	00fd87b3          	add	a5,s11,a5
    800025cc:	0007c683          	lbu	a3,0(a5)
    800025d0:	00f00613          	li	a2,15
    800025d4:	0007079b          	sext.w	a5,a4
    800025d8:	f8d40023          	sb	a3,-128(s0)
    800025dc:	0047559b          	srliw	a1,a4,0x4
    800025e0:	0047569b          	srliw	a3,a4,0x4
    800025e4:	00000c93          	li	s9,0
    800025e8:	0ee65063          	bge	a2,a4,800026c8 <__printf+0x410>
    800025ec:	00f6f693          	andi	a3,a3,15
    800025f0:	00dd86b3          	add	a3,s11,a3
    800025f4:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    800025f8:	0087d79b          	srliw	a5,a5,0x8
    800025fc:	00100c93          	li	s9,1
    80002600:	f8d400a3          	sb	a3,-127(s0)
    80002604:	0cb67263          	bgeu	a2,a1,800026c8 <__printf+0x410>
    80002608:	00f7f693          	andi	a3,a5,15
    8000260c:	00dd86b3          	add	a3,s11,a3
    80002610:	0006c583          	lbu	a1,0(a3)
    80002614:	00f00613          	li	a2,15
    80002618:	0047d69b          	srliw	a3,a5,0x4
    8000261c:	f8b40123          	sb	a1,-126(s0)
    80002620:	0047d593          	srli	a1,a5,0x4
    80002624:	28f67e63          	bgeu	a2,a5,800028c0 <__printf+0x608>
    80002628:	00f6f693          	andi	a3,a3,15
    8000262c:	00dd86b3          	add	a3,s11,a3
    80002630:	0006c503          	lbu	a0,0(a3)
    80002634:	0087d813          	srli	a6,a5,0x8
    80002638:	0087d69b          	srliw	a3,a5,0x8
    8000263c:	f8a401a3          	sb	a0,-125(s0)
    80002640:	28b67663          	bgeu	a2,a1,800028cc <__printf+0x614>
    80002644:	00f6f693          	andi	a3,a3,15
    80002648:	00dd86b3          	add	a3,s11,a3
    8000264c:	0006c583          	lbu	a1,0(a3)
    80002650:	00c7d513          	srli	a0,a5,0xc
    80002654:	00c7d69b          	srliw	a3,a5,0xc
    80002658:	f8b40223          	sb	a1,-124(s0)
    8000265c:	29067a63          	bgeu	a2,a6,800028f0 <__printf+0x638>
    80002660:	00f6f693          	andi	a3,a3,15
    80002664:	00dd86b3          	add	a3,s11,a3
    80002668:	0006c583          	lbu	a1,0(a3)
    8000266c:	0107d813          	srli	a6,a5,0x10
    80002670:	0107d69b          	srliw	a3,a5,0x10
    80002674:	f8b402a3          	sb	a1,-123(s0)
    80002678:	28a67263          	bgeu	a2,a0,800028fc <__printf+0x644>
    8000267c:	00f6f693          	andi	a3,a3,15
    80002680:	00dd86b3          	add	a3,s11,a3
    80002684:	0006c683          	lbu	a3,0(a3)
    80002688:	0147d79b          	srliw	a5,a5,0x14
    8000268c:	f8d40323          	sb	a3,-122(s0)
    80002690:	21067663          	bgeu	a2,a6,8000289c <__printf+0x5e4>
    80002694:	02079793          	slli	a5,a5,0x20
    80002698:	0207d793          	srli	a5,a5,0x20
    8000269c:	00fd8db3          	add	s11,s11,a5
    800026a0:	000dc683          	lbu	a3,0(s11)
    800026a4:	00800793          	li	a5,8
    800026a8:	00700c93          	li	s9,7
    800026ac:	f8d403a3          	sb	a3,-121(s0)
    800026b0:	00075c63          	bgez	a4,800026c8 <__printf+0x410>
    800026b4:	f9040713          	addi	a4,s0,-112
    800026b8:	00f70733          	add	a4,a4,a5
    800026bc:	02d00693          	li	a3,45
    800026c0:	fed70823          	sb	a3,-16(a4)
    800026c4:	00078c93          	mv	s9,a5
    800026c8:	f8040793          	addi	a5,s0,-128
    800026cc:	01978cb3          	add	s9,a5,s9
    800026d0:	f7f40d13          	addi	s10,s0,-129
    800026d4:	000cc503          	lbu	a0,0(s9)
    800026d8:	fffc8c93          	addi	s9,s9,-1
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	9f8080e7          	jalr	-1544(ra) # 800020d4 <consputc>
    800026e4:	ff9d18e3          	bne	s10,s9,800026d4 <__printf+0x41c>
    800026e8:	0100006f          	j	800026f8 <__printf+0x440>
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	9e8080e7          	jalr	-1560(ra) # 800020d4 <consputc>
    800026f4:	000c8493          	mv	s1,s9
    800026f8:	00094503          	lbu	a0,0(s2)
    800026fc:	c60510e3          	bnez	a0,8000235c <__printf+0xa4>
    80002700:	e40c0ee3          	beqz	s8,8000255c <__printf+0x2a4>
    80002704:	00003517          	auipc	a0,0x3
    80002708:	fdc50513          	addi	a0,a0,-36 # 800056e0 <pr>
    8000270c:	00001097          	auipc	ra,0x1
    80002710:	94c080e7          	jalr	-1716(ra) # 80003058 <release>
    80002714:	e49ff06f          	j	8000255c <__printf+0x2a4>
    80002718:	f7843783          	ld	a5,-136(s0)
    8000271c:	03000513          	li	a0,48
    80002720:	01000d13          	li	s10,16
    80002724:	00878713          	addi	a4,a5,8
    80002728:	0007bc83          	ld	s9,0(a5)
    8000272c:	f6e43c23          	sd	a4,-136(s0)
    80002730:	00000097          	auipc	ra,0x0
    80002734:	9a4080e7          	jalr	-1628(ra) # 800020d4 <consputc>
    80002738:	07800513          	li	a0,120
    8000273c:	00000097          	auipc	ra,0x0
    80002740:	998080e7          	jalr	-1640(ra) # 800020d4 <consputc>
    80002744:	00002d97          	auipc	s11,0x2
    80002748:	a4cd8d93          	addi	s11,s11,-1460 # 80004190 <digits>
    8000274c:	03ccd793          	srli	a5,s9,0x3c
    80002750:	00fd87b3          	add	a5,s11,a5
    80002754:	0007c503          	lbu	a0,0(a5)
    80002758:	fffd0d1b          	addiw	s10,s10,-1
    8000275c:	004c9c93          	slli	s9,s9,0x4
    80002760:	00000097          	auipc	ra,0x0
    80002764:	974080e7          	jalr	-1676(ra) # 800020d4 <consputc>
    80002768:	fe0d12e3          	bnez	s10,8000274c <__printf+0x494>
    8000276c:	f8dff06f          	j	800026f8 <__printf+0x440>
    80002770:	f7843783          	ld	a5,-136(s0)
    80002774:	0007bc83          	ld	s9,0(a5)
    80002778:	00878793          	addi	a5,a5,8
    8000277c:	f6f43c23          	sd	a5,-136(s0)
    80002780:	000c9a63          	bnez	s9,80002794 <__printf+0x4dc>
    80002784:	1080006f          	j	8000288c <__printf+0x5d4>
    80002788:	001c8c93          	addi	s9,s9,1
    8000278c:	00000097          	auipc	ra,0x0
    80002790:	948080e7          	jalr	-1720(ra) # 800020d4 <consputc>
    80002794:	000cc503          	lbu	a0,0(s9)
    80002798:	fe0518e3          	bnez	a0,80002788 <__printf+0x4d0>
    8000279c:	f5dff06f          	j	800026f8 <__printf+0x440>
    800027a0:	02500513          	li	a0,37
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	930080e7          	jalr	-1744(ra) # 800020d4 <consputc>
    800027ac:	000c8513          	mv	a0,s9
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	924080e7          	jalr	-1756(ra) # 800020d4 <consputc>
    800027b8:	f41ff06f          	j	800026f8 <__printf+0x440>
    800027bc:	02500513          	li	a0,37
    800027c0:	00000097          	auipc	ra,0x0
    800027c4:	914080e7          	jalr	-1772(ra) # 800020d4 <consputc>
    800027c8:	f31ff06f          	j	800026f8 <__printf+0x440>
    800027cc:	00030513          	mv	a0,t1
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	7bc080e7          	jalr	1980(ra) # 80002f8c <acquire>
    800027d8:	b4dff06f          	j	80002324 <__printf+0x6c>
    800027dc:	40c0053b          	negw	a0,a2
    800027e0:	00a00713          	li	a4,10
    800027e4:	02e576bb          	remuw	a3,a0,a4
    800027e8:	00002d97          	auipc	s11,0x2
    800027ec:	9a8d8d93          	addi	s11,s11,-1624 # 80004190 <digits>
    800027f0:	ff700593          	li	a1,-9
    800027f4:	02069693          	slli	a3,a3,0x20
    800027f8:	0206d693          	srli	a3,a3,0x20
    800027fc:	00dd86b3          	add	a3,s11,a3
    80002800:	0006c683          	lbu	a3,0(a3)
    80002804:	02e557bb          	divuw	a5,a0,a4
    80002808:	f8d40023          	sb	a3,-128(s0)
    8000280c:	10b65e63          	bge	a2,a1,80002928 <__printf+0x670>
    80002810:	06300593          	li	a1,99
    80002814:	02e7f6bb          	remuw	a3,a5,a4
    80002818:	02069693          	slli	a3,a3,0x20
    8000281c:	0206d693          	srli	a3,a3,0x20
    80002820:	00dd86b3          	add	a3,s11,a3
    80002824:	0006c683          	lbu	a3,0(a3)
    80002828:	02e7d73b          	divuw	a4,a5,a4
    8000282c:	00200793          	li	a5,2
    80002830:	f8d400a3          	sb	a3,-127(s0)
    80002834:	bca5ece3          	bltu	a1,a0,8000240c <__printf+0x154>
    80002838:	ce5ff06f          	j	8000251c <__printf+0x264>
    8000283c:	40e007bb          	negw	a5,a4
    80002840:	00002d97          	auipc	s11,0x2
    80002844:	950d8d93          	addi	s11,s11,-1712 # 80004190 <digits>
    80002848:	00f7f693          	andi	a3,a5,15
    8000284c:	00dd86b3          	add	a3,s11,a3
    80002850:	0006c583          	lbu	a1,0(a3)
    80002854:	ff100613          	li	a2,-15
    80002858:	0047d69b          	srliw	a3,a5,0x4
    8000285c:	f8b40023          	sb	a1,-128(s0)
    80002860:	0047d59b          	srliw	a1,a5,0x4
    80002864:	0ac75e63          	bge	a4,a2,80002920 <__printf+0x668>
    80002868:	00f6f693          	andi	a3,a3,15
    8000286c:	00dd86b3          	add	a3,s11,a3
    80002870:	0006c603          	lbu	a2,0(a3)
    80002874:	00f00693          	li	a3,15
    80002878:	0087d79b          	srliw	a5,a5,0x8
    8000287c:	f8c400a3          	sb	a2,-127(s0)
    80002880:	d8b6e4e3          	bltu	a3,a1,80002608 <__printf+0x350>
    80002884:	00200793          	li	a5,2
    80002888:	e2dff06f          	j	800026b4 <__printf+0x3fc>
    8000288c:	00002c97          	auipc	s9,0x2
    80002890:	8e4c8c93          	addi	s9,s9,-1820 # 80004170 <_ZZ12printIntegerE6digits+0x150>
    80002894:	02800513          	li	a0,40
    80002898:	ef1ff06f          	j	80002788 <__printf+0x4d0>
    8000289c:	00700793          	li	a5,7
    800028a0:	00600c93          	li	s9,6
    800028a4:	e0dff06f          	j	800026b0 <__printf+0x3f8>
    800028a8:	00700793          	li	a5,7
    800028ac:	00600c93          	li	s9,6
    800028b0:	c69ff06f          	j	80002518 <__printf+0x260>
    800028b4:	00300793          	li	a5,3
    800028b8:	00200c93          	li	s9,2
    800028bc:	c5dff06f          	j	80002518 <__printf+0x260>
    800028c0:	00300793          	li	a5,3
    800028c4:	00200c93          	li	s9,2
    800028c8:	de9ff06f          	j	800026b0 <__printf+0x3f8>
    800028cc:	00400793          	li	a5,4
    800028d0:	00300c93          	li	s9,3
    800028d4:	dddff06f          	j	800026b0 <__printf+0x3f8>
    800028d8:	00400793          	li	a5,4
    800028dc:	00300c93          	li	s9,3
    800028e0:	c39ff06f          	j	80002518 <__printf+0x260>
    800028e4:	00500793          	li	a5,5
    800028e8:	00400c93          	li	s9,4
    800028ec:	c2dff06f          	j	80002518 <__printf+0x260>
    800028f0:	00500793          	li	a5,5
    800028f4:	00400c93          	li	s9,4
    800028f8:	db9ff06f          	j	800026b0 <__printf+0x3f8>
    800028fc:	00600793          	li	a5,6
    80002900:	00500c93          	li	s9,5
    80002904:	dadff06f          	j	800026b0 <__printf+0x3f8>
    80002908:	00600793          	li	a5,6
    8000290c:	00500c93          	li	s9,5
    80002910:	c09ff06f          	j	80002518 <__printf+0x260>
    80002914:	00800793          	li	a5,8
    80002918:	00700c93          	li	s9,7
    8000291c:	bfdff06f          	j	80002518 <__printf+0x260>
    80002920:	00100793          	li	a5,1
    80002924:	d91ff06f          	j	800026b4 <__printf+0x3fc>
    80002928:	00100793          	li	a5,1
    8000292c:	bf1ff06f          	j	8000251c <__printf+0x264>
    80002930:	00900793          	li	a5,9
    80002934:	00800c93          	li	s9,8
    80002938:	be1ff06f          	j	80002518 <__printf+0x260>
    8000293c:	00002517          	auipc	a0,0x2
    80002940:	83c50513          	addi	a0,a0,-1988 # 80004178 <_ZZ12printIntegerE6digits+0x158>
    80002944:	00000097          	auipc	ra,0x0
    80002948:	918080e7          	jalr	-1768(ra) # 8000225c <panic>

000000008000294c <printfinit>:
    8000294c:	fe010113          	addi	sp,sp,-32
    80002950:	00813823          	sd	s0,16(sp)
    80002954:	00913423          	sd	s1,8(sp)
    80002958:	00113c23          	sd	ra,24(sp)
    8000295c:	02010413          	addi	s0,sp,32
    80002960:	00003497          	auipc	s1,0x3
    80002964:	d8048493          	addi	s1,s1,-640 # 800056e0 <pr>
    80002968:	00048513          	mv	a0,s1
    8000296c:	00002597          	auipc	a1,0x2
    80002970:	81c58593          	addi	a1,a1,-2020 # 80004188 <_ZZ12printIntegerE6digits+0x168>
    80002974:	00000097          	auipc	ra,0x0
    80002978:	5f4080e7          	jalr	1524(ra) # 80002f68 <initlock>
    8000297c:	01813083          	ld	ra,24(sp)
    80002980:	01013403          	ld	s0,16(sp)
    80002984:	0004ac23          	sw	zero,24(s1)
    80002988:	00813483          	ld	s1,8(sp)
    8000298c:	02010113          	addi	sp,sp,32
    80002990:	00008067          	ret

0000000080002994 <uartinit>:
    80002994:	ff010113          	addi	sp,sp,-16
    80002998:	00813423          	sd	s0,8(sp)
    8000299c:	01010413          	addi	s0,sp,16
    800029a0:	100007b7          	lui	a5,0x10000
    800029a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    800029a8:	f8000713          	li	a4,-128
    800029ac:	00e781a3          	sb	a4,3(a5)
    800029b0:	00300713          	li	a4,3
    800029b4:	00e78023          	sb	a4,0(a5)
    800029b8:	000780a3          	sb	zero,1(a5)
    800029bc:	00e781a3          	sb	a4,3(a5)
    800029c0:	00700693          	li	a3,7
    800029c4:	00d78123          	sb	a3,2(a5)
    800029c8:	00e780a3          	sb	a4,1(a5)
    800029cc:	00813403          	ld	s0,8(sp)
    800029d0:	01010113          	addi	sp,sp,16
    800029d4:	00008067          	ret

00000000800029d8 <uartputc>:
    800029d8:	00002797          	auipc	a5,0x2
    800029dc:	ac07a783          	lw	a5,-1344(a5) # 80004498 <panicked>
    800029e0:	00078463          	beqz	a5,800029e8 <uartputc+0x10>
    800029e4:	0000006f          	j	800029e4 <uartputc+0xc>
    800029e8:	fd010113          	addi	sp,sp,-48
    800029ec:	02813023          	sd	s0,32(sp)
    800029f0:	00913c23          	sd	s1,24(sp)
    800029f4:	01213823          	sd	s2,16(sp)
    800029f8:	01313423          	sd	s3,8(sp)
    800029fc:	02113423          	sd	ra,40(sp)
    80002a00:	03010413          	addi	s0,sp,48
    80002a04:	00002917          	auipc	s2,0x2
    80002a08:	a9c90913          	addi	s2,s2,-1380 # 800044a0 <uart_tx_r>
    80002a0c:	00093783          	ld	a5,0(s2)
    80002a10:	00002497          	auipc	s1,0x2
    80002a14:	a9848493          	addi	s1,s1,-1384 # 800044a8 <uart_tx_w>
    80002a18:	0004b703          	ld	a4,0(s1)
    80002a1c:	02078693          	addi	a3,a5,32
    80002a20:	00050993          	mv	s3,a0
    80002a24:	02e69c63          	bne	a3,a4,80002a5c <uartputc+0x84>
    80002a28:	00001097          	auipc	ra,0x1
    80002a2c:	834080e7          	jalr	-1996(ra) # 8000325c <push_on>
    80002a30:	00093783          	ld	a5,0(s2)
    80002a34:	0004b703          	ld	a4,0(s1)
    80002a38:	02078793          	addi	a5,a5,32
    80002a3c:	00e79463          	bne	a5,a4,80002a44 <uartputc+0x6c>
    80002a40:	0000006f          	j	80002a40 <uartputc+0x68>
    80002a44:	00001097          	auipc	ra,0x1
    80002a48:	88c080e7          	jalr	-1908(ra) # 800032d0 <pop_on>
    80002a4c:	00093783          	ld	a5,0(s2)
    80002a50:	0004b703          	ld	a4,0(s1)
    80002a54:	02078693          	addi	a3,a5,32
    80002a58:	fce688e3          	beq	a3,a4,80002a28 <uartputc+0x50>
    80002a5c:	01f77693          	andi	a3,a4,31
    80002a60:	00003597          	auipc	a1,0x3
    80002a64:	ca058593          	addi	a1,a1,-864 # 80005700 <uart_tx_buf>
    80002a68:	00d586b3          	add	a3,a1,a3
    80002a6c:	00170713          	addi	a4,a4,1
    80002a70:	01368023          	sb	s3,0(a3)
    80002a74:	00e4b023          	sd	a4,0(s1)
    80002a78:	10000637          	lui	a2,0x10000
    80002a7c:	02f71063          	bne	a4,a5,80002a9c <uartputc+0xc4>
    80002a80:	0340006f          	j	80002ab4 <uartputc+0xdc>
    80002a84:	00074703          	lbu	a4,0(a4)
    80002a88:	00f93023          	sd	a5,0(s2)
    80002a8c:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    80002a90:	00093783          	ld	a5,0(s2)
    80002a94:	0004b703          	ld	a4,0(s1)
    80002a98:	00f70e63          	beq	a4,a5,80002ab4 <uartputc+0xdc>
    80002a9c:	00564683          	lbu	a3,5(a2)
    80002aa0:	01f7f713          	andi	a4,a5,31
    80002aa4:	00e58733          	add	a4,a1,a4
    80002aa8:	0206f693          	andi	a3,a3,32
    80002aac:	00178793          	addi	a5,a5,1
    80002ab0:	fc069ae3          	bnez	a3,80002a84 <uartputc+0xac>
    80002ab4:	02813083          	ld	ra,40(sp)
    80002ab8:	02013403          	ld	s0,32(sp)
    80002abc:	01813483          	ld	s1,24(sp)
    80002ac0:	01013903          	ld	s2,16(sp)
    80002ac4:	00813983          	ld	s3,8(sp)
    80002ac8:	03010113          	addi	sp,sp,48
    80002acc:	00008067          	ret

0000000080002ad0 <uartputc_sync>:
    80002ad0:	ff010113          	addi	sp,sp,-16
    80002ad4:	00813423          	sd	s0,8(sp)
    80002ad8:	01010413          	addi	s0,sp,16
    80002adc:	00002717          	auipc	a4,0x2
    80002ae0:	9bc72703          	lw	a4,-1604(a4) # 80004498 <panicked>
    80002ae4:	02071663          	bnez	a4,80002b10 <uartputc_sync+0x40>
    80002ae8:	00050793          	mv	a5,a0
    80002aec:	100006b7          	lui	a3,0x10000
    80002af0:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    80002af4:	02077713          	andi	a4,a4,32
    80002af8:	fe070ce3          	beqz	a4,80002af0 <uartputc_sync+0x20>
    80002afc:	0ff7f793          	andi	a5,a5,255
    80002b00:	00f68023          	sb	a5,0(a3)
    80002b04:	00813403          	ld	s0,8(sp)
    80002b08:	01010113          	addi	sp,sp,16
    80002b0c:	00008067          	ret
    80002b10:	0000006f          	j	80002b10 <uartputc_sync+0x40>

0000000080002b14 <uartstart>:
    80002b14:	ff010113          	addi	sp,sp,-16
    80002b18:	00813423          	sd	s0,8(sp)
    80002b1c:	01010413          	addi	s0,sp,16
    80002b20:	00002617          	auipc	a2,0x2
    80002b24:	98060613          	addi	a2,a2,-1664 # 800044a0 <uart_tx_r>
    80002b28:	00002517          	auipc	a0,0x2
    80002b2c:	98050513          	addi	a0,a0,-1664 # 800044a8 <uart_tx_w>
    80002b30:	00063783          	ld	a5,0(a2)
    80002b34:	00053703          	ld	a4,0(a0)
    80002b38:	04f70263          	beq	a4,a5,80002b7c <uartstart+0x68>
    80002b3c:	100005b7          	lui	a1,0x10000
    80002b40:	00003817          	auipc	a6,0x3
    80002b44:	bc080813          	addi	a6,a6,-1088 # 80005700 <uart_tx_buf>
    80002b48:	01c0006f          	j	80002b64 <uartstart+0x50>
    80002b4c:	0006c703          	lbu	a4,0(a3)
    80002b50:	00f63023          	sd	a5,0(a2)
    80002b54:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80002b58:	00063783          	ld	a5,0(a2)
    80002b5c:	00053703          	ld	a4,0(a0)
    80002b60:	00f70e63          	beq	a4,a5,80002b7c <uartstart+0x68>
    80002b64:	01f7f713          	andi	a4,a5,31
    80002b68:	00e806b3          	add	a3,a6,a4
    80002b6c:	0055c703          	lbu	a4,5(a1)
    80002b70:	00178793          	addi	a5,a5,1
    80002b74:	02077713          	andi	a4,a4,32
    80002b78:	fc071ae3          	bnez	a4,80002b4c <uartstart+0x38>
    80002b7c:	00813403          	ld	s0,8(sp)
    80002b80:	01010113          	addi	sp,sp,16
    80002b84:	00008067          	ret

0000000080002b88 <uartgetc>:
    80002b88:	ff010113          	addi	sp,sp,-16
    80002b8c:	00813423          	sd	s0,8(sp)
    80002b90:	01010413          	addi	s0,sp,16
    80002b94:	10000737          	lui	a4,0x10000
    80002b98:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80002b9c:	0017f793          	andi	a5,a5,1
    80002ba0:	00078c63          	beqz	a5,80002bb8 <uartgetc+0x30>
    80002ba4:	00074503          	lbu	a0,0(a4)
    80002ba8:	0ff57513          	andi	a0,a0,255
    80002bac:	00813403          	ld	s0,8(sp)
    80002bb0:	01010113          	addi	sp,sp,16
    80002bb4:	00008067          	ret
    80002bb8:	fff00513          	li	a0,-1
    80002bbc:	ff1ff06f          	j	80002bac <uartgetc+0x24>

0000000080002bc0 <uartintr>:
    80002bc0:	100007b7          	lui	a5,0x10000
    80002bc4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80002bc8:	0017f793          	andi	a5,a5,1
    80002bcc:	0a078463          	beqz	a5,80002c74 <uartintr+0xb4>
    80002bd0:	fe010113          	addi	sp,sp,-32
    80002bd4:	00813823          	sd	s0,16(sp)
    80002bd8:	00913423          	sd	s1,8(sp)
    80002bdc:	00113c23          	sd	ra,24(sp)
    80002be0:	02010413          	addi	s0,sp,32
    80002be4:	100004b7          	lui	s1,0x10000
    80002be8:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    80002bec:	0ff57513          	andi	a0,a0,255
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	534080e7          	jalr	1332(ra) # 80002124 <consoleintr>
    80002bf8:	0054c783          	lbu	a5,5(s1)
    80002bfc:	0017f793          	andi	a5,a5,1
    80002c00:	fe0794e3          	bnez	a5,80002be8 <uartintr+0x28>
    80002c04:	00002617          	auipc	a2,0x2
    80002c08:	89c60613          	addi	a2,a2,-1892 # 800044a0 <uart_tx_r>
    80002c0c:	00002517          	auipc	a0,0x2
    80002c10:	89c50513          	addi	a0,a0,-1892 # 800044a8 <uart_tx_w>
    80002c14:	00063783          	ld	a5,0(a2)
    80002c18:	00053703          	ld	a4,0(a0)
    80002c1c:	04f70263          	beq	a4,a5,80002c60 <uartintr+0xa0>
    80002c20:	100005b7          	lui	a1,0x10000
    80002c24:	00003817          	auipc	a6,0x3
    80002c28:	adc80813          	addi	a6,a6,-1316 # 80005700 <uart_tx_buf>
    80002c2c:	01c0006f          	j	80002c48 <uartintr+0x88>
    80002c30:	0006c703          	lbu	a4,0(a3)
    80002c34:	00f63023          	sd	a5,0(a2)
    80002c38:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80002c3c:	00063783          	ld	a5,0(a2)
    80002c40:	00053703          	ld	a4,0(a0)
    80002c44:	00f70e63          	beq	a4,a5,80002c60 <uartintr+0xa0>
    80002c48:	01f7f713          	andi	a4,a5,31
    80002c4c:	00e806b3          	add	a3,a6,a4
    80002c50:	0055c703          	lbu	a4,5(a1)
    80002c54:	00178793          	addi	a5,a5,1
    80002c58:	02077713          	andi	a4,a4,32
    80002c5c:	fc071ae3          	bnez	a4,80002c30 <uartintr+0x70>
    80002c60:	01813083          	ld	ra,24(sp)
    80002c64:	01013403          	ld	s0,16(sp)
    80002c68:	00813483          	ld	s1,8(sp)
    80002c6c:	02010113          	addi	sp,sp,32
    80002c70:	00008067          	ret
    80002c74:	00002617          	auipc	a2,0x2
    80002c78:	82c60613          	addi	a2,a2,-2004 # 800044a0 <uart_tx_r>
    80002c7c:	00002517          	auipc	a0,0x2
    80002c80:	82c50513          	addi	a0,a0,-2004 # 800044a8 <uart_tx_w>
    80002c84:	00063783          	ld	a5,0(a2)
    80002c88:	00053703          	ld	a4,0(a0)
    80002c8c:	04f70263          	beq	a4,a5,80002cd0 <uartintr+0x110>
    80002c90:	100005b7          	lui	a1,0x10000
    80002c94:	00003817          	auipc	a6,0x3
    80002c98:	a6c80813          	addi	a6,a6,-1428 # 80005700 <uart_tx_buf>
    80002c9c:	01c0006f          	j	80002cb8 <uartintr+0xf8>
    80002ca0:	0006c703          	lbu	a4,0(a3)
    80002ca4:	00f63023          	sd	a5,0(a2)
    80002ca8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80002cac:	00063783          	ld	a5,0(a2)
    80002cb0:	00053703          	ld	a4,0(a0)
    80002cb4:	02f70063          	beq	a4,a5,80002cd4 <uartintr+0x114>
    80002cb8:	01f7f713          	andi	a4,a5,31
    80002cbc:	00e806b3          	add	a3,a6,a4
    80002cc0:	0055c703          	lbu	a4,5(a1)
    80002cc4:	00178793          	addi	a5,a5,1
    80002cc8:	02077713          	andi	a4,a4,32
    80002ccc:	fc071ae3          	bnez	a4,80002ca0 <uartintr+0xe0>
    80002cd0:	00008067          	ret
    80002cd4:	00008067          	ret

0000000080002cd8 <kinit>:
    80002cd8:	fc010113          	addi	sp,sp,-64
    80002cdc:	02913423          	sd	s1,40(sp)
    80002ce0:	fffff7b7          	lui	a5,0xfffff
    80002ce4:	00004497          	auipc	s1,0x4
    80002ce8:	a3b48493          	addi	s1,s1,-1477 # 8000671f <end+0xfff>
    80002cec:	02813823          	sd	s0,48(sp)
    80002cf0:	01313c23          	sd	s3,24(sp)
    80002cf4:	00f4f4b3          	and	s1,s1,a5
    80002cf8:	02113c23          	sd	ra,56(sp)
    80002cfc:	03213023          	sd	s2,32(sp)
    80002d00:	01413823          	sd	s4,16(sp)
    80002d04:	01513423          	sd	s5,8(sp)
    80002d08:	04010413          	addi	s0,sp,64
    80002d0c:	000017b7          	lui	a5,0x1
    80002d10:	01100993          	li	s3,17
    80002d14:	00f487b3          	add	a5,s1,a5
    80002d18:	01b99993          	slli	s3,s3,0x1b
    80002d1c:	06f9e063          	bltu	s3,a5,80002d7c <kinit+0xa4>
    80002d20:	00003a97          	auipc	s5,0x3
    80002d24:	a00a8a93          	addi	s5,s5,-1536 # 80005720 <end>
    80002d28:	0754ec63          	bltu	s1,s5,80002da0 <kinit+0xc8>
    80002d2c:	0734fa63          	bgeu	s1,s3,80002da0 <kinit+0xc8>
    80002d30:	00088a37          	lui	s4,0x88
    80002d34:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    80002d38:	00001917          	auipc	s2,0x1
    80002d3c:	77890913          	addi	s2,s2,1912 # 800044b0 <kmem>
    80002d40:	00ca1a13          	slli	s4,s4,0xc
    80002d44:	0140006f          	j	80002d58 <kinit+0x80>
    80002d48:	000017b7          	lui	a5,0x1
    80002d4c:	00f484b3          	add	s1,s1,a5
    80002d50:	0554e863          	bltu	s1,s5,80002da0 <kinit+0xc8>
    80002d54:	0534f663          	bgeu	s1,s3,80002da0 <kinit+0xc8>
    80002d58:	00001637          	lui	a2,0x1
    80002d5c:	00100593          	li	a1,1
    80002d60:	00048513          	mv	a0,s1
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	5e4080e7          	jalr	1508(ra) # 80003348 <__memset>
    80002d6c:	00093783          	ld	a5,0(s2)
    80002d70:	00f4b023          	sd	a5,0(s1)
    80002d74:	00993023          	sd	s1,0(s2)
    80002d78:	fd4498e3          	bne	s1,s4,80002d48 <kinit+0x70>
    80002d7c:	03813083          	ld	ra,56(sp)
    80002d80:	03013403          	ld	s0,48(sp)
    80002d84:	02813483          	ld	s1,40(sp)
    80002d88:	02013903          	ld	s2,32(sp)
    80002d8c:	01813983          	ld	s3,24(sp)
    80002d90:	01013a03          	ld	s4,16(sp)
    80002d94:	00813a83          	ld	s5,8(sp)
    80002d98:	04010113          	addi	sp,sp,64
    80002d9c:	00008067          	ret
    80002da0:	00001517          	auipc	a0,0x1
    80002da4:	40850513          	addi	a0,a0,1032 # 800041a8 <digits+0x18>
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	4b4080e7          	jalr	1204(ra) # 8000225c <panic>

0000000080002db0 <freerange>:
    80002db0:	fc010113          	addi	sp,sp,-64
    80002db4:	000017b7          	lui	a5,0x1
    80002db8:	02913423          	sd	s1,40(sp)
    80002dbc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80002dc0:	009504b3          	add	s1,a0,s1
    80002dc4:	fffff537          	lui	a0,0xfffff
    80002dc8:	02813823          	sd	s0,48(sp)
    80002dcc:	02113c23          	sd	ra,56(sp)
    80002dd0:	03213023          	sd	s2,32(sp)
    80002dd4:	01313c23          	sd	s3,24(sp)
    80002dd8:	01413823          	sd	s4,16(sp)
    80002ddc:	01513423          	sd	s5,8(sp)
    80002de0:	01613023          	sd	s6,0(sp)
    80002de4:	04010413          	addi	s0,sp,64
    80002de8:	00a4f4b3          	and	s1,s1,a0
    80002dec:	00f487b3          	add	a5,s1,a5
    80002df0:	06f5e463          	bltu	a1,a5,80002e58 <freerange+0xa8>
    80002df4:	00003a97          	auipc	s5,0x3
    80002df8:	92ca8a93          	addi	s5,s5,-1748 # 80005720 <end>
    80002dfc:	0954e263          	bltu	s1,s5,80002e80 <freerange+0xd0>
    80002e00:	01100993          	li	s3,17
    80002e04:	01b99993          	slli	s3,s3,0x1b
    80002e08:	0734fc63          	bgeu	s1,s3,80002e80 <freerange+0xd0>
    80002e0c:	00058a13          	mv	s4,a1
    80002e10:	00001917          	auipc	s2,0x1
    80002e14:	6a090913          	addi	s2,s2,1696 # 800044b0 <kmem>
    80002e18:	00002b37          	lui	s6,0x2
    80002e1c:	0140006f          	j	80002e30 <freerange+0x80>
    80002e20:	000017b7          	lui	a5,0x1
    80002e24:	00f484b3          	add	s1,s1,a5
    80002e28:	0554ec63          	bltu	s1,s5,80002e80 <freerange+0xd0>
    80002e2c:	0534fa63          	bgeu	s1,s3,80002e80 <freerange+0xd0>
    80002e30:	00001637          	lui	a2,0x1
    80002e34:	00100593          	li	a1,1
    80002e38:	00048513          	mv	a0,s1
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	50c080e7          	jalr	1292(ra) # 80003348 <__memset>
    80002e44:	00093703          	ld	a4,0(s2)
    80002e48:	016487b3          	add	a5,s1,s6
    80002e4c:	00e4b023          	sd	a4,0(s1)
    80002e50:	00993023          	sd	s1,0(s2)
    80002e54:	fcfa76e3          	bgeu	s4,a5,80002e20 <freerange+0x70>
    80002e58:	03813083          	ld	ra,56(sp)
    80002e5c:	03013403          	ld	s0,48(sp)
    80002e60:	02813483          	ld	s1,40(sp)
    80002e64:	02013903          	ld	s2,32(sp)
    80002e68:	01813983          	ld	s3,24(sp)
    80002e6c:	01013a03          	ld	s4,16(sp)
    80002e70:	00813a83          	ld	s5,8(sp)
    80002e74:	00013b03          	ld	s6,0(sp)
    80002e78:	04010113          	addi	sp,sp,64
    80002e7c:	00008067          	ret
    80002e80:	00001517          	auipc	a0,0x1
    80002e84:	32850513          	addi	a0,a0,808 # 800041a8 <digits+0x18>
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	3d4080e7          	jalr	980(ra) # 8000225c <panic>

0000000080002e90 <kfree>:
    80002e90:	fe010113          	addi	sp,sp,-32
    80002e94:	00813823          	sd	s0,16(sp)
    80002e98:	00113c23          	sd	ra,24(sp)
    80002e9c:	00913423          	sd	s1,8(sp)
    80002ea0:	02010413          	addi	s0,sp,32
    80002ea4:	03451793          	slli	a5,a0,0x34
    80002ea8:	04079c63          	bnez	a5,80002f00 <kfree+0x70>
    80002eac:	00003797          	auipc	a5,0x3
    80002eb0:	87478793          	addi	a5,a5,-1932 # 80005720 <end>
    80002eb4:	00050493          	mv	s1,a0
    80002eb8:	04f56463          	bltu	a0,a5,80002f00 <kfree+0x70>
    80002ebc:	01100793          	li	a5,17
    80002ec0:	01b79793          	slli	a5,a5,0x1b
    80002ec4:	02f57e63          	bgeu	a0,a5,80002f00 <kfree+0x70>
    80002ec8:	00001637          	lui	a2,0x1
    80002ecc:	00100593          	li	a1,1
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	478080e7          	jalr	1144(ra) # 80003348 <__memset>
    80002ed8:	00001797          	auipc	a5,0x1
    80002edc:	5d878793          	addi	a5,a5,1496 # 800044b0 <kmem>
    80002ee0:	0007b703          	ld	a4,0(a5)
    80002ee4:	01813083          	ld	ra,24(sp)
    80002ee8:	01013403          	ld	s0,16(sp)
    80002eec:	00e4b023          	sd	a4,0(s1)
    80002ef0:	0097b023          	sd	s1,0(a5)
    80002ef4:	00813483          	ld	s1,8(sp)
    80002ef8:	02010113          	addi	sp,sp,32
    80002efc:	00008067          	ret
    80002f00:	00001517          	auipc	a0,0x1
    80002f04:	2a850513          	addi	a0,a0,680 # 800041a8 <digits+0x18>
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	354080e7          	jalr	852(ra) # 8000225c <panic>

0000000080002f10 <kalloc>:
    80002f10:	fe010113          	addi	sp,sp,-32
    80002f14:	00813823          	sd	s0,16(sp)
    80002f18:	00913423          	sd	s1,8(sp)
    80002f1c:	00113c23          	sd	ra,24(sp)
    80002f20:	02010413          	addi	s0,sp,32
    80002f24:	00001797          	auipc	a5,0x1
    80002f28:	58c78793          	addi	a5,a5,1420 # 800044b0 <kmem>
    80002f2c:	0007b483          	ld	s1,0(a5)
    80002f30:	02048063          	beqz	s1,80002f50 <kalloc+0x40>
    80002f34:	0004b703          	ld	a4,0(s1)
    80002f38:	00001637          	lui	a2,0x1
    80002f3c:	00500593          	li	a1,5
    80002f40:	00048513          	mv	a0,s1
    80002f44:	00e7b023          	sd	a4,0(a5)
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	400080e7          	jalr	1024(ra) # 80003348 <__memset>
    80002f50:	01813083          	ld	ra,24(sp)
    80002f54:	01013403          	ld	s0,16(sp)
    80002f58:	00048513          	mv	a0,s1
    80002f5c:	00813483          	ld	s1,8(sp)
    80002f60:	02010113          	addi	sp,sp,32
    80002f64:	00008067          	ret

0000000080002f68 <initlock>:
    80002f68:	ff010113          	addi	sp,sp,-16
    80002f6c:	00813423          	sd	s0,8(sp)
    80002f70:	01010413          	addi	s0,sp,16
    80002f74:	00813403          	ld	s0,8(sp)
    80002f78:	00b53423          	sd	a1,8(a0)
    80002f7c:	00052023          	sw	zero,0(a0)
    80002f80:	00053823          	sd	zero,16(a0)
    80002f84:	01010113          	addi	sp,sp,16
    80002f88:	00008067          	ret

0000000080002f8c <acquire>:
    80002f8c:	fe010113          	addi	sp,sp,-32
    80002f90:	00813823          	sd	s0,16(sp)
    80002f94:	00913423          	sd	s1,8(sp)
    80002f98:	00113c23          	sd	ra,24(sp)
    80002f9c:	01213023          	sd	s2,0(sp)
    80002fa0:	02010413          	addi	s0,sp,32
    80002fa4:	00050493          	mv	s1,a0
    80002fa8:	10002973          	csrr	s2,sstatus
    80002fac:	100027f3          	csrr	a5,sstatus
    80002fb0:	ffd7f793          	andi	a5,a5,-3
    80002fb4:	10079073          	csrw	sstatus,a5
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	8ec080e7          	jalr	-1812(ra) # 800018a4 <mycpu>
    80002fc0:	07852783          	lw	a5,120(a0)
    80002fc4:	06078e63          	beqz	a5,80003040 <acquire+0xb4>
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	8dc080e7          	jalr	-1828(ra) # 800018a4 <mycpu>
    80002fd0:	07852783          	lw	a5,120(a0)
    80002fd4:	0004a703          	lw	a4,0(s1)
    80002fd8:	0017879b          	addiw	a5,a5,1
    80002fdc:	06f52c23          	sw	a5,120(a0)
    80002fe0:	04071063          	bnez	a4,80003020 <acquire+0x94>
    80002fe4:	00100713          	li	a4,1
    80002fe8:	00070793          	mv	a5,a4
    80002fec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80002ff0:	0007879b          	sext.w	a5,a5
    80002ff4:	fe079ae3          	bnez	a5,80002fe8 <acquire+0x5c>
    80002ff8:	0ff0000f          	fence
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	8a8080e7          	jalr	-1880(ra) # 800018a4 <mycpu>
    80003004:	01813083          	ld	ra,24(sp)
    80003008:	01013403          	ld	s0,16(sp)
    8000300c:	00a4b823          	sd	a0,16(s1)
    80003010:	00013903          	ld	s2,0(sp)
    80003014:	00813483          	ld	s1,8(sp)
    80003018:	02010113          	addi	sp,sp,32
    8000301c:	00008067          	ret
    80003020:	0104b903          	ld	s2,16(s1)
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	880080e7          	jalr	-1920(ra) # 800018a4 <mycpu>
    8000302c:	faa91ce3          	bne	s2,a0,80002fe4 <acquire+0x58>
    80003030:	00001517          	auipc	a0,0x1
    80003034:	18050513          	addi	a0,a0,384 # 800041b0 <digits+0x20>
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	224080e7          	jalr	548(ra) # 8000225c <panic>
    80003040:	00195913          	srli	s2,s2,0x1
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	860080e7          	jalr	-1952(ra) # 800018a4 <mycpu>
    8000304c:	00197913          	andi	s2,s2,1
    80003050:	07252e23          	sw	s2,124(a0)
    80003054:	f75ff06f          	j	80002fc8 <acquire+0x3c>

0000000080003058 <release>:
    80003058:	fe010113          	addi	sp,sp,-32
    8000305c:	00813823          	sd	s0,16(sp)
    80003060:	00113c23          	sd	ra,24(sp)
    80003064:	00913423          	sd	s1,8(sp)
    80003068:	01213023          	sd	s2,0(sp)
    8000306c:	02010413          	addi	s0,sp,32
    80003070:	00052783          	lw	a5,0(a0)
    80003074:	00079a63          	bnez	a5,80003088 <release+0x30>
    80003078:	00001517          	auipc	a0,0x1
    8000307c:	14050513          	addi	a0,a0,320 # 800041b8 <digits+0x28>
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	1dc080e7          	jalr	476(ra) # 8000225c <panic>
    80003088:	01053903          	ld	s2,16(a0)
    8000308c:	00050493          	mv	s1,a0
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	814080e7          	jalr	-2028(ra) # 800018a4 <mycpu>
    80003098:	fea910e3          	bne	s2,a0,80003078 <release+0x20>
    8000309c:	0004b823          	sd	zero,16(s1)
    800030a0:	0ff0000f          	fence
    800030a4:	0f50000f          	fence	iorw,ow
    800030a8:	0804a02f          	amoswap.w	zero,zero,(s1)
    800030ac:	ffffe097          	auipc	ra,0xffffe
    800030b0:	7f8080e7          	jalr	2040(ra) # 800018a4 <mycpu>
    800030b4:	100027f3          	csrr	a5,sstatus
    800030b8:	0027f793          	andi	a5,a5,2
    800030bc:	04079a63          	bnez	a5,80003110 <release+0xb8>
    800030c0:	07852783          	lw	a5,120(a0)
    800030c4:	02f05e63          	blez	a5,80003100 <release+0xa8>
    800030c8:	fff7871b          	addiw	a4,a5,-1
    800030cc:	06e52c23          	sw	a4,120(a0)
    800030d0:	00071c63          	bnez	a4,800030e8 <release+0x90>
    800030d4:	07c52783          	lw	a5,124(a0)
    800030d8:	00078863          	beqz	a5,800030e8 <release+0x90>
    800030dc:	100027f3          	csrr	a5,sstatus
    800030e0:	0027e793          	ori	a5,a5,2
    800030e4:	10079073          	csrw	sstatus,a5
    800030e8:	01813083          	ld	ra,24(sp)
    800030ec:	01013403          	ld	s0,16(sp)
    800030f0:	00813483          	ld	s1,8(sp)
    800030f4:	00013903          	ld	s2,0(sp)
    800030f8:	02010113          	addi	sp,sp,32
    800030fc:	00008067          	ret
    80003100:	00001517          	auipc	a0,0x1
    80003104:	0d850513          	addi	a0,a0,216 # 800041d8 <digits+0x48>
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	154080e7          	jalr	340(ra) # 8000225c <panic>
    80003110:	00001517          	auipc	a0,0x1
    80003114:	0b050513          	addi	a0,a0,176 # 800041c0 <digits+0x30>
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	144080e7          	jalr	324(ra) # 8000225c <panic>

0000000080003120 <holding>:
    80003120:	00052783          	lw	a5,0(a0)
    80003124:	00079663          	bnez	a5,80003130 <holding+0x10>
    80003128:	00000513          	li	a0,0
    8000312c:	00008067          	ret
    80003130:	fe010113          	addi	sp,sp,-32
    80003134:	00813823          	sd	s0,16(sp)
    80003138:	00913423          	sd	s1,8(sp)
    8000313c:	00113c23          	sd	ra,24(sp)
    80003140:	02010413          	addi	s0,sp,32
    80003144:	01053483          	ld	s1,16(a0)
    80003148:	ffffe097          	auipc	ra,0xffffe
    8000314c:	75c080e7          	jalr	1884(ra) # 800018a4 <mycpu>
    80003150:	01813083          	ld	ra,24(sp)
    80003154:	01013403          	ld	s0,16(sp)
    80003158:	40a48533          	sub	a0,s1,a0
    8000315c:	00153513          	seqz	a0,a0
    80003160:	00813483          	ld	s1,8(sp)
    80003164:	02010113          	addi	sp,sp,32
    80003168:	00008067          	ret

000000008000316c <push_off>:
    8000316c:	fe010113          	addi	sp,sp,-32
    80003170:	00813823          	sd	s0,16(sp)
    80003174:	00113c23          	sd	ra,24(sp)
    80003178:	00913423          	sd	s1,8(sp)
    8000317c:	02010413          	addi	s0,sp,32
    80003180:	100024f3          	csrr	s1,sstatus
    80003184:	100027f3          	csrr	a5,sstatus
    80003188:	ffd7f793          	andi	a5,a5,-3
    8000318c:	10079073          	csrw	sstatus,a5
    80003190:	ffffe097          	auipc	ra,0xffffe
    80003194:	714080e7          	jalr	1812(ra) # 800018a4 <mycpu>
    80003198:	07852783          	lw	a5,120(a0)
    8000319c:	02078663          	beqz	a5,800031c8 <push_off+0x5c>
    800031a0:	ffffe097          	auipc	ra,0xffffe
    800031a4:	704080e7          	jalr	1796(ra) # 800018a4 <mycpu>
    800031a8:	07852783          	lw	a5,120(a0)
    800031ac:	01813083          	ld	ra,24(sp)
    800031b0:	01013403          	ld	s0,16(sp)
    800031b4:	0017879b          	addiw	a5,a5,1
    800031b8:	06f52c23          	sw	a5,120(a0)
    800031bc:	00813483          	ld	s1,8(sp)
    800031c0:	02010113          	addi	sp,sp,32
    800031c4:	00008067          	ret
    800031c8:	0014d493          	srli	s1,s1,0x1
    800031cc:	ffffe097          	auipc	ra,0xffffe
    800031d0:	6d8080e7          	jalr	1752(ra) # 800018a4 <mycpu>
    800031d4:	0014f493          	andi	s1,s1,1
    800031d8:	06952e23          	sw	s1,124(a0)
    800031dc:	fc5ff06f          	j	800031a0 <push_off+0x34>

00000000800031e0 <pop_off>:
    800031e0:	ff010113          	addi	sp,sp,-16
    800031e4:	00813023          	sd	s0,0(sp)
    800031e8:	00113423          	sd	ra,8(sp)
    800031ec:	01010413          	addi	s0,sp,16
    800031f0:	ffffe097          	auipc	ra,0xffffe
    800031f4:	6b4080e7          	jalr	1716(ra) # 800018a4 <mycpu>
    800031f8:	100027f3          	csrr	a5,sstatus
    800031fc:	0027f793          	andi	a5,a5,2
    80003200:	04079663          	bnez	a5,8000324c <pop_off+0x6c>
    80003204:	07852783          	lw	a5,120(a0)
    80003208:	02f05a63          	blez	a5,8000323c <pop_off+0x5c>
    8000320c:	fff7871b          	addiw	a4,a5,-1
    80003210:	06e52c23          	sw	a4,120(a0)
    80003214:	00071c63          	bnez	a4,8000322c <pop_off+0x4c>
    80003218:	07c52783          	lw	a5,124(a0)
    8000321c:	00078863          	beqz	a5,8000322c <pop_off+0x4c>
    80003220:	100027f3          	csrr	a5,sstatus
    80003224:	0027e793          	ori	a5,a5,2
    80003228:	10079073          	csrw	sstatus,a5
    8000322c:	00813083          	ld	ra,8(sp)
    80003230:	00013403          	ld	s0,0(sp)
    80003234:	01010113          	addi	sp,sp,16
    80003238:	00008067          	ret
    8000323c:	00001517          	auipc	a0,0x1
    80003240:	f9c50513          	addi	a0,a0,-100 # 800041d8 <digits+0x48>
    80003244:	fffff097          	auipc	ra,0xfffff
    80003248:	018080e7          	jalr	24(ra) # 8000225c <panic>
    8000324c:	00001517          	auipc	a0,0x1
    80003250:	f7450513          	addi	a0,a0,-140 # 800041c0 <digits+0x30>
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	008080e7          	jalr	8(ra) # 8000225c <panic>

000000008000325c <push_on>:
    8000325c:	fe010113          	addi	sp,sp,-32
    80003260:	00813823          	sd	s0,16(sp)
    80003264:	00113c23          	sd	ra,24(sp)
    80003268:	00913423          	sd	s1,8(sp)
    8000326c:	02010413          	addi	s0,sp,32
    80003270:	100024f3          	csrr	s1,sstatus
    80003274:	100027f3          	csrr	a5,sstatus
    80003278:	0027e793          	ori	a5,a5,2
    8000327c:	10079073          	csrw	sstatus,a5
    80003280:	ffffe097          	auipc	ra,0xffffe
    80003284:	624080e7          	jalr	1572(ra) # 800018a4 <mycpu>
    80003288:	07852783          	lw	a5,120(a0)
    8000328c:	02078663          	beqz	a5,800032b8 <push_on+0x5c>
    80003290:	ffffe097          	auipc	ra,0xffffe
    80003294:	614080e7          	jalr	1556(ra) # 800018a4 <mycpu>
    80003298:	07852783          	lw	a5,120(a0)
    8000329c:	01813083          	ld	ra,24(sp)
    800032a0:	01013403          	ld	s0,16(sp)
    800032a4:	0017879b          	addiw	a5,a5,1
    800032a8:	06f52c23          	sw	a5,120(a0)
    800032ac:	00813483          	ld	s1,8(sp)
    800032b0:	02010113          	addi	sp,sp,32
    800032b4:	00008067          	ret
    800032b8:	0014d493          	srli	s1,s1,0x1
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	5e8080e7          	jalr	1512(ra) # 800018a4 <mycpu>
    800032c4:	0014f493          	andi	s1,s1,1
    800032c8:	06952e23          	sw	s1,124(a0)
    800032cc:	fc5ff06f          	j	80003290 <push_on+0x34>

00000000800032d0 <pop_on>:
    800032d0:	ff010113          	addi	sp,sp,-16
    800032d4:	00813023          	sd	s0,0(sp)
    800032d8:	00113423          	sd	ra,8(sp)
    800032dc:	01010413          	addi	s0,sp,16
    800032e0:	ffffe097          	auipc	ra,0xffffe
    800032e4:	5c4080e7          	jalr	1476(ra) # 800018a4 <mycpu>
    800032e8:	100027f3          	csrr	a5,sstatus
    800032ec:	0027f793          	andi	a5,a5,2
    800032f0:	04078463          	beqz	a5,80003338 <pop_on+0x68>
    800032f4:	07852783          	lw	a5,120(a0)
    800032f8:	02f05863          	blez	a5,80003328 <pop_on+0x58>
    800032fc:	fff7879b          	addiw	a5,a5,-1
    80003300:	06f52c23          	sw	a5,120(a0)
    80003304:	07853783          	ld	a5,120(a0)
    80003308:	00079863          	bnez	a5,80003318 <pop_on+0x48>
    8000330c:	100027f3          	csrr	a5,sstatus
    80003310:	ffd7f793          	andi	a5,a5,-3
    80003314:	10079073          	csrw	sstatus,a5
    80003318:	00813083          	ld	ra,8(sp)
    8000331c:	00013403          	ld	s0,0(sp)
    80003320:	01010113          	addi	sp,sp,16
    80003324:	00008067          	ret
    80003328:	00001517          	auipc	a0,0x1
    8000332c:	ed850513          	addi	a0,a0,-296 # 80004200 <digits+0x70>
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	f2c080e7          	jalr	-212(ra) # 8000225c <panic>
    80003338:	00001517          	auipc	a0,0x1
    8000333c:	ea850513          	addi	a0,a0,-344 # 800041e0 <digits+0x50>
    80003340:	fffff097          	auipc	ra,0xfffff
    80003344:	f1c080e7          	jalr	-228(ra) # 8000225c <panic>

0000000080003348 <__memset>:
    80003348:	ff010113          	addi	sp,sp,-16
    8000334c:	00813423          	sd	s0,8(sp)
    80003350:	01010413          	addi	s0,sp,16
    80003354:	1a060e63          	beqz	a2,80003510 <__memset+0x1c8>
    80003358:	40a007b3          	neg	a5,a0
    8000335c:	0077f793          	andi	a5,a5,7
    80003360:	00778693          	addi	a3,a5,7
    80003364:	00b00813          	li	a6,11
    80003368:	0ff5f593          	andi	a1,a1,255
    8000336c:	fff6071b          	addiw	a4,a2,-1
    80003370:	1b06e663          	bltu	a3,a6,8000351c <__memset+0x1d4>
    80003374:	1cd76463          	bltu	a4,a3,8000353c <__memset+0x1f4>
    80003378:	1a078e63          	beqz	a5,80003534 <__memset+0x1ec>
    8000337c:	00b50023          	sb	a1,0(a0)
    80003380:	00100713          	li	a4,1
    80003384:	1ae78463          	beq	a5,a4,8000352c <__memset+0x1e4>
    80003388:	00b500a3          	sb	a1,1(a0)
    8000338c:	00200713          	li	a4,2
    80003390:	1ae78a63          	beq	a5,a4,80003544 <__memset+0x1fc>
    80003394:	00b50123          	sb	a1,2(a0)
    80003398:	00300713          	li	a4,3
    8000339c:	18e78463          	beq	a5,a4,80003524 <__memset+0x1dc>
    800033a0:	00b501a3          	sb	a1,3(a0)
    800033a4:	00400713          	li	a4,4
    800033a8:	1ae78263          	beq	a5,a4,8000354c <__memset+0x204>
    800033ac:	00b50223          	sb	a1,4(a0)
    800033b0:	00500713          	li	a4,5
    800033b4:	1ae78063          	beq	a5,a4,80003554 <__memset+0x20c>
    800033b8:	00b502a3          	sb	a1,5(a0)
    800033bc:	00700713          	li	a4,7
    800033c0:	18e79e63          	bne	a5,a4,8000355c <__memset+0x214>
    800033c4:	00b50323          	sb	a1,6(a0)
    800033c8:	00700e93          	li	t4,7
    800033cc:	00859713          	slli	a4,a1,0x8
    800033d0:	00e5e733          	or	a4,a1,a4
    800033d4:	01059e13          	slli	t3,a1,0x10
    800033d8:	01c76e33          	or	t3,a4,t3
    800033dc:	01859313          	slli	t1,a1,0x18
    800033e0:	006e6333          	or	t1,t3,t1
    800033e4:	02059893          	slli	a7,a1,0x20
    800033e8:	40f60e3b          	subw	t3,a2,a5
    800033ec:	011368b3          	or	a7,t1,a7
    800033f0:	02859813          	slli	a6,a1,0x28
    800033f4:	0108e833          	or	a6,a7,a6
    800033f8:	03059693          	slli	a3,a1,0x30
    800033fc:	003e589b          	srliw	a7,t3,0x3
    80003400:	00d866b3          	or	a3,a6,a3
    80003404:	03859713          	slli	a4,a1,0x38
    80003408:	00389813          	slli	a6,a7,0x3
    8000340c:	00f507b3          	add	a5,a0,a5
    80003410:	00e6e733          	or	a4,a3,a4
    80003414:	000e089b          	sext.w	a7,t3
    80003418:	00f806b3          	add	a3,a6,a5
    8000341c:	00e7b023          	sd	a4,0(a5)
    80003420:	00878793          	addi	a5,a5,8
    80003424:	fed79ce3          	bne	a5,a3,8000341c <__memset+0xd4>
    80003428:	ff8e7793          	andi	a5,t3,-8
    8000342c:	0007871b          	sext.w	a4,a5
    80003430:	01d787bb          	addw	a5,a5,t4
    80003434:	0ce88e63          	beq	a7,a4,80003510 <__memset+0x1c8>
    80003438:	00f50733          	add	a4,a0,a5
    8000343c:	00b70023          	sb	a1,0(a4)
    80003440:	0017871b          	addiw	a4,a5,1
    80003444:	0cc77663          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    80003448:	00e50733          	add	a4,a0,a4
    8000344c:	00b70023          	sb	a1,0(a4)
    80003450:	0027871b          	addiw	a4,a5,2
    80003454:	0ac77e63          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    80003458:	00e50733          	add	a4,a0,a4
    8000345c:	00b70023          	sb	a1,0(a4)
    80003460:	0037871b          	addiw	a4,a5,3
    80003464:	0ac77663          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    80003468:	00e50733          	add	a4,a0,a4
    8000346c:	00b70023          	sb	a1,0(a4)
    80003470:	0047871b          	addiw	a4,a5,4
    80003474:	08c77e63          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    80003478:	00e50733          	add	a4,a0,a4
    8000347c:	00b70023          	sb	a1,0(a4)
    80003480:	0057871b          	addiw	a4,a5,5
    80003484:	08c77663          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    80003488:	00e50733          	add	a4,a0,a4
    8000348c:	00b70023          	sb	a1,0(a4)
    80003490:	0067871b          	addiw	a4,a5,6
    80003494:	06c77e63          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    80003498:	00e50733          	add	a4,a0,a4
    8000349c:	00b70023          	sb	a1,0(a4)
    800034a0:	0077871b          	addiw	a4,a5,7
    800034a4:	06c77663          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    800034a8:	00e50733          	add	a4,a0,a4
    800034ac:	00b70023          	sb	a1,0(a4)
    800034b0:	0087871b          	addiw	a4,a5,8
    800034b4:	04c77e63          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    800034b8:	00e50733          	add	a4,a0,a4
    800034bc:	00b70023          	sb	a1,0(a4)
    800034c0:	0097871b          	addiw	a4,a5,9
    800034c4:	04c77663          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    800034c8:	00e50733          	add	a4,a0,a4
    800034cc:	00b70023          	sb	a1,0(a4)
    800034d0:	00a7871b          	addiw	a4,a5,10
    800034d4:	02c77e63          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    800034d8:	00e50733          	add	a4,a0,a4
    800034dc:	00b70023          	sb	a1,0(a4)
    800034e0:	00b7871b          	addiw	a4,a5,11
    800034e4:	02c77663          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    800034e8:	00e50733          	add	a4,a0,a4
    800034ec:	00b70023          	sb	a1,0(a4)
    800034f0:	00c7871b          	addiw	a4,a5,12
    800034f4:	00c77e63          	bgeu	a4,a2,80003510 <__memset+0x1c8>
    800034f8:	00e50733          	add	a4,a0,a4
    800034fc:	00b70023          	sb	a1,0(a4)
    80003500:	00d7879b          	addiw	a5,a5,13
    80003504:	00c7f663          	bgeu	a5,a2,80003510 <__memset+0x1c8>
    80003508:	00f507b3          	add	a5,a0,a5
    8000350c:	00b78023          	sb	a1,0(a5)
    80003510:	00813403          	ld	s0,8(sp)
    80003514:	01010113          	addi	sp,sp,16
    80003518:	00008067          	ret
    8000351c:	00b00693          	li	a3,11
    80003520:	e55ff06f          	j	80003374 <__memset+0x2c>
    80003524:	00300e93          	li	t4,3
    80003528:	ea5ff06f          	j	800033cc <__memset+0x84>
    8000352c:	00100e93          	li	t4,1
    80003530:	e9dff06f          	j	800033cc <__memset+0x84>
    80003534:	00000e93          	li	t4,0
    80003538:	e95ff06f          	j	800033cc <__memset+0x84>
    8000353c:	00000793          	li	a5,0
    80003540:	ef9ff06f          	j	80003438 <__memset+0xf0>
    80003544:	00200e93          	li	t4,2
    80003548:	e85ff06f          	j	800033cc <__memset+0x84>
    8000354c:	00400e93          	li	t4,4
    80003550:	e7dff06f          	j	800033cc <__memset+0x84>
    80003554:	00500e93          	li	t4,5
    80003558:	e75ff06f          	j	800033cc <__memset+0x84>
    8000355c:	00600e93          	li	t4,6
    80003560:	e6dff06f          	j	800033cc <__memset+0x84>

0000000080003564 <__memmove>:
    80003564:	ff010113          	addi	sp,sp,-16
    80003568:	00813423          	sd	s0,8(sp)
    8000356c:	01010413          	addi	s0,sp,16
    80003570:	0e060863          	beqz	a2,80003660 <__memmove+0xfc>
    80003574:	fff6069b          	addiw	a3,a2,-1
    80003578:	0006881b          	sext.w	a6,a3
    8000357c:	0ea5e863          	bltu	a1,a0,8000366c <__memmove+0x108>
    80003580:	00758713          	addi	a4,a1,7
    80003584:	00a5e7b3          	or	a5,a1,a0
    80003588:	40a70733          	sub	a4,a4,a0
    8000358c:	0077f793          	andi	a5,a5,7
    80003590:	00f73713          	sltiu	a4,a4,15
    80003594:	00174713          	xori	a4,a4,1
    80003598:	0017b793          	seqz	a5,a5
    8000359c:	00e7f7b3          	and	a5,a5,a4
    800035a0:	10078863          	beqz	a5,800036b0 <__memmove+0x14c>
    800035a4:	00900793          	li	a5,9
    800035a8:	1107f463          	bgeu	a5,a6,800036b0 <__memmove+0x14c>
    800035ac:	0036581b          	srliw	a6,a2,0x3
    800035b0:	fff8081b          	addiw	a6,a6,-1
    800035b4:	02081813          	slli	a6,a6,0x20
    800035b8:	01d85893          	srli	a7,a6,0x1d
    800035bc:	00858813          	addi	a6,a1,8
    800035c0:	00058793          	mv	a5,a1
    800035c4:	00050713          	mv	a4,a0
    800035c8:	01088833          	add	a6,a7,a6
    800035cc:	0007b883          	ld	a7,0(a5)
    800035d0:	00878793          	addi	a5,a5,8
    800035d4:	00870713          	addi	a4,a4,8
    800035d8:	ff173c23          	sd	a7,-8(a4)
    800035dc:	ff0798e3          	bne	a5,a6,800035cc <__memmove+0x68>
    800035e0:	ff867713          	andi	a4,a2,-8
    800035e4:	02071793          	slli	a5,a4,0x20
    800035e8:	0207d793          	srli	a5,a5,0x20
    800035ec:	00f585b3          	add	a1,a1,a5
    800035f0:	40e686bb          	subw	a3,a3,a4
    800035f4:	00f507b3          	add	a5,a0,a5
    800035f8:	06e60463          	beq	a2,a4,80003660 <__memmove+0xfc>
    800035fc:	0005c703          	lbu	a4,0(a1)
    80003600:	00e78023          	sb	a4,0(a5)
    80003604:	04068e63          	beqz	a3,80003660 <__memmove+0xfc>
    80003608:	0015c603          	lbu	a2,1(a1)
    8000360c:	00100713          	li	a4,1
    80003610:	00c780a3          	sb	a2,1(a5)
    80003614:	04e68663          	beq	a3,a4,80003660 <__memmove+0xfc>
    80003618:	0025c603          	lbu	a2,2(a1)
    8000361c:	00200713          	li	a4,2
    80003620:	00c78123          	sb	a2,2(a5)
    80003624:	02e68e63          	beq	a3,a4,80003660 <__memmove+0xfc>
    80003628:	0035c603          	lbu	a2,3(a1)
    8000362c:	00300713          	li	a4,3
    80003630:	00c781a3          	sb	a2,3(a5)
    80003634:	02e68663          	beq	a3,a4,80003660 <__memmove+0xfc>
    80003638:	0045c603          	lbu	a2,4(a1)
    8000363c:	00400713          	li	a4,4
    80003640:	00c78223          	sb	a2,4(a5)
    80003644:	00e68e63          	beq	a3,a4,80003660 <__memmove+0xfc>
    80003648:	0055c603          	lbu	a2,5(a1)
    8000364c:	00500713          	li	a4,5
    80003650:	00c782a3          	sb	a2,5(a5)
    80003654:	00e68663          	beq	a3,a4,80003660 <__memmove+0xfc>
    80003658:	0065c703          	lbu	a4,6(a1)
    8000365c:	00e78323          	sb	a4,6(a5)
    80003660:	00813403          	ld	s0,8(sp)
    80003664:	01010113          	addi	sp,sp,16
    80003668:	00008067          	ret
    8000366c:	02061713          	slli	a4,a2,0x20
    80003670:	02075713          	srli	a4,a4,0x20
    80003674:	00e587b3          	add	a5,a1,a4
    80003678:	f0f574e3          	bgeu	a0,a5,80003580 <__memmove+0x1c>
    8000367c:	02069613          	slli	a2,a3,0x20
    80003680:	02065613          	srli	a2,a2,0x20
    80003684:	fff64613          	not	a2,a2
    80003688:	00e50733          	add	a4,a0,a4
    8000368c:	00c78633          	add	a2,a5,a2
    80003690:	fff7c683          	lbu	a3,-1(a5)
    80003694:	fff78793          	addi	a5,a5,-1
    80003698:	fff70713          	addi	a4,a4,-1
    8000369c:	00d70023          	sb	a3,0(a4)
    800036a0:	fec798e3          	bne	a5,a2,80003690 <__memmove+0x12c>
    800036a4:	00813403          	ld	s0,8(sp)
    800036a8:	01010113          	addi	sp,sp,16
    800036ac:	00008067          	ret
    800036b0:	02069713          	slli	a4,a3,0x20
    800036b4:	02075713          	srli	a4,a4,0x20
    800036b8:	00170713          	addi	a4,a4,1
    800036bc:	00e50733          	add	a4,a0,a4
    800036c0:	00050793          	mv	a5,a0
    800036c4:	0005c683          	lbu	a3,0(a1)
    800036c8:	00178793          	addi	a5,a5,1
    800036cc:	00158593          	addi	a1,a1,1
    800036d0:	fed78fa3          	sb	a3,-1(a5)
    800036d4:	fee798e3          	bne	a5,a4,800036c4 <__memmove+0x160>
    800036d8:	f89ff06f          	j	80003660 <__memmove+0xfc>

00000000800036dc <__putc>:
    800036dc:	fe010113          	addi	sp,sp,-32
    800036e0:	00813823          	sd	s0,16(sp)
    800036e4:	00113c23          	sd	ra,24(sp)
    800036e8:	02010413          	addi	s0,sp,32
    800036ec:	00050793          	mv	a5,a0
    800036f0:	fef40593          	addi	a1,s0,-17
    800036f4:	00100613          	li	a2,1
    800036f8:	00000513          	li	a0,0
    800036fc:	fef407a3          	sb	a5,-17(s0)
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	b3c080e7          	jalr	-1220(ra) # 8000223c <console_write>
    80003708:	01813083          	ld	ra,24(sp)
    8000370c:	01013403          	ld	s0,16(sp)
    80003710:	02010113          	addi	sp,sp,32
    80003714:	00008067          	ret

0000000080003718 <__getc>:
    80003718:	fe010113          	addi	sp,sp,-32
    8000371c:	00813823          	sd	s0,16(sp)
    80003720:	00113c23          	sd	ra,24(sp)
    80003724:	02010413          	addi	s0,sp,32
    80003728:	fe840593          	addi	a1,s0,-24
    8000372c:	00100613          	li	a2,1
    80003730:	00000513          	li	a0,0
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	ae8080e7          	jalr	-1304(ra) # 8000221c <console_read>
    8000373c:	fe844503          	lbu	a0,-24(s0)
    80003740:	01813083          	ld	ra,24(sp)
    80003744:	01013403          	ld	s0,16(sp)
    80003748:	02010113          	addi	sp,sp,32
    8000374c:	00008067          	ret

0000000080003750 <console_handler>:
    80003750:	fe010113          	addi	sp,sp,-32
    80003754:	00813823          	sd	s0,16(sp)
    80003758:	00113c23          	sd	ra,24(sp)
    8000375c:	00913423          	sd	s1,8(sp)
    80003760:	02010413          	addi	s0,sp,32
    80003764:	14202773          	csrr	a4,scause
    80003768:	100027f3          	csrr	a5,sstatus
    8000376c:	0027f793          	andi	a5,a5,2
    80003770:	06079e63          	bnez	a5,800037ec <console_handler+0x9c>
    80003774:	00074c63          	bltz	a4,8000378c <console_handler+0x3c>
    80003778:	01813083          	ld	ra,24(sp)
    8000377c:	01013403          	ld	s0,16(sp)
    80003780:	00813483          	ld	s1,8(sp)
    80003784:	02010113          	addi	sp,sp,32
    80003788:	00008067          	ret
    8000378c:	0ff77713          	andi	a4,a4,255
    80003790:	00900793          	li	a5,9
    80003794:	fef712e3          	bne	a4,a5,80003778 <console_handler+0x28>
    80003798:	ffffe097          	auipc	ra,0xffffe
    8000379c:	6dc080e7          	jalr	1756(ra) # 80001e74 <plic_claim>
    800037a0:	00a00793          	li	a5,10
    800037a4:	00050493          	mv	s1,a0
    800037a8:	02f50c63          	beq	a0,a5,800037e0 <console_handler+0x90>
    800037ac:	fc0506e3          	beqz	a0,80003778 <console_handler+0x28>
    800037b0:	00050593          	mv	a1,a0
    800037b4:	00001517          	auipc	a0,0x1
    800037b8:	95450513          	addi	a0,a0,-1708 # 80004108 <_ZZ12printIntegerE6digits+0xe8>
    800037bc:	fffff097          	auipc	ra,0xfffff
    800037c0:	afc080e7          	jalr	-1284(ra) # 800022b8 <__printf>
    800037c4:	01013403          	ld	s0,16(sp)
    800037c8:	01813083          	ld	ra,24(sp)
    800037cc:	00048513          	mv	a0,s1
    800037d0:	00813483          	ld	s1,8(sp)
    800037d4:	02010113          	addi	sp,sp,32
    800037d8:	ffffe317          	auipc	t1,0xffffe
    800037dc:	6d430067          	jr	1748(t1) # 80001eac <plic_complete>
    800037e0:	fffff097          	auipc	ra,0xfffff
    800037e4:	3e0080e7          	jalr	992(ra) # 80002bc0 <uartintr>
    800037e8:	fddff06f          	j	800037c4 <console_handler+0x74>
    800037ec:	00001517          	auipc	a0,0x1
    800037f0:	a1c50513          	addi	a0,a0,-1508 # 80004208 <digits+0x78>
    800037f4:	fffff097          	auipc	ra,0xfffff
    800037f8:	a68080e7          	jalr	-1432(ra) # 8000225c <panic>
	...
