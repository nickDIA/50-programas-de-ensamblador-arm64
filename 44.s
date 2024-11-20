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

// Generador de números pseudoaleatorios con semilla
.global _start
.section .text

_start:
    // Inicializar generador
    mov x19, #12345      // Semilla inicial
    mov x20, #1103515245 // Multiplicador (constante)
    mov x21, #12345      // Incremento (constante)
    mov x22, #10         // Cantidad de números a generar
    
generate_loop:
    // Fórmula: siguiente = (semilla * multiplicador + incremento) & máscara
    mul x19, x19, x20            // x19 = semilla * multiplicador
    add x19, x19, x21            // x19 += incremento
    and x19, x19, #0x7fffffff    // Mantener 31 bits (máscara)
    
    // El número aleatorio está en x19
    
    // Preparar siguiente iteración
    sub x22, x22, #1             // Decrementar contador
    cbnz x22, generate_loop      // Continuar si no hemos terminado

exit:
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
