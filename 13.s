//Versión en C# equivalente:
//using System;
//
//class Program
//{
//    static int FindMin(int[] array)
//    {
//        // Inicializar con el primer elemento como mínimo
//        int min = array[0];
//        
//        // Recorrer el resto del arreglo
//        for (int i = 1; i < array.Length; i++)
//        {
//            // Actualizar min si encontramos un valor menor
//            if (array[i] < min)
//            {
//                min = array[i];
//            }
//        }
//        
//        return min;
//    }
//
//    static void Main(string[] args)
//    {
//        int[] array = { 3, 9, 5, 12, 7, 15, 2 };
//        int min = FindMin(array);
//        // Nota: El programa en Assembly no imprime el valor,
//        // solo lo almacena en x5
//    }
//}

//no imprime

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

    // Cargar el primer valor del arreglo como el valor mínimo inicial
    ldr w2, [x0]                     // w2 guarda el valor mínimo encontrado
    add x3, x0, #4                   // x3 es el índice del siguiente elemento

find_min:
    // Comprobar si hemos alcanzado el final del arreglo
    subs x1, x1, #1                  // Reducir longitud en 1
    beq store_min                    // Si x1 es cero, hemos terminado

    // Cargar el siguiente elemento y compararlo con el valor mínimo actual
    ldr w4, [x3], #4                 // Cargar siguiente valor y avanzar puntero
    cmp w4, w2                       // Comparar con el valor mínimo actual
    csel w2, w4, w2, lt              // Si w4 es menor, actualizar w2

    b find_min                       // Repetir el bucle

store_min:
    mov x5, x2                       // Guardar el valor mínimo encontrado en x5

exit_program:
    mov x8, #93                      // syscall: exit
    mov x0, #0                       // Código de salida
    svc #0
