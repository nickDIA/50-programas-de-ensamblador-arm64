// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

//Versión en C# del ordenamiento burbuja:
//using System;
//
//class Program
//{
//    static void BubbleSort(int[] arr)
//    {
//        int n = arr.Length;
//        bool swapped;
//        
//        for (int i = 0; i < n - 1; i++)
//        {
//            swapped = false;
//            
//            for (int j = 0; j < n - i - 1; j++)
//            {
//                // Comparar elementos adyacentes
//                if (arr[j] > arr[j + 1])
//                {
//                    // Intercambiar si están en orden incorrecto
//                    int temp = arr[j];
//                    arr[j] = arr[j + 1];
//                    arr[j + 1] = temp;
//                    swapped = true;
//                }
//            }
//            
//            // Si no hubo intercambios en esta pasada,
//            // el array ya está ordenado
//            if (!swapped)
//                break;
//        }
//    }
//
//    static void Main(string[] args)
//    {
//        int[] array = { 64, 34, 25, 12, 22, 11, 90 };
//        BubbleSort(array);
//        // El array ahora está ordenado de menor a mayor
//    }
//}

// Versión en Assembly del ordenamiento burbuja:
.section .data
array:      .word 64, 34, 25, 12, 22, 11, 90  // Array a ordenar
len:        .quad 7                            // Longitud del array

.section .text
.global _start
_start:
    // Cargar dirección del array y su longitud
    ldr x0, =array                   // x0 = dirección base del array
    ldr x1, =len                     // Cargar dirección de len
    ldr x1, [x1]                     // x1 = longitud del array
    sub x1, x1, #1                   // x1 = n-1 para el bucle externo

outer_loop:
    mov x2, #0                       // x2 = índice i para bucle externo
    mov x9, #0                       // x9 = flag de intercambio (swapped)

    // Verificar si hemos terminado el bucle externo
    cmp x2, x1
    bge end_sort

inner_loop:
    // Calcular n-i-1 para el límite del bucle interno
    sub x3, x1, x2                   // x3 = n-i-1
    
    // Verificar si hemos terminado el bucle interno
    cmp x2, x3
    bge check_swapped
    
    // Cargar elementos adyacentes
    lsl x4, x2, #2                   // x4 = offset para array[j]
    add x5, x4, #4                   // x5 = offset para array[j+1]
    
    ldr w6, [x0, x4]                 // w6 = array[j]
    ldr w7, [x0, x5]                 // w7 = array[j+1]
    
    // Comparar elementos
    cmp w6, w7
    ble no_swap
    
    // Intercambiar elementos si están en orden incorrecto
    str w7, [x0, x4]                 // array[j] = array[j+1]
    str w6, [x0, x5]                 // array[j+1] = temp
    mov x9, #1                       // Marcar que hubo un intercambio

no_swap:
    add x2, x2, #1                   // Incrementar índice j
    b inner_loop

check_swapped:
    // Si no hubo intercambios, terminar
    cmp x9, #0
    beq end_sort
    
    // Preparar siguiente iteración del bucle externo
    sub x1, x1, #1                   // Decrementar n para siguiente pasada
    b outer_loop

end_sort:
    // Salir del programa
    mov x8, #93                      // syscall: exit
    mov x0, #0                       // Código de salida
    svc #0
