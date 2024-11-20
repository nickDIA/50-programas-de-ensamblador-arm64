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
        // Solicitar al usuario que ingrese un número hexadecimal
        Console.WriteLine("Ingresa un número en formato hexadecimal:");
        string hexInput = Console.ReadLine();

        try
        {
            // Convertir el número hexadecimal a decimal
            int decimalValue = Convert.ToInt32(hexInput, 16);
            Console.WriteLine($"El valor decimal de {hexInput} es: {decimalValue}");
        }
        catch (FormatException)
        {
            Console.WriteLine("El valor ingresado no es un número hexadecimal válido.");
        }
    }
}

*/

// Programa para convertir hexadecimal a decimal
.global _start
.section .text

_start:
    mov x19, #0xAB       // Número hexadecimal a convertir
    mov x20, #0          // Resultado decimal
    mov x21, #1          // Multiplicador (potencia de 16)
    mov x22, #16         // Base hexadecimal
    
convert_loop:
    // Obtener último dígito hexadecimal
    and x23, x19, #0xF   // Máscara para último dígito
    
    // Multiplicar dígito por potencia de 16
    mul x24, x23, x21    // x24 = dígito * 16^posición
    add x20, x20, x24    // Sumar al resultado
    
    // Preparar siguiente iteración
    lsr x19, x19, #4     // Desplazar para siguiente dígito
    mul x21, x21, x22    // Actualizar multiplicador (*16)
    
    // Comprobar si quedan dígitos
    cmp x19, #0
    bne convert_loop

exit:
    mov x0, #0           // Código de salida
    mov x8, #93          // Syscall exit
    svc #0

.section .data
    // No se necesitan datos
