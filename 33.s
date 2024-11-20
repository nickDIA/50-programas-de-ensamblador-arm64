// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Cálculo de la suma de elementos en un arreglo");

        // Solicitar el tamaño del arreglo
        Console.Write("Ingresa el número de elementos del arreglo: ");
        string inputTamaño = Console.ReadLine();

        if (int.TryParse(inputTamaño, out int tamaño) && tamaño > 0)
        {
            int[] arreglo = new int[tamaño];

            // Llenar el arreglo
            for (int i = 0; i < tamaño; i++)
            {
                Console.Write($"Ingresa el elemento {i + 1}: ");
                if (int.TryParse(Console.ReadLine(), out int elemento))
                {
                    arreglo[i] = elemento;
                }
                else
                {
                    Console.WriteLine("Entrada no válida. Se establecerá el valor 0.");
                    arreglo[i] = 0;
                }
            }

            // Calcular la suma
            int suma = CalcularSuma(arreglo);

            // Mostrar el resultado
            Console.WriteLine($"La suma de los elementos del arreglo es: {suma}");
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número entero positivo.");
        }
    }

    static int CalcularSuma(int[] arreglo)
    {
        int suma = 0;

        foreach (int elemento in arreglo)
        {
            suma += elemento;
        }

        return suma;
    }
}

*/


// Programa para sumar elementos de un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: longitud del arreglo
// x2: suma total
// x3-x6: valores temporales para desenrollado de bucle
// x7: contador de elementos restantes

.data
    .align 3                     // Alinear a 8 bytes
    array: .quad 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    longitud = (. - array) / 8   // Calcular longitud (elementos de 8 bytes)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array
    add x0, x0, :lo12:array
    
    // Inicializar registros
    mov x1, longitud        // Cargar longitud total
    mov x2, #0              // Inicializar suma en 0
    mov x7, x1              // Copiar longitud para contador

    // Verificar si hay suficientes elementos para desenrollar
    cmp x7, #4
    blt suma_simple         // Si hay menos de 4 elementos, usar bucle simple

suma_desenrollada:
    // Verificar si quedan al menos 4 elementos
    cmp x7, #4
    blt suma_restantes
    
    // Cargar 4 elementos a la vez
    ldp x3, x4, [x0], #16  // Cargar dos elementos
    ldp x5, x6, [x0], #16  // Cargar dos elementos más
    
    // Sumar los 4 elementos
    add x2, x2, x3         // Sumar primer elemento
    add x2, x2, x4         // Sumar segundo elemento
    add x2, x2, x5         // Sumar tercer elemento
    add x2, x2, x6         // Sumar cuarto elemento
    
    sub x7, x7, #4         // Actualizar contador
    b suma_desenrollada    // Siguiente grupo de 4

suma_restantes:
    // Procesar elementos restantes uno por uno
    cbz x7, fin            // Si no quedan elementos, terminar
    
suma_simple:
    ldr x3, [x0], #8       // Cargar un elemento
    add x2, x2, x3         // Sumar al total
    sub x7, x7, #1         // Decrementar contador
    cbnz x7, suma_simple   // Si quedan elementos, continuar

fin:
    // x2 contiene la suma total
    mov x8, #93            // Syscall exit
    mov x0, x2             // Mover resultado a x0 para retorno
    svc #0
