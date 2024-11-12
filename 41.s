// Programa para convertir decimal a hexadecimal
.global _start
.section .text

_start:
    mov x19, #255        // Número decimal a convertir
    mov x20, #0          // Resultado hexadecimal
    mov x21, #0          // Contador de posición
    mov x22, #16         // Base hexadecimal
    mov x23, #0          // Registro temporal para dígitos
    
convert_loop:
    // Dividir el número actual entre 16
    udiv x24, x19, x22   // x24 = x19 / 16
    msub x25, x24, x22, x19  // x25 = x19 - (x24 * 16) [resto]
    
    // Convertir el resto a su representación hex
    cmp x25, #10
    blt numeric_digit
    
    // Dígito alfabético (A-F)
    add x25, x25, #55    // Convertir a ASCII (A=65, por lo que sumamos 55 a 10)
    b store_digit
    
numeric_digit:
    add x25, x25, #48    // Convertir a ASCII (0=48)
    
store_digit:
    // Almacenar dígito en resultado
    lsl x25, x25, x21    // Desplazar a posición correcta
    orr x20, x20, x25    // Combinar con resultado
    
    // Preparar siguiente iteración
    mov x19, x24         // Actualizar número con cociente
    add x21, x21, #8     // Incrementar posición (8 bits por byte)
    
    // Comprobar si quedan más dígitos
    cmp x19, #0
    bne convert_loop

    // El resultado hexadecimal está en x20

exit:
    mov x0, #0           // Código de salida
    mov x8, #93          // Syscall exit
    svc #0

.section .data
    // No se necesitan datos
