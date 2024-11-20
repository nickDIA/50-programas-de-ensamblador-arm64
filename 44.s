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

.arch armv8-a
.global main

// Sección de datos
.data
.align 4
multiplier:  .word 1664525
increment:   .word 1013904223
seed:        .word 12345
msg:         .asciz "Numero generado: "
newline:     .asciz "\n"
buffer:      .skip 16           // Buffer para la conversión de números

// Sección de código
.text
.align 2

// Función principal
main:
    // Guardar registros
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Cargar valores iniciales
    adrp    x0, seed           // Cargar página de memoria de seed
    add     x0, x0, :lo12:seed // Ajustar offset
    ldr     w1, [x0]           // w1 = valor semilla
    
    adrp    x2, multiplier
    add     x2, x2, :lo12:multiplier
    ldr     w2, [x2]           // w2 = multiplicador
    
    adrp    x3, increment
    add     x3, x3, :lo12:increment
    ldr     w3, [x3]           // w3 = incremento

    // Generar número aleatorio
    mul     w1, w1, w2         // w1 = seed * multiplier
    add     w1, w1, w3         // w1 = (seed * multiplier) + increment
    
    // Guardar nueva semilla
    str     w1, [x0]

    // Imprimir mensaje
    adrp    x0, msg
    add     x0, x0, :lo12:msg
    bl      printf

    // Imprimir número
    mov     w0, w1
    bl      print_number

    // Imprimir nueva línea
    adrp    x0, newline
    add     x0, x0, :lo12:newline
    bl      printf

    // Restaurar y retornar
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

// Función para imprimir número
print_number:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Preparar buffer
    adrp    x3, buffer
    add     x3, x3, :lo12:buffer
    mov     x4, x3              // Guardar inicio del buffer
    mov     w5, w0              // Número a convertir

convert:
    // División por 10
    mov     w6, #10
    udiv    w7, w5, w6          // w7 = número / 10
    msub    w8, w7, w6, w5      // w8 = número % 10
    
    // Convertir a ASCII y guardar
    add     w8, w8, #'0'        // Convertir a ASCII
    strb    w8, [x3], #1        // Guardar y avanzar puntero
    
    // Siguiente dígito
    mov     w5, w7              // Preparar siguiente número
    cbnz    w5, convert         // Continuar si no es cero

    // Terminar string
    mov     w8, #0
    strb    w8, [x3]            // Agregar null terminator

    // Revertir string
    sub     x3, x3, #1          // Apuntar al último caracter
reverse:
    cmp     x4, x3
    bge     print
    ldrb    w5, [x4]
    ldrb    w6, [x3]
    strb    w6, [x4]
    strb    w5, [x3]
    add     x4, x4, #1
    sub     x3, x3, #1
    b       reverse

print:
    // Imprimir número usando printf
    adrp    x0, buffer
    add     x0, x0, :lo12:buffer
    bl      printf

    // Retornar
    ldp     x29, x30, [sp], 16
    ret

.section .note.GNU-stack, "", @progbits
