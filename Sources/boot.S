.section ".text.boot"

.global _start

//sends three out of four cores to halt, shutting them down
_start:
    mrc p15, #0, r1, c0, c0, #5
    and r1, r1, #3
    cmp r1, #0
    bne halt

//entry point for C stack
    mov sp, #0x8000

//loads address of the start and end of BSS section into register 4 and 9
    ldr r4, =_bss_start
    ldr r9, =_bss_end

//zeros out bss section and checks wether r4 is last than r9. if it is, executes 1
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    b       2f

1:
    stmia r4!, {r5-58}

2: 
    cmp r4, r9
    blo 1b

    ldr r3, =kernel_main
    blx r3

halt:
    wfe
    b halt
    
