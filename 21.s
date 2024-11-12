//Matriz transpuesta
//Matricez 2x2

.section .data
matrix:     .word 1, 2, 3, 4    // Matriz 2x2: A = [1, 2; 3, 4]
result:     .skip 16            // Espacio para la matriz transpuesta (2x2)

.section .text
.global _start

_start:
    // Cargar la dirección de la matriz original y la de la matriz resultado
    ldr x0, =matrix              // Dirección de la matriz original (A)
    ldr x1, =result              // Dirección de la matriz transpuesta (A^T)

    // Transponer la matriz 2x2:
    // A[0, 0] -> A^T[0, 0] (matrix[0] -> result[0])
    ldr w2, [x0]                 // Cargar a11 (matrix[0])
    str w2, [x1]                 // Guardar en result[0] (A^T[0, 0])

    // A[0, 1] -> A^T[1, 0] (matrix[1] -> result[2])
    ldr w2, [x0, #4]             // Cargar a12 (matrix[1])
    str w2, [x1, #8]             // Guardar en result[2] (A^T[1, 0])

    // A[1, 0] -> A^T[0, 1] (matrix[2] -> result[1])
    ldr w2, [x0, #8]             // Cargar a21 (matrix[2])
    str w2, [x1, #4]             // Guardar en result[1] (A^T[0, 1])

    // A[1, 1] -> A^T[1, 1] (matrix[3] -> result[3])
    ldr w2, [x0, #12]            // Cargar a22 (matrix[3])
    str w2, [x1, #12]            // Guardar en result[3] (A^T[1, 1])

    // Finalizar el programa
    mov x8, #93                  // syscall: exit
    mov x0, #0                   // Código de salida
    svc #0                        // Llamada al sistema para salir
