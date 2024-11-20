// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Conversor de Celsius a Fahrenheit");
        
        // Solicitar al usuario ingresar los grados Celsius
        Console.Write("Ingresa la temperatura en grados Celsius: ");
        string input = Console.ReadLine();

        // Validar la entrada
        if (double.TryParse(input, out double celsius))
        {
            // Convertir a Fahrenheit
            double fahrenheit = (celsius * 9 / 5) + 32;

            // Mostrar el resultado
            Console.WriteLine($"{celsius}°C equivalen a {fahrenheit}°F.");
        }
        else
        {
            Console.WriteLine("Entrada no válida. Por favor, ingresa un número.");
        }
    }
}
*/

.global _start

.text
_start:
    // Suponemos que la temperatura en Celsius está en x0
    // Fórmula: °F = (°C × 9/5) + 32
    
    // Multiplicar por 9
    mov x1, #9
    mul x0, x0, x1
    
    // Dividir por 5
    mov x1, #5
    udiv x0, x0, x1
    
    // Sumar 32
    add x0, x0, #32
    
    // El resultado en Fahrenheit está ahora en x0
    
    // Salir del programa
    mov x8, #93        // syscall exit
    mov x0, #0         // return code 0
    svc #0             // realizar syscall

.data
    celsius: .word 25   // Ejemplo: 25°C
