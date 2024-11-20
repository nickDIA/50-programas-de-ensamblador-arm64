// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64
// Conversión de entero a ASCII

/*
using System;
using System.Text;

class Program
{
    static void Main()
    {
        int number = 1234;  // Número que queremos convertir
        string outputString = "Resultado: ";  // Cadena fija para mostrar antes del resultado

        // Convertimos el número a cadena usando el método personalizado intToAscii
        string resultString = intToAscii(number);

        // Mostramos el resultado completo
        Console.WriteLine(outputString + resultString);
    }

    // Función: intToAscii
    // Convierte un número entero en una cadena ASCII
    static string intToAscii(int number)
    {
        StringBuilder buffer = new StringBuilder();

        // Convierte el número a cadena al revés (mismo principio que en ensamblador)
        while (number > 0)
        {
            int remainder = number % 10;                // Obtener el último dígito
            char asciiChar = (char)('0' + remainder);   // Convertir a ASCII
            buffer.Insert(0, asciiChar);                // Insertar el carácter en el inicio
            number /= 10;                               // Reducir el número dividiéndolo entre 10
        }

        return buffer.ToString();  // Devuelve la cadena construida
    }
}
*/

.section .data
buffer:         .space 16            // Buffer para almacenar el resultado (cadena ASCII)
output_string:  .asciz "Resultado: "  // Cadena fija para mostrar antes del resultado

.section .text
.global _start

_start:
    // Inicializar el número a convertir
    mov w0, 1234                     // Número entero que queremos convertir a ASCII

    // Cargar la dirección del buffer en x1
    adrp x1, buffer                  // Cargar la página de base del buffer
    add x1, x1, :lo12:buffer         // Añadir el offset de 12 bits a la dirección base
    add x1, x1, #15                  // Apuntar al final del buffer

    // Llamar a la función int_to_ascii
    bl int_to_ascii

    // Imprimir el resultado (usando una syscall en Linux ARM64)
    mov x0, 1                        // file descriptor (stdout)
    ldr x1, =output_string           // Cargar dirección de "Resultado: "
    mov x2, 11                       // Longitud de "Resultado: "
    mov x8, 64                       // syscall write
    svc 0

    // Imprimir el resultado convertido
    mov x0, 1                        // file descriptor (stdout)
    adrp x1, buffer                  // Recargar la dirección del buffer
    add x1, x1, :lo12:buffer
    mov x2, 16                       // Supuesta longitud máxima del número (ajustar si necesario)
    mov x8, 64                       // syscall write
    svc 0

    // Salir
    mov w8, 93                       // syscall exit
    mov x0, 0
    svc 0

// Función: int_to_ascii
// Convierte un número entero en una cadena ASCII en el buffer
// Entrada: w0 -> número entero
// Salida: buffer contiene la cadena de caracteres ASCII en orden
int_to_ascii:
    mov w2, w0                       // Copiar el número a w2
    mov w3, 10                       // Valor 10 en un registro para la división

convert_loop:
    udiv w4, w2, w3                  // Dividir el número por 10 (cociente en w4)
    msub w5, w4, w3, w2              // Obtener el resto: w5 = w2 - (w4 * 10)
    add w5, w5, '0'                  // Convertir el dígito a ASCII ('0' + dígito)
    sub x1, x1, 1                    // Mover el puntero del buffer hacia atrás
    strb w5, [x1]                    // Almacenar el dígito en el buffer

    mov w2, w4                       // Actualizar el número con el cociente
    cbnz w2, convert_loop            // Repetir si el cociente no es cero

    ret
