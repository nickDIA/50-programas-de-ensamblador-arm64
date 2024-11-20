// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

// Version C#
/*
  using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Cálculo de Máximo Común Divisor (MCD) y Mínimo Común Múltiplo (MCM)");

        // Solicitar los dos números
        Console.Write("Ingresa el primer número entero: ");
        string input1 = Console.ReadLine();

        Console.Write("Ingresa el segundo número entero: ");
        string input2 = Console.ReadLine();

        // Validar la entrada
        if (int.TryParse(input1, out int num1) && int.TryParse(input2, out int num2) && num1 > 0 && num2 > 0)
        {
            int mcd = CalcularMCD(num1, num2);
            int mcm = (num1 * num2) / mcd;

            // Mostrar resultados
            Console.WriteLine($"El MCD de {num1} y {num2} es: {mcd}");
            Console.WriteLine($"El MCM de {num1} y {num2} es: {mcm}");
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa dos números enteros positivos.");
        }
    }

    static int CalcularMCD(int a, int b)
    {
        while (b != 0)
        {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
}

*/

// Programa para calcular el MCM usando la relación MCM = (a × b) / MCD
// Registros usados:
// x0: primer número / resultado MCD
// x1: segundo número
// x2: temporal para el resto
// x3: guarda el primer número original
// x4: guarda el segundo número original
// x5: resultado del MCM

.global _start
.text

_start:
    // Ejemplo: calcular MCM de 12 y 18
    mov x0, #12         // Primer número en x0
    mov x1, #18         // Segundo número en x1
    
    // Guardar los números originales
    mov x3, x0          // Guardar primer número
    mov x4, x1          // Guardar segundo número

calcular_mcd:
    // Comprobar si el segundo número es 0
    cmp x1, #0
    beq calcular_mcm    // Si es 0, pasar a calcular MCM

    // Calcular el resto de la división
    udiv x2, x0, x1     // x2 = x0 / x1
    mul x2, x2, x1      // x2 = x2 * x1
    sub x2, x0, x2      // x2 = x0 - x2 (resto)

    // Preparar para la siguiente iteración
    mov x0, x1          // x0 = x1
    mov x1, x2          // x1 = resto
    
    b calcular_mcd      // Volver al inicio del bucle

calcular_mcm:
    // En este punto, x0 contiene el MCD
    // MCM = (a × b) / MCD
    
    // Primero multiplicamos los números originales
    mul x5, x3, x4      // x5 = a × b
    
    // Dividimos por el MCD (que está en x0)
    udiv x5, x5, x0     // x5 = (a × b) / MCD
    
    // x5 contiene el MCM

fin:
    // x0 contiene el MCD
    // x5 contiene el MCM
    mov x8, #93         // Syscall exit
    mov x0, #0          // Código de retorno 0
    svc #0              // Llamada al sistema
