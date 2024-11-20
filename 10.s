// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

// using System;
// using System.Text;

// class Program
// {
//     static void Main(string[] args)
//     {
//         const string cadenaOriginal = "Hola mundo! Esta es una prueba de inversión.";
        
//         // Método 1: Usando Array.Reverse
//         char[] caracteres = cadenaOriginal.ToCharArray();
//         Array.Reverse(caracteres);
//         string resultado1 = new string(caracteres);
//         Console.WriteLine($"Método 1 (Array.Reverse): {resultado1}");

//         // Método 2: Usando StringBuilder
//         StringBuilder sb = new StringBuilder(cadenaOriginal.Length);
//         for (int i = cadenaOriginal.Length - 1; i >= 0; i--)
//         {
//             sb.Append(cadenaOriginal[i]);
//         }
//         string resultado2 = sb.ToString();
//         Console.WriteLine($"Método 2 (StringBuilder): {resultado2}");

//         // Método 3: LINQ (menos eficiente pero más conciso)
//         string resultado3 = new string(cadenaOriginal.Reverse().ToArray());
//         Console.WriteLine($"Método 3 (LINQ): {resultado3}");
        
//         // Método 4: Recursivo (para cadenas pequeñas)
//         static string InvertirRecursivo(string str)
//         {
//             if (string.IsNullOrEmpty(str) || str.Length <= 1)
//                 return str;
                
//             return str[^1] + InvertirRecursivo(str[..^1]);
//         }
        
//         string resultado4 = InvertirRecursivo(cadenaOriginal);
//         Console.WriteLine($"Método 4 (Recursivo): {resultado4}");
//     }
// }

// Programa en ensamblador ARM de 64 bits para invertir una cadena fija
// Guardar este archivo como invertir.s y compilar con:
// $ as -o invertir.o invertir.s
// $ ld -o invertir invertir.o
// Ejecutar con:
// $ ./invertir

.section .data
cadena: .asciz "hello"              // Cadena original que queremos invertir

.section .text
    .global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =cadena                 // x0 apunta al inicio de la cadena
    mov x1, x0                      // Copia de la dirección de inicio para contar

    // Encontrar la longitud de la cadena
    mov x2, 0                       // Contador de longitud
find_length:
    ldrb w3, [x1], 1                // Cargar byte de la cadena y avanzar
    cbz w3, start_reverse           // Si encontramos el nulo ('\0'), iniciar inversión
    add x2, x2, 1                   // Incrementar contador
    b find_length                   // Repetir hasta encontrar el final

start_reverse:
    sub x2, x2, 1                   // Ajustar longitud para el último carácter (ignorar '\0')
    mov x3, x2                      // Guardar la longitud en x3 como índice final

reverse_loop:
    // Terminar si los índices se cruzan
    cmp x0, x1                      // Comparar el inicio y el final
    bge end_reverse                 // Si se cruzan, fin de la inversión

    // Intercambiar caracteres
    ldrb w4, [x0]                   // Cargar byte del inicio
    ldrb w5, [x1]                   // Cargar byte del final
    strb w4, [x1]                   // Almacenar byte inicial en la posición final
    strb w5, [x0]                   // Almacenar byte final en la posición inicial

    // Mover índices
    add x0, x0, 1                   // Avanzar al siguiente carácter desde el inicio
    sub x1, x1, 1                   // Retroceder al siguiente carácter desde el final
    b reverse_loop                  // Repetir hasta que los índices se crucen

end_reverse:
    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    mov x0, 0                       // Código de salida
    svc 0                           // Llamada al sistema
