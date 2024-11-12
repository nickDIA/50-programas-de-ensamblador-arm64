// Detector de desbordamiento en suma
.global _start
.section .text

_start:
    mov x19, #0x7FFFFFFFFFFFFFFF  // Máximo valor positivo
    mov x20, #1                   // Valor a sumar
    
    // Intentar suma y verificar desbordamiento
    adds x21, x19, x20            // Suma con actualización de flags
    bvs overflow_detected         // Saltar si hay desbordamiento
    
    // No hay desbordamiento
    mov x0, #0
    b exit
    
overflow_detected:
    mov x0, #1                    // Indicar desbordamiento

exit:
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
