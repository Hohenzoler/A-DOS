org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

; jump instruction so that the os starts from main instead of something else
start:
    jmp main



; Print a string to the screen
; Parameters are ds:si that points to a string

puts:
    ; save registers

    push si
    push ax

.loop:
    lodsb   ; loads next char into al
    or al, al   ; checks if char is null
    jz .done    ; jz is a conditional jump if the zero flag is set
                ; which will be the case if al is null in the line before


    mov ah, 0x0e    ; call bios interrupt
    mov bh, 0
    int 0x10



    jmp .loop

.done:
    pop ax
    pop si
    ret


main:

    ; setup data segments
    mov ax, 0
    mov ds, ax    ; ax == 0 so both ds and es == 0
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00 ; move stack to the begining of the OS

    ; print string
    mov si, msg
    call puts

    hlt

.halt:
    jmp .halt


msg: db 'Welcome to A-DOS, an operating system designed to do nothing and it does it perfectly!', ENDL, 0



times 510-($-$$) db 0
dw 0AA55h