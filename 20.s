// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

//using System;

// class MultiplicacionMatrices
// {
//     public static int[,] MultiplicarMatrices(int[,] matrizA, int[,] matrizB)
//     {
//         // Obtener dimensiones de las matrices
//         int filasA = matrizA.GetLength(0);
//         int columnasA = matrizA.GetLength(1);
//         int columnasB = matrizB.GetLength(1);

//         // Validar que las matrices se puedan multiplicar
//         if (columnasA != matrizB.GetLength(0))
//         {
//             throw new ArgumentException("Las dimensiones de las matrices no son compatibles para multiplicación");
//         }

//         // Crear matriz resultado
//         int[,] resultado = new int[filasA, columnasB];

//         // Realizar multiplicación
//         for (int i = 0; i < filasA; i++)
//         {
//             for (int j = 0; j < columnasB; j++)
//             {
//                 resultado[i, j] = 0;
//                 for (int k = 0; k < columnasA; k++)
//                 {
//                     resultado[i, j] += matrizA[i, k] * matrizB[k, j];
//                 }
//             }
//         }

//         return resultado;
//     }

//     // Versión paralela para matrices grandes
//     public static int[,] MultiplicarMatricesParalelo(int[,] matrizA, int[,] matrizB)
//     {
//         int filasA = matrizA.GetLength(0);
//         int columnasA = matrizA.GetLength(1);
//         int columnasB = matrizB.GetLength(1);

//         if (columnasA != matrizB.GetLength(0))
//         {
//             throw new ArgumentException("Las dimensiones de las matrices no son compatibles para multiplicación");
//         }

//         int[,] resultado = new int[filasA, columnasB];

//         // Usar paralelismo para matrices grandes
//         System.Threading.Tasks.Parallel.For(0, filasA, i =>
//         {
//             for (int j = 0; j < columnasB; j++)
//             {
//                 resultado[i, j] = 0;
//                 for (int k = 0; k < columnasA; k++)
//                 {
//                     resultado[i, j] += matrizA[i, k] * matrizB[k, j];
//                 }
//             }
//         });

//         return resultado;
//     }

//     // Método para imprimir matriz
//     public static void ImprimirMatriz(int[,] matriz)
//     {
//         int filas = matriz.GetLength(0);
//         int columnas = matriz.GetLength(1);

//         for (int i = 0; i < filas; i++)
//         {
//             for (int j = 0; j < columnas; j++)
//             {
//                 Console.Write($"{matriz[i, j],4} ");
//             }
//             Console.WriteLine();
//         }
//         Console.WriteLine();
//     }

//     static void Main()
//     {
//         // Ejemplo de uso
//         int[,] matrizA = new int[,]
//         {
//             {1, 2, 3},
//             {4, 5, 6}
//         };

//         int[,] matrizB = new int[,]
//         {
//             {7, 8},
//             {9, 10},
//             {11, 12}
//         };

//         Console.WriteLine("Matriz A:");
//         ImprimirMatriz(matrizA);

//         Console.WriteLine("Matriz B:");
//         ImprimirMatriz(matrizB);

//         Console.WriteLine("Resultado de la multiplicación (método secuencial):");
//         int[,] resultado = MultiplicarMatrices(matrizA, matrizB);
//         ImprimirMatriz(resultado);

//         Console.WriteLine("Resultado de la multiplicación (método paralelo):");
//         int[,] resultadoParalelo = MultiplicarMatricesParalelo(matrizA, matrizB);
//         ImprimirMatriz(resultadoParalelo);

//         // Ejemplo con matrices más grandes para demostrar la diferencia de rendimiento
//         Console.WriteLine("Probando rendimiento con matrices grandes...");
//         int tamano = 500;
//         int[,] matrizGrandeA = new int[tamano, tamano];
//         int[,] matrizGrandeB = new int[tamano, tamano];

//         // Inicializar matrices grandes con valores aleatorios
//         Random rand = new Random();
//         for (int i = 0; i < tamano; i++)
//         {
//             for (int j = 0; j < tamano; j++)
//             {
//                 matrizGrandeA[i, j] = rand.Next(1, 10);
//                 matrizGrandeB[i, j] = rand.Next(1, 10);
//             }
//         }

