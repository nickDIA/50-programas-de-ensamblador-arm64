// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

//Versión en C# equivalente:
//using System;
//
//class Program
//{
//    static int[,] SumMatrices(int[,] matrix1, int[,] matrix2)
//    {
//        int rows = matrix1.GetLength(0);    // 3 en este caso
//        int cols = matrix1.GetLength(1);    // 3 en este caso
//        int[,] result = new int[rows, cols];
//
//        // Recorrer cada elemento de las matrices
//        for (int i = 0; i < rows; i++)
//        {
//            for (int j = 0; j < cols; j++)
//            {
//                // Sumar los elementos correspondientes
//                result[i,j] = matrix1[i,j] + matrix2[i,j];
//            }
//        }
//
//        return result;
//    }
//
//    static void Main(string[] args)
//    {
//        int[,] matrix1 = new int[,] {
//            {1, 2, 3},
//            {4, 5, 6},
//            {7, 8, 9}
//        };
//
//        int[,] matrix2 = new int[,] {
//            {9, 8, 7},
//            {6, 5, 4},
//            {3, 2, 1}
//        };
//
//        int[,] result = SumMatrices(matrix1, matrix2);
//        // Nota: El programa en Assembly no imprime la matriz resultante,
//        // solo la almacena en memoria
//    }
//}


//no imprime

.section .data
matrix1:    .word 1, 2, 3, 4, 5, 6, 7, 8, 9   // Primera matriz 3x3
matrix2:    .word 9, 8, 7, 6, 5, 4, 3, 2, 1   // Segunda matriz 3x3
result:     .skip 36                         // Espacio para la matriz resultado 3x3

.section .text
.global _start

_start:
    // Cargar las direcciones de las matrices
    ldr x0, =matrix1                 // Dirección de la primera matriz
    ldr x1, =matrix2                 // Dirección de la segunda matriz
    ldr x2, =result                  // Dirección de la matriz resultado

    // Definir las dimensiones de la matriz (en este caso 3x3)
    mov x3, #3                       // Número de filas
    mov x4, #3                       // Número de columnas
    mov x5, #0                       // Inicializar el índice de fila

loop_rows:
    cmp x5, x3                        // Comparar el índice de fila con el número de filas
    bge end                           // Si ya hemos procesado todas las filas, terminamos

    mov x6, #0                        // Inicializar el índice de columna

loop_columns:
    cmp x6, x4                        // Comparar el índice de columna con el número de columnas
    bge next_row                      // Si ya hemos procesado todas las columnas, pasamos a la siguiente fila

    // Calcular el índice de la matriz para la fila y columna actuales
    mul x7, x5, x4                     // x7 = fila * número de columnas
    add x7, x7, x6                     // x7 = índice de la posición en la matriz

    // Cargar el valor de la primera matriz
    ldr w8, [x0, x7, lsl #2]           // Cargar el valor de matrix1[fila][columna]
    
    // Cargar el valor de la segunda matriz
    ldr w9, [x1, x7, lsl #2]           // Cargar el valor de matrix2[fila][columna]

    // Sumar los valores de las dos matrices
    add w10, w8, w9                   // w10 = w8 + w9 (suma de los dos valores)

    // Guardar el resultado en la matriz resultado
    str w10, [x2, x7, lsl #2]         // Almacenar el resultado en result[fila][columna]

    add x6, x6, #1                    // Incrementar el índice de columna
    b loop_columns                    // Volver al ciclo de columnas

next_row:
    add x5, x5, #1                    // Incrementar el índice de fila
    b loop_rows                       // Volver al ciclo de filas

end:
    // Finalizar el programa
    mov x8, #93                       // syscall: exit
    mov x0, #0                        // Código de salida
    svc #0                             // Llamada a la syscall para salir del programa
