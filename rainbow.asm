
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; code revision 1
;; 2023.11.12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; set the processor type target for the assembly file
    processor 6502

    include "vcs.h"
    include "macro.h"

    ; start a segment of code here
    seg code

    ; set the memory address location where the code will begin
    ; start of cartridge ROM
    org $F000

StartCartridge:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic housekeeping required at the beginning of program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; disable interrupts
    sei

    ; disable the BCD (binary coded decimal) math mode
    cld

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; initialise the SP (stack pointer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldx #$00

    txa

    tay

StackLoop:

    dex

    ; transfer the value of the x register to the stack pointer register
    txs

    pha

    bne StackLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; program starts here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProgramStart:

    lda #$02

    sta VSYNC

    sta VBLANK

    ldx #$03

WsyncLoop1:

    sta WSYNC

    dex

    bne WsyncLoop1

    lda #$00

    sta VSYNC

    ldx #$25

WsyncLoop2:

    sta WSYNC

    dex

    bne WsyncLoop2

    lda #$00

    sta VBLANK

    ldx #$c0

Colubk:

    stx COLUBK

    sta WSYNC

    dex
    
    bne Colubk

    lda #$02

    sta VBLANK

    ldx #$1e

WsyncLoop3:

    sta WSYNC

    dex

    bne WsyncLoop3

    lda #$00

    sta VBLANK

    jmp ProgramStart
                                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; program ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EndCartridge:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic housekeeping required at the end of program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; set the memory address location for end of program housekeeping
    ; end of cartridge ROM
    org $FFFC

    ; reset vector
    ; add two bytes for the reset vector: $FFFC and $FFFD
    ; start address of program
    .word StartCartridge  
                            
    ; interrupt vector
    ; add another two bytes for the interrupt vector: $FFFE and $FFFF
    ; unused by the 2600
    .word StartCartridge    
                              