// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: https://github.com/nickDIA/50-programas-de-ensamblador-arm64

/*
  using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Conversión de binario a decimal");

        // Solicitar al usuario un número binario
        Console.Write("Ingresa un número binario: ");
        string inputBinario = Console.ReadLine();

        // Validar si el número binario es válido
        if (EsBinarioValido(inputBinario))
        {
            int numeroDecimal = ConvertirBinarioADecimal(inputBinario);
            Console.WriteLine($"El número binario {inputBinario} en decimal es: {numeroDecimal}");
        }
        else
        {
            Console.WriteLine("El número ingresado no es un binario válido.");
        }
    }

    // Verificar si el número ingresado es un número binario válido
    static bool EsBinarioValido(string binario)
    {
        foreach (char c in binario)
        {
            if (c != '0' && c != '1')
            {
                return false; // Si contiene un carácter distinto a '0' o '1', no es binario
            }
        }
        return true;
    }

    // Convertir el número binario a decimal
    static int ConvertirBinarioADecimal(string binario)
    {
        int numeroDecimal = 0;
        int potencia = 0;

        // Recorremos el número binario de derecha a izquierda
        for (int i = binario.Length - 1; i >= 0; i--)
        {
            if (binario[i] == '1')
            {
                numeroDecimal += (int)Math.Pow(2, potencia); // Sumar el valor correspondiente en base 2
            }
            potencia++;
        }

        return numeroDecimal;
    }
}

*/

// Programa para convertir número binario a decimal
.global _start
.section .text

_start:
    // Inicializamos registros
    mov x19, #0          // x19 = Resultado decimal
    mov x20, #0b1101     // x20 = Número binario a convertir (ejemplo: 1101 = 13)
    mov x21, #0          // x21 = Contador de posición
    mov x22, #2          // x22 = Base (binario = 2)

convert_loop:
    // Obtener el bit menos significativo
    and x23, x20, #1     // x23 = último bit del número
    
    // Calcular el valor posicional (2^posición * bit)
    mov x24, #1          // x24 = 2^posición
    mov x25, x21         // x25 = contador temporal para potencia
power_loop:
    cbz x25, power_done  // Si contador es 0, salir del loop
    mul x24, x24, x22    // x24 = x24 * 2
    sub x25, x25, #1     // Decrementar contador
    b power_loop
power_done:
    
    // Multiplicar bit por su valor posicional
    mul x23, x23, x24    // x23 = bit * 2^posición
    
    // Sumar al resultado
    add x19, x19, x23    // Resultado += valor calculado
    
    // Preparar siguiente iteración
    lsr x20, x20, #1     // Desplazar número a la derecha
    add x21, x21, #1     // Incrementar posición
    
    // Comprobar si quedan bits
    cmp x20, #0          // ¿Quedan bits por procesar?
    bne convert_loop     // Si quedan bits, continuar loop

    // En este punto, x19 contiene el resultado decimal

exit:
    // Salir del programa
    mov x0, #0           // Código de salida 0
    mov x8, #93          // Syscall exit
    svc #0

.section .data
    // No se necesitan datos en este ejemplo
