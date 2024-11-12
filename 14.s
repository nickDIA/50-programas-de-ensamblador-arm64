// using System;
// using System.Collections.Generic;

// class BusquedaLineal
// {
//     // Búsqueda lineal básica que retorna el índice del primer elemento encontrado
//     public static int BusquedaLinealSimple(int[] arreglo, int elementoBuscado)
//     {
//         for (int i = 0; i < arreglo.Length; i++)
//         {
//             if (arreglo[i] == elementoBuscado)
//                 return i;
//         }
//         return -1; // Elemento no encontrado
//     }

//     // Búsqueda lineal que encuentra todas las ocurrencias
//     public static List<int> BusquedaLinealTodasOcurrencias(int[] arreglo, int elementoBuscado)
//     {
//         List<int> indices = new List<int>();
        
//         for (int i = 0; i < arreglo.Length; i++)
//         {
//             if (arreglo[i] == elementoBuscado)
//                 indices.Add(i);
//         }
        
//         return indices;
//     }

//     // Búsqueda lineal que cuenta el número de ocurrencias
//     public static int ContarOcurrencias(int[] arreglo, int elementoBuscado)
//     {
//         int contador = 0;
        
//         foreach (int elemento in arreglo)
//         {
//             if (elemento == elementoBuscado)
//                 contador++;
//         }
        
//         return contador;
//     }

//     // Búsqueda lineal con condición personalizada (ejemplo: encontrar el primer número par)
//     public static int BusquedaLinealConCondicion(int[] arreglo, Func<int, bool> condicion)
//     {
//         for (int i = 0; i < arreglo.Length; i++)
//         {
//             if (condicion(arreglo[i]))
//                 return i;
//         }
//         return -1;
//     }

//     static void Main()
//     {
//         // Ejemplo de uso con un arreglo que tiene elementos repetidos
//         int[] arreglo = { 64, 34, 25, 12, 34, 11, 90, 34 };
//         int elementoBuscado = 34;

//         Console.WriteLine("Arreglo de prueba:");
//         Console.WriteLine(string.Join(", ", arreglo));
//         Console.WriteLine();

//         // Prueba de búsqueda simple
//         int indice = BusquedaLinealSimple(arreglo, elementoBuscado);
//         Console.WriteLine($"Búsqueda simple del elemento {elementoBuscado}:");
//         if (indice != -1)
//             Console.WriteLine($"Elemento encontrado en el índice: {indice}");
//         else
//             Console.WriteLine("Elemento no encontrado");

//         // Prueba de búsqueda de todas las ocurrencias
//         List<int> todosIndices = BusquedaLinealTodasOcurrencias(arreglo, elementoBuscado);
//         Console.WriteLine($"\nTodas las ocurrencias del elemento {elementoBuscado}:");
//         if (todosIndices.Count > 0)
//             Console.WriteLine($"Encontrado en los índices: {string.Join(", ", todosIndices)}");
//         else
//             Console.WriteLine("Elemento no encontrado");

//         // Prueba de contar ocurrencias
//         int cantidadOcurrencias = ContarOcurrencias(arreglo, elementoBuscado);
//         Console.WriteLine($"\nNúmero de ocurrencias del elemento {elementoBuscado}: {cantidadOcurrencias}");

//         // Prueba de búsqueda con condición (ejemplo: primer número par)
//         int indicePar = BusquedaLinealConCondicion(arreglo, x => x % 2 == 0);
//         Console.WriteLine("\nBúsqueda del primer número par:");
//         if (indicePar != -1)
//             Console.WriteLine($"Primer número par encontrado en el índice {indicePar}: {arreglo[indicePar]}");
//         else
//             Console.WriteLine("No se encontraron números pares");
//     }
// }

//no imprime

.section .data
array:      .word 3, 9, 5, 12, 7, 15, 2      // Ejemplo de arreglo de enteros
len:        .quad 7                          // Longitud del arreglo
target:     .word 12                         // Valor a buscar en el arreglo

.section .text
.global _start

_start:
    // Cargar la dirección del arreglo, su longitud y el valor objetivo
    ldr x0, =array                    // x0 apunta al inicio del arreglo
    ldr x1, =len                      // x1 guarda la longitud del arreglo
    ldr x1, [x1]                      // Obtener el valor de la longitud
    ldr w3, =target                   // w3 guarda el valor que estamos buscando
    ldr w3, [x3]                      // Obtener el valor del target

    // Inicializar el índice y el valor de no encontrado (-1)
    mov x4, #0                        // x4 es el índice actual
    mov x5, -1                        // x5 será el índice del valor encontrado o -1 si no se encuentra

search_loop:
    // Comprobar si hemos alcanzado el final del arreglo
    cmp x4, x1                        // Comparar índice actual con longitud
    beq end_search                    // Si x4 == x1, terminamos la búsqueda (no encontrado)

    // Cargar el siguiente elemento y compararlo con el valor buscado
    ldr w2, [x0, x4, lsl #2]          // Cargar elemento en el índice actual
    cmp w2, w3                        // Comparar con el valor objetivo
    beq found                         // Si son iguales, ir a found

    // Incrementar índice y continuar la búsqueda
    add x4, x4, #1                    // Incrementar índice
    b search_loop                     // Repetir el bucle

found:
    mov x5, x4                        // Guardar el índice encontrado en x5

end_search:
    // Salir del programa
    mov x8, #93                       // syscall: exit
    mov x0, #0                        // Código de salida
    svc #0
