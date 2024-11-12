// Codigo en C#
/*
using System;

class Program
{
    static void Main()
    {
        int[] array = { 2, 5, 7, 9, 12, 15, 20 }; // Ejemplo de arreglo de enteros, ordenado
        int length = array.Length;
        int target = 9; // Valor a buscar en el arreglo

        int index = BinarySearch(array, length, target);

        if (index != -1)
        {
            Console.WriteLine("Valor encontrado en el índice: " + index);
        }
        else
        {
            Console.WriteLine("Valor no encontrado en el arreglo.");
        }
    }

    static int BinarySearch(int[] arr, int len, int target)
    {
        int low = 0;
        int high = len - 1;

        while (low <= high)
        {
            int mid = (low + high) / 2;

            if (arr[mid] == target)
            {
                return mid; // Valor encontrado, retornar índice
            }
            else if (arr[mid] < target)
            {
                low = mid + 1; // Ajustar límite inferior
            }
            else
            {
                high = mid - 1; // Ajustar límite superior
            }
        }

        return -1; // Valor no encontrado, retornar -1
    }
}
*/

//ino imprime
.section .data
array:      .word 2, 5, 7, 9, 12, 15, 20       // Ejemplo de arreglo de enteros, ordenado
len:        .quad 7                            // Longitud del arreglo
target:     .word 9                            // Valor a buscar en el arreglo

.section .text
.global _start

_start:
    // Cargar la dirección del arreglo, su longitud y el valor objetivo
    ldr x0, =array                    // x0 apunta al inicio del arreglo
    ldr x1, =len                      // x1 guarda la longitud del arreglo
    ldr x1, [x1]                      // Obtener el valor de la longitud
    ldr w3, =target                   // w3 guarda el valor que estamos buscando
    ldr w3, [x3]                      // Obtener el valor del target

    // Inicializar los límites para la búsqueda binaria
    mov x4, #0                        // x4 es el límite inferior (índice 0)
    sub x5, x1, #1                    // x5 es el límite superior (longitud - 1)
    mov x6, -1                        // x6 será el índice del valor encontrado o -1 si no se encuentra

binary_search:
    // Comprobar si el límite inferior supera al límite superior
    cmp x4, x5                        // Comparar el límite inferior con el superior
    bgt end_search                    // Si x4 > x5, no se encuentra el valor

    // Calcular el índice medio
    add x7, x4, x5                    // x7 = límite inferior + límite superior
    lsr x7, x7, #1                    // x7 = (límite inferior + límite superior) / 2

    // Cargar el valor en el índice medio y compararlo con el valor buscado
    ldr w2, [x0, x7, lsl #2]          // Cargar el elemento en el índice medio
    cmp w2, w3                        // Comparar con el valor objetivo
    beq found                         // Si son iguales, ir a found

    // Ajustar los límites según el resultado de la comparación
    blt adjust_upper                  // Si w2 < w3, ajustar el límite inferior
    mov x5, x7                        // Si w2 > w3, ajustar el límite superior
    sub x5, x5, #1                    // Ajuste para excluir el índice medio
    b binary_search                   // Repetir el bucle

adjust_upper:
    mov x4, x7                        // Ajustar el límite inferior
    add x4, x4, #1                    // Ajuste para excluir el índice medio
    b binary_search                   // Repetir el bucle

found:
    mov x6, x7                        // Guardar el índice encontrado en x6

end_search:
    // Salir del programa
    mov x8, #93                       // syscall: exit
    mov x0, #0                        // Código de salida
    svc #0
