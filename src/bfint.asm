; SPDX-License-Identifier: ISC
; bfint.asm: brainfuck interpreter

; AMD64 ABI
;  Arguments (syscall): RDI, RSI, RDX, R10, R8, R9
;  Arguments:           RDI, RSI, RDX, RCX, R8, R9
;  Return:              RAX
;  Untouched registers: RBX, RBP, R12, R13, R14, R15

%include "lib.inc"
extern perror
extern puts

section .bss

BUFSIZE equ 4096        ; Output buffer size

align 16
outbuf: resb BUFSIZE    ; Output buffer
outidx: resd 1          ; Output index

section .data

section .text

%define TAPE_LENGTH 0xa000

; void putchar(u8 ch)
putchar:
    mov eax, [outidx]
    ; Append char
    mov byte [outbuf + eax], dil
    inc eax
    ; Check for newline
    cmp dil, 10 ; \n
    je .flush
    ; Check if buffer is full
    cmp eax, BUFSIZE
    jl .done
.flush:
    ; Flush buffer
    mov edi, 1
    mov rsi, outbuf
    mov edx, eax
    sys_write
    ; Reset counter
    xor eax, eax
    mov [outidx], eax
.done:
    ; Save size and return
    mov [outidx], eax
    ret

; i64 interpret(u8 *prog, u64 prog_len)
interpret:

; save callee saved registers
push rbx ; u8  ir
push r12
push r13 ; u8 *tape_ptr
push r14 ; u8 *prog_ptr
push r15 ; u8 *prog_endptr

mov rbp, rsp

; program
mov r14, rdi
lea r15, [rdi + rsi]

; mmap tape
mov rdi, 0                           ; addr
mov rsi, TAPE_LENGTH                 ; len
mov rdx, PROT_READ | PROT_WRITE      ; prot
mov r10, MAP_PRIVATE | MAP_ANONYMOUS ; flags
mov r8, -1                           ; fd
sys_mmap
test rax, rax
jl .end

; tape
mov r13, rax

; zero tape
lea rcx, [rax + TAPE_LENGTH]
.zero_loop:
mov qword [rax], 0
add rax, 8
cmp rax, rcx
jl .zero_loop

; execution loop
.loop_exec:
mov bl, [r14]

; print current instruction
; movzx rdi, bl
; call putchar
; mov edi, 10
; call putchar

;
; Instruction: >
;
.insn_0:
cmp bl, '>' ; move to right
jne .insn_1

inc r13
jmp .insn_end

;
; Instruction: <
;
.insn_1:
cmp bl, '<' ; move to left
jne .insn_2

dec r13
jmp .insn_end

;
; Instruction: +
;
.insn_2:
cmp bl, '+' ; increase cell
jne .insn_3

inc byte [r13]
jmp .insn_end

;
; Instruction: -
;
.insn_3:
cmp bl, '-' ; decrease cell
jne .insn_4

dec byte [r13]
jmp .insn_end

;
; Instruction: .
;
.insn_4:
cmp bl, '.' ; print cell
jne .insn_5

movzx rdi, byte [r13]
call putchar

jmp .insn_end

;
; Instruction: ,
;
.insn_5:
cmp bl, ',' ; read input
jne .insn_6

mov byte [r13], 0 ; FIXME: input is not always zero
jmp .insn_end

;
; Instruction: [
;
.insn_6:
cmp bl, '[' ; jump to ] if cell is zero
jne .insn_7
    ; Skip loop if data is zero
    cmp byte [r13], 0
    jz .skip

    ; Otherwise save jump target
    push r14
    jmp .insn_end

.skip:
    ; Setup nesting counter
    mov eax, 1
    .i6loop:
    inc r14
    mov bl, byte [r14]
    ; Increase nesting level on [
    cmp bl, '['
    jne .i6loop1
    inc eax
    .i6loop1:
    ; Decrease nesting level on [
    cmp bl, ']'
    jne .i6loop2
    dec eax
    .i6loop2:
    ; Loop if still nested
    test eax, eax
    jnz .i6loop

    jmp .insn_end

;
; Instruction: ]
;
.insn_7:
cmp bl, ']' ; jump to [ if cell is non-zero
jne .insn_end
    ; Check data
    cmp byte [r13], 0
    jnz .i7jump
    ; Remove target from stack
    add rsp, 8
    jmp .insn_end
    ; Perform jump if data is non-zero
.i7jump:
    mov r14, [rsp]

; End of instruction
.insn_end:

inc r14
cmp r14, r15
jl .loop_exec

; print newline to make sure buffer is flushed
mov edi, 10 ; \n
call putchar

; return 0
xor rax, rax
.end:

; restore callee-saved registers
mov rsp, rbp

pop r15
pop r14
pop r13
pop r12
pop rbx

ret

;;
; void _noreturn main()
;;
global _start
_start:

; check command line arguments
pop rcx
cmp rcx, 2
jge arg_ok
mov rdi, msg_usage
call puts
jmp die
arg_ok:

pop rbx
pop rbx ; filename

; open file
mov rdi, rbx ; filename
xor rsi, rsi
xor rdx, rdx
sys_open
test rax, rax
jl die_err
mov r13, rax ; fd

; get filesize
mov rdi, rax
mov rsi, 0
mov rdx, SEEK_END
sys_lseek
test rax, rax
jl die_err
mov r14, rax ; size

; mmap file
mov rdi, 0           ; addr
mov rsi, r14         ; len
mov rdx, PROT_READ   ; prot
mov r10, MAP_PRIVATE ; flags
mov r8, r13          ; fd
sys_mmap
test rax, rax
jl die_err
mov r15, rax ; program

; interpret
mov rdi, r15
mov rsi, r14
call interpret
test rax, rax
jl die_err

; exit(0)
mov rdi, 0
sys_exit

; perror + exit(1)
die_err:

; print errror
mov rdi, rbx ; filename
mov rsi, rax ; errno
not rsi
inc rsi
call perror

; exit
die:
mov rdi, 1
sys_exit

section .rodata

msg_usage db 'Usage: bfint PROGRAM',0xa,0
