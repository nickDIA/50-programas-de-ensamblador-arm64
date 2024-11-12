//Versión en C# equivalente:
//using System;
//
//class Program
//{
//    static int FindMax(int[] array)
//    {
//        // Inicializar con el primer elemento como máximo
//        int max = array[0];
//        
//        // Recorrer el resto del arreglo
//        for (int i = 1; i < array.Length; i++)
//        {
//            // Actualizar max si encontramos un valor mayor
//            if (array[i] > max)
//            {
//                max = array[i];
//            }
//        }
//        
//        return max;
//    }
//
//    static void Main(string[] args)
//    {
//        int[] array = { 3, 9, 5, 12, 7, 15, 2 };
//        int max = FindMax(array);
//        // Nota: El programa en Assembly no imprime el valor,
//        // solo lo almacena en x5
//    }
//}

//no imprime el valor

.section .data
array:      .word 3, 9, 5, 12, 7, 15, 2     // Ejemplo de arreglo de enteros
len:        .quad 7                         // Longitud del arreglo

.section .text
.global _start

_start:
    // Cargar la dirección del arreglo y su longitud
    ldr x0, =array                   // x0 apunta al inicio del arreglo
    ldr x1, =len                     // x1 guarda la longitud del arreglo
    ldr x1, [x1]                     // Obtener el valor de la longitud

    // Cargar el primer valor del arreglo como el valor máximo inicial
    ldr w2, [x0]                     // w2 guarda el valor máximo encontrado
    add x3, x0, #4                   // x3 es el índice del siguiente elemento

find_max:
    // Comprobar si hemos alcanzado el final del arreglo
    subs x1, x1, #1                  // Reducir longitud en 1
    beq store_max                    // Si x1 es cero, hemos terminado

    // Cargar el siguiente elemento y compararlo con el valor máximo actual
    ldr w4, [x3], #4                 // Cargar siguiente valor y avanzar puntero
    cmp w4, w2                       // Comparar con el valor máximo actual
    csel w2, w4, w2, gt              // Si w4 es mayor, actualizar w2

    b find_max                       // Repetir el bucle

store_max:
    mov x5, x2                       // Guardar el valor máximo encontrado en x5

exit_program:
    mov x8, #93                      // syscall: exit
    mov x0, #0                       // Código de salida
    svc #0
