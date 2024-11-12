// Medidor de tiempo de ejecución
.global _start
.section .text

_start:
    // Obtener tiempo inicial
    mrs x19, CNTVCT_EL0          // Contador de tiempo inicial
    
    // Código a medir (ejemplo: loop simple)
    mov x22, #1000
time_loop:
    sub x22, x22, #1
    cbnz x22, time_loop
    
    // Obtener tiempo final
    mrs x20, CNTVCT_EL0          // Contador de tiempo final
    
    // Calcular diferencia
    sub x21, x20, x19            // x21 = tiempo transcurrido

exit:
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