//         // Medir tiempo de ejecución para método secuencial
//         var watch = System.Diagnostics.Stopwatch.StartNew();
//         MultiplicarMatrices(matrizGrandeA, matrizGrandeB);
//         watch.Stop();
//         Console.WriteLine($"Tiempo de ejecución secuencial: {watch.ElapsedMilliseconds} ms");

//         // Medir tiempo de ejecución para método paralelo
//         watch = System.Diagnostics.Stopwatch.StartNew();
//         MultiplicarMatricesParalelo(matrizGrandeA, matrizGrandeB);
//         watch.Stop();
//         Console.WriteLine($"Tiempo de ejecución paralelo: {watch.ElapsedMilliseconds} ms");
//     }
// }

//Matrices 2x2
//no imprimie

.section .data
matrix1:    .word 1, 2, 3, 4   // Primera matriz 2x2
matrix2:    .word 5, 6, 7, 8   // Segunda matriz 2x2
result:     .skip 16           // Espacio para la matriz resultado 2x2

.section .text
.global _start

_start:
    // Cargar las direcciones de las matrices
    ldr x0, =matrix1                 // Dirección de la primera matriz
    ldr x1, =matrix2                 // Dirección de la segunda matriz
    ldr x2, =result                  // Dirección de la matriz resultado

    // Realizar la multiplicación de matrices 2x2
    // c11 = a11 * b11 + a12 * b21
    ldr w3, [x0]                     // Cargar a11 (matrix1[0])
    ldr w4, [x1]                     // Cargar b11 (matrix2[0])
    mul w5, w3, w4                   // w5 = a11 * b11

    ldr w3, [x0, #4]                 // Cargar a12 (matrix1[1])
    ldr w4, [x1, #8]                 // Cargar b21 (matrix2[2])
    mul w6, w3, w4                   // w6 = a12 * b21

    add w7, w5, w6                   // c11 = a11 * b11 + a12 * b21
    str w7, [x2]                     // Almacenar c11 en result[0]

    // c12 = a11 * b12 + a12 * b22
    ldr w3, [x0]                     // Cargar a11 (matrix1[0])
    ldr w4, [x1, #4]                 // Cargar b12 (matrix2[1])
    mul w5, w3, w4                   // w5 = a11 * b12

    ldr w3, [x0, #4]                 // Cargar a12 (matrix1[1])
    ldr w4, [x1, #12]                // Cargar b22 (matrix2[3])
    mul w6, w3, w4                   // w6 = a12 * b22

    add w7, w5, w6                   // c12 = a11 * b12 + a12 * b22
    str w7, [x2, #4]                 // Almacenar c12 en result[1]

    // c21 = a21 * b11 + a22 * b21
    ldr w3, [x0, #8]                 // Cargar a21 (matrix1[2])
    ldr w4, [x1]                     // Cargar b11 (matrix2[0])
    mul w5, w3, w4                   // w5 = a21 * b11

    ldr w3, [x0, #12]                // Cargar a22 (matrix1[3])
    ldr w4, [x1, #8]                 // Cargar b21 (matrix2[2])
    mul w6, w3, w4                   // w6 = a22 * b21

    add w7, w5, w6                   // c21 = a21 * b11 + a22 * b21
    str w7, [x2, #8]                 // Almacenar c21 en result[2]

    // c22 = a21 * b12 + a22 * b22
    ldr w3, [x0, #8]                 // Cargar a21 (matrix1[2])
    ldr w4, [x1, #4]                 // Cargar b12 (matrix2[1])
    mul w5, w3, w4                   // w5 = a21 * b12

    ldr w3, [x0, #12]                // Cargar a22 (matrix1[3])
    ldr w4, [x1, #12]                // Cargar b22 (matrix2[3])
    mul w6, w3, w4                   // w6 = a22 * b22

    add w7, w5, w6                   // c22 = a21 * b12 + a22 * b22
    str w7, [x2, #12]                // Almacenar c22 en result[3]

    // Finalizar el programa
    mov x8, #93                      // syscall: exit
    mov x0, #0                       // Código de salida
    svc #0                            // Llamada a la syscall para salir del programa
