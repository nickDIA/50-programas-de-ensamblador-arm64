.global _start

.section .data
value: .quad 0x12345678         // Definir el valor 0x12345678 en memoria

.section .text
_start:

    // Cargar un valor desde la memoria en el registro x0
    ldr x0, =value              // Cargar la dirección de "value"
    ldr x0, [x0]                // Cargar el valor de la dirección de "value" en x0

    // Desplazamiento a la izquierda (LSL) - Desplazar 4 bits a la izquierda
    lsl x1, x0, #4              // x1 = x0 << 4  (0x12345678 << 4)

    // Desplazamiento a la derecha (LSR) - Desplazar 8 bits a la derecha
    lsr x2, x0, #8              // x2 = x0 >> 8  (0x12345678 >> 8)

    // Finalizar el programa
    mov x8, 93                  // Syscall para salir
    mov x0, 0                   // Código de salida
    svc 0                        // Llamar al sistema (exit)
