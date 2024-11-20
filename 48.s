// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/* 
using System;
using System.Diagnostics;

class MedidorTiempo
{
    static void Main()
    {
        // Crear una instancia de Stopwatch
        Stopwatch stopwatch = new Stopwatch();

        // Iniciar el cronómetro
        stopwatch.Start();

        // El bloque de código cuyo tiempo de ejecución queremos medir
        Console.WriteLine("Ejecutando tarea...");
        
        // Simulación de tarea que tarda 2 segundos
        System.Threading.Thread.Sleep(2000);  // Simula una tarea que toma 2 segundos

        // Detener el cronómetro
        stopwatch.Stop();

        // Mostrar el tiempo transcurrido
        Console.WriteLine($"El tiempo de ejecución fue: {stopwatch.ElapsedMilliseconds} milisegundos");
    }
}

*/

// Medidor de tiempo de ejecución
.global _start
.section .text

_start:
    // Obtener tiempo inicial
    mrs x19, CNTVCT_EL0          // Contador de tiempo inicial
    
    // Código a medir (ejemplo: loop simple)
    mov x22, #1000
time_loop:
    sub x22, x22, #1
    cbnz x22, time_loop
    
    // Obtener tiempo final
    mrs x20, CNTVCT_EL0          // Contador de tiempo final
    
    // Calcular diferencia
    sub x21, x20, x19            // x21 = tiempo transcurrido

exit:
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
