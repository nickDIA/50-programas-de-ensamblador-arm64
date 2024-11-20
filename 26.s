// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

// Operaciones AND, OR, XOR a nivel de bits

/*
using System;

class Program
{
    static void Main()
    {
        // Valores iniciales (en hexadecimal)
        ulong value1 = 0xF0F0F0F0F0F0F0F0;
        ulong value2 = 0x0F0F0F0F0F0F0F0F;

        // Operación AND
        ulong resultAnd = value1 & value2;
        
        // Operación OR
        ulong resultOr = value1 | value2;
        
        // Operación XOR
        ulong resultXor = value1 ^ value2;

        // Imprimir los resultados
        Console.WriteLine("Resultado de AND: 0x" + resultAnd.ToString("X16"));
        Console.WriteLine("Resultado de OR:  0x" + resultOr.ToString("X16"));
        Console.WriteLine("Resultado de XOR: 0x" + resultXor.ToString("X16"));
    }
}
*/
.global _start

.section .data
value1: .quad 0xF0F0F0F0F0F0F0F0  // Primer valor: 0xF0F0F0F0F0F0F0F0
value2: .quad 0x0F0F0F0F0F0F0F0F  // Segundo valor: 0x0F0F0F0F0F0F0F0F

.section .text
_start:

    // Cargar los dos valores de la memoria en los registros x0 y x1
    ldr x0, =value1             // Cargar la dirección de value1
    ldr x0, [x0]                // Cargar el valor en x0
    ldr x1, =value2             // Cargar la dirección de value2
    ldr x1, [x1]                // Cargar el valor en x1

    // Operación AND
    and x2, x0, x1              // x2 = x0 AND x1

    // Operación OR
    orr x3, x0, x1              // x3 = x0 OR x1

    // Operación XOR
    eor x4, x0, x1              // x4 = x0 XOR x1

    // Salir del programa
    mov x8, 93                  // Syscall para salir
    mov x0, 0                   // Código de salida
    svc 0                        // Llamada al sistema (exit)
