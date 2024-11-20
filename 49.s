// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/* 
using System;

class LectorTeclado
{
    static void Main()
    {
        // Leer una línea completa de texto
        Console.Write("Ingresa tu nombre: ");
        string nombre = Console.ReadLine();

        Console.WriteLine($"Hola, {nombre}!");
    }
}

*/

// Lector de entrada desde teclado
.global _start
.section .text

_start:
    // Reservar espacio en el stack para buffer
    sub sp, sp, #16
    
    // Leer entrada
    mov x0, #0              // stdin
    mov x1, sp             // Buffer en stack
    mov x2, #16            // Tamaño máximo a leer
    mov x8, #63            // syscall read
    svc #0
    
    // x0 contiene número de bytes leídos
    
    // Restaurar stack
    add sp, sp, #16

exit:
    mov x8, #93            // syscall exit
    svc #0

.section .data
    // No se necesitan datos
