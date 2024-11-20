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
        Console.WriteLine("Rotación de elementos en un arreglo");

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

            // Solicitar el número de rotaciones
            Console.Write("Ingresa el número de posiciones a rotar: ");
            string inputRotaciones = Console.ReadLine();

            if (int.TryParse(inputRotaciones, out int rotaciones))
            {
                // Mostrar el arreglo original
                Console.WriteLine("Arreglo original: " + string.Join(", ", arreglo));

                // Rotar el arreglo
                RotarArreglo(arreglo, rotaciones);

                // Mostrar el arreglo rotado
                Console.WriteLine("Arreglo rotado: " + string.Join(", ", arreglo));
            }
            else
            {
                Console.WriteLine("Número de rotaciones no válido.");
            }
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número entero positivo.");
        }
    }

    static void RotarArreglo(int[] arreglo, int posiciones)
    {
        int n = arreglo.Length;
        posiciones %= n; // Asegurarnos de que las rotaciones no excedan el tamaño del arreglo
        if (posiciones < 0) posiciones += n; // Manejar rotaciones negativas (rotación a la izquierda)

        // Rotar el arreglo
        Reverse(arreglo, 0, n - 1); // Invertir todo el arreglo
        Reverse(arreglo, 0, posiciones - 1); // Invertir la primera parte
        Reverse(arreglo, posiciones, n - 1); // Invertir la segunda parte
    }

    static void Reverse(int[] arreglo, int inicio, int fin)
    {
        while (inicio < fin)
        {
            int temp = arreglo[inicio];
            arreglo[inicio] = arreglo[fin];
            arreglo[fin] = temp;
            inicio++;
            fin--;
        }
    }
}

*/

// Programa para rotar elementos de un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: longitud del arreglo
// x2: cantidad de posiciones a rotar
// x3-x4: índices para reversión
// x5-x6: valores temporales para intercambio
// x7: dirección temporal
// x8: dirección temporal

.data
    .align 3                     // Alinear a 8 bytes
    array: .quad 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    longitud = (. - array) / 8   // Calcular longitud (elementos de 8 bytes)
    rotaciones = 3               // Número de posiciones a rotar (positivo=izquierda, negativo=derecha)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array
    add x0, x0, :lo12:array
    
    // Inicializar registros
    mov x1, longitud            // Longitud del arreglo
    mov x2, rotaciones         // Cantidad de rotaciones

    // Normalizar rotaciones si son negativas o mayores que la longitud
    cmp x2, #0
    bge normalizar_positivo
    
    // Si es negativo, convertir a rotación equivalente a la izquierda
    add x2, x2, x1
    
normalizar_positivo:
    // Asegurar que rotaciones < longitud
    sdiv x3, x2, x1
    msub x2, x3, x1, x2    // x2 = x2 % longitud

    // Si rotaciones es 0, terminar
    cbz x2, fin

rotar_izquierda:
    // Paso 1: Revertir primeros k elementos
    mov x3, #0              // índice inicio
    sub x4, x2, #1          // índice fin
    bl revertir_subarray
    
    // Paso 2: Revertir elementos restantes
    mov x3, x2              // índice inicio
    sub x4, x1, #1          // índice fin
    bl revertir_subarray
    
    // Paso 3: Revertir todo el array
    mov x3, #0              // índice inicio
    sub x4, x1, #1          // índice fin
    bl revertir_subarray
    b fin

// Subrutina para revertir un subarray entre los índices x3 y x4
revertir_subarray:
    // Guardar dirección de retorno
    str x30, [sp, #-16]!
    
revertir_loop:
    // Verificar si hemos terminado
    cmp x3, x4
    bge revertir_fin
    
    // Calcular direcciones
    mov x7, x0
    mov x8, x0
    lsl x5, x3, #3         // x5 = inicio * 8
    lsl x6, x4, #3         // x6 = fin * 8
    add x7, x7, x5         // Dirección elemento inicio
    add x8, x8, x6         // Dirección elemento fin
    
    // Intercambiar elementos
    ldr x5, [x7]           // Cargar elemento inicio
    ldr x6, [x8]           // Cargar elemento fin
    str x6, [x7]           // Guardar fin en inicio
    str x5, [x8]           // Guardar inicio en fin
    
    // Actualizar índices
    add x3, x3, #1
    sub x4, x4, #1
    
    b revertir_loop

revertir_fin:
    // Restaurar dirección de retorno
    ldr x30, [sp], #16
    ret

fin:
    mov x8, #93            // Syscall exit
    mov x0, #0             // Código de retorno
    svc #0
