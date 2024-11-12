// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
using System;

class Program
{
    public static void Main(string[] args)
    {
        string inputString = "1234";  // Ejemplo de cadena ASCII de entrada
        int result = AsciiToInt(inputString);  // Llamada a la función de conversión
        
        Console.WriteLine($"La cadena '{inputString}' convertida a entero es: {result}");
    }

    // Función para convertir una cadena ASCII a un entero
    public static int AsciiToInt(string asciiString)
    {
        int result = 0;
        foreach (char c in asciiString)
        {
            // Restar el valor ASCII de '0' para obtener el valor numérico
            int digit = c - '0';
            
            // Multiplicar el resultado actual por 10 y agregar el dígito actual
            result = result * 10 + digit;
        }
        return result;
    }
}
*/

.section .data
input_string:   .asciz "1234"     // Cadena de entrada en ASCII
result:         .word 0           // Variable para almacenar el resultado

.section .text
.global _start

_start:
    // Cargar la dirección de la cadena de entrada en x0
    ldr x0, =input_string

    // Llamar a la función ascii_to_int
    bl ascii_to_int

    // Guardar el resultado en memoria
    ldr x1, =result
    str w0, [x1]                 // Almacena el valor en 'result'

    // Salir
    mov w8, 93                   // syscall exit
    mov x0, 0
    svc 0

// Función: ascii_to_int
// Convierte una cadena ASCII a un número entero
// Entrada: x0 -> dirección de la cadena ASCII
// Salida: w0 -> valor entero
ascii_to_int:
    mov w1, 0                    // Inicializar el acumulador (resultado) en w1
    mov w3, 10                   // Cargar el valor 10 en el registro w3

ascii_to_int_loop:
    ldrb w2, [x0], #1            // Cargar el siguiente byte (carácter ASCII) y avanzar el puntero
    cmp w2, #0                   // Verificar si llegamos al final de la cadena (byte nulo)
    beq ascii_to_int_end         // Si es el final, salir del bucle

    sub w2, w2, #'0'             // Convertir ASCII a valor numérico restando '0'
    mul w1, w1, w3               // Multiplicar el acumulador por 10 usando w3
    add w1, w1, w2               // Sumar el dígito actual al acumulador

    b ascii_to_int_loop          // Repetir para el siguiente dígito

ascii_to_int_end:
    mov w0, w1                   // Mover el resultado a w0 para el retorno
    ret
