// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

// Calcular la longitud de una cadena

/*
using System;

class Program
{
    static void Main()
    {
        string inputString = "Cadena a Medir";  // Cadena de entrada

        // Llamar a la función personalizada strlen para calcular la longitud de la cadena
        int length = Strlen(inputString);

        // Imprimir la longitud de la cadena
        Console.WriteLine("Longitud de la cadena: " + length);
    }

    // Función: Strlen
    // Calcula la longitud de una cadena terminada en nulo (sin contar el '\0')
    static int Strlen(string str)
    {
        int length = 0;

        // Recorre cada carácter de la cadena hasta llegar al final
        foreach (char c in str)
        {
            if (c == '\0')   // Verificar si es el carácter nulo (aunque en C# no suele usarse)
                break;
            length++;
        }

        return length;
    }
}
*/
.section .data
input_string:   .asciz "Cadena a Medir"   // Cadena de entrada (terminada en '\0')

.section .text
.global _start

_start:
    // Cargar la dirección de la cadena de entrada en x0
    ldr x0, =input_string

    // Llamar a la función strlen
    bl strlen

    // El resultado de la longitud de la cadena está ahora en w0
    // Guardar la longitud en un registro de 32 bits (para imprimir)
    mov w1, w0                   // Mover el resultado de la longitud a w1 (32 bits)

    // Imprimir la longitud de la cadena (usando una syscall en Linux ARM64)
    mov x0, 1                    // file descriptor (stdout)
    mov x2, 1                    // Longitud del número a imprimir (asumimos que es 1 dígito)
    mov x8, 64                   // syscall write
    svc 0

    // Salir
    mov w8, 93                   // syscall exit
    mov x0, 0                    // Código de salida
    svc 0

// Función: strlen
// Calcula la longitud de una cadena terminada en nulo
// Entrada: x0 -> dirección de la cadena
// Salida: w0 -> longitud de la cadena (sin contar el '\0')
strlen:
    mov w1, 0                    // Inicializamos el contador de longitud en 0

strlen_loop:
    ldrb w2, [x0], #1            // Cargar el siguiente byte (carácter) y avanzar el puntero
    cmp w2, #0                   // Comprobar si es el byte nulo (fin de la cadena)
    beq strlen_end               // Si es el fin de la cadena, salir del bucle
    add w1, w1, #1                // Incrementar el contador de longitud
    b strlen_loop                // Repetir el bucle

strlen_end:
    mov w0, w1                   // Mover el contador de longitud a w0 (para el retorno)
    ret
