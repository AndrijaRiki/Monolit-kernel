.extern supervisorTrapHandler
.align 4
.global supervisorTrap
.type supervisorTrap, @function
supervisorTrap:
    # Alociramo prostor za 32 registra
    addi sp, sp, -256

    # Čuvamo x1 (ra)
    sd x1, 1 * 8(sp)

    # Čuvamo sve ostale osim x0 (nula) i x2 (sp)
    .irp index, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    sd x\index, \index * 8(sp)
    .endr

    # KLJUČNO OVO FALI: Šaljemo pokazivač na sačuvane registre kao prvi argument u C++
    mv a0, sp

    call supervisorTrapHandler

    # Vraćamo registre nazad
    ld x1, 1 * 8(sp)
    .irp index, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    ld x\index, \index * 8(sp)
    .endr

    addi sp, sp, 256
    sret