.equ FRAME_SIZE, 256

.extern internalTrapHandler
.align 4
.global internalTrap
.type internalTrap, @function
internalTrap:
    addi sp, sp, -FRAME_SIZE

    sd x1,  1 * 8(sp)

    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        sd x\index, \index * 8(sp)
    .endr

    mv a0, sp
    call internalTrapHandler

    ld x1,  1 * 8(sp)

    .irp index, 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        ld x\index, \index * 8(sp)
    .endr

    addi sp, sp, FRAME_SIZE
    sret