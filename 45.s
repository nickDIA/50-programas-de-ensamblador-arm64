// Verificador de números Armstrong
.global _start
.section .text

_start:
    mov x19, #153        // Número a verificar
    mov x20, x19         // Copia para procesamiento
    mov x21, #0          // Suma de cubos
    
digit_loop:
    // Obtener último dígito
    mov x22, #10
    udiv x23, x20, x22           // x23 = x20 / 10
    msub x24, x23, x22, x20      // x24 = x20 - (x23 * 10) [dígito]
    
    // Calcular cubo del dígito
    mul x25, x24, x24            // x25 = dígito * dígito
    mul x25, x25, x24            // x25 = x25 * dígito (cubo)
    
    // Sumar al total
    add x21, x21, x25
    
    // Preparar siguiente dígito
    mov x20, x23                 // x20 = x20 / 10
    
    // Continuar si quedan dígitos
    cbnz x20, digit_loop
    
    // Verificar si es número Armstrong
    cmp x19, x21
    beq is_armstrong
    
not_armstrong:
    mov x0, #1                   // No es Armstrong
    b exit
    
is_armstrong:
    mov x0, #0                   // Es Armstrong

exit:
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
