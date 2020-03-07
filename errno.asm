;;
; Errno handling by hand, because muh libc
;;
%include "errno.inc"
extern puts

section .text

;;
; void perror(u8 *msg, u64 errno)
;;
global perror
perror:
push rsi
; print message
call puts
; print ': '
push 0x203a
mov rdi, rsp
call puts
pop rsi
pop rsi
; print errno
mov rax, UNKNOWN
cmp rsi, rax
cmovge rsi, rax
mov rdi, [err_strings + rsi * 8]
call puts
ret

section .rodata

; Error string table
err_strings:

dq msg_SUCCESS
dq msg_EPERM
dq msg_ENOENT
dq msg_ESRCH
dq msg_EINTR
dq msg_EIO
dq msg_ENXIO
dq msg_E2BIG
dq msg_ENOEXEC
dq msg_EBADF
dq msg_ECHILD
dq msg_EAGAIN
dq msg_ENOMEM
dq msg_EACCES
dq msg_EFAULT
dq msg_ENOTBLK
dq msg_EBUSY
dq msg_EEXIST
dq msg_EXDEV
dq msg_ENODEV
dq msg_ENOTDIR
dq msg_EISDIR
dq msg_EINVAL
dq msg_ENFILE
dq msg_EMFILE
dq msg_ENOTTY
dq msg_ETXTBSY
dq msg_EFBIG
dq msg_ENOSPC
dq msg_ESPIPE
dq msg_EROFS
dq msg_EMLINK
dq msg_EPIPE
dq msg_EDOM
dq msg_ERANGE
dq msg_UNKNOWN

; Success
msg_SUCCESS db 'Success',0xa,0

; Errors
msg_EPERM   db 'Operation not permitted',0xa,0
msg_ENOENT  db 'No such file or directory',0xa,0
msg_ESRCH   db 'No such process',0xa,0
msg_EINTR   db 'Interrupted system call',0xa,0
msg_EIO     db 'I/O error',0xa,0
msg_ENXIO   db 'No such device or address',0xa,0
msg_E2BIG   db 'Argument list too long',0xa,0
msg_ENOEXEC db 'Exec format error',0xa,0
msg_EBADF   db 'Bad file number',0xa,0
msg_ECHILD  db 'No child processes',0xa,0
msg_EAGAIN  db 'Try again',0xa,0
msg_ENOMEM  db 'Out of memory',0xa,0
msg_EACCES  db 'Permission denied',0xa,0
msg_EFAULT  db 'Bad address',0xa,0
msg_ENOTBLK db 'Block device required',0xa,0
msg_EBUSY   db 'Device or resource busy',0xa,0
msg_EEXIST  db 'File exists',0xa,0
msg_EXDEV   db 'Cross-device link',0xa,0
msg_ENODEV  db 'No such device',0xa,0
msg_ENOTDIR db 'Not a directory',0xa,0
msg_EISDIR  db 'Is a directory',0xa,0
msg_EINVAL  db 'Invalid argument',0xa,0
msg_ENFILE  db 'File table overflow',0xa,0
msg_EMFILE  db 'Too many open files',0xa,0
msg_ENOTTY  db 'Not a typewriter',0xa,0
msg_ETXTBSY db 'Text file busy',0xa,0
msg_EFBIG   db 'File too large',0xa,0
msg_ENOSPC  db 'No space left on device',0xa,0
msg_ESPIPE  db 'Illegal seek',0xa,0
msg_EROFS   db 'Read-only file system',0xa,0
msg_EMLINK  db 'Too many links',0xa,0
msg_EPIPE   db 'Broken pipe',0xa,0
msg_EDOM    db 'Math argument out of domain of func',0xa,0
msg_ERANGE  db 'Math result not representable',0xa,0

; Unknown errno
msg_UNKNOWN db 'Unknown errno',0xa,0
