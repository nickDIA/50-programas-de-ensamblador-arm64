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
        Console.WriteLine("Calculadora de Factorial");

        // Solicitar al usuario ingresar un número
        Console.Write("Ingresa un número entero positivo: ");
        string input = Console.ReadLine();

        // Validar la entrada
        if (int.TryParse(input, out int numero) && numero >= 0)
        {
            // Calcular el factorial
            long factorial = CalcularFactorial(numero);

            // Mostrar el resultado
            Console.WriteLine($"El factorial de {numero} es: {factorial}");
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número entero positivo.");
        }
    }

    static long CalcularFactorial(int n)
    {
        long resultado = 1;

        for (int i = 1; i <= n; i++)
        {
            resultado *= i;
        }

        return resultado;
    }
}

*/

.section .text
    .global _start

_start:
    // Definir un número fijo, por ejemplo, 5
    mov x0, 5                       // Número para el que se calculará el factorial

    // Calcular el factorial
    mov x1, x0                      // Copiar el número a x1 (usado para multiplicación)
    mov x2, 1                       // Inicializar x2 en 1 (resultado del factorial)

factorial_loop:
    cmp x1, 1                       // Comparar x1 con 1
    ble end_factorial               // Si x1 <= 1, salir del bucle
    mul x2, x2, x1                  // Multiplicar x2 (resultado) por x1
    sub x1, x1, 1                   // Decrementar x1
    b factorial_loop                // Repetir el bucle

end_factorial:
    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    mov x0, 0                       // Código de salida
    svc 0                           // Llamada al sistema
