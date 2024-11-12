// Programa para convertir hexadecimal a decimal
.global _start
.section .text

_start:
    mov x19, #0xAB       // Número hexadecimal a convertir
    mov x20, #0          // Resultado decimal
    mov x21, #1          // Multiplicador (potencia de 16)
    mov x22, #16         // Base hexadecimal
    
convert_loop:
    // Obtener último dígito hexadecimal
    and x23, x19, #0xF   // Máscara para último dígito
    
    // Multiplicar dígito por potencia de 16
    mul x24, x23, x21    // x24 = dígito * 16^posición
    add x20, x20, x24    // Sumar al resultado
    
    // Preparar siguiente iteración
    lsr x19, x19, #4     // Desplazar para siguiente dígito
    mul x21, x21, x22    // Actualizar multiplicador (*16)
    
    // Comprobar si quedan dígitos
    cmp x19, #0
    bne convert_loop

exit:
    mov x0, #0           // Código de salida
    mov x8, #93          // Syscall exit
    svc #0

.section .data
    // No se necesitan datos
