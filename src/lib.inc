; SPDX-License-Identifier: ISC
; lib.inc: Library routines

; Error numbers

%define SUCCESS 0  ; Success
%define EPERM   1  ; Operation not permitted
%define ENOENT  2  ; No such file or directory
%define ESRCH   3  ; No such process
%define EINTR   4  ; Interrupted system call
%define EIO     5  ; I/O error
%define ENXIO   6  ; No such device or address
%define E2BIG   7  ; Argument list too long
%define ENOEXEC 8  ; Exec format error
%define EBADF   9  ; Bad file number
%define ECHILD  10 ; No child processes
%define EAGAIN  11 ; Try again
%define ENOMEM  12 ; Out of memory
%define EACCES  13 ; Permission denied
%define EFAULT  14 ; Bad address
%define ENOTBLK 15 ; Block device required
%define EBUSY   16 ; Device or resource busy
%define EEXIST  17 ; File exists
%define EXDEV   18 ; Cross-device link
%define ENODEV  19 ; No such device
%define ENOTDIR 20 ; Not a directory
%define EISDIR  21 ; Is a directory
%define EINVAL  22 ; Invalid argument
%define ENFILE  23 ; File table overflow
%define EMFILE  24 ; Too many open files
%define ENOTTY  25 ; Not a typewriter
%define ETXTBSY 26 ; Text file busy
%define EFBIG   27 ; File too large
%define ENOSPC  28 ; No space left on device
%define ESPIPE  29 ; Illegal seek
%define EROFS   30 ; Read-only file system
%define EMLINK  31 ; Too many links
%define EPIPE   32 ; Broken pipe
%define EDOM    33 ; Math argument out of domain of func
%define ERANGE  34 ; Math result not representable
%define UNKNOWN ERANGE + 1

; System calls

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
