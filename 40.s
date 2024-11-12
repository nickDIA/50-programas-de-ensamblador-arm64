// Programa para convertir número binario a decimal
.global _start
.section .text

_start:
    // Inicializamos registros
    mov x19, #0          // x19 = Resultado decimal
    mov x20, #0b1101     // x20 = Número binario a convertir (ejemplo: 1101 = 13)
    mov x21, #0          // x21 = Contador de posición
    mov x22, #2          // x22 = Base (binario = 2)

convert_loop:
    // Obtener el bit menos significativo
    and x23, x20, #1     // x23 = último bit del número
    
    // Calcular el valor posicional (2^posición * bit)
    mov x24, #1          // x24 = 2^posición
    mov x25, x21         // x25 = contador temporal para potencia
power_loop:
    cbz x25, power_done  // Si contador es 0, salir del loop
    mul x24, x24, x22    // x24 = x24 * 2
    sub x25, x25, #1     // Decrementar contador
    b power_loop
power_done:
    
    // Multiplicar bit por su valor posicional
    mul x23, x23, x24    // x23 = bit * 2^posición
    
    // Sumar al resultado
    add x19, x19, x23    // Resultado += valor calculado
    
    // Preparar siguiente iteración
    lsr x20, x20, #1     // Desplazar número a la derecha
    add x21, x21, #1     // Incrementar posición
    
    // Comprobar si quedan bits
    cmp x20, #0          // ¿Quedan bits por procesar?
    bne convert_loop     // Si quedan bits, continuar loop

    // En este punto, x19 contiene el resultado decimal

exit:
    // Salir del programa
    mov x0, #0           // Código de salida 0
    mov x8, #93          // Syscall exit
    svc #0

.section .data
    // No se necesitan datos en este ejemplo
