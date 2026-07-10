.text
.global traps
.extern internalTrapHandler
.extern timerHandler
.balign 4
traps:
    j internal
    j timer
    .skip 28
    j external

.macro pushAll
    addi sp, sp, -256
    # x0 is hardwired zero — skip it
    # x2 is sp — must NOT be saved here; it is managed by the addi pair
    .irp index, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        sd x\index, \index * 8(sp)
    .endr
.endm

.macro popAll
    # x0 is hardwired zero — skip it
    # x2 is sp — must NOT be restored here; addi below restores it
    .irp index, 1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        ld x\index, \index * 8(sp)
    .endr
    addi sp, sp, 256
.endm

internal:
    pushAll
    addi fp, sp, 256
    mv a0, sp
    call internalTrapHandler
    popAll
    sret

timer:
    pushAll
    addi fp, sp, 256
    call timerHandler
    popAll
    sret

external:
    pushAll
    addi fp, sp, 256
    call externalHandler
    popAll
    sret