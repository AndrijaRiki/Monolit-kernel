# supervisorTrap: common entry point for all S-mode traps (installed into
# stvec by Riscv::initTraps).
#
# We carve out a frame on the stack and save every general-purpose register
# except x0 (always zero, never needs saving) and x2/sp (it's the stack
# pointer we're using to build this very frame, so it's restored implicitly
# once we pop the frame at the end).
#
# supervisorTrapHandler (traps.cpp) receives a pointer to this frame as its
# "regs" argument, so regs[N] there corresponds exactly to the value of
# register xN at the moment the trap fired.

.equ FRAME_SIZE, 256          # 32 registers * 8 bytes per register

.extern supervisorTrapHandler
.align 4
.global supervisorTrap
.type supervisorTrap, @function
supervisorTrap:
    addi sp, sp, -FRAME_SIZE

    sd x1, 1 * 8(sp)          # ra

    # All other registers except x0 (zero) and x2 (sp, handled above).
    .irp index, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
        sd x\index, \index * 8(sp)
    .endr

    # Pass a pointer to the saved-register frame as the first (and only)
    # argument to the C++ handler.
    mv a0, sp
    call supervisorTrapHandler

    ld x1, 1 * 8(sp)

    .irp index, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
        ld x\index, \index * 8(sp)
    .endr

    addi sp, sp, FRAME_SIZE
    sret