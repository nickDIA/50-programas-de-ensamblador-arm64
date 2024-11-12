// Programa para calcular el MCD usando el algoritmo de Euclides
// Registros usados:
// x0: primer número
// x1: segundo número
// x2: temporal para el resto

.global _start      // Punto de entrada del programa
.text

_start:
    // Ejemplo: calcular MCD de 48 y 36
    mov x0, #48     // Primer número en x0
    mov x1, #36     // Segundo número en x1

calcular_mcd:
    // Comprobar si el segundo número es 0
    cmp x1, #0
    beq fin         // Si es 0, el resultado está en x0

    // Calcular el resto de la división
    udiv x2, x0, x1 // x2 = x0 / x1
    mul x2, x2, x1  // x2 = x2 * x1
    sub x2, x0, x2  // x2 = x0 - x2 (resto)

    // Preparar para la siguiente iteración
    mov x0, x1      // x0 = x1
    mov x1, x2      // x1 = resto
    
    b calcular_mcd  // Volver al inicio del bucle

fin:
    // x0 contiene el MCD
    // Aquí puedes agregar código para mostrar el resultado
    mov x8, #93     // Syscall exit
    mov x0, #0      // Código de retorno 0
    svc #0          // Llamada al sistema
