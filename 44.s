// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
    using System;

class GeneradorAleatorio
{
    static void Main()
    {
        // Solicitar al usuario que ingrese una semilla
        Console.Write("Ingresa una semilla para el generador de números aleatorios: ");
        int semilla = Convert.ToInt32(Console.ReadLine());

        // Crear una instancia de Random utilizando la semilla
        Random random = new Random(semilla);

        // Generar algunos números aleatorios
        Console.WriteLine("Generando 5 números aleatorios:");
        for (int i = 0; i < 5; i++)
        {
            int numeroAleatorio = random.Next();
            Console.WriteLine(numeroAleatorio);
        }
    }
}

*/

.global _start
.align 2

// Constantes para el algoritmo LCG
// Usando los parámetros de "Numerical Recipes"
.equ MULTIPLIER, 1664525
.equ INCREMENT, 1013904223
.equ MODULUS, 0xFFFFFFFF    // 2^32 - 1

.data
seed:   .word 12345         // Semilla inicial
msg:    .ascii "Número generado: "
msglen = . - msg
newline:.ascii "\n"

.text
_start:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Cargar la semilla inicial
    adr x0, seed
    ldr w1, [x0]           // w1 = semilla actual

generate_number:
    // Implementar la fórmula LCG:
    // next = (multiplier * seed + increment) % modulus
    
    // Multiplicación
    mov w2, #MULTIPLIER
    mul w1, w1, w2
    
    // Suma del incremento
    mov w2, #INCREMENT
    add w1, w1, w2
    
    // El módulo es implícito por el uso de registros de 32 bits
    
    // Guardar el nuevo valor como siguiente semilla
    adr x0, seed
    str w1, [x0]
    
    // Imprimir mensaje
    mov x0, #1              // fd = 1 (stdout)
    adr x1, msg            // buffer = dirección del mensaje
    mov x2, #msglen        // length = longitud del mensaje
    mov x8, #64            // syscall write
    svc #0
    
    // Convertir número a string y mostrar
    mov w0, w1             // Número a convertir
    bl number_to_string
    
    // Imprimir nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Salir del programa
    mov x0, #0
    mov x8, #93            // syscall exit
    svc #0

// Subrutina para convertir número a string y mostrarlo
number_to_string:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Reservar espacio para el string (12 caracteres son suficientes para 32 bits)
    sub sp, sp, #16
    mov x3, sp             // x3 = puntero al buffer
    
    // Convertir número a ASCII
    mov x2, #10            // Base 10
    mov w4, w0             // Copiar número
    
convert_loop:
    udiv w5, w4, w2        // w5 = w4 / 10
    msub w6, w5, w2, w4    // w6 = w4 - (w5 * 10) = residuo
    add w6, w6, #'0'       // Convertir a ASCII
    strb w6, [x3], #1      // Almacenar y avanzar puntero
    mov w4, w5             // Preparar para siguiente iteración
    cbnz w4, convert_loop  // Continuar si no es cero
    
    // Imprimir el número
    mov x0, #1             // fd = 1 (stdout)
    mov x1, sp             // buffer = inicio del número
    sub x2, x3, sp        // length = longitud del número
    mov x8, #64            // syscall write
    svc #0
    
    // Restaurar stack y registros
    add sp, sp, #16
    ldp x29, x30, [sp], #16
    ret
