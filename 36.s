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
        Console.WriteLine("Encontrar el segundo elemento más grande en un arreglo");

        // Solicitar al usuario el tamaño del arreglo
        Console.Write("Ingresa el número de elementos del arreglo: ");
        string inputTamaño = Console.ReadLine();

        if (int.TryParse(inputTamaño, out int tamaño) && tamaño > 1)
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

            // Llamar a la función para encontrar el segundo elemento más grande
            int segundoMasGrande = EncontrarSegundoMasGrande(arreglo);

            if (segundoMasGrande != int.MinValue)
            {
                Console.WriteLine($"El segundo elemento más grande en el arreglo es: {segundoMasGrande}");
            }
            else
            {
                Console.WriteLine("No se puede determinar el segundo elemento más grande, el arreglo tiene menos de 2 elementos diferentes.");
            }
        }
        else
        {
            Console.WriteLine("Entrada no válida. El arreglo debe tener al menos 2 elementos.");
        }
    }

    static int EncontrarSegundoMasGrande(int[] arreglo)
    {
        int maximo = int.MinValue; // El mayor número encontrado
        int segundoMaximo = int.MinValue; // El segundo mayor número encontrado

        foreach (int numero in arreglo)
        {
            if (numero > maximo)
            {
                segundoMaximo = maximo;  // El segundo máximo pasa a ser el máximo anterior
                maximo = numero;         // Actualizar el máximo
            }
            else if (numero > segundoMaximo && numero != maximo)
            {
                segundoMaximo = numero;  // Actualizar el segundo máximo
            }
        }

        return segundoMaximo;
    }
}

*/

// Programa para encontrar el segundo elemento más grande en un arreglo
// Registros usados:
// x0: dirección base del arreglo
// x1: longitud del arreglo
// x2: máximo valor encontrado
// x3: segundo máximo valor encontrado
// x4: valor actual siendo comparado
// x5: contador
// x6: dirección temporal

.data
    .align 3                     // Alinear a 8 bytes
    array: .quad 15, 8, 23, 12, 9, 20, 11, 16, 7, 22
    longitud = (. - array) / 8   // Calcular longitud (elementos de 8 bytes)
    no_encontrado = 0x8000000000000000  // Valor centinela (número más pequeño posible)

.text
.global _start

_start:
    // Cargar dirección base del arreglo
    adrp x0, array
    add x0, x0, :lo12:array
    
    // Inicializar registros
    mov x1, longitud                    // Longitud del arreglo
    mov x2, no_encontrado               // Inicializar máximo
    mov x3, no_encontrado               // Inicializar segundo máximo
    
    // Verificar si hay al menos 2 elementos
    cmp x1, #2
    blt array_muy_pequeno
    
    // Cargar primer elemento
    ldr x2, [x0]                        // Primer máximo
    ldr x3, [x0, #8]                    // Segundo máximo provisional
    
    // Ordenar los dos primeros elementos
    cmp x2, x3
    bge continuar_busqueda
    // Si x3 > x2, intercambiar
    mov x4, x2
    mov x2, x3
    mov x3, x4

continuar_busqueda:
    // Inicializar para recorrer el resto del array
    mov x5, #2                          // Comenzar desde el tercer elemento
    add x6, x0, #16                     // Actualizar puntero al array

buscar_segundo:
    // Verificar si hemos terminado
    cmp x5, x1
    bge fin
    
    // Cargar siguiente elemento
    ldr x4, [x6], #8
    
    // Comparar con el máximo actual
    cmp x4, x2
    bgt nuevo_maximo
    
    // Comparar con el segundo máximo
    cmp x4, x3
    bgt nuevo_segundo
    
continuar:
    add x5, x5, #1                      // Incrementar contador
    b buscar_segundo

nuevo_maximo:
    // Actualizar máximos
    mov x3, x2                          // Antiguo máximo pasa a ser segundo
    mov x2, x4                          // Nuevo máximo
    b continuar

nuevo_segundo:
    // Actualizar solo segundo máximo
    mov x3, x4
    b continuar

array_muy_pequeno:
    // Manejar caso de array con menos de 2 elementos
    mov x3, no_encontrado
    b fin

fin:
    // x3 contiene el segundo elemento más grande
    mov x8, #93                         // Syscall exit
    mov x0, x3                          // Mover resultado a x0 para retorno
    svc #0
