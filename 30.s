// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64
// public static class MCDCalculator
// {
//     // Método iterativo usando el algoritmo de Euclides
//     public static int CalcularMCD(int a, int b)
//     {
//         // Convertimos a números positivos
//         a = Math.Abs(a);
//         b = Math.Abs(b);
        
//         // Caso especial: si uno de los números es 0
//         if (a == 0) return b;
//         if (b == 0) return a;
        
//         // Algoritmo de Euclides
//         while (b != 0)
//         {
//             int temp = b;
//             b = a % b;
//             a = temp;
//         }
        
//         return a;
//     }
    
//     // Método recursivo
//     public static int CalcularMCDRecursivo(int a, int b)
//     {
//         a = Math.Abs(a);
//         b = Math.Abs(b);
        
//         if (b == 0)
//             return a;
            
//         return CalcularMCDRecursivo(b, a % b);
//     }
    
//     // Método para calcular el MCD de múltiples números
//     public static int CalcularMCDMultiple(params int[] numeros)
//     {
//         if (numeros == null || numeros.Length == 0)
//             throw new ArgumentException("Debe proporcionar al menos un número");
            
//         if (numeros.Length == 1)
//             return Math.Abs(numeros[0]);
            
//         int resultado = CalcularMCD(numeros[0], numeros[1]);
        
//         for (int i = 2; i < numeros.Length; i++)
//         {
//             resultado = CalcularMCD(resultado, numeros[i]);
//         }
        
//         return resultado;
//     }
// }


// Programa para calcular el MCD usando el algoritmo de Euclides
// Registros usados:
// x0: primer número
// x1: segundo número
// x2: temporal para el resto

.global _start      // Punto de entrada del programa
.text

_start:
    // Ejemplo: calcular MCD de 48 y 36
    mov x0, #48     // Primer número en x0
    mov x1, #36     // Segundo número en x1

calcular_mcd:
    // Comprobar si el segundo número es 0
    cmp x1, #0
    beq fin         // Si es 0, el resultado está en x0

    // Calcular el resto de la división
    udiv x2, x0, x1 // x2 = x0 / x1
    mul x2, x2, x1  // x2 = x2 * x1
    sub x2, x0, x2  // x2 = x0 - x2 (resto)

    // Preparar para la siguiente iteración
    mov x0, x1      // x0 = x1
    mov x1, x2      // x1 = resto
    
    b calcular_mcd  // Volver al inicio del bucle

fin:
    // x0 contiene el MCD
    // Aquí puedes agregar código para mostrar el resultado
    mov x8, #93     // Syscall exit
    mov x0, #0      // Código de retorno 0
    svc #0          // Llamada al sistema
