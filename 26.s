.global _start

.section .data
value1: .quad 0xF0F0F0F0F0F0F0F0  // Primer valor: 0xF0F0F0F0F0F0F0F0
value2: .quad 0x0F0F0F0F0F0F0F0F  // Segundo valor: 0x0F0F0F0F0F0F0F0F

.section .text
_start:

    // Cargar los dos valores de la memoria en los registros x0 y x1
    ldr x0, =value1             // Cargar la dirección de value1
    ldr x0, [x0]                // Cargar el valor en x0
    ldr x1, =value2             // Cargar la dirección de value2
    ldr x1, [x1]                // Cargar el valor en x1

    // Operación AND
    and x2, x0, x1              // x2 = x0 AND x1

    // Operación OR
    orr x3, x0, x1              // x3 = x0 OR x1

    // Operación XOR
    eor x4, x0, x1              // x4 = x0 XOR x1

    // Salir del programa
    mov x8, 93                  // Syscall para salir
    mov x0, 0                   // Código de salida
    svc 0                        // Llamada al sistema (exit)
