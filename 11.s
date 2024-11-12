// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

//Versión en C# equivalente:
//using System;
//
//class Program
//{
//    static bool IsPalindrome(string input)
//    {
//        int start = 0;
//        int end = input.Length - 1;
//
//        while (start < end)
//        {
//            if (input[start] != input[end])
//            {
//                return false;
//            }
//            start++;
//            end--;
//        }
//        return true;
//    }
//
//    static void Main(string[] args)
//    {
//        string inputString = "radar";
//
//        if (IsPalindrome(inputString))
//        {
//            Console.WriteLine("Es un palindromo");
//        }
//        else
//        {
//            Console.WriteLine("No es un palindromo");
//        }
//    }
//}

//si imprime el valor

.section .data
input_string: .asciz "radar"         // Cadena de ejemplo
len:          .quad 5                // Longitud de la cadena (sin el null terminador)
result_msg:   .asciz "Es un palindromo\n"
not_msg:      .asciz "No es un palindromo\n"

.section .text
.global _start

_start:
    // Cargar dirección de la cadena y su longitud
    ldr x0, =input_string           // x0 apunta al inicio de la cadena
    ldr x1, =len                    // x1 guarda la longitud de la cadena
    ldr x1, [x1]                    // Obtener el valor de la longitud de la cadena
    sub x1, x1, #1                  // Reducir longitud en 1 para la comparación (ignorar null terminador)

    // Configurar punteros de inicio y fin de la cadena
    mov x2, x0                      // x2 es el puntero al inicio
    add x3, x0, x1                  // x3 es el puntero al final (inicio + longitud - 1)

check_palindrome:
    // Si los punteros se cruzan o se encuentran, la cadena es un palíndromo
    cmp x2, x3
    bge is_palindrome               // Saltar si x2 >= x3 (la cadena es un palíndromo)

    // Comparar caracteres en el inicio y el final
    ldrb w4, [x2]                   // Cargar el carácter en el puntero de inicio
    ldrb w5, [x3]                   // Cargar el carácter en el puntero de fin
    cmp w4, w5                      // Comparar los caracteres
    bne not_palindrome              // Saltar si los caracteres no coinciden

    // Avanzar los punteros hacia el centro
    add x2, x2, #1                  // Mover puntero de inicio hacia adelante
    sub x3, x3, #1                  // Mover puntero de fin hacia atrás
    b check_palindrome              // Repetir hasta que se crucen los punteros

is_palindrome:
    // Imprimir mensaje de que es palíndromo
    ldr x0, =result_msg
    bl print_string
    b exit_program

not_palindrome:
    // Imprimir mensaje de que no es palíndromo
    ldr x0, =not_msg
    bl print_string

exit_program:
    // Salir del programa
    mov x8, #93                     // syscall: exit
    mov x0, #0                      // Código de salida
    svc #0

print_string:
    // syscall: write(1, x0, longitud de la cadena)
    mov x1, x0                      // x1 apunta al mensaje a imprimir
    mov x2, #17                     // Longitud estimada del mensaje
    mov x0, #1                      // File descriptor (1 = salida estándar)
    mov x8, #64                     // syscall: write
    svc #0
    ret
