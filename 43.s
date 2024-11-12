// Calculadora simple (suma, resta, multiplicación, división)
.global _start
.section .text

_start:
    // Valores de ejemplo
    mov x19, #25         // Primer número
    mov x20, #5          // Segundo número
    
    // Suma
    add x21, x19, x20    // x21 = x19 + x20
    
    // Resta
    sub x22, x19, x20    // x22 = x19 - x20
    
    // Multiplicación
    mul x23, x19, x20    // x23 = x19 * x20
    
    // División
    udiv x24, x19, x20   // x24 = x19 / x20
    
    // Obtener resto de división
    msub x25, x24, x20, x19  // x25 = x19 - (x24 * x20)

    // Manejo de división por cero
    cbz x20, division_error
    
    b exit

division_error:
    mov x24, #-1         // Indicador de error
    mov x25, #-1

exit:
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
