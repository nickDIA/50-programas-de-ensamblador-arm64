// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
    using System;

class VerificadorArmstrong
{
    static void Main()
    {
        // Solicitar al usuario que ingrese un número
        Console.Write("Ingresa un número para verificar si es un número de Armstrong: ");
        int numero = Convert.ToInt32(Console.ReadLine());

        // Convertir el número a cadena para contar el número de dígitos
        int numeroOriginal = numero;
        int cantidadDeDigitos = numero.ToString().Length;
        int suma = 0;

        // Sumar los dígitos elevados a la potencia de la cantidad de dígitos
        while (numero > 0)
        {
            int digito = numero % 10; // Obtener el último dígito
            suma += (int)Math.Pow(digito, cantidadDeDigitos); // Elevarlo a la potencia de la cantidad de dígitos y sumarlo
            numero /= 10; // Eliminar el último dígito
        }

        // Verificar si el número original es igual a la suma
        if (suma == numeroOriginal)
        {
            Console.WriteLine($"{numeroOriginal} es un número de Armstrong.");
        }
        else
        {
            Console.WriteLine($"{numeroOriginal} no es un número de Armstrong.");
        }
    }
}

*/

// Verificador de números Armstrong
.global _start
.section .text

_start:
    mov x19, #153        // Número a verificar
    mov x20, x19         // Copia para procesamiento
    mov x21, #0          // Suma de cubos
    
digit_loop:
    // Obtener último dígito
    mov x22, #10
    udiv x23, x20, x22           // x23 = x20 / 10
    msub x24, x23, x22, x20      // x24 = x20 - (x23 * 10) [dígito]
    
    // Calcular cubo del dígito
    mul x25, x24, x24            // x25 = dígito * dígito
    mul x25, x25, x24            // x25 = x25 * dígito (cubo)
    
    // Sumar al total
    add x21, x21, x25
    
    // Preparar siguiente dígito
    mov x20, x23                 // x20 = x20 / 10
    
    // Continuar si quedan dígitos
    cbnz x20, digit_loop
    
    // Verificar si es número Armstrong
    cmp x19, x21
    beq is_armstrong
    
not_armstrong:
    mov x0, #1                   // No es Armstrong
    b exit
    
is_armstrong:
    mov x0, #0                   // Es Armstrong

exit:
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
