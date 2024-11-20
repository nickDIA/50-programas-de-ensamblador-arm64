// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
    using System;

class Calculadora
{
    static void Main()
    {
        double num1, num2, resultado;
        string operacion;

        Console.WriteLine("Calculadora simple");
        
        // Ingresar el primer número
        Console.Write("Ingresa el primer número: ");
        num1 = Convert.ToDouble(Console.ReadLine());

        // Ingresar la operación
        Console.Write("Ingresa la operación (+, -, *, /): ");
        operacion = Console.ReadLine();

        // Ingresar el segundo número
        Console.Write("Ingresa el segundo número: ");
        num2 = Convert.ToDouble(Console.ReadLine());

        // Realizar la operación según la elección del usuario
        switch (operacion)
        {
            case "+":
                resultado = num1 + num2;
                Console.WriteLine($"Resultado: {num1} + {num2} = {resultado}");
                break;

            case "-":
                resultado = num1 - num2;
                Console.WriteLine($"Resultado: {num1} - {num2} = {resultado}");
                break;

            case "*":
                resultado = num1 * num2;
                Console.WriteLine($"Resultado: {num1} * {num2} = {resultado}");
                break;

            case "/":
                if (num2 != 0)
                {
                    resultado = num1 / num2;
                    Console.WriteLine($"Resultado: {num1} / {num2} = {resultado}");
                }
                else
                {
                    Console.WriteLine("Error: No se puede dividir entre cero.");
                }
                break;

            default:
                Console.WriteLine("Operación no válida.");
                break;
        }
    }
}

*/

// Calculadora simple (suma, resta, multiplicación, división)
.global _start
.section .text

_start:
    // Valores de ejemplo
    mov x19, #25         // Primer número
    mov x20, #5          // Segundo número
    
    // Suma
    add x21, x19, x20    // x21 = x19 + x20
    
    // Resta
    sub x22, x19, x20    // x22 = x19 - x20
    
    // Multiplicación
    mul x23, x19, x20    // x23 = x19 * x20
    
    // División
    udiv x24, x19, x20   // x24 = x19 / x20
    
    // Obtener resto de división
    msub x25, x24, x20, x19  // x25 = x19 - (x24 * x20)

    // Manejo de división por cero
    cbz x20, division_error
    
    b exit

division_error:
    mov x24, #-1         // Indicador de error
    mov x25, #-1

exit:
    mov x0, #0
    mov x8, #93
    svc #0

.section .data
    // No se necesitan datos
