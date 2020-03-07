;;
; Linux syscalls
;;

%macro sys_read 0
xor rax, rax
syscall
%endmacro

%macro sys_write 0
mov rax, 1
syscall
%endmacro

; open flags
%define O_RDONLY 0
%define O_WRONLY 1
%define O_RDWR   2

%macro sys_open 0
mov rax, 2
syscall
%endmacro

%macro sys_close 0
mov rax, 3
syscall
%endmacro

; seek whence
%define SEEK_SET 0
%define SEEK_CUR 1
%define SEEK_END 2

%macro sys_lseek 0
mov rax, 8
syscall
%endmacro

; mmap prot
%define PROT_NONE  0
%define PROT_READ  1
%define PROT_WRITE 2
%define PROT_EXEC  4

; mmap flags
%define MAP_PRIVATE   2
%define MAP_ANONYMOUS 0x20

%macro sys_mmap 0
mov rax, 9
syscall
%endmacro

%macro sys_exit 0
mov rax, 60
syscall
%endmacro
