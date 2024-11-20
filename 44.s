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

.globl main
.align 2

// Constantes para el algoritmo LCG
.data
multiplier:  .word 1664525
increment:   .word 1013904223
seed:        .word 12345         // Semilla inicial
msg:         .ascii "Numero generado: "
msglen = . - msg
newline:     .ascii "\n"
buffer:      .skip 12           // Buffer para conversión de números

.text
.align 2
main:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Cargar la semilla inicial
    adr x0, seed
    ldr w1, [x0]           // w1 = semilla actual

    // Cargar constantes
    adr x0, multiplier
    ldr w2, [x0]           // w2 = multiplier
    adr x0, increment
    ldr w3, [x0]           // w3 = increment

generate_number:
    // Implementar LCG: next = (multiplier * seed + increment) % 2^32
    mul w1, w1, w2         // w1 = seed * multiplier
    add w1, w1, w3         // w1 = w1 + increment
    
    // Guardar el nuevo valor como siguiente semilla
    adr x0, seed
    str w1, [x0]
    
    // Imprimir mensaje
    mov x0, #1              // fd = 1 (stdout)
    adr x1, msg            // buffer = dirección del mensaje
    mov x2, msglen         // length = longitud del mensaje
    mov x8, #64            // syscall write
    svc #0
    
    // Convertir número a string
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
    ldp x29, x30, [sp], #16
    ret

// Subrutina para convertir número a string y mostrarlo
number_to_string:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Preparar buffer
    adr x3, buffer         // x3 = puntero al buffer
    mov x4, x3             // Guardar inicio del buffer
    mov w5, w0             // Copiar número a convertir
    
convert_loop:
    // Dividir por 10
    mov w6, #10
    udiv w7, w5, w6        // w7 = w5 / 10
    msub w8, w7, w6, w5    // w8 = remainder
    
    // Convertir dígito a ASCII y guardarlo
    add w8, w8, #48        // Convertir a ASCII
    strb w8, [x3], #1      // Guardar y avanzar puntero
    
    // Preparar siguiente iteración
    mov w5, w7             // Actualizar número
    cbnz w5, convert_loop  // Continuar si no es cero
    
    // Revertir los dígitos en el buffer
    sub x3, x3, #1         // Apuntar al último dígito
reverse_loop:
    cmp x4, x3
    bge print_number
    ldrb w5, [x4]
    ldrb w6, [x3]
    strb w6, [x4]
    strb w5, [x3]
    add x4, x4, #1
    sub x3, x3, #1
    b reverse_loop
    
print_number:
    // Calcular longitud e imprimir
    adr x1, buffer         // Dirección del buffer
    sub x2, x3, x1         // Longitud = final - inicio
    add x2, x2, #1         // Ajustar longitud
    mov x0, #1             // fd = stdout
    mov x8, #64            // syscall write
    svc #0
    
    // Restaurar y retornar
    ldp x29, x30, [sp], #16
    ret
