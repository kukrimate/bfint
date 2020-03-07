;;
; String functions
;;
%include "syscall.inc"

section .text

;;
; u64 strlen(u8 *str)
;;
extern strlen
strlen:
xor rax, rax
nextloop:
cmp byte [rdi], 0
jz endloop
inc rdi
inc rax
jmp nextloop
endloop:
ret

;;
; void puts(u8 *str)
;;
extern puts
puts:
push rdi
call strlen
mov rdi, 1
pop rsi
mov rdx, rax
sys_write
ret
