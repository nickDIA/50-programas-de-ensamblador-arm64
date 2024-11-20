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
        Console.WriteLine("Verificador de números primos");

        // Solicitar al usuario un número
        Console.Write("Ingresa un número entero positivo: ");
        string input = Console.ReadLine();

        // Validar la entrada
        if (int.TryParse(input, out int numero) && numero > 0)
        {
            if (EsPrimo(numero))
            {
                Console.WriteLine($"El número {numero} es primo.");
            }
            else
            {
                Console.WriteLine($"El número {numero} no es primo.");
            }
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número entero positivo.");
        }
    }

    static bool EsPrimo(int n)
    {
        if (n <= 1) return false; // Los números menores o iguales a 1 no son primos
        if (n == 2) return true;  // El número 2 es primo
        if (n % 2 == 0) return false; // Los números pares mayores que 2 no son primos

        // Verificar divisores desde 3 hasta la raíz cuadrada de n
        int limite = (int)Math.Sqrt(n);
        for (int i = 3; i <= limite; i += 2)
        {
            if (n % i == 0)
            {
                return false;
            }
        }

        return true;
    }
}

*/

// Programa en ensamblador ARM de 64 bits para verificar si un número fijo es primo
// Guardar este archivo como primo.s y compilar con:
// $ as -o primo.o primo.s
// $ ld -o primo primo.o
// Ejecutar con:
// $ ./primo
//si el 

.section .text
    .global _start

_start:
    // Definir el número a verificar, por ejemplo, 13
    mov x0, 13                      // Número a verificar si es primo
    mov x1, 2                       // Inicializar divisor en 2

check_prime_loop:
    // Comprobar si el divisor x1 al cuadrado es mayor que x0
    mul x2, x1, x1                  // x2 = x1 * x1
    cmp x2, x0                      // Comparar x2 con el número x0
    bgt is_prime                    // Si x2 > x0, el número es primo

    // Verificar si el número es divisible por el divisor actual
    udiv x3, x0, x1                 // x3 = x0 / x1 (división entera)
    msub x3, x3, x1, x0             // x3 = x0 - (x3 * x1), es decir, el residuo de x0 / x1
    cbz x3, not_prime               // Si x3 es 0, x0 es divisible, no es primo

    // Incrementar el divisor y continuar
    add x1, x1, 1                   // Incrementar divisor
    b check_prime_loop              // Repetir el bucle

is_prime:
    // Aquí se llega si el número es primo
    mov x0, 1                       // Resultado 1 (indica primo)
    b end_program

not_prime:
    // Aquí se llega si el número no es primo
    mov x0, 0                       // Resultado 0 (indica no primo)

end_program:
    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    svc 0                           // Llamada al sistema
