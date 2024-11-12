/*
using System;

class MergeSortProgram
{
    public static void Main(string[] args)
    {
        int[] array = { 8, 3, 7, 4, 6, 2, 5, 1 }; // Ejemplo de arreglo desordenado
        Console.WriteLine("Arreglo original:");
        PrintArray(array);

        MergeSort(array, 0, array.Length - 1); // Llamada a la función de ordenamiento

        Console.WriteLine("\nArreglo ordenado:");
        PrintArray(array);
    }

    // Función principal de Merge Sort
    public static void MergeSort(int[] array, int left, int right)
    {
        if (left < right)
        {
            int middle = (left + right) / 2;

            // Ordenar cada mitad
            MergeSort(array, left, middle);
            MergeSort(array, middle + 1, right);

            // Combinar las mitades ordenadas
            Merge(array, left, middle, right);
        }
    }

    // Función para combinar dos mitades ordenadas
    public static void Merge(int[] array, int left, int middle, int right)
    {
        int n1 = middle - left + 1;
        int n2 = right - middle;

        // Crear arreglos temporales para las mitades izquierda y derecha
        int[] leftArray = new int[n1];
        int[] rightArray = new int[n2];

        // Copiar datos a los arreglos temporales
        for (int i = 0; i < n1; i++)
            leftArray[i] = array[left + i];
        for (int j = 0; j < n2; j++)
            rightArray[j] = array[middle + 1 + j];

        // Combinar los arreglos temporales en el arreglo original
        int k = left, iIndex = 0, jIndex = 0;

        while (iIndex < n1 && jIndex < n2)
        {
            if (leftArray[iIndex] <= rightArray[jIndex])
            {
                array[k] = leftArray[iIndex];
                iIndex++;
            }
            else
            {
                array[k] = rightArray[jIndex];
                jIndex++;
            }
            k++;
        }

        // Copiar los elementos restantes de leftArray, si los hay
        while (iIndex < n1)
        {
            array[k] = leftArray[iIndex];
            iIndex++;
            k++;
        }

        // Copiar los elementos restantes de rightArray, si los hay
        while (jIndex < n2)
        {
            array[k] = rightArray[jIndex];
            jIndex++;
            k++;
        }
    }

    // Método auxiliar para imprimir el arreglo
    public static void PrintArray(int[] array)
    {
        foreach (int item in array)
        {
            Console.Write(item + " ");
        }
        Console.WriteLine();
    }
}
*/

.section .data
array:      .word 8, 3, 7, 4, 6, 2, 5, 1  // Ejemplo de datos a ordenar
size:       .word 8                       // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar dirección del array y tamaño
    ldr x0, =array      // x0 apunta al arreglo
    ldr w1, =8          // w1 contiene el tamaño del arreglo

    // Llamar a merge_sort
    bl merge_sort

    // Salir
    mov w8, 93          // syscall exit
    mov x0, 0
    svc 0

// Función principal: merge_sort
// Argumentos: x0 -> arreglo, w1 -> tamaño
merge_sort:
    // Si el tamaño es 1 o menos, ya está ordenado
    cmp w1, 1
    ble end_merge_sort

    // Dividir el tamaño entre 2
    mov w2, w1            // w2 = tamaño
    lsr w2, w2, 1         // w2 = tamaño / 2

    // Calcular las mitades izquierda y derecha
    // Multiplicar tamaño de mitad por 4 para usarlo como desplazamiento en bytes
    uxtw x3, w2           // Expandir w2 a 64 bits en x3
    mov x3, x3, lsl #2    // x3 = (tamaño/2) * 4
    add x1, x0, x3        // x1 = arreglo + (tamaño/2)*4

    // Guardar registros en la pila para evitar corrupción
    stp x0, x1, [sp, -16]! // Guardar x0 y x1 en la pila

    // Llamar recursivamente para cada mitad
    mov w3, w2              // w3 = tamaño/2
    bl merge_sort           // merge_sort(arreglo, tamaño/2)

    sub w4, w1, w2          // w4 = tamaño - tamaño/2
    mov x0, x1              // x0 = inicio de segunda mitad
    mov w1, w4              // w1 = tamaño - tamaño/2
    bl merge_sort           // merge_sort(arreglo + (tamaño/2)*4, tamaño - tamaño/2)

    // Restaurar registros de la pila
    ldp x0, x1, [sp], 16    // Restaurar x0 y x1

    // Llamar a merge para combinar las dos mitades
    mov w1, w2              // w1 = tamaño de la primera mitad
    mov w2, w4              // w2 = tamaño de la segunda mitad
    bl merge

end_merge_sort:
    ret

// Función merge
// Combina dos subarreglos ordenados
// Argumentos: x0 -> arreglo, w1 -> tamaño de primera mitad, w2 -> tamaño de segunda mitad
merge:
    // Reservar espacio temporal
    mov x3, x0
    uxtw x5, w1           // Expandir w1 a 64 bits en x5
    mov x5, x5, lsl #2    // x5 = (tamaño de primera mitad) * 4
    add x4, x3, x5        // x4 = inicio de segunda mitad

loop_merge:
    // Condiciones de final de cada mitad
    cmp w1, 0
    beq copy_right
    cmp w2, 0
    beq copy_left

    // Comparar elementos de cada mitad y agregar el menor al arreglo original
    ldr w5, [x3], #4
    ldr w6, [x4], #4
    cmp w5, w6
    b.le left_smaller

right_smaller:
    str w6, [x0], #4
    sub w2, w2, 1
    b loop_merge

left_smaller:
    str w5, [x0], #4
    sub w1, w1, 1
    b loop_merge

copy_left:
    // Copiar los elementos restantes de la primera mitad
    cbz w1, end_merge
    ldr w5, [x3], #4
    str w5, [x0], #4
    sub w1, w1, 1
    b copy_left

copy_right:
    // Copiar los elementos restantes de la segunda mitad
    cbz w2, end_merge
    ldr w6, [x4], #4
    str w6, [x0], #4
    sub w2, w2, 1
    b copy_right

end_merge:
    ret
