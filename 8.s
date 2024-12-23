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
        Console.WriteLine("Cálculo del n-ésimo término de la Serie de Fibonacci");

        // Solicitar al usuario un número
        Console.Write("Ingresa el valor de n (entero positivo): ");
        string input = Console.ReadLine();

        // Validar la entrada
        if (int.TryParse(input, out int n) && n >= 0)
        {
            long fibonacci = CalcularFibonacci(n);
            Console.WriteLine($"El término {n} de la serie de Fibonacci es: {fibonacci}");
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número entero no negativo.");
        }
    }

    static long CalcularFibonacci(int n)
    {
        if (n == 0) return 0; // Caso base: Fibonacci(0) = 0
        if (n == 1) return 1; // Caso base: Fibonacci(1) = 1

        long a = 0, b = 1;

        for (int i = 2; i <= n; i++)
        {
            long temp = a + b;
            a = b;
            b = temp;
        }

        return b;
    }
}
*/

// Programa en ensamblador ARM de 64 bits para calcular la serie de Fibonacci hasta un número fijo
// Guardar este archivo como fibonacci.s y compilar con:
// $ as -o fibonacci.o fibonacci.s
// $ ld -o fibonacci fibonacci.o
// Ejecutar con:
// $ ./fibonacci

.section .text
    .global _start

_start:
    // Definir el número de términos de Fibonacci que queremos calcular, por ejemplo, 10
    mov x0, 10                      // Número de términos de la serie de Fibonacci no confundir con el número de término que buscamos
    mov x1, 0                       // F(0)
    mov x2, 1                       // F(1)
    mov x3, 2                       // Contador de términos, comenzando en el tercer término

fibonacci_loop:
    cmp x3, x0                      // Comparar el contador con el número fijo
    bge end_fibonacci               // Si alcanzamos el número fijo, salir del bucle

    // Calcular el siguiente término de Fibonacci
    add x4, x1, x2                  // F(n) = F(n-1) + F(n-2)
    mov x1, x2                      // Mover F(n-1) a F(n-2)
    mov x2, x4                      // Mover F(n) a F(n-1)
    add x3, x3, 1                   // Incrementar el contador

    b fibonacci_loop                // Repetir el bucle

end_fibonacci:
    // Al finalizar, el último término de Fibonacci calculado estará en x2

    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    mov x0, 0                       // Código de salida
    svc 0                           // Llamada al sistema
