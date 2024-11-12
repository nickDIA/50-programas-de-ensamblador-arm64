// Escritor de archivo
.global _start
.section .text

_start:
    // Abrir archivo
    mov x0, #-100              // AT_FDCWD
    adr x1, filename           // Nombre del archivo
    mov x2, #0x241            // O_WRONLY | O_CREAT | O_TRUNC
    mov x3, #0644             // Permisos
    mov x8, #56               // syscall openat
    svc #0
    
    // Guardar file descriptor
    mov x19, x0
    
    // Escribir datos
    mov x0, x19               // File descriptor
    adr x1, data             // Buffer de datos
    mov x2, #12              // Longitud de datos
    mov x8, #64              // syscall write
    svc #0
    
    // Cerrar archivo
    mov x0, x19              // File descriptor
    mov x8, #57              // syscall close
    svc #0

exit:
    mov x0, #0
    mov x8, #93              // syscall exit
    svc #0

.section .data
filename:
    .asciz "output.txt"
data:
    .asciz "Hello World!\n"
