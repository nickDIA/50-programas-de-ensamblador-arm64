// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/* 
using System;

class DetectorDesbordamiento
{
    static void Main()
    {
        // Solicitar al usuario que ingrese dos números
        Console.WriteLine("Ingresa el primer número:");
        int num1 = Convert.ToInt32(Console.ReadLine());

        Console.WriteLine("Ingresa el segundo número:");
        int num2 = Convert.ToInt32(Console.ReadLine());

        // Detectar si ocurre desbordamiento al sumar los dos números
        try
        {
            checked // Activar comprobación de desbordamiento
            {
                int suma = num1 + num2;
                Console.WriteLine($"El resultado de la suma es: {suma}");
            }
        }
        catch (OverflowException)
        {
            Console.WriteLine("Error: Ocurrió un desbordamiento al sumar los números.");
        }
    }
}

*/

// Detector de desbordamiento en suma
.global _start
.section .text

_start:
    mov x19, #0x7FFFFFFFFFFFFFFF  // Máximo valor positivo
    mov x20, #1                   // Valor a sumar
    
    // Intentar suma y verificar desbordamiento
    adds x21, x19, x20            // Suma con actualización de flags
    bvs overflow_detected         // Saltar si hay desbordamiento
    
    // No hay desbordamiento
    mov x0, #0
    b exit
    
overflow_detected:
    mov x0, #1                    // Indicar desbordamiento

exit:
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
